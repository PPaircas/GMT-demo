#!/bin/sh
fig_name=snapshot
fig_fmt=png
data=snap_shot_xz_t800ms.bin
gridfile=model.grd

R=0/299/0/299
J=JX
incpt=seis
cptfile=seis
#gmt makecpt -C$incpt -D -T0/1 -Icz -Z > $cptfile

gmt set FONT_TITLE = 15p,Helvetica,black
gmt set FONT_LABEL = 15p,Helvetica,black
gmt set FONT_ANNOT_PRIMARY = 13p,Helvetica,black
gmt set MAP_TITLE_OFFSET = 20p
gmt set MAP_ANNOT_OFFSET_PRIMARY = 5p
gmt set MAP_LABEL_OFFSET = 8p

gmt begin $fig_name $fig_fmt
	#gmt surface $data -R$R -I1i/1i -Z -V -G$gridfile
	gmt xyz2grd $data -G$gridfile -I1c/1c -R$R -ZTLf
	gmt grdimage $gridfile -R0/300/0/300 -JX3.0i/-3.0i -C$cptfile -E300
	gmt basemap -BWNbr+t" " -Bxa50f50+l"Distance(m)" -Bya50f50+l"Depth(m)"	
	#gmt colorbar -C$cptfile -DjMR+w5.0c/0.5c+o-0.8c/0c+m -B+l"Velocity(km/s)"	
	rm *.grd
gmt end