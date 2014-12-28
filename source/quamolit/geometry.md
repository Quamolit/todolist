
This is the paint geometry documentation.
Schemas are in [Cirru JSON][json] to be compact.
Colors are in HSLa so that to be manipulated with [color][color,0.5].
Angles are defined in degree to be easier for written.

[color]: https://www.npmjs.com/package/color
[json]: https://www.npmjs.com/package/cirru-json

Shapes are defined in JSON and rendered in Canvas.
Each shape is defined to be modular, and with a base point.
Meanwhile performance is not the first priority.
This Spec is working in progress. Currently it contains these shapes:

* Line
* Path
* Text
* Arc
* Image
* Bezier
* Quadratic
* Shadow
* Gradient(not ready)
* Transform(not ready)
* Clip(not ready)

### Point

In this spec, point is written in:

```cirru
p 1 2
```

which expands to:

```cirru
map (:x 1) (:y 2)
```

And `P` is used to reprecent a random point as an example.

### Color

For HSLA colors, use this form:

```cirru
hsla 240 50 50 0.5
```

and expands to:

```cirru
":hsla(240,50%,50%,0.5)"
```

### Line

```cirru
map
  :type :line
  :base P
  :from P
  :to P
  :color $ hsla 240 50 50 0.5
  :close #true
  :fill #true
  :strokeStyle $ hsla 240 50 50 0.5
  :filleStyle $ hsla 240 50 50 0.5
```

### Path

```cirru
map
  :type :line
  :base P
  :from P
  :to P
  :color $ hsla 240 50 50 0.5
  :close #true
  :lineWidth 1
  -- cap can be: butt round square
  :lineCap :butt
  -- join can be: round round miter
  :lineJoin :round
  :miterLimit
```

### Text

```cirru
map
  :base P
  :from P
  :text :demo
  :family :Optima
  :size 14
  -- align can be: left right center
  :textAlign :center
  -- baseline can be: top middle bottom alphabetic
  :baseLine :middle
  :fillStyle $ hsla 240 50 50 0.5
```

### Arc

```cirru
map
  :type :arc
  :base P
  :from P
  :radius 10
  :startAngle 30
  :endAngle 60
  -- anti is short for anticlockwise
  :anti #true
  -- kind can be: fill stroke
  :kind :fill
  :fillStyle $ hsla 240 50 50 0.5
  :strokeStyle $ hsla 240 50 50 0.5
```

### Rect

Rect is position from its center, so is different from canvas:

```cirru
map
  :type :rect
  :base P
  :from P
  -- half of width and height
  :vector P
  -- kind can be: fill clear stroke
  :kind :fill
  :fillStyle $ hsla 240 50 50 0.5
  :strokeStyle $ hsla 240 50 50 0.5
```

### Image

```cirru
map
  :type :image
  :base P
  :from P
  -- full size of desired image
  :scaledVector P
  -- to slice image
  :sliceFrom P
  :sliceVector P
```

### Bezier

Quadratic is written the same but with only 1 point in between:

```cirru
map
  :type :quadratic
  :base P
  :from P
  :between $ array P P
  -- for quadratics, use a single point
  -- :between $ array P
  :to P
```

### Shadow

For shapes that have shadow, use this:

```cirru
:shadow $ map
  :vector P
  :blur 2
  :color $ hsla 240 50 50 0.5
```
