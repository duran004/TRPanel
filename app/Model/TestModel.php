<?php

namespace App\Model;

class TestModel extends Model
{
    public string $table = 'test';
    public function __construct()
    {
        parent::__construct();
    }
}