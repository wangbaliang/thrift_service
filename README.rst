===========
教练伴学service
===========

提供教练伴学相关远程接口


Features
--------

教练伴学功能管理相关接口


测试部署
----

1. 部署虚拟环境（如果没有在当前目录下部署过虚拟环境），运行命令行：

    $ make deploy


#. 运行服务

    $ make run-service


生产环境部署
------

1. 系统必要组件：
    + python2.7
    + pip
    + virtualenv
    + supervisor

#. 准备好存放日志文件的目录：/usr/local/logs/etutorservice

#. 部署虚拟环境并安装程序依赖包：::

    $ cd /path/of/code/
    $ make deploy
#. 修改程序配置文件：::

    $ vim etc/default.yml
#. 修改supervisor配置文件：::

    $ vim /etc/supervisor/supervisord.conf
加入如下配置信息（注意其中路径）：::

    [program:etutorservice]
    command=/path/of/code/virtual_env/bin/python -m etutorservice -c etc/default.yml -r
    directory=/path/of/code
    stdout_logfile=/usr/local/logs/etutorservice/info.log ; stdout log path, NONE for none; default AUTO
    stderr_logfile=/usr/local/logs/etutorservice/error.log ; stderr log path, NONE for none; default AUTO


定时任务
----

0. 进入虚拟环境（如已经进入，不用重复执行）::

    $ source virtual_env/bin/activate

1. 命令介绍
    + 创建建班任务（每天凌晨0点定期执行）::

        $ python -m etutorservice -c etc/default.yml -e invite create

    + 向老师发邀请::

        $ python -m etutorservice -c etc/default.yml -e invite exec

    + 检查建班任务及邀请状态::

        $ python -m etutorservice -c etc/default.yml -e invite check

    + 教练未及时进行软件测试，在截止2小时时及时提醒（每天的17点和22点运行）::

        $ python -m etutorservice -c etc/default.yml -e invite notify_test

    + 开班前26小时教练还没有找齐的通知（每分钟或者从整点开始每30分钟（匹配上开班时间）执行一次）::

        $ python -m etutorservice -c etc/default.yml -e invite notify_class

    + 教师没有提前10分钟登录教练端的通知（每分钟执行一次）::

        $ python -m etutorservice -c etc/default.yml -e clazz check_on_time

    + 上午课课前通知（每天晚上8点运行一次（一天一次））::

        $ python -m etutorservice -c etc/default.yml -e clazz morning_notify

    + 非上午课课前通知（每分钟运行一次，从上午8点开始，到晚上8点结束）::

        $ python -m etutorservice -c etc/default.yml -e clazz not_morning_notify

    + 通知短信发送任务（每分钟执行一次）::

        $ python -m etutorservice -c etc/default.yml -e sms send

    + 初始化及更新名额占用信息（每天执行一次）::

        $ python -m etutorservice -c etc/default.yml -e clazz init_place

    + 清除班级过期学员（每天执行一次）::

        $ python -m etutorservice -c etc/default.yml -e clazz remove_expired_students

    + 释放教师可用时段（每天执行一次）::

        $ python -m etutorservice -c etc/default.yml -e clazz free_available_time

    + 发送报名数据任务（每天早上九点执行一次）::

        $ python -m etutorservice -c etc/default.yml -e send_reservation

    + 启动定时任务::

        $ python -m etutorservice -c etc/default.yml -e scheduler

2. 测试支持
如果设置配置文件中的testing项为true，可以在所有命令最后增加一个日期参数，会按照参数指定日期处理（不设置默认是三天后），如::

    $ python -m etutorservice -c etc/default.yml -e invite create 2016-04-01

