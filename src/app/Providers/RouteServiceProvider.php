<?php

namespace App\Providers;

use Illuminate\Support\Facades\Route;
use Illuminate\Foundation\Support\Providers\RouteServiceProvider as ServiceProvider;

class RouteServiceProvider extends ServiceProvider {

  /**
   * This namespace is applied to your controller routes.
   *
   * In addition, it is set as the URL generator's root namespace.
   *
   * @var string
   */
  protected $namespace = 'App\Http\Controllers';


  /**
   * Define your route model bindings, pattern filters, etc.
   *
   * @return void
   */
  public function boot() {
    //
    parent::boot();
  }


  /**
   * Define the routes for the application.
   *
   * @return void
   */
  public function map () {

    // $this->mapApiRoutes();

    // $this->mapWebRoutes();

    $this->mapAjaxRoutes();
    $this->mapAuthRoutes();
    $this->mapCabinetRoutes();
    $this->mapFrontRoutes();
    $this->mapMediaRoutes();

    //
  }


  /**
   * Define the "AJAX" routes for the application.
   *
   * @return void
   */
  protected function mapAjaxRoutes() {
    Route::middleware('web')
         ->namespace($this->namespace)
         ->group(base_path('routes/ajax.php'));
  }


  /**
   * Define the "AUTHENTICATE" routes for the application.
   *
   * @return void
   */
  protected function mapAuthRoutes() {
    Route::middleware('web')
         ->namespace($this->namespace)
         ->group(base_path('routes/auth.php'));
  }


  /**
   * Define the "CABINET" routes for the application.
   *
   * @return void
   */
  protected function mapCabinetRoutes() {
    Route::middleware('web')
         ->namespace($this->namespace)
         ->group(base_path('routes/cabinet.php'));
  }


  /**
   * Define the "frontend" routes for the application.
   *
   * These routes all receive session state, CSRF protection, etc.
   *
   * @return void
   */
  protected function mapFrontRoutes() {
    Route::middleware('web')
         ->namespace($this->namespace)
         ->group(base_path('routes/frontend.php'));
  }


  /**
   * Define the "media" routes for the application.
   *
   * @return void
   */
  protected function mapMediaRoutes() {
    Route::middleware('web')
         ->namespace($this->namespace)
         ->group(base_path('routes/media.php'));
  }


  /**
   * Define the "web" routes for the application.
   *
   * These routes all receive session state, CSRF protection, etc.
   *
   * @return void
   */
  protected function mapWebRoutes() {
    Route::middleware('web')
         ->namespace($this->namespace)
         ->group(base_path('routes/web.php'));
  }


  /**
   * Define the "api" routes for the application.
   *
   * These routes are typically stateless.
   *
   * @return void
   */
  protected function mapApiRoutes () {
    Route::prefix('api')
        ->middleware('api')
        ->namespace($this->namespace)
        ->group(base_path('routes/api.php'));
  }

}
