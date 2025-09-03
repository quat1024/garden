# Digital cameras

Thinking about purchasing my first digital camera, wanted to write down some of the jargon I keep seeing.

## Digital camera types

* *DSLR*: *digital single lens reflex*. Older style of digital camera. Characterized by use of a mirror to reflect light from the sensor into the viewfinder or the camera sensor.
* *mirrorless*: "Newer" type of camera (about 2010) characterized by not using a mirror, viewfinder is all electronic.

The mirror isn't really the important part. The mirror exists to overcome technology limitations; DSLRs started out not powerful enough to read the image from the sensor and display it on the LCD in real time (something I take for granted when I shoot on a phone). Mirrorlesses have more fancy pants technological features because their technology is powerful enough to do exactly that.

Those are the big interchangeable lens cameras. For cheaper cameras there's "compact cameras" and the like.

## Lens mounts?

DSLRs and mirrorlesses need a lens. The lens mount system encompasses:

* physical connector things, like the diameter of the screw threads/placements of bayonets
* electronic things, like the method the camera uses to communicate with the lens for autofocus
* standardized things outside of the actual connection mechanism, like where the lens expects the image sensor to be placed inside the camera (the "flange focal distance")

"Does this lens fit on this camera", including subproblems like "does the autofocus on this lens work when mounted on this camera", is a thorny problem. You pretty much need a table ([example for nikon lenses](https://www.kenrockwell.com/nikon/compatibility-lens.htm#dslr)). [This post](https://wycameras.com/blogs/news/35mm-slr-lens-mount-identification-guide-1) from a camera club-nee-store seems to be a good overview of the subject *for film lenses*.

The impression I'm getting is that it's kind of like railroad gauge or CPU sockets. It also seems like any remotely popular camera will have a good-enough selection of lenses available especially because I just want a basic one.

## Buying used cameras

Two camera stores I know of in columbus:

* [Midwest Photo](https://mpex.com/). New and used cameras and all sorts of stuff.
* [World of Photography](https://www.worldofusedphotography.com/). Used cameras and... they're the mom-and-poppiest of mom-and-pops and barely have a web presence, so I don't know exactly what they sell.

Probably looking for a used DSLR because that will be the cheapest. If it doesn't come with a lens, I do enjoy shooting slightly zoomed-in / using the telephoto when I take pictures with my Pixel, so given the choice I might err on the side of a longer focal length.

## Sensor sizes

All the language comes from 35mm film. A "full frame" sensor is a sensor with the same size as a single frame of 35mm film. They came out relatively late in the world of digital cameras.

Any sensor smaller than a slice of 35mm film is called a "crop sensor". The "APS-C" size sensor seems to be a common one. Nikon refers to APS-C as "DX format". Canon cameras use a slightly smaller version of the APS-C standard but it's pretty close.

When a lens is sized for an APS-C size sensor but you use it on a full-frame camera, you'd get *vingetting* where the image viewed through the lens doesn't fill the camera sensor. When the lens is sized for a full-frame sensor (or sized for actual 35mm film) but you use it on an APS-C size camera, you'd get *cropping* where the image is more zoomed in than it would be on a 35mm film camera.

## Focal lengths

The focal length of a *lens* is the distance at which all the light from it converges at a point. Imagine burning a mark in the pavement with a magnifying glass. The focal length of the magnifying glass is the distance from the glass to the hot point.

A shorter focal length means the hot point is closer to the lens; the lens bends light more strongly. A longer focal length means light has not been bent as much by the lens.

If a sensor is placed *at* the focal point it'd just capture a dot, but if the sensor is placed before or after the focal point an image can be captured (imagine the pinhole camera). This is why shorter focal length lenses have a wider field-of-view; they bend light more, compressing more of the world onto an area the size of the camera sensor. Longer focal length lenses have a narrower field-of-view because they do not bend light as much.

Focal length is inversely related to field-of-view. Shorter focal lengths have wider fields-of-view; narrower fields-of-view correspond to longer focal lengths.

### Focal length (physical quantity) vs focal length (photography term)

(The term "35mm" is not a focal length. It's a film format.)

Again we have language coming from 35mm film: 35mm photographers wanting a certain look learned to reach for a lens with a specific focal length. When using a smaller sensor, a lens will need to bend light more (have a shorter focal length) to fill the sensor the same way and produce the same creative effect. So in reference to a specific camera or sensor size, people might say a lens is "50mm equivalent to 35mm" to mean: when using the lens on this camera, it has the same look as a 50mm lens *would* have on a 35mm film camera. Even if the actual focal length of the lens is not 50 millimeters.

Basically "35mm equivalent focal lengths" are just the unit photographers use to talk about field-of-view.

Non-full frame sensors have a "crop factor" in relation to a full-frame sensor. An APS-C sensor has a crop factor of 1.5. This means the focal length (physical quantity) of a lens is multiplied by 1.5 to determine the effective focal length (photography term) when a picture is taken with that combination of lens and camera. This is because the smaller sensor captures a smaller portion of the lens's usable output. (A "medium format" camera, which is any camera with a sensor larger than 35mm film, has a crop factor less than 1.)

People say a 50mm lens has a similar amount of perspective-distortion as the human eye, so your "typical" lens will have a 35mm-equiv focal length of around 40-60mm. Shorter than that is wideangle, shorter still is fisheye territory. Longer than that is portrait ("short telephoto"), longer still is telephoto.

## Aperture

The size of the pinhole light comes through.

The unit is the slightly-odd "f-stop". A small F stop means the hole is open very wide, and a large F stop means the hole is very small.

Aperture controls two things: the amount of light hitting the sensor (obviously) and a depth-of-field effect. Wide apertures (small F numbers) create a narrow depth-of-field; more scattered light can come in and blur the image. Narrow apertures (large F numbers) reduce the amount of scattered light and create a wide depth-of-field: an image that's sharp all the way to the back.

Phone cameras, generally, cannot adjust the aperture. Some photo apps use F-stop terminology to talk about the degree of fake blur they add in post.

## Shutter speed

This one's pretty intuitive, it's just how long the sensor is allowed to accumulate light. Faster shutter speeds freeze motion, shorter speeds introduce motion blur.

Fast shutter speed also means less total light hits the sensor, so the image will be darker.

## ISO

Yes, it's just named after the International Standards Organization.

This is *film speed*, the sensitivity of a camera to light. In film, the ISO is a chemical property of the film material and cannot be changed. In digital cameras, the ISO is related to the gain applied to the image sensor and can be changed. The meaning of the number is, as usual, "whatever film is equivalent to this digital process".

Low ISO means the sensor is not very sensitive and more light is required to light up a pixel. High ISO means less light is required to light up a pixel. High ISO also introduces more sensor noise.

Advice I received in the photography class: Keep the ISO as low as you can go, prefer to adjust aperture and shutter speed first. This keeps the amount of sensor noise in check. Don't use ISO as a get-out-of-jail-free card to work around picking the wrong aperture or shutter speed.

On my phone, adjusting the ISO actually keeps the image at roughly the same brightness, until you look over and find it's automatically picked a ridiculously fast shutter speed to compensate.

## "Exposure triangle"

Aperture, shutter speed, and ISO all change the amount of light received by the sensor. If you want to change one property but keep the brightness of the image the same, you need to adjust one of the other properties to compensate.

## Digital zoom

Cropping.






