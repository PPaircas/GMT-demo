#!/bin/bash
fig_name=model
fig_fmt=png

gmt begin $fig_name $fig_fmt
gmt set MAP_TICK_LENGTH_PRIMARY -0.1c
gmt set FONT_TITLE = 17p,Helvetica,black
gmt set FONT_LABEL = 15p,Helvetica,black
gmt set FONT_ANNOT_PRIMARY = 13p,Helvetica,black
gmt set MAP_TITLE_OFFSET = 15p
gmt set MAP_ANNOT_OFFSET_PRIMARY = 5p
gmt set MAP_LABEL_OFFSET = 8p

model=model.txt
gmt basemap -R0/10/0/50 -JX8c/-10c -Bx1+l"Velocity (km/s)" -By10+l"Depth (km)" -BWSrt+t'Crust model'
# 利用 awk 计算每一层上下边界的深度，提取该层的速度
# 每一层上边界的深度即为前几层的厚度累加，下边界的深度为上边界的深度加该层层厚
# Vs
awk 'BEGIN{d1=0;d2=0}{d2=d2+$1;print $2,d1;print $2,d2;d1=d2;}' $model | gmt plot -W1.5p,blue
# Vp
awk 'BEGIN{d1=0;d2=0}{d2=d2+$1;print $3,d1;print $3,d2;d1=d2;}' $model | gmt plot -W1.5p,red,6_2:2awk
gmt legend -DjBL+w2c+o0.2c/0.2c -F << EOF
S 0.4c - 0.5c - 1p,blue 1c @;blue;Vs@;;
S 0.4c - 0.5c - 1p,red,6_2:0 1c @;red;Vp@;;
EOF
gmt end