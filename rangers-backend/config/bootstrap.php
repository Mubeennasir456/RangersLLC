<?php
declare(strict_types=1);
ini_set('display_errors', '0');
error_reporting(E_ALL);
$cfg = require __DIR__.'/database.php';
$secure = !empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off';
ini_set('session.use_strict_mode', '1');
session_name('rangers_admin');
session_set_cookie_params(['lifetime'=>0,'path'=>'/','secure'=>$secure,'httponly'=>true,'samesite'=>'Lax']);
if (session_status() !== PHP_SESSION_ACTIVE) session_start();
header('X-Content-Type-Options: nosniff');
header('Referrer-Policy: strict-origin-when-cross-origin');
function db(): PDO { global $cfg; static $pdo; if (!$pdo) $pdo=new PDO('mysql:host='.$cfg['host'].';port='.$cfg['port'].';dbname='.$cfg['name'].';charset=utf8mb4',$cfg['user'],$cfg['password'],[PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION,PDO::ATTR_DEFAULT_FETCH_MODE=>PDO::FETCH_ASSOC,PDO::ATTR_EMULATE_PREPARES=>false]); return $pdo; }
function json_out($data,int $status=200): never {http_response_code($status);header('Content-Type: application/json; charset=utf-8');echo json_encode($data,JSON_UNESCAPED_SLASHES|JSON_INVALID_UTF8_SUBSTITUTE);exit;}
function rows(string $sql,array $args=[]): array {$q=db()->prepare($sql);$q->execute($args);return $q->fetchAll();}
function one(string $sql,array $args=[]): ?array {$q=db()->prepare($sql);$q->execute($args);$r=$q->fetch();return $r?:null;}
function execute_sql(string $sql,array $args=[]): int {$q=db()->prepare($sql);$q->execute($args);return $q->rowCount();}
function auth(): bool {return isset($_SESSION['admin_id']) && (time()-($_SESSION['last_activity']??0))<3600;}
function require_auth(): void {if(!auth())json_out(['error'=>'Unauthorized'],401);$_SESSION['last_activity']=time();}
function csrf(): string {return $_SESSION['csrf']??=bin2hex(random_bytes(32));}
function check_csrf(): void {if(!hash_equals(csrf(),$_SERVER['HTTP_X_CSRF_TOKEN']??''))json_out(['error'=>'Invalid CSRF token'],419);}
function body(): array {$s=file_get_contents('php://input');$v=json_decode($s,true);if(!is_array($v))json_out(['error'=>'Expected JSON object'],400);return $v;}
function val(array $d,string $k,int $max=5000): string {return mb_substr(trim((string)($d[$k]??'')),0,$max);}
function status_val(array $d): string {return ($d['status']??'inactive')==='active'?'active':'inactive';}
function slug(string $s): string {$s=strtolower(trim(preg_replace('/[^a-zA-Z0-9]+/','-',$s),'-'));return $s?:bin2hex(random_bytes(5));}
function setting(string $k,string $v): void {execute_sql('INSERT INTO website_settings(setting_key,setting_value) VALUES(?,?) ON DUPLICATE KEY UPDATE setting_value=VALUES(setting_value)',[$k,$v]);}
function e($s): string {return htmlspecialchars((string)$s,ENT_QUOTES|ENT_SUBSTITUTE,'UTF-8');}
