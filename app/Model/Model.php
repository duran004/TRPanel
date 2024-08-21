<?php

namespace App\Model;

/**
 * Class Model like laravel model
 */
class Model
{
    public \PDO $db;
    public string $table;
    public function __construct()
    {
        try {
            $this->db = new \PDO('mysql:host=localhost;dbname=trpanel', env('DB_USERNAME'), env('DB_PASSWORD'));
        } catch (\PDOException $e) {
            echo $e->getMessage();
            Log::info($e->getMessage());
        }
    }

    public static function all()
    {
        $model = new static();
        $stmt = $model->db->prepare("SELECT * FROM $model->table");
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public static function find($id)
    {
        $model = new static();
        $stmt = $model->db->prepare("SELECT * FROM $model->table WHERE id = :id");
        $stmt->execute(['id' => $id]);
        return $stmt->fetch();
    }

    public static function where($column, $value)
    {
        $model = new static();
        $stmt = $model->db->prepare("SELECT * FROM $model->table WHERE $column = :$column");
        $stmt->execute([$column => $value]);
        return $stmt->fetchAll();
    }

    public static function create($data)
    {
        $model = new static();
        $sql = sprintf(
            'INSERT INTO %s (%s) VALUES (%s)',
            $model->table,
            implode(', ', array_keys($data)),
            ':' . implode(', :', array_keys($data))
        );
        $stmt = $model->db->prepare($sql);
        $stmt->execute($data);
    }

    public static function update($id, $data)
    {
        $model = new static();
        $columns = '';
        foreach (array_keys($data) as $key) {
            $columns .= $key . ' = :' . $key . ', ';
        }
        $columns = rtrim($columns, ', ');
        $sql = sprintf(
            'UPDATE %s SET %s WHERE id = :id',
            $model->table,
            $columns
        );
        $stmt = $model->db->prepare($sql);
        $stmt->execute(array_merge($data, ['id' => $id]));
    }

    public static function delete($id)
    {
        $model = new static();
        $stmt = $model->db->prepare("DELETE FROM $model->table WHERE id = :id");
        $stmt->execute(['id' => $id]);
    }

    public static function query($sql)
    {
        $model = new static();
        $stmt = $model->db->prepare($sql);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public static function raw($sql)
    {
        $model = new static();
        $stmt = $model->db->prepare($sql);
        $stmt->execute();
        return $stmt->fetch();
    }
    // @TODO: Implement toSql method
    // public function toSql()
    // {
    //     return $this->db->lastQuery;
    // }
    public function __destruct()
    {
        $this->db = null;
    }
}