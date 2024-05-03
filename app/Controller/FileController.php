<?php

namespace App\Controller;

use App\View\View;

class FileController
{
    public $basePath = __DIR__ . '\var\www\html';
    public function files()
    {
        return scandir($this->basePath);
    }
}
