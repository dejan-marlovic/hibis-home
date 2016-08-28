<?php

header('Accept-Charset: UTF-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Credentials: true');
header('Access-Control-Allow-Headers: authorization, content-type');

require_once(__DIR__ . '/../lib.hibis.com/messenger.php');
require_once(__DIR__ . '/../lib.hibis.com/database.php');
require_once(__DIR__ . '/../lib.hibis.com/utility.php');

global $DB;

$msg = Utility::valid_or_die($_POST["msg"], "msg");
$system = Utility::valid_or_die($_POST["system"], "system");
$params = Utility::valid_or_null("params", $_POST);
if (isset($params)) $params = json_decode($params, true);

if ($msg == "get_rows")
{
    $columns = Utility::valid_or_value("columns", $params, "*");
    $where = Utility::valid_or_value("where", $params, "1");
    $orderBy = Utility::valid_or_value("order_by", $params, "id");
    $limit = Utility::valid_or_value("limit", $params, "100");
    Messsenger::respond($DB->get_rows($system, $columns, $where, $orderBy, $limit), true);
}




Messsenger::respond($DB->get_rows("events", "*"), true);

