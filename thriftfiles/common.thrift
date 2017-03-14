# 共用数据结构定义文件

namespace py et_thrift.common
namespace php EtThrift.Common


# 无效参数错误
exception InvalidArgumentError {
    1:optional string message
}

# 服务器端发生错误
exception ServerError {
    1: optional i16 errorCode,
    2: optional string message
}

# 返回错误信息
exception ReturnFalse {
    1: required i16 returnCode,
    2: optional string message,
    3: optional string errors
}

# 服务基本信息类
service BaseService {
    void ping(),
    string getVersion()
}
