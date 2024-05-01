<?php
if (!shell_exec('git pull origin master')) {
    die('Git update failed');
}

echo phpinfo();
