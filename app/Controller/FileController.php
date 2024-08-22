<?php

namespace App\Controller;

use App\View\View;
use App\Model\TestModel;

class FileController
{
    public string $basePath;
    public array $ignore = ['.', '..', '.git', '.gitignore', 'index.php', 'composer.json', 'composer.lock', 'vendor', 'node_modules', 'package.json', 'package-lock.json', 'public', 'src', 'storage', 'tests', 'phpunit.xml', 'phpunit.xml.dist', 'README.md', 'LICENSE'];

    public function __construct()
    {
        $this->basePath = dirname(__DIR__, 2) . "/";
    }
    public function getFiles($path)
    {
        $files = scandir($path);
        $data = new \stdClass();
        foreach ($files as $file) {
            if (!in_array($file, $this->ignore)) {
                $path = $this->basePath . $file;
                $data->$file = new \stdClass();
                $data->$file->name = $file;
                $data->$file->path = $path;
                $data->$file->type = is_dir($path) ? 'dir' : 'file';
            }
        }
        // dd($data);
        return $data;
    }

    public function index()
    {
        $path = $_GET['path'] ?? '';
        if ($path == '') {
            $path = $this->basePath;
        } else {
            $this->basePath = $path . "/";
        }


        if (!is_dir($path)) {
            http_response_code(404);
            die(View::view('errors/404'));
        }


        // dd($path);
        if (!file_exists($path)) {
            http_response_code(404);
            echo View::view('errors/404');
            return;
        }

        $data = [
            'title' => 'File Manager',
            'files' => $this->getFiles($path),
            'path' => $path,
            'basePath' => $this->basePath
        ];
        echo View::view('filemanager/header', $data);
        echo View::view('filemanager/files', $data);
        echo View::view('filemanager/footer', $data);
    }
}