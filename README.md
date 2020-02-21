# 區塊鏈應用實作
這是一個在區塊鏈上建置簡單轉帳交易應用程式的教學，使用的區塊鏈架構是由 IBM 開發給 Linux 基金會的 [`Hyperledger Fabric`](https://www.hyperledger.org/projects/fabric)。這裡會詳細紀錄從事前準備到最終成品的過程，提供初學的人手把手的教學，如果對區塊鏈技術的開發有興趣或是想了解關於區塊鏈在證券、法規方面的同學，歡迎參加我們成大區塊鏈研究社！<br>
<p align="center">⚠️  注意： ⚠️</p>

`Hyperledger Composer` 已經被淘汰了，此教學只供基礎知識教學，後續開發建議使用 `Hyperledger Fabric 1.4 版以上` 
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

1. 你會利用一些腳本來控制你的 runtime，如果你是按照教學的步驟安裝的話。當你第一次執行 runtime 時，你會需要跑啟動腳本並產生出一張 PeerAdmin 的卡片。<br>

   ```bash
   cd ~/fabric-dev-servers
   export FABRIC_VERSION=hlfv12 #有關指定版本的部分請看安裝教學(install.md)
   ./startFabric.sh #啟動Fabric
   ```
   - 你可以利用 `./stopFabric.sh` 停止 runtime，或 `./startFabric.sh` 來重新啟動它。
   - `startFabric.sh` 最終會執行 ~/fabric-tools/fabric-scripts/hlfv12/startFabric.sh，裡面有如下一行內容：

      ```bash
      ARCH=$ARCH docker-compose -f "${DOCKER_FILE}" up -d
      ```
   - 打開 `~/fabric-tools/fabric-scripts/hlfv11/composer/docker-compose.yml` 我們可以看到有如下四個Docker 應用的配置：
      * `ca.org1.example.com` (CA Node)
      * `orderer.example.com` (Orderer Node)
      * `peer0.org1.example.com` (Peer Node)
      * `couchdb` (Database)

      它們啟動成功後就代表 Fabric 區塊鏈網路的核心部分已經處於運行的狀態了。<br><br>
   - 在 `startFabric.sh` 中，還有以下內容：<br>
   
      ```bash
      docker exec peer0.org1.example.com peer channel create ……
      docker exec -e …… peer0.org1.example.com peer channel join ……
      ```

      它們的作用是建立一個通道（Channel）並將剛啟動的節點 `peer0.org1.example.com` 加入到這個通道<br>
      通道（Channel）是 Fabric 中的重要概念與設計，它是網路成員間通訊的私有的子網路；網路中會有多個通道同時存在；每個交易都在認證、授權後在某個通道裡執行；所有數據、交易、成員、通道信息都只對此通道的授權成員可見。<br><br><br>

2. 生成並導入PeerAdmin Card：<br>
   
   ```bash
   ./createPeerAdminCard.sh #生成卡片
   ```
   這個腳本會生成一個卡片，它包含了 Fabric 網路的資訊以及管理員 PeerAdmin 與之連接所必須的資訊；即**管理員的身份證明**；生成後這個卡片會被導入到 Composer，你可以在 `~/ .composer/cards/PeerAdmin@hlfv1` 目錄下找到被導入的PeerAdmin 卡片內容。之後，Composer 會利用這個卡片建立起到 Fabric 網路的連接。<br><br>
   - 你可以用 `composer card list` 來確認所有的卡片，理論上輸出應該會像這樣：<br><br>

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
<br>
<p align="center">🎉<b>到這裡時你已經順利將區塊鏈啟動並獲取一張能在鏈上部署應用程式的通行證了！🎉</b></p><br><br>

## 部署第一個 Fabric 區塊鏈商業網路
Fabric runtime 已經被成功安裝、啟動了，現在我們要部署第一個 Fabric 區塊鏈商業網路。
### 準備商業網路
為使學習過程更容易，我們直接利用 Yeoman 及已經下載的Generator 生成區塊鏈商業網路框架。<br>

在以後的章節中，我們會介紹如何按步驟手工完成定義、部署過程。<br>

1. 生成商業網路定義（Business Network Definition – BND）

   ```bash
   yo hyperledger-composer:businessnetwork
   ```

   - 參數 `businessnetwork` 來自於之前安裝的generator-hyperledger-composer，表示了一組對應的模板文件。可以在 `~/.nvm/versions/node/v8.11.1/lib/node_modules/generator-hyperledger-composer/generators/businessnetwork/templates/` 下找到即將生成的內容的模板。<br>
   它會提示輸入相關資料，可以按照下面來填入：
   <br>
   <table><tr>
   <td><img src="https://cdn-media-1.freecodecamp.org/images/CF0D-XmKKlo4bmAyumr3l91W90T1o1SIHTko"></td>
   </tr></table>
   <br>

   執行成功後，在當前 `~/fabric-tools/` 路徑下，會新增了一個資料夾叫 `test-bank`，裡面有 `index.js`、`package.json` 等檔案，以及 `lib`、`models` 兩個資料夾，這就是將要部署的區塊鏈商業網路定義。<br><br><br>
2. 生成商業網路壓縮檔 .bna (**b**usiness **n**etwork **a**rchive)
   1. 進入 test-bank 資料夾<br>
      ```bash
      cd ~/fabric-tools/tutorial-network
      ```
      後續的操作基本都在此目錄下完成。<br><br>
   2. 生成商業網路壓縮檔 .bna<br>
   
      ```bash
      composer archive create -t dir -n .
      ```

      執行成功後，在當前資料夾下會產生一個新導案 test-bank@0.0.1.bna，即是 test-bank 整個資料夾的壓縮檔。解壓縮後會發現含有主要的資料夾及檔案：`lib/`、`models/`、`package.json`、`permissions.acl`。我們會在以後詳細解釋、操作這些檔案。<br><br>

### 部署及啟動商業網路
這是安裝部署的最後一部分內容了。

1. 部署商業網路 test-bank<br>

   ```bash
   composer network install --card PeerAdmin@hlfv1 --archiveFile test-bank@0.0.1.bna
   ```
   <table><tr>
   <td><img src="https://cdn-media-1.freecodecamp.org/images/B3DUtkud4azEoCEoiIKV4PupBCxIPY4XOjLn"></td>
   </tr></table>

   `composer network install` 指令會部署指定的 .bna 檔案到 Fabric 網絡。.bna 檔包括了這個商業網路的 Assets 模型、交易事務邏輯、訪問控制規則等定義，但它並不能直接在 Fabric 上運行。.bna 文件是由 Composer 生成的，它是用 Composer 提供支持的一系列建模語言、規範定義的業務網絡定義，我們必須將它先安裝在 Fabric Peer 節點上。然後才可以在這個節點上啟動運行這個業務網絡。<br><br>

   - 參數 `-c (--card)` 應指定為在上一步驟中生成PeerAdmin 卡片。<br>

   - 參數 `-a (--archiveFile)` 應指定為將要部署的業務網絡文件包。<br><br>

2. 啟動業務網絡<br>

   ```bash
   composer network start --networkName test-bank \
                          --networkVersion 0.0.1 \
                          --networkAdmin admin \
                          --networkAdminEnrollSecret adminpw \
                          --card PeerAdmin@hlfv1 \
                          --file networkadmin.card
   ```
   <table><tr>
   <td><img src="https://cdn-media-1.freecodecamp.org/images/LSkNP7nxN4tUcY3Dy01M22S6CivgkYLUJL4T"></td>
   </tr></table>

   <br>`composer network start` 用指定的卡片啟動這個網路；同時會生成一個當前商業網路的管理員卡片，即此範例中的 `networkadmin.card`。

   這個檔案是 zip 格式的壓縮檔，解壓縮後，可以發現包含兩個檔案：`connection.json`、`metadata.json`。其中，`metadata.json` 內容如下：<br><br>

   ```bash
   {
      "version":1,
      "userName":"admin",
      "businessNetwork":"tutorial-network",
      "enrollmentSecret":"adminpw"
   }
   ```

   `admin`、`tutorial-network` 正是我們此前的定義的管理員用戶名，及商業網路名。我們在以後可以通過類似 `-c admin@tutorial-network` 使用這個管理員身份。<br><br>
<br>

3. 導入tutorial-network 管理員Card<br><br>

   ```bash
   composer card import --file networkadmin.card
   ```
   <table><tr>
   <td><img src="https://cdn-media-1.freecodecamp.org/images/keh-Fx-k7zKaN11RaG6LPsedpFTmpfyAF6cC"></td>
   </tr></table>
<br>

4. 確認tutorial-network 安裝成功<br>

   ```bash
   composer network ping --card admin@tutorial-network
   ```
   <table><tr>
   <td><img src="https://cdn-media-1.freecodecamp.org/images/VnU45AuKe6eCuQ82kr9AqTIJqNaeDMZJ-OKM"></td>
   </tr></table>
   如果部署成功，會顯示類似如下內容：

   ```bash
   The connection to the network was successfully tested: tutorial-network
   Business network version: 0.0.1
   Composer runtime version: 0.19.1
   participant: org.hyperledger.composer.system.NetworkAdmin#admin
   identity: org.hyperledger.composer.system.Identity#...
   Command succeeded
   ```
<br>

5. 啟動 REST Server<br>

   ```bash 
   composer-rest-server
   ```
   並在之後提示的選項中輸入內容如下：<br>

   ```bash
   Card Name: admin@test-bank
   Never use namespace
   Enable authentication (default): No
   Enable event publication over WebSockets (default): Yes
   Enable TSL (default): No
   ```
   <table><tr>
   <td><img src="https://cdn-media-1.freecodecamp.org/images/0hTic2-uVL1dhxlNfTYlfo9lBdW3lbDr4HEJ"></td>
   </tr></table>
   
   `composer-rest-server` 會根據部署的商業網路生成一系列REST API，以方便用戶通過瀏覽器或其他類似 curl 的應用程式訪問這個區塊鏈商業網路。<br><br>
   以瀏覽器開啟這個連結：<ins>http://localhost:3000/explorer</ins><br><br>
   你就會看到你美麗的區塊鏈 API~<br>
   
   <table><tr>
   <td><img src="https://cdn-media-1.freecodecamp.org/images/rUfk5ZJuROhQ5ipcqDPXAQ-5LLtIRxYQvyQk"></td>
   </tr></table>

<p align="center">

## 部署成功 :tada:
</p>

## 訪問區塊鏈網路
現在我們可以開始訪問部署成功的第一個 Fabric 區塊鏈商業網路。<br>
本文主要介紹通過瀏覽器和 curl 命令訪問 REST Service。

1. 通過瀏覽器訪問REST Service
   在瀏覽器中輸入：<ins>http://fabric11dev1:3000/explorer</ins>。
   `fabric11dev1` 是當前部署運行 Composer REST Server的機器名。如果從本機訪問，可以使用 localhost，或者直接使用 IP 地址 (127.0.0.1) 訪問。後文不再對此特別說明。
## Reference
官方說明：https://hyperledger.github.io/composer/latest/introduction/introduction.html<br>
Hyperledger Composer Github：https://hyperledger.github.io/composer/latest/introduction/introduction.html<br>
