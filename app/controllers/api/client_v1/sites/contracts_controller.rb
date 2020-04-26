# frozen_string_literal: true

class API::ClientV1::Sites::ContractsController < API::ClientV1::Sites::ApplicationController
  def index
    render json: {
      status: "ok",
      contracts: [
        {
          id: 1,
          name: "Real-time users",
          group_name: "Behavior",
          desc: "The number of users currently using the product",
          script: "",
          builtin: true,
          status: "in_use",
          credit_rate: 100,
          last_used_at: 1.days.ago
        }, {
          id: 2,
          name:  "Page views",
          group_name: "Behavior",
          desc: "The number of visiting behaviors",
          script: "",
          builtin: true,
          status: "in_use",
          credit_rate: 100,
          last_used_at: 1.days.ago
        }, {
          id: 3,
          name: "Visited users",
          group_name: "Behavior",
          desc: "The number of users who visited the product",
          script: "",
          builtin: true,
          status: "in_use",
          credit_rate: 100,
          last_used_at: 1.days.ago
        }, {
          id: 4,
          name: "Session duration",
          group_name: "Stats",
          desc: "The average length of time users stay in the product",
          script: "",
          builtin: true,
          status: "in_use",
          credit_rate: 100,
          last_used_at: 1.days.ago
        }, {
          id: 5,
          name: "User retention",
          group_name: "Stats",
          desc: "Acquisition date cohorts by user retention",
          script: "",
          builtin: true,
          status: "in_use",
          credit_rate: 100,
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

  def new
    @contracts = Contract.includes(:group).where.not(id: @site.contract_ids).page(params[:page]).per(params[:per_page])
    render json: {
      status: "ok",
      contracts: [
        {
          id: 1,
          name: "Real-time users",
          group_name: "Behavior",
          desc: "The number of users currently using the product",
          builtin: true,
        }, {
          id: 2,
          name:  "Page views",
          group_name: "Behavior",
          desc: "The number of visiting behaviors",
          builtin: true,
        }, {
          id: 3,
          name: "Visited users",
          group_name: "Behavior",
          desc: "The number of users who visited the product",
          builtin: true,
        }, {
          id: 4,
          name: "Session duration",
          group_name: "Stats",
          desc: "The average length of time users stay in the product",
          builtin: true,
        }, {
          id: 5,
          name: "User retention",
          group_name: "Stats",
          desc: "Acquisition date cohorts by user retention",
          builtin: true,
        }
      ],
      pagination: {
        current_page: 1,
        total_count: 5,
        per_page: params[:per_page] || 25
      }
    }
  end

  def create
    render json: {
      status: "ok"
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
