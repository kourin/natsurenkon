set TITLE=ほにゃらら用設定1
rem 実際に選択する際は、上の「TITLE=」以降が表示されます。区別のつくように説明を書いておくと良いでしょう
rem ただし、半角の「' " & ^ = | > <」などは使わないでください。動作しなくなります。

rem FlashPlayerへの対応(1～3から選択）（プリセットy以外）
rem 2にする必要がある例: http://www.nicovideo.jp/watch/sm17278404
rem a:自動（プリセットo-q,y,xは1。それ以外は2）
rem 1:それなりに対応（ほとんどの場合これで十分）
rem 2:おおげさに対応（画質を多少犠牲にするが、Flashplayer由来のノイズはなくなる）
rem 3:完全互換が目標（画質をかなり犠牲にする、特にフェードや暗部）
rem 1にした場合は、エンコ後の動画確認の際、 Flashplayerのハードウェアアクセラレーションを
rem off(動画上で右クリック→設定)にした後、ページをリロードして、動画の確認を行なうこと
set FLASH=a

rem デインターレースの選択（a/y/nから選択）
rem aは必要かどうか自動判定、yは強制的にする、nは強制的にしない
rem 通常は、aで。
set DEINT=a

rem =============================== エンコード設定の質問への答え =======================================================
rem 質問への返答をあらかじめ入力しておくとドラッグ＆ドロップの後いちいち質問に答えなくてもよくなります
rem それぞれイコールの後ろに質問の答えを書いてください（例：「set ACTYPE=y」「set TEMP_BITRATE=160」）
rem 質問形式を維持したい場合はイコールの後ろは空欄のままにしておいてください（スペースも入れちゃだめ！）

rem プリセット選択（a,l～q,t,x,yから選択）
rem アニメ・アイマス・MMDなどはlmnから選択
rem 実写・PCゲームなどはopqから選択
rem それぞれ左から速度重視・バランス・画質重視
rem YouTube用はy、ニコニコ動画用CRFエンコはt
set PRETYPE=

rem プレミアムアカウントの場合は下を「set ACTYPE=y」に、一般アカウントの場合は下を「set ACTYPE=n」に変えてください
set ACTYPE=

rem YouTube用のエンコードの場合、ファイルサイズが1GB未満であっても必ずエンコードする場合は「set YTCONFIRM=y」に変えてください。
set YTCONFIRM=

rem YouTube用のエンコードの場合、パートナープログラムに登録している場合は下を「set YTTYPE=y」に、
rem していない場合は下を「set YTTYPE=n」に変えてください
set YTTYPE=

rem ---------------------------------------------------------------------------------------------------------------------
rem ここから下は、aを指定すると自動で推奨設定になります

rem プレミアムアカウントの場合の目標総合ビットレート(映像+音声)（単位はkbps、入力例：set T_BITRATE=1000）
set T_BITRATE=

rem 上記、総合目標ビットレートを2001 kbps以上にした場合、先にCRFエンコをして指定したビットレートが
rem 目的とする画質に対して過剰になっていないかどうかをテストするかどうか (y/n)
set CRF_TEST=

rem プリセットtの場合は、k:軽さ重視、m：バランス、q；画質重視 から選択
rem または、crfの数字 ( 入力例：set CRFTYPE=m または  set CRFTYPE=23.0 )
set CRFTYPE=

rem エコ回避する場合は下を「set ENCTYPE=y」に、エコ回避しない場合は下を「set ENCTYPE=n」に変えてください
set ENCTYPE=

rem 低再生負荷エンコにする場合は下を「set DECTYPE=y」に、低再生負荷エンコしない場合は下を「set DECTYPE=n」に変えてください
set DECTYPE=

rem リサイズする場合は下を「set RESIZE=y」に、リサイズしない場合は下を「set RESIZE=n」に変えてください
set RESIZE=

rem 音声のビットレートを「set TEMP_BITRATE=160」のように入力してください
rem 音声なしでエンコードする場合は「set TEMP_BITRATE=0」と入力してください
rem 元動画と同じにする場合は「set TEMP_BITRATE=a」と入力してください
set TEMP_BITRATE=

rem 音ズレ処理
rem yを選択すると自動で処理、nを選択すると処理しない
rem 手動で指定するときは「A_SYNC=20」のように数字を書いてください（単位はミリ秒）
rem （正なら冒頭に無音を追加、負なら音声の冒頭をカット）
set A_SYNC=

rem 音量調整
rem 音量調整しない場合は、n。単位はdB。
rem エンコード時に調整するよりも、事前に調整しておくこと推奨なので、通常は、nで。
rem A_GAIN=5なら、5dB音量を上がる。A_GAIN=-5なら、5dB音量が下がる。
rem 上げすぎて耳を痛めないように注意。上げすぎると音割れしますし。
set A_GAIN=

rem さらに最後の確認画面もスキップしたい場合は下を「set SKIP_MODE=true」に変えてください
set SKIP_MODE=

rem 上記以外でこのファイルで設定して有効になるパラメータ。
rem 有効にしたい場合は、set の前のremを消してください。
rem set DEFAULT_FPS=
rem set /a IMAGE_FPS=10
rem set /a IMAGE_KEYINT=%IMAGE_FPS%*10
rem set AUTO_A_BITRATE=320
rem set AAC_ENCODER=nero
rem set AAC_PROFILE=auto
rem set MAX_SAMPLERATE=48000
rem set TRIM_AUDIO=true
rem set COLORMATRIX=BT.601
rem set FULL_RANGE=off
rem set DEFAULT_PASS_SPEED=1
rem set DEFAULT_PASS_BALANCE=0
rem set DEFAULT_PASS_QUALITY=0
rem set RESIZER=
rem その他、user_setting.bat関連のパラメータ
rem 口調の選択
rem set KEEPWAV=y
rem set MOVIE_CHECK=y
rem set PLAYER_MODE=NEW
rem set CBROWSER=
rem set SHUTYPE=n

rem 「PRETYPE=c」とした時は、x264のオプションをここで指定することができます。
rem それ以外のプリセットを指定した場合は、以下は無視されます。
set BFRAMES=4
set B_ADAPT=2
set B_PYRAMID=normal
set REF=4
set RC_LOOKAHEAD=40
set QPSTEP=4
set AQ_MODE=2
set AQ_STRENGTH=0.80
set ME=umh
set SUBME=7
set PSY_RD=0.2:0
set TRELLIS=2

rem CRFの値を指定した場合は、シングルパスの品質基準VBRでエンコします。
rem 指定しない場合はマルチパスのビットレート指定でエンコ
set CRF=

rem その他手動指定で追加したいオプションがある場合はスペースで区切りながら追加
set MISC=--slow-firstpass --merange 24 --partitions all --no-fast-pskip --no-dct-decimate 

set MIN_KEYINT=1
set SCENECUT=50
set QCOMP=0.80
set WEIGHTP=1
set THREADS=0

rem その他手動指定で追加したいオプションがある場合はスペースで区切りながら追加
set COMMON_MISC=--qpmin 10 --direct auto --thread-input --log-level warning --no-interlaced --stats %TEMP_DIR%\x264.log
