<?php

class Books
{
    public static function parse($msg, $params)
    {
        switch ($msg)
        {
            case "add":
                self::add($params);
                break;

            case "delete":
                self::delete(Utility::valid_or_die($params["id"], "id"));
                break;

            case "update":
                self::update(Utility::valid_or_die($params["id"], "id"),
                    Utility::valid_or_die($params["column"], "column"),
                    Utility::valid_or_die($params["value"], "value"));
                break;
        }

        return null;
    }

    private static function add($properties)
    {
        global $DB;
        $properties["name"] = Utility::valid_or_die($properties["name"], "name");
        $properties["author"] = Utility::valid_or_die($properties["author"], "author");
        $properties["format"] = Utility::valid_or_die($properties["format"], "format");
        $properties["brief"] = Utility::valid_or_die($properties["brief"], "brief");
        $properties["image"] = Utility::valid_or_die($properties["image"], "image");

        $DB->execute("INSERT INTO books(name, author, format, brief, image) 
                      VALUES (:name, :author, :format, :brief, :image)", $properties);
    }

    private static function delete($id)
    {
        global $DB;
        $DB->execute("DELETE FROM books WHERE id = ?", array($id));
    }

    private static function update($id, $column, $value)
    {
        global $DB;
        $DB->execute("UPDATE books SET $column = ? WHERE id = ?", array($value, $id));
    }



}