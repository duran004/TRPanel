<?php

namespace App\Controller;

use App\View\View;
use App\Controller\FileController;

class AppController
{
    public $fileController;
    public function __construct()
    {
        $this->fileController = new FileController();

        $this->index();
    }
    public function index()
    {
        $data = [
            'files' => $this->fileController->files()
        ];
        echo View::view('files', $data);
    }
}