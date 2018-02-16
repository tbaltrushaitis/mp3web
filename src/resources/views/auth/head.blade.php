<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--[if IE 9 ]><html lang="en" xml:lang="en" xmlns="http://www.w3.org/1999/xhtml" class="ie9"> <![endif]-->
<!--[if IE 10 ]><html lang="en" xml:lang="en" xmlns="http://www.w3.org/1999/xhtml" class="ie10"> <![endif]-->
<!--[if IE 11 ]><html lang="en" xml:lang="en" xmlns="http://www.w3.org/1999/xhtml" class="ie11"> <![endif]-->
<!--[if (gt IE 11)|!(IE)]><!--><html lang="en" xml:lang="en" xmlns="http://www.w3.org/1999/xhtml" class="noie"> <!--<![endif]-->
<head>
  <!--/ Basic Page Needs
  ========================================================================= /-->
  <meta charset="utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
  <meta http-equiv="Content-Type"    content="text/html; charset=utf-8" />

  <title>Premium Music Collection :: Auth</title>

  <!--/ Metas
  ========================================================================= /-->
  <meta name="title"         content="Web MP3 Player with Premium Music Collection as a Bonus" />
  <meta name="description"   content="Web MP3 Player and Media Library management. Backend based on Laravel framework, client-side - mostly JavaScript" />
  <meta name="keywords"      content="mp3, audio, mix, hit, remix, original, original mix, dj, track, theme, party, music, web, player, media, content, library, laravel" />
  <meta name="author"        content="tbaltrushaitis@gmail.com" />
  <meta name="language"      content="en" />
  <meta name="robots"        content="index, nofollow, noarchive" />
  <meta name="revisit-after" content="15 days" />

  <!--/ Metas for Crawlers
  ========================================================================= /-->
  <meta property="og:type"        content="collection" />
  <meta property="og:title"       content="Premium Music Collection :: Original Tracks and Best DJ's Remixes" />
  <meta property="og:description" content="Web MP3 Player and Media Library management. Backend based on Laravel framework, client-size - mostly JavaScript" />
  <meta property="og:image"       content="{{ asset('assets/img/logo/logo-lg.png') }}" />
  <meta property="og:site_name"   content="Web MP3 Player and Media Library Manager" />
  <meta property="og:url"         content="{{ url('/') }}" />
  <meta property="og:see_also"    content="https://github.com/tbaltrushaitis/mp3web" />

  <!--/ Mobile Specific Metas
  ========================================================================= /-->
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />

  <!--/ Application Specific Metas
  ========================================================================= /-->
  <meta name="csrf-token" content="{{ csrf_token() }}" />

  <!--/ Fonts
  ========================================================================= /-->
  <!-- <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,700" /> -->

  <!--/ Styles
  ========================================================================= /-->
  <!--/ Custom /-->
  <link rel="stylesheet" href="{{ asset('assets/css/bower-bundle.min.css') }}" id="css-bower" />
  <link rel="stylesheet" href="{{ asset('assets/css/cabinet-bundle.min.css') }}" id="css-cabinet" />

  <!--/ Favicon
  ========================================================================= /-->
  <link href="{{ asset('assets/img/favicon.ico') }}" type="image/x-icon" rel="icon" alt="Site Icon" />
  <link href="{{ asset('assets/img/favicon.ico') }}" type="image/x-icon" rel="shortcut icon"  alt="Site Shortcut Icon" />

  <!--/ Shim and Respond.js IE8 support of HTML5 elements and media queries /-->
  <!--[if lt IE 9]>
    <script src="{{ asset('assets/js/lib/html5shiv.min.js') }}"></script>
    <script src="{{ asset('assets/js/lib/respond.min.js') }}"></script>
  <![endif]-->

</head>
