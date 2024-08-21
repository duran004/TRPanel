<?php

namespace App\Controller;

use App\View\View;
use App\Model\TestModel;

class FileController
{
    public string $basePath;

    public function files(string $dirnaname = __DIR__ . '/../../')
    {
        \var_dump(TestModel::all());
        $this->basePath = $dirnaname;
        return scandir($this->basePath);
    }
}