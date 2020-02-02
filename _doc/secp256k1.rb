# https://github.com/cryptape/ruby-bitcoin-secp256k1
require "secp256k1"

MSG = "user@fake.dev"

# 服务器预先生成密钥对 (pk,sk)
sk = Secp256k1::PrivateKey.new
pk = sk.pubkey

# 导出私钥字符串
sk_str = sk.send(:serialize)
puts "SK: #{sk_str}"

# 导出公钥字符串
pk_str = pk.serialize(compressed: true).unpack1("H*")
puts "PK: #{pk_str}"

# 用于接下来测试签名的信息
msg = MSG

# 服务器使用私钥 sk 对信息签名得到 sig
sig_raw = sk.ecdsa_sign msg
sig = sk.ecdsa_serialize sig_raw
_had_to_normalize, normalized_sig_raw = sk.ecdsa_signature_normalize(sig_raw)
normalized_sig = sk.ecdsa_serialize(normalized_sig_raw)

puts "Sig: #{sig.unpack1("H*")}"
puts "Normalized sig: #{normalized_sig.unpack1("H*")}"

# 验证 sig
if pk.ecdsa_verify(msg, normalized_sig_raw)
  puts "Verified"
else
  puts "Invalid"
end

PREMADE_SK = "c830f8e67ca276138bcd194e5cec7e2987043a42b94796cdbd6c83ca075726a8"
PREMADE_PK = "03cb388fb2c5c65041b27bd7d3019faf943b1a066126c6f1a2f403e226ed067995"

# 从私钥字符串导入私钥
sk = Secp256k1::PrivateKey.new(privkey: PREMADE_SK, raw: false)

# 从公钥字符串导入公钥
pk = Secp256k1::PublicKey.new(pubkey: [PREMADE_PK].pack("H*"), raw: true)

# 用于接下来测试签名的信息
msg = MSG

# 服务器使用私钥 sk 对信息签名得到 sig
sig_raw = sk.ecdsa_sign msg
sig = sk.ecdsa_serialize sig_raw
_had_to_normalize, normalized_sig_raw = sk.ecdsa_signature_normalize(sig_raw)
normalized_sig = sk.ecdsa_serialize(normalized_sig_raw)

puts "Sig: #{sig.unpack1("H*")}"
puts "Normalized sig: #{normalized_sig.unpack1("H*")}"

# 验证 sig
if pk.ecdsa_verify(msg, normalized_sig_raw)
  puts "Verified"
else
  puts "Invalid"
end

PREMADE_SIG = "30440220553e6b2c3f978a50d129804a5ef0c0b4a13318f3ad07426e8c109796dba4ff7a02203f400feb15d5cbc3ecd833e7dfda7048ab4778de48598275518c55e621d820ee"

# 从公钥字符串导入公钥
pk = Secp256k1::PublicKey.new(pubkey: [PREMADE_PK].pack("H*"), raw: true)

sig = [PREMADE_SIG].pack("H*")
sig_raw = pk.ecdsa_deserialize(sig)
_had_to_normalize, normalized_sig_raw = pk.ecdsa_signature_normalize(sig_raw)

# 验证 sig
if pk.ecdsa_verify(msg, normalized_sig_raw)
  puts "Verified"
else
  puts "Invalid"
end
