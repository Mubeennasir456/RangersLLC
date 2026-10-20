<?php
declare(strict_types=1);
require dirname(__DIR__).'/config/bootstrap.php';
$remote=$_SERVER['REMOTE_ADDR']??'';
$local=in_array($remote,['127.0.0.1','::1'],true);
$err='';$done=false;$already=false;
try{$already=(int)one('SELECT COUNT(*) AS n FROM admins')['n']>0;}catch(Throwable $e){$err='Database is not ready. Import database/schema.sql and database/cms_migration.sql in phpMyAdmin, then check config/database.php.';}
if($_SERVER['REQUEST_METHOD']==='POST'){
 if(!$local)$err='For safety, initial setup is only available from localhost.';
 elseif($already)$err='An admin account already exists. Please sign in or use the CLI tool to reset access.';
 elseif(!hash_equals(csrf(),(string)($_POST['csrf']??'')))$err='Security token expired. Refresh and retry.';
 else{
  $email=trim((string)($_POST['email']??''));$name=trim((string)($_POST['name']??''));$pass=(string)($_POST['password']??'');
  if(!filter_var($email,FILTER_VALIDATE_EMAIL)||$name===''||strlen($pass)<12)$err='Enter a name, valid email, and a password of at least 12 characters.';
  else try{execute_sql('INSERT INTO admins(name,email,password_hash,status) VALUES(?,?,?,"active")',[$name,$email,password_hash($pass,PASSWORD_DEFAULT)]);$done=true;}catch(Throwable $e){$err='Could not create admin. Check database installation.';}
 }
}
?>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>First Admin Setup — Rangers Safety Systems</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="../assets/css/admin.css?v=202610201411" rel="stylesheet">
</head>
<body class="setup-body">
  <main class="setup-card">
    <a class="setup-logo" href="../" aria-label="Rangers Safety Systems home">
      <img src="../site/assets/rangers-logo.png" alt="Rangers Safety Systems">
    </a>
    <p class="portal-eyebrow">SECURE ADMINISTRATION</p>
    <h1>Create your admin account</h1>
    <p class="setup-intro">Set up your secure login to manage the website and its images.</p>
    <?php if($err):?><div class="alert alert-danger" role="alert"><?=e($err)?></div><?php endif;?>
    <?php if($done):?>
      <div class="alert alert-success" role="status">Admin created successfully. Sign in with the account you just created.</div>
      <a class="btn btn-primary w-100" href="./">Go to admin login</a>
    <?php elseif(!$local):?>
      <div class="alert alert-warning" role="alert">Setup is available only from the same computer running XAMPP.</div>
    <?php elseif($already):?>
      <div class="alert alert-info" role="status">An admin account already exists. Setup is locked to protect your site.</div>
      <a class="btn btn-primary w-100" href="./">Go to admin login</a>
    <?php else:?>
      <form method="post" class="setup-form">
        <input type="hidden" name="csrf" value="<?=e(csrf())?>">
        <label>Admin name<input class="form-control" name="name" required maxlength="150" value="Rangers Admin" autocomplete="name"></label>
        <label>Admin email<input class="form-control" type="email" name="email" required maxlength="190" value="admin@rangers.com" autocomplete="email"></label>
        <label>Password <span class="field-hint">(12 characters minimum)</span><input class="form-control" type="password" name="password" minlength="12" required autocomplete="new-password"></label>
        <button class="btn btn-primary w-100" type="submit">Create admin account</button>
      </form>
    <?php endif;?>
    <a class="setup-back" href="../">← Back to website menu</a>
  </main>
</body>
</html>
