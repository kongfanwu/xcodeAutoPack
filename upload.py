#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import urllib.request
import json
import requests
import sys

print(sys.argv[1])
print(sys.argv[2])
print(sys.argv[3])

def uploadFile(productVersion=1.0, fileName=None, file=None):
    '''
    上传符号表
    :param productVersion: 版本号 1.0
    :param fileName: dSYM 文件名 dsym.dSYM.zip
    :param file: dSYM 文件路径 /Users/kongfanwu/Desktop/build_SIT/2018_06_28_20_58_16/dsym.app.dSYM.zip
    :return: None
    '''
    params = {'app_key': 'b92742df-9',
              'app_id': '320f77cc4c',
              'bugly_url': 'https://api.bugly.qq.com/openapi/file/upload/symbol',
              'bundleId': '',
              'api_version': '1',
              'symbolType': '2',
              'channel': 'DDSC'
             }
    params['productVersion'] = productVersion
    params['fileName'] = fileName
    params['file'] = file
    print(params)

    bugly_url = "https://api.bugly.qq.com/openapi/file/upload/symbol?" + 'app_key=' + params['app_key'] + '&' + 'app_id=' + params['app_id']
    print(bugly_url)

    files = {'file': open(file, 'rb')}

    res = requests.post(bugly_url, data=params, files=files)
    print(res.json())
    if res.json()['rtcode'] == 0:
        print('符号表上传成功')
    else:
        print('符号表上传失败')


uploadFile(sys.argv[1], sys.argv[2], sys.argv[3])
