set USER_VERSION=28

rem エンコードそのものに関連する設定は、enc_setting.bat にあります
rem 初期値がわからなくなった場合は、template\user_setting_template.batをコピーしてください。
rem ↓ここから下を適当に弄って自分好みの設定にしてください↓

rem 背景色の選択
rem 「BG_COLOR=F0」（白地に黒文字）、「BG_COLOR=07」（黒地に白文字)
rem 他に指定できる色については、コマンドプロンプトで、color /? と入力して調べてください。
set BG_COLOR=07

rem 口調の選択
call ..\setting\message_tsundere.bat
rem デフォルトのツンデレ以外にしたい場合は「call」の前の「rem」を削除してください
rem ノーマル口調
rem call ..\setting\message_normal.bat 
rem でれでれんこ
rem call ..\setting\message_deredere.bat 
rem 修造れんこ
rem call ..\setting\message_shuzo.bat
rem ご自分でカスタマイズした場合はフルパスで指定してください 
rem 下記は例です。記号や空白が含まれていると正常動作しないかもしれません
rem call "C:\encode\message_custom.bat"

rem 音声の有無
rem 一部のメッセージを読み上げます
rem 音声ありなら「VOICE=true」、音声なしなら「VOICE=false」
set VOICE=true

rem 音声の選択
rem デフォルトのさとうささら以外にしたい場合は「set」の前の「rem」を削除してください
rem さとうささら
set VOICE_DIR=sasara_mp3
rem ゆっくり
rem set VOICE_DIR=tsundere_mp3
rem ore (ユーザーさん提供)
rem set VOICE_DIR=ore_mp3

rem 自作の音声をExtra\Voice\defaultにあるものと同じファイル名で用意することでカスタマイズ可能です
rem 使用しているボイスの一覧は、Extra\Voice\VOICE_list.txt にあります
rem 自作のボイスを使いたい場合は、Extra\Voice の下にフォルダを作って、フォルダ名を記述してください。
rem 下記は例です。記号や空白が含まれていると正常動作しないかもしれません
rem VOICE_DIR=MyVoice
rem (いまのところ、他の場所にボイスファイルを置いてフルパスを書くとかしても動きません。)

rem エンコード終了のお知らせ音は、このファイルを編集するのではなく
rem end_sound_setting.batで行うか、end_sound.txtにフルパスで記入してください

rem エンコード後にwavファイルを残すかどうか
rem デフォルト(「KEEPWAV=y」では音ズレ修正用にwavを残します
rem 不要な場合は、「KEEPWAV=n」にしてください
set KEEPWAV=y

rem エンコード後にプレイヤーを開くかどうか（開く場合はy、開かない場合はn）
rem ほかのプレイヤーで見ると、ニコニコ動画上で見るときと見え方が違う場合があるので
rem デフォルトのyをお勧めします
set MOVIE_CHECK=y

rem エンコード後に開くプレーヤーのスタイル。
rem 「PLAYER_MODE=NEW」だとニコニコ動画Q仕様。「PLAYER_MODE=OLD」だと、ニコニコ動画(原宿)仕様。
set PLAYER_MODE=NEW

rem 動画の確認に使用するブラウザ
rem デフォルトのブラウザで開く場合は、「CBROWSER=」に
rem デフォルト以外のブラウザで開きたい場合は、フルパスで記述
set CBROWSER=

rem 以下、設定する場合の例。該当の行の冒頭のremを削除すれば動くはず。インストール場所を変更していた場合は書き換えてください
rem set CBROWSER="%ProgramFiles%\Internet Explorer\iexplore.exe"
rem set CBROWSER="%ProgramFiles(x86)%\Internet Explorer\iexplore.exe"
rem set CBROWSER="%ProgramFiles%\Mozilla Firefox\firefox.exe"
rem set CBROWSER="%ProgramFiles(x86)%\Mozilla Firefox\firefox.exe"
rem set CBROWSER="%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe"
rem set CBROWSER="%ProgramFiles%\Opera\Opera.exe"
rem set CBROWSER="%ProgramFiles(x86)%\Opera\Opera.exe"
rem set CBROWSER="%ProgramFiles%\Safari\safari.exe"
rem set CBROWSER="%ProgramFiles(x86)%\Safari\safari.exe"

rem プロキシ設定
rem ネットワーク接続にproxyの設定が必要な場合は指定してください
rem サーバー[:ポート] 例： wwwcache.example.com または wwwcache.example.com:8080
rem 自動設定スクリプトには未対応
rem 認証が必要な場合は、PROXY=wwwcache.example.com:8080 --proxy-user user:pass  (:passは省略化)
set PROXY=

rem 自動バージョンチェック機能の設定
rem オンにする場合は「DEFAULT_VERSION_CHECK=true」にする（デフォルト＆激しく推奨）
rem オフにする場合は「DEFAULT_VERSION_CHECK=false」にする（激しく「非」推奨）
set DEFAULT_VERSION_CHECK=true

rem ファイルの出力先の指定（デフォルト推奨）
rem 指定したフォルダに同名のmp4がある場合は以前のファイルをold.mp4に変えてしまいます
rem またパス、ファイル名に日本語がある場合は不具合が起きる場合があります
set MP4_DIR=..\MP4

rem 8.3形式の短いファイル名の使用
rem 8.3形式の短いファイル名を生成しないように設定している方は、「SHORTNAME=false」にしてください
rem この場合、ファイル名やパスに一部の記号などを使っているとリネームするように言われることがあります
set SHORTNAME=true

rem エンコード終了後の挙動（デフォルトのn推奨）
rem nだとそのまま(MP4フォルダを開きに行きます)、oだと120秒待機後にシャットダウン
rem これをoに変えたことで他のアプリケーションの未保存のデータが消えても責任は取れません
set SHUTYPE=n
