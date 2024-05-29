#!/bin/sh
#输出文件名
fig_name=geoid_model_map
#输出文件格式、分辨率
fig_fmt=png dpi=300
#大地水准面数据（下载自公开数据源）
data=earth_geoid_01m
#显示区域 输入格式：/经度小值/经度大值/纬度小值/纬度大值
R=99/122/2/24
mapwidth=8i
#输入色标文件
#incpt=rainbow
master_cpt=no_green
in_cpt=geoid.cpt
in_shadow=geoid_shade.grd
#gmt makecpt -C$incpt -D -T-6000/4000/50 -Icz -Z > $cptfile
colwidth=0.2i colheight=5i

#依据网格文件生成CPT
gmt grd2cpt @$data -R$R -C$master_cpt > $in_cpt

gmt begin $fig_name $fig_fmt
    #设置光照梯度文件
    gmt grdgradient @$data -R$R -G$in_shadow -A45 -N5
    #1.绘制网格数据(-I 增加光照效果，-I+自动计算光照效果)
	gmt grdimage @$data -JM$mapwidth -R$R -I$in_shadow -C$in_cpt -E$dpi
    #2.绘制海岸线
    gmt coast -R$R -JM$mapwidth -Cblack@75 -W0.25p
    #3.绘制等值线
    gmt grdcontour @$data -C2 -A4 -Gn1/1i -Wthinnest,dimgray

    #3.绘制轴和边框
    gmt basemap -BWNrb -Bxa4f2g4 -Bya4f2g4
    #4.绘制比例尺
    gmt basemap -LjBR+o0c/-1.0c+w500k+f+l"Mercator projection.Scale,km"\
	--FONT_LABEL=8p  --MAP_LABEL_OFFSET=5p --FONT_ANNOT_PRIMARY=8p
    #绘制方向玫瑰图
    gmt basemap -TmjLB+o2c/1.5c+w2.5i+d-14.5+t45/10/5+i0.25p,blue+p0.25p,black+l\
    --FONT_ANNOT_PRIMARY=9p,Helvetica,black --FONT_ANNOT_SECONDARY=10p,Helvetica,black \
    --FONT_LABEL=10p,Times-Italic,black --FONT_TITLE=10p --MAP_TITLE_OFFSET=7p \
    --MAP_FRAME_WIDTH=1p --COLOR_BACKGROUND=black --MAP_DEFAULT_PEN=2p,black \
    --COLOR_BACKGROUND=black --MAP_VECTOR_SHAPE=0.5 --MAP_TICK_PEN_SECONDARY=thinner,red \
    --MAP_TICK_PEN_PRIMARY=thinner,blue
    #5.绘制色标
    gmt colorbar -C$in_cpt -DjBR+w$colheight/$colwidth+o-1.0c/0c+v -Bxaf -By+l"mGal" --FONT_ANNOT_PRIMARY=7p \
    --MAP_ANNOT_OFFSET_PRIMARY=3p
    #5.绘制GMT logo
    gmt gmtlogo -DjBC+o0.2c/-1.3c+w1.5c -U+jBL+o-0.5c/-1.0c
    #标签字体格式配置
    gmt set FONT_ANNOT_PRIMARY = 11p,Helvetica,black
    gmt set MAP_TITLE_OFFSET = 20p
    gmt set MAP_ANNOT_OFFSET_PRIMARY = 5p
    gmt set MAP_LABEL_OFFSET = 8p

gmt end

rm gmt.history *.grd
