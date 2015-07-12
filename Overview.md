#Livecoding relations between body, movement and sound

Workshop files available at [https://github.com/sensestage/livecoding_body_movement_sound](https://github.com/sensestage/livecoding_body_movement_sound)

*Examples are available in SuperCollider - by the end of the workshop, I hope to have more examples from all of you!*






## Introduction - movement with arms

- make different pathways/shapes around the body
- make the same movement with a different speed
- change the fluidity of the movement
- find oscillating movements

- *do the movements again - and vocalise the sound of the movement*





## Infrastructure

- [SenseStage MiniBee][1], with built-in accelerometer
- [minibee2osc][2] - to translate data between minibees and osc
- [xosc][3] - to distribute the minibee data to all participants

Thus: accelerometer -> MiniBee -> minibee2osc -> xosc -> each participant

The data has the format (osctag followed by arguments):

- ```/minibee/data id x y z```, where ```id``` is the number of the minibee (an integer), ```x y z``` are the three axes of acceleration (three floats).
- to subscribe to the data, you must send a message to XOSC: ```
/XOSC/subscribe/tag /minibee/data portno```. Here ```/minibee/data``` is a string argument indicating the osc-tag you are interested in. ```portno``` is the port that you will be listening on for incoming messages.

[1]: https://docs.sensestage.eu
[2]: https://github.com/sensestage/minibee2osc
[3]: https://github.com/sensestage/xosc





## First data exploration

- the data is scaled to be between 0 and 1
- the middle point of the data will be at 0.5
- as you turn the sensors slowly, you will find the three axes of gravity
- 1g is around 0.03 in the range; full range is 32 g (+/- 16g).

exercise: *make a first simple mapping of the 3 parameters to a sound*






## Mapping strategies

- *direct mapping* : data is mapped from one range to another
- *activity mapping* : change in data is mapped to parameters (activity, speed)
- *threshold triggering* : data is analyzed to find certain thresholds
- *conditional* : data is mapped under certain conditions (if activity is low, then one sounds plays, if activity is high, another sound is played and controlled)

exercise: *control 3 different sounds based on different types of movement/position*





## Livecoding mapping

exercise: *move while another person livecodes mappings of the data to sound*

- *discuss how the sound is influencing your movement and what sounds and/or movements you discover*
- *discuss how the movement is influencing your coding and/or mappings you discover*
- *switch roles and repeat*





## Networking

- Share data from your mapping algorithms with others by sending it to XOSC (port 57300), use a clear osctag: e.g. ```/myname/minibee1/x/inrange```

- Subscribe to the data of others, you must send a message to XOSC: ```
/XOSC/subscribe/tag /custom/osc/tag portno```. Here ```/custom/osc/tag``` is a string argument indicating the osc-tag you are interested in. ```portno``` is the port that you will be listening on for incoming messages.

- Use the conditioned data from others for conditional mapping of yours (keep existing data streams going)




## Group improvisation!

