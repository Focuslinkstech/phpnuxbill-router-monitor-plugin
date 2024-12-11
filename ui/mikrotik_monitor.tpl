{include file="sections/header.tpl"}
<style>
    /* Styles for overall layout and responsiveness */
    body {
        background-color: #f8f9fa;
        font-family: 'Arial', sans-serif;
    }

    .container {
        margin-top: 20px;
        background-color: #d8dfe5;
        border-radius: 8px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        padding: 20px;
        max-width: 98%;
        flex-wrap: wrap;
        justify-content: space-between;
        align-items: center;
    }

    /* Styles for table and pagination */
    .table {
        width: 100%;
        margin-bottom: 1rem;
        background-color: #fff;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    .table th {
        vertical-align: middle;
        border-color: #dee2e6;
        background-color: #343a40;
        color: #fff;
    }

    .table td {
        vertical-align: middle;
        border-color: #dee2e6;
    }

    .table-striped tbody tr:nth-of-type(odd) {
        background-color: rgba(0, 0, 0, 0.05);
    }

    .dataTables_length,
    .dataTables_filter {
        margin-bottom: 20px;
    }

    .form-control {
        border-radius: 4px;
    }

    .pagination {
        justify-content: center;
        margin-top: 20px;
    }

    .pagination .page-item .page-link {
        color: #007bff;
        background-color: #fff;
        border: 1px solid #dee2e6;
        margin: 0 2px;
        padding: 6px 12px;
        transition: background-color 0.3s, color 0.3s;
    }

    .pagination .page-item .page-link:hover {
        background-color: #e9ecef;
        color: #0056b3;
    }

    .pagination .page-item.active .page-link {
        z-index: 1;
        color: #fff;
        background-color: #007bff;
        border-color: #007bff;
    }

    .pagination-container {
        display: flex;
        justify-content: center;
        margin-top: 20px;
    }

    /* Styles for log message badges */
    .badge {
        padding: 6px 12px;
        font-size: 12px;
        font-weight: 700;
        text-transform: uppercase;
        border-radius: 4px;
        transition: background-color 0.3s, color 0.3s;
    }

    .badge-danger {
        color: #721c24;
        background-color: #f8d7da;
    }

    .badge-success {
        color: #155724;
        background-color: #d4edda;
    }

    .badge-warning {
        color: #856404;
        background-color: #ffeeba;
    }

    .badge-info {
        color: #0c5460;
        background-color: #d1ecf1;
    }

    .badge:hover {
        opacity: 0.8;
    }

    @media screen and (max-width: 600px) {
        .container {
            overflow-x: auto;
        }
    }
</style>
<div class="box-body table-responsive no-padding">
    <div class="col-sm-12 col-md-12">
        <form class="form-horizontal" method="post" role="form" action="{$_url}plugin/mikrotik_monitor_ui">
            <ul class="nav nav-tabs"> {foreach $routers as $r} <li role="presentation" {if
                    $r['id']==$router}class="active" {/if}> <a
                        href="{$_url}plugin/mikrotik_monitor_ui/{$r['id']}">{$r['name']}</a>
                </li> {/foreach} </ul>
        </form>
        <div class="panel">
            <div class="table-responsive" api-get-text="{$_url}plugin/mikrotik_monitor_get_resources/{$router}">
                <center>
                    <br>
                    <br>
                    <img src="ui/ui/images/loading.gif">
                    <br>
                    <br>
                    <br>
                </center>
            </div>
            <!-- Progress Bars -->
            <div class="column-card-container" id="progress-bars">
                <!-- CPU Load Progress Bar -->
                <div class="column-card" id="cpu-load-bar">
                    <div class="column-card-header_progres">{Lang::T('CPU Load')}</div>
                    <div class="progress" style="height: 20px;">
                        <div class="progress-bar bg-success progress-animated" role="progressbar"
                            style="width: 0%; background-color: #5cb85c">0%</div>
                    </div>
                </div>
                <!-- Temperature Progress Bar -->
                <div class="column-card" id="temperature-bar">
                    <div class="column-card-header_progres">{Lang::T('Temperature')}</div>
                    <div class="progress" style="height: 20px;">
                        <div class="progress-bar bg-info progress-animated" role="progressbar"
                            style="width: 0%; background-color: #5cb85c">0°C</div>
                    </div>
                </div>
                <!-- Voltage Progress Bar -->
                <div class="column-card" id="voltage-bar">
                    <div class="column-card-header_progres">{Lang::T('Voltage')}</div>
                    <div class="progress" style="height: 20px;">
                        <div class="progress-bar bg-primary progress-animated" role="progressbar"
                            style="width: 0%; background-color: #5cb85c">0 V</div>
                    </div>
                </div>
            </div>
            <!-- End of Progress Bars -->
        </div>
        <div class="table-responsive">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <li class="active">
                        <a href="#tab_4" data-toggle="tab">{Lang::T('Wireless Status')}</a>
                    </li>
                    <li>
                        <a href="#tab_1" data-toggle="tab">{Lang::T('Interface Status')}</a>
                    </li>
                    <li>
                        <a href="#tab_2" data-toggle="tab">{Lang::T('Hotspot Online Users')}</a>
                    </li>
                    <li>
                        <a href="#tab_3" data-toggle="tab">{Lang::T('PPPoE Online Users')}</a>
                    </li>
                    <li>
                        <a href="#tab_5" data-toggle="tab">{Lang::T('Traffic Monitor')}</a>
                    </li>
                    <li>
                        <a href="#tab_6" data-toggle="tab">{Lang::T('Logs')}</a>
                    </li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane" id="tab_1">
                        <div class="box-body no-padding" id="">
                            <div class="table-responsive">
                                <div id="logsys-mikrotik" class="container">
                                    <div class="row">
                                        <table id="traffic-table" class="table table-bordered table-striped">
                                            <thead class="thead-dark">
                                                <tr>
                                                    <th>{Lang::T('Interface Name')}</th>
                                                    <th>{Lang::T('Tx (bytes Out)')}</th>
                                                    <th>{Lang::T('Rx (bytes In)')}</th>
                                                    <th>{Lang::T('Total Usage')}</th>
                                                    <th>{Lang::T('Status')}</th>
                                                </tr>
                                            </thead>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- /.tab-pane -->
                    <div class="tab-pane" id="tab_2">
                        <div class="box-body no-padding" id="">
                            <div class="table-responsive">
                                <div id="logsys-mikrotik" class="container">
                                    <div class="row">
                                        <table class="table table-bordered table-striped" id="hotspot-table">
                                            <thead class="thead-dark">
                                                <tr>
                                                    <th>{Lang::T('Username')}</th>
                                                    <th>{Lang::T('IP Address')}</th>
                                                    <th>{Lang::T('Uptime')}</th>
                                                    <th>{Lang::T('Server')}</th>
                                                    <th>{Lang::T('Mac Address')}</th>
                                                    <th>{Lang::T('Session Time Left')}</th>
                                                    <th>{Lang::T('Upload (RX)')}</th>
                                                    <th>{Lang::T('Download (TX)')}</th>
                                                    <th>{Lang::T('Total Usage')}</th>
                                                    <!--  <th>Action</th>  -->
                                                </tr>
                                            </thead>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- /.tab-pane -->
                    <div style="overflow-x:auto;" class="tab-pane" id="tab_3">
                        <div class="box-body no-padding" id="">
                            <div class="table-responsive">
                                <div id="logsys-mikrotik" class="container">
                                    <div class="row">
                                        <table class="table table-bordered table-striped" id="ppp-table">
                                            <thead class="thead-dark">
                                                <tr>
                                                    <th>{Lang::T('Username')}</th>
                                                    <th>{Lang::T('IP Address')}</th>
                                                    <th>{Lang::T('Uptime')}</th>
                                                    <th>{Lang::T('Service')}</th>
                                                    <th>{Lang::T('Caller ID')}</th>
                                                    <th>{Lang::T('Download')}</th>
                                                    <th>{Lang::T('Upload')}</th>
                                                    <th>{Lang::T('Total Usage')}</th>
                                                </tr>
                                            </thead>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane" id="tab_4">
                        <div class="box-body no-padding" id="">
                            <div class="table-responsive">
                                <div id="logsys-mikrotik" class="container">
                                    <div class="row">
                                        <table class="table table-bordered table-striped" id="signal-table">
                                            <thead class="thead-dark">
                                                <tr>
                                                    <th>{Lang::T('Interface')}</th>
                                                    <th>{Lang::T('Mac Address')}</th>
                                                    <th>{Lang::T('Uptime')}</th>
                                                    <th>{Lang::T('Last Ip')}</th>
                                                    <th>{Lang::T('Last Activity')}</th>
                                                    <th>{Lang::T('Signal Strength')}</th>
                                                    <th>{Lang::T('Tx / Rx CCQ')}</th>
                                                    <th>{Lang::T('Rx Rate')}</th>
                                                    <th>{Lang::T('Tx Rate')}</th>
                                                </tr>
                                            </thead>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="tab-pane" id="tab_5">
                        <div class="box-body no-padding" id="">
                            <div class="table-responsive">
                                <div id="logsys-mikrotik" class="container">
                                    <div class="row">
                                        <table class="table table-bordered table-striped">
                                            <thead class="thead-dark">
                                                <th>{Lang::T('Interace')}</th>
                                                <th>{Lang::T('TX')}</th>
                                                <th>{Lang::T('RX')}</th>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <select name="interface" id="interface">
                                                            {foreach from=$interfaces item=interface}
                                                            <option value="{$interface}">{$interface}
                                                            </option>
                                                            {/foreach}
                                                        </select>
                                                    </td>
                                                    <td>
                                                        <div id="tabletx"></div>
                                                    </td>
                                                    <td>
                                                        <div id="tablerx"></div>
                                                    </td>
                                                </tr>
                                        </table>
                                        <canvas id="chart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane" id="tab_6">
                        <div class="box-body no-padding" id="">
                            <div class="table-responsive">
                                <div id="logsys-mikrotik" class="container">
                                    <div class="row">
                                        <table id="logTable" class="table table-bordered table-striped">
                                            <thead class="thead-dark">
                                                <tr>
                                                    <th>{Lang::T('Date/Time')}</th>
                                                    <th>{Lang::T('Topic')}</th>
                                                    <th>{Lang::T('Message')}</th>
                                                </tr>
                                            </thead>
                                            <tbody id="logTableBody">
                                                <!-- Table rows will be populated here -->
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
            <script src="https://cdn.datatables.net/1.11.3/js/jquery.dataTables.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            <script>

            </script>
            <script>
                var $j = jQuery.noConflict(); // Use $j as an alternative to $

                function fetchData() {
                    return $j.ajax({
                        url: '{$_url}plugin/mikrotik_monitor_get_resources_json{$routes}', // Ganti dengan URL yang sesuai untuk mendapatkan data real-time
                        method: 'GET',
                        dataType: 'json',
                        success: function (data) {
                            $j('#cpu-load-bar .progress-bar').css('width', data.cpu_load + '%').text(data.cpu_load + '%');
                            $j('#temperature-bar .progress-bar').css('width', data.temperature + '%').text(data.temperature + '°C');
                            $j('#voltage-bar .progress-bar').css('width', data.voltage + '%').text(data.voltage + ' V');
                        },
                        error: function (xhr, status, error) {
                            console.error('AJAX Error:', error);
                        }
                    });
                }

                function fetchTrafficData() {
                    return $j.ajax({
                        url: '{$_url}plugin/mikrotik_monitor_get_traffic/{$router}',
                        method: 'GET',
                        success: function (response) {
                            $j('#traffic-table').DataTable().clear().rows.add(response).draw();
                        },
                        error: function (xhr, error, thrown) {
                            console.log('AJAX error:', error);
                        }
                    });
                }

                function fetchUserListData() {
                    var table = $j('#ppp-table').DataTable({
                        columns: [
                            { data: 'username' },
                            { data: 'address' },
                            { data: 'uptime' },
                            { data: 'service' },
                            { data: 'caller_id' },
                            { data: 'tx' },
                            { data: 'rx' },
                            { data: 'total' },
                        ]
                    });
                    return $j.ajax({
                        url: '{$_url}plugin/mikrotik_monitor_get_ppp_online_users/{$router}',
                        method: 'GET',
                        success: function (response) {
                            table.clear().rows.add(response).draw();
                        },
                        error: function (xhr, error, thrown) {
                            console.log('AJAX error:', error);
                        },
                    });
                }

                function fetchHotspotListData() {
                    var table = $j('#hotspot-table').DataTable({
                        columns: [
                            { data: 'username' },
                            { data: 'address' },
                            { data: 'uptime' },
                            { data: 'server' },
                            { data: 'mac' },
                            { data: 'session_time' },
                            { data: 'tx_bytes' },
                            { data: 'rx_bytes' },
                            { data: 'total' },
                        ]
                    });
                    return $j.ajax({
                        url: '{$_url}plugin/mikrotik_monitor_get_hotspot_online_users/{$router}',
                        method: 'GET',
                        success: function (response) {
                            table.clear().rows.add(response).draw();
                        },
                        error: function (xhr, error, thrown) {
                            console.log('AJAX error:', error);
                        },
                    });
                }

                function fetchSignalListData() {
                    var table = $j('#signal-table').DataTable({
                        columns: [
                            { data: 'interface' },
                            { data: 'mac_address' },
                            { data: 'uptime' },
                            { data: 'last_ip' },
                            { data: 'last_activity' },
                            { data: 'signal_strength' },
                            { data: 'tx_ccq' },
                            { data: 'rx_rate' },
                            { data: 'tx_rate' }
                        ]
                    });
                    return $j.ajax({
                        url: '{$_url}plugin/mikrotik_monitor_get_wlan/{$router}',
                        method: 'GET',
                        success: function (response) {
                            table.clear().rows.add(response).draw();
                        },
                        error: function (xhr, error, thrown) {
                            console.log('AJAX error:', error);
                        }
                    });
                }

                function disconnectUser(username) {
                    console.log('Disconnect user:', username);
                }

                var chart;
                var chartData = {
                    labels: [],
                    txData: [],
                    rxData: []
                };

                function createChart() {
                    var ctx = document.getElementById('chart').getContext('2d');
                    chart = new Chart(ctx, {
                        type: 'line',
                        data: {
                            labels: chartData.labels,
                            datasets: [{
                                label: 'TX',
                                data: chartData.txData,
                                backgroundColor: 'rgba(54, 162, 235, 0.5)',
                                borderColor: 'rgba(54, 162, 235, 1)',
                                borderWidth: 0,
                                tension: 0.4,
                                fill: 'start'
                            },
                            {
                                label: 'RX',
                                data: chartData.rxData,
                                backgroundColor: 'rgba(255, 99, 132, 0.5)',
                                borderColor: 'rgba(255, 99, 132, 1)',
                                borderWidth: 0,
                                tension: 0.4,
                                fill: 'start'
                            }
                            ]
                        },
                        options: {
                            responsive: true,
                            scales: {
                                x: {
                                    display: true,
                                    title: {
                                        display: true,
                                        text: 'Time'
                                    }
                                },
                                y: {
                                    display: true,
                                    title: {
                                        display: true,
                                        text: 'Live Traffic'
                                    },
                                    ticks: {
                                        callback: function (value) {
                                            return formatBytes(value);
                                        }
                                    }
                                }
                            },
                            plugins: {
                                tooltip: {
                                    callbacks: {
                                        label: function (context) {
                                            var label = context.dataset.label || '';
                                            var value = context.parsed.y || 0;
                                            return label + ': ' + formatBytes(value) + 'ps';
                                        }
                                    }
                                }
                            },
                            elements: {
                                point: {
                                    radius: 0,
                                    hoverRadius: 0
                                },
                                line: {
                                    tension: 0
                                }
                            }
                        }
                    });
                }

                function formatBytes(bytes) {
                    if (bytes === 0) return '0 B';
                    var k = 1024;
                    var sizes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
                    var i = Math.floor(Math.log(bytes) / Math.log(k));
                    var formattedValue = parseFloat((bytes / Math.pow(k, i)).toFixed(2));
                    return formattedValue + ' ' + sizes[i];
                }

                function updateTrafficValues() {
                    var interface = $j('#interface').val();
                    $j.ajax({
                        url: '{$_url}plugin/mikrotik_monitor_traffic_update/{$router}',
                        dataType: 'json',
                        data: {
                            interface: interface
                        },
                        success: function (data) {
                            var labels = data.labels;
                            var txData = data.rows.tx;
                            var rxData = data.rows.rx;
                            if (txData.length > 0 && rxData.length > 0) {
                                var TX = parseInt(txData[0]);
                                var RX = parseInt(rxData[0]);
                                chartData.labels.push(labels[0]);
                                chartData.txData.push(TX);
                                chartData.rxData.push(RX);
                                var maxDataPoints = 10;
                                if (chartData.labels.length > maxDataPoints) {
                                    chartData.labels.shift();
                                    chartData.txData.shift();
                                    chartData.rxData.shift();
                                }
                                chart.update();
                                document.getElementById("tabletx").textContent = formatBytes(TX);
                                document.getElementById("tablerx").textContent = formatBytes(RX);
                            } else {
                                document.getElementById("tabletx").textContent = "0";
                                document.getElementById("tablerx").textContent = "0";
                            }
                        },
                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                            console.error("Status: " + textStatus + " request: " + XMLHttpRequest);
                            console.error("Error: " + errorThrown);
                        }
                    });
                }

                function startRefresh() {
                    setInterval(updateTrafficValues, 2000);
                }

                $j(document).ready(function () {
                    $j('#traffic-table').DataTable({
                        columns: [
                            { data: 'name' },
                            { data: 'tx' },
                            { data: 'rx' },
                            { data: 'total' },
                            { data: 'status' }
                        ]
                    });

                    fetchData()
                        .then(fetchTrafficData)
                        .then(fetchUserListData)
                        .then(fetchHotspotListData)
                        .then(fetchSignalListData)
                        .then(fetchLogs)
                        .then(function () {
                            createChart();
                            startRefresh();
                            $j('#interface').on('input', function () {
                                updateTrafficValues();
                            });
                        });
                });
            </script>
            <script>
                window.addEventListener('DOMContentLoaded', function () {
                    var portalLink = "https://github.com/focuslinkstech";
                    $('#version').html('MikroTik Monitor | Ver: 3.0 | by: <a href="' + portalLink + '">Focuslinks Tech</a>');
                });
            </script>

            <script>
                var $j = jQuery.noConflict();

                async function fetchLogs() {
                    const logTableBody = $j('#logTableBody');
                    logTableBody.empty();

                    try {
                        // Fetch logs from the API
                        const response = await fetch('{$_url}plugin/mikrotik_monitor_getLogs&routerId={$router}');
                        if (!response.ok) {
                            throw new Error('Network response was not ok: ' + response.statusText);
                        }

                        const logs = await response.json();
                        console.log(logs);

                        logs.reverse().forEach(log => {
                            const row = document.createElement('tr');
                            row.classList.add('log-entry');

                            // Create date/time cell
                            const timeCell = document.createElement('td');
                            timeCell.textContent = log.time || 'N/A';
                            row.appendChild(timeCell);

                            // Create topic cell
                            const topicCell = document.createElement('td');
                            topicCell.textContent = log.topics || 'N/A';
                            row.appendChild(topicCell);

                            // Create message cell with badge
                            const messageCell = document.createElement('td');
                            const messageBadge = document.createElement('span');
                            messageBadge.classList.add('badge');

                            // Use a safe check for the message
                            const message = log.message || 'No message available';
                            const messageLower = message.toLowerCase();

                            if (messageLower.includes('failed')) {
                                messageBadge.classList.add('badge-danger');
                                messageBadge.textContent = 'Error';
                            } else if (messageLower.includes('trying')) {
                                messageBadge.classList.add('badge-warning');
                                messageBadge.textContent = 'Warning';
                            } else if (messageLower.includes('logged in')) {
                                messageBadge.classList.add('badge-success');
                                messageBadge.textContent = 'Success';
                            } else if (messageLower.includes('login failed')) {
                                messageBadge.classList.add('badge-info');
                                messageBadge.textContent = 'Login Info';
                            } else {
                                messageBadge.classList.add('badge-info');
                                messageBadge.textContent = 'Info';
                            }

                            messageCell.appendChild(messageBadge);
                            messageCell.appendChild(document.createTextNode(' ' + message));
                            row.appendChild(messageCell);
                            logTableBody.append(row);
                        });

                        // Destroy existing DataTable instance if it exists
                        if ($j.fn.DataTable.isDataTable('#logTable')) {
                            $j('#logTable').DataTable().destroy();
                        }

                        // Reinitialize DataTable
                        $j('#logTable').DataTable({
                            "pagingType": "full_numbers",
                            "order": [
                                [0, 'desc']
                            ]
                        });

                    } catch (error) {
                        console.error('Error fetching logs:', error);
                    }
                }
            </script>

            {include file="sections/footer.tpl"}