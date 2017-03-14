# 教练伴学服务定义文件

include "common.thrift"

namespace py etthrift.tutor
namespace php EtThrift.Tutor


struct PeriodDef {
    1: required i32 id,
    2: required i32 seasonId,
    3: required byte gradeType,
    4: required i16 startTime,
    5: required i16 endTime
}

struct PeriodTimeDef {
    1: required string startTime,
    2: required string endTime
}

struct SeasonDef {
    1: required i32 id,
    2: required i16 year,
    3: required byte seasonType,
    4: required string startDay,
    5: required string endDay,
    6: optional set<string> exceptDays,
    7: optional byte status
}

service SeasonService extends common.BaseService {

    list<SeasonDef> getAll()
        throws (1:common.ServerError se),

    i32 addSeason(1:required SeasonDef season)
        throws (1:common.ServerError se),

    bool updateSeason(1:required SeasonDef season)
        throws (1:common.ServerError se),

    bool deleteSeason(1:required i32 seasonId)
        throws (1:common.ServerError se),

    list<SeasonDef> getSeason(1:required list<i32> seasonId)
        throws (1:common.ServerError se),
}

service PeriodService extends common.BaseService {
    list<PeriodDef> getAll(1:required i32 limit, 2:required i32 offset)
        throws (1:common.ServerError se),

    i32 getAllCount()
        throws (1:common.ServerError se),

    list<PeriodDef> getBySeasonAndGradeType(1:required i32 seasonId, 2:required i32 gradeType)
        throws (1:common.ServerError se),

    i32 add(1:required PeriodDef period)
        throws (1:common.ServerError se),

    bool update(1:required PeriodDef period)
        throws (1:common.ServerError se),

    bool remove(1:required i32 periodId)
        throws (1:common.ServerError se),

    list<PeriodTimeDef> getPeriod(
        1:required byte gradeType,
        2:required i32 subjectId,
        3:required i32 season,
    )throws (1:common.ServerError se),
}

struct ClassTemplateDef {
    1: required i32 id,
    2: required i32 seasonId,
    3: required i32 subjectId,
    4: required i16 grade,
    5: optional i32 periodId,
    6: optional i16 cycleDay,
    7: optional i16 startTime,
    8: optional i16 endTime,
    9: optional i16 maxClassNum,
    10: optional i16 maxStudentNum
}

struct EnlistDef {
    1: required i32 subjectId,
    2: required i32 classId,
    3: required i16 cycleDay,
    4: required i32 period_id,
}

struct ReservationTemplateDef{
    1: required i32 id,
    2: required i32 seasonId,
    3: required i32 periodId,
    4: required i32 subjectId,
    5: required i16 grade,
    6: required i16 cycleDay,
    7: required i16 startTime,
    8: required i16 endTime,
    9: required i16 maxClassNum,
    10: required i16 maxStudentNum,
    11: required i16 maxStudentInClass,
    12: required i32 minNeededCoachNumber,
    13: required i32 usableCoachNumber,
    14: required i32 allotStudentNumber,
    15: required i32 unallotStudentNumber,
    16: required i32 allStudentNumber
}

struct EnrollmentScheduleDef{
    1: required i32 templateId,
    2: required i32 seasonId,
    3: required i32 periodId,
    4: required i32 subjectId,
    5: required i16 grade,
    6: required i16 cycleDay,
    7: required i16 startTime,
    8: required i16 endTime,
    9: required i16 maxClassNum,
    10: required i16 maxStudentNum,
    11: required i32 totalNumber,  # 招生名额
    12: required i32 usedNumber,  # 占用名额报名
    13: required i32 currentClassNumber,  # 报名本次课的学员
    14: required i32 totalRestNumber,  # 剩余名额
    15: required i32 currentRestNumber,  # 本次课剩余名额
    16: required i32 lastClassContinueNumber,  # 上次课需续约数
    17: required i32 lastClassUnContinueNumber,  # 上次课未续约数
    18: required i32 currentContinueNumber,  # 需要在本次课续约数
    19: required i32 lastClassNewNumber,  # 上次课新约课总人数
    20: required i32 lastWeekTotalNumber  # 上周新约课总人数
}

service ClassTemplateService extends common.BaseService {

    list<ClassTemplateDef> getAll(1:required i32 limit, 2:required i32 offset)
        throws (1:common.ServerError se),

    i32 getAllCount()
        throws (1:common.ServerError se),

    list<ClassTemplateDef> getFilteredData(
        1:required i32 limit,
        2:required i32 offset,
        3:required i32 seasonId,
        4:required i32 subjectId,
        5:required i16 grade,
        6:required i32 periodId
    )
        throws (1:common.ServerError se),

    ClassTemplateDef getById(1:required i32 id)
        throws (1:common.ServerError se, 2:common.ReturnFalse rf),

    i32 getReservationDataCount()
        throws (1:common.ServerError se),

    list<ReservationTemplateDef>getFilteredReservationData(
        1:required i32 limit,
        2:required i32 offset
    )
        throws (1:common.ServerError se),

    list<ClassTemplateDef> getFilteredDataByTemplateID(
        1:required i32 id
        )
        throws (1:common.ServerError se),

    list<EnrollmentScheduleDef> getEnrollmentSchedule(
        1:required i32 limit,
        2:required i32 offset
    ) throws (1:common.ServerError se),

    i32 getFilteredDataCount(
        1:required i32 seasonId,
        2:required i32 subjectId,
        3:required i16 grade,
        4:required i32 periodId
    )
        throws (1:common.ServerError se),

    i32 add(1:required ClassTemplateDef classTemplate)
        throws (1:common.ServerError se),

    bool update(1:required ClassTemplateDef classTemplate)
        throws (1:common.ServerError se),

    bool remove(1:required i32 classTemplateId)
        throws (1:common.ServerError se)
}

struct CoachDef {
    1: required string userName,
    2: required string realName,
    3: required string areaCode,
    4: required string schoolName,
    5: required byte gradeType,
    6: required i32 subjectId,
    7: required string phone,
    8: required string qq,
    9: required i16 jobStatus,
    10: required i16 jobStage,
    11: required byte isForbidCity,
    12: required i16 rank,
    13: optional string areaDisplay
}

struct CoachImportCheckResultDef {
    1: required list<string> imported,
    2: required list<string> notExists,
    3: required list<string> notTeacher
}

struct CoachAvailableTimeDef {
    1: required i32 id,
    2: required string coach,
    3: required i32 periodId,
    4: required i32 seasonId,
    5: required i16 cycleDay,
    6: required i16 startTime,
    7: required i16 endTime,
    8: required string startDay,
    9: required string endDay,
    10: required bool isUsed
}

struct FiredInfoDef{
    1: required string firedDate,
    2: required string firedReason,
    3: required string operator,
    4: required i16 operateType
}

struct CoachHiringDef {
    1: required string userName,
    2: required string realName,
    3: required string areaCode,
    4: required string schoolName,
    5: required byte gradeType,
    6: required i32 subjectId,
    7: required string phone,
    8: required string qq,
    9: optional string areaDisplay
}

service CoachService extends common.BaseService {

    list<FiredInfoDef> getFiredCoachInfoByUserName(1:required string userName)
        throws (1:common.ServerError se),

    list<CoachAvailableTimeDef> getAllUsablePeriod(1:required string userName)
        throws (1:common.ServerError se),

    list<CoachDef> getAll(1:required i32 limit, 2:required i32 offset)
        throws (1:common.ServerError se),

    i32 getAllCount()
        throws (1:common.ServerError se),

    list<CoachDef> getFilteredCoaches(
        1:required i32 limit,
        2:required i32 offset,
        3:required string condition)
        throws (1:common.ServerError se),

    i32 getFilteredCoachesCount(
        1:required string condition)
        throws (1:common.ServerError se),

    CoachImportCheckResultDef importCheck(
        1:required list<string> coachNames)
        throws (1:common.ServerError se),

    bool importCoaches(1:required list<string> coachNames)
        throws (1:common.ServerError se),

    list<i32> getCoachClassIds(1:required string coachName)
        throws (1:common.ServerError se),

    bool dismissCoach(
        1:required string coachName,
        2:required string opAdmin,
        3:required string remark)
        throws (1:common.ServerError se),

    bool setCoachRetraining(
        1:required string coachName,
        2:required string opAdmin,
        3:required string remark)
        throws (1:common.ServerError se),

    bool setCoachTrial(
        1:required string coachName,
        2:required string opAdmin,
        3:required string remark)
        throws (1:common.ServerError se),

    bool setCoachPositive(
        1:required string coachName,
        2:required string opAdmin,
        3:required string remark)
        throws (1:common.ServerError se),

    bool cancelCoachRetraining(
        1:required string coachName,
        2:required string opAdmin,
        3:required string remark)
        throws (1:common.ServerError se),

    list<CoachAvailableTimeDef> getCoachAvailableTime(1:required string coachName)
        throws (1:common.ServerError se),

    list<CoachHiringDef> getFilteredHiringCoaches(
        1:required i32 limit,
        2:required i32 offset,
        3:required string condition)
        throws (1:common.ServerError se),

    i32 getFilteredHiringCoachesCount(
        1:required string condition)
        throws (1:common.ServerError se),

    CoachImportCheckResultDef importHiringCheck(
        1:required list<string> coachNames)
        throws (1:common.ServerError se),

    bool importHiringCoaches(1:required list<string> coachNames)
        throws (1:common.ServerError se),

    bool setCoachReserve(
        1:required string coachName,
        2:required string opAdmin,
        3:required string remark)
        throws (1:common.ServerError se),

    bool setCoachClassNum(
        1:required string coachName,
        2:required i16 coachRank)
        throws (1:common.ServerError se)
}

struct StudentDef {
    1: required string userName,
    2: required string realName,
    3: required string areaCode,
    4: required string schoolName,
    5: required i16 grade,
    6: required string phone,
    7: required string qq,
    8: optional string areaDisplay,
    9: optional i16 giftServiceTotal,
    10: optional i16 usedServiceTotal,
    11: optional i16 buyServiceTotal
}

service StudentService extends common.BaseService {

    list<StudentDef> getAll(1:required i32 limit, 2:required i32 offset)
        throws (1:common.ServerError se),

    list<EnlistDef> getEnlistResult(1:required string student_user_name)
        throws (1:common.ServerError se),

    list<EnlistDef> getClassList(1:required string student_user_name)
        throws (1:common.ServerError se),

    i32 getAllCount()
        throws (1:common.ServerError se),

    list<StudentDef> getFilteredStudents(
        1:required i32 limit,
        2:required i32 offset,
        3:required string condition)
        throws (1:common.ServerError se),

    i32 getFilteredStudentsCount(
        1:required string condition)
        throws (1:common.ServerError se),
}

struct ClassCreateTaskDef {
    1: required i32 id,
    2: required i16 grade,
    3: required i32 subjectId,
    4: required i32 periodId,
    5: required string classDay,
    6: required i16 startTime,
    7: required i16 endTime,
    8: required i32 studentNum,
    9: required i16 remainNum,
    10: required i16 taskStatus,
    11: required i32 newClassNum,
    12: optional i32 acceptCoachNum,
    13: optional i32 testSuccessCoachNum
}

struct CoachInviteDef {
    1: required i32 id,
    2: required i32 taskId,
    3: required i32 classTemplateId,
    4: required string coach,
    5: required i16 inviteStatus,
    6: required i16 inviteType,
    7: required string expireTime,
    8: required string inviteTime,
    9: optional string coachPhone,
    10: optional string coachRealName
}

service ClassAdminService extends common.BaseService {

    list<ClassCreateTaskDef> getAllClassCreateTasks(1:required i32 limit, 2:required i32 offset)
        throws (1:common.ServerError se),

    i32 getAllClassCreateTaskCount()
        throws (1:common.ServerError se),

    list<CoachInviteDef> getClassCreateTaskCoachInviteInfo(1:required i32 taskId)
        throws (1:common.ServerError se),

    list<StudentDef> getApplyStudentInfo(1:required i32 taskId)
        throws (1:common.ServerError se),

    i16 inviteCoach(1:required i32 taskId, 2:required string coachName)
        throws (1:common.ServerError se),

    bool cancelInvite(1:required i32 taskId, 2:required string coachName)
        throws (1:common.ServerError se),

    i16 startChangeClassCoach(
        1:required i32 classId,
        2:required string newCoachName,
        3:required i16 reasonType,
        4:required string remark
    )throws (1:common.ServerError se),

    i16 startTemporarySubstituteCoach(
        1:required i32 classId,
        2:required string newCoachName,
        3:required list<string> days,
        4:required string remark
    )throws (1:common.ServerError se),

    i32 ChangeStudentClass(
        1:required string student,
        2:required string original_class_id,
        3:required string target_class_id)
        throws (1:common.ServerError se),

    bool sendNotification(
        1:required i16 classId,
        2:required string notification,
        3:required list<i16> target
    )throws (1:common.ServerError se),

    i16 modifyStudentToAnotherClass(
        1:required string studentName,
        2:required i16 originClassId,
        3:required i16 targetClassId,
        4:required string op_admin,
        5:required string remark
    )throws (1:common.ServerError se),

    bool closeClass(1:required i32 classId)
        throws (1:common.ServerError se)
}

struct ServiceReservationDef {
    1: required i32 templateId,
    2: required string startTime,
    3: required string endTime,
    4: required i16 subjectId,
    5: required string subjectName,
    6: required string coachName,
    7: required i16 status,
    8: required i16 cycleDay,
    9: required i32 total,
    10: required i32 notCost,
    11: required i32 canCancelNum
    12: required i16 grade,
    13: required i32 seasonId,
    14: required i16 seasonType,
    15: optional string nextDay,
    16: optional i32 classId,
    17: optional i16 edition,
    18: optional string insertTime,
    19: optional i32 cardId
}

struct ServiceDayPayInfoDef {
    1: required string day,
    2: required bool isRequired,
    3: required i16 price,
    4: required i32 totalPrice
}

struct ClassPlanDef {
    1: required string classDay,
    2: required i16 status,
    3: required i16 canChangeStatus,
    4: required i16 canCancelStatus
}

struct ServiceCostDef {
    1: required i16 totalNum,
    2: required i16 needPayMoney,
    3: required i16 useRemainNum,
    4: required i16 needPayNum
}


# 用户提交教练伴学服务订单
struct TutorOrderDef {
    1: required string userName,
    2: required i32 templateId,
    3: required i16 classId,
    4: required string startTime,                           # 毫秒数
    5: required i32 rechargeCardId
}

struct StudentAccountSummaryDef {
    1: required string userName,
    2: required i16 remainServiceNum,
    3: required i32 subjectId,
    4: required string nextLessonDay
}

struct StudentApplyClassInfoDef {
    1: required string userName,
    2: required i32 classId,
    3: required string coach,
    4: required string coachName,
    5: required i16 subjectId,
    6: required i16 edition,
    7: required string startTime,
    8: required string endTime,
    9: required i16 cycleDay
}

struct StudentClassInfoDef {
    1: required string coachName,
    2: required i32 subjectId,
    3: required i16 grade,
    4: required i16 edition,
    5: required string startDay,
    6: required string endDay
}


struct UserSoftTestInfoDef {
    1: required string userName,    # 用户名
    2: required bool isTested,      # 是否参与测试
    3: required bool passTest,      # 是否通过测试
    4: required bool camera,        # 摄像头是否通过测试
    5: required bool voiceOutput,   # 耳机／音响是否测试通过
    6: required bool voiceInput,    # 麦克风是否测试通过
    7: optional bool lesson,        # 听课是否通过测试
    8: optional bool whiteBoard,    # 白板是否通过测试
}

struct CancelReservationInfoDef {
    1: required i32 classTemplateId,                        # 约课记录的 班型id
    2: required string startTime,                           # 取消约课的开始课次时间
    3: required string endTime,                             # 取消约课的结束课次时间
    4: required i32 cardId                                  # 约课记录的来源课卡id
}

struct OldDailyServiceCostDetailDef {
    1: required string day,                 # 日期
    2: required string student,             # 学员
    3: required i16 costNum,             # 消耗数量
    4: required i16 subjectId,              # 科目编号
}

struct CardCostDef {
    1: required i32 cardId,     # 卡编号
    2: required i16 costNum,    # 消耗次数
    3: required double price,   # 单价
}

struct DailyServiceCostDetailDef {
    1: required string day,                 # 日期
    2: required string student,             # 学员
    3: required string orderId,             # 订单号
    4: required list<CardCostDef> cards,    # 消耗卡详细信息
}

struct DailyServiceCostResultDef {
    1: required list<OldDailyServiceCostDetailDef> oldOrderCost,
    2: required list<DailyServiceCostDetailDef> newOrderCost,
}

struct OrderRecordDef {
    1:required string userName,
    2:required i32 subjectId,
    3:required string orderId,
    4:required i16 serviceNum,
    5:required double price,
    6:optional i16 cancelServiceNum,
    7:optional string orderTime
}

# 用于销售展示学季卡
struct SaleRechargeCardDef {
    1: required i32 id,                             # 销售卡ID
    2: required i32 seasonId,                       # 学季ID
    3: required i32 subjectId,                      # 科目ID
    4: required byte gradeType,                     # 年级类型， 1， 初中， 2，高中
    5: required i16 serviceNum,                     # 包含课次，（每天更新）
    6: optional double price                        # 课次单价
    7: optional byte isForSale,                     # 是否可售， 1， 可以， 2，不可以
}

struct ServiceDayInfoDef {
    1: required i32 classTemplateId,
    2: required string day,
    3: required i16 status,
    4: optional i32 subjectId
    5: optional i32 classId
}

# -5: 指定教练，正在该班上课，未过保留名额期，除最近一节课，后面的都不可约
# -3: 后面有已约时段，且间期不足学季卡标准次数
# -2: 已约课 -1:冲突 0:没有名额 1:可约
# 2:可约课，处于名额保留期

# 教练伴学服务信息，约课使用
struct CanApplyServiceInfoDef {
    1: required string startTime,
    2: required string endTime,
    3: required list<ServiceDayInfoDef> serviceDaysInfo,
}

struct CoachServiceDef{
    1:required string coach,
    2:required string realName
}

# 学生约课卡
struct StudentRechargeCardDef {
    1: required i32 id,
    2: required i32 seasonId,
    3: required i32 subjectId,
    4: required byte gradeType,
    5: required i16 remainNum,
    6: required string expireTime,
    7: required bool isExpired,
    8: optional i16 originNum,
    9: optional bool canRefund,
    10: optional string orderId,
    11: optional byte cardType
}

# 课表展示
struct StudentLessonScheduleDef {
    1: required i32 classId,
    2: required i32 classTemplateId,
    3: required string coach,
    4: required i16 grade,
    5: required i32 subjectId,
    6: required string day,
    7: required string startTime,
    8: required string endTime,
    9: required string startDay,
    10: required string endDay,
    # 请假状态
    11: required i32 reservationId,
    12: required i16 edition,
    13: required bool askLeaveStatus,
    14: required bool canAskLeave,
    15: required bool canChange,
    # 1正在上课 2还没上，但不能调课 4上完了
    16: required byte status
}

# 学生版本信息
# id=0 新增
struct StudentTextbookEditionDef {
    1: required i32 id,
    2: required byte gradeType,
    3: required i32 subjectId,
    4: required i16 edition,
}

# 快递地址
struct DeliveryAddressDef {
    1: required i32 id,
    2: required string name,
    3: required string phone,
    4: required string address,
    5: required string areaCode,
    6: optional bool isDefault,
    7: optional string province,
    8: optional string city,
    9: optional string area
}

# 取消约课的子订单里各课卡详情
struct CancelCardInfoDef {
    1: required i32 rechargeCardId,         # 卡号
    2: required i32 subjectId,              # 课卡的科目id
    3: required i32 cancelServiceNum,       # 取消次数
    4: required double price,               # 课卡的课次单价
    5: required i32 seasonId,               # 课卡的学季
    6: required i32 saleCardId,             # 对应的销售卡id
}

# 取消约课的订单数据里子订单详情
struct CancelOrderInfoDef {
    1: required string orderId,                                     # 订单id， 旧订单数据里会有可能出现为空
    2: required list<CancelCardInfoDef> cancelCardInfo,             # 订单里包含的退卡信息列表
}

# 取消约课价格明细信息（根据是否有合并订单归类）
struct CancelPayPriceInfoDef {
    1: required list<CancelOrderInfoDef> cancelOrderInfo,           # 包含的具体各订单信息列表
    2: required byte isMerged,                                      # 是否合并订单，1，是，0，不是
    3: required byte isOldOrder,                                    # 是否旧版订单，1，是，0，不是
    4: required i32 totalCancelNum,                                 # 本次取消总数
    5: required i32 payNum,                                         # 实际付款次数（旧订单展示用，对于新订单视为等于总次数）
    6: required i32 totalCancelMoney,                               # 本次取消总价  （旧订单取消总价等于实际付费，按次数观察优惠）
    7: required double payMoney,                                    # 实际付费价格
    8: required double giftMoney,                                   # 减免的费用

}

struct BankRecordDef{
    1:required i32 id,
    2:required string bankName,
    3:required string bankCard,
    4:required string bankAddress,
    5:required string subBankName,
    6:required string beneficiaryName,
    7:required string phone,
    8:required byte isDefault,
}

struct ComputeOrderMoneyDef{
    1: required double originalMoney,                                   # 订单原价
    2: required double giftMoney,                                       # 减免费用
    3: required list<string> mergeOrderIdList,                                  # 关联的合并订单id列表
    4: required byte version                                            # 当前版本
}

struct HandoutDef {
    1:required i16 grade,
    2:required i32 subject,
    3:required string semester,
    4:required string version,
    5:optional i32 remain,
    6:optional bool selectable
}

struct ApplyServiceInfoDef {
    1: required string subjectName,
    2: required i32 remainNum,
    3: required i32 consumeNum,
    4: required string periodTime,
    5: required string startDay,
    6: required string endDay
}

struct AccountNumOverviewDef {
    1: required string cardName,
    2: required i32 totalNum,
    3: required i32 cardRemainNum,
    4: required list<ApplyServiceInfoDef> applyServiceInfo
}

#struct StudentRegisterTimeDef {
#    1: required string student,
#    2: required string registerTime,
#}

struct OrderDef {
    1: required string orderId,         # 订单编号
    2: required string userName,        # 用户编号
    3: required i16 subjectId,          # 科目
    4: required i32 serviceNum,         # 订单明细数据
    5: required byte orderType,         # 订单类型
    6: required byte orderStatus,       # 订单状态
    7: required double payMoney,        # 订单需支付金额
    8: required bool isValid,           # 是否有效
    9: required string createdAt,       # 订单创建时间
}


service QuotaService extends common.BaseService {

    # 获取当前
    i16 getDayStudyYear(1:string day) throws (1:common.ServerError se, 2:common.ReturnFalse rf)

    # 计算提单金额
    ComputeOrderMoneyDef computeOrderMoney(
        1: required string student                                      # 用户名
        2: required map<i32,i32> saleCards                              # { 销售卡id编号: 次数 }
        )
        throws (1:common.ServerError se, 2:common.ReturnFalse rf)       # 错误类型： 1: 提交数据为空，2：单科目未达5次，3：卡不存在

    # 网站保存订单到非教学端
    bool addOrderAndAccount(                         # 1：失败，单科目未达5次， 2：订单金额有误
        1:required string userName,                                     # 用户名
        2:required string orderId,                                      # 订单编号
        3:required list<SaleRechargeCardDef> saleRechargeCardDef,       # 订单包含的销售卡信息
        4:required string orderTime,                                    # 购买的服务次数
        5:required double originMoney,                                  # 原价
        6:required double payMoney,                                     # 实付价格
        7:required byte version,                                         # 版本
        8:required byte orderType,                                      # 订单(卡)类型，1: 普通订单， 2 :X+1订单，3，体验卡
        )
        throws (1:common.ServerError se, 2:common.ReturnFalse rf),      # 1：失败，单科目未达5次， 2：订单金额有误, 3:添加订单失败

    # 增加体验课次数
    byte addExperienceAccount(
        1:required string userName,                                     # 用户名
        )
        throws (1:common.ServerError se),

    # 获取拥有的未使用的体验卡次数
    i32 getNotUsedExperienceCardNum(
        1:required string userName,                                     # 用户名
        )
        throws (1:common.ServerError se),

    # 根据用户名得到是否有权限报名教练伴学(试运营期间)
    bool isAuthorized(
        1:required string student                                       # 学员用户名。
        )
        throws (1:common.ServerError se),

    # 退课页面获取已约但未上完的课程
    list<ServiceReservationDef> getStudentCanCancelReservationInfo(
        1:required string student                                       # 学员用户名。
        )
        throws (1:common.ServerError se),

    # 获取当前可供约课的教练伴学服务信息，会根据学员本身约课情况有所不同。
    list<CanApplyServiceInfoDef> getAllServiceInfo(
        1:required string student,                                      # 学员用户名。
        2:required byte gradeType,                                      # 年级类型 1，初中, 2，高中
        3:required i32 seasonId,                                        # 学季ID
        4:required i32 subjectId                                        # 科目ID
        )
        throws (1:common.ServerError se),

    list<CoachServiceDef> getCoachServices(
        1:required string student,
        2:required byte gradeType,
        3:required i32 seasonId,
        4:required i32 subjectId
        )
        throws (1:common.ServerError se),

    list<CanApplyServiceInfoDef> getCoachServiceInfo(
        1:required string student,                                      # 学员用户名。
        2:required byte gradeType,                                      # 年级类型 1，初中, 2，高中
        3:required i32 seasonId,                                        # 学季ID
        4:required i32 subjectId,                                        # 科目ID
        5:required string coach
        )
        throws (1:common.ServerError se),

    list<CanApplyServiceInfoDef> getContinueServiceInfo(
        1:required string student,                                       # 学员用户名。
        2:required i32 classId,                                          # 续接的班级编号。
        )
        throws (1:common.ServerError se),

    # 根据学员选择的约课开始日期和约课卡信息得到上课日期
    list<string> getApplyServiceByStartDay(
        1:required string student,                                       # 学员用户名。
        2:required i32 classTemplateId,                                  # 学员约课的班型编号。
        3:required string startDay,                                      # 学员约课的开始日期。
        4:required i32 rechargeCardId,                                   # 学季id
        5:required i32 classId,
        )
        throws (1:common.ServerError se),

    # 根据学员希望续的课得到其续该课的不同结束日期对应的需付费信息。
    list<ServiceDayPayInfoDef> getContinueClassInfo(
        1:required string student,                                       # 学员用户名。
        2:required i32 classId                                           # 续课的班级编号。
        )
        throws (1:common.ServerError se),

    # 获取学员约课详情
    StudentApplyClassInfoDef getStudentApplyClass(
        1:required string student,                                       # 学员用户名
        2:required i32 classId                                           # 已约课的班级编号。
        )
        throws (1:common.ServerError se, 2:common.ReturnFalse rf),

    # 根据起止时间和班型得到区间内的所有上课日期
    list<ClassPlanDef> getClassPlanByTemplate(
        1:required string student,                                       # 学员用户名
        2:required i32 templateId,                                       # 班型编号
        3:required string startDay,                                      # 开始日期
        4:required string endDay                                         # 结束日期
        )
        throws (1:common.ServerError se),

    # 根据起止时间和班级得到区间内的所有上课日期
    list<ClassPlanDef> getClassPlan(
        1:required string student,                                       # 学员用户名
        2:required i32 classId,                                          # 班级编号
        3:required string startDay,                                      # 开始日期
        4:required string endDay                                         # 结束日期
        )
        throws (1:common.ServerError se),

    # bool checkSameTemplateClass(
    #     1:required string student,
    #     2:required i32 classTemplateId,
    #     3:required string startTime,
    #     4:required string endTime,
    #     5:required i32 classId
    #     )
    #     throws (1:common.ServerError se),

    # return值
    # 1:报名时间不对  2:学生信息不对  3:组班任务未找到老师
    # 4:班级冲突 5:找不到学季信息 6:班型不对
    # 7:计算出来使用次数<0 8:扣除约课卡次数失败 9:班级id错误
    # 10:名额不足
    # 12:班级人数已达上限 13:续接班报名给教练发送短信
    # 14:教材版本不对 15:未找到约课卡 16:约课卡剩余次数为0
    # 17:开始日期后以约课
    i16 submitTutorService(
        1: required TutorOrderDef order)
        throws (1:common.ServerError se),

    # 同步用户信息（批量）
    bool syncUserInfo(
        1:required list<string> students                                # 需要同步的用户名数组
        )
        throws (1:common.ServerError se),

    ServiceCostDef computeCost(
        1:required string student,
        2:required i32 classTemplateId,
        3:required string startDay,
        4:required string endDay)
        throws (1:common.ServerError se, 2:common.ReturnFalse rf),

    bool useClassTemplateQuota(
        1:required string student,
        2:required i32 classTemplateId,
        3:required string startDay,
        4:required string endDay)
        throws (1:common.ServerError se),

    bool cancelTemplatePlaceHold(
        1:required string student,
        2:required i32 classTemplateId,
        3:required string startDay,
        4:required string endDay)
        throws (1:common.ServerError se),

    # 获取服务单价
    list<i16> getPrice()
        throws (1:common.ServerError se),

    # 获取当前有效（可报名的）的学季信息
    list<SeasonDef> getAvailableSeasons()
        throws (1:common.ServerError se),

    list<StudentAccountSummaryDef> getStudentAccountSummaryInfo(1:required string student)
        throws (1:common.ServerError se),

    UserSoftTestInfoDef getUserSoftTestInfo(1:required string userName)
        throws (1:common.ServerError se),

    # 换课
    bool changeStudentReservation(
        1:required string student,
        2:required i32 classTemplateId,
        3:required string startDay)
        throws (1:common.ServerError se, 2:common.ReturnFalse rf),

    bool addOrderRecord(
        1:required string userName,                                     # 用户名
        2:required i32 subjectId,                                       # 科目编号
        3:required string orderId,                                      # 订单编号
        4:required i16 serviceNum,                                      # 购买的服务次数
        5:required double price,                                        # 购买单价
        6:required double cancel_price                                  # 此订单退款时的单价
        )
        throws (1:common.ServerError se, 2:common.ReturnFalse rf),

    list<OrderRecordDef> getUserOrderRecode(
        1:required string userName
        )
        throws (1:common.ServerError se),

    DailyServiceCostResultDef computeDailyTotalCost(1:required string day)
        throws (1:common.ServerError se),

    # 展示销售学季卡
    list<SaleRechargeCardDef> getAllSaleCard()
        throws (1:common.ServerError se),

    # 根据编号数组获取约课卡信息
    list<SaleRechargeCardDef> getSaleCardByIds(1:required list<i32> idList)
        throws (1:common.ServerError se),

    # 课表展示
    list<StudentLessonScheduleDef> getStudentClassSchedule(
        1:required string student,
        2:required i32 season
        )throws (1:common.ServerError se),

    # 课表获取课程详情
    StudentClassInfoDef getStudentClassInfo(
        1: required string student,
        2: required i32 classTemplateId,
        3: required string day
        )throws (1:common.ServerError se, 2:common.ReturnFalse rf)

    # 获取学员所有的约课卡
    list<StudentRechargeCardDef> getAllStudentCard(
        1: required string student,
        # 2: required i16 flag
        )throws (1:common.ServerError se),

    StudentRechargeCardDef getStudentCardById(
        1: required string student,
        2: required i32 cardId
        )throws (1:common.ServerError se, 2:common.ReturnFalse rf),

    # 获取学生版本信息
    StudentTextbookEditionDef getStudentTextbookEdition(
        1: required string student,
        2: required i32 subjectId,
        3: required byte gradeType
        )throws (1:common.ServerError se, 2:common.ReturnFalse rf),

    list<StudentTextbookEditionDef> getAllStudentTextbookEdition(
        1: required string student
        )throws (1:common.ServerError se),

    list<StudentTextbookEditionDef> getStudentTextbookEditionById(
        1: required list<i32> id,
        )throws (1:common.ServerError se),

    bool setStudentTextbookEdition(
        1: required string student,
        2: required StudentTextbookEditionDef studentTextbookEdition,
        )throws (1:common.ServerError se),

    # 获取学员快递地址信息
    list<DeliveryAddressDef> getDeliveryAddress(
        1: required string student,
        2: required i32 id
        )throws (1:common.ServerError se),

    bool setDeliveryAddress(
        1: required string student,
        2: required DeliveryAddressDef deliveryAddress,
        )throws (1:common.ServerError se),

    # 计算退费
    list<CancelPayPriceInfoDef> computeCancelPay(
        1:required string student,
        2:required list<i32> cancelRechargeCards,                            # 取消的课卡card_id列表
        3:required list<CancelReservationInfoDef> cancelReservation          # 取消的约课信息列表
       )
       throws (1:common.ServerError se, 2:common.ReturnFalse rf),

    # 退费
    list<CancelPayPriceInfoDef> cancelPay(
        1:required string student,
        2:required list<i32> cancelRechargeCards,                             # 取消的课卡card_id列表
        3:required list<CancelReservationInfoDef> cancelReservation           # 取消的约课信息列表
        )
        throws (1:common.ServerError se, 2:common.ReturnFalse rf),

    # 取消退款
    bool cancelRefund(
        1:required string student,
        2:required string cancelPayPriceInfoJson,                      # 取消退费在网站订单保存的订单信息json串
        )
        throws (1:common.ServerError se),

    # 请假功能
    bool studentAskLeave(
        1:required string studentName,
        2:required i32 reservationId,
        3:required string leaveStartTime                                # 请假课次的开始时间（datetime）
        )throws (1:common.ServerError se, 2:common.ReturnFalse rf),      # return: 1,课程已结束 2，请假次数已满 3,报名数据不存在

    # 添加银行卡记录
    bool addBankCard(
        1:required string userName,                                     # 用户
        2:required string beneficiaryName,                              # 受益人
        3:required string bankName,                                     # 银行名称
        4:required string bankCard,                                     # 银行卡号
        5:required string bankAddress,                                  # 银行地址
        6:required string subBankName,                                  # 支行名称
        7:required string phone,                                        # 联系电话
        )
        throws (1:common.ServerError se),

    # 获取用户退款银行信息
    list<BankRecordDef> getBankRecordInfo(
        1:required string userName,
        )
        throws (1:common.ServerError se),

    # 根据ID获取退款银行信息且设为默认选择
    BankRecordDef getBankRecordById(
        1:required string userName,
        2:required i32 cardId,                                          # 银行卡记录id
        )
        throws (1:common.ServerError se, 2:common.ReturnFalse rf),

    list<byte> getApplyGrade(
        1:required string student,
        2:required byte gradeType
        )throws (1:common.ServerError se, 2:common.ReturnFalse rf),

    list<HandoutDef> checkHandoutSelectable(
        1:required string student,
        2:required list<HandoutDef> handouts,
        3:required i32 season
        )throws (1:common.ServerError se),

    bool addHandoutRecord(
        1:required string student,
        2:required list<HandoutDef> handouts,
        3:required i32 season
        )throws (1:common.ServerError se),

    # 获取学员还没有学完的服务的科目信息
    list<i16> getStudentRemainServiceSubjects(1:string userName)
        throws (1:common.ServerError se, 2:common.ReturnFalse rf),

    list<i32> checkIfHandoutReachLimit(
        1:required string student,
        2:required byte gradeType,
        3:required i32 subjectId,
        4:required i32 seasonId
        )throws (1:common.ServerError se),

    list<AccountNumOverviewDef> getAccountNumOverview(
        1:required string student
        )throws (1:common.ServerError se),

    #list<StudentRegisterTimeDef> getRegisterTimesByDay(
    #    1:required string day
    #    )throws (1:common.ServerError se),

    # 作废订单
    bool deleteCardByInvalidOrder(1:string orderId)
        throws(1:common.ServerError se, 2:common.ReturnFalse rf),

    # 作废订单恢复
    bool addCardByRecoverOrder(1:string orderId)
    throws(1:common.ServerError se, 2:common.ReturnFalse rf),

    # 获取旧版CRM来源订单用于订单展示
    list<OrderDef> getOldOrderFromCrm(1:string userName)

    bool sendUserRegisterSms(1:string phone, 2:string content)
        throws (1:common.ServerError se),
}

struct ClassDef{
    1: required i32 classID,
    2: required string startDate,
    3: required string endDate,
    4: required string coach,
    5: required i16 year,
    6: required i16 season,
    7: required i16 grade,
    8: required i32 subject,
    9: required i16 circleDay,
   10: required i16 startTime,
   11: required i16 endTime,
   12: required i16 maxOneClass,
   13: required i32 maxClass,
   14: required i16 numberOfPeople,
   15: required double percent,
   16: required i16 changeCoach,
   17: required string lessonPlan,
   18: required i16 isClosed
}

struct StudentInClassDef{
    1:required string userName,
    2:required string realName,
    3:required string phone,
    4:required string areaDisplay,
    5:required string firstClassDate,
    6:required string lastClassDate
}

# state
# 1-成功 2-失败，班级重复 3-失败，没有这个班级 4-失败，班级满了 5-不在平行班


struct ClassExchangeDef{
    1:required i32 oldClassID,
    2:required i32 newClassID,
    3:required i32 state
}

struct TemporarySubstituteInfoDef{
    1: required i32 classID,
    2: required string oldCoach,
    3: required i16 season,
    4: required i16 grade,
    5: required i32 subject,
    6: required i16 circleDay,
    7: required i16 startTime,
    8: required i16 endTime,
    9: required string newCoach,
   10: required list<string> dateTime,
   11: required i32 times,
   12: required i16 status
}

struct ClassChangeCoachStatusDef{
    1: required i32 classID,
    2: required string originCoach,
    3: required i16 seasonId,
    4: required i16 grade,
    5: required i32 subjectId,
    6: required i16 circleDay,
    7: required i16 startTime,
    8: required i16 endTime,
    9: required string newCoach,
    10: required string beginDate,
    11: required i16 status,
    12: required i16 periodId
}

struct ClassNumDef{
    1: required string rank,
    2: required i16 id,
    3: required i16 spring_base_num,
    4: required i16 spring_max_num,
    5: required i16 winter_base_num,
    6: required i16 winter_max_num
}

service ClassService extends common.BaseService {

    list<StudentInClassDef>getStudentInfoInClassById(
        1:required i32 classId
    )throws (1:common.ServerError se),

    list<ClassExchangeDef> modifyStudentToAnotherClass(
        1:required i32 studentId,
        2:required list<ClassExchangeDef> changeList
    )throws (1:common.ServerError se),

    list<ClassDef> getFilteredClass(
        1:required i32 limit,
        2:required i32 offset,
        3:required string condition)
        throws (1:common.ServerError se),

    list<ClassDef> getClassById(
        1:required i32 classId
        )
        throws (1:common.ServerError se),

    i32 getFilteredClassCount(
        1:required string condition)
        throws (1:common.ServerError se)

    list<TemporarySubstituteInfoDef> getFilteredTemporaryInfo(
        1:required i32 limit,
        2:required i32 offset,
        3:required string condition)
        throws (1:common.ServerError se),

    i32 getFilteredTemporaryInfoCount(
        1:required string condition)
        throws (1:common.ServerError se),

    # 取出系统自动给班级更换老师的任务未完成的班级
    list<ClassChangeCoachStatusDef> getChangeClassCoachStatus(
        1:required i32 limit,
        2:required i32 offset)
        throws (1:common.ServerError se),

    i32 getChangeClassCoachStatusCount()
        throws (1:common.ServerError se),

    list<ClassNumDef> getRankClassNum()
        throws (1:common.ServerError se),

    bool updateRankClassNum(
        1:required string data)
        throws (1:common.ServerError se)
}

service TutorClientService extends common.BaseService {

    # 教练登陆客户端完成软件测试
    bool completeSoftwareTest(1:required string coach)
        throws (1:common.ServerError se),

    # 记录教练最新登陆客户端的时间
    bool logCoachLastLoginTime(1:required string coach)
        throws (1:common.ServerError se),

    # 根据日期获取所属学季信息
    SeasonDef getBelongSeasonInfo(1:required string day)
        throws (1:common.ServerError se),

    list<ServiceReservationDef> getStudentAllServiceReservationInfo(
        1:required string student           # 学员用户名。
        )
        throws (1:common.ServerError se)
}

service CoachClientService extends common.BaseService {
    # 接受邀请
    bool acceptInvite(1:required i32 inviteId)
        throws (1:common.ServerError se),

    # 拒绝邀请
    bool refuseInvite(1:required i32 inviteId)
        throws (1:common.ServerError se),

    list<string> getInviteClassDays(1:required i32 inviteId)
        throws (1:common.ServerError se),

    # 创建跨季续接班
    bool createContinueClass
    (
        1:required i32 periodId,    # 时段编号
        2:required i16 cycleDay,    # 循环日类型
        3:required string startDay, # 开始日期
        4:required string endDay,   # 结束日期
        5:required i16 grade,       # 年级编号
        6:required string coach     # 教练用户名
    ) throws (1:common.ServerError se)
}



struct MonitorCoachDef{
    1: required i32 classID,
    2: required i16 season,
    3: required i16 year,
    4: required i16 grade,
    5: required i32 subject,
    6: required i16 circleDay,
    7: required string startDate,
    8: required i16 startTime,
    9: required i16 endTime,
   10: required string coach,
   11: required string realName,
   12: required i16 coachStatus,
   13: required i16 coachOnline,
   14: required i32 disconnectTime,
   15: required string phone
}

struct MonitorStudentDef{
    1: required i32 classID,
    2: required i16 season,
    3: required i16 year,
    4: required i16 grade,
    5: required i32 subject,
    6: required i16 circleDay,
    7: required string startDate,
    8: required i16 startTime,
    9: required i16 endTime,
    10: required i16 studentNum,
    11: required i16 loginNum,
    12: required i16 notlogNum,
    13: required i16 onlineNum,
    14: required i16 offlineNum,
    15: required double loginPercent,
    16: required double onlinePercent
}

service MonitorService extends common.BaseService {

    list<MonitorCoachDef> filterCoachClass(
        1:required i32 limit,
        2:required i32 offset,
        3:required string condition)
        throws (1:common.ServerError se),

    list<MonitorStudentDef> filterStudentClass(
        1:required i32 limit,
        2:required i32 offset,
        3:required string condition)
        throws (1:common.ServerError se),

    i32 filterCoachClassCount(
        1:required string condition)
        throws (1:common.ServerError se),

    i32 filterStudentClassCount(
        1:required string condition)
        throws (1:common.ServerError se),

    list<MonitorCoachDef> filterUnusualCoach(
        1:required i32 limit,
        2:required i32 offset,
        3:required string condition)
        throws (1:common.ServerError se),

    list<MonitorStudentDef> filterUnusualStudent(
        1:required i32 limit,
        2:required i32 offset,
        3:required string condition)
        throws (1:common.ServerError se),

    i32 filterUnusualCoachCount(
        1:required string condition)
        throws (1:common.ServerError se),

    i32 filterUnusualStudentCount(
        1:required string condition)
        throws (1:common.ServerError se)
}


struct SendSmsCodeResultDef {
    1: required byte status,        # 发送结果状态码：0-发送成功；1-发送间隔小于规定，不予发送；2-发送失败
    2: required string code,        # 发送的验证码
    3: required i16 remainSeconds   # 下一次可发送的剩余时间，单位：秒
}

service SmsCodeService extends common.BaseService {

    SendSmsCodeResultDef sendSmsCode(
        1: required string phone        # 需要向其发送验证短信的手机号
    ) throws (1:common.ServerError se, 2:common.ReturnFalse rf),

    bool checkSmsCode(
        1: required string phone,           # 需要验证短信的手机号
        2: required string code,            # 验证的短信码内容
        3: required bool removeAfterCheck   # 是否在验证后删除验证码
    ) throws (1:common.ServerError se, 2:common.ReturnFalse rf)
}

struct VideoDef{
    1: required i32 id,                             # 视频id
    2: required i32 grade,                          # 年级编号
    3: required i32 subject,                        # 科目编号
    4: required string title                        # 视频标题
    5: required string teacher                      # 主讲老师
    6: required string coach                        # 教练
    7: required string imageUrl                     # 图片url
    8: required string videoUrl                     # 视频url
    9: required i32 hits                            # 点击量

}

service ExperienceService extends common.BaseService {

    bool isUserHasRechargeCard(
        1: required string userName                 # 学生用户名
    ) throws (1:common.ServerError se),

    bool isHasExperience(
        1: required string userName                 # 学生用户名
    ) throws (1:common.ServerError se),

    bool setUserExperience(
        1: required string userName,                # 学生用户名
    ) throws (1:common.ServerError se),

    list<VideoDef> getAllVideoInfo() throws (1:common.ServerError se),

    bool addVideoPlayTimes(
        1: required i32 videoId,                    # 视频编号
    ) throws (1:common.ServerError se),

    bool addUserPlayHistory(
        1: required string userName,                   # 学生用户名
        2: required i32 videoId,                    # 视频编号
        3: required string startTime,               # 开始播放时间
        4: required i32 playTime                    # 播放时长
    ) throws (1:common.ServerError se),

    bool applyInteraction(
        1: required string userName,
    )throws (1:common.ServerError se),
}

struct PaymentInfoDef {
    1: required i32 id,
    2: required string userName,
    3: required string orderId,
    4: required i16 orderSys,
    5: required double payMoney,
    6: required i16 status,
    7: required string orderDescription,
    8: required i16 payChannel,
    9: optional string payResult,
    10: optional string createdAt,
    11: optional string updatedAt
}

service PaymentService extends common.BaseService {
    PaymentInfoDef createPayment(1:required PaymentInfoDef paymentInfo)
        throws (1:common.ServerError se, 2:common.ReturnFalse rf)

    PaymentInfoDef getPayment(1:required i32 paymentId)
        throws (1:common.ServerError se, 2:common.ReturnFalse rf)

    PaymentInfoDef getPaymentByOrder(1:required string orderId, 2:required i16 payChannel)
        throws (1:common.ServerError se, 2:common.ReturnFalse rf)

    bool updatePaymentStatus(
        1:required i32 paymentId,
        2:required bool isSuccess,
        3:required string payResult
    ) throws (1:common.ServerError se)
}
