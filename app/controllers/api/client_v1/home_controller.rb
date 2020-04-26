# frozen_string_literal: true

module API
  module ClientV1
    class HomeController < API::ClientV1::ApplicationController
      def index
        render json: {
          status: "ok"
        }
      end

      def me
        render json: {
          status: "ok",
          client: {
            fingerprint: current_client.fingerprint,
            created_at: current_client.created_at,
          }
        }
      end

      def dashboard
        render json: {
          status: "ok",
          data: {
            total_sites_count: 56,
            total_contracts_count: 24,
            approved_contracts_count: 8,
            earnings: 2223,
            latest_used_your_data_sites: [
              {
                id: 1,
                name: "Phala Official",
                desc: "Phala.Network, Blockchain Confidentiality by Trusted Computing",
                builtin: true,
                last_used_at: 1.days.ago
              }, {
                id: 2,
                name: "pLibra",
                desc: "A privacy preserving Libra bridge",
                builtin: true,
                last_used_at: 1.days.ago
              }, {
                id: 3,
                name: "w3c",
                desc: "W3c.Group’s mission is to familiarize creators with blockchain",
                builtin: true,
                last_used_at: 1.days.ago
              }, {
                id: 4,
                name: "Maskbook",
                desc: "Encrypt your posts & chats on You-Know-Where. Allow only your friends to decrypt",
                builtin: true,
                last_used_at: 1.days.ago
              }
            ],
            latest_devices: [
              {
                location: "Beijing",
                last_seen_at: Time.zone.now,
                device: "iPhone",
                earnings: 2223
              }
            ]
          }
        }
      end

      def stats
        render json: {
          status: "ok",
          data: {
            earnings: {
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
            data_outputs: {
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
  end
end
