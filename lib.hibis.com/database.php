<?php

class Database
{
    public function __construct($dbname, $user, $pass)
    {
        require_once(__DIR__ . '/messenger.php');
        try
        {
            $this->dbh = new PDO("mysql:host=localhost;charset=utf8;dbname=" . $dbname, $user, $pass);
            $this->dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        }
        catch (PDOException $e)
        {
            require_once(__DIR__ . '/messenger.php');
            Messenger::respond("Server database error", false, $e->getMessage());
        }
    }

    public function get_row($system, $columns, $id)
    {
        return self::query("SELECT $columns FROM $system WHERE id = ?", array($id));
    }

    public function get_row_by_column($system, $columns, $search_column, $search_value)
    {
        return self::query("SELECT $columns FROM $system WHERE $search_column = ?", array($search_value));
    }

    public function get_rows($system, $columns, $where = "1", $order_by = null, $limit = null)
    {
        if (!isset($limit)) $limit = "0, 100";
        $statement = "SELECT DISTINCT $columns FROM $system WHERE $where";
        if ($order_by != null) $statement .= " ORDER BY $order_by";
        $statement .= " LIMIT $limit";
        return self::query_all($statement, null);
    }

    public function query($statement, $array, $fetch = PDO::FETCH_ASSOC)
    {
        try
        {
            $stmnt = $this->dbh->prepare($statement);
            if ($stmnt->execute($array) == true) return $stmnt->fetch($fetch);
        }
        catch (PDOException $e)
        {
            Messenger::respond("Server database error", false, $e->getMessage());
        }
        return null;
    }

    public function query_all($statement, $array, $fetch = PDO::FETCH_ASSOC)
    {
        try
        {
            $stmnt = $this->dbh->prepare($statement);
            if ($stmnt->execute($array) == true) return $stmnt->fetchAll($fetch);
            else
            {
                Messenger::respond("Server database error", false, $this->dbh->errorInfo());
            }
        }
        catch (PDOException $e)
        {
            Messenger::respond("Server database error", false, $e->getMessage());
        }
        return null;
    }

    public function execute($statement, $array)
    {
        $data = null;
        try
        {
            $stmnt = $this->dbh->prepare($statement);
            //$this->dbh->setAttribute(PDO::MYSQL_ATTR_USE_BUFFERED_QUERY, false);
            $stmnt->execute($array);
        }
        catch (PDOException $e)
        {
            Messenger::respond("Server database error", false, $e->getMessage());
        }
    }

    public function get_last_insert_id()
    {
        $stmnt = $this->dbh->prepare("SELECT LAST_INSERT_ID() as last_id");
        $stmnt->execute(null);
        $rs = $stmnt->fetch(PDO::FETCH_ASSOC);
        return $rs["last_id"];
    }

    private $dbh;
}

$config = parse_ini_file(__DIR__ . "/config.ini.php");
$DB = new Database($config["dbname"], $config["username"], $config["password"]);
