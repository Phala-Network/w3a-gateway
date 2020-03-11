# frozen_string_literal: true

class API::AdminV1::Sites::ContractsController < API::AdminV1::Sites::ApplicationController
  def index
    render json: {
      status: "ok",
      contracts: [
        {
          id: 1,
          name: "DesignLab",
          desc: "在中台产品的研发过程中，会出现不同的设计规范和实现方式...",
          builtin: true
        }, {
          id: 2,
          name: "凤蝶",
          desc: "在中台产品的研发过程中，会出现不同的设计规范和实现方式...",
          builtin: true
        }, {
          id: 3,
          name: "云雀",
          desc: "在中台产品的研发过程中，会出现不同的设计规范和实现方式...",
          builtin: true
        }, {
          id: 4,
          name: "Basement",
          desc: "在中台产品的研发",
          builtin: true
        }
      ]
    }
  end
end
