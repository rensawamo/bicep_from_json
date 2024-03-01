## Azure ポータルから 作成した リソースグループや VN VMなどを jsonから bicepへの置き換え
![image](https://github.com/rensawamo/bicep_from_json/assets/106803080/743b49c8-83a4-4987-bfc6-87ddbd7bcd57)

## Azure でアカウントをセッティング
```sh
az login
```

```sh
az account list --refresh --query "[?contains(name, 'Azure サブスクリプション名')].id" --output table
```

サブスクリプションの作成 
```sh
az account set --subscription ID--------
```

```sh
az configure --defaults group=YOURS
```


最初に  Azure portalからubuntu リソースの作成をおこない

テンプレートのエクスポートから jsonファイルをダウンロードした。

###  変換
ダウンロードしたテンプレートを逆コンパイル
```sh
az bicep decompile --file template.json
```
main.bicepにデコンパイルされたファイルをコピーペースト


### リファクタリング
変数の定義
```sh
var virtualNetworkName = 'ToyTruck-vnet'
```
main.parameters.production.jsonからの参照変数
```sh
@description('The administrator password for the virtual machine.')
@secure()
param virtualMachineAdminPassword string
```

不要プロパティ { 空 } などはフルで削除
以下でbicepのランゲージサーバは必要なプロパティを教えてくれる
![image](https://github.com/rensawamo/bicep_from_json/assets/106803080/f0911b23-945e-4f4f-b025-2cd9c26a0d46)


### テスト
本番環境との差を確認
```sh
az deployment group what-if --mode Complete --resource-group ToyTruck --template-file main.bicep --parameters main.parameters.production.json
```


### デプロイ
```sh
az deployment group create --resource-group ToyTruck --template-file main.bicep --parameters main.parameters.production.json
```

