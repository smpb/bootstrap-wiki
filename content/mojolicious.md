# Mojolicious

Web development can be fun again.


## A next generation web framework for the Perl programming language.

Back in the early days of the web, many people learned Perl because of a wonderful Perl library called `CGI`. It was simple enough to get started without knowing much about the language and powerful enough to keep you going, learning by doing was much fun. While most of the techniques used are outdated now, the idea behind it is not. Mojolicious is a new attempt at implementing this idea using state of the art technology.


## Features

 - An amazing real-time web framework supporting a simplified single file mode through [Mojolicious::Lite](http://mojolicio.us/perldoc/Mojolicious/Lite).
 - Powerful out of the box with `REST`ful routes, plugins, Perl-ish templates, session management, signed cookies, testing framework, static file server, I18N, first class unicode support and much more for you to discover.
 - Very clean, portable and Object Oriented pure Perl API without any hidden magic and no requirements besides Perl 5.10.1 (although 5.12+ is recommended, and optional `CPAN` modules will be used to provide advanced functionality if they are installed).
 - Full stack `HTTP 1.1` and WebSocket client/server implementation with `IPv6`, `TLS`, `Bonjour`, `IDNA`, `Comet` (long polling), chunking and multipart support.
 - Built-in non-blocking I/O web server supporting libev and hot deployment, perfect for embedding.
 - Automatic `CGI` and `PSGI` detection.
 - `JSON` and `HTML5/XML` parser with `CSS3` selector support.
 - Fresh code based upon years of experience developing `Catalyst`.


## Installation

All you need is a oneliner, it takes less than a minute.

    $ curl get.mojolicio.us | sh


## Getting Started

These three lines are a whole web application.

    use Mojolicious::Lite;

    get '/' => {text => 'Hello World!'};

    app->start;

To run this example with the built-in development web server just put the code into a file and start it with `morbo`.

    $ morbo hello.pl
    Server available at http://127.0.0.1:3000.

    $ curl http://127.0.0.1:3000/
    Hello World!

## Duct tape for the HTML5 web

Web development for humans, making hard things possible and everything fun.

    use Mojolicious::Lite;

    # Simple plain text response
    get '/' => {text => 'Hello World!'};

    # Route associating "/time" with template in DATA section
    get '/time' => 'clock';

    # RESTful web service with JSON and text representation
    get '/list/:offset' => sub {
      my $self    = shift;
      my $numbers = [0 .. $self->param('offset')];
      $self->respond_to(
        json => {json => $numbers},
        txt  => {text => join(',', @$numbers)}
      );
    };

    # Scrape information from remote sites
    post '/title' => sub {
      my $self = shift;
      my $url  = $self->param('url') || 'http://mojolicio.us';
      $self->render_text(
        $self->ua->get($url)->res->dom->html->head->title->text);
    };

    # WebSocket echo service
    websocket '/echo' => sub {
      my $self = shift;
      $self->on(message => sub {
        my ($self, $message) = @_;
        $self->send("echo: $message");
      });
    };

    app->start;
    __DATA__

    @@ clock.html.ep
    % use Time::Piece;
    % my $now = localtime;
    The time is <%= $now->hms %>.

Single file prototypes like this one can easily grow into well-structured applications.


## Want to know more?

Take a look at the excellent [documentation](http://mojolicio.us/perldoc)!

