
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
```

### Path

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
  :width 10
  :height 10
```

### Image

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
