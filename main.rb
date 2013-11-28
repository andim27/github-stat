require 'sinatra'
require "sinatra/json"
require 'erb'

get '/' do
 erb :index
end

get '/activeusers' do
  json ({:user=>'user-1',:commits=>23,:pull_request=>5},:encoder => :to_json, :content_type => :js)

  #content_type :json
  #{ :user-1 => 'value1', :user-2 => 'value2' }.to_json
end

__END__

@@ index

<!DOCTYPE html>
<html lang="en">
<head>
<!--styles -->
<link href="//netdna.bootstrapcdn.com/bootstrap/3.0.2/css/bootstrap.min.css" rel="stylesheet">
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.js"></script>
<script type="text/javascript" src="//netdna.bootstrapcdn.com/bootstrap/3.0.2/js/bootstrap.min.js"></script>
<script type="text/javascript" src="http://code.highcharts.com/highcharts.js"></script>
</head>

<body>

<div class="container">
<!-------->
<h1> GitHub User analyzer</h1>
<div id="content">
<ul id="tabs" class="nav nav-tabs" data-tabs="tabs">
<li class="active"><a href="#enter" data-toggle="tab">Enter params:</a></li>
<li><a href="#repos" data-toggle="tab">Repos</a></li>
<li><a href="#active_users" data-toggle="tab">Active Users</a></li>
<li><a href="#author" data-toggle="tab">Author</a></li>
</ul>
<div id="my-tab-content" class="tab-content">
<div class="tab-pane active" id="enter">
  <%=erb :enter %>
</div>

<div class="tab-pane" id="repos">
  <%=erb :repos %>
</div>

<div class="tab-pane" id="active_users">
  <%= erb :active_users %>
</div>

<div class="tab-pane" id="author">
<h1>Project author</h1>
  <%= erb :author_content %>
</div>

</div>
</div>
</div>


<script type="text/javascript">
jQuery(document).ready(function ($) {
          $('#show_id').click(function (){
            <%= erb :show_js %>
          });
          $('#tabs').tab();
          $('#chart').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'GitHub users statistics'
            },
            subtitle: {
                text: 'Repo-123'
            },
            xAxis: {
                categories: [
                    'User-1',
                    'User-2',
                    'User-3',
                    'User-4',
                    'User-5',
                    'User-6',
                    'User-7',
                    'User-8',
                    'User-9',
                    'User-10',
                    'User-11',
                    'User-12'
                ]
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Amount'
                }
            },
            tooltip: {
                headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y:.1f} mm</b></td></tr>',
                footerFormat: '</table>',
                shared: true,
                useHTML: true
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0
                }
            },
            credits: {
              enabled: false
            },
            series: [{
                name: 'Commits',
                data: [49, 71, 106, 129, 144, 176, 135, 148, 216, 194, 95, 54]

            }, {
                name: 'Pull request',
                data: [83, 78, 98, 93, 106, 84, 105, 104, 91, 83, 106, 92]

            }, {
                name: 'Reviews',
                data: [48, 38, 39, 41, 47, 48, 59, 59, 52, 65, 59, 51]

            }, {
                name: 'Pushes',
                data: [42, 33, 34, 39, 56, 75, 57, 60, 47, 39, 46, 51]

            }, {
                name: 'Comments',
                data: [42, 33, 34, 39, 52, 75, 57, 60, 47, 39, 46, 51]

            }
            ]
        });
});
</script>
</div> <!-- container -->




</body>
</html>

@@show_js
  $.getJSON("/activeusers",function (data) {alert(data);});



@@users_chart
<div id="chart"></div>

@@enter
  <h1>Enter parameters</h1>
  <p>
    <a href="http://github.com/rails"> github.com/rails</a>
  </p>

@@repos
  <h1>Current repo</h1>
  <p>
    github.com/rails
  </p>

@@active_users
<br>
<div class="row">
  <div class="col-xs-6 col-md-4">

  </div>
  <div class="col-xs-6 col-md-4">
      <div class="btn-group">
        <button type="button" class="btn btn-default">Last Hour</button>
        <button type="button" class="btn btn-default">Last Day</button>
      </div>
      <button id="show_id" type="button" class="btn btn-primary">Show</button>
  </div>
  <div class="col-xs-6 col-md-4"></div>
</div>
   <%= erb :users_chart %>



@@author_content
<p>Makarevich Andrey Stepanovich</p>
<p>Ukraine,Kharkov</p>
<p>skype:andrey_makarevich</p>