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

class AjaxController extends Controller {

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
        $this->middleware('auth');
        $this->mediaRepository  =   $mediarepository;
    }


    /**
     * getMeta - provide track's metadata as JSON
     * @param  Hash  $id
     * @return Response
     */
    public function getMeta ($id) {
        $meta   =   $this->mediaRepository->getTrackMeta($id);
        return response()->json($meta);
    }

    /**
     * updateMeta - Update Track's metadata
     * @param  Hash  $id
     * @return Response
     */
    public function updateMeta (Request $request) {
        $params =   collect(Input::all());
        $hash   =   $params->get('id');
        $meta   =   $this->mediaRepository->getTrackMeta($hash);
        $merged =   $meta->merge($params);
        $saveResult =   $this->mediaRepository->setTrackMeta($merged);
        $saveResult->put('action', 'save');
        return response()->json($saveResult);
    }


    /**
     * Create a new MediaFile.
     *
     * @return \Illuminate\Http\Response
     */
    public function create () {
        //
    }


    /**
     * Store an Media Track in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store (Request $request) {
        //
    }


    /**
     * Update Media Track in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $bet
     * @return \Illuminate\Http\Response
     */
    public function update (Request $request) {
        //
    }


    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show ($id) {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit ($id) {
        //
    }


    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy ($id) {
        //
    }

}
