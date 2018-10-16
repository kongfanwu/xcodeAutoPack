#author by 得力

#注意：脚本目录和WorkSpace目录在同一个目录
#工程名字(Target名字)
Project_Name="LiveneoMobileSurvey"
#workspace的名字
Workspace_Name="LiveneoMobileSurvey"
#配置环境，Release或者Debug,默认release
Configuration="Release"

#AdHoc版本的Bundle ID
AdHocBundleID="com.xxxx"
#AppStore版本的Bundle ID
AppStoreBundleID="com.xxxx"
#enterprise的Bundle ID
EnterpriseBundleID="cn.daokang.cliams.guoxh.b.su"

# ADHOC证书名#描述文件
ADHOCCODE_SIGN_IDENTITY="iPhone Distribution: xxxx"
ADHOCPROVISIONING_PROFILE_NAME="xxxxx-xxxx-xxxx-xxxx-xxxxxx"

#AppStore证书名#描述文件
APPSTORECODE_SIGN_IDENTITY="iPhone Distribution: xxxxx"
APPSTOREROVISIONING_PROFILE_NAME="xxxxx-xxxx-xxxx-xxxx-xxxxxx"

#企业(enterprise)证书名 钥匙串查看
ENTERPRISECODE_SIGN_IDENTITY="iPhone Distribution: Liveneo Information Technology Co.,Ltd"
#描述文件 可先手动导出选择描述文件时，找到描述文件路径，复制文件名
ENTERPRISEROVISIONING_PROFILE_NAME="7d810f5e-6bf7-47ce-abdf-7f9c7a3f66e9"

#加载各个版本的plist文件
ADHOCExportOptionsPlist=./ADHOCExportOptionsPlist.plist
AppStoreExportOptionsPlist=./AppStoreExportOptionsPlist.plist
EnterpriseExportOptionsPlist=./EnterpriseExportOptionsPlist.plist

ADHOCExportOptionsPlist=${ADHOCExportOptionsPlist}
AppStoreExportOptionsPlist=${AppStoreExportOptionsPlist}
EnterpriseExportOptionsPlist=${EnterpriseExportOptionsPlist}

###########################################################################
echo "~~~~~~~~~~~~选择打包平台(输入序号)~~~~~~~~~~~~~~~"
echo "		1 SIT"
echo "		2 UAT"
echo "		3 生产"

read environmentInput
environment="$environmentInput"
out_folder="build_SIT"
# 判读用户是否有输入
if [ -n "$environment" ]
then
	if [ "$environment" = "1" ]
    then
    	out_folder="build_SIT"
    elif [ "$environment" = "2" ]
    then
    	out_folder="build_UAT"
    elif [ "$environment" = "3" ]
    then
    	out_folder="build_生产"
    else
    echo "参数无效...."
    exit 1
    fi
fi

#指定项目的scheme名称
scheme=""
# 获取 scheme 名称
getFileName(){

	filepath2=$(cd "$(dirname "$0")"; ls) #获取当前文件夹下所有文件 
	for fileName in $filepath2; do # 遍历
		lenght=${#fileName} # 获取文件名 长度

		if [ $lenght -ge 12 ]; then # 文件名长度小于12
			fileHouZhuo=${fileName:($lenght-11):11} # 截取后11字符 
			if [ $fileHouZhuo = "xcworkspace" ]; then # 字符串相等
				xcworkspace=$fileName # 保留文件名
				scheme=${fileName:0:($lenght-12)}  # 保留文件名，不带后缀
			fi
		fi
	done

	#检测字符串是否为空，不为空返回 true。
	if [ $xcworkspace ]; then
		return 0
	fi

	for fileName in $filepath2; do
		lenght=${#fileName}
		echo $lenght $fileName

		if [ $lenght -ge 12 ]; then
			# echo ${fileName:($lenght-9):9} 
			fileHouZhuo=${fileName:($lenght-9):9} 
			if [ $fileHouZhuo = "xcodeproj" ]; then
				xcworkspace=$fileName
				scheme=${fileName:0:($lenght-10)} 
			fi
		fi
	done
}
# 调用方法。获取scheme名称
getFileName 

#假设脚本放置在与项目相同的路径下
project_path="$(pwd)"

#获取当前上一级目录
project_up_path=''
get_last_path(){
	scheme=$2
	current_path=$1
	scheme_lenght=${#scheme}
	current_path_lenght=${#current_path}
	last_path_lenght=$[$current_path_lenght-$scheme_lenght-1]
	project_up_path=`echo | awk '{print substr("'${current_path}'",0,"'${last_path_lenght}'")}'` 
	# echo $last_path
}
get_last_path $project_path $scheme

#取当前时间字符串添加到文件结尾
now=$(date +"%m-%d-%H-%M")
#指定要打包的配置名
configuration="Release"
#指定打包所使用的输出方式，目前支持app-store, package, ad-hoc, enterprise, development, 和developer-id，即xcodebuild的method参数
export_method='enterprise'


#指定输出路径
output_path="${project_up_path}/${out_folder}/${now}"
#符号表名
archive_name="archive.xcarchive"
# 符号表路径
archivePath="${output_path}/${archive_name}"


# echo "~~~~~~~~~~~~选择打包方式(输入序号)~~~~~~~~~~~~~~~"
# echo "		1 adHoc"
# echo "		2 AppStore"
# echo "		3 Enterprise"

# 读取用户输入并存到变量里
#read parameter
#sleep 0.5
method="3" #"$parameter"

# 判读用户是否有输入
if [ -n "$method" ]
then
    if [ "$method" = "1" ]
    then
#adhoc脚本
xcodebuild -workspace $Workspace_Name.xcworkspace -scheme $Project_Name -configuration $Configuration -archivePath build/$Project_Name-adhoc.xcarchive clean archive build CODE_SIGN_IDENTITY="${ADHOCCODE_SIGN_IDENTITY}" PROVISIONING_PROFILE="${ADHOCPROVISIONING_PROFILE_NAME}" PRODUCT_BUNDLE_IDENTIFIER="${AdHocBundleID}"
xcodebuild  -exportArchive -archivePath build/$Project_Name-adhoc.xcarchive -exportOptionsPlist ${ADHOCExportOptionsPlist} -exportPath ~/Desktop/$Project_Name-adhoc.ipa

    elif [ "$method" = "2" ]
    then
#appstore脚本
xcodebuild -workspace $Workspace_Name.xcworkspace -scheme $Project_Name -configuration $Configuration -archivePath build/$Project_Name-appstore.xcarchive archive build CODE_SIGN_IDENTITY="${APPSTORECODE_SIGN_IDENTITY}" PROVISIONING_PROFILE="${APPSTOREROVISIONING_PROFILE_NAME}" PRODUCT_BUNDLE_IDENTIFIER="${AppStoreBundleID}"
xcodebuild  -exportArchive -archivePath build/$Project_Name-appstore.xcarchive -exportOptionsPlist ${AppStoreExportOptionsPlist} -exportPath ~/Desktop/$Project_Name-appstore.ipa

    elif [ "$method" = "3" ]
    then
#企业打包脚本
xcodebuild -workspace $Workspace_Name.xcworkspace -scheme $Project_Name -configuration $Configuration -archivePath ${archivePath} archive build CODE_SIGN_IDENTITY="${ENTERPRISECODE_SIGN_IDENTITY}" PROVISIONING_PROFILE="${ENTERPRISEROVISIONING_PROFILE_NAME}" PRODUCT_BUNDLE_IDENTIFIER="${EnterpriseBundleID}"
xcodebuild  -exportArchive -archivePath build/$Project_Name-enterprise.xcarchive -exportOptionsPlist ${EnterpriseExportOptionsPlist} -exportPath "${output_path}"
    else
    echo "参数无效...."
    exit 1
    fi
fi

# 打开文件夹
open ${output_path}

# 获取app版本号 PlistBuddy框架是读取plist文件的
appInfoPath="$(pwd)/${Project_Name}/Info.plist"
bundleShortVersionString=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" ${appInfoPath})
echo "bundleShortVersionString=${bundleShortVersionString}"

# 压缩符号表 q:不显示log r:文件夹内部文件也压缩 m:压缩完，删除原文件
zip -q -r -m $archivePath.zip $archivePath

# 上传符号表
./upload.py ${bundleShortVersionString} ${archive_name} ${archivePath}.zip
