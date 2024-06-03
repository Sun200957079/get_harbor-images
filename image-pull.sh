#!/bin/bash
#
#*********************************************
#Author:                zhang
#QQ:                    200957079
#URL:                   vanblog.ztunan.top
#Date:                  2024-04-03
#Filename:              image-pull.sh 
#Description:           The test script
#*********************************************
cd /data/images
Image_tags=`ls | grep harbor | uniq|xargs cat`
for image_tag in $Image_tags;do
    image_Name=$(echo $image_tag | awk -F'[/|:]' '{print $3}')
    image_Lable=$(echo $image_tag | awk -F'[/|:]' '{print $4}')
#使用docker从镜像文件中下载镜像
    docker pull $image_tag
#将下载的镜像进行打包保存
    docker save $image_tag  -o $image_Name-$image_Lable.tar
#删除下载到本地的镜像
    docker rmi  $image_tag
#打包所有镜像为一个文件并使用gzip压缩,注意磁盘空间!!!
	tar -cvf - *.tar | gzip > images_all.tar.gz
done
