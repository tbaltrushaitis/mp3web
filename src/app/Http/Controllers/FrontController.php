<?php

namespace App\Http\Controllers;

use App\Http\Requests;
use Illuminate\Http\Request;

use App\Http\Controllers\Controller;

class FrontController extends Controller {
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct () {
        // $this->middleware('guest');
    }

    /**
     * Show the application landing.
     *
     * @return \Illuminate\Http\Response
     */
    public function index () {
        return view('welcome');
    }
}
