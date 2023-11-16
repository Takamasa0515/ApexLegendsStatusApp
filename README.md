# README

## アプリ URL

以下の URL から実際にサービスを利用することができます。テストデータも用意しており、アカウント登録せずともアプリの機能を試すことができます。  
https://apexlegends-status-b4441d272292.herokuapp.com

## アプリケーションを開発した経緯

ApexLegends の戦績を確認できるサービスとして[Tracker Network](https://tracker.gg/ "Tracker Network")が広く利用されています。私もその一人でしたが、このサイトでは 1 日の合計キル数などのキル数の推移を簡単に見ることができないという点を不便に感じていました。  
今回開発したサービスでは、総キル数やレジェンドごとのキル数など、一般的な戦績表示機能に加え、独自機能として試合履歴を日別で保存する機能を追加しました。  
この機能の目的は、ユーザーが自身の目標を達成するための支援です。例えば、「1 ヶ月でこれだけキル数を増やしたい！」などの目標を掲げるユーザーにとって、サービスを通じて目標を計画的に達成できるよう支援することを目指しています。

## 主なページと機能

## 使用技術

### バックエンド

- Ruby 3.1.2
- Rails 7.0.7

### フロントエンド

- HTML
- CSS (SCSS)
- Bootstrap ([Startbootstrap](https://startbootstrap.com/template/scrolling-nav "Start Bootstrap"))
- JavaScript（jQuery）

### インフラストラクチャ

- AWS S3

### API

- [Tracker Network API](https://tracker.gg/ "Tracker Network API")
  - Apex Legends の戦績データを取得するために使用しています。戦績関連の情報を取得し当サービスでの表示・保存に活用しています。

## ER 図
