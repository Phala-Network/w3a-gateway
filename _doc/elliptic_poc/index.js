const SHA256 = require('crypto-js/sha256');
const EC = require('elliptic').ec;

const msg = "hello";

const privKeyHexString = "c830f8e67ca276138bcd194e5cec7e2987043a42b94796cdbd6c83ca075726a8";
const pubKeyHexString = "03cb388fb2c5c65041b27bd7d3019faf943b1a066126c6f1a2f403e226ed067995";

const ec = new EC('secp256k1');

const privKey = ec.keyFromPrivate(privKeyHexString, "hex");

const msgHash = SHA256(msg).toString();
console.log(msgHash);

let signature = privKey.sign(msgHash);
let derSign = signature.toDER();

// For node
// const hexedDerSign = Buffer.from(derSign).toString("hex");
// For browser
const minUtils = require('minimalistic-crypto-utils');
const hexedDerSign = minUtils.toHex(derSign);
console.log(hexedDerSign);

const pubKey = ec.keyFromPublic(pubKeyHexString, 'hex');

console.log(pubKey.verify(msgHash, hexedDerSign));
