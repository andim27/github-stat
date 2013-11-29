require 'sinatra'
require "sinatra/json"
require 'erb'
require 'octokit'
require 'date'

BASE_REPO='https://github.com/'
get '/' do
 erb :index
end

#---------------------Format output data---------------------------
#--  [ users:active_users,
#     commits:x,
#     pull_requests:x,
#     reviews:x,
#     pushes:x,
#     comments:x
#   ]
# -------------
#  active_users=[ {name:x,actions:{commits:x,pull_requests:x}},
#                 {name:x,actions:{commits:x,pull_requests:x}
#                 {name:x,actions:{commits:x,pull_requests:x}
#               ]
#---------------------------------------------------------------------

get '/activeusers' do
 begin
  repo_name   = params[:repo_name].gsub(BASE_REPO,"")
  time_period = params[:time_period]
  client=Octokit::Client.new
  #-- if Faraday error occur
  #--Octokit.connection_options[:ssl] = {:ca_file => './ssl/cert.pem'}
  #--or OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  stat = client.contributors_stats(repo_name)
  users,users_active,commits,requests_active=[],[],[],[]
  stat.each do |u|
    users << {:name=>u.author.login,:actions=>{:commits=>0,:pull_requests=>0}}
  end
  time_to=DateTime.now
  if time_period ==1
  #--------------------1 hour ago--------------
      time_from=(Time.now-3600) #-----1 hour is 3600sek
  else
  #--------------------day---------------
      time_from=(DateTime.now-1)
  end
  commits=client.commits_between(repo_name,time_from.to_s,time_to.to_s)
  requests=client.pull_requests(repo_name)

  requests.each do |r|
    requests_active << r if (time_to <=r.created_at)&&(time_from>=r.created.at)
  end
  #----prepare active users fo output---
  users.each do |u|
    author_commits=0
    #---count for author's commits----
    commits.each do |c|
      if u.name==c.author.login
        author_commits+=1
      end
    end
    #---count for author's pull request
    author_pull_requests=0
    requests_active.each do |r|
      if r.head.user.login ==u.name
        author_pull_requests+=1
      end
    end
    users_active <<  {:name=>u.name,:actions=>{:commits=>author_commits,:pull_requests=>author_pull_requests}}
  end
  json ({:users=>users_active,:commits=>commits.size,:pull_request=>requests_active.size,:repo_name=>repo_name, :encoder => :to_json, :content_type => :js})
 #--Sometimes github server return error 500.Possible connection limit exhausted
 rescue Exception => e
   json ({:users=>users_active,:commits=>commits.size,:pull_request=>requests_active.size,:repo_name=>repo_name,:error=>e.message,:error_full_mes=>e.backtrace.inspect,   :encoder => :to_json, :content_type => :js})
 end


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
<li class="active"><a href="#enter" data-toggle="tab">Repos:</a></li>
<li><a href="#active_users" data-toggle="tab">Active Users</a></li>
<li><a href="#author" data-toggle="tab">Author</a></li>
</ul>
<div id="my-tab-content" class="tab-content">
<div class="tab-pane active" id="enter">
  <%=erb :enter %>
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
          repo_name_start="rails/rails";
          time_period=1;
          $('#repo_name').val(repo_name_start);
          $('#time_hour').click(function(){time_period=1})
          $('#time_day').click(function(){time_period=2})
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



@@users_chart
<div id="chart"></div>

@@enter
  <h1>Name repository</h1>
  <div class="input-group">
  <span class="input-group-addon">https://github.com/</span>
  <input id="repo_name" type="text" class="form-control" >
</div>



@@repos
  <h1>Current repo</h1>
  <p>
    github.com/rails
  </p>

@@active_users
<br>
<div class="row">
  <div class="col-xs-6 col-md-4"></div>
  <div class="col-xs-6 col-md-4">
      <div class="btn-group">
        <button id="time_hour" type="button" class="btn btn-default">Last Hour</button>
        <button id="time_day" type="button" class="btn btn-default">Last Day</button>
      </div>
      <button id="show_id" type="button" class="btn btn-primary">Show</button>
  </div>
  <div class="col-xs-6 col-md-4"></div>
</div>
   <%= erb :users_chart %>



@@author_content
<p><strong>Makarevich Andrey Stepanovich</strong></p>
<p>Ukraine,Kharkov</p>
<p>email:a2772@gmail.com</p>
<p>skype:andrey_makarevich</p>



@@show_js
  $.getJSON("/activeusers",{time_period:time_period,repo_name:$('#repo_name').val()})
  .done(function (data) {
      console.log(data);alert(data);
  })
  .fail(function(){alert('Error connect to server!')});

