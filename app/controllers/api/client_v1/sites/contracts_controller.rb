# frozen_string_literal: true

class API::ClientV1::Sites::ContractsController < API::ClientV1::Sites::ApplicationController
  def index
    render json: {
      status: "ok",
      contracts: [
        {
          id: 1,
          name: "实时用户数",
          group_name: "用户行为",
          desc: "现在正在使用产品的用户数",
          builtin: true,
          last_used_at: 1.days.ago
        }, {
          id: 2,
          name:  "产品浏览量",
          group_name: "用户行为",
          desc: "访问产品的浏览行为次数",
          builtin: true,
          last_used_at: 2.days.ago
        }, {
          id: 3,
          name: "访问用户量",
          group_name: "用户行为",
          desc: "访问产品的用户数量",
          builtin: true,
          last_used_at: nil
        }, {
          id: 4,
          name: "平均用户会话时长",
          group_name: "概况统计",
          desc: "现在正在使用产品的用户数",
          builtin: true,
          last_used_at: 10.days.ago
        }, {
          id: 5,
          name: "用户留存状况",
          group_name: "概况统计",
          desc: "历史用户的回访次数",
          builtin: true,
          last_used_at: nil
        }
      ],
      pagination: {
        current_page: 1,
        total_count: 4,
        per_page: 25
      }
    }
  end

  def stats
    render json: {
      status: "ok",
      data: {
        total_groups: 4,
        total_contracts: 15,
        my_groups: 4,
        my_contracts: 12,
        total_earning: 6560,
        earning_in_week: [
          300, 150, 200, 100, 50, 120, 150
        ]
      }
    }
  end

  def destroy
    render json: {
      status: "ok"
    }
  end
end
