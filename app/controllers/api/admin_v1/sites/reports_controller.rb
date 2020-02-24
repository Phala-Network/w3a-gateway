# frozen_string_literal: true

class API::AdminV1::Sites::ReportsController < API::AdminV1::Sites::ApplicationController
  def online_users
    render json: {
      status: "ok",
      data: {
        count: 126560,
        week_on_week: 12,
        day_to_day: -11,
        timestamp: "2020-2-14 5:16:40"
      }
    }
  end

  def popular_pages
    render json: {
      status: "ok",
      data: {
        activeness: { # 活跃行为
          stats: {
            total: 12321,
            growth: 17.1,
          },
          chart: {
            xAxis: %w[Mon Tue Wed Thu Fri Sat Sun], # x轴
            data: [820, 932, 901, 934, 1290, 1330, 1320], # 数值
          }
        },
        conversion_rate: {
          ratio: 78,
          week_on_week: 12,
          day_to_day: -11
        },
        popular_pages: [
          {
            path: "/latest",
            pv_count: 2404,
            week_on_week: 3
          },
          {
            path: "/",
            pv_count: 2234,
            week_on_week: 28
          },
          {
            path: "/topic1",
            pv_count: 1231,
            week_on_week: -58
          },
          {
            path: "/topic2",
            pv_count: 1021,
            week_on_week: -58
          },
          {
            path: "/topic3",
            pv_count: 800,
            week_on_week: 58
          }
        ]
      }
    }
  end

  def devices
    render json: {
      status: "ok",
      data: {
        chart: {
          data: [ # 常用设备
            { value: 335, name: "Mobile", growth: 14 },
            { value: 310, name: "Windows", growth: 14 },
            { value: 234, name: "iPhone", growth: -16 },
            { value: 135, name: "iPad", growth: 54 },
            { value: 1548, name: "Linux", growth: -78 },
            { value: 1548, name: "Others", growth: 14 },
          ]
        }
      }
    }
  end

  def activities
    render json: {
      status: "ok",
      data: {
        chart: {
          xAxis: %w[Mon Tue Wed Tur Fri Sat Sun], # x轴
          yAxis: %w[
            0:00 1:00 2:00 3:00 4:00 5:00 6:00 7:00 8:00
            9:00 10:00 11:00 12:00 13:00 14:00 15:00 16:00
            17:00 18:00 19:00 20:00 21:00 22:00 23:00],
          data: [ # X 轴从左到右，即一天一个数组，每个数组从 Y 轴上到下，值为活跃度量化（将访问量转化成 0-9的量表）
            [
              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
            ],
            [
              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            ],
            [
              0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 3, 5, 5, 1
            ],
            [
              0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 5, 7, 7, 3, 1, 1
            ],
            [
              1, 1, 1, 1, 1, 3, 1, 3, 7, 7, 9, 9, 1, 0, 0, 0
            ],
            [
              0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0
            ],
            [
              0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            ],
          ]
        }
      }
    }
  end

  def geo
    render json: {
      status: "ok",
      data: {
        chart: {
          scope: "china",
          data: [
            { name: "北京", value: rand * 1000 },
            { name: "天津", value: rand * 1000 },
            { name: "上海", value: rand * 1000 },
            { name: "重庆", value: rand * 1000 },
            { name: "河北", value: rand * 1000 },
            { name: "河南", value: rand * 1000 },
            { name: "云南", value: rand * 1000 },
            { name: "辽宁", value: rand * 1000 },
            { name: "黑龙江", value: rand * 1000 },
            { name: "湖南", value: rand * 1000 },
            { name: "安徽", value: rand * 1000 },
            { name: "山东", value: rand * 1000 },
            { name: "新疆", value: rand * 1000 },
            { name: "江苏", value: rand * 1000 },
            { name: "浙江", value: rand * 1000 },
            { name: "江西", value: rand * 1000 },
            { name: "湖北", value: rand * 1000 },
            { name: "广西", value: rand * 1000 },
            { name: "甘肃", value: rand * 1000 },
            { name: "山西", value: rand * 1000 },
            { name: "内蒙古", value: rand * 1000 },
            { name: "陕西", value: rand * 1000 },
            { name: "吉林", value: rand * 1000 },
            { name: "福建", value: rand * 1000 },
            { name: "贵州", value: rand * 1000 },
            { name: "广东", value: rand * 1000 },
            { name: "青海", value: rand * 1000 },
            { name: "西藏", value: rand * 1000 },
            { name: "四川", value: rand * 1000 },
            { name: "宁夏", value: rand * 1000 },
            { name: "海南", value: rand * 1000 },
            { name: "台湾", value: rand * 1000 },
            { name: "香港", value: rand * 1000 },
            { name: "澳门", value: rand * 1000 }
          ]
        },
        ranking: [
          {
            name: "北京",
            ratio: 80,
          }, {
            name: "天津",
            ratio: 10,
          }, {
            name: "上海",
            ratio: 5,
          }, {
            name: "广州",
            ratio: 2,
          }, {
            name: "深圳",
            ratio: 1,
          }
        ]
      }
    }
  end

  def referrers
    render json: {
      status: "ok",
      data: {
        chart: {
          yAxis: %w[外链跳转 直接访问 搜索引擎],
          data: [
            {
              name: "头条",
              data: [120, 702, 301]
            }, {
              name: "百度",
              data: [0, 132, 101]
            }, {
              name: "谷歌",
              data: [220, 182, 0]
            }
          ]
        }
      }
    }
  end

  def retention_rate
    render json: {
      status: "ok",
      data: {
        chart: {
          xAxis: %w[Week0 Week1 Week2 Week3 Week4], # x轴
          yAxis: ["2/8 - 2/14", "2/15 - 2/21", "2/22 - 2/28", "2/29 - 3/4", "3/5 - 3/12"],
          summary: [100, 40, 30, 23, 60],
          data: [ # Y 轴从上到下，即一周一个数组，每个数组从 X 轴左到右，值为留存率（0-100）
            [
              100, 75, 50, 25, 25
            ],
            [
              100, 75, 50, 25, 0
            ],
            [
              100, 50, 45, 0, 0
            ],
            [
              100, 75, 0, 0, 0
            ],
            [
              100, 0, 0, 0, 0
            ],
          ]
        }
      }
    }
  end

  def trends
    render json: {
      status: "ok",
      data: {
        pv: {
          chart: {
            xAxis: %w[2 3 4 5 6 7 8], # x轴
            data1: [
              120, 132, 101, 134, 23, 230, 210
            ],
            data2: [
              220, 182, 191, 234, 290, 330, 310
            ]
          }
        },
        uv: {
          chart: {
            xAxis: %w[2 3 4 5 6 7 8], # x轴
            data1: [
              220, 182, 191, 234, 290, 330, 310
            ],
            data2: [
              120, 132, 101, 134, 23, 230, 210
            ]
          }
        },
        stay: {
          chart: {
            xAxis: %w[2 3 4 5 6 7 8], # x轴
            data1: [
              220, 182, 191, 234, 290, 330, 310
            ],
            data2: [
              120, 132, 101, 134, 23, 230, 210
            ]
          }
        },
      }
    }
  end
end
