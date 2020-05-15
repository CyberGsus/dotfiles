#!/bin/sh

TRANSITION=1.75
pushd ~/.config/qtile/custom/wallpapers > /dev/null
current=$( [ -f current ] && cat current || echo "$1")
cp -f $current old.bg
cp -f $1 new.bg
echo $1 > current
if [ -f current ]; then
  for i in `seq 0 $TRANSITION 100`; do
    convert old.bg -fill black -colorize $i% transition.bg
    feh --bg-fill transition.bg
  done
fi
for i in `seq 100 -$TRANSITION 0`; do
  convert new.bg -fill black -colorize $i% transition.bg
  feh --bg-fill transition.bg
done
feh --bg-fill new.bg
rm -f *.bg
popd  > /dev/null

