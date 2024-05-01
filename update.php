<?php
try {
    $my_version = file_get_contents("version.txt");
    $latest_version = file_get_contents("https://raw.githubusercontent.com/duran004/TRPanel/main/version.txt");
    if ($my_version != $latest_version) {
        throw new Exception("New version available. Updating...");
    }
    echo "<x-alert>You are up to date!
    <br>Current version: $my_version
    <br>Latest version: $latest_version
    </x-alert>";
} catch (Exception $e) {
    echo $e->getMessage() . "<br>";
    $output = [];
    $return_var = 0;
    exec('git pull origin main 2>&1', $output, $return_var);
    if ($return_var !== 0) {
        echo "Git update failed. Output: " . implode("\n", $output);
    } else {
        echo "Git update successful. Output: " . implode("\n", $output);
    }
    header("Refresh:5");
    exit;
}
