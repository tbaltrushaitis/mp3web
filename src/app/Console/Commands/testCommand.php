<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;

class testCommand extends Command {

  /**
   * The name and signature of the console command.
   *
   * @var string
   */
  protected $signature = 'mp3:greet';

  /**
   * The console command description.
   *
   * @var string
   */
  protected $description = 'Greeting command';

  /**
   * Create a new command instance.
   *
   * @return void
   */
  public function __construct() {
    parent::__construct();
  }

  /**
   * Execute the console command.
   *
   * @return mixed
   */
  public function handle() {
    echo PHP_EOL . "Output of [" . $this->signature . "]: [" . $this->description . "]" . PHP_EOL;
  }

}
