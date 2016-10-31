<?php

class Customers
{
    public static function parse($msg, $params)
    {
        switch ($msg)
        {
            case "contact":
                return self::contact($params);
                break;

            case "find":
                return self::find
                (
                    Utility::valid_or_die($params["firstnam"]),
                    Utility::valid_or_die($params["lastname"]),
                    Utility::valid_or_die($params["email"])
                );
                break;
        }

        return null;
    }

    private static function contact($params)
    {
        /// Required fields
        $dbVal["organisation"] = Utility::valid_or_die($params["organisation"], "organisation");
        $dbVal["postal_code"] = Utility::valid_or_die($params["postal_code"], "postal_code");
        $dbVal["city"] = Utility::valid_or_die($params["city"], "city");
        $dbVal["country"] = Utility::valid_or_die($params["country"], "country");
        $dbVal["firstname"] = Utility::valid_or_die($params["firstname"], "firstname");
        $dbVal["lastname"] = Utility::valid_or_die($params["lastname"], "lastname");
        $dbVal["email"] = Utility::valid_or_die($params["email"], "email");
        $dbVal["forum"] = Utility::valid_or_die($params["forum"], "forum");
        $dbVal["comments"] = Utility::valid_or_die($params["comments"], "comments");

        /// Optional fields
        $dbVal["department"] = Utility::valid_or_null("department", $params);
        $dbVal["address"] = Utility::valid_or_null("address", $params);
        $dbVal["title"] = Utility::valid_or_null("title", $params);
        $dbVal["telephone"] = Utility::valid_or_null("telephone", $params);

        global $DB;
        $id = self::find($params["firstname"], $params["lastname"], $params["email"]);
        if (isset($id))
        {
            $dbVal["id"] = $id;
            /// Existing customer, update
            $DB->execute("UPDATE customers SET organisation = :organisation, postal_code = :postal_code, city = :city,
                          country = :country, firstname = :firstname, lastname = :lastname, email = :email, comments = :comments, 
                          department = :department, address = :address, title = :title, telephone = :telephone, forum = :forum
                          WHERE id = :id", $dbVal);
        }
        else
        {
            /// Add new customer
            $DB->execute("INSERT INTO customers (organisation, postal_code, city, country, firstname, lastname, comments,
                          email, department, address, title, telephone, forum) VALUES (:organisation, :postal_code,
                          :city, :country, :firstname, :lastname, :comments, :email, :department, :address, :title, 
                          :telephone, :forum)", $dbVal);
            $id = $DB->get_last_insert_id();
        }

        $subject = "New contact form submission";
        $message = "Email: ${params["email"]}\r\nComments:${dbVal["comments"]}";

        mail("patrick.minogue@gmail.com", $subject, $message);
		mail("info@hibis.com", $subject, $message);

        return $id;
    }

    public static function find($firstname, $lastname, $email)
    {
        global $DB;
        $rs = $DB->query("SELECT id FROM customers WHERE (firstname = ? AND lastname = ?) OR email = ?", array($firstname, $lastname, $email));

        return Utility::valid_or_null("id", $rs);
    }




}