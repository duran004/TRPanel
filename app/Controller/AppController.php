<?php

namespace App\Controller;

use App\View\View;
use App\Controller\FileController;

class AppController
{
    private FileController $fileController;
    public function __construct()
    {
        $this->fileController = new FileController();
    }

    public function index()
    {
        $data = [
            'title' => 'TRPanel',
        ];
        echo View::view('welcome', $data);
    }

    public function phpinfo()
    {
        phpinfo();
    }
}