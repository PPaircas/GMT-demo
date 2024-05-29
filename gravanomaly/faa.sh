#!/bin/sh
#输出文件名
fig_name=free-air_anomaly
#输出文件格式、分辨率
fig_fmt=png dpi=300
#自由空间重力异常数据（下载自公开数据源）
data=earth_faa_01m
#显示区域 输入格式：/经度小值/经度大值/纬度小值/纬度大值
R=102/132/2/22
mapwidth=10i
#输入色标文件
#incpt=rainbow
#master_cpt=spectral.cpt
master_cpt=panoply
in_cpt=faa.cpt
in_shadow=faa_shade.grd
#gmt makecpt -C$incpt -D -T-6000/4000/50 -Icz -Z > $cptfile
colwidth=0.2i colheight=5i

#依据网格文件生成CPT
gmt grd2cpt @$data -R$R -C$master_cpt -I > $in_cpt

gmt begin $fig_name $fig_fmt

    #设置光照梯度文件
    gmt grdgradient @$data -R$R -G$in_shadow -A45 -N5
    #1.绘制网格数据(-I 增加光照效果，-I+自动计算光照效果)
	gmt grdimage @$data -JM$mapwidth -I$in_shadow -R$R -C$in_cpt -E$dpi
    #2.绘制海岸线
    gmt coast -R$R -JM$mapwidth -C -W0.25p
    #3.绘制轴和边框
    gmt basemap -BWNrb -Bxa4f2g4 -Bya4f2g4
    #4.绘制比例尺
    gmt basemap -LjBR+o0c/-1.0c+w500k+f+l"Mercator projection.Scale,km"\
	--FONT_LABEL=8p  --MAP_LABEL_OFFSET=5p --FONT_ANNOT_PRIMARY=8p 
    #5.绘制色标
    gmt colorbar -C$in_cpt -DjBR+w$colheight/$colwidth+o-1.0c/0c+v -Bxaf -By+l"mGal" --FONT_ANNOT_PRIMARY=7p \
    #--MAP_ANNOT_OFFSET_PRIMARY=3p
    #5.绘制GMT logo
    gmt gmtlogo -DjBC+o0.2c/-1.3c+w1.5c -U+jBL+o-0.5c/-1.0c
    #标签字体格式配置
    gmt set FONT_ANNOT_PRIMARY = 11p,Helvetica,black
    gmt set MAP_TITLE_OFFSET = 20p
    gmt set MAP_ANNOT_OFFSET_PRIMARY = 5p
    gmt set MAP_LABEL_OFFSET = 8p

gmt end

rm *.grd gmt.history
