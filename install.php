<?php
$output = [];
$return_var = 0;
exec('git pull origin master 2>&1', $output, $return_var);
if ($return_var !== 0) {
    echo "Git update failed. Output: " . implode("\n", $output);
    die();
}

echo phpinfo();
