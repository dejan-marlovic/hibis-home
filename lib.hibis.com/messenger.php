<?php

class Messsenger
{
    public static function respond($result, $success, $extra = null)
    {
        $response["result"] = $result;
        $response["success"] = $success;
        if (isset($extra)) $response["extra"] = $extra;
        die(json_encode($response));
    }
}