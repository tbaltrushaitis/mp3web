@extends('layouts.cabinet')

@section('content')
<div class="container">
  <div class="row">
    <div class="col-md-10 col-md-offset-1">
      <div class="panel panel-default">
        <div class="panel-heading">Cabinet</div>
        <div class="panel-body">
          Cabinet Content
        </div>
      </div>
    </div>
  </div>

  @if( Session::has('status') )
    <div class="alert alert-success">
      {{ Session::get('status') }}
    </div>
  @endif

  @if (session('status'))
    <div class="alert alert-success">
      {{ session('status') }}
    </div>
  @endif

  @if (Session('status'))
    <div class="alert alert-success">
      {{ Session('status') }}
    </div>
  @endif

</div>
@endsection
