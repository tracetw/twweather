//
// TWAPIBox+Info.m
//
// Copyright (c) Weizhong Yang (http://zonble.net)
// All Rights Reserved
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
//
//     * Redistributions of source code must retain the above
//       copyright notice, this list of conditions and the following
//       disclaimer.
//     * Redistributions in binary form must reproduce the above
//       copyright notice, this list of conditions and the following
//       disclaimer in the documentation and/or other materials
//       provided with the distribution.
//     * Neither the name of Weizhong Yang (zonble) nor the names of
//       its contributors may be used to endorse or promote products
//       derived from this software without specific prior written
//       permission.
//
// THIS SOFTWARE IS PROVIDED BY WEIZHONG YANG ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL WEIZHONG YANG BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
// OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
// USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
// DAMAGE.

#import "TWAPIBox+Info.h"

@interface TWAPIBox(Private_Info)
- (void)initForecastLocations;
- (void)initWeekLocations;
- (void)initWeekTravelLocations;
- (void)initThreeDaySeaLocations;
- (void)initNearSeaLocations;
- (void)initTideLocations;
- (void)initImageIdentifiers;
- (void)initOBSLocations;
@end

@implementation TWAPIBox(Private_Info)

- (void)addToArray:(NSMutableArray *)array name:(char *)name identifier:(NSString *)identifier
{
	NSString *nameString = @(name);
	[array addObject:@{@"identifier": identifier, @"name": nameString}];
}

- (void)initForecastLocations
{
	_forecastLocations = [[NSMutableArray alloc] init];
	[self addToArray:_forecastLocations name:"台北市" identifier:@"1"];
	[self addToArray:_forecastLocations name:"高雄市" identifier:@"2"];
	[self addToArray:_forecastLocations name:"基隆市" identifier:@"3"];
	[self addToArray:_forecastLocations name:"新北市" identifier:@"4"];
	[self addToArray:_forecastLocations name:"桃園縣" identifier:@"5"];
	[self addToArray:_forecastLocations name:"新竹市" identifier:@"14"];
	[self addToArray:_forecastLocations name:"新竹縣" identifier:@"6"];
	[self addToArray:_forecastLocations name:"苗栗縣" identifier:@"7"];
	[self addToArray:_forecastLocations name:"台中市" identifier:@"8"];
	[self addToArray:_forecastLocations name:"彰化縣" identifier:@"9"];
	[self addToArray:_forecastLocations name:"南投縣" identifier:@"10"];
	[self addToArray:_forecastLocations name:"雲林縣" identifier:@"11"];
	[self addToArray:_forecastLocations name:"嘉義市" identifier:@"16"];
	[self addToArray:_forecastLocations name:"嘉義縣" identifier:@"12"];
	[self addToArray:_forecastLocations name:"台南市" identifier:@"13"];
	[self addToArray:_forecastLocations name:"屏東縣" identifier:@"15"];
	[self addToArray:_forecastLocations name:"宜蘭縣" identifier:@"17"];
	[self addToArray:_forecastLocations name:"花蓮縣" identifier:@"18"];
	[self addToArray:_forecastLocations name:"台東縣" identifier:@"19"];
	[self addToArray:_forecastLocations name:"澎湖縣" identifier:@"20"];
	[self addToArray:_forecastLocations name:"金門縣" identifier:@"21"];
	[self addToArray:_forecastLocations name:"連江縣" identifier:@"22"];
}
- (void)initWeekLocations
{
	_weekLocations = [[NSMutableArray alloc] init];
	[self addToArray:_weekLocations name:"台北市" identifier:@"Taipei"];
	[self addToArray:_weekLocations name:"北部" identifier:@"North"];
	[self addToArray:_weekLocations name:"中部" identifier:@"Center"];
	[self addToArray:_weekLocations name:"南部" identifier:@"South"];
	[self addToArray:_weekLocations name:"東北部" identifier:@"North-East"];
	[self addToArray:_weekLocations name:"東部" identifier:@"East"];
	[self addToArray:_weekLocations name:"東南部" identifier:@"South-East"];
	[self addToArray:_weekLocations name:"澎湖" identifier:@"Penghu"];
	[self addToArray:_weekLocations name:"金門" identifier:@"Kinmen"];
	[self addToArray:_weekLocations name:"馬祖" identifier:@"Matsu"];
}
- (void)initWeekTravelLocations
{
	_weekTravelLocations = [[NSMutableArray alloc] init];
	[self addToArray:_weekTravelLocations name:"陽明山" identifier:@"Yang-ming-shan"];
	[self addToArray:_weekTravelLocations name:"拉拉山" identifier:@"Lalashan"];
	[self addToArray:_weekTravelLocations name:"梨山" identifier:@"Lishan"];
	[self addToArray:_weekTravelLocations name:"合歡山" identifier:@"Hohuan-shan"];
	[self addToArray:_weekTravelLocations name:"日月潭" identifier:@"Sun-Moon-Lake"];
	[self addToArray:_weekTravelLocations name:"溪頭" identifier:@"Hsitou"];
	[self addToArray:_weekTravelLocations name:"阿里山" identifier:@"Alishan"];
	[self addToArray:_weekTravelLocations name:"玉山" identifier:@"Yushan"];
	[self addToArray:_weekTravelLocations name:"墾丁" identifier:@"Kenting"];
	[self addToArray:_weekTravelLocations name:"龍洞" identifier:@"Lung-tung"];
	[self addToArray:_weekTravelLocations name:"太魯閣" identifier:@"Taroko"];
	[self addToArray:_weekTravelLocations name:"三仙台" identifier:@"San-shiantai"];
	[self addToArray:_weekTravelLocations name:"綠島" identifier:@"Lu-Tao"];
	[self addToArray:_weekTravelLocations name:"蘭嶼" identifier:@"Lanyu"];
}
- (void)initThreeDaySeaLocations
{
	_threeDaySeaLocations = [[NSMutableArray alloc] init];
	[self addToArray:_threeDaySeaLocations name:"黃海南部海面" identifier:@"1"];
	[self addToArray:_threeDaySeaLocations name:"花鳥山海面" identifier:@"2"];
	[self addToArray:_threeDaySeaLocations name:"東海北部海面" identifier:@"3"];
	[self addToArray:_threeDaySeaLocations name:"浙江海面" identifier:@"4"];
	[self addToArray:_threeDaySeaLocations name:"東海南部海面" identifier:@"5"];
	[self addToArray:_threeDaySeaLocations name:"台灣北部海面" identifier:@"6"];
	[self addToArray:_threeDaySeaLocations name:"台灣海峽北部" identifier:@"7"];
	[self addToArray:_threeDaySeaLocations name:"台灣海峽南部" identifier:@"8"];
	[self addToArray:_threeDaySeaLocations name:"台灣東北部海面" identifier:@"9"];
	[self addToArray:_threeDaySeaLocations name:"台灣東南部海面" identifier:@"10"];
	[self addToArray:_threeDaySeaLocations name:"巴士海峽" identifier:@"11"];
	[self addToArray:_threeDaySeaLocations name:"廣東海面" identifier:@"12"];
	[self addToArray:_threeDaySeaLocations name:"東沙島海面" identifier:@"13"];
	[self addToArray:_threeDaySeaLocations name:"中西沙島海面" identifier:@"14"];
	[self addToArray:_threeDaySeaLocations name:"南沙島海面" identifier:@"15"];
}
- (void)initNearSeaLocations
{
	_nearSeaLocations = [[NSMutableArray alloc] init];
	[self addToArray:_nearSeaLocations name:"釣魚台海面" identifier:@"1"];
	[self addToArray:_nearSeaLocations name:"彭佳嶼基隆海面" identifier:@"2"];
	[self addToArray:_nearSeaLocations name:"宜蘭蘇澳沿海" identifier:@"3"];
	[self addToArray:_nearSeaLocations name:"新竹鹿港沿海" identifier:@"4"];
	[self addToArray:_nearSeaLocations name:"澎湖海面" identifier:@"5"];
	[self addToArray:_nearSeaLocations name:"鹿港東石沿海" identifier:@"6"];
	[self addToArray:_nearSeaLocations name:"東石安平沿海" identifier:@"7"];
	[self addToArray:_nearSeaLocations name:"安平高雄沿海" identifier:@"8"];
	[self addToArray:_nearSeaLocations name:"高雄枋寮沿海" identifier:@"9"];
	[self addToArray:_nearSeaLocations name:"枋寮恆春沿海" identifier:@"10"];
	[self addToArray:_nearSeaLocations name:"鵝鑾鼻沿海" identifier:@"11"];
	[self addToArray:_nearSeaLocations name:"成功大武沿海" identifier:@"12"];
	[self addToArray:_nearSeaLocations name:"綠島蘭嶼海面" identifier:@"13"];
	[self addToArray:_nearSeaLocations name:"花蓮沿海" identifier:@"14"];
	[self addToArray:_nearSeaLocations name:"金門海面" identifier:@"15"];
	[self addToArray:_nearSeaLocations name:"馬祖海面" identifier:@"16"];
}
- (void)initTideLocations
{
	_tideLocations = [[NSMutableArray alloc] init];
	[self addToArray:_tideLocations name:"基隆" identifier:@"1"];
	[self addToArray:_tideLocations name:"福隆" identifier:@"2"];
	[self addToArray:_tideLocations name:"鼻頭角" identifier:@"3"];
	[self addToArray:_tideLocations name:"石門" identifier:@"4"];
	[self addToArray:_tideLocations name:"淡水" identifier:@"5"];
	[self addToArray:_tideLocations name:"大園" identifier:@"6"];
	[self addToArray:_tideLocations name:"新竹" identifier:@"7"];
	[self addToArray:_tideLocations name:"苗栗" identifier:@"8"];
	[self addToArray:_tideLocations name:"梧棲" identifier:@"9"];
	[self addToArray:_tideLocations name:"王功" identifier:@"10"];
	[self addToArray:_tideLocations name:"台西" identifier:@"11"];
	[self addToArray:_tideLocations name:"東石" identifier:@"12"];
	[self addToArray:_tideLocations name:"將軍" identifier:@"13"];
	[self addToArray:_tideLocations name:"安平" identifier:@"14"];
	[self addToArray:_tideLocations name:"高雄" identifier:@"15"];
	[self addToArray:_tideLocations name:"東港" identifier:@"16"];
	[self addToArray:_tideLocations name:"南灣" identifier:@"17"];
	[self addToArray:_tideLocations name:"澎湖" identifier:@"18"];
	[self addToArray:_tideLocations name:"蘇澳" identifier:@"19"];
	[self addToArray:_tideLocations name:"頭城" identifier:@"20"];
	[self addToArray:_tideLocations name:"花蓮" identifier:@"21"];
	[self addToArray:_tideLocations name:"台東" identifier:@"22"];
	[self addToArray:_tideLocations name:"成功" identifier:@"23"];
	[self addToArray:_tideLocations name:"蘭嶼" identifier:@"24"];
	[self addToArray:_tideLocations name:"馬祖" identifier:@"25"];
	[self addToArray:_tideLocations name:"金門" identifier:@"26"];
}
- (void)initImageIdentifiers
{
	_imageIdentifiers = [[NSMutableArray alloc] init];
	[self addToArray:_imageIdentifiers name:"最新天氣圖" identifier:@"weather"];
	[self addToArray:_imageIdentifiers name:"24小時預測圖" identifier:@"weather_24"];
	[self addToArray:_imageIdentifiers name:"日雨量累積圖" identifier:@"rain"];
	[self addToArray:_imageIdentifiers name:"定量降水預報 12 小時" identifier:@"rain_12"];
	[self addToArray:_imageIdentifiers name:"定量降水預報 24 小時" identifier:@"rain_24"];
	[self addToArray:_imageIdentifiers name:"雷達示波圖（有地形）" identifier:@"radar"];
	[self addToArray:_imageIdentifiers name:"雷達示波圖（無地形）" identifier:@"radar2"];
	[self addToArray:_imageIdentifiers name:"台灣彩色雲圖" identifier:@"color_taiwan"];
	[self addToArray:_imageIdentifiers name:"亞洲彩色雲圖" identifier:@"color_asia"];
	[self addToArray:_imageIdentifiers name:"全球彩色雲圖" identifier:@"color_world"];
	[self addToArray:_imageIdentifiers name:"台灣色彩強化雲圖" identifier:@"hilight_taiwan"];
	[self addToArray:_imageIdentifiers name:"亞洲色彩強化雲圖" identifier:@"hilight_asia"];
	[self addToArray:_imageIdentifiers name:"全球色彩強化雲圖" identifier:@"hilight_world"];
	[self addToArray:_imageIdentifiers name:"台灣可見光雲圖" identifier:@"light_taiwan"];
	[self addToArray:_imageIdentifiers name:"亞洲可見光雲圖" identifier:@"light_asia"];
	[self addToArray:_imageIdentifiers name:"全球可見光雲圖" identifier:@"light_world"];
	[self addToArray:_imageIdentifiers name:"台灣黑白雲圖" identifier:@"bw_taiwan"];
	[self addToArray:_imageIdentifiers name:"亞洲黑白雲圖" identifier:@"bw_asia"];
	[self addToArray:_imageIdentifiers name:"全球黑白雲圖" identifier:@"bw_world"];

	[self addToArray:_imageIdentifiers name:"波浪分析圖" identifier:@"wave"];
	[self addToArray:_imageIdentifiers name:"24 小時波浪預報圖" identifier:@"wave_24"];
	[self addToArray:_imageIdentifiers name:"36 小時波浪預報圖" identifier:@"wave_36"];
	[self addToArray:_imageIdentifiers name:"48 小時波浪預報圖" identifier:@"wave_48"];

}
- (void)initOBSLocations
{
	_OBSLocations = [[NSMutableArray alloc] init];
	NSMutableArray *north = [NSMutableArray array];

	[self addToArray:north name:"基隆" identifier:@"46694"];
	[self addToArray:north name:"台北" identifier:@"46692"];
	[self addToArray:north name:"板橋" identifier:@"46688"];
	[self addToArray:north name:"陽明山" identifier:@"46693"];
	[self addToArray:north name:"淡水" identifier:@"46690"];
	[self addToArray:north name:"新店" identifier:@"A0A9M"];
	[self addToArray:north name:"桃園" identifier:@"46697"];
//	[self addToArray:north name:"新屋" identifier:@"C0C45"];
	[self addToArray:north name:"新竹" identifier:@"46757"];
	[self addToArray:north name:"雪霸" identifier:@"C0D55"];
	[self addToArray:north name:"三義" identifier:@"C0E53"];
	[self addToArray:north name:"竹南" identifier:@"C0E42"];

	NSDictionary *d = @{@"items": north, @"AreaID": @"north", @"areaName": @"北部"};
	[_OBSLocations addObject:d];

	NSMutableArray *center = [NSMutableArray array];
	[self addToArray:center name:"台中" identifier:@"46749"];
	[self addToArray:center name:"梧棲" identifier:@"46777"];
	[self addToArray:center name:"梨山" identifier:@"C0F86"];
	[self addToArray:center name:"員林" identifier:@"C0G65"];
	[self addToArray:center name:"鹿港" identifier:@"C0G64"];
	[self addToArray:center name:"日月潭" identifier:@"46765"];
	[self addToArray:center name:"廬山" identifier:@"C0I01"];
	[self addToArray:center name:"合歡山" identifier:@"C0H9C"];
	[self addToArray:center name:"虎尾" identifier:@"C0K33"];
	[self addToArray:center name:"草嶺" identifier:@"C0K24"];
	[self addToArray:center name:"嘉義" identifier:@"46748"];
	[self addToArray:center name:"阿里山" identifier:@"46753"];
	[self addToArray:center name:"玉山" identifier:@"46755"];

	d = @{@"items": center, @"AreaID": @"center", @"areaName": @"中部"};
	[_OBSLocations addObject:d];

	NSMutableArray *south = [NSMutableArray array];
	[self addToArray:south name:"台南" identifier:@"46741"];
	[self addToArray:south name:"高雄" identifier:@"46744"];
	[self addToArray:south name:"甲仙" identifier:@"C0V25"];
	[self addToArray:south name:"三地門" identifier:@"C0R15"];
	[self addToArray:south name:"恆春" identifier:@"46759"];

	d = @{@"items": south, @"AreaID": @"south", @"areaName": @"南部"};
	[_OBSLocations addObject:d];

	NSMutableArray *east = [NSMutableArray array];
	[self addToArray:east name:"宜蘭" identifier:@"46708"];
	[self addToArray:east name:"蘇澳" identifier:@"46706"];
	[self addToArray:east name:"太平山" identifier:@"C0U71"];
	[self addToArray:east name:"花蓮" identifier:@"46699"];
	[self addToArray:east name:"玉里" identifier:@"C0Z06"];
	[self addToArray:east name:"成功" identifier:@"46761"];
	[self addToArray:east name:"台東" identifier:@"46766"];
	[self addToArray:east name:"大武" identifier:@"46754"];

	d = @{@"items": east, @"AreaID": @"east", @"areaName": @"東部"};
	[_OBSLocations addObject:d];

	NSMutableArray *island = [NSMutableArray array];
	[self addToArray:island name:"澎湖" identifier:@"46735"];
	[self addToArray:island name:"金門" identifier:@"46711"];
	[self addToArray:island name:"馬祖" identifier:@"46799"];
	[self addToArray:island name:"綠島" identifier:@"C0S73"];
	[self addToArray:island name:"蘭嶼" identifier:@"46762"];
	[self addToArray:island name:"彭佳嶼" identifier:@"46695"];
	[self addToArray:island name:"東吉島" identifier:@"46730"];
	[self addToArray:island name:"琉球嶼" identifier:@"C0R27"];

	d = @{@"items": island, @"AreaID": @"island", @"areaName": @"外島"};
	[_OBSLocations addObject:d];
}
- (void)initGlobalCityLocations
{
	_globalCityLocations = [[NSMutableArray alloc] init];

	NSMutableArray *asia = [NSMutableArray array];
	[self addToArray:asia name:"東京" identifier:@"TOKYO"];
	[self addToArray:asia name:"大阪" identifier:@"OSAKA"];
	[self addToArray:asia name:"首爾" identifier:@"SEOUL"];
	[self addToArray:asia name:"曼谷" identifier:@"BANGKOK"];
	[self addToArray:asia name:"雅加達" identifier:@"JAKARTA"];
	[self addToArray:asia name:"吉隆坡" identifier:@"KUALALUMPUR"];
	[self addToArray:asia name:"新加坡" identifier:@"SINGAPORE"];
	[self addToArray:asia name:"馬尼拉" identifier:@"MANILA"];
	[self addToArray:asia name:"加德滿都" identifier:@"KATMANDU"];
	[self addToArray:asia name:"胡志明市" identifier:@"HO-CHI-MINH"];
	[self addToArray:asia name:"河內" identifier:@"HA-NOI"];
	[self addToArray:asia name:"新德里" identifier:@"NEW-DELHI"];
	[self addToArray:asia name:"伊斯坦堡" identifier:@"ISTANBUL"];
	[self addToArray:asia name:"莫斯科" identifier:@"MOSCOW"];
	[self addToArray:asia name:"海參威" identifier:@"VLADIVOSTOK"];
	[self addToArray:asia name:"伯力" identifier:@"HABAROVSK"];
	[self addToArray:asia name:"威靈頓" identifier:@"WELLINGTON"];
	[self addToArray:asia name:"奧克蘭" identifier:@"AUCKLAND"];
	[self addToArray:asia name:"墨爾本" identifier:@"MELBOURNE"];
	[self addToArray:asia name:"雪梨" identifier:@"SYDNEY"];
	[self addToArray:asia name:"伯斯" identifier:@"PERTH"];
	[self addToArray:asia name:"布里斯班" identifier:@"BRISBANE"];

	NSDictionary *d = @{@"items": asia, @"AreaID": @"asia", @"areaName": @"亞洲"};
	[_globalCityLocations addObject:d];

	NSMutableArray *america = [NSMutableArray array];
//	[self addToArray:america name:"關島" identifier:@"GUAM"];
	[self addToArray:america name:"檀香山" identifier:@"HONOLULU"];
	[self addToArray:america name:"洛杉磯" identifier:@"LOSANGELES"];
	[self addToArray:america name:"舊金山" identifier:@"SANFRANCISCO"];
	[self addToArray:america name:"西雅圖" identifier:@"SEATTLE"];
	[self addToArray:america name:"紐約" identifier:@"NEWYORK"];
	[self addToArray:america name:"芝加哥" identifier:@"CHICAGO"];
	[self addToArray:america name:"邁阿密" identifier:@"MIAMI"];
	[self addToArray:america name:"多倫多" identifier:@"TORONTO"];
	[self addToArray:america name:"溫哥華" identifier:@"VANCOUVER"];
	[self addToArray:america name:"蒙特婁" identifier:@"MONTREAL"];
	[self addToArray:america name:"墨西哥城" identifier:@"MEXICO-CITY"];
	[self addToArray:america name:"里約熱內盧" identifier:@"RIO-DE-JANEIRO"];
	[self addToArray:america name:"聖地牙哥（智利）" identifier:@"SANTIAGO"];
	[self addToArray:america name:"利瑪" identifier:@"LIMA"];
	[self addToArray:america name:"拉斯維加斯" identifier:@"LASVEGAS"];
	[self addToArray:america name:"華盛頓特區" identifier:@"WASHINGTON-DC"];
	[self addToArray:america name:"布宜諾斯艾利斯" identifier:@"BUENOS-AIRES"];

	d = @{@"items": america, @"AreaID": @"america", @"areaName": @"美洲"};
	[_globalCityLocations addObject:d];

	NSMutableArray *europeAfrica = [NSMutableArray array];
	[self addToArray:europeAfrica name:"奧斯陸" identifier:@"OSLO"];
	[self addToArray:europeAfrica name:"馬德里" identifier:@"MADRID"];
	[self addToArray:europeAfrica name:"哥本哈根" identifier:@"COPENHAGEN"];
	[self addToArray:europeAfrica name:"赫爾辛基" identifier:@"HELSINKI"];
	[self addToArray:europeAfrica name:"法蘭克福" identifier:@"FRANKFURT"];
	[self addToArray:europeAfrica name:"柏林" identifier:@"BERLIN"];
	[self addToArray:europeAfrica name:"日內瓦" identifier:@"GENEVA"];
	[self addToArray:europeAfrica name:"布魯塞爾" identifier:@"BRUXELLES"];
	[self addToArray:europeAfrica name:"倫敦" identifier:@"LONDON"];
	[self addToArray:europeAfrica name:"巴黎" identifier:@"PARIS"];
	[self addToArray:europeAfrica name:"維也納" identifier:@"VIENNA"];
	[self addToArray:europeAfrica name:"羅馬" identifier:@"ROME"];
	[self addToArray:europeAfrica name:"威尼斯" identifier:@"VENEZIA"];
	[self addToArray:europeAfrica name:"布達佩斯" identifier:@"BUDAPEST"];
	[self addToArray:europeAfrica name:"雅典" identifier:@"ATHENS"];
	[self addToArray:europeAfrica name:"華沙" identifier:@"WARSZAWA"];
	[self addToArray:europeAfrica name:"布拉格" identifier:@"PRAHA"];
	[self addToArray:europeAfrica name:"開羅" identifier:@"CAIRO"];
	[self addToArray:europeAfrica name:"阿姆斯特丹" identifier:@"AMSTERDAM"];
	[self addToArray:europeAfrica name:"約翰尼斯堡" identifier:@"JOHANNESBURG"];
	[self addToArray:europeAfrica name:"斯德哥爾摩" identifier:@"STOCKHOLM"];

	d = @{@"items": europeAfrica, @"AreaID": @"europeAfrica", @"areaName": @"歐非"};
	[_globalCityLocations addObject:d];

	NSMutableArray *china = [NSMutableArray array];
	[self addToArray:china name:"廣州" identifier:@"GUANGZHOU"];
	[self addToArray:china name:"香港" identifier:@"HONGKONG"];
	[self addToArray:china name:"福州" identifier:@"FUZHOU"];
	[self addToArray:china name:"昆明" identifier:@"KUNMING"];
	[self addToArray:china name:"重慶" identifier:@"CHONGQING"];
	[self addToArray:china name:"武漢" identifier:@"WUHAN"];
	[self addToArray:china name:"南昌" identifier:@"NANCHANG"];
	[self addToArray:china name:"杭州" identifier:@"HANGZHOU"];
	[self addToArray:china name:"上海" identifier:@"SHANGHAI"];
	[self addToArray:china name:"南京" identifier:@"NANJING"];
	[self addToArray:china name:"青島" identifier:@"QINGDAO"];
	[self addToArray:china name:"北京" identifier:@"BEIJING"];
	[self addToArray:china name:"開封" identifier:@"KAIFENG"];
	[self addToArray:china name:"西安" identifier:@"XIAN"];
	[self addToArray:china name:"瀋陽" identifier:@"SHENINAG"];
	[self addToArray:china name:"蘭州" identifier:@"LANZHOU"];
	[self addToArray:china name:"海口" identifier:@"HAIKOU"];

	d = @{@"items": china, @"AreaID": @"china", @"areaName": @"中國"};
	[_globalCityLocations addObject:d];
}

@end

@implementation TWAPIBox(Info)

- (void)initInfoArrays
{
	[self initForecastLocations];
	[self initWeekLocations];
	[self initWeekTravelLocations];
	[self initThreeDaySeaLocations];
	[self initNearSeaLocations];
	[self initTideLocations];
	[self initImageIdentifiers];
	[self initOBSLocations];
	[self initGlobalCityLocations];
}
- (void)releaseInfoArrays
{
}

- (NSArray *)forecastLocations
{
	return _forecastLocations;
}
- (NSArray *)weekLocations
{
	return _weekLocations;
}
- (NSArray *)weekTravelLocations
{
	return _weekTravelLocations;
}
- (NSArray *)threeDaySeaLocations
{
	return _threeDaySeaLocations;
}
- (NSArray *)nearSeaLocations
{
	return _nearSeaLocations;
}
- (NSArray *)tideLocations
{
	return _tideLocations;
}
- (NSArray *)imageIdentifiers
{
	return _imageIdentifiers;
}
- (NSArray *)OBSLocations
{
	return _OBSLocations;
}
- (NSArray *)globalCityLocations
{
	return _globalCityLocations;
}

@end
