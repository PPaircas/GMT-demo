#!/bin/sh
#清理历史文件
#rm *.png

##设置参数
fig_name=contour
fig_format=png
grdfile=earth_relief_02m
#显示区域 输入格式：/经度小值/经度大值/纬度小值/纬度大值
lonmin=108 lonmax=120 latmin=4 latmax=12
range=$lonmin/$lonmax/$latmin/$latmax
#地图宽度(1i=2.54cm)
mapwidth=5i
#等值线线型
cwidth=0.15p awidth=0.35p
#等值线的间隔、标注的间隔
linc=1000 ainc=2000
#根据数据的Z值范围，制作色标，给等值线区域填充颜色
cptfile=mycolor.cpt
#选择GMT内置色标
incpt=bathy
gmt makecpt -C$incpt -D -T-6000/0/-50 -Icz > $cptfile

gmt begin $fig_name $fig_format
	#1. 绘制海岸线
	gmt coast -R$range -JM$mapwidth -Gburlywood -Sazure
	#2. 绘制等值线（-N选项可填充颜色）
	gmt grdcontour @$grdfile -C$linc -A$ainc -Gn1/1i -Wc$cwidth -Wa$awidth
	#3. 绘制底图边框、轴
	gmt basemap -BWNrb -Bxa4f1 -Bya4f1
	#4. 绘制比例尺
	gmt basemap -LjBR+o0c/-1.0c+w500k+f+l"Mercator projection.Scale,km"\
	--FONT_LABEL=8p  --MAP_LABEL_OFFSET=5p --FONT_ANNOT_PRIMARY=8p 
	#5. 绘制 GMT-logo
	gmt gmtlogo -DjBC+o0.2c/-1.3c+w1.5c -U+jBL+o-0.5c/-1.0c
	#6. 绘制色标
	#gmt colorbar -C$cptfile -DjBL+w5.0c/0.25c+o4c/-1.5c+h+ml -Bxaf+l"Depth(m)"\
	#--FONT_LABEL=10p --FONT_ANNOT_PRIMARY=10p --MAP_ANNOT_OFFSET_PRIMARY=2p --MAP_LABEL_OFFSET=5p

	#设置全局的标签字体格式
	gmt set FONT_ANNOT_PRIMARY = 10p,Helvetica,black
	gmt set MAP_TITLE_OFFSET = 20p
	gmt set MAP_ANNOT_OFFSET_PRIMARY = 5p
	gmt set MAP_LABEL_OFFSET = 8p

	project -C110/9 -E112/11 -G10 -Q |\
	grdtrack -G@$grdfile > $in_track
	# 輸出的檔是四欄：經度、緯度、距離、輸入網格的 z 值
	# psxy 預設使用前兩欄繪圖，所以儘管檔案有四欄資料，我們仍然不用加上任何指定欄位的參數
	plot $in_track -R -J -O -K -Wthick,darkred
	pstext -R -J -O -K -F+j+f14p,20,darkred << TEXTEND
	123.613 13.2236 RT A
	123.756 13.2862 LT B


gmt end 
