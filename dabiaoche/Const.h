//
//  Const.h
//  dabiaoche
//
//  Created by xin.li on 14-6-2.
//  Copyright (c) 2014年 li losser. All rights reserved.
//

#ifndef dabiaoche_Const_h
#define dabiaoche_Const_h

#define API_HOST @"http://112.126.66.203:8080/"
#define API_HOST_BRANDS                 API_HOST"getBrands"
#define API_HOST_CARMODELS_BY_BRAND     API_HOST"getCarModels?brandId=%ld"
#define API_HOST_CARMODEL_BY_USER       API_HOST"getCarModelByUserId?userId=%@"
#define API_HOST_CITYS                  API_HOST"getCities"
#define API_HOST_LOGIN                  API_HOST"login"
#define API_HOST_REGISTER               API_HOST"register"
#define API_HOST_SAVE_RECORDS           API_HOST"saveRaceRecords"
#define API_HOST_HTMLADDRESS_BY_KEY     API_HOST"getHtmlAddress?key=%@"

#define HTMLADDRESS_HOME    @"home"

#define IMAGE_URL_CARMODEL API_HOST"product/carModel/%@_120.jpg"

#define EDIT_MODEL_EMAIL    1
#define EDIT_MODEL_PASSWORD 2
#define EDIT_MODEL_NICKNAME 3

#endif
