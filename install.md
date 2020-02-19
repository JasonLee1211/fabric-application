## 事前準備
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
curl -O https://hyperledger.github.io/composer/v0.19/prereqs-ubuntu.sh #下載腳本
chmod u+x prereqs-ubuntu.sh #給予權限
```
接著執行腳本，腳本內有些指令會用到 sudo 權限，所以會需要輸入密碼：
```bash
./prereqs-ubuntu.sh
```

#### macOS
蘋果的教學之後再翻譯，我是使用 Ubuntu 所以懶得現在翻 :stuck_out_tongue:
<br><br>
<hr>
<br>

## 安裝開發環境
確定你上面的事前準備都有先裝好。以下步驟是假設你先前沒有安裝過 Hyperledger 套件（Fabric, Composer...etc），如果有個話請移除掉先前的版本再執行下面步驟，關於如何移除可以跳到下面的[附錄]()。

#### 安裝套件

##### 第一步：安裝命令工具
這是一些提供給 Composer 開發者的命令列介面工具，最重要的是 `composer-cli`，它包含了所有必要的指令，所以我們會先安裝它。接下來我們會安裝 `generator-hyperledger-composer`、 `composer-rest-server`、`Yeoman` 和 `generator-hyperledger-composer`。後面三個不是開發的核心元件，但會對你很有幫助如果你是按照這個教學或是要開發跟你的 Business Network（商業網路）互動的應用程式。<br><br>
注意，請**不要**使用 `su` 或 `sudo` 執行 npm 命令。

1. 必要的命令列介面工具：
   ```bash
   npm install -g composer-cli@0.19
   ```
2. 跑 REST 伺服器的小工具 （將你的商業網路以 RESTful API expose 出來）：
   ```bash
   npm install -g composer-cli@0.19
   ```
3. 生成應用程式資產的小工具：
   ```bash
   npm install -g generator-hyperledger-composer@0.19
   ```
4. `Yeoman` 是生成應用程式的工具（利用 `generator-hyperledger-composer`）：
   ```bash
   npm install -g yo
   ```

##### 第二步：安裝 Playground
如果你在網路上已經嘗試過 [Composer Online](https://composer-playground.mybluemix.net/login)，你就有看過 `Playground` 這個瀏覽程式。你其實也可以在本地端安裝這個瀏覽程式來查看和展示你的商業網路。

1. 用來簡單編輯和測試商業網路的瀏覽程式：
   ```bash
   npm install -g composer-playground@0.19
   ```

##### 第三步：設定你的 IDE
雖然說所有的文件編輯器都可以，推薦使用`VSCode`，因為它有提供一個 Composer 的插件。

1. 從這個網址下載 `VSCode`：https://code.visualstudio.com/download
<br>

2. 打開 VSCode、點擊 Extensions、在市集裡搜尋並安裝 `Hyperledger Composer`

##### 第四步：安裝 Hyperledger Fabric
這個步驟提供你一個本地的 Hyperledger Fabric runtime，使你可以部署你的商業網路到上面去。

1. 選一個資料夾（這裡假設 `~/fabric-dev-servers`），下載安裝 Hyperledger Fabric 的工具：
   ```bash
   mkdir ~/fabric-dev-servers && cd ~/fabric-dev-servers
   ```
   ```bash
   curl -O https://raw.githubusercontent.com/hyperledger/composer-tools/master/packages/fabric-dev-servers/fabric-dev-servers.tar.gz
   ```
   ```bash
   tar -xvf fabric-dev-servers.tar.gz
   ```
   也有 `zip` 檔提供下載，將上面的 `.tar.gz` 改成 `.zip` 並在解壓縮時從 `tar -xvf` 換成 `unzip`。
<br>

2. 使用剛取得的腳本來下載本地的 Hyperledger Fabric runtime：
   ```bash
   cd ~/fabric-dev-servers
   ```
   <details>
   <summary>指定版本請點我</summary>

   如果不指定版本則是預設 1.2 版，如果要 1.0 版則設成 `hlfv1`、如果要 1.1 版則設成 `hlfv11`、如果要 1.2 版則設成 `hlfv12`
   </details>

   ```bash
   export FABRIC_VERSION=hlfv11
   ```
   ```bash
   ./downloadFabric.sh
   ```

##### 附錄：刪除先前版本
如果這不是你第一次安裝、使用 Hyperledger 的套件，而是想要刪除先期版本使用較新版本的話，你可能會需要將所有 Docker 的容器都移除。
```bash
docker kill $(docker ps -q)
docker rm $(docker ps -aq)
docker rmi $(docker images dev-* -q)
```

## 恭喜安裝完成！:tada: