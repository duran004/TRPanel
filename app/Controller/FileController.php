<?php

namespace App\Controller;

use App\View\View;

class FileController
{
    private $basePath = __DIR__ . '/../../../';
    public function files()
    {
        return scandir($this->basePath);
    }
}