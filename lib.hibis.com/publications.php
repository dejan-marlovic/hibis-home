<?php

class Publications
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
        $properties["publisher"] = Utility::valid_or_die($properties["publisher"], "publisher");
        $properties["date"] = Utility::valid_or_die($properties["date"], "date");
        $properties["brief"] = Utility::valid_or_null("brief", $properties);
        $properties["url_info"] = Utility::valid_or_null("url_info", $properties);
        $properties["url_publisher"] = Utility::valid_or_null("url_publisher", $properties);


        if (isset($_FILES["pdf"]))
        {
            $public_dir = "../gfx/publication_icons/";
            $server_dir = __DIR__ . "/../public_html/temp/demo-academy/gfx/publication_icons/";
            $properties["url_pdf"] = $public_dir . basename($_FILES["pdf"]["name"]);
            $server_file = $server_dir . basename($_FILES["pdf"]["name"]);
            move_uploaded_file($_FILES["pdf"]["tmp_name"], $server_file);
        }
        else $properties["url_pdf"] = null;

        if (isset($_FILES["icon"]))
        {
            $public_dir = "../gfx/publication_icons/";
            $server_dir = __DIR__ . "/../public_html/temp/demo-academy/gfx/publication_icons/";
            $properties["url_pdf"] = $public_dir . basename($_FILES["pdf"]["name"]);
            $server_file = $server_dir . basename($_FILES["pdf"]["name"]);
            move_uploaded_file($_FILES["pdf"]["tmp_name"], $server_file);
        }
        else $properties["url_icon"] = null;



        $DB->execute("INSERT INTO publications (name, publisher, date, brief, url_info, url_publisher, url_pdf, url_icon) VALUES (:name, :publisher, :date, :brief, :url_info, :url_publisher, :url_pdf, :url_icon)", $properties);
    }

    private static function delete($id)
    {
        global $DB;
        $DB->execute("DELETE FROM publications WHERE id = ?", array($id));
    }


    private static function update($id, $column, $value)
    {
        global $DB;
        $DB->execute("UPDATE publications SET $column = ? WHERE id = ?", array($value, $id));
    }
}