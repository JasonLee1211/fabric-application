# 區塊鏈應用實作
這是一個在區塊鏈上建置簡單轉帳交易應用程式的教學，使用的區塊鏈架構是由 IBM 開發給 Linux 基金會的 [`Hyperledger Fabric`](https://www.hyperledger.org/projects/fabric)。這裡會詳細紀錄從事前準備到最終成品的過程，提供初學的人手把手的教學，如果對區塊鏈技術的開發有興趣或是想了解關於區塊鏈在證券、法規方面的同學，歡迎參加我們成大區塊鏈研究社！<br>
⚠️  注意：`Hyperledger Composer` 已經被淘汰了，此教學只供基礎知識教學，後續開發建議使用 `Hyperledger Fabric 1.4 版以上` ⚠️
<p align="center">
<a href ="https://www.hyperledger.org/projects/fabric"><img src="https://img.shields.io/badge/hyperledger%20fabric-v1.2-brightgreen.svg"></a>
<a href ="https://hyperledger.github.io/composer/latest/"><img src="https://img.shields.io/badge/hyperledger%20composer-v0.20.9-brightgreen.svg"></a>
<a href ="https://hyperledger.github.io/composer/latest/"><img src="https://img.shields.io/badge/docker-v19.03.5-blue.svg"></a>
<a href ="https://hyperledger.github.io/composer/latest/"><img src="https://img.shields.io/badge/node-v8.11.4-red.svg"></a>
<a href ="https://hyperledger.github.io/composer/latest/"><img src="https://img.shields.io/badge/npm-v5.6.0-red.svg"></a>
<a href ="https://hyperledger.github.io/composer/latest/"><img src="https://img.shields.io/badge/OS-Ubuntu%2018.04-blueviolet.svg"></a>
</p>

## 目錄
<!-- table of contents start -->
- old toc 1
- old toc 2
- old toc 3
<!-- table of contents stop -->

## 執行 
**如果你的環境還沒有安裝好的話，可以參考[安裝步驟](install.md)。**<br>
你會利用一些腳本來控制你的 runtime，如果你是按照教學的步驟安裝的話。當你第一次執行 runtime 時，你會需要跑啟動腳本並產生出一張 PeerAdmin 的 card 文件。

```bash
cd ~/fabric-dev-servers
export FABRIC_VERSION=hlfv12 #有關指定版本的部分請看安裝教學(install.md)
./startFabric.sh
./createPeerAdminCard.sh
```
你可以利用 `~/fabric-dev-servers/stopFabric.sh` 停止 runtime，或 `~/fabric-dev-servers/startFabric.sh` 來重新啟動它。<br>
你可以利用 `composer card list` 來確認所有的 card 文件，理論上輸出應該會像這樣：
```bash
The following Business Network Cards are available:

Connection Profile: hlfv1
┌─────────────────┬───────────┬──────────────────┐
│ Card Name       │ UserId    │ Business Network │
├─────────────────┼───────────┼──────────────────┤
│ admin@test-bank │ admin     │ test-bank        │
├─────────────────┼───────────┼──────────────────┤
│ PeerAdmin@hlfv1 │ PeerAdmin │                  │
└─────────────────┴───────────┴──────────────────┘


Issue composer card list --card <Card Name> to get details a specific card

Command succeeded
```
到這裡時你已經順利將區塊鏈啟動並獲取一張