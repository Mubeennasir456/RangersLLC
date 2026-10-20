<?php
require dirname(__DIR__).'/config/bootstrap.php';
try {
 $path=trim(parse_url($_SERVER['REQUEST_URI'],PHP_URL_PATH),'/');$pos=strpos($path,'api/');$path=$pos===false?'':substr($path,$pos+4);$method=$_SERVER['REQUEST_METHOD'];
 if($path==='admin/login' && $method==='POST') {
  $d=body();$email=val($d,'email',190);$ip=hash('sha256',($_SERVER['REMOTE_ADDR']??'unknown'));$count=one('SELECT COUNT(*) n FROM login_attempts WHERE ip_hash=? AND created_at>NOW()-INTERVAL 15 MINUTE',[$ip])['n'];
  if($count>=8)json_out(['error'=>'Too many attempts; try later'],429);
  $a=one('SELECT * FROM admins WHERE email=? AND status="active"',[$email]);
  if(!$a||!password_verify((string)($d['password']??''),$a['password_hash'])) {execute_sql('INSERT INTO login_attempts(ip_hash) VALUES(?)',[$ip]);json_out(['error'=>'Invalid credentials'],401);}
  execute_sql('DELETE FROM login_attempts WHERE ip_hash=?',[$ip]);session_regenerate_id(true);$_SESSION['admin_id']=$a['id'];$_SESSION['last_activity']=time();json_out(['ok'=>true,'name'=>$a['name'],'csrf'=>csrf()]);
 }
 if($path==='admin/session' && $method==='GET'){require_auth();json_out(['ok'=>true,'csrf'=>csrf(),'admin_id'=>$_SESSION['admin_id']]);}
 if(str_starts_with($path,'admin/')) {require_auth();if($method!=='GET')check_csrf();}
 if($path==='admin/logout' && $method==='POST'){$_SESSION=[];session_destroy();json_out(['ok'=>true]);}
 if($path==='admin/catalogue/report' && $method==='GET'){
  $catalogueFile=dirname(__DIR__).'/storage/catalogues/rangers-products.json';
  if(!is_readable($catalogueFile))json_out(['error'=>'Catalogue data file is unavailable'],500);
  try{$catalogue=json_decode(file_get_contents($catalogueFile),true,512,JSON_THROW_ON_ERROR);}catch(Throwable $e){error_log('Catalogue JSON could not be read: '.$e->getMessage());json_out(['error'=>'Catalogue data file is invalid'],500);}
  if(!is_array($catalogue)||!isset($catalogue['products'])||!is_array($catalogue['products']))json_out(['error'=>'Catalogue data file has an invalid structure'],500);
  $existing=rows('SELECT id,specifications FROM products');$knownSkus=[];
  foreach($existing as $item){$rawSpec=trim((string)($item['specifications']??''));if($rawSpec==='')continue;$spec=json_decode($rawSpec,true);if(json_last_error()!==JSON_ERROR_NONE)json_out(['error'=>'Cannot safely check duplicate SKUs because an existing product has invalid specifications JSON'],409);$sku=$spec['sku']??null;if(is_string($sku)&&$sku!=='')$knownSkus[strtoupper($sku)]=true;}
  $duplicates=0;$review=0;
  foreach($catalogue['products'] as $product){$sku=(string)($product['specifications']['sku']??'');if($sku!==''&&isset($knownSkus[strtoupper($sku)]))$duplicates++;if(!empty($product['manual_review']))$review++;}
  json_out(['source_pdf'=>$catalogue['source_pdf']??'','detected'=>count($catalogue['products']),'already_imported'=>$duplicates,'pending'=>count($catalogue['products'])-$duplicates,'manual_review'=>$review,'duplicate_policy'=>'skip existing SKU; never overwrite existing product records']);
 }
 if($path==='admin/catalogue/import' && $method==='POST'){
  body();
  $catalogueFile=dirname(__DIR__).'/storage/catalogues/rangers-products.json';
  if(!is_readable($catalogueFile))json_out(['error'=>'Catalogue data file is unavailable'],500);
  try{$catalogue=json_decode(file_get_contents($catalogueFile),true,512,JSON_THROW_ON_ERROR);}catch(Throwable $e){error_log('Catalogue JSON could not be read: '.$e->getMessage());json_out(['error'=>'Catalogue data file is invalid'],500);}
  if(!is_array($catalogue)||!isset($catalogue['products'])||!is_array($catalogue['products']))json_out(['error'=>'Catalogue data file has an invalid structure'],500);
  $existing=rows('SELECT id,name,slug,specifications FROM products');$knownSkus=[];$usedSlugs=[];
  foreach($existing as $item){
   $usedSlugs[strtolower((string)$item['slug'])]=true;
   $rawSpec=trim((string)($item['specifications']??''));if($rawSpec==='')continue;
   $spec=json_decode($rawSpec,true);
   if(json_last_error()!==JSON_ERROR_NONE)json_out(['error'=>'Cannot safely check duplicate SKUs because an existing product has invalid specifications JSON'],409);
   $sku=$spec['sku']??null;if(is_string($sku)&&$sku!=='')$knownSkus[strtoupper($sku)]=true;
  }
  $sourceSkus=[];$valid=[];$errors=[];$skipped=0;$manualReview=0;$outcomes=[];
  foreach($catalogue['products'] as $index=>$product){
   if(!is_array($product)){$errors[]=['record'=>$index+1,'error'=>'Product entry must be an object'];continue;}
   $spec=$product['specifications']??null;$sku=is_array($spec)?trim((string)($spec['sku']??'')):'';
   if(!empty($product['manual_review']))$manualReview++;
   $missing=[];foreach(['name','slug','category','short_description','full_description','image_path'] as $required){if(trim((string)($product[$required]??''))==='')$missing[]=$required;}
   if($sku==='')$missing[]='specifications.sku';
   if(!is_array($spec))$missing[]='specifications';
   if($missing){$errors[]=['record'=>$index+1,'sku'=>$sku,'error'=>'Missing or invalid fields: '.implode(', ',$missing)];if($sku!=='')$outcomes[strtoupper($sku)]='failed_validation';continue;}
   if(strlen((string)$product['name'])>255||strlen((string)$product['category'])>190||strlen((string)$product['full_description'])>60000){$errors[]=['record'=>$index+1,'sku'=>$sku,'error'=>'Field exceeds the database length limit'];$outcomes[strtoupper($sku)]='failed_validation';continue;}
   $skuKey=strtoupper($sku);
   if(isset($sourceSkus[$skuKey])){$errors[]=['record'=>$index+1,'sku'=>$sku,'error'=>'Duplicate SKU in source catalogue'];$outcomes[$skuKey]='failed_validation';continue;}
   $sourceSkus[$skuKey]=true;
   if(isset($knownSkus[$skuKey])){$skipped++;$outcomes[$skuKey]='skipped_duplicate';continue;}
   $imagePath=trim((string)$product['image_path']);
   if(!preg_match('~^storage/uploads/catalogue/[a-z0-9-]+\.png$~D',$imagePath)){$errors[]=['record'=>$index+1,'sku'=>$sku,'error'=>'Image path is invalid'];$outcomes[$skuKey]='failed_validation';continue;}
   $twoKPath=substr($imagePath,0,-4).'-2k.png';
   $highResolutionPath=substr($imagePath,0,-4).'-hd.png';
   if(is_file(dirname(__DIR__).'/'.str_replace('/',DIRECTORY_SEPARATOR,$twoKPath)))$imagePath=$twoKPath;
   elseif(is_file(dirname(__DIR__).'/'.str_replace('/',DIRECTORY_SEPARATOR,$highResolutionPath)))$imagePath=$highResolutionPath;
   $imageFile=dirname(__DIR__).'/'.str_replace('/',DIRECTORY_SEPARATOR,$imagePath);
   if(!is_file($imageFile)||!is_readable($imageFile)){$errors[]=['record'=>$index+1,'sku'=>$sku,'error'=>'Image file is missing or unreadable'];$outcomes[$skuKey]='failed_validation';continue;}
   $imageSize=filesize($imageFile);$imageInfo=@getimagesize($imageFile);$imageMime=(new finfo(FILEINFO_MIME_TYPE))->file($imageFile);
   if($imageSize===false||$imageSize<1||$imageSize>5*1024*1024||$imageMime!=='image/png'||$imageInfo===false||$imageInfo[2]!==IMAGETYPE_PNG||$imageInfo[0]<1||$imageInfo[1]<1||$imageInfo[0]>5000||$imageInfo[1]>5000){$errors[]=['record'=>$index+1,'sku'=>$sku,'error'=>'Image file must be a valid PNG no larger than 5 MB'];$outcomes[$skuKey]='failed_validation';continue;}
   $product['_validated_image']=['path'=>$imagePath,'filename'=>basename($imagePath),'mime_type'=>$imageMime,'file_size'=>$imageSize];
   $valid[]=$product;
  }
  $imported=0;$imagesAttached=0;$categoryIds=[];
  if($valid){
   db()->beginTransaction();
   try{
    foreach(rows('SELECT id,name,slug FROM categories') as $category){$categoryIds[mb_strtolower(trim($category['name']))]=(int)$category['id'];$usedSlugs['category:'.strtolower($category['slug'])]=true;}
    foreach($valid as $product){
     $categoryName=mb_substr(trim((string)$product['category']),0,190);$categoryKey=mb_strtolower($categoryName);
     if(!isset($categoryIds[$categoryKey])){
      $categorySlug=slug($categoryName);$candidate=$categorySlug;$suffix=2;
      while(isset($usedSlugs['category:'.strtolower($candidate)]))$candidate=$categorySlug.'-'.$suffix++;
      execute_sql('INSERT INTO categories(name,slug,description,status,display_order) VALUES(?,?,?,\'active\',0)',[$categoryName,$candidate,'Imported category from the Rangers safety catalogue']);
      $categoryIds[$categoryKey]=(int)db()->lastInsertId();$usedSlugs['category:'.strtolower($candidate)]=true;
     }
     $productSlug=slug((string)$product['slug']);$candidate=$productSlug;$suffix=2;
     while(isset($usedSlugs[strtolower($candidate)]))$candidate=$productSlug.'-'.slug((string)$product['specifications']['sku']).'-'.$suffix++;
     $usedSlugs[strtolower($candidate)]=true;
     $storedSpecs=$product['specifications'];
     if(isset($product['subcategory']))$storedSpecs['subcategory']=trim((string)$product['subcategory']);
     $storedSpecs['manual_review']=!empty($product['manual_review']);
     $storedSpecs['image_path']=$product['_validated_image']['path'];
     $storedSpecs['image_status']='original_pdf_photo_web_enhanced';
     $specJson=json_encode($storedSpecs,JSON_THROW_ON_ERROR|JSON_INVALID_UTF8_SUBSTITUTE);
     execute_sql('INSERT INTO products(category_id,name,slug,short_description,full_description,specifications,status,display_order) VALUES(?,?,?,?,?,?,?,0)',[$categoryIds[$categoryKey],mb_substr(trim((string)$product['name']),0,255),$candidate,trim((string)$product['short_description']),mb_substr(trim((string)$product['full_description']),0,60000),$specJson,'inactive']);
     $productId=(int)db()->lastInsertId();$image=$product['_validated_image'];
     if(!one('SELECT id FROM media_library WHERE file_path=? LIMIT 1',[$image['path']]))execute_sql('INSERT INTO media_library(filename,file_path,mime_type,file_size) VALUES(?,?,?,?)',[$image['filename'],$image['path'],$image['mime_type'],$image['file_size']]);
     execute_sql('INSERT INTO product_images(product_id,image_path,alt_text,display_order) VALUES(?,?,?,0)',[$productId,$image['path'],mb_substr(trim((string)$product['name']),0,255)]);
     execute_sql('UPDATE products SET main_image_id=? WHERE id=?',[(int)db()->lastInsertId(),$productId]);
     $imported++;$imagesAttached++;$outcomes[strtoupper((string)$product['specifications']['sku'])]='imported';
    }
    db()->commit();
   }catch(Throwable $e){if(db()->inTransaction())db()->rollBack();throw $e;}
  }
  $reportFile=dirname(__DIR__).'/storage/catalogues/rangers-import-report.json';$reportSaved=false;$reportError=null;
  if(is_readable($reportFile)){
   try{
    $report=json_decode(file_get_contents($reportFile),true,512,JSON_THROW_ON_ERROR);
    if(!is_array($report)||!isset($report['reconciliation'])||!is_array($report['reconciliation']))throw new RuntimeException('Import report has an invalid structure');
    foreach($report['reconciliation'] as &$entry){$key=strtoupper((string)($entry['sku']??''));$status=$outcomes[$key]??(isset($knownSkus[$key])?'skipped_duplicate':'not_processed');if($status==='skipped_duplicate'&&($entry['import_status']??'')==='imported')$status='imported';$entry['import_status']=$status;}unset($entry);
    $importedTotal=0;$skippedTotal=0;$failedTotal=0;
    foreach($report['reconciliation'] as $entry){if($entry['import_status']==='imported')$importedTotal++;elseif($entry['import_status']==='skipped_duplicate')$skippedTotal++;elseif($entry['import_status']==='failed_validation')$failedTotal++;}
    $report['import_summary']=['detected'=>count($catalogue['products']),'imported'=>$importedTotal,'updated'=>0,'skipped_duplicates'=>$skippedTotal,'failed_validation'=>$failedTotal,'manual_review'=>$manualReview,'images_attached'=>count(array_filter($report['reconciliation'],static fn($entry)=>($entry['import_status']??'')==='imported'&&!empty($entry['image'])))];
    $report['last_import_attempt']=['imported'=>$imported,'images_attached'=>$imagesAttached,'skipped_duplicates'=>$skipped,'failed_validation'=>count($errors),'attempted_at'=>date(DATE_ATOM)];
    $encodedReport=json_encode($report,JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES|JSON_INVALID_UTF8_SUBSTITUTE);
    if($encodedReport===false||file_put_contents($reportFile,$encodedReport,LOCK_EX)===false)throw new RuntimeException('Could not save the updated import report');
    $reportSaved=true;
   }catch(Throwable $e){error_log('Catalogue import report could not be updated: '.$e->getMessage());$reportError='Products were processed, but the reconciliation report could not be updated.';}
  }
  json_out(['detected'=>count($catalogue['products']),'imported'=>$imported,'images_attached'=>$imagesAttached,'updated'=>0,'skipped_duplicates'=>$skipped,'failed_validation'=>count($errors),'manual_review'=>$manualReview,'errors'=>$errors,'report_saved'=>$reportSaved,'report_error'=>$reportError,'duplicate_policy'=>'skip existing SKU; never overwrite existing product records','status_policy'=>'all imported products are inactive for admin review']);
 }
 if($path==='admin/dashboard' && $method==='GET')json_out(['products'=>one('SELECT COUNT(*) n FROM products')['n'],'active_products'=>one('SELECT COUNT(*) n FROM products WHERE status="active"')['n'],'categories'=>one('SELECT COUNT(*) n FROM categories')['n'],'images'=>one('SELECT COUNT(*) n FROM product_images')['n'],'missing_images'=>one('SELECT COUNT(*) n FROM products WHERE main_image_id IS NULL')['n'],'recent'=>rows('SELECT id,name,updated_at FROM products ORDER BY updated_at DESC LIMIT 8')]);
 if(preg_match('~^(admin/)?products(?:/(\\d+))?$~',$path,$m)){
  $admin=!empty($m[1]);$id=(int)($m[2]??0);
  if($method==='GET'){
   $filter=$admin?'':' WHERE p.status="active" AND c.status="active"';$args=[];
   if($id){$filter.=($filter?' AND ':' WHERE ').'p.id=?';$args[]=$id;}
   $list=rows('SELECT p.*,c.name category_name,(SELECT image_path FROM product_images WHERE id=p.main_image_id) main_image FROM products p JOIN categories c ON c.id=p.category_id'.$filter.' ORDER BY p.display_order,p.id',$args);
   foreach($list as &$prod){$prod['images']=rows('SELECT id,image_path,alt_text,display_order FROM product_images WHERE product_id=? ORDER BY display_order,id',[$prod['id']]);$prod['specifications']=json_decode($prod['specifications']??'null',true); }unset($prod);
   if($id)json_out($list[0]??['error'=>'Not found'],$list?200:404);json_out($list);
  }
  if(!$admin)json_out(['error'=>'Method not allowed'],405);
  if($method==='DELETE' && $id){execute_sql('DELETE FROM booklet_products WHERE product_id=?',[$id]);execute_sql('UPDATE products SET main_image_id=NULL WHERE id=?',[$id]);execute_sql('DELETE FROM products WHERE id=?',[$id]);json_out(['ok'=>true]);}
  if(in_array($method,['POST','PUT'],true)){
   $d=body();$name=val($d,'name',255);$category=(int)($d['category_id']??0);if(!$name||!one('SELECT id FROM categories WHERE id=?',[$category]))json_out(['error'=>'Name and valid category required'],422);
   $spec=json_encode($d['specifications']??[],JSON_INVALID_UTF8_SUBSTITUTE);$fields=[$category,$name,slug(val($d,'slug',255)?:$name),val($d,'short_description'),val($d,'full_description',60000),$spec,status_val($d),(int)($d['display_order']??0)];
   if($method==='POST'){execute_sql('INSERT INTO products(category_id,name,slug,short_description,full_description,specifications,status,display_order) VALUES(?,?,?,?,?,?,?,?)',$fields);$id=(int)db()->lastInsertId();}
   else {if(!$id)json_out(['error'=>'ID required'],422);$fields[]=$id;execute_sql('UPDATE products SET category_id=?,name=?,slug=?,short_description=?,full_description=?,specifications=?,status=?,display_order=? WHERE id=?',$fields);}
   json_out(['ok'=>true,'id'=>$id]);
  }
 }
 if(preg_match('~^(admin/)?categories(?:/(\\d+))?$~',$path,$m)){
  $admin=!empty($m[1]);$id=(int)($m[2]??0);
  if($method==='GET')json_out(rows('SELECT * FROM categories'.($admin?'':' WHERE status="active"').' ORDER BY display_order,id'));
  if(!$admin)json_out(['error'=>'Forbidden'],403);
  if($method==='DELETE'&&$id){if(one('SELECT id FROM products WHERE category_id=? LIMIT 1',[$id]))json_out(['error'=>'Category has products; deactivate instead'],409);execute_sql('DELETE FROM categories WHERE id=?',[$id]);json_out(['ok'=>true]);}
  if(in_array($method,['POST','PUT'],true)){$d=body();$name=val($d,'name',190);if(!$name)json_out(['error'=>'Name required'],422);$a=[$name,slug(val($d,'slug',190)?:$name),val($d,'description'),val($d,'image_path',500),status_val($d),(int)($d['display_order']??0)];if($method==='POST'){execute_sql('INSERT INTO categories(name,slug,description,image_path,status,display_order) VALUES(?,?,?,?,?,?)',$a);$id=(int)db()->lastInsertId();}else{$a[]=$id;execute_sql('UPDATE categories SET name=?,slug=?,description=?,image_path=?,status=?,display_order=? WHERE id=?',$a);}json_out(['ok'=>true,'id'=>$id]);}
 }
 if($path==='admin/media'&&$method==='GET')json_out(rows('SELECT id,filename,file_path,mime_type,file_size,uploaded_at FROM media_library ORDER BY uploaded_at DESC,id DESC LIMIT 100'));
 if($path==='admin/upload'&&$method==='POST'){
  if(!isset($_FILES['image'])||!is_uploaded_file($_FILES['image']['tmp_name']))json_out(['error'=>'Image required'],422);$f=$_FILES['image'];if($f['error']!==UPLOAD_ERR_OK||$f['size']>5*1024*1024)json_out(['error'=>'Image must be under 5 MB'],422);
  $mime=(new finfo(FILEINFO_MIME_TYPE))->file($f['tmp_name']);$ext=['image/jpeg'=>'jpg','image/png'=>'png','image/webp'=>'webp'][$mime]??null;if(!$ext||!getimagesize($f['tmp_name']))json_out(['error'=>'Invalid image'],422);
  $name=bin2hex(random_bytes(20)).'.'.$ext;$dir=dirname(__DIR__).'/storage/uploads';if(!is_dir($dir)&&!mkdir($dir,0755,true))json_out(['error'=>'Cannot create upload directory'],500);if(!is_writable($dir))json_out(['error'=>'Upload directory is not writable'],500);if(!move_uploaded_file($f['tmp_name'],$dir.'/'.$name))json_out(['error'=>'Upload failed'],500);$url='storage/uploads/'.$name;
  execute_sql('INSERT INTO media_library(filename,file_path,mime_type,file_size) VALUES(?,?,?,?)',[$name,$url,$mime,$f['size']]);
  $product=(int)($_POST['product_id']??0);$imageId=null;if($product){execute_sql('INSERT INTO product_images(product_id,image_path,alt_text) VALUES(?,?,?)',[$product,$url,mb_substr((string)($_POST['alt_text']??''),0,255)]);$imageId=(int)db()->lastInsertId();if(($_POST['main']??'')==='1')execute_sql('UPDATE products SET main_image_id=? WHERE id=?',[$imageId,$product]);}
  json_out(['ok'=>true,'path'=>$url,'image_id'=>$imageId]);
 }
 if(preg_match('~^admin/product-images/(\\d+)$~',$path,$m)&&$method==='DELETE'){$id=(int)$m[1];execute_sql('UPDATE products SET main_image_id=NULL WHERE main_image_id=?',[$id]);execute_sql('DELETE FROM product_images WHERE id=?',[$id]);json_out(['ok'=>true]);}
 if($path==='admin/set-main-image'&&$method==='PUT'){$d=body();$pid=(int)($d['product_id']??0);$iid=(int)($d['image_id']??0);if(!one('SELECT id FROM product_images WHERE id=? AND product_id=?',[$iid,$pid]))json_out(['error'=>'Image does not belong to product'],422);execute_sql('UPDATE products SET main_image_id=? WHERE id=?',[$iid,$pid]);json_out(['ok'=>true]);}
 if($path==='booklet'&&$method==='GET'){$s=one('SELECT * FROM booklet_settings WHERE id=1');$items=rows('SELECT p.*,c.name category_name,(SELECT image_path FROM product_images WHERE id=p.main_image_id) main_image FROM booklet_products bp JOIN products p ON bp.product_id=p.id JOIN categories c ON c.id=p.category_id WHERE p.status="active" AND c.status="active" ORDER BY bp.display_order,bp.id');json_out(['settings'=>$s,'products'=>$items]);}
 if($path==='admin/booklet'&&$method==='PUT'){$d=body();db()->beginTransaction();try{execute_sql('UPDATE booklet_settings SET title=?,description=?,status=? WHERE id=1',[val($d,'title',255),val($d,'description'),status_val($d)]);execute_sql('DELETE FROM booklet_products');foreach(array_values(array_unique(array_map('intval',$d['product_ids']??[]))) as $i=>$pid){if(one('SELECT id FROM products WHERE id=?',[$pid]))execute_sql('INSERT INTO booklet_products(product_id,display_order) VALUES(?,?)',[$pid,$i]);}db()->commit();}catch(Throwable $e){db()->rollBack();throw $e;}json_out(['ok'=>true]);}
 if($path==='admin/exhibitions'&&$method==='GET')json_out(rows('SELECT * FROM exhibitions ORDER BY id'));
 if($path==='exhibitions'&&$method==='GET')json_out(rows('SELECT * FROM exhibitions WHERE status="active" ORDER BY display_order,id'));
 if($path==='admin/exhibition'&&$method==='PUT'){$d=body();execute_sql('UPDATE exhibitions SET title=?,description=?,status=? WHERE id=1',[val($d,'title',255),val($d,'description'),status_val($d)]);json_out(['ok'=>true]);}
 if($path==='company'&&$method==='GET')json_out(one('SELECT * FROM company_information WHERE id=1'));
 if($path==='admin/company'&&$method==='PUT'){$d=body();execute_sql('UPDATE company_information SET company_name=?,about_heading=?,about_description=?,company_image=? WHERE id=1',[val($d,'company_name',255),val($d,'about_heading',255),val($d,'about_description',60000),val($d,'company_image',500)]);json_out(['ok'=>true]);}
 if($path==='settings/public'&&$method==='GET'){$out=[];foreach(rows('SELECT setting_key,setting_value FROM website_settings') as $s)$out[$s['setting_key']]=$s['setting_value'];json_out($out);}
 if($path==='social-links'&&$method==='GET')json_out(rows('SELECT platform,url FROM social_links WHERE status="active" AND url<>""'));
 if($path==='admin/settings'&&$method==='GET')json_out(['settings'=>rows('SELECT * FROM website_settings'),'social'=>rows('SELECT * FROM social_links')]);
 if($path==='admin/settings'&&$method==='PUT'){$d=body();foreach(($d['settings']??[]) as $k=>$v){if(in_array($k,['whatsapp_number','whatsapp_message','whatsapp_enabled','logo_path','favicon_path','seo_description','website_name'],true))setting($k,(string)$v);}foreach(($d['social']??[]) as $platform=>$entry){if(!in_array($platform,['linkedin','instagram','facebook'],true))continue;$url=(string)($entry['url']??'');if($url&&!filter_var($url,FILTER_VALIDATE_URL))json_out(['error'=>'Invalid social URL'],422);execute_sql('UPDATE social_links SET url=?,status=? WHERE platform=?',[$url,($entry['status']??'inactive')==='active'?'active':'inactive',$platform]);}json_out(['ok'=>true]);}

 // CMS public pages and overrides
 if($path==='cms' && $method==='GET'){
  $page=preg_replace('/[^a-z0-9-]/','',strtolower((string)($_GET['page']??'home')));
  $items=rows('SELECT page_slug,element_key,kind,content FROM cms_elements WHERE page_slug IN (?,"global")',[$page]);
  json_out(['page'=>$page,'elements'=>$items]);
 }
 if($path==='admin/cms/pages' && $method==='GET')json_out(rows('SELECT * FROM cms_pages ORDER BY sort_order,id'));
 if($path==='admin/cms/pages' && $method==='POST'){
  $d=body();$slug=slug(val($d,'slug',100));$title=val($d,'title',200);
  if(!$title)json_out(['error'=>'Page title required'],422);
  execute_sql('INSERT INTO cms_pages(slug,title,status,sort_order) VALUES(?,?,?,?)',[$slug,$title,status_val($d),(int)($d['sort_order']??0)]);json_out(['ok'=>true]);
 }
 if(preg_match('~^admin/cms/pages/([a-z0-9-]+)$~',$path,$m) && $method==='PUT'){
  $d=body();execute_sql('UPDATE cms_pages SET title=?,status=?,sort_order=? WHERE slug=?',[val($d,'title',200),status_val($d),(int)($d['sort_order']??0),$m[1]]);json_out(['ok'=>true]);
 }
 if($path==='admin/cms/elements' && $method==='GET')json_out(rows('SELECT * FROM cms_elements ORDER BY page_slug,element_key'));
 if($path==='admin/cms/element' && $method==='PUT'){
  $d=body();$page=val($d,'page_slug',100);$key=val($d,'element_key',255);$kind=val($d,'kind',20);$content=val($d,'content',100000);
  if(!preg_match('/^[a-z0-9-]+$/',$page)||!preg_match('/^[a-zA-Z0-9_:()\[\]\.\-# >]+$/',$key)||!in_array($kind,['text','image','video','link','html','style'],true))json_out(['error'=>'Invalid CMS element'],422);
  if(in_array($kind,['image','video','link'],true) && $content && !preg_match('~^(https?://|assets/|../storage/uploads/|storage/uploads/|/rangers-backend/)~',$content))json_out(['error'=>'Invalid media/link path'],422);
  execute_sql('INSERT INTO cms_elements(page_slug,element_key,kind,content) VALUES(?,?,?,?) ON DUPLICATE KEY UPDATE kind=VALUES(kind),content=VALUES(content)',[$page,$key,$kind,$content]);json_out(['ok'=>true]);
 }
 if(preg_match('~^admin/cms/elements/(\d+)$~',$path,$m)&&$method==='DELETE'){execute_sql('DELETE FROM cms_elements WHERE id=?',[(int)$m[1]]);json_out(['ok'=>true]);}
 if($path==='admin/profile' && $method==='GET'){ $a=one('SELECT id,name,email,created_at FROM admins WHERE id=?',[$_SESSION['admin_id']]);json_out($a); }
 if($path==='admin/profile' && $method==='PUT'){
  $d=body();$a=one('SELECT * FROM admins WHERE id=?',[$_SESSION['admin_id']]);
  if(!$a||!password_verify((string)($d['current_password']??''),$a['password_hash']))json_out(['error'=>'Current password is incorrect'],403);
  $name=val($d,'name',150);$email=val($d,'email',190);if(!$name||!filter_var($email,FILTER_VALIDATE_EMAIL))json_out(['error'=>'Valid name and email required'],422);
  $new=(string)($d['new_password']??'');if($new!=='' && strlen($new)<12)json_out(['error'=>'New password must be at least 12 characters'],422);
  if($new!=='')execute_sql('UPDATE admins SET name=?,email=?,password_hash=? WHERE id=?',[$name,$email,password_hash($new,PASSWORD_DEFAULT),$a['id']]);
  else execute_sql('UPDATE admins SET name=?,email=? WHERE id=?',[$name,$email,$a['id']]);
  session_regenerate_id(true);json_out(['ok'=>true]);
 }
 json_out(['error'=>'Route not found'],404);
} catch(PDOException $e){error_log($e->getMessage());json_out(['error'=>'Database operation failed (check duplicate slugs and constraints)'],500);}catch(Throwable $e){error_log($e->getMessage());json_out(['error'=>'Server error'],500);}
