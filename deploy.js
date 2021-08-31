import BigNum from 'bn.js'
import { readFileSync } from 'fs'
import fetch from 'node-fetch'
import {
  contractPrincipalCV,
  stringAsciiCV,
  uintCV,

  broadcastTransaction,
  makeContractCall,
  makeContractDeploy,

  PostConditionMode,
} from '@stacks/transactions'
import { StacksTestnet, StacksMainnet } from '@stacks/network'

import {
  getNonce,
  wait,
} from './src/tx-utils.js'

import {
  MODE,
  STACKS_API_URL,

  CONTRACT_NAME_SIP010_TRAIT,
  CONTRACT_NAME_LIQUIDITY_TOKEN_TRAIT,
  CONTRACT_NAME_RESTRICTED_TOKEN_TRAIT,
  CONTRACT_NAME_STACKSWAP_DAO_TOKEN_TRAIT ,
  CONTRACT_NAME_INITIALIZABLE_TOKEN_TRAIT ,
  
   CONTRACT_NAME_STACKSWAP_SWAP_V1,
   CONTRACT_NAME_STACKSWAP_SWAP_FEE_V1 ,
   CONTRACT_NAME_STACKSWAP_ONE_STEP_MINT_V1 ,
   CONTRACT_NAME_STACKSWAP_ONE_STEP_MINT_FEE_V1 ,

   CONTRACT_NAME_STACKSWAP_DAO ,
   CONTRACT_NAME_STACKSWAP_GOVERNANCE_V1 ,
   CONTRACT_NAME_STACKSWAP_FARMING ,
   CONTRACT_NAME_STACKSWAP_FARMING_REWARD ,
  
   CONTRACT_NAME_VSTSW,
   CONTRACT_NAME_STSW ,
   CONTRACT_NAME_WSTX ,
   CONTRACT_NAME_PLAID,
   CONTRACT_NAME_PLAID_WSTX ,
   CONTRACT_NAME_TOKENSOFT ,
   CONTRACT_NAME_TOKENSOFT_V2,
   CONTRACT_NAME_TOKENSOFT_WSTX ,
   CONTRACT_NAME_POXLSOFT_V1,
   CONTRACT_NAME_LIQUIDITY_TOKENSOFT_V1 ,
  
  STSW_SK,
  STSW_PK,
  STSW_STX,

} from './src/config.js'

console.log("deploying STSW with", STSW_STX, "on", MODE)

const network = MODE === 'mainnet' ? new StacksMainnet() : new StacksTestnet()
network.coreApiUrl = STACKS_API_URL
console.log("using", STACKS_API_URL)

async function deployContract(contract_name, contract_file) {
  const body = readFileSync(contract_file).toString()

  const codeBody = body
    .replaceAll('ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.sip-010-trait', `${STSW_STX}.${CONTRACT_NAME_SIP010_TRAIT}`)  // minting
    .replaceAll('ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.restricted-token-trait', `${STSW_STX}.${CONTRACT_NAME_RESTRICTED_TOKEN_TRAIT}`)  // minting
    .replaceAll('ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.initializable-token-trait', `${STSW_STX}.${CONTRACT_NAME_INITIALIZABLE_TOKEN_TRAIT}`)  // minting
    .replaceAll('ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.stackswap-swap-v1', `${STSW_STX}.${CONTRACT_NAME_STACKSWAP_SWAP_V1}`)  // minting
    .replaceAll('ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.stackswap-swap-fee-v1', `${STSW_STX}.${CONTRACT_NAME_STACKSWAP_SWAP_FEE_V1}`)  // minting
    .replaceAll('ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.stackswap-dao-token-trait', `${STSW_STX}.${CONTRACT_NAME_STACKSWAP_DAO_TOKEN_TRAIT}`)  // minting
    .replaceAll('ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.stackswap-dao', `${STSW_STX}.${CONTRACT_NAME_STACKSWAP_DAO}`)  // minting
    .replaceAll('ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.liquidity-token-trait', `${STSW_STX}.${CONTRACT_NAME_LIQUIDITY_TOKEN_TRAIT}`)  // minting
    .replaceAll('ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.stackswap-governance-v1', `${STSW_STX}.${CONTRACT_NAME_STACKSWAP_GOVERNANCE_V1}`)  // minting
    .replaceAll('ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.stackswap-one-step-mint-fee-v1', `${STSW_STX}.${CONTRACT_NAME_STACKSWAP_ONE_STEP_MINT_FEE_V1}`)  // minting
    .replaceAll('ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.stackswap-one-step-mint-v1', `${STSW_STX}.${CONTRACT_NAME_STACKSWAP_ONE_STEP_MINT_V1}`)  // minting
    .replaceAll('ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.wstx-token', `${STSW_STX}.${CONTRACT_NAME_WSTX}`)  // minting
    .replaceAll('ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.stsw-token', `${STSW_STX}.${CONTRACT_NAME_STSW}`)  // minting
    .replaceAll('ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE.vstsw-token', `${STSW_STX}.${CONTRACT_NAME_VSTSW}`)  // minting
    .replaceAll('ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE', STSW_STX)  // minting
    .replaceAll('ST000000000000000000002AMW42H', STSW_STX)
    .replaceAll('ST20ATRN26N9P05V2F1RHFRV24X8C8M3W54E427B2', STSW_STX)

  console.log("deploy", contract_name)
  console.log(codeBody)

  const transaction = await makeContractDeploy({
    contractName: contract_name,
    codeBody,
    senderKey: STSW_PK,
    network,
  })

  const result = await broadcastTransaction(transaction, network)
  if (result.error) {
    if (result.reason === 'ContractAlreadyExists') {
      console.log(`${contract_name} already deployed`)
      return
    } else {
      throw new Error(
        `failed to deploy ${contract_name}: ${JSON.stringify(result)}`
      )
    }
  }
  const processed = await processing(result, 0)
  if (!processed) {
    throw new Error(`failed to deploy ${contract_name}: transaction not found`)
  }
  return result
}


async function getContractInfo(contract_name) {
  var result = await fetch(`${STACKS_API_URL}/extended/v1/contract/${STSW_STX}.${contract_name}`)
  // console.log("result", result)
  var value = await result.json()
  // console.log("value", value)
  if (value.error) {
    return null
  }
  return value.tx_id
}

async function processing(tx, count) {
  console.log("processing", tx, count)
  var result = await fetch(`${STACKS_API_URL}/extended/v1/tx/${tx}`)
  var value = await result.json()
  if (value.tx_status === "success") {
    console.log(`transaction ${tx} processed`)
    // console.log(value)
    return true
  }
  if (count > 10000) {
    console.log("failed after 10 attempts", value)
    return false
  }

  await wait(30000)
  return processing(tx, count + 1)
}

if (!await getContractInfo(CONTRACT_NAME_SIP010_TRAIT)) {
  await deployContract(CONTRACT_NAME_SIP010_TRAIT, './clarinet/contracts/trait-sip-010.clar')
}
if (!await getContractInfo(CONTRACT_NAME_LIQUIDITY_TOKEN_TRAIT)) {
  await deployContract(CONTRACT_NAME_LIQUIDITY_TOKEN_TRAIT, './clarinet/contracts/trait-liquidity-token.clar')
}
if (!await getContractInfo(CONTRACT_NAME_RESTRICTED_TOKEN_TRAIT)) {
  await deployContract(CONTRACT_NAME_RESTRICTED_TOKEN_TRAIT, './clarinet/contracts/trait-restricted-token.clar')
}
if (!await getContractInfo(CONTRACT_NAME_STACKSWAP_DAO_TOKEN_TRAIT)) {
  await deployContract(CONTRACT_NAME_STACKSWAP_DAO_TOKEN_TRAIT, './clarinet/contracts/stackswap-dao-token-trait.clar')
}
if (!await getContractInfo(CONTRACT_NAME_INITIALIZABLE_TOKEN_TRAIT)) {
  await deployContract(CONTRACT_NAME_INITIALIZABLE_TOKEN_TRAIT, './clarinet/contracts/trait-initializable-token.clar')
}

if (!await getContractInfo(CONTRACT_NAME_STACKSWAP_SWAP_FEE_V1)) {
  await deployContract(CONTRACT_NAME_STACKSWAP_SWAP_FEE_V1, './clarinet/contracts/stackswap-swap-fee-v1.clar')
}

if (!await getContractInfo(CONTRACT_NAME_STACKSWAP_SWAP_V1)) {
  await deployContract(CONTRACT_NAME_STACKSWAP_SWAP_V1, './clarinet/contracts/stackswap-swap-v1.clar')
}

if (!await getContractInfo(CONTRACT_NAME_STACKSWAP_DAO)) {
  await deployContract(CONTRACT_NAME_STACKSWAP_DAO, './clarinet/contracts/stackswap-dao.clar')
}

if (!await getContractInfo(CONTRACT_NAME_STACKSWAP_ONE_STEP_MINT_FEE_V1 ,
  )) {
  await deployContract(CONTRACT_NAME_STACKSWAP_ONE_STEP_MINT_FEE_V1 , './clarinet/contracts/stackswap-one-step-mint-fee-v1.clar')
}

if (!await getContractInfo(CONTRACT_NAME_WSTX)) {
  await deployContract(CONTRACT_NAME_WSTX, './clarinet/contracts/token-wstx.clar')
}

if (!await getContractInfo(CONTRACT_NAME_STACKSWAP_ONE_STEP_MINT_V1 ,
  )) {
  await deployContract(CONTRACT_NAME_STACKSWAP_ONE_STEP_MINT_V1 , './clarinet/contracts/stackswap-one-step-mint-v1.clar')
}

if (!await getContractInfo(CONTRACT_NAME_STSW)) {
  await deployContract(CONTRACT_NAME_STSW, './clarinet/contracts/token-stsw.clar')
}

if (!await getContractInfo(CONTRACT_NAME_STACKSWAP_GOVERNANCE_V1)) {
  await deployContract(CONTRACT_NAME_STACKSWAP_GOVERNANCE_V1, './clarinet/contracts/stackswap-governance-v1.clar')
}
// if (!await getContractInfo(CONTRACT_NAME_STACKSWAP_FARMING)) {
//   await deployContract(CONTRACT_NAME_STACKSWAP_FARMING, './clarinet/contracts/stackswap-farming.clar')
// }
// if (!await getContractInfo(CONTRACT_NAME_STACKSWAP_FARMING_REWARD)) {
//   await deployContract(CONTRACT_NAME_STACKSWAP_FARMING_REWARD, './clarinet/contracts/stackswap-farming-reward.clar')
// }

// if (!await getContractInfo(CONTRACT_NAME_VSTSW)) {
//   await deployContract(CONTRACT_NAME_VSTSW, './clarinet/contracts/token-vstsw.clar')
// }

if (!await getContractInfo(CONTRACT_NAME_PLAID)) {
  await deployContract(CONTRACT_NAME_PLAID, './clarinet/contracts/token-plaid.clar')
}
if (!await getContractInfo(CONTRACT_NAME_PLAID_WSTX)) {
  await deployContract(CONTRACT_NAME_PLAID_WSTX, './clarinet/contracts/liquidity-token-plaid-wstx.clar')
}
if (!await getContractInfo(CONTRACT_NAME_TOKENSOFT)) {
  await deployContract(CONTRACT_NAME_TOKENSOFT, './clarinet/contracts/token-tokensoft.clar')
}
if (!await getContractInfo(CONTRACT_NAME_TOKENSOFT_V2)) {
  await deployContract(CONTRACT_NAME_TOKENSOFT_V2, './clarinet/contracts/token-tokensoft-v2.clar')
}
if (!await getContractInfo(CONTRACT_NAME_TOKENSOFT_WSTX)) {
  await deployContract(CONTRACT_NAME_TOKENSOFT_WSTX, './clarinet/contracts/liquidity-token-tokensoft-wstx.clar')
}
if (!await getContractInfo(CONTRACT_NAME_POXLSOFT_V1)) {
  await deployContract(CONTRACT_NAME_POXLSOFT_V1, './clarinet/contracts/token-poxlsoft-v1.clar')
}
if (!await getContractInfo(CONTRACT_NAME_LIQUIDITY_TOKENSOFT_V1)) {
  await deployContract(CONTRACT_NAME_LIQUIDITY_TOKENSOFT_V1, './clarinet/contracts/liquidity-tokensoft-v1.clar')
}


console.log("done")
