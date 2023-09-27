@extends('layouts.cabinet')

@section('content')
<div class="container-fluid">
  <div class="col-sm-offset-0 col-sm-12">

    <div class="panel panel-default hide">
      <div class="panel-heading">
        New Track
      </div>

      <div class="panel-body">
        <!--/ Display Validation Errors /-->
        @include('common.errors')

        <!--/ New Track Form /-->
        <form action="{{ url('track') }}" method="POST" class="form-horizontal">
          {{ csrf_field() }}

          <!--/ Track Name /-->
          <div class="form-group">
            <label for="track-name" class="col-sm-3 control-label">Track</label>

            <div class="col-sm-6">
              <input type="text" name="name" id="track-name" class="form-control" value="{{ old('track') }}">
            </div>
          </div>

          <!--/ Add <Upload Track> Button /-->
          <div class="form-group">
            <div class="col-sm-offset-3 col-sm-6">
              <button type="submit" class="btn btn-primary">
                <i class="fa fa-btn fa-plus"></i>Upload Track
              </button>
            </div>
          </div>
        </form>
      </div>
    </div>

    <!--/ Current Tracks /-->
    @if (count($tracks) > 0)
    <div class="panel panel-info box box-info">
      <div class="panel-heading">
        <strong>Tracklist</strong> <span class="pull-right">{{ count($tracks) }} item(s)</span>
      </div>

      <div class="panel-body">

        <table class="table table-bordered table-hover table-striped table-condensed track-table">

          <thead class="text-primary">
            <th>#</th>
            <th>ID</th>
            <th>Path</th>
            <th>Title</th>
            <!-- <th>Plays</th> -->
            <th><i class="fa fa-headphones fa-lg fa-fw"></i></th>
            <th><i class="fa fa-thumbs-o-up fa-lg fa-fw"></i></th>
            <th><i class="fa fa-thumbs-o-down fa-lg fa-fw"></i></th>
            <th>Rate</th>
            <th>Days</th>
            <th>Size</th>
            <!-- <th>Added</th> -->
            <th>Edit</th>
            <th>Delete</th>
          </thead>

          <tbody>
          @foreach ($tracks as $key => $track)
            <tr>

              <td class="table-text"><div>{{ 1 + $key }}</div></td>
              <td class="table-text"><div>{{ substr($track->get('id'), 0, 6) }}</div></td>
              <td class="table-text"><div>{{ $track->get('path') . '/' }}</div></td>
              <td class="table-text"><div>{{ $track->get('title') }}</div></td>
              <td class="table-text"><div>{{ $track->get('plays') }}</div></td>
              <td class="table-text"><div>{{ $track->get('likes') }}</div></td>
              <td class="table-text"><div>{{ $track->get('dislikes') }}</div></td>
              <td class="table-text"><div>{{ round(($track->get('likes') * 5) / max( $track->get('likes') + $track->get('dislikes'), 1), 2) }}</div></td>
              <td class="table-text"><div>{{ intval((time() - $track->get('added')) / (60 * 60 * 24)) }}</div></td>
              <td class="table-text"><div>{{ round( $track->get('size') / ( 1024 * 1024 ), 2) }}</div></td>
              <!-- <td class="table-text"><div>{{ date("Y-m-d", $track->get('added')) }}</div></td> -->

              <!--/ EDIT Track Meta /-->
              <td>
                <button type="button"
                  id="edit-track-{{ $track->get('id') }}"
                  class="btn btn-xs btn-fw btn-primary btn-edit"
                  data-id="{{ $track->get('id') }}"
                  data-toggle="modal"
                  data-target="#modalEditTrack">
                  <i class="fa fa-1x fa-edit"></i>
                </button>
              </td>

              <!--/ DELETE Button /-->
              <td>
                <form action="{{ url('/' . $track->get('id')) }}" method="POST">
                  {{ csrf_field() }}
                  {{ method_field('DELETE') }}

                  <button type="submit"
                    id="delete-track-{{ $track->get('id') }}"
                    class="btn btn-xs btn-fw btn-danger">
                    <i class="fa fa-1x fa-ban"></i>
                  </button>
                </form>
              </td>

            </tr>
          @endforeach
          </tbody>
          </table>
      </div>

      <div class="panel-footer">
        Total tracks in playlist: {{ count($tracks) }}
      </div>
    </div>
    @endif
  </div>
</div>
@endsection
