@include('doc.head-frontend')

<body   id="layout-frontend"
        class="homepage skin-default theme-default"
        data-id_page="layout-frontend"
        data-rooturl="{{ Request::root() }}">

    <!--/ START: NavBar-Top /-->
    <header class="header" id="header">

        <!--/  Header Navbar  /-->
        <nav class="navbar navbar-default navbar-fixed-top" role="navigation">

            <div class="navbar-header">
                <a class="navbar-brand" href="#">
                    <img class="logo-sm" alt="Premium MP3 Collection" src="{{ asset('/assets/img/logo/logo-sm.png') }}" />
                </a>
                <!--/  Navbar toggle button  /-->
                <a  href="#player-wrapper"
                    class="navbar-btn navbar-toggle"
                    data-toggle="collapse"
                    data-target="#player-wrapper"
                    aria-controls="player-wrapper"
                    aria-expanded="false"
                    role="button">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </a>

                <div class="navbar-header navbar-right">
                    <!--/ Right Side Of Navbar /-->
                    <ul class="nav navbar-nav ">
                        <!--/ Authentication Links /-->
                        @if (Auth::guest())
                            <li><a href="{{ url('/login') }}"> Login</a></li>
                            {{-- <li><a href="{{ url('/register') }}"> Register</a></li> --}}
                        @else
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">
                                    {{ Auth::user()->name }} <span class="caret"></span>
                                </a>

                                <ul class="dropdown-menu" role="menu">
                                    <li><a href="{{ url('/home') }}" target="_blank"><i class="fa fa-btn fa-dashboard"></i>  Cabinet</a></li>
                                    <li><a href="{{ url('/logout') }}"><i class="fa fa-btn fa-sign-out"></i>  Logout</a></li>
                                </ul>
                            </li>
                        @endif
                    </ul>
                </div>

            </div>

            <div class="container">
                <!--/ --- PLAYER --- /-->
                <div id="player-wrapper" class="navbar navbar-collapse collapse">
                    @include('partials.player')
                </div>
            </div><!--/  END: .container  /-->

        </nav><!--/  END: Header Navbar  /-->

    </header><!--/  END: NavBar-Top  /-->

    <!--/ START: Content /-->
    <section id="content">
        <div class="container">
            <div class="row">

                <div class="col-sm-12">
                    <h3 class="column-title">Feel, Drive, Live - Smile! <i class="fa fa-smile-o"></i></h3>
                </div>

            </div>
        </div>

    </section><!--/#content-->

    <!--/ --- TRACKLIST --- /-->
    <section id="list">
        <div class="container">
            <div class="row">

                <!--/ --- GENRE Accordion --- /-->
                <div class="col-xs-12">

                     <!--/ Nav tabs /-->
                    <ul class="nav nav-tabs" role="tablist">
                        <li role="presentation" class="active"><a href="#all" aria-controls="all" role="tab" data-toggle="tab">All Tracks (<span id="files-count"></span>)</a></li>
                        <li role="presentation" class="hide"><a href="#genre" aria-controls="genre" role="tab" data-toggle="tab">Genre</a></li>
                    </ul>

                    <!--/ Tab panes /-->
                    <div class="tab-content no-padding">
                        <div class="tab-pane active fade in" id="all" role="tabpanel">
                            <ul class="list-group nostyle" id="tracklist">

                                @yield('tracklist')

                            </ul>
                        </div>

                        <div class="tab-pane fade hide" id="genre" role="tabpanel"></div>

                    </div>

                </div>

            </div>
        </div>

    </section><!--/#list-->

    @include('doc.footer')
    @include('doc.javascripts')

</body>
</html>
