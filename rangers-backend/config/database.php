<?php
return ['host'=>getenv('DB_HOST')?:'127.0.0.1','port'=>getenv('DB_PORT')?:'3306','name'=>getenv('DB_NAME')?:'rangers_safety_systems','user'=>getenv('DB_USER')?:'root','password'=>getenv('DB_PASSWORD')?:''];
