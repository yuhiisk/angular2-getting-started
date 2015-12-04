(function() {

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
// ブラウザがコンテンツの読み込みが終わったことを伝えるために待って、その後にAngularのbootstrapメソッドを呼ぶんだよ。
// `bootstrap`メソッドはアプリケーションルートでアプリケーションと`AppConponent`がスタートしたことをAngularに教えるんだよ。
document.addEventListener('DOMContentLoaded', function() {
    ng.bootstrap(AppComponent);
});

})();
