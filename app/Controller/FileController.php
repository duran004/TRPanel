<?php

namespace App\Controller;

use App\View\View;

class FileController
{
    public function __construct(public string $basePath) {}

    public function files(string $dirnaname = __DIR__ . '/../../')
    {
        $this->basePath = $dirnaname;
        return scandir($this->basePath);
    }
}