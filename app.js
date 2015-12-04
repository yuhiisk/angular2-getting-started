(function() {

// 5分のクイックスタートをやるよ。
// これは5 MIN QUICKSTARTの日本語訳だよ

// ゼロからJavascriptで作る簡単なAngular2アプリケーション制作を始めようよ。

// もしかしてJavascriptやりたくない？
// 僕たちはJavascriptで始めようとしているけど、バナーのコンボボックスから他の言語を選択すれば、Angular 2 アプリケーションはTypeScriptやDartでも書くことができるんだよ。

// 6つの手順で進めるよ。
// 1. プロジェクトフォルダを作るよ。
// 2. 必要なライブラリをインストールするよ。
// 3. app.jsにアプリケーションのルートコンポーネントを書くよ。
// 4. Bootstrapだよ
// 5. index.htmlを作るよ
// 6. 実行するよ


// プロジェクトフォルダを作るよ
// ぼくたちのアプリケーションを入れる新しいフォルダを作るよ。
//
// mkdir Angular2-quickstart
// cd    Angular2-quickstart


// 必要なライブラリをインストールするよ
// npmパッケージマネージャーを使ってライブラリと開発ツールのパッケージをインストールするよ。
// angular2 - Angular 2 ライブラリだよ。
// live-server ファイルを変更するとブラウザをリロードしてくれる静的なファイルサーバーだよ。
// ウェブ上でライブラリを参照するか、ぼくたちのプロジェクトにダウンロードすることができるよ。
// それはnpmの持続的な開発プロセスじゃないのと、一回npmをインストールしておけばパッケージの読み込みは超絶簡単だよ。

// npmを持ってないの？このドキュメント全体で繰り返し使うからすぐ入手しておいてよ。

// ターミナルを開いてコマンドを入力するよ。
// npm init -y
// npm i angular2@2.0.0-alpha.44 --save --save-exact
// npm i live-server --save-dev

// これらのコマンドはパッケージのインストールとnpmの設定ファイル「package.json」を作るコマンドだよ。
// ぼくたちのpackage.jsonは次のようになるよ。
// {
//   "name": "angular2-getting-started",
//   "version": "1.0.0",
//   "dependencies": {
//     "angular2": "2.0.0-alpha.44"
//   },
//   "devDependencies": {
//     "live-server": "^0.8.1"
//   }
// }
// scriptsセクションもあるよ。次のように変更してよ。
// {
//   "scripts": {
//     "start": "live-server"
//   }
// }
// すぐ実行するよ。スクリプトコマンドでプロジェクトの世界を拡張したんだよ。


// はじめてのAngularコンポーネントだよ。

// ngがグローバルなAngularのNamespaceだよ。
var AppComponent = ng
    // Componentメソッドはコンポーネント設定だよ。
    // 今回は2つのプロパティを指定するよ。
    .Component({
        // 要素の名前を設定するよ。
        selector: 'my-app',
        // テンプレートだよ。これでコンポーネントの外観を定義するよ。
        template: '<h1>My First Angular 2 App</h1>'
        // templateUrl property でfilenameを指定してもいけるよ。
    })
    // Classメソッドはここで定義するプロパティとメソッドをviewに結合して、
    // 適切な振る舞いをコンポーネント自体を設定するよ。
    .Class({
        constructor: function() {}
    });

// このコンポーネントクラスは最低限の実装だよ。
// コンストラクタ関数には何もないから、まぁ何もしないよ。
// この後興味をそそるコンポーネントクラスを見ていくよ。


// Bootstrapアプリだよ。

// 何かアプリに動きをつけたいんだよ。
// 以下のコードをapp.jsの最後に書いてほしいよ。
document.addEventListener('DOMContentLoaded', function() {
    ng.bootstrap(AppComponent);
});

// ブラウザがコンテンツの読み込みが終わったことを伝えるために待って、その後にAngularのbootstrapメソッドを呼ぶんだよ。
// `bootstrap`メソッドはアプリケーションルートでアプリケーションと`AppConponent`がスタートしたことをAngularに教えるんだよ。
// いつかぼくたちのアプリケーションは、このルートからツリー状に発生する複数のコンポーネントから構成されることを推測するのが正しいんだよ。

// 生命維持で包むんだよ。
// ぼくたちはグローバルの名前空間を汚染したくないんだよ。
// あと、ぼくたちはまだアプリケーションの名前空間を必要としてないよ。
// だから、単純な生命維持（匿名関数）のラッパーでコードを囲むんだよ。
// ファイル全体は次のようになるよ。
//
// (function() {
// var AppComponent = ng
//   .Component({
//     selector: 'my-app',
//     template: '<h1>My First Angular 2 App</h1>'
//   })
//   .Class({
//     constructor: function () { }
//   });
// document.addEventListener('DOMContentLoaded', function() {
//   ng.bootstrap(AppComponent);
// });
// })();


// index.htmlを作るよ
// 新しく`index.html`をプロジェクトフォルダに追加して、次のHTMLを入力するよ。
// <html>
//   <head>
//     <title>Angular 2 QuickStart</title>
//     <script src="node_modules/angular2/bundles/angular2.sfx.dev.js"></script>
//     <script src="app.js"></script>
//   </head>
//   <body>
//     <my-app></my-app>
//   </body>
// </html>

// <blockquote>
// このアプリでは2つのスクリプトファイルを`<head>`で読み込むよ。
// angular2.sfx.dev.js はAngular 2 の開発ファイルでAngularの中にグローバル`ng`名前空間を置くよ。
// app.js はぼくたちが書いたアプリケーションのJavascriptだよ。
// `<body>`の中に、`<my-app>`があるよ。これはアプリケーションルートのプレースホルダーだよ。
// Angularでは、ここでぼくたちのアプリケーションが表示されるよ。
// </blockquote>


// 実行するよ！
// 
// 静的なアプリケーションのアセット（index.htmlとapp.js）を提供するために、ファイルサーバが必要だよ。
// この例ではデフォルトでライブリロードを実行して、ぼくたちが変更を行うようにブラウザの更新を見て楽しめるから、`npm`でインストールしたlive-serverを使うよ。
// ターミナル（Windows/Linuxはコマンドライン）を開いて入力するよ。
// npm start
//
// この`npm`コマンドは前に`package.json`のscriptセクションに追加したやつだよ。
//
// live-serverはブラウザを読み込んで、アプリケーションを変更するとページをリフレッシュするよ。
// しばらくすると、ブラウザタブが開いて表示されるよ。
//
//
// 変更してみてよ。
// `live-server`はファイルの変更を検出して自動的にブラウザのページをリフレッシュするよ。
// メッセージを"My SECOND Angular 2 app"に変更してみてよ。`live-server`はその変更を見てブラウザをリロードするよ。
// ターミナルの画面で`live-server`を実行したまま、変更しようとし続けてよ。
// `Cttl-C`でいつでも止めることができるよ。
//
// おめでとう！ぼくたちはビジネスをしているんだよ...そして、次のレベルへの準備が完了したよ。
//
})();
