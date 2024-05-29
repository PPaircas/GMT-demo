#!/bin/sh
rm *.png
fig_name=velmodFig
fig_fmt=png
data=smesh_contious_final1.dat
gridfile=model.grd

R=0/1220/0/70
J=M5i
incpt=rainbow
#cptfile=mycolor.cpt
cptfile=mydata.cpt
gmt makecpt -C$incpt -D -T1.5/8.0/0.5 -I -Z> $cptfile
#gmt makecpt -C0/191/255,0/205/0,192/255/62,255/215/0,255/20/147,255/165/0,220,122/55/139 \
#-D -T1/8/0.5 -Z > $cptfilie

gmt set FONT_TITLE = 15p,Helvetica,black
gmt set FONT_LABEL = 13p,Helvetica,black
gmt set FONT_ANNOT_PRIMARY = 13p,Helvetica,black
gmt set MAP_TITLE_OFFSET = 20p
gmt set MAP_ANNOT_OFFSET_PRIMARY = 5p
gmt set MAP_LABEL_OFFSET = 8p

gmt begin $fig_name $fig_fmt
	#gmt surface $data -R$R -I1i/1i -Z -V -G$gridfile
	gmt xyz2grd $data -G$gridfile -I1c/1c -R$R -ZLBA
	gmt grdimage $gridfile -R0/1220/0/70 -JX6i/-2i -C$cptfile -E300
	gmt basemap -BWSrt+t" " -Bxa100f50+l"Distance(km)" -Bya10f5+l"Depth(km)"
	gmt basemap -LjBR+o2.0c/-1.5c+w50k --FONT_LABEL=10p --FONT_ANNOT_PRIMARY=8p
	gmt colorbar -C$cptfile -DjBL+w4.0c/0.2c+o0c/-1.5c+ml+h -Bxa2f1+l"Velocity(km/s)" \
	--FONT_LABEL=8p --FONT_ANNOT_PRIMARY=8p --MAP_ANNOT_OFFSET_PRIMARY=2p --MAP_LABEL_OFFSET=5p
	gmt grdcontour $gridfile -C0.5 -A1.0+f8p+gwhite+pblack+f6p,black -Wa0.5p,black
	rm *.grd
gmt end