<?php
try {
    $my_version = file_get_contents("version.txt");
    $latest_version = file_get_contents("https://raw.githubusercontent.com/duran004/TRPanel/main/version.txt");
    if ($my_version != $latest_version) {
        throw new Exception("New version available. Updating...");
    }
} catch (Exception $e) {
    echo $e->getMessage() . "<br>";
    $output = [];
    $return_var = 0;
    exec('git pull origin main 2>&1', $output, $return_var);
    if ($return_var !== 0) {
        die("Git update failed. Output: " . implode("\n", $output));
    } else {
        echo "Git update successful. Output: " . implode("\n", $output);
        header("Refresh:3");
        exit;
    }
}
