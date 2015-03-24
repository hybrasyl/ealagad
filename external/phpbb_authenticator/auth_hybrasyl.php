<?php

/**
 * Hybrasyl authentication module for phpBB3
 *
 * @package login
 * @version 0.1
 * @copyright (c) 2014 Justin Baugh / Project Hybrasyl
 * @license http://opensource.org/license/gpl-license.php GNU Public License v2
 *
 */

if (!defined('IN_PHPBB'))
{
    exit;
}

function get_account_info($playername)
{
    $curl = get_curl_resource();

    if (!$curl)
    {
        return false;
    }

    $reqdata = array(
        'username' => urlencode($username),
        'password' => urlencode($password)
    );

    $reqdata_string = json_encode($reqdata);

    $apiurl = "https://www.hybrasyl.com/api/v1/info/player";
    curl_setopt($curl, CURLOPT_URL, $apiurl);
    curl_setopt($curl, CURLOPT_CUSTOMREQUEST, 'POST');
    curl_setopt($curl, CURLOPT_POSTFIELDS, $reqdata_string);

    $result = trim(curl_exec($curl));
    curl_close($curl);

    $jsonresult = json_decode($result, true);

    if ($jsonresult != false && $jsonresult['Success'] == true)
    {
        return false;
    }

    return true;

}

function auth_hybrasyl($username, $password)
{
    $curl = get_curl_resource();
    if (!$curl)
    {
        return false;
    }

    $reqdata = array(
        'username' => urlencode($username),
        'password' => urlencode($password)
    );
    $reqdata_string = json_encode($reqdata);

    $apiurl = "https://www.hybrasyl.com/api/v1/login/player";
    curl_setopt($curl, CURLOPT_URL, $apiurl);
    curl_setopt($curl, CURLOPT_CUSTOMREQUEST, 'POST');
    curl_setopt($curl, CURLOPT_POSTFIELDS, $reqdata_string);

    $result = trim(curl_exec($curl));
    curl_close($curl);

    $jsonresult = json_decode($result, true);

    if ($jsonresult != false && $jsonresult['Success'] == true)
    {
        return false;
    }

    return true;

}

function get_curl_resource()
{
    $API_TOKEN= "";
    $headers = array(
        'Content-type: application/json',
        "Authorization: Token token=\"$API_TOKEN\"");

    $curl = curl_init();

    curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($curl, CURLOPT_TIMEOUT, 5);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
    return $curl;
}

function init_hybrasyl()
{
    $curl = curl_get_resource();
    if (!$curl)
    {
        return false;
    }

    $apiurl = "https://www.hybrasyl.com/api/v1/status";
    curl_setopt($curl, CURLOPT_URL, $apiurl);

    $result = trim(curl_exec($curl));
    curl_close($curl);

    $jsonresult = json_decode($result, true);

    if ($jsonresult != false && $jsonresult['Status'] == 'Active')
    {
        return false;
    }
    return "ERROR: Couldn't authenticate to Hybrasyl API. Check to ensure the API token is correct";

}

function login_hybrasyl(&$username, &$password)
{
    global $db, $user;

    if (!$password)
    {
        return array(
            'status' => LOGIN_ERROR_PASSWORD,
            'error_msg' => 'NO_PASSWORD_SUPPLIED',
            'user_row' => array('user_id' => ANONYMOUS),
        );
    }

    if (!$username)
    {
        return array(
            'status' => LOGIN_ERROR_USERNAME,
            'error_msg' => 'LOGIN_ERROR_USERNAME',
            'user_row' => array('user_id' => ANONYMOUS),
        );
    }

    if (!@extension_loaded('curl'))
    {
        return array(
            'status' => LOGIN_ERROR_EXTERNAL_AUTH,
            'error_msg' => 'CURL extension is not loaded.',
            'user_row' => array('user_id' => ANONYMOUS),
        );
    }

    $curl = get_curl_resource();

    if (!$curl)
    {
        return array(
            'status' => LOGIN_ERROR_EXTERNAL_AUTH,
            'error_msg' => 'CURL resource could not be created. Unknown error.',
            'user_row' => array('user_id' => ANONYMOUS),
        );

    }

    if (auth_hybrasyl($username, $password))
    {
        // Authentication was successful
        @ldap_close($ldap);

        $sql ='SELECT user_id, username, user_password, user_passchg, user_email, user_type FROM ' . 
            USERS_TABLE . "WHERE username_clean = '" . $db->sql_escape(utf8_clean_string($username)) . "'";
        $result = $db->sql_query($sql);
        $row = $db->sql_fetchrow($result);
        $db->sql_freeresult($result);

        if ($row)
        {
            // Handle inactive user
            if ($row['user_type'] == USER_INACTIVE || $row['user_type'] == USER_IGNORE)
            {
                return array(
                    'status'                => LOGIN_ERROR_ACTIVE,
                    'error_msg'             => 'ACTIVE_ERROR',
                    'user_row'              => $row,
                );
            }

            // Successful login... set user_login_attempts to zero...
            return array(
                'status'                => LOGIN_SUCCESS,
                'error_msg'             => false,
                'user_row'              => $row,
            );

        }
        else
        {
            // User is new
            // retrieve default group id
            $sql = 'SELECT group_id FROM ' .
                GROUPS_TABLE . "WHERE group_name = '" . $db->sql_escape('REGISTERED') .
                "' AND group_type = " . GROUP_SPECIAL;
            $result = $db->sql_query($sql);
            $row = $db->sql_fetchrow($result);
            $db->sql_freeresult($result);

            if (!$row)
            {
                trigger_error('NO_GROUP');
            }

            // generate user account data - first time login
            $ldap_user_row = array(
                'username'              => $username,
                'user_password' => phpbb_hash($password),
                'user_email'    => (!empty($config['ldap_email'])) ? utf8_htmlspecialchars($ldap_result[0][htmlspecialchars_decode($confi \
                                                                                                                                   g['ldap_email'])][0]) : '',
                'group_id'              => (int) $row['group_id'],
                                    'user_type'             => USER_NORMAL,
                'user_ip'               => $user->ip,
                'user_new'              => ($config['new_member_post_limit']) ? 1 : 0,
            );

        }

    }
    else
    {
        // Authentication failed
    }