<?php
if(PHP_SAPI!=='cli'){http_response_code(403);exit('CLI only');}
require dirname(__DIR__).'/config/bootstrap.php';
$email=$argv[1]??'';$name=$argv[2]??'Administrator';if(!filter_var($email,FILTER_VALIDATE_EMAIL)){fwrite(STDERR,"Usage: php tools/create_admin.php email@example.com [name]\n");exit(1);}
echo 'Password: ';$pass=trim(fgets(STDIN));if(strlen($pass)<12){fwrite(STDERR,"Use at least 12 characters\n");exit(1);}
execute_sql('INSERT INTO admins(name,email,password_hash) VALUES(?,?,?)',[$name,$email,password_hash($pass,PASSWORD_DEFAULT)]);echo "Admin created.\n";
