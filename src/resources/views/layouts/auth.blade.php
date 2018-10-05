@include('auth.head')

<body id="layout-auth"
      class="layout-auth skin-default theme-default"
      data-id_page="layout-auth"
      data-rooturl="{{ Request::root() }}">

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
        <a class="navbar-brand" href="{{ url('/') }}" target="_self">
          <img class="logo-sm" alt="Premium MP3 Collection" src="{{ asset('/assets/img/logo/logo-sm.png') }}" />
        </a>
      </div>

      <div class="collapse navbar-collapse" id="app-navbar-collapse">
        <!--/ Left Side Of Navbar /-->
        <ul class="nav navbar-nav">
          <li><a href="{{ url('/cabinet') }}" target="_self">Cabinet</a></li>
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
                <li><a href="{{ url('/logout') }}"><i class="fa fa-btn fa-sign-out"></i>Logout</a></li>
              </ul>
            </li>
          @endif
        </ul>
      </div>
    </div>
  </nav>

  @yield('content')

  <!--/ JavaScripts /-->
  {{-- @include('doc.javascripts') --}}
  {{-- <script src="{{ elixir('js/app.js') }}"></script> --}}
</body>
</html>
