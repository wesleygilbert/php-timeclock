<?php

/*
 * Compatibility helpers for modern PHP runtimes.
 * The application still contains calls from PHP 4/5 era extensions; these
 * wrappers keep that code working while the rest of the mysqli migration
 * remains incremental.
 */

if (!function_exists('timeclock_mysqli_link')) {
    function timeclock_mysqli_link() {
        global $db, $db_hostname, $db_username, $db_password, $db_name;

        if (isset($db) && $db instanceof mysqli) {
            return $db;
        }

        if (isset($db_hostname, $db_username, $db_password, $db_name)) {
            $db = mysqli_connect($db_hostname, $db_username, $db_password);
            if ($db) {
                mysqli_select_db($db, $db_name);
            }
            return $db;
        }

        return null;
    }
}

if (function_exists('mysqli_report')) {
    mysqli_report(MYSQLI_REPORT_OFF);
}

if (!function_exists('mysql_connect')) {
    function mysql_connect($server = null, $username = null, $password = null) {
        global $db, $db_hostname, $db_username, $db_password, $db_name;

        $server = $server === null ? $db_hostname : $server;
        $username = $username === null ? $db_username : $username;
        $password = $password === null ? $db_password : $password;

        $db = mysqli_connect($server, $username, $password);
        if ($db && isset($db_name)) {
            mysqli_select_db($db, $db_name);
        }

        return $db;
    }
}

if (!function_exists('mysql_select_db')) {
    function mysql_select_db($database_name, $link_identifier = null) {
        $link = $link_identifier ?: timeclock_mysqli_link();
        return $link ? mysqli_select_db($link, $database_name) : false;
    }
}

if (!function_exists('mysql_query')) {
    function mysql_query($query, $link_identifier = null) {
        $link = $link_identifier ?: timeclock_mysqli_link();
        return $link ? mysqli_query($link, $query) : false;
    }
}

if (!function_exists('mysql_real_escape_string')) {
    function mysql_real_escape_string($string, $link_identifier = null) {
        $link = $link_identifier ?: timeclock_mysqli_link();
        return $link ? mysqli_real_escape_string($link, (string)$string) : addslashes((string)$string);
    }
}

if (!function_exists('mysql_error')) {
    function mysql_error($link_identifier = null) {
        $link = $link_identifier ?: timeclock_mysqli_link();
        return $link ? mysqli_error($link) : '';
    }
}

if (!function_exists('mysql_affected_rows')) {
    function mysql_affected_rows($link_identifier = null) {
        $link = $link_identifier ?: timeclock_mysqli_link();
        return $link ? mysqli_affected_rows($link) : -1;
    }
}

if (!function_exists('mysql_fetch_row')) {
    function mysql_fetch_row($result) {
        return mysqli_fetch_row($result);
    }
}

if (!function_exists('mysql_fetch_assoc')) {
    function mysql_fetch_assoc($result) {
        return mysqli_fetch_assoc($result);
    }
}

if (!function_exists('mysql_fetch_array')) {
    function mysql_fetch_array($result, $result_type = MYSQLI_BOTH) {
        return mysqli_fetch_array($result, $result_type);
    }
}

if (!function_exists('mysql_result')) {
    function mysql_result($result, $row, $field = 0) {
        if (!$result || !mysqli_data_seek($result, $row)) {
            return false;
        }

        $data = mysqli_fetch_array($result, MYSQLI_BOTH);
        return isset($data[$field]) ? $data[$field] : false;
    }
}

if (!function_exists('get_magic_quotes_gpc')) {
    function get_magic_quotes_gpc() {
        return false;
    }
}

if (!function_exists('set_magic_quotes_runtime')) {
    function set_magic_quotes_runtime($new_setting) {
        return false;
    }
}

if (!function_exists('ereg')) {
    function ereg($pattern, $string, &$regs = null) {
        $regex = '~' . str_replace('~', '\~', $pattern) . '~';
        $matched = preg_match($regex, (string)$string, $matches);
        if ($matched && func_num_args() >= 3) {
            $regs = $matches;
        }

        return $matched;
    }
}

if (!function_exists('split')) {
    function split($pattern, $string, $limit = -1) {
        $regex = '~' . str_replace('~', '\~', $pattern) . '~';
        return preg_split($regex, (string)$string, $limit);
    }
}

?>
