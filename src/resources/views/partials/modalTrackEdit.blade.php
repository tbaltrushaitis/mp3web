<!--/ modalTrackEdit /-->
<div class="modal fade" id="modalEditTrack" tabindex="-1" role="dialog" aria-labelledby="modalEditLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content panel-default">

            <div class="modal-header-- panel-heading">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title-- panel-title" id="modalEditLabel">Modal title</h4>
            </div>

            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="id" class="col-sm-1 control-label">Id:</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="id" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="filename" class="col-sm-1 control-label">File:</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="filename" placeholder="File Name" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="path" class="col-sm-1 control-label">Folder:</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="path" placeholder="File Path" readonly>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="title" class="col-sm-1 control-label">Title:</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="title" placeholder="Track Title">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="name" class="col-sm-1 control-label">Name:</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="name" placeholder="Track Name">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="artist" class="col-sm-1 control-label">Artist:</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="artist" placeholder="Track Artist">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="album" class="col-sm-1 control-label">Album:</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="album" placeholder="Track Album">
                        </div>
                    </div>
                    <div class="form-group hide">
                        <label for="track" class="col-sm-1 control-label">Track:</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="track" placeholder="Track Number">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="year" class="col-sm-1 control-label">Year:</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="year" placeholder="2000">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="genre" class="col-sm-1 control-label">Genre:</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="genre" placeholder="pop">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="meta" class="col-sm-1 control-label">JSON:</label>
                        <div class="col-sm-10">
                            <textarea class="form-control" rows="5" id="meta" readonly></textarea>
                        </div>
                    </div>
                </form>
            </div>

            <div class="panel-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary btn-save" data-dismiss="modal">Save</button>
            </div>

        </div>
    </div>
</div>
