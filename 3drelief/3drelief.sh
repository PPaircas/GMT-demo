#!/bin/sh
fig_name=relief_SCS_3D
fig_fmt=png
in_data=earth_relief_30s.grd
in_shadow=earth_relief_2m_Afar_shadow.grd
R=108/122/4/24
J=M5i
incpt=geo
cptfile=mydata.cpt
out_ps=3D_relief.ps
#gmt makecpt -C -D -T-Icz -Z > $cptfile

gmt begin $fig_name $fig_fmt
    #01 设置光照梯度文件
    gmt grdgradient @$in_data -R$R -G$in_shadow -A275 -N10
    #02 制作3D底图与添加地图元素
    gmt basemap -R108/122//4/24/-4/3 -JM5i -JZ1.6i -p145/30 -B2 -Bz2+lkm -BSEwnZ 
    #03 绘制3D视图
    gmt grdview @$in_data -R108/122/4/24/-4000/3000 -I$in_shadow -J$J -JZ0.6i \
    -N1000+ggray -p -C$incpt -Qi500 
    #04 绘制装饰物指南针
    #gmt psbasemap -JZ -p -TdjRB+w1.5c+l,,,N+o2c/0c >> $out_ps
    #05 转换文件格式(GMT5)
    #psconvert $out_ps -A -P -F -Tg
    gmt set GMT_DATA_UPDATE_INTERVAL = 1d
gmt end
rm *.grd *.ps