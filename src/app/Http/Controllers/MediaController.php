<?php

namespace App\Http\Controllers;

use App\Http\Requests;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

use Auth;
use Input;
use Storage;

use App\Repositories\MediaRepository;
use App\Audio;
use App\Video;

class MediaController extends Controller {

    /**
     * The MediaRepository
     *
     * @var MediaRepository
     */
    protected   $mediaRepository;


    /**
     * Create a new controller instance.
     *
     * @param  MediaRepository  $mediarepository
     * @return void
     */
    public function __construct (MediaRepository $mediarepository) {
        // $this->middleware('auth');
        $this->mediaRepository  =   $mediarepository;
    }


    /**
     * Display a list of all audiotracks
     * @param  none
     * @return View
     */
    public function listAudio () {
        $arrTracks  =   $this->mediaRepository->getTracksAudio();
        return  view('welcome', [
                    'tracks'    =>  array_sort($arrTracks, function ($track) {
                                        return -1 * $track->get('plays', 0);
                                    })
                ]);
    }


    /**
     * Play - provide track's metadata as JSON
     * @param  String $id
     * @return Response JSON
     */
    public function mediaPlay ($id) {
        $meta   =   $this->mediaRepository->getTrackMeta($id);
        $plays  =   $meta->get('plays', 0);
        $meta->put('plays', ++$plays);
        $this->mediaRepository->setTrackMeta($meta);
        return response()->json($meta);
    }


    /**
     * Rate - add like/dislike vote
     * @param  $id, $vote
     * @return Response JSON
     */
    public function mediaRate ($id, $vote) {
        $meta       =   $this->mediaRepository->getTrackMeta($id);
        $rateKey    =   $vote . 's';
        $rateCur    =   $meta->get($rateKey, 0);
        $meta->put($rateKey, ++$rateCur);
        $saveResult =   $this->mediaRepository->setTrackMeta($meta);
        $saveResult->put('action', $vote);
        return response()->json($saveResult);
    }


    /**
     * Drop - delete track's metadata
     * @param  $id
     * @return Response JSON
     */
    public function mediaDrop ($id) {
        // $this->middleware('auth');
        $actionResult =   $this->mediaRepository->dropTrack($id);
        $actionResult->put('action', 'DROP');
        // return response()->json($actionResult);
        return redirect()->action('HomeController@index')->with('status', 'Track Metadata removed!');
    }

}
