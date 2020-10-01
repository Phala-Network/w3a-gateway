# frozen_string_literal: true
require "aead"
require 'base64'

class CollectorsController < ApplicationController
  def page_view
    key_hex = "290c3c5d812a4ba7ce33adf09598a462692a615beb6c80fdafb3f9e3bbef8bc6"
    key = key_hex.unpack('a2'*32).map{|x| x.hex}.pack('c'*32)

    sid = params[:sid]
    # Check SID exists
    # unless Site.exists?(sid: sid)
    #   head :bad_request
    # end

    cid = params[:cid]
    if cid.blank?
      #head :bad_request
      return
    end

    host = params[:h]
    if host.blank?
      head :bad_request
    end

    path = params[:p]
    if path.blank?
      head :bad_request
    end

    uid = params[:uid]

    if true
      o_cipher = OpenSSL::Cipher.new('aes-256-gcm')
      
      mode = AEAD::Cipher.new('AES-256-GCM')
      cipher = mode.new(key)

      host = encrypt(o_cipher, cipher, host)
      path = encrypt(o_cipher, cipher, path)
      ip = encrypt(o_cipher, cipher, request.ip)
      user_agent = encrypt(o_cipher, cipher, request.user_agent)
      referrer = encrypt(o_cipher, cipher, params[:r])
    else
      ip = request.ip
      user_agent = request.user_agent
      referrer = params[:r]
    end

    pv = PageView.new id: SecureRandom.uuid,
                      sid: sid,
                      cid: cid,
                      uid: uid,
                      host: host,
                      path: path,
                      ip: ip,
                      ua: user_agent,
                      referrer: referrer
    pv.send :create_or_update # Hack to avoid transaction

    head :no_content
  end

  def encrypt(o_cipher, cipher, what)
    iv = o_cipher.random_iv
    aead = cipher.encrypt(iv, '', what);
    Base64.encode64(iv).chomp + '|' + Base64.encode64(aead).gsub(/\n/,"")
  end

end
