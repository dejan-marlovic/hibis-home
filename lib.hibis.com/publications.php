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
        $properties["pdf"] = Utility::valid_or_null("pdf", $properties);
        $properties["icon"] = Utility::valid_or_null("icon", $properties);

        $DB->execute("INSERT INTO publications (name, publisher, date, brief, url_info, url_publisher, pdf, icon) 
                      VALUES (:name, :publisher, :date, :brief, :url_info, :url_publisher, :pdf, :icon)", $properties);
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