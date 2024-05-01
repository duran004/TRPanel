<?php

namespace App\Helper;

class SysHelper
{
    public static function update()
    {
        try {
            //clear cache
            ini_set('realpath_cache_size', '0');
            clearstatcache();
            //check for updates
            $my_version = file_get_contents("version.txt");
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, "https://raw.githubusercontent.com/duran004/TRPanel/main/version.txt");
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_FRESH_CONNECT, true);
            curl_setopt($ch, CURLOPT_FORBID_REUSE, true);
            $latest_version = curl_exec($ch);
            if ($my_version != $latest_version) {
                throw new \Exception("New version available. Updating...");
            }
            echo "<x-alert>You are up to date!
            <br>Current version: $my_version
            <br>Latest version: $latest_version
            </x-alert>";
        } catch (\Exception $e) {
            echo $e->getMessage() . "<br>";
            $output = [];
            $return_var = 0;
            exec('git reset --hard 2>&1', $output, $return_var);
            exec('git pull origin main 2>&1', $output, $return_var);
            if ($return_var !== 0) {
                echo "Git update failed. Output: " . implode("\n", $output);
            } else {
                echo "Git update successful. Output: " . implode("\n", $output);
            }
            header("Refresh:5");
            exit;
        }
    }
}

function view($view, $data = [])
{
    extract($data);
    require_once "app/View/$view.php";
}
