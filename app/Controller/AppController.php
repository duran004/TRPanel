<?php

namespace App\Controller;

use App\View\View;
use App\Controller\FileController;

class AppController
{
    private FileController $fileController;
    public string $basePath = __DIR__ . '/../../';
    public function __construct()
    {
        $this->fileController = new FileController();
    }
    public function file_manager()
    {
        $data = [
            'title' => 'File Manager',
            'files' => $this->fileController->files(),
            'basePath' => $this->fileController->basePath,
        ];
        echo View::view('header', $data);
        echo View::view('files', $data);
        echo View::view('footer', $data);
    }
}