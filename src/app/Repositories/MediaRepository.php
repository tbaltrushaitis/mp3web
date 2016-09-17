<?php

namespace App\Repositories;

use Storage;
use Collection;

use App\MediaTrack;
use App\Audio;
use App\Video;

class MediaRepository {

    /**
     * Get all of the audio tracks
     *
     * @param  none
     * @return Collection
     */
    public function getTracksAudio () {
        $tracks =   [];
        $files  =   Storage::disk('audio')->allFiles();
        $sDir   =   storage_path('media/audio') . DIRECTORY_SEPARATOR;
        foreach ($files as $file) {
            $fileName   =   rawurldecode($file);
            $hash       =   md5_file($sDir . $fileName);
            if (Storage::disk('meta')->exists($hash)) {
                $meta   =   collect(json_decode(Storage::disk('meta')->get($hash), TRUE));
            }else{
                $meta   =   collect([
                    'id'        =>  $hash
                  , 'filename'  =>  $fileName
                  , 'path'      =>  dirname($fileName)
                  , 'title'     =>  basename($fileName)
                  , 'name'      =>  $fileName
                  , 'size'      =>  Storage::disk('audio')->size($file)
                  , 'url'       =>  'audio/' . $fileName
                  , 'added'     =>  time()
                ]);
                Storage::disk('meta')->put($hash, $meta->toJson());
                chmod(storage_path('app/metadata/' . $hash), 0664);
            }
            $tracks[]   =   $meta;
        }
        return $tracks;
    }

    /**
     * Get all of the video tracks
     *
     * @param  none
     * @return Collection
     */
    public function getTracksVideo () {
        $tracks =   collect(Storage::disk('video')->allFiles());
        return $tracks->all();
    }


    /**
     * Get Track's Metadata as JSON
     *
     * @param  none
     * @return Collection
     */
    public function getTrackMeta ($hash) {
        if (Storage::disk('meta')->exists($hash)) {
            $meta   =   collect(json_decode(Storage::disk('meta')->get($hash), TRUE));
        }else{
            $meta   =   collect([
                'id'        =>  $hash
              , 'filename'  =>  'no_media'
              , 'title'     =>  'File not exists'
              , 'name'      =>  'no_media'
              , 'url'       =>  'audio/no_media'
            ]);
        };
        return  $meta;
    }


    /**
     * Set Track's Metadata
     *
     * @param  none
     * @return Collection
     */
    public function setTrackMeta ($meta) {
        $hash   =   $meta->get('id');
        if (Storage::disk('meta')->put($hash, $meta->toJson())) {
            $meta->put('action_result', 'SUCCESS');
        }else{
            $meta->put('action_result', 'ERROR');
        };
        return  $meta;
    }

}
