<?php
// Global değişkenler
global $env;
// .env dosyasını yükle
if (!function_exists('loadEnv')) {
    function loadEnv($path)
    {
        if (!file_exists($path)) {
            return [];
        }

        $lines = file($path, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        $env = [];

        foreach ($lines as $line) {
            if (strpos(trim($line), '#') === 0) {
                continue;
            }

            list($key, $value) = explode('=', $line, 2);
            $key = trim($key);
            $value = trim($value);

            if (!empty($key)) {
                $env[$key] = $value;
            }
        }

        return $env;
    }
}

$envFilePath = __DIR__ . '/../../.env';
$env = loadEnv($envFilePath);
if (!function_exists('env')) {
    function env($key, $default = null)
    {
        global $env;
        if (isset($env[$key])) {
            return $env[$key];
        }
        return $default;
    }
}