
This is the paint geometry documentation.
Schemas are in [Cirru JSON][json] to be compact.
Colors are in HSL so that to be manipulated with [color][color].
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
* Gradient

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

### Line

```cirru
map
  :type :line
  :base P
  :from P
  :to P
  :color ":hsl(240,50%,50%)"
  :close #true
  :fill #true
  :strokeStyle ":hsl(240,50%,50%)"
  :filleStyle ":hsl(240,50%,50%)"
```

### Path

```cirru
map
  :type :line
  :base P
  :from P
  :to P
  :color ":hsl(240,50%,50%)"
  :close #true
  :lineWidth 1
  -- cap can be: butt round square
  :lineCap :butt
  -- join can be: round round miter
  :lineJoin :round
  :miterLimit
```

### Text

### Arc

```cirru
map
  :type :arc
  :base P
  :from P
  :startAngle 30
  :endAngle 60
  :close #true
```

### Rect

Rect is position from its center, so is different from canvas:

```cirru
map
  :type :rect
  :base P
  :from P
  -- half of width and height
  :halfVector P
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

### Gradient
