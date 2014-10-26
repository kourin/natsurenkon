set ENC_VERSION=32

rem 口調の選択など、エンコード以外の設定は、user_setting.batにあります。
rem 初期値がわからなくなった場合は、template\enc_setting_template.batをコピーしてください。
rem ↓ここから下を適当に弄って自分好みの設定にしてください↓

rem 一般アカウント用エンコードで目指す総ビットレート（kbps）
rem ビットレートオーバーになるときは、この数値を下げる(初期値は640)
set I_TARGET_BITRATE=640
rem 一般アカウント用の限界総ビットレート（kbps）
set I_MAX_BITRATE=654

rem エコノミーモード回避用エンコードで目指す総ビットレート（kbps）
rem ビットレートオーバーになるときは、この数値を下げる(初期値は430)
set E_TARGET_BITRATE=430
rem エコノミーモード回避用の限界総ビットレート（kbps）
set E_MAX_BITRATE=445

rem リサイズの質問時にyを答えたときの幅と高さの設定 (16:9用。通常はこちらを使用）
rem 幅のデフォルトは854pixels。変えたいときは「DEFAULT_WIDTHW=640」などのようにする
rem 高さのデフォルトは「DEFAULT_HEIGHTW=」で、空欄のときは自動計算（動画ファイルのアスペクト比を維持）
rem 指定したい場合は「DEFAULT_HEIGHTW=360」などのようにする
set DEFAULT_WIDTHW=854
set DEFAULT_HEIGHTW=

rem リサイズの質問時にyを答えたときの幅と高さの設定 (4:3用）
rem 高さのデフォルトは480pixels。変えたいときは「DEFAULT_HEIGHT=360」などのようにする
rem 幅のデフォルトは「DEFAULT_WIDTH=」で、空欄のときは自動計算（動画ファイルのアスペクト比を維持）
rem 指定したい場合は「DEFAULT_WIDTH=854」などのようにする
set DEFAULT_WIDTH=
set DEFAULT_HEIGHT=480

rem 一般アカウントの解像度の上限の設定
rem 幅のデフォルトは1280pixels、高さのデフォルトは720pixels (2012年5月1日時点でのニコニコ動画の仕様)
set I_MAX_WIDTH=1280
set I_MAX_HEIGHT=720

rem リサイザの指定
rem Avisynthのリサイザから選んでください（Spline36Resize、Lanczos4Resizeなど）
rem よくわからない人は空欄のままにしておくこと
set RESIZER=

rem FPSを指定したいときは、「DEFAULT_FPS=24」などのようにする
rem 元の動画と同じのままなら空欄のままにしておく
set DEFAULT_FPS=

rem 静止画1枚と音声からmp4を作る場合のフレームレートとキーフレーム間隔
rem IMAGE_FPS=1にすると再生環境によっては最初の数秒がスキップされるので、理由が無ければいじらないこと
rem IMAGE_KEYINTは再生時にシークバーを動かせる間隔(デフォルトでは10秒おき)。
rem IMAGE_KEYINT=%IMAGE_FPS%*5にすると5秒おきになるが、画質維持のためにはより高い映像ビットレートが必要になる。
set /a IMAGE_FPS=10
set /a IMAGE_KEYINT=%IMAGE_FPS%*10

rem プレミアム会員がプリセットaを選んだ場合に、品質基準VBRにする基準値
rem 最大総合ビットレートで指定
rem 30fps以下の場合
rem デフォルトは、1500 kbps。
rem 99 MB * 1024 * 1024 * 8 / (1500 * 1000) = 553.6… 秒 (= 9分13秒)以下
rem ただし、エンコして100MBを越えた場合は、次回から上限が下がる
rem settingフォルダのbeginner_enc_record.txtを削除すると初期値に戻る
set AUTO_ENC_LIMIT=1500

rem 30fpsを越える場合
rem デフォルトは、2760 kbps。
rem 99 MB * 1024 * 1024 * 8 / (2760 * 1000) = 300.8… 秒(= 5分0秒)以下
set AUTO_ENC_LIMIT2=2760

rem 自動設定にした場合の音声ビットレート (kbps)
rem プレミアム会員が、音声ビットレートを自動にした場合の目標ビットレート
rem 一定時間より長い動画の場合は、この設定とは無関係に、96または128 kbpsになる
rem 音声が重要な場合は、「AUTO_A_BITRATE=320」、
rem 音声は重要ではなく、動画を軽くしたい場合は、「AUTO_A_BITRATE=96」、などと設定
set AUTO_A_BITRATE=320

rem デコーダの選択
rem auto、avi、ffmpeg、directshow、qt、LSMASH、ds_inputから選択(デフォルトのautoを推奨)
rem autoは自動選択、aviはAVISource、ffmpegはFFMpegSource、directshowはDirectShowSource
rem LSMASHはLSMASHsource、ds_inputはdirectshow file reader plugin for AviUtl
rem デコードに失敗したら別のものを自動で試すので、結果がおかしい場合以外は、autoのままで
rem qtはQuickTime(QuickTime7以降が必要です、一部コーデックでは非常に遅いです)
rem qtはファイル名・フォルダ名などに日本語等が含まれていると失敗するので
rem アルファベットのみにする、Cドライブ直下に置く等して対処してから使用してください
rem デコードが上手くいかない場合、LSMASHやdirectshowやffmegを指定するとうまく行く場合も
rem いずれでも上手くいかない場合は、「FFPIPE=n」を「FFPIPE=y」に変更して試してみてください
rem directshowでエンコ自体は出来るけれど、音ズレする等の問題がある場合は、ds_inputにしてください
set DECODER=auto
set FFPIPE=n

rem FlashPlayerへの対応(aまたは1～3から選択）（プリセットy以外）
rem 2にする必要がある例: http://www.nicovideo.jp/watch/sm17278404
rem a:自動（プリセットo-q,y,xは1。それ以外は2）
rem 1:それなりに対応（ほとんどの場合これで十分）
rem 2:おおげさに対応（画質を多少犠牲にするが、Flashplayer由来のノイズはなくなる）
rem 3:完全互換が目標（画質をかなり犠牲にする、特にフェードや暗部）
rem 1にした場合は、エンコ後の動画確認の際、 Flashplayerのハードウェアアクセラレーションを
rem off(動画上で右クリック→設定)にした後、ページをリロードして、動画の確認を行なうこと
set FLASH=a

rem デインターレースの選択（a/b/d/y/nから選択）
rem aは必要かどうか自動判定、yは強制的にする、nは強制的にしない
rem bは必要かどうか自動判定し、必要な時は2倍のフレームレートにする(60iなら、60p)に。
rem dは強制的にインターレース解除し、解除時に2倍のフレームレートにする
rem 通常は、aで。
set DEINT=a

rem AACエンコーダの選択（NeroAacEncかQuickTimeか）
rem neroかqt（QuickTimeがインストールされてる必要があります）かを選択
set AAC_ENCODER=nero

rem AACエンコードのプロファイル選択(hev2はAAC_ENCODER=neroの時のみ有効)
rem auto、lc、he、hev2から選択(デフォルトのautoを推奨)
set AAC_PROFILE=auto

rem 音声のサンプルレートの上限 (Hz)
rem AACの仕様上、96000 Hzが最大。それ以上にするとエンコに失敗します
rem 2011年12月現在、ニコニコ動画の再エンコ条件からサンプリングレート上限は撤廃されているようです
rem 初期値は48000。よほど耳に自信があるのでなければ、これ以上高くしても良いことはないかも。
set MAX_SAMPLERATE=48000

rem 音声の末尾カット
rem 動画と音声をドロップし、動画よりも音声が長い場合に、音声の最後の部分をカットするかどうか
rem カットしない場合、映像より長い部分については黒画面になり、その部分はシークできなくなります。
rem カットする場合は「TRIM_AUDIO=true」にする（デフォルト）
rem カットせずに残す場合は「TRIM_AUDIO=false」にする
rem 10分以上の動画の場合は、自動でfalseになるので、事前に各自でカットしておくこと
set TRIM_AUDIO=true

rem カラーマトリクス
rem よく分からない場合は弄らないのが吉
rem BT.601かBT.709を選択する
rem Adobe Flash Playerの仕様がコロコロ変わるので、よほどのことがなければイジらないのが吉 
set COLORMATRIX=BT.601

rem フルレンジを有効にしたい場合はonにする
rem フルレンジにした場合のデメリット(プレイヤー互換等)を認識している人のみ使用してください
rem きちんと色空間を考慮しないと、Avisynthでエラーになります
rem Flash Playerのバージョンによっては、onにしても無視されます
rem 特に理由がなければ、デフォルトのoffを推奨
set FULL_RANGE=off

rem MP4の容量の設定 (MB)
rem エンコード後の容量が100MB（プレアカ）や40MB（一般アカ）を超えてしまうとき
rem 下の値を小さくしてみるといいかも
rem DEFAULT_SIZE_PREMIUMかプレアカ用の設定、DEFAULT_SIZE_NOMALが一般アカ用の設定
rem 初期設定は「DEFAULT_SIZE_PREMIUM=100」、「DEFAULT_SIZE_NOMAL=40」
rem 
rem ニコニコ動画以外に投稿するなど、100MBを越えても良い場合は、 DEFAULT_SIZE_PREMIUMのほうを変更してください
rem ただし、2048MBを越えるサイズは指定できません。
set DEFAULT_SIZE_PREMIUM=100
set DEFAULT_SIZE_NORMAL=40

rem MP4の容量にどれだけ余裕を見るか(%)
rem 目標ファイルサイズ=DEFAULT_SIZE_PREMIUM(またはDEFAULT_SIZE_NORMAL) * DEFAULT_SIZE_PERCENT/100
rem 初期設定では、プレミアム会員の場合は、100*0.99 = 99 MB、一般会員の場合は、40*0.99=39.6 MB
rem 容量オーバーするときは「DEFAULT_SIZE_PERCENT=98.5」などと小さくしてみる
set DEFAULT_SIZE_PERCENT=99.0

rem YouTube用の設定 (GB)
rem 上限は128 GBです。 (2014年9月20日現在)
rem 15分を越える動画の投稿には、認証をして、上限を引き上げる必要があります。(最長 11時間。(2014年9月20日現在))
set DEFAULT_SIZE_YOUTUBE_PARTNER=128
set DEFAULT_SIZE_YOUTUBE_NORMAL=128
rem YouTube用のCRFの設定は、y\high.bat を編集して指定してください

rem FLV用mp3の容量の設定 (MB)
rem 画像(jpg、png、bmp)とmp3を一緒にドロップした際は、(可能なら)FLVを生成しますが、この場合、FLVのファイルサイズ指定ができないため、
rem mp3のファイルサイズの上限を設けることで、FLVの容量が100MB（プレアカ）や40MB（一般アカ）を超えてしまうのを防ぎます。
rem 上のDEFAULT_SIZE_PREMIUMやDEFAULT_SIZE_NORMALより1.5-2MBほど小さい整数値を指定してください。
set MP3_SIZE_PREMIUM=97
set MP3_SIZE_NORMAL=37

rem パス数の設定（画像＆音声の同時D&Dのときはこの設定は無効です）
rem 強制的に1passや2passや3passにしたいときはここを弄る
rem 「DEFAULT_PASS_**=1」「DEFAULT_PASS_**=2」「DEFAULT_PASS_**=3」でそれぞれ1pass、2pass、3passを強制する
rem 「DEFAULT_PASS_**=0」（デフォルト）だと自動判定（2pass後のビットレートから3passが必要かを判断）
rem 速度重視、バランス、画質重視の各プリセットごとに設定してください
rem SPEED、BALANCE、QUALITYがそれぞれ速度重視、バランス、画質重視を選んだ時のパス数設定になります
set DEFAULT_PASS_SPEED=1
set DEFAULT_PASS_BALANCE=0
set DEFAULT_PASS_QUALITY=0

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

rem YouTube用のエンコードの場合、アップロード上限解除の設定をしている場合は下を「set YTTYPE=y」に、
rem していない場合は下を「set YTTYPE=n」に変えてください
set YTTYPE=

rem ---------------------------------------------------------------------------------------------------------------------
rem ここから下は、aを指定すると自動で推奨設定になります

rem プレミアムアカウントの場合の目標総合ビットレート(映像+音声)（単位はkbps、入力例：set T_BITRATE=1000）
set T_BITRATE=

rem 上記、総合目標ビットレートから音声ビットレートを引いた値を2001 kbps以上にした場合、先にCRFエンコをして指定したビットレートが
rem 目的とする画質に対して過剰になっていないかどうかをテストするかどうか (y/n、または、crfの数字)
rem YouTube用のCRFの値は、y\high.bat を編集して指定してください
set CRF_TEST=

rem プリセットtの場合は、k:軽さ重視、m：バランス、q；画質重視 から選択
rem または、crfの数字 ( 入力例：set CRFTYPE=m または  set CRFTYPE=23.0 )
set CRFTYPE=

rem エコ回避する場合は下を「set ENCTYPE=y」に、エコ回避しない場合は下を「set ENCTYPE=n」に変えてください
set ENCTYPE=

rem 低再生負荷エンコにする場合は下を「set DECTYPE=y」に、低再生負荷エンコしない場合は下を「set DECTYPE=n」に変えてください
set DECTYPE=

rem 自動リサイズする場合は下を「set RESIZE=y」に、リサイズしない場合は下を「set RESIZE=n」に変えてください
rem 手動でリサイズする場合には、半角の「:」区切りで「幅:高さ」を入力してください。(例: 640:360 等)
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
rem 音量調整しない場合は、n。単位はdB。(入力例：set A_GAIN=5）
rem エンコード時に調整するよりも、事前に調整しておくこと推奨なので、通常は、nで。
rem A_GAIN=5なら、5dB音量を上がる。A_GAIN=-5なら、5dB音量が下がる。
rem 上げすぎて耳を痛めないように注意。上げすぎると音割れしますし。
set A_GAIN=

rem さらに最後の確認画面もスキップしたい場合は下を「set SKIP_MODE=true」に変えてください
set SKIP_MODE=
