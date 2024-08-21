<?php

namespace App\Controller;

use App\View\View;
use App\Model\TestModel;

class FileController
{
    public string $basePath;

    public function files(string $dirnaname = __DIR__ . '/../../')
    {
        try {
            \var_dump(TestModel::all());
        } catch (\Exception $e) {
            echo $e->getMessage();
            log($e->getMessage());
        }

        $this->basePath = $dirnaname;
        return scandir($this->basePath);
    }
}