# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.find_or_create_by! email: "user@fake.local",
                               public_key: "03cb388fb2c5c65041b27bd7d3019faf943b1a066126c6f1a2f403e226ed067995" do |r|
  r.activated_at = Time.zone.now
end

user.sites.find_or_create_by! sid: "test",
                              domain: "fake.local",
                              verified: true

g1 = ContractGroup.find_or_create_by! name: "用户行为"
g2 = ContractGroup.find_or_create_by! name: "概况统计"

g1.contracts.find_or_create_by! name: "实时用户数",
                                description: "现在正在使用产品的用户数",
                                builtin: true
g1.contracts.find_or_create_by! name: "产品浏览量",
                                description: "访问产品的浏览行为次数",
                                builtin: true
g1.contracts.find_or_create_by! name: "访问用户量",
                                description: "访问产品的用户数量",
                                builtin: true
g2.contracts.find_or_create_by! name: "平均用户会话时长",
                                description: "现在正在使用产品的用户数",
                                builtin: true
g2.contracts.find_or_create_by! name: "用户留存状况",
                                description: "历史用户的回访次数",
                                builtin: true
