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
        $properties["icon"] = Utility::valid_or_null("icon", $properties);

        $pdfFile = Utility::valid_or_null("pdf", $properties);
        unset($properties["pdf"]);

        $DB->execute("INSERT INTO publications (name, publisher, date, brief, url_info, url_publisher, icon) 
                      VALUES (:name, :publisher, :date, :brief, :url_info, :url_publisher, :icon)", $properties);

        if (isset($pdfFile))
        {
            $targetDir = __DIR__ . '/../public_html/academy/pdf/';
            $targetFile = $targetDir . basename($pdfFile);
            $fileType = pathinfo($targetFile, PATHINFO_EXTENSION);
            if ($fileType != "pdf") Messenger::respond("invalid_file_type ($fileType)", false);

            move_uploaded_file($pdfFile, $targetFile);
            Messenger::respond("file_uploaded", true, $pdfFile);
        }
    }

    private static function delete($id)
    {
        global $DB;
        $DB->execute("DELETE FROM publications WHERE id = ?", array($id));
    }


    private static function update($id, $column, $value)
    {
        global $DB;
        if ($column == "pdf")
        {
            $value = substr($value, strlen("data:application/pdf;base64,"));
            $pdf_decoded = base64_decode($value);
            //Write data back to pdf file
            $pdf = fopen(__DIR__ . '/../public_html/academy/pdf/publication-' . $id . '.pdf','w');
            fwrite($pdf, $pdf_decoded);
            fclose($pdf);
            $DB->execute("UPDATE publications SET url_pdf = ? WHERE id = ?", array("http://fraudacademy.hibis.com/pdf/publication-$id.pdf", $id));

            Messenger::respond("file_uploaded", true);
        }

        else
        {
            $DB->execute("UPDATE publications SET $column = ? WHERE id = ?", array($value, $id));
        }
    }
}