## ApexLegends Status

![apexlegends_status_logo](https://github.com/Takamasa0515/ApexLegendsStatusApp/assets/102008250/a0972c0f-8b52-4107-b810-663022bd9927)

ApexLegends Statusは「ApexLegends」のアカウント全体の戦績から、1日1日のキル数をはじめとする試合の結果を確認できるサービスです。

## アプリ URL

以下の URL から実際にサービスを利用することができます。テストデータも用意しており、アカウント登録せずともアプリの機能を試すことができます。  
https://apexlegends-status-b4441d272292.herokuapp.com

## アプリケーションを開発した経緯

ApexLegendsの戦績を確認できるサービスとして[Tracker Network](https://tracker.gg/ "Tracker Network")(以降TRN)が広く利用されています。私もその一人でしたが、**TRNでは1日の合計キル数や月間キル数などのキル数の推移を簡単に見ることができない**という点を不便に感じていました。  
目標のキル数を設定し、その目標を達成するためにゲームをプレイしているユーザーも多く、この問題を解決したいと思いサービスの開発に取り組みました。  
今回開発したサービスでは、総キル数やレジェンドごとのキル数など、一般的な戦績表示機能に加え、**独自機能として試合履歴を日別で保存する機能を追加しました。**  
この機能の目的は、ユーザーが自身の目標を達成するための支援です。例えば、「1ヶ月でこれだけキル数を増やしたい！」などの目標を掲げるユーザーにとって、サービスを通じて目標を計画的に達成できるよう支援することを目指しています。


## 主なページと機能
| TOPページ | 新規登録ページ |
| ---- | ---- |
| ![ApexLegends_status_top](https://github.com/Takamasa0515/ApexLegendsStatusApp/assets/102008250/8f14250e-f0ed-44da-bc89-d075f9271b77) | ![ApexLegends_status_signup](https://github.com/Takamasa0515/ApexLegendsStatusApp/assets/102008250/cb35ad4c-2bb6-4be1-a555-c57a0c09ed7d) |
| トップページはサービスの紹介と、未ログインのユーザーにはログインまたは新規登録ページへ誘導、ログイン済みのユーザーにはマイページへ誘導するボタンを設置しました。これによりページに訪れた後のステップが明確になり、サービスをスムーズに利用できるよう工夫しました。 | 各フォームの下にエラーメッセージを表示することで、ユーザーにわかりやすい設計を意識しました。また、アカウントを所持している場合はログインページにすぐ遷移できるようフォーム下部にリンクを設置しました。 |

| ログインページ | マイページトップ |
| ---- | ---- |
| <img width="1664" alt="ApexLegends_status_login" src="https://github.com/Takamasa0515/ApexLegendsStatusApp/assets/102008250/a1439227-925e-43a9-94ca-1bda616c36fa"> | <img width="1664" alt="ApexLegends_mypage" src="https://github.com/Takamasa0515/ApexLegendsStatusApp/assets/102008250/1aff96ef-cb2c-4f3b-89a5-b6699289d0d5"> |
| ログインページではログイン保持機能やパスワード再設定機能などを追加し、ユーザビリティの向上を目指しました。 | マイページ上部ではユーザーのプロフィールやゲームアカウントなどの登録情報を一目でわかるようなレイアウトにしました。 |

| プロフィール編集ページ | ゲームアカウント登録・編集ページ |
| ---- | ---- |
| <img width="1664" alt="ApexLegends_status_user_edit" src="https://github.com/Takamasa0515/ApexLegendsStatusApp/assets/102008250/d6f0d435-0f0f-462a-bad6-2e2931f69ff8"> | <img width="1664" alt="ApexLegends_status_gameaccont_edit" src="https://github.com/Takamasa0515/ApexLegendsStatusApp/assets/102008250/02070553-295f-4326-974e-8d96575e37fb"> |
| プロフィール編集ではユーザー名やプロフィール、プロフィール画像を設定できます。 | ゲームアカウントの登録・編集ができます。プラットフォームはセレクトボックスを使用し、選択しやすいよう実装しました。 |

| 総合戦績画面 | 試合履歴画面 |
| ---- | ---- |
| ![ApexLegends_status_results](https://github.com/Takamasa0515/ApexLegendsStatusApp/assets/102008250/c7b25132-2f23-4083-af8e-88fa78e1d43f) | ![ApexLegends_status_matches](https://github.com/Takamasa0515/ApexLegendsStatusApp/assets/102008250/e6cb8f4d-a12d-4f79-8c33-79fc57ab5a6c) |
| マイページ下部の総合戦績画面では、アカウントの総合戦績とレジェンドの戦績を表示させています。 総合戦績ではアカウント全体の戦績や現在のランクを対応する画像と共に表示し、キル数が多い順にレジェンドの戦績を表示しています。| ページ上部では先月と今月の総キル数を、ページ下部にはカレンダーを表示しており、1日のキル数の合計を表示しています。また、日付をクリックすることでその日使用したレジェンドごとの戦績を確認できます。 |

| ユーザー一覧・検索ページ | お問い合わせページ |
| ---- | ---- |
| ![ApexLegends_status_user_search](https://github.com/Takamasa0515/ApexLegendsStatusApp/assets/102008250/172c180e-6d97-440f-a586-399ff46faa72) | <img width="1664" alt="ApexLegends_status_contact" src="https://github.com/Takamasa0515/ApexLegendsStatusApp/assets/102008250/b71ac9f6-b30a-4dbd-8ccd-6ba6b93f67a1"> |
| ユーザー一覧では登録されているユーザーを表示しています。また、ユーザ検索機能を実装し、ユーザー名やゲームIDから検索するキーワード検索に加え、プラットフォームや現在のランクを指定する絞り込み機能も実装しました。 | フッターにはお問い合わせフォームへのリンクを設置しています。名前とお問い合わせ内容、任意でメールアドレスを入力するフォームを設置し、ユーザーの意見を取り入れることを目的に実装しています。 |

## こだわったポイント

試合履歴画面では、カレンダーを導入し、各日付のセルにその日のキル数の合計を表示しています。日付をクリックすると、ページ下部にその日に使用したキャラクター、キル数、勝利数、ダメージ数が表示されます。  
複数の日付をクリックすることが想定されるため、Ajaxを利用して戦績を動的に表示し、ユーザビリティの向上に注力しました。

![ApexLegends_using_matches](https://github.com/Takamasa0515/ApexLegendsStatusApp/assets/102008250/c55dcd91-c4d9-4ccd-8e2f-ed968fd9acdb)

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

### ホスティング/デプロイ

- heroku

## ER 図

![ApexLegends_status_erd](https://github.com/Takamasa0515/ApexLegendsStatusApp/assets/102008250/c7572089-00fe-4b02-9c5a-aec40020c917)

