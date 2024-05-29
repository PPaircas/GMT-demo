#!/bin/sh

#输出文件名
fig_name=relief_SCS
#输出文件格式、分辨率
fig_fmt=png dpi=300
#地形起伏网格数据（下载自公开数据源）
data=earth_relief_30s.grd
#显示区域 输入格式：/经度小值/经度大值/纬度小值/纬度大值
R=106/122/12/24
mapwidth=5i
#输入色标文件
incpt=geo
cptfile=mydata.cpt
#gmt makecpt -C$incpt -D -T-6000/4000/50 -Icz -Z > $cptfile
colwidth=0.1i colheight=2.5i

#标签字体格式配置
gmt set FONT_ANNOT_PRIMARY = 11p,Helvetica,black
gmt set MAP_TITLE_OFFSET = 20p
gmt set MAP_ANNOT_OFFSET_PRIMARY = 5p
gmt set MAP_LABEL_OFFSET = 8p

gmt begin $fig_name $fig_fmt
    #1.绘制网格数据
	gmt grdimage @$data -JM$mapwidth -R$R -C$incpt -I+ -E$dpi
    #gmt grdcontour @$data -C1000 -A2000 -Gn1/1i -Wthinnest
    #2.绘制轴和边框
    gmt basemap -BWNrb -Bxa4f2g4 -Bya4f2g4
    #3.绘制比例尺
    gmt basemap -LjBR+o0c/-1.0c+w500k+f+l"Mercator projection.Scale,km"\
	--FONT_LABEL=8p  --MAP_LABEL_OFFSET=5p --FONT_ANNOT_PRIMARY=8p 
    #4.绘制色标
    gmt colorbar -C$incpt -DjBR+w$colheight/$colwidth+o-1.0c/0c+v -Bxa2000f1000 -By+l"m" --FONT_ANNOT_PRIMARY=7p \
    --MAP_ANNOT_OFFSET_PRIMARY=3p
    #5.绘制GMT logo
    gmt gmtlogo -DjBC+o0.2c/-1.3c+w1.5c -U+jBL+o-0.5c/-1.0c
    #6.绘制右小角研究区域小地图
    #gmt inset begin -DjBR+w4c/4c+o0.1c 
    #    gmt grdimage @earth_relief_01d -Rg -JG100/14/? -C$incpt -Bg
    #    echo 106 2 122 24 | gmt plot -Sr+s -W1p,blue
    #gmt inset end
gmt end

rm gmt.conf
