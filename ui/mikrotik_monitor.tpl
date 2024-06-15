{include file="sections/header.tpl"}
<div class="box-body table-responsive no-padding">
  <div class="col-sm-12 col-md-12">
    <form class="form-horizontal" method="post" role="form" action="{$_url}plugin/mikrotik_monitor_ui">
      <ul class="nav nav-tabs"> {foreach $routers as $r} <li role="presentation" {if $r['id']==$router}class="active" {/if}>
          <a href="{$_url}plugin/mikrotik_monitor_ui/{$r['id']}">{$r['name']}</a>
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
        <div class="column-card-header_progres">CPU Load</div>
        <div class="progress" style="height: 20px;">
            <div class="progress-bar bg-success progress-animated" role="progressbar" style="width: 0%; background-color: #5cb85c">0%</div>
        </div>
    </div>
    <!-- Temperature Progress Bar -->
    <div class="column-card" id="temperature-bar">
        <div class="column-card-header_progres">Temperature</div>
        <div class="progress" style="height: 20px;">
            <div class="progress-bar bg-info progress-animated" role="progressbar" style="width: 0%; background-color: #5cb85c">0°C</div>
        </div>
    </div>
    <!-- Voltage Progress Bar -->
    <div class="column-card" id="voltage-bar">
        <div class="column-card-header_progres">Voltage</div>
        <div class="progress" style="height: 20px;">
            <div class="progress-bar bg-primary progress-animated" role="progressbar" style="width: 0%; background-color: #5cb85c">0 V</div>
        </div>
    </div>
</div>
<!-- End of Progress Bars -->

    </div>
    <div class="table-responsive">
      <div class="nav-tabs-custom">
        <ul class="nav nav-tabs">
          <li class="active">
            <a href="#tab_4" data-toggle="tab">Wireless Status</a>
          </li>
          <li>
            <a href="#tab_1" data-toggle="tab">Interface Status</a>
          </li>
          <li>
            <a href="#tab_2" data-toggle="tab">Hotspot Online Users</a>
          </li>
          <li>
            <a href="#tab_3" data-toggle="tab">PPPoE Online Users</a>
          </li>
          <li>
            <a href="#tab_5" data-toggle="tab">Traffic Monitor</a>
          </li>
        </ul>
        <div class="tab-content">
          <div style="overflow-x:auto;" class="tab-pane" id="tab_1">
            <div class="box-body no-padding" id="traffic-panel">
              <table id="traffic-table" class="display">
                <thead>
                  <tr>
                    <th>Interface Name</th>
                    <th>Tx (bytes Out)</th>
                    <th>Rx (bytes In)</th>
                    <th>Total Usage</th>
                    <th>Status</th>
                  </tr>
                </thead>
              </table>
            </div>
          </div>
          <!-- /.tab-pane -->
          <div class="tab-pane" style="overflow-x:auto;" id="tab_2">
            <div class="box-body no-padding" id="hotspot-panel">
              <table class="display" id="hotspot-table">
                <thead>
                  <tr>
                    <th>Username</th>
                    <th>IP Address</th>
                    <th>Uptime</th>
                    <th>Server</th>
                    <th>Mac Address</th>
                    <th>Session Time Left</th>
                    <th>Upload (RX)</th>
                    <th>Download (TX)</th>
                    <th>Total Usage</th>
                    <!--  <th>Action</th>  -->
                  </tr>
                </thead>
              </table>
            </div>
          </div>
          <!-- /.tab-pane -->
          <div style="overflow-x:auto;" class="tab-pane" id="tab_3">
            <div class="box-body no-padding" id="traffic-panel">
              <table class="display" id="ppp-table">
                <thead>
                  <tr>
                    <th>Username</th>
                    <th>IP Address</th>
                    <th>Uptime</th>
                    <th>Service</th>
                    <th>Caller ID</th>
                    <th>Download</th>
                    <th>Upload</th>
                    <th>Total Usage</th>
                  </tr>
                </thead>
              </table>
            </div>
          </div>
          <div style="overflow-x:auto;" class="tab-pane active" id="tab_4">
            <div class="box-body no-padding" id="signal-panel">
              <table class="display" id="signal-table">
                <thead>
                  <tr>
                    <th>Interface</th>
                    <th>Mac Address</th>
                    <th>Uptime</th>
                    <th>Last Ip</th>
                    <th>Last Activity</th>
                    <th>Signal Strength</th>
                    <th>Tx / Rx CCQ</th>
                    <th>Rx Rate</th>
                    <th>Tx Rate</th>
                  </tr>
                </thead>
              </table>
            </div>
          </div>
          <div style="overflow-x:auto;" class="tab-pane" id="tab_5">
            <div class="box-body no-padding" id="">
              <div class="table-responsive">
                <table class="table table-bordered">
                  <tr>
                    <th>Interace</th>
                    <th>TX</th>
                    <th>RX</th>
                  </tr>
                  <tr>
                    <td>
                      <select name="interface" id="interface">
                        {foreach from=$interfaces item=interface}
                          <option value="{$interface}">{$interface}</option>
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
      </div>
      <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
      <script>
          var $j = jQuery.noConflict(); // Use $j as an alternative to $
          
          // Function to fetch data from server
          function fetchData() {
              $j.ajax({
                  url: '{$_url}plugin/mikrotik_monitor_get_resources_json{$routes}', // Ganti dengan URL yang sesuai untuk mendapatkan data real-time
                  method: 'GET',
                  dataType: 'json', // Jika server mengembalikan data dalam format JSON
                  success: function(data) {
                      // Update CPU Load progress bar
                      $j('#cpu-load-bar .progress-bar').css('width', data.cpu_load + '%').text(data.cpu_load + '%');
                      
                      // Update Temperature progress bar
                      $j('#temperature-bar .progress-bar').css('width', data.temperature + '%').text(data.temperature + '°C');
                      
                      // Update Voltage progress bar
                      $j('#voltage-bar .progress-bar').css('width', data.voltage + '%').text(data.voltage + ' V');
                  },
                  error: function(xhr, status, error) {
                      console.error('AJAX Error:', error);
                  }
              });
          }
          
          // Call fetchData initially
          fetchData();
          
          // Polling fetchData every 5 seconds (5000 milliseconds)
          setInterval(fetchData, 2000); // Ubah interval sesuai dengan kebutuhan Anda
      </script>
      <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
      <script src="https://cdn.datatables.net/1.11.3/js/jquery.dataTables.min.js"></script>
      <script>
        var $j = jQuery.noConflict(); // Use $j as an alternative to $
        function fetchData() {
          $j.ajax({
            url: '{$_url}plugin/mikrotik_monitor_get_traffic/{$router}',
            method: 'GET',
            success: function(response) {
              // Update the DataTable with the fetched data
              $j('#traffic-table').DataTable().clear().rows.add(response).draw();
            },
            error: function(xhr, error, thrown) {
              console.log('AJAX error:', error);
            }
          });
        }

        function fetchUserListData() {
          var table = $j('#ppp-table').DataTable({
            columns: [{
              data: 'username'
            }, {
              data: 'address'
            }, {
              data: 'uptime'
            }, {
              data: 'service'
            }, {
              data: 'caller_id'
            }, {
              'data': 'tx'
            }, {
              'data': 'rx'
            }, {
              'data': 'total'
            }, ],
            // Add any additional options or configurations as needed
          });
          $j.ajax({
            url: '{$_url}plugin/mikrotik_monitor_get_ppp_online_users/{$router}',
            method: 'GET',
            success: function(response) {
              // Update the DataTable with the fetched user list data
              table.clear().rows.add(response).draw();
            },
            error: function(xhr, error, thrown) {
              console.log('AJAX error:', error);
            },
          });
        }

        function fetchHotspotListData() {
          var table = $j('#hotspot-table').DataTable({
            columns: [{
              data: 'username'
            }, {
              data: 'address'
            }, {
              data: 'uptime'
            }, {
              data: 'server'
            }, {
              data: 'mac'
            }, {
              data: 'session_time'
            }, {
              data: 'tx_bytes'
            }, {
              data: 'rx_bytes'
            }, {
              data: 'total'
            }, ],
            // Add any additional options or configurations as needed
          });
          $j.ajax({
            url: '{$_url}plugin/mikrotik_monitor_get_hotspot_online_users/{$router}',
            method: 'GET',
            success: function(response) {
              // Update the DataTable with the fetched user list data
              table.clear().rows.add(response).draw();
            },
            error: function(xhr, error, thrown) {
              console.log('AJAX error:', error);
            },
          });
        }
        // Function to disconnect a user
        function disconnectUser(username) {
          // Perform the disconnect action for the specified user
          // You can implement the functionality to disconnect the user here
          console.log('Disconnect user:', username);
        }
        $j(document).ready(function() {
          $j('#traffic-table').DataTable({
            'columns': [{
              'data': 'name'
            }, {
              'data': 'tx'
            }, {
              'data': 'rx'
            }, {
              'data': 'total'
            }, {
              'data': 'status'
            }],
            'error': function(xhr, error, thrown) {
              console.log('DataTables error:', error);
            }
          });
          // Fetch data initially
          //fetchSignalListData();
          fetchData();
          fetchHotspotListData();
          fetchUserListData();
          // Refresh the user list data every 5 seconds
          //  setInterval(fetchUserListData, 5000);
          // Refresh the data every 5 seconds
          //  setInterval(fetchData, 5000);
        });
      </script>
      <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
      <script>
        function fetchSignalListData() {
          var table = $j('#signal-table').DataTable({
            columns: [{
              data: 'interface'
            }, {
              data: 'mac_address'
            }, {
              data: 'uptime'
            }, {
              data: 'last_ip'
            }, {
              data: 'last_activity'
            }, {
              data: 'signal_strength'
            }, {
              data: 'tx_ccq'
            }, {
              data: 'rx_rate'
            }, {
              data: 'tx_rate'
            }]
            // Add any additional options or configurations as needed
          });
          $.ajax({
            url: '{$_url}plugin/mikrotik_monitor_get_wlan/{$router}',
            method: 'GET',
            success: function(response) {
              // Update the DataTable with the fetched user list data
              table.clear().rows.add(response).draw();
            },
            error: function(xhr, error, thrown) {
              console.log('AJAX error:', error);
            }
          });
        }
        fetchSignalListData();
      </script>
      <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
      <script>
        /// Global variables for the chart and data
        var chart;
        var chartData = {
          labels: [],
          txData: [],
          rxData: []
        };

        // Function to create and update the chart
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
                fill: 'start' // Use 'start' to fill the area from the starting point
              }, {
                label: 'RX',
                data: chartData.rxData,
                backgroundColor: 'rgba(255, 99, 132, 0.5)',
                borderColor: 'rgba(255, 99, 132, 1)',
                borderWidth: 0,
                tension: 0.4,
                fill: 'start' // Use 'start' to fill the area from the starting point
              }]
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
                    callback: function(value) {
                      return formatBytes(value); // Format the tick values using formatBytes()
                    }
                  }
                }
              },
              plugins: {
                tooltip: {
                  callbacks: {
                    label: function(context) {
                      var label = context.dataset.label || '';
                      var value = context.parsed.y || 0;
                      return label + ': ' + formatBytes(value) + 'ps';
                    }
                  }
                }
              },
              elements: {
                point: {
                  radius: 0, // Set the point radius to 0 to remove the dots
                  hoverRadius: 0 // Set the hover point radius to 0 to remove the dots
                },
                line: {
                  tension: 0 // Set the line tension to 0 to remove the curve
                }
              }
            }
          });
        }

        function formatBytes(bytes) {
          if (bytes === 0) {
            return '0 B';
          }
          var k = 1024;
          var sizes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
          var i = Math.floor(Math.log(bytes) / Math.log(k));
          var formattedValue = parseFloat((bytes / Math.pow(k, i)).toFixed(2));
          return formattedValue + ' ' + sizes[i];
        }
        // Function to update the TX and RX values
        function updateTrafficValues() {
          var interface = $('#interface').val(); // Get the interface value from the input field
          $.ajax({
            url: '{$_url}plugin/mikrotik_monitor_traffic_update/{$router}',
            dataType: 'json',
            data: {
              interface: interface
            }, // Pass the interface value in the AJAX request
            success: function(data) {
              var labels = data.labels;
              var txData = data.rows.tx;
              var rxData = data.rows.rx;
              if (txData.length > 0 && rxData.length > 0) {
                var TX = parseInt(txData[0]);
                var RX = parseInt(rxData[0]);
                // Update chart data
                chartData.labels.push(labels[0]);
                chartData.txData.push(TX);
                chartData.rxData.push(RX);
                // Limit the number of data points to display (e.g., show the last 10 entries)
                var maxDataPoints = 10;
                if (chartData.labels.length > maxDataPoints) {
                  chartData.labels.shift();
                  chartData.txData.shift();
                  chartData.rxData.shift();
                }
                // Update the chart with the new data
                chart.update();
                // Update the table values
                document.getElementById("tabletx").textContent = formatBytes(TX);
                document.getElementById("tablerx").textContent = formatBytes(RX);
              } else {
                document.getElementById("tabletx").textContent = "0";
                document.getElementById("tablerx").textContent = "0";
              }
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
              console.error("Status: " + textStatus + " request: " + XMLHttpRequest);
              console.error("Error: " + errorThrown);
            }
          });
        }
        // Function to refresh the values every 1 second
        function startRefresh() {
          setInterval(updateTrafficValues, 2000); // Refresh every 1 second (1000 milliseconds)
        }
        // Event listener for the interface input field
        $('#interface').on('input', function() {
          updateTrafficValues(); // Update the values when the input changes
        });
        // Initialize the chart
        createChart();
        // Example usage:
        startRefresh();
      </script>
      <script>
        window.addEventListener('DOMContentLoaded', function() {
          var portalLink = "https://github.com/focuslinkstech";
          $('#version').html('MikroTik Monitor | Ver: 1.0 | by: <a href="' + portalLink + '">Focuslinks Tech</a>');
        });
      </script>
      
{include file="sections/footer.tpl"}
