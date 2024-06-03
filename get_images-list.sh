#!/bin/bash
#
#*********************************************
#Author:                zhang
#QQ:                    200957079
#URL:                   vanblog.ztunan.top
#Date:                  2024-04-03
#Filename:              images-list.sh
#Description:           The test script
#*********************************************
#Harbor主机地址
Harbor_Address=harbor.zhang.org
#登录Harbor的用户
Harbor_User=admin
#登录Harbor的用户密码
Harbor_Passwd=123456
#镜像清单文件
Images_File=harbor-images-`date '+%Y-%m-%d'`.txt
#镜像tar包存放路径
Tar_File=/images/
set -x
#获取Harbor中所有的项目（Projects）
Project_List=$(curl -u ${Harbor_User}:${Harbor_Passwd}  -H "Content-Type: application/json" -X GET  harbor.zhang.org/api/v2.0/projects -k | python3 -m json.tool| grep name | awk '/"name": /' | awk -F '"' '{print $4}')
for Project in $Project_List;do
#循环获取项目下所有的镜像
	Image_Names=$(curl -u ${Harbor_User}:${Harbor_Passwd} "http://${Harbor_Address}/api/v2.0/projects/$Project/repositories?page=1&page_size=50"| python3 -m json.tool | grep name | awk '/"name": /' | awk -F '"' '{print $4}')
    for Image in $Image_Names;do
#循环获取镜像的版本（tag)
        Image_Tags=$(curl -u ${Harbor_User}:${Harbor_Passwd} -H "Content-Type: application/json" -X GET harbor.zhang.org/v2/$Image/tags/list -k | awk -F '"' '{print $8,$10,$12}')
	for Tag in $Image_Tags;do
#格式化输出镜像信息
        echo "$Harbor_Address/$Image:$Tag"   >> harbor-images-`date '+%Y-%m-%d'`.txt
        done
    done
done
