#!/usr/bin/env perl

use v5.14;
use warnings;

# bootstrap_wiki.pl
#
#   Simple wiki engine using Mojolicious and Bootstrap,
#    with Markdown files as content.
#
# Created by Sérgio Bernardino <me@sergiobernardino.net> on 2012-03-26.
#
# This program is free software;
# you can redistribute it and/or modify it under the terms of Perl itself.
# See http://dev.perl.org/licenses/ for more information.
#

package Articles;

use autodie;
use Mojo::Util qw/encode decode/;
use Text::Markdown 'markdown';

sub new
{
  my $class = shift;
  my %args  = @_;

  bless {
    path => $args{path} || 'content',
  }, $class;
}

sub get
{
  my ($self, $name) = @_;
  my $html;

  eval
  {
    open my $fh, '<', "$self->{path}/$name.md";
    my $md = do { local $/; <$fh> };
    $md =~ s/\[\[(\w+)\]\]/\[$1\]\($1\)/g; # convert MediaWiki links
    $html = decode 'UTF-8', markdown($md);
    close $fh;
  }; warn $@ if $@;

  return $html;
}

#

package main;

use Mojolicious::Lite;

my $model = Articles->new;

# helpers

helper articles => sub { return $model };

# routes

get '/' => sub {
  my $self = shift;
  $self->redirect_to('index');
};

get '/:article' => [ article => qr/[-_\w\d]+/ ] => sub {
  my $self = shift;
  my $article = $self->param('article');

  if (my $content = $self->articles->get($article))
  {
    $self->render('article',
      name => $article,
      html => $content,
    );
  }

  $self->render('not_found', status => 404);
};

# let's do this!

app->secret('sauce');
app->start;

__DATA__

@@ article.html.ep
% layout 'simple';
% title "Article : $name";
%== $html;

@@ not_found.html.ep
% layout 'simple';
% title '404 Not Found';
<h1>404 Not Found</h1>
<p>Sorry, the page you requested was not found.</p>

@@ layouts/simple.html.ep
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title><%= title %></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Le styles -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
      body {
        padding-top: 60px; /* 60px to make the container go all the way to the bottom of the topbar */
      }
    </style>
    <link href="css/bootstrap-responsive.min.css" rel="stylesheet">

    <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <!-- Le fav and touch icons -->
    <link rel="shortcut icon" href="ico/favicon.ico">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="ico/apple-touch-icon-57-precomposed.png">
  </head>

  <body>

    <div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </a>
          <a class="brand" href="#">Bootstrap Wiki</a>
          <div class="nav-collapse">
            <ul class="nav">
              <li class="active"><a href="Index">Home</a></li>
              <li><a href="About">About</a></li>
              <li><a href="Contact">Contact</a></li>
            </ul>
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>

    <div class="container">

    <%== content %>

    </div> <!-- /container -->

    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="js/jquery.js"></script>
    <script src="js/bootstrap.min.js"></script>

  </body>
</html>

