<?php

class Utility
{
    public static function valid_or_null($key, $in_array)
    {
        if (isset($in_array[$key])) return $in_array[$key];
        else return null;
    }

    public static function valid_or_value($key, $in_array, $value)
    {
        if (isset($in_array[$key])) return $in_array[$key];
        else return $value;
    }

    public static function valid_or_die($param, $param_name = null)
    {
        require_once(__DIR__ . '/messenger.php');
        isset($param) or Messsenger::respond("Required parameter missing", false, $param_name);
        return $param;
    }
}