//
//  Const.h
//  dabiaoche
//
//  Created by xin.li on 14-6-2.
//  Copyright (c) 2014年 li losser. All rights reserved.
//

#ifndef dabiaoche_Const_h
#define dabiaoche_Const_h


#pragma mark api

//#define API_HOST @"http://112.126.66.203:8080/"
#define API_HOST                        @"http://api.dabiaoche.com/"
#define API_HOST_V1                     API_HOST"V1/"

//首页排行列表
#define API_HOST_GET_HOME_RANKING       API_HOST_V1"getHomeRanking"
//品牌列表
#define API_HOST_BRANDS                 API_HOST_V1"getBrands"
//车型列表
#define API_HOST_CARMODELS_BY_BRAND     API_HOST_V1"getCarModels?brandId=%ld"
//个人默认车型
#define API_HOST_CARMODEL_BY_USER       API_HOST_V1"getCarModelByUserId?userId=%@"
//城市列表
#define API_HOST_CITYS                  API_HOST_V1"getCities"
//登陆
#define API_HOST_LOGIN                  API_HOST_V1"login"
//注册
#define API_HOST_REGISTER               API_HOST_V1"register"
//设置个人信息
#define API_HOST_UPDATE_USER_INFO       API_HOST_V1"updateUserInfo"
//保存测试成绩
#define API_HOST_SAVE_RECORDS           API_HOST_V1"saveRaceRecords"
//个人成绩
#define API_HOST_GET_USER_TOP_RECORD    API_HOST_V1"getUserTopRecord"
//首页广告html地址
#define API_HOST_HTMLADDRESS_BY_KEY     API_HOST_V1"getHtmlAddress?key=%@"

#pragma mark 常量

//首页广告地址获取key
#define HTMLADDRESS_HOME    @"home"
//根据车型id拼车型图片
#define IMAGE_URL_CARMODEL API_HOST"product/carModel/%@_120.jpg"

//编辑框类型
#define EDIT_MODEL_EMAIL    1
#define EDIT_MODEL_PASSWORD 2
#define EDIT_MODEL_NICKNAME 3

#endif
