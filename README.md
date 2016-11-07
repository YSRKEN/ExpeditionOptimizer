# ExpeditionOptimizer
Optimize schedule of expedition for Kantai Collection and Warship Girls  
『艦隊これくしょん』と『戦艦少女』用の遠征最適化ソルバー

## 概要
　題名の通り、どの遠征を何回行わせれば最も効率が良いかを算出します。
　Windows用に作りましたが、単純な仕組みなので他OSでも頑張れば動かせるのではないでしょうか？

## 実行例
![実行例](https://cloud.githubusercontent.com/assets/3734392/20052981/d15bbec2-a519-11e6-8a3d-6c7191ab885a.png)

## 実行方法
1. リポジトリをcloneするか、zipをダウンロードするか、releaseに置いてあるzipファイルをダウンロードします。
2. calc.rbやrun.batが置いてあるのと同じフォルダに、[SCIP](http://scip.zib.de/)の実行ファイルを置きます。  
その際、「scip～～.exe」と長い名前になっているファイルを「scip.exe」とリネームしてください。
3. run.batを実行します。最適化する対象の指定、資材量指定などを入力すれば計算が実行されます。

## 注意
- 出力される総遠征時間は目安の数値です
- キラ付けや大発には対応していません
- temp.lp、query.txt、result.txt、query.solは自動生成されます(削除しても構いません)
- 表示してほしくない遠征があれば、table1.csvやtable2.csvを自前で編集してください。UTF-8形式・CR+LFを想定しています
