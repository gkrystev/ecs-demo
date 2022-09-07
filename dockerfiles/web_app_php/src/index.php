<?php

/********* CONFIG ********/
$clusterEndpoint = getenv("RDS_HOST");
$clusterPort = getenv("RDS_PORT");
$clusterRegion = getenv("REGION");
$dbUsername = getenv("WEB_APP_DB_USERNAME");
$dbDatabase = getenv("WEB_APP_DBNAME");
/*************************/

// AWS-PHP-SDK installed via Composer
require 'vendor/autoload.php';

use Aws\Credentials\CredentialProvider;

$provider = CredentialProvider::defaultProvider();
$RdsAuthGenerator = new Aws\Rds\AuthTokenGenerator($provider);

$token = $RdsAuthGenerator->createToken($clusterEndpoint . ":" . $clusterPort, $clusterRegion, $dbUsername);

$mysqli = mysqli_init();

$mysqli->options(MYSQLI_READ_DEFAULT_FILE, "/etc/my.cnf");
$mysqli->options(MYSQLI_OPT_SSL_VERIFY_SERVER_CERT, true);
$mysqli->ssl_set(NULL, NULL, "/etc/ssl/certs/aws-global-bundle.pem", NULL, NULL);

$mysqli->real_connect($clusterEndpoint, $dbUsername, $token, $dbDatabase, $clusterPort, NULL, MYSQLI_CLIENT_SSL);

if ($mysqli->connect_errno) {
    echo "Error: Failed to make a MySQL connection, here is why: <br />";
    echo "Errno: " . $mysqli->connect_errno . "<br />";
    echo "Error: " . $mysqli->connect_error . "<br />";
    echo "Host: " . $clusterEndpoint . "<br />";
    echo "User: " . $dbUsername . "<br />";
    echo "Token: " . $token . "<br />";
    echo "Database: " . $dbDatabase . "<br />";
    echo "Port: " . $clusterPort . "<br />";
    exit;
}

/***** Example code to perform a query and return all tables in the DB *****/
$tableList = array();
$res = mysqli_query($mysqli,"SHOW DATABASES");
while($cRow = mysqli_fetch_array($res))
{
    $tableList[] = $cRow[0];
}
echo '<pre>';
print_r($tableList);
echo '</pre>';

