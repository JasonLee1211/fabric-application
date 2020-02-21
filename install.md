## 1. 事前準備
Hyperledger Composer 可以被安裝在 [Ubuntu](#ubuntu) 和 [macOS](#macos) 上，挑選適合你的作業系統或是往下滑。

#### Ubuntu
要在 Ubuntu 上安裝 Hyperledger Composer 和 Hyperledger Fabric，建議記憶體至少要有 4GB。<br>
以下是在安裝 Hyperledger Composer 和 Hyperledger Fabric 之前需要先裝好的：

- 作業系統：Ubuntu 14.04 / 16.04 LTS (64位元)
  - 我自己是使用 18.04，沒有任何問題
- Docker Engine：17.03 版以上
- Docker-Compose：1.8 版以上
- Node：8.9.0 版以上、9.0.0 版以下
- npm：5.x 版
- git：2.9x 版以上
- Python：2.7.x
- 文件編輯器，推薦用 VSCode

> 如果 Hyperledger Composer 是裝在 Linux 上的話，請注意一下幾點：
> 
> - 用普通帳戶登入，而非 root
> - 不用 su 到 root
> - 當在安裝事前準備時，用 curl 下載、再用 sudo 解壓縮
> - 用普通使用者執行 `prereqs-ubuntu.sh`。有可能會因為有些指令需要 root 權限而要求輸入密碼。
> - 不要用 root 權限或 su 到 root 去執行 `npm`。
> - 避免全域安裝 node

如果你是跑 Ubuntu，你可以用下列指令一鍵下載所有事前所需要安裝的：
```bash
chmod u+x prereqs-ubuntu.sh #給予權限
```
接著執行腳本，腳本內有些指令會用到 sudo 權限，所以會需要輸入密碼：
```bash
./prereqs-ubuntu.sh
```
安裝成功後，會顯示以下內容，包括安裝的軟件名稱及版本號。（後續版本可能會有變化。）

```bash
----- 安裝完成，以下為個套件的版本：-----
Node:             v8.11.4
npm:              5.6.0
Docker:           Docker version 19.03.5-ce, build 0520e24
Docker Compose:   docker-compose version 1.13.0, build 1719ceb
Python:           Python 2.7.12
請登出再登入使更動生效。
```

#### macOS
蘋果的教學之後再翻譯，我是使用 Ubuntu 所以懶得現在翻 :stuck_out_tongue:
<br><br>
<hr>
<br>

## 2. 安裝開發環境
確定你上面的[事前準備](#1.事前準備)都有先裝好。以下步驟是假設你先前沒有安裝過 Hyperledger 套件（Fabric, Composer...etc），如果有個話請移除掉先前的版本再執行下面步驟，關於如何移除可以跳到下面的[附錄]()。

#### 安裝套件

##### 【第一步】安裝命令工具
這是一些提供給 Composer 開發者的命令列介面工具，最重要的是 `composer-cli`，它包含了所有必要的指令，所以我們會先安裝它。接下來我們會安裝 `generator-hyperledger-composer`、 `composer-rest-server`、`Yeoman` 和 `generator-hyperledger-composer`。後面三個不是開發的核心元件，但會對你很有幫助如果你是按照這個教學或是要開發跟你的 Business Network（商業網路）互動的應用程式。<br><br>
注意，請**不要**使用 `su` 或 `sudo` 執行 npm 命令。

1. 安裝 Composer 命令列工具：<br><br>
   ```bash
   npm install -g composer-cli@0.19
   ```
2. 安裝 Composer REST Server（將你的商業網路以 RESTful API expose 出來）：<br><br>
   ```bash
   npm install -g composer-cli@0.19
   ```
3. 生成應用程式資產的小工具：<br><br>
   ```bash
   npm install -g generator-hyperledger-composer@0.19
   ```
   它包含了一組 Yeoman generator，可以在 Yeoman 中執行，根據模板生成我們將要部署的區塊鏈網路文件。
4. `Yeoman` 是生成應用程式的工具（利用 `generator-hyperledger-composer`）：<br><br>
   ```bash
   npm install -g yo
   ```
<br>

##### 【第二步】安裝 Playground
如果你在網路上已經嘗試過 [Composer Online](https://composer-playground.mybluemix.net/login)，你就有看過 `Playground` 這個瀏覽程式。你其實也可以在本地端安裝這個瀏覽程式來查看和展示你的商業網路。

1. 用來簡單編輯和測試商業網路的瀏覽程式：<br><br>
   ```bash
   npm install -g composer-playground@0.19
   ```
<br>

##### 【第三步】設定你的 IDE
雖然說所有的文件編輯器都可以，推薦使用`VSCode`，因為它有提供一個 Composer 的插件。

1. 從這個網址下載 `VSCode`：https://code.visualstudio.com/download
<br>

2. 打開 VSCode、點擊 Extensions、在市集裡搜尋並安裝 `Hyperledger Composer`
<br>

##### 【第四步】安裝 Hyperledger Fabric
這個步驟提供你一個本地的 Hyperledger Fabric runtime，使你可以部署你的商業網路到上面去。

1. 新建一個Fabric Tools 目錄：<br><br>
   ```bash
   $ cd ~
   $ mkdir fabric-tools
   $ cd fabric-tools/
   ```
   fabric-tools 目錄是我們以後的工作目錄，讀者可以按需要改成自己期望的目錄名。<br><br>
2. 下載Fabric Dev Server：<br><br>
   ```bash
   curl -O https://raw.githubusercontent.com/hyperledger/composer-tools/master/packages/fabric-dev-servers/fabric-dev-servers.tar.gz
   ```
   目前，fabric-dev-servers.tar.gz 包含了Fabric1.0、1.1 和 1.2 三個版本的安裝腳本，及用於初始化 Fabric 的相關配置。解壓後檔案位於 `~/fabric-tools/fabric-scripts`。<br><br>
3. 解壓縮 Fabric Dev Server：<br><br>
   ```bash
   tar -xvf fabric-dev-servers.tar.gz
   ```
   也有 `zip` 檔提供下載，將上面的 `.tar.gz` 改成 `.zip` 並在解壓縮時從 `tar -xvf` 換成 `unzip`。
<br>

4. 使用剛取得的腳本來下載本地的 Hyperledger Fabric runtime：
   ```bash
   cd ~/fabric-dev-servers
   ```
   <details>
   <summary>指定版本請點我</summary>

   如果不指定版本則是預設 1.2 版，如果要 1.0 版則設成 `hlfv1`、如果要 1.1 版則設成 `hlfv11`、如果要 1.2 版則設成 `hlfv12`
   </details>

   ```bash
   export FABRIC_VERSION=hlfv11
   ```<br>

5. 下載 Fabric 映像檔：<br><br>
   ```bash
   ./downloadFabric.sh
   ```
<br>

如果你在上面沒有指定版本（FABRIC_VERSION）的話，默認情況下這個腳本會執行 `fabric-scripts/hlfv12/downloadFabric.sh`，hlfv12 表示Hyperledger Fabric v1.2。<br>
這個過程會下載 5 個docker image 文件，共約3.6G，視網絡情況，可能需要比較長的時間。下載完成後可以通過 `docker images` 命令查看。<br>

```bash
$ docker images
REPOSITORY                   TAG             IMAGE ID          CREATED             SIZE
hyperledger/fabric-ca        x86_64-1.1.0    72617b4fa9b4      2 weeks ago         299MB
hyperledger/fabric-orderer   x86_64-1.1.0    ce0c810df36a      2 weeks ago         180MB
hyperledger/fabric-peer      x86_64-1.1.0    b023f9be0771      2 weeks ago         187MB
hyperledger/fabric-ccenv     x86_64-1.1.0    c8b4909d8d46      2 weeks ago         1.39GB
hyperledger/fabric-couchdb   x86_64-0.4.6    7e73c828fc5b      6 weeks ago         1.56GB
```
<br><br>
到這裡，我們就非常迅速、方便的完成了 Fabric 的下載，及部署環境的安裝，得益於 Docker Container 技術，我們並不需要做複雜的配置。<br>
點下面回到 README 準備開始部署應用了。

## [恭喜安裝完成！:tada:](./README.md#執行)
<br><br>

##### 【附錄】刪除先前版本
如果這不是你第一次安裝、使用 Hyperledger 的套件，而是想要刪除先期版本使用較新版本的話，你可能會需要將所有 Docker 的容器都移除。
```bash
docker kill $(docker ps -q)
docker rm $(docker ps -aq)
docker rmi $(docker images dev-* -q)
```