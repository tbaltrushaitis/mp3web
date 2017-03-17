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
                @if ((time() - $track->get('added')) < 60 * 60 * 24 * 14)
                    <span class="label label-danger">New!</span>
                @else
                    <span class="label label-success">{{ $track->get('plays', 0) }}</span>
                @endif
                <a class="" href="{{ $track->get('id') }}">{{ $track->get('title') }}</a>

                <div class="raty pull-right" data-score="{{ ($track->get('likes') * 5) / max( $track->get('likes') + $track->get('dislikes'), 1) }}"></div>

                <div class="labels-holder pull-right">
                    @if (is_array($track->get('genre')) && count($track->get('genre')) > 0)
                        @foreach ( $track->get('genre') as $idx => $Genre )
                            <span class="label label-primary tagholder" id="tag_genre_{{$idx}}">{{ $Genre }}</span>
                        @endforeach
                    @endif
                </div>

            </li>
        @endforeach
    @else
        <li class="list-group-item track">No tracks</li>
    @endif
@endsection
