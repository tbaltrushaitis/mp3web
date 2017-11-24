<?php

return [

  /*
  |--------------------------------------------------------------------------
  | Default Filesystem Disk
  |--------------------------------------------------------------------------
  */

  'default' => 'local'

  /*
  |--------------------------------------------------------------------------
  | Default Cloud Filesystem Disk
  |--------------------------------------------------------------------------
  */

  , 'cloud' => 's3'

  /*
  |--------------------------------------------------------------------------
  | Filesystem Disks
  |--------------------------------------------------------------------------
  */

  , 'disks' => [

      'local' => [
          'driver' => 'local'
        , 'root'   => storage_path('app')
      ]

    , 'public' => [
          'driver'     => 'local'
        , 'root'       => storage_path('app/public')
        , 'visibility' => 'public'
      ]

    /*
    |----------------------------------------------------------------------
    | Media Storage
    |----------------------------------------------------------------------
    */
    , 'media' => [
          'driver'     => 'local'
        , 'root'       => storage_path('media')
        , 'visibility' => 'public'
      ]

    , 'audio' => [
          'driver'     => 'local'
        , 'root'       => storage_path('media/audio')
        , 'visibility' => 'public'
      ]

    , 'video' => [
          'driver'     => 'local'
        , 'root'       => storage_path('media/video')
        , 'visibility' => 'public'
      ]

    , 'meta' => [
          'driver'     => 'local'
        , 'root'       => storage_path('app/metadata')
        , 'visibility' => 'public'
      ]

  ]

];
