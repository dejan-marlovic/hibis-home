<?php

class Customers
{
    public static function parse($msg, $params)
    {
        switch ($msg)
        {
            case "add":
                return self::add($params);
                break;

            case "contact":
                return self::contact($params);
                break;

            case "find":
                return self::find
                (
                    Utility::valid_or_die($params["firstname"]),
                    Utility::valid_or_die($params["lastname"]),
                    Utility::valid_or_die($params["email"])
                );
                break;

            case "signup":
                return self::signup($params);
                break;
        }

        return null;
    }

    private static function add($params)
    {
        /// Required fields
        $dbVal["organisation"] = Utility::valid_or_die($params["organisation"], "organisation");
        $dbVal["zip"] = Utility::valid_or_die($params["postal_code"], "postal_code");
        $dbVal["city"] = Utility::valid_or_die($params["city"], "city");
        $dbVal["country"] = Utility::valid_or_die($params["country"], "country");
        $dbVal["street"] = Utility::valid_or_die($params["street"], "street");
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
            $DB->execute("UPDATE customers SET organisation = :organisation, street = :street, zip = :zip, city = :city,
                          country = :country, firstname = :firstname, lastname = :lastname, email = :email, comments = :comments, 
                          department = :department, address = :address, title = :title, telephone = :telephone, forum = :forum
                          WHERE id = :id", $dbVal);
        }
        else
        {
            $DB->execute("INSERT INTO customers (organisation, street, zip, city, country, firstname, lastname, comments,
                          email, department, address, title, telephone, forum) VALUES (:organisation, :street, :zip,
                          :city, :country, :firstname, :lastname, :comments, :email, :department, :address, :title, 
                          :telephone, :forum)", $dbVal);
            $id = $DB->get_last_insert_id();
        }
        return $id;
    }

    private static function contact($params)
    {
        $id = self::add($params);

        $subject = "New contact form submission";
        $message = "Email: ${params["email"]}\r\nComments:${$params["comments"]}";

        mail("patrick.minogue@gmail.com", $subject, $message);
		mail("fraud.academy@hibis.com", $subject, $message);

        return $id;
    }

    public static function find($firstname, $lastname, $email)
    {
        global $DB;
        $rs = $DB->query("SELECT id FROM customers WHERE (firstname = ? AND lastname = ?) OR email = ?", array($firstname, $lastname, $email));

        return Utility::valid_or_null("id", $rs);
    }

    private static function signup($params)
    {
        echo "WTF";
        global $DB;
        $id = self::add($params);

        $DB->execute("INSERT INTO bookings (event_id, customer_id, payment_reference) VALUES (?, ?, ?)",
            array($params["event_id"], $id, $params["payment_reference"]));

        return $DB->get_last_insert_id();
    }
}
