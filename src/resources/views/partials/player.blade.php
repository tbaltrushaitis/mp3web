<!--/ CONTAINER /-->
<div id="player-container" class="">
    <audio id="player" tabindex="0" type="audio/mp3" no-controls>
        Your browser does not support the audio element.
    </audio>
</div>

<!--/ TOOLBAR /-->
<div id="player-toolbar" class="text-center">

    <div id="player-controls" class="btn-toolbar" aria-expanded="true" role="toolbar">

        <!--/ CONTROLS /-->
        <div class="btn-group btn-group-sm" role="group">
            <!--/ TEST /-->
            <a href="#" id="btn-control-test" class="btn btn-default btn-player-control hide" title="Test" aria-label="Test">
                <i class="fa fa-magnet fa-lg fa-fw"></i>
            </a>
        </div>

        <!--/ CONTROLS /-->
        <div class="btn-group btn-group-sm" role="group">

            <!--/ BACK /-->
            <a href="#" id="btn-control-backward" class="btn btn-default btn-player-control" title="Previous Track" aria-label="Previous">
                <i class="fa fa-step-backward fa-lg fa-fw"></i>
            </a>

            <!--/ PLAY /-->
            <a href="#" id="btn-control-play" class="btn btn-default btn-player-control" title="Play" aria-label="Play">
                <i class="fa fa-play fa-lg fa-fw"></i>
            </a>

            <!--/ NEXT /-->
            <a href="#" id="btn-control-forward" class="btn btn-default btn-player-control" title="Next Track" aria-label="Next">
                <i class="fa fa-step-forward fa-lg fa-fw"></i>
            </a>

        </div>

        <!--/ CONFIG /-->
        <div class="btn-group btn-group-sm" role="group">
            <a href="#" id="btn-option-repeat" class="btn btn-default btn-player-option" title="Repeat Track" aria-label="Repeat">
                <i class="fa fa-retweet fa-lg fa-fw"></i>
            </a>
            <a href="#" id="btn-option-random" class="btn btn-default btn-player-option is-enabled active" title="Randomize" aria-label="Random">
                <i class="fa fa-random fa-lg fa-fw"></i>
            </a>
        </div>

    </div>

    <div id="player-bar" class="btn-toolbar" aria-expanded="true" role="toolbar">

        <!--/ DATA /-->
        <div class="btn-group btn-group-sm" id="player-data" role="group">
            <span id="data-time-remain">00:00</span>
        </div>

        <!--/ PROGRESS /-->
        <div class="btn-group btn-group-sm"  id="player-seek" role="group">
            <div class="progress progress-striped">
                <div id="data-current-progress" class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="min-width: 1pt;">
                    <span class="sr-only"></span>
                </div>
            </div>
            <span id="data-current-src" class="text-cover"></span>
        </div>

        <!--/ ACTIONS /-->
        <div class="btn-group btn-group-sm" id="panel-actions" role="group">

            <div class="btn-group btn-group-sm" role="group">
                <a href="#" id="btn-like" class="btn btn-sm btn-rate" data-rate="like" title="I Like It" aria-label="Like">
                    <i class="fa fa-thumbs-o-up fa-lg fa-fw"></i>
                </a>
                <label id="info-rank-like" title="Likes" class="info-rank">0</label>
            </div>

            <div class="btn-group btn-group-sm" role="group">
                <a href="#" id="btn-dislike" class="btn btn-sm btn-rate" data-rate="dislike" title="I Don't Like It" aria-label="Dislike">
                    <i class="fa fa-thumbs-o-down fa-lg fa-fw"></i>
                </a>
                <label id="info-rank-dislike" title="Dislikes" class="info-rank">0</label>
            </div>

        </div>

        <!--/ TRACK-INFO /-->
        <div class="btn-group btn-group-sm" id="panel-track-info" role="group">

            <div class="btn-group btn-group-sm" role="group">
                <a href="#" id="btn-plays" class="btn btn-sm btn-track-info" data-mp3="plays" title="Plays" aria-label="Plays">
                    <i class="fa fa-headphones fa-lg fa-fw"></i>
                </a>
                <label id="info-plays" title="Plays" class="info-plays">0</label>
            </div>

        </div>

    </div>

</div>

