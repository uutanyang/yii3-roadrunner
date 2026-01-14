#!/usr/bin/env php
<?php
/**
 * Yii3 RoadRunner Worker Placeholder
 * This is a placeholder worker. Replace with your actual Yii3 worker.
 */

use Spiral\RoadRunner\Worker;
use Spiral\RoadRunner\Http\PSR7Worker;
use Nyholm\Psr7\Factory\Psr17Factory;

require 'vendor/autoload.php';

$worker = Worker::create();
$factory = new Psr17Factory();

$psr7 = new PSR7Worker(
    $worker,
    $factory,
    $factory,
    $factory
);

while ($req = $psr7->waitRequest()) {
    try {
        $response = $psr7->respond(
            new \Nyholm\Psr7\Response(
                200,
                ['Content-Type' => 'text/plain'],
                'Yii3 App Worker Ready'
            )
        );
    } catch (\Throwable $e) {
        $psr7->respond(new \Nyholm\Psr7\Response(500, [], $e->getMessage()));
    }
}
