# frozen_string_literal: true

class API::AdminV1::Sites::ContractsController < API::AdminV1::Sites::ApplicationController
  def index
    @contract_subscriptions = @site.contract_subscriptions.includes(:contract).page(params[:page]).per(params[:per_page])

    unless params[:in_use].nil?
      @contract_subscriptions =
        @contract_subscriptions
          .where(status: ActiveModel::Type.lookup(:boolean).cast(params[:in_use]) ? :in_use : :not_in_use)
    end
    if params[:keyword].present?
      @contract_subscriptions = @contract_subscriptions.joins(:contract).where("\"contracts\".\"name\" LIKE ?", "%#{params[:keyword]}%")
    end

    render json: {
      status: "ok",
      contracts: @contract_subscriptions.map { |contract_subscription| render_contract_subscription contract_subscription.contract, contract_subscription, with_status: true },
      pagination: {
        current_page: @contract_subscriptions.current_page,
        total_count: @contract_subscriptions.size,
        per_page: params[:per_page] || 25
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
        credit_rate: 78,
        week_on_week: 12,
        day_to_day: -11
      }
    }
  end

  def new
    @contracts = Contract.includes(:group).where.not(id: @site.contract_ids).page(params[:page]).per(params[:per_page])
    render json: {
      status: "ok",
      contracts: @contracts.map { |contract| render_contract_subscription contract, nil },
      pagination: {
        current_page: @contracts.current_page,
        total_count: @contracts.size,
        per_page: params[:per_page] || 25
      }
    }
  end

  def create
    @contracts = Contract.where(id: params[:contract_ids])
    @contracts.each do |contract|
      @site.contracts << contract rescue ActiveRecord::RecordInvalid
    end

    render json: {
      status: "ok"
    }
  end

  def destroy
    @site.contracts.delete(params[:id]) rescue ActiveRecord::RecordNotFound

    render json: {
      status: "ok"
    }
  end

  private

    def render_contract_subscription(contract, contract_subscription, with_status: false)
      hash = {
        id: contract.id,
        group_name: contract.group&.name,
        name: contract.name,
        desc: contract.description,
        agreement: contract.agreement,
        builtin: contract.builtin?,
        script: contract.script
      }

      if with_status
        hash[:status] = contract_subscription.status
        hash[:credit_rate] = rand(100)
      end

      hash
    end
end
