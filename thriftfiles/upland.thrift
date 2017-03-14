# 网站服务定义文件

include "common.thrift"

namespace py et_thrift.upland
namespace php EtThrift.Upland

struct DistrictDef {
    1: required i32 id,
    2: required string name,
    3: required i32 parentId,
    4: required string path,
    5: required byte level,
    6: required byte isValid,
    7: required byte type,
    8: required string areaCode
}

service AreaService extends common.BaseService {

    list<DistrictDef> getDistrictsByAreaCodes(1:list<string> areaCodes)
        throws (1:common.ServerError se),

    list<DistrictDef> getDistrictDetailByAreaCode(1:string areaCode)
        throws (1:common.ServerError se),

    list<DistrictDef> getSchools(1:list<i32> schoolIds)
        throws (1:common.ServerError se),

    list<DistrictDef> getDistrictByName(1:string districtName)
        throws (1:common.ServerError se),

    list<DistrictDef> getDistrictByNameAndLevel(
        1:string districtName,
        2:byte level
        )throws (1:common.ServerError se),

    string getAllDistrictData()
        throws (1:common.ServerError se),

    string getAllDistrictDataWithSingleName()
        throws (1:common.ServerError se),
}

struct UserDef {
    1: required i32 id,
    2: required string userName,
    3: required string realName,
    4: required string email,
    5: required string schoolName,
    6: required string grade,
    7: required byte gradeType,
    8: required string telephone,
    9: required string mobile,
    10: required string qq,
    11: required bool isIpUser,
    12: required byte userFigure,
    13: required string subject,
    14: required string areaCode,

    15: optional string password,
    16: optional bool isBindMobile,
    17: optional bool isDetailed,
    18: optional byte subjectClassify,
    19: optional string province,
    20: optional string district,
    21: optional string subDistrict,
    22: optional string faceData,
    23: optional byte sourceType,
    24: optional string registerIP,
    25: optional string inviteCode
}

service UserBaseInfoService extends common.BaseService {

    # 根据用户名批量获取用户信息
    list<UserDef> getByUserNames(
        1:list<string> userNames    # 用户名数组
    ) throws (1:common.ServerError se)

    # 根据用户编号批量获取用户信息
    list<UserDef> getByUserIds(
        1:list<i32> userIds         # 用户编号数组
    ) throws (1:common.ServerError se)

    # 注册用户
    UserDef registerUser(
        1:UserDef userInfo          # 用户信息
    ) throws (1:common.ServerError se, 2:common.ReturnFalse rf)

    # 注册用户
    byte updateUserBaseInfo(
        1:string userName,          # 用户信息
        2:string realName,          # 姓名
        3:string grade,             # 年级编码
        4:string areaCode,          # 区域
        5:string schoolName,        # 学校名称
        6:string qq,                # qq号
        7:string email,             # 电子邮箱
        8:byte gradeType,           # 年级学制：0-六三制，1-五四制
        9:byte subjectClassify      # 分科信息：0-没有分科，1-理科 2-文科
    ) throws (1:common.ServerError se)

    # 修改密码
    byte changePassword(
        1:string userName,          # 用户名
        2:string oldPassword,       # 用户原密码
        3:string newPassword        # 用户新密码
    ) throws (1:common.ServerError se)

    # 检查用户密码是否信息正确。
    # 若正确返回用户名，否则返回common.ReturnFalse错误。
    UserDef checkUserPassword(
        1:string userName,             # 用户名
        2:string password              # 密码
    ) throws (1:common.ServerError se, 2:common.ReturnFalse rf)

    # 检查用户绑定的手机号和密码是否正确。（通常用于使用绑定的手机号登录）
    # 若正确返回用户信息，否则返回common.ReturnFalse错误。
    UserDef checkUserMobileAndPassword(
        1:string mobile,               # 绑定的手机号
        2:string password              # 密码
    ) throws (1:common.ServerError se, 2:common.ReturnFalse rf)

    # 判断手机号是否已经绑定。
    bool isMobileBind(
        1:string mobile,       # 手机号
    ) throws (1:common.ServerError se)

    # 用户绑定手机号。
    byte bindMobile(
        1:string userName,     # 用户名
        2:string mobile,       # 手机号
    ) throws (1:common.ServerError se)

    # 用户解绑手机号。
    byte unbindMobile(
        1:string userName,     # 用户名
        2:string mobile,       # 手机号
    ) throws (1:common.ServerError se)
}

struct HandoutDef {
    1:required i16 grade,
    2:required i32 subject,
    3:required string semester,
    4:required string version,
    5:optional i32 remain,
    6:optional bool selectable
}

service HandoutService extends common.BaseService {
    list<HandoutDef> getHandout(
        1: required string userName,
        2: required byte gradeType,
        3: required i32 subject,
        4: required string version
    ) throws (1:common.ServerError se),

    list<i32> reduceHandoutRemain(
        1: required string userName,
        2: required list<HandoutDef> handouts,
    ) throws (1:common.ServerError se, 2:common.ReturnFalse rf),
}

# 订单信息数据结构
struct OrderDef {
    1: required string orderId,         # 订单编号
    2: required i32 userId,             # 用户编号
    3: required string orderData,       # 订单明细数据
    4: required byte orderType,         # 订单类型
    5: required i16 orderStatus,        # 订单状态
    6: required double payMoney,        # 订单需支付金额
    7: required byte payType,           # 订单支付类型
    8: required bool needInvoice,       # 订单是否需要发票
    9: required string invoiceContent,  # 发票内容
    10: required string remark,         # 备注
    11: required bool isValid,          # 是否有效
    12: required string createdAt,      # 订单创建时间
}

struct RechargeCardDef {
    1: required i32 id,
    2: required i32 seasonId,
    3: required i32 subjectId,
    4: required byte gradeType,
    5: required i16 serviceNum,
    6: required double price,
}

struct PriceDef {
    1: required double realMoney,
    2: required double originMoney,
    3: required list<string> mergeOrders,
    4: required byte version,
}

# 收款人信息
struct PayeeDef {
    1: required string name,        # 收款人姓名
    2: required string bankName,    # 开户银行名称
    3: required string province,    # 开户银行省
    4: required string city,        # 开户银行市
    5: required string area,        # 开户银行区县
    6: required string subName,     # 开户银行支行名称
    7: required string card,        # 银行卡号
    8: required string phone,       # 收款人手机号码
}

# 收款人地址信息
struct DeliveryAddressDef {
    1: required string name,        # 收款人姓名
    2: required string phone,       # 收件人手机号码
    3: required string address,     # 详细地址
    4: required string province,    # 省
    5: required string city,        # 市
    6: required string area,        # 县
}

service TutorOrderService extends common.BaseService {
    # 获取用户所有教练伴学相关订单信息
    list<OrderDef> getAllOrders(1:string userName)
        throws (1:common.ServerError se, 2:common.ReturnFalse rf)

    # 根据订单号获取订单信息
    OrderDef getOrderById(1:string orderId)
        throws (1:common.ServerError se, 2:common.ReturnFalse rf)

    # 获取用户未完成订单
    list<OrderDef> getUserNotCompleteOrders(1:string userName)
        throws (1:common.ServerError se, 2:common.ReturnFalse rf)

    # 获取用户未完成订单
    list<OrderDef> getUserNotCompleteRefundOrders(1:string userName)
        throws (1:common.ServerError se, 2:common.ReturnFalse rf)

    # 添加购买订单
    byte addBuyOrder(
        1:string orderId,                   # 新订单号
        2:i32 userId,                       # 用户编号
        3:list<RechargeCardDef> cards,      # 购买的约课卡信息
        4:PriceDef priceInfo,               # 订单价格信息
        5:byte orderType,                   # 订单类型：6-CRM提x+1简教练订单；7-简教练网站订单；8-CRM提1+x简教练订单；9-简教练网站退款订单
        6:byte payType                      # 订单支付类型：0-网站在线支付；3-线下支付
    ) throws (1:common.ServerError se)

    # 修改订单信息
    byte updateBuyOrder(
        1:string orderId,                   # 新订单号
        2:list<RechargeCardDef> cards,      # 购买的约课卡信息
        3:PriceDef priceInfo,               # 订单价格信息
    ) throws (1:common.ServerError se)

    # 设置订单状态
    byte setOrderStatus(
        1:string orderId,       # 订单号
        2:i16 status            # 订单状态
    ) throws (1:common.ServerError se)

    # 添加退款订单
    byte addRefundOrder(
        1:string orderId,           # 退款订单号
        2:string userName,          # 用户名
        3:PayeeDef payeeInfo,       # 退款收款人信息
        4:string cancelPayPriceInfoJson,    # 退款金额信息（JSON格式字符串）
        5:double amount             # 退款总金额
    ) throws (1:common.ServerError se)

    # 添加订单讲义快递信息
    byte addLectureDeliveryOrder(
        1:string userName,          # 用户名
        2:i16 subjectId,            # 讲义科目编号
        3:i32 seasonId,             # 讲义学季编号
        4:list<i32> lectureIds,     # 讲义编号数组
        5:DeliveryAddressDef address,      # 快递地址
    ) throws (1:common.ServerError se)

    # 每天24点检查设置待付订单过期
    bool everydayCheckExpiredOrder() throws (1:common.ServerError se)
}

struct CourseLectureDownloadInfoDef {
    1:required string saleCourseId,
    2:required string courseId,
    3:required string title,
    4:required byte publishStatus,
    5:required bool canDownloadWhole,
    6:required string level,
}

struct LessonLectureDownloadInfoDef {
    1:required string lessonId,
    2:required string courseId,
    3:required string title,
    4:required bool isPublish,
    5:required bool canDownloadLecture,
}

service CourseService extends common.BaseService {
    list<CourseLectureDownloadInfoDef> getCourseLectureDownloadInfo(
        1:byte grade,
        2:i16 studyYear,
        3:string version,
        4:i16 subjectId
    ) throws (1:common.ServerError se, 2:common.ReturnFalse rf)

    list<LessonLectureDownloadInfoDef> getCourseLessonLectureDownloadInfo(
        1:string courseId
    ) throws (1:common.ServerError se, 2:common.ReturnFalse rf)

    CourseLectureDownloadInfoDef getLectureDownloadInfoByCourse(1:string saleCourseId)
        throws (1:common.ServerError se, 2:common.ReturnFalse rf)

    LessonLectureDownloadInfoDef getLectureDownloadInfoByLesson(1:string lessonId)
        throws (1:common.ServerError se, 2:common.ReturnFalse rf)
}

struct ProtectorCorrespondStudentDef {
    1: required string userName,
    2: required string realName,
    3: required string phone,
    4: required string qq,
    5: required string wechat,
    6: required string email,
    7: required string wechatCode,
    8: required string studentName
}

service ProtectorService extends common.BaseService {
    list<ProtectorCorrespondStudentDef> getProtectorInfo(
        1:list<string> userNames
    ) throws (1:common.ServerError se)
}
