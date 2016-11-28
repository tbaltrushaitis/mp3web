@extends('layouts.frontend')

@section('content')
<div class="container">
    <div class="row">
        <div class="col-md-10 col-md-offset-1">
            <div class="panel panel-default">
                <div class="panel-heading">Welcome</div>
                <div class="panel-body">
                    Application's Landing Page.
                </div>
            </div>
        </div>
    </div>
</div>
@endsection

@section('tracklist')
    @if (count($tracks) > 0)
        @foreach ($tracks as $idx => $track)
            <li class="list-group-item track">
                <i class="fa fa-headphones fa-fw"></i>
                @if ((time() - $track->get('added')) < 604800)
                    <span class="label label-danger">New!</span>
                @else
                    <span class="label label-success">{{ $track->get('plays', 0) }}</span>
                @endif
                <a href="{{ $track->get('id') }}">{{ $track->get('title') }}</a>
                <input class="genre" value="{{ $track->get('genre') }}" data-role="tagsinput" />
                <div class="raty" data-score="{{ ($track->get('likes') * 5) / max( $track->get('likes') + $track->get('dislikes'), 1) }}"></div>
            </li>
        @endforeach
    @else
        <li class="list-group-item track">No tracks</li>
    @endif
@endsection
