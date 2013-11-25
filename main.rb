require 'sinatra'
require 'erb'

get '/' do
 erb :index
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

<div class="tab-pane active" id="repos">
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
$('#tabs').tab();
});
</script>
</div> <!-- container -->




</body>
</html>


@@users_chart
<h1>USERS CHART DIAGRAM</h1>


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
  <h1>Active users statistics</h1>
  <p>Stat  content</p>
    <%= erb :users_chart %>



@@author_content
<p>Makarevich Andrey Stepanovich</p>
<p>Ukraine,Kharkov</p>
<p>skype:andrey_makarevich</p>