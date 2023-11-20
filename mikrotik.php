<?php
use PEAR2\Net\RouterOS;

register_menu("Router Monitor", true, "mikrotik_ui", 'AFTER_SETTINGS', 'ion ion-wifi');

function mikrotik_ui()
{
    global $ui,$routes;
    _admin();
    $ui->assign('_title', 'Mikrotik Router Monitor');
    $ui->assign('_system_menu', 'Router Monitor');
    $admin = Admin::_info();
    $ui->assign('_admin', $admin);
    $routers = ORM::for_table('tbl_routers')->where('enabled', '1')->find_many();
    $router = $routes['2'];
    if(empty($router)){
        $router = $routers[0]['id'];
    }
    $ui->assign('routers', $routers);
    $ui->assign('router', $router);
    $ui->display('mikrotik.tpl');
}

function mikrotik_get_wlan()
{
  global $routes;
  $router = $routes['2'];
  $mikrotik = ORM::for_table('tbl_routers')->where('enabled', '1')->find_one($router);
  $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
  $wlan = $client->sendSync(new RouterOS\Request('/interface/wireless/registration-table/print'));

    $signalList = [];
    foreach ($wlan as $signal) {
        $interface = $signal->getProperty('interface');
        $mac_address = $signal->getProperty('mac-address');
        $uptime = $signal->getProperty('uptime');
        $last_ip = $signal->getProperty('last-ip');
        $last_activity = $signal->getProperty('last-activity');
        $signal_strength = $signal->getProperty('signal-strength');
        $tx_ccq = $signal->getProperty('tx-ccq');
        $rx_ccq = $signal->getProperty('rx-ccq');
        $rx_rate = $signal->getProperty('rx-rate');
        $tx_rate = $signal->getProperty('tx-rate');


        $signalList[] = [
            'interface' => $interface,
            'mac_address' => $mac_address,
            'uptime' => $uptime,
            'last_ip' => $last_ip,
            'last_activity' => $last_activity,
            'signal_strength' => $signal_strength,
            'tx_ccq' => $tx_ccq,
            'rx_ccq' => $rx_ccq,
            'rx_rate' => $rx_rate,
            'tx_rate' => $tx_rate,
        ];
      }

      header('Content-Type: application/json');
      echo json_encode($signalList);
  }

function mikrotik_get_resources()
{
    global $routes;
    $router = $routes['2'];
    $mikrotik = ORM::for_table('tbl_routers')->where('enabled', '1')->find_one($router);
    $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
    $health = $client->sendSync(new RouterOS\Request('/system health print'));
    $res = $client->sendSync(new RouterOS\Request('/system resource print'));

    // Function to round the value and append the appropriate unit
    function mikrotik_formatSize($size)
    {
        $units = ['B', 'KB', 'MB', 'GB'];
        $unitIndex = 0;
        while ($size >= 1024 && $unitIndex < count($units) - 1) {
            $size /= 1024;
            $unitIndex++;
        }
        return round($size, 2) . ' ' . $units[$unitIndex];
    }

    $table = '
<table class="table table-condensed table-bordered">';
    $table .= '
	<tr>
		<th>Platform</th>
		<td>'.$res->getProperty('platform').'</td>
		<th>Board</th>
		<td>'.$res->getProperty('board-name').'</td>
		<th>Arch</th>
		<td>'.$res->getProperty('architecture-name').'</td>
		<th>Version</th>
		<td>'.$res->getProperty('version').'</td>
	</tr>';
    $table .= '
	<tr>
		<th>Uptime</th>
		<td>'.$res->getProperty('uptime').'</td>
		<th>Build time</th>
		<td>'.$res->getProperty('build-time').'</td>
		<th>Factory Software</th>
		<td>'.$res->getProperty('factory-software').'</td>
		<th>Volt</th>
		<td>'.$health->getProperty('voltage').'</td>
	</tr>';
    $table .= '
	<tr>
		<th>Mem used/free/total</th>
		<td>'.mikrotik_formatSize($res->getProperty('total-memory') - $res->getProperty('free-memory')).' / '.mikrotik_formatSize($res->getProperty('free-memory')).' / '.mikrotik_formatSize($res->getProperty('total-memory')).'</td>
		<th>CPU</th>
		<td>'.$res->getProperty('cpu').'</td>
		<th>CPU count/freq/load</th>
		<td>'.$res->getProperty('cpu-count').'/'.$res->getProperty('cpu-frequency').'/'.$res->getProperty('cpu-load').'</td>
		<th>Temp</th>
		<td>'.$health->getProperty('temperature').'</td>
	</tr>';
    $table .= '
	<tr>
		<th>Hdd</th>
		<td>'.mikrotik_formatSize($res->getProperty('free-hdd-space')).' / '.mikrotik_formatSize($res->getProperty('total-hdd-space')).'</td>
		<th>Bad Blocks</th>
		<td>'.$res->getProperty('bad-blocks').'</td>
		<th>Write Total</th>
		<td>'.$res->getProperty('write-sect-total').'</td>
		<th>Write Since Reboot</th>
		<td>'.$res->getProperty('write-sect-since-reboot').'</td>
	</tr>';
    $table .= '
</table>';
    echo $table;
}

function mikrotik_get_traffic()
{
    global $routes;
    $router = $routes['2'];
    $mikrotik = ORM::for_table('tbl_routers')->where('enabled', '1')->find_one($router);
    $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
    $traffic = $client->sendSync(new RouterOS\Request('/interface/print'));

    $interfaceData = [];
    foreach ($traffic as $interface) {
        $name = $interface->getProperty('name');
        // Skip interfaces with missing names
        if (empty($name)) {
            continue;
        }

        $txBytes = intval($interface->getProperty('tx-byte'));
        $rxBytes = intval($interface->getProperty('rx-byte'));

        $interfaceData[] = [
            'name' => $name,
            'status' => $interface->getProperty('running') === 'true' ? '
<small class="label bg-green">up</small>' : '
<small class="label bg-red">down</small>',
            'tx' => mikrotik_formatBytes($txBytes),
            'rx' => mikrotik_formatBytes($rxBytes)
        ];
    }

    header('Content-Type: application/json');
    echo json_encode($interfaceData);
}

// Function to format bytes into KB, MB, GB or TB
function mikrotik_formatBytes($bytes, $precision = 2)
{
    $units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    $bytes = max($bytes, 0);
    $pow = floor(($bytes ? log($bytes) : 0) / log(1024));
    $pow = min($pow, count($units) - 1);
    $bytes /= pow(1024, $pow);
    return round($bytes, $precision) . ' ' . $units[$pow];
}

function mikrotik_get_ppp_online_users()
{
    global $routes;
    $router = $routes['2'];
    $mikrotik = ORM::for_table('tbl_routers')->where('enabled', '1')->find_one($router);
    $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
    $pppUsers = $client->sendSync(new RouterOS\Request('/ppp/active/print'));

    $userList = [];
    foreach ($pppUsers as $pppUser) {
        $username = $pppUser->getProperty('name');
        $address = $pppUser->getProperty('address');
        $uptime = $pppUser->getProperty('uptime');
        $service = $pppUser->getProperty('service');
        $callerid = $pppUser->getProperty('caller-id');
        $bytes_in = $pppUser->getProperty('limit-bytes-in');
        $bytes_out = $pppUser->getProperty('limit-bytes-out');

        $userList[] = [
            'username' => $username,
            'address' => $address,
            'uptime' => $uptime,
            'service' => $service,
            'caller_id' => $callerid,
            'bytes_in' => $bytes_in,
            'bytes_out' => $bytes_out,
        ];
    }

    // Return the PPP online user list as JSON
    header('Content-Type: application/json');
    echo json_encode($userList);
}




function mikrotik_get_hotspot_online_users()
{
    global $routes;
    $router = $routes['2'];
    $mikrotik = ORM::for_table('tbl_routers')->where('enabled', '1')->find_one($router);
    $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);
    $hotspotActive = $client->sendSync(new RouterOS\Request('/ip/hotspot/active/print'));

    $hotspotList = [];
    foreach ($hotspotActive as $hotspot) {
        $username = $hotspot->getProperty('user');
        $address = $hotspot->getProperty('address');
        $uptime = $hotspot->getProperty('uptime');
        $server = $hotspot->getProperty('server');
        $mac = $hotspot->getProperty('mac-address');
        $sessionTime = $hotspot->getProperty('session-time-left');
        $rxBytes = $hotspot->getProperty('bytes-in');
        $txBytes = $hotspot->getProperty('bytes-out');

        $hotspotList[] = [
            'username' => $username,
            'address' => $address,
            'uptime' => $uptime,
            'server' => $server,
            'mac' => $mac,
            'session_time' => $sessionTime,
            'rx_bytes' => mikrotik_formatBytes($rxBytes),
            'tx_bytes' => mikrotik_formatBytes($txBytes),
            'total' => mikrotik_formatBytes($txBytes + $rxBytes),
        ];
    }

    // Return the Hotspot online user list as JSON
    header('Content-Type: application/json');
    echo json_encode($hotspotList);

}

function mikrotik_disconnect_online_user($router, $username, $userType)
{
  // Check if the form was submitted
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  // Retrieve the form data
  $router = $_POST['router'];
  $username = $_POST['username'];
  $userType = $_POST['userType'];

    $mikrotik = ORM::for_table('tbl_routers')->where('enabled', '1')->find_one($router);

    if (!$mikrotik) {
        // Handle the error response or redirection
        return;
    }

    try {
        $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);

        if ($userType == 'hotspot') {
            Mikrotik::removeHotspotActiveUser($client, $username);
            // Handle the success response or redirection
        } elseif ($userType == 'pppoe') {
            Mikrotik::removePpoeActive($client, $username);
            // Handle the success response or redirection
        } else {
            // Handle the error response or redirection
            return;
        }
    } catch (Exception $e) {
        // Handle the error response or redirection
    } finally {
        // Disconnect from the MikroTik router
        if (isset($client)) {
            $client->disconnect();
        }
    }
  }
}

function mikrotik_monitor_traffic()
{
    $interface  = $_GET["interface"];
    global $routes;
    $router = $routes['2'];
    $mikrotik = ORM::for_table('tbl_routers')->where('enabled', '1')->find_one($router);
    $client = Mikrotik::getClient($mikrotik['ip_address'], $mikrotik['username'], $mikrotik['password']);

    try {
        $results = $client->sendSync(
            (new RouterOS\Request('/interface/monitor-traffic'))
                ->setArgument('interface', $interface)
                ->setArgument('once', '')
        );

        $rows = array();
        $rows2 = array();
        $labels = array();

        foreach ($results as $result) {
            $ftx = $result->getProperty('tx-bits-per-second');
            $frx = $result->getProperty('rx-bits-per-second');

            $rows[] = $ftx;
            $rows2[] = $frx;
            $labels[] = date('H:i:s');
        }

        $result = array(
            'labels' => $labels,
            'rows' => array(
                'tx' => $rows,
                'rx' => $rows2
            )
        );
    } catch (Exception $e) {
        $result = array('error' => $e->getMessage());
    }

    // Return the result as JSON
    header('Content-Type: application/json');
    echo json_encode($result);
}
