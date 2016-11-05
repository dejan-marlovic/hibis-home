<?php

class Fellows
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
        $properties["firstname"] = Utility::valid_or_die($properties["firstname"], "firstname");
        $properties["lastname"] = Utility::valid_or_die($properties["lastname"], "lastname");
        $properties["email"] = Utility::valid_or_die($properties["email"], "email");
        $properties["phone"] = Utility::valid_or_die($properties["phone"], "phone");
        $properties["phone_2"] = Utility::valid_or_null("phone_2", $properties);
        $properties["city"] = Utility::valid_or_die($properties["city"], "city");
        $properties["country"] = Utility::valid_or_die($properties["country"], "country");
        $properties["description_short"] = Utility::valid_or_die($properties["description_short"], "description_short");
        $properties["description_long"] = Utility::valid_or_die($properties["description_long"], "description_long");
        $properties["image"] = Utility::valid_or_die($properties["image"], "image");
        $properties["logo"] = Utility::valid_or_null("logo", $properties);

        file_put_contents(__DIR__ . '/info.txt', print_r($properties, true));

        $DB->execute("INSERT INTO fellows (firstname, lastname, email, phone, phone_2, city, country, description_short, description_long, image, logo) 
                      VALUES (:firstname, :lastname, :email, :phone, :phone_2, :city, :country, :description_short, :description_long, :image, :logo)", $properties);
    }

    private static function delete($id)
    {
        global $DB;
        $DB->execute("DELETE FROM fellows WHERE id = ?", array($id));
    }


    private static function update($id, $column, $value)
    {
        global $DB;
        $DB->execute("UPDATE fellows SET $column = ? WHERE id = ?", array($value, $id));
    }
}