<?php

class Books
{
    public static function parse($msg, $params)
    {
        switch ($msg)
        {
            case "list_all":
                return self::list_all();
                break;
        }

        return null;
    }

    private static function list_all()
    {
        global $DB;
        $rs = $DB->query_all("SELECT id, name, author, format, brief, image_url FROM books WHERE 1", null);
        return $rs;
    }



}