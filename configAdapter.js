const { ETH_CONFIG } = require("./config/eth-config");
const { BSC_CONFIG } = require("./config/bsc-config");
const { HECO_CONFIG } = require("./config/heco-config");
const { KOVAN_CONFIG } = require("./config/kovan-config");
const { MBTEST_CONFIG } = require("./config/mbtest-config");
const { MBTESTNET_CONFIG } = require("./config/mbtestnet-config");
const { OKTEST_CONFIG } = require("./config/oktest-config");
const { ARBTEST_CONFIG } = require("./config/arbtest-config");
const { MATIC_CONFIG } = require("./config/matic-config");
const { RINKEBY_CONFIG } = require("./config/rinkeby-config");

exports.GetConfig = function (network, accounts) {
    var CONFIG = {}
    switch (network) {
        case "kovan":
            CONFIG = KOVAN_CONFIG
            CONFIG.multiSigAddress = accounts[0]
            CONFIG.defaultMaintainer = accounts[0]
            break;
        case "live":
            CONFIG = ETH_CONFIG
            break;
        case "bsclive":
            CONFIG = BSC_CONFIG
            break;
        case "heco":
            CONFIG = HECO_CONFIG
            break;
        case "matic":
            CONFIG = MATIC_CONFIG
            break;
        //testnet
        case "kovan":
            CONFIG = KOVAN_CONFIG
            CONFIG.multiSigAddress = accounts[0]
            CONFIG.defaultMaintainer = accounts[0]
            break;
        case "rinkeby":
            CONFIG = RINKEBY_CONFIG
            CONFIG.multiSigAddress = accounts[0]
            CONFIG.defaultMaintainer = accounts[0]
            break;
        case "mbtestnet":
            CONFIG = MBTEST_CONFIG
            CONFIG.multiSigAddress = accounts[0]
            CONFIG.defaultMaintainer = accounts[0]
            break;
        case "mbtestnet_offical":
            CONFIG = MBTESTNET_CONFIG
            CONFIG.multiSigAddress = accounts[0]
            CONFIG.defaultMaintainer = accounts[0]
            break;
        case "oktest":
            CONFIG = OKTEST_CONFIG
            CONFIG.multiSigAddress = accounts[0]
            CONFIG.defaultMaintainer = accounts[0]
            break;
        case "arbtest":
            CONFIG = ARBTEST_CONFIG
            CONFIG.multiSigAddress = accounts[0]
            CONFIG.defaultMaintainer = accounts[0]
            break;
    }
    return CONFIG
}