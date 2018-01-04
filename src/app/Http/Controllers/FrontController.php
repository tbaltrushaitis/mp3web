<?php

namespace App\Http\Controllers;

use App\Http\Requests;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use App\Repositories\MediaRepository;

class FrontController extends Controller {

    /**
     * The MediaRepository
     *
     * @var MediaRepository
     */
    protected   $mediaRepository;


    /**
     * Create a new controller instance.
     *
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
    public function index () {
        $arrTracks  =   $this->mediaRepository->getTracksAudio();
        return  view('frontend', [
                    'tracks'    =>  array_sort($arrTracks, function ($track) {
                                        return -1 * $track->get('plays', 0);
                                    })
                ]);
    }

}
