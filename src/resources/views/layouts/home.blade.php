<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--[if lt IE 7 ]><html lang="en" xml:lang="en" xmlns="http://www.w3.org/1999/xhtml" class="ie6"> <![endif]-->
<!--[if IE 7 ]><html lang="en" xml:lang="en" xmlns="http://www.w3.org/1999/xhtml" class="ie7"> <![endif]-->
<!--[if IE 8 ]><html lang="en" xml:lang="en" xmlns="http://www.w3.org/1999/xhtml" class="ie8"> <![endif]-->
<!--[if IE 9 ]><html lang="en" xml:lang="en" xmlns="http://www.w3.org/1999/xhtml" class="ie9"> <![endif]-->
<!--[if IE 10 ]><html lang="en" xml:lang="en" xmlns="http://www.w3.org/1999/xhtml" class="ie10"> <![endif]-->
<!--[if IE 11 ]><html lang="en" xml:lang="en" xmlns="http://www.w3.org/1999/xhtml" class="ie11"> <![endif]-->
<!--[if (gt IE 11)|!(IE)]><!--><html lang="en" xml:lang="en" xmlns="http://www.w3.org/1999/xhtml" class="noie"> <!--<![endif]-->
<head>
    <!--/ Basic Page Needs
    ================================================== /-->
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <title>Premium Music Collection :: Admin Dashboard</title>

    <!--/ Application Specific Metas
    ================================================== /-->
    <meta name="csrf-token" content="{{ csrf_token() }}" />

    <!--/ Mobile Specific Metas
    ================================================== /-->
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />

    <!--/ Fonts
    ================================================== /-->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Lato:100,300,400,700" />

    <!--/ Styles
    ================================================== /-->
    {{-- <link href="{{ elixir('css/app.css') }}" rel="stylesheet" /> --}}

    <!--/ Custom styles
    ================================================== /-->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/rainbow/1.2.0/themes/github.css" />
    <link rel="stylesheet" href="assets/css/bower-bundle.min.css" id="css-bower" />
    <!--/ <link rel="stylesheet" href="assets/css/styles.min.css" id="css-themes" /> /-->
    <!--/ <link rel="stylesheet" href="assets/css/50-mp3.css" id="css-custom" /> /-->

    <!--/ Favicon
    ================================================== /-->
    <link href="assets/img/favicon.ico" type="image/x-icon" rel="icon"          alt="Site Icon" />
    <link href="assets/img/favicon.ico" type="image/x-icon" rel="shortcut icon" alt="Site Shortcut Icon" />

    <!--/ HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries /-->
    <!--[if lt IE 9]>
        <script src="assets/js/lib/html5shiv.min.js"></script>
        <script src="assets/js/lib/respond.min.js"></script>
    <![endif]-->
    <style>
        body {
            font-family: 'Lato';
        }

        .fa-btn {
            margin-right: 6px;
        }
    </style>

</head>

<body id="layout-home" data-id_page="layout-home" data-rooturl="{{ Request::root() }}">
    <nav class="navbar navbar-default navbar-static-top">
        <div class="container">

            <div class="navbar-header">

                <!--/ Collapsed Hamburger /-->
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#app-navbar-collapse">
                    <span class="sr-only">Toggle Navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>

                <!--/ Branding Image /-->
                <a class="navbar-brand" href="{{ url('/') }}">
                    <img class="logo-sm" alt="Premium MP3 Collection" src="{{ asset('assets/img/logo/logo-sm.png') }}" />
                </a>
            </div>

            <div class="collapse navbar-collapse" id="app-navbar-collapse">
                <!--/ Left Side Of Navbar /-->
                <ul class="nav navbar-nav">
                    <li><a href="{{ url('/') }}">Site Front</a></li>
                    <li><a href="{{ url('/home') }}">Home</a></li>
                </ul>

                <!--/ Right Side Of Navbar /-->
                <ul class="nav navbar-nav navbar-right">
                    <!--/ Authentication Links /-->
                    @if (Auth::guest())
                        <li><a href="{{ url('/login') }}">Login</a></li>
                        <li><a href="{{ url('/register') }}">Register</a></li>
                    @else
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">
                                {{ Auth::user()->name }} <span class="caret"></span>
                            </a>

                            <ul class="dropdown-menu" role="menu">
                                <li><a href="{{ url('/profile') }}"><i class="fa fa-btn fa-user"></i>Profile</a></li>
                                <li><a href="{{ url('/history') }}"><i class="fa fa-btn fa-history"></i>History</a></li>
                                <li><a href="{{ url('/playlists') }}"><i class="fa fa-btn fa-list-alt"></i>Playlists</a></li>
                                <li role="separator" class="divider"></li>
                                <li><a href="{{ url('/logout') }}"><i class="fa fa-btn fa-sign-out"></i>Logout</a></li>
                            </ul>
                        </li>
                    @endif
                </ul>
            </div>

        </div>
    </nav>

    @yield('content')

    @include('partials.modalTrackEdit')

    @include('cabinet.javascripts')

</body>

</html>
