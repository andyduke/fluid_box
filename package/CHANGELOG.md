## 3.0.0

* Update Flutter dependencies, set Flutter >=3.3.0 and Dart to >=2.18.0 <4.0.0

## 2.1.0

* Added support for `TextDirection` and `Directionality`.

## 2.0.3

* Improved algorithm for determining the allowed width of the child widget.

## 2.0.2

* The algorithm for determining the minimum width of child widgets has been changed, for example, for widgets such as `TextField` and other widgets that try to fill all the available space. Now such widgets do not expand beyond the specified in `fluid` proportions in the line.

## 2.0.1

* Fixed a bug with calculating the available space when spacing is greater than zero.

## 2.0.0

* Migrate to null safety.

## 2.0.0-nullsafety.0

* Migrate to null safety.

## 1.0.1

* Added check for division by zero.

## 1.0.0

* Initial version.
