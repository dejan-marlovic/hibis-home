<?php

class Events
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
        $properties["description"] = Utility::valid_or_null("description", $properties);
        $properties["url_description"] = Utility::valid_or_null("url_description", $properties);
        $properties["url_signup"] = Utility::valid_or_die($properties["url_signup"], "url_signup");
        $properties["date_start"] = Utility::valid_or_die($properties["date_start"], "date_start");
        $properties["date_end"] = Utility::valid_or_die($properties["date_end"], "date_end");
        $properties["street"] = Utility::valid_or_die($properties["street"], "street");
        $properties["city"] = Utility::valid_or_die($properties["city"], "city");
        $properties["country"] = Utility::valid_or_die($properties["country"], "country");
        $properties["lang"] = Utility::valid_or_die($properties["lang"], "lang");
        $properties["pdf"] = Utility::valid_or_die($properties["pdf"], "pdf");

        $DB->execute("INSERT INTO events (name, description, url_description, url_signup, date_start, date_end, street, city, country, lang, pdf) 
                      VALUES (:name, :description, :url_description, :url_signup, :date_start, :date_end, :street, :city, :country, :lang, :pdf)", $properties);
    }

    private static function delete($id)
    {
        global $DB;
        $DB->execute("DELETE FROM events WHERE id = ?", array($id));
    }

    private static function update($id, $column, $value)
    {
        global $DB;
        $DB->execute("UPDATE events SET $column = ? WHERE id = ?", array($value, $id));
    }
}