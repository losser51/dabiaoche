//
//  Const.h
//  dabiaoche
//
//  Created by xin.li on 14-6-2.
//  Copyright (c) 2014年 li losser. All rights reserved.
//

#ifndef dabiaoche_Const_h
#define dabiaoche_Const_h

//#define API_HOST @"http://112.126.66.203:8080/"
#define API_HOST                        @"http://api.dabiaoche.com/"
#define API_HOST_V1                     API_HOST"V1/"

#define API_HOST_GET_HOME_RANKING       API_HOST_V1"getHomeRanking"
#define API_HOST_BRANDS                 API_HOST_V1"getBrands"
#define API_HOST_CARMODELS_BY_BRAND     API_HOST_V1"getCarModels?brandId=%ld"
#define API_HOST_CARMODEL_BY_USER       API_HOST_V1"getCarModelByUserId?userId=%@"
#define API_HOST_CITYS                  API_HOST_V1"getCities"
#define API_HOST_LOGIN                  API_HOST_V1"login"
#define API_HOST_REGISTER               API_HOST_V1"register"
#define API_HOST_UPDATE_USER_INFO       API_HOST_V1"updateUserInfo"
#define API_HOST_SAVE_RECORDS           API_HOST_V1"saveRaceRecords"
#define API_HOST_GET_USER_TOP_RECORD    API_HOST_V1"getUserTopRecord"
#define API_HOST_HTMLADDRESS_BY_KEY     API_HOST_V1"getHtmlAddress?key=%@"

#define HTMLADDRESS_HOME    @"home"

#define IMAGE_URL_CARMODEL API_HOST"product/carModel/%@_120.jpg"

#define EDIT_MODEL_EMAIL    1
#define EDIT_MODEL_PASSWORD 2
#define EDIT_MODEL_NICKNAME 3

#endif
