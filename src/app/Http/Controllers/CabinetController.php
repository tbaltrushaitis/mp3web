<?php

namespace App\Http\Controllers;

use App\Http\Requests;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

use Auth;
// use Input;
// use Storage;

use App\Repositories\MediaRepository;

class CabinetController extends Controller {

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
        $this->middleware('auth');
        $this->mediaRepository  =   $mediarepository;
    }

    /**
     * Show the application dashboard.
     *
     * @return \Illuminate\Http\Response
     */
    public function index () {
        return view('tracks.audio', [
            'tracks' =>  $this->mediaRepository->getTracksAudio()
        ]);
    }
}
