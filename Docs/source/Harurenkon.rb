#!ruby -Ks
require 'vr/vruby'
require 'net/http'
require 'vr/simple_dialog'
require 'vr/vrcontrol'
require 'vr/vrlayout'
require 'vr/vrddrop'
require 'vr/vrolednd'
require 'vr/vrhandler'
include SimpleDialog

basedir = Dir.getwd

def filelistmake
  unless ARGV[0] == nil then
    if File.directory?(ARGV[0]) == false then
        while line = ARGF.gets
          movie1=ARGF.path
        if /(wav|mp3|m4a|aac)$/i =~ movie1 then 
            $audio = "\""+ movie1 + "\""
        elsif
           begin
             unless movie1 == nil then
              $movie = $movie + " " + "\""+ movie1 + "\""
             end
           rescue
             $movie = "\""+ movie1 + "\""
           else
           end
        end 
        ARGF.skip
      end
    elsif File.directory?(ARGV[0]) == true then
      $movie = "\""+ ARGV[0] + "\""
    end
  end
end

filelistmake
Dir.chdir(basedir)

class DropPanel < VRPanel
  include VROleDropTarget
  include VRDropFileTarget
  def construct
    addControl VRStatic,"label","", 0,0,500,200
    start_oledroptarget([CF_HDROP])
  end
  
  def self_dropfiles(files)
    1.upto(files.size-1) do |i|
    print files[i]
        if /(wav|mp3)$/i =~ files[i] then 
            $audio = "\""+ files[i] + "\""
        else
           begin
             unless files[i] == nil then
              $movie = $movie + " " + "\""+ files[i] + "\""
             end
           rescue
              $movie = "\""+ files[i] + "\""
           else
           end
        end 
    end
  end
end

def vercheck
	@verfile = "tool/version.bat"
	@currentverfile = "tool/current_version"
	open(@verfile) {|file|
	@currentver0 = file.readlines[0]
	}
	@currentver1 = @currentver0.split(/\s*\=\s*/)
	@currentver2 = @currentver1.pop
	$currentver = @currentver2.sub(/\n/, '')

	@latestverfile = "tool/latest_version"

	begin
    unless File.exist?("tool/debug.txt")
	    url = URI.parse('http://kourindrug.sakura.ne.jp/files/tde/latest_version')
    else 
	    url = URI.parse('http://kourindrug.sakura.ne.jp/files/tde/latest_version2')
    end
		req = Net::HTTP::Get.new(url.path)
		res = Net::HTTP.start(url.host, url.port) {|http|
		http.request(req)
		}
	rescue
    	@latestver = $currentver
	else
		@latestver1 =  res.body
    	@latestver = @latestver1.sub(/\n/, '')
	    open( @latestverfile, "w"){|f| f.write(@latestver)}
	end

	unless @latestver == $currentver then
		begin
			url2 = URI.parse('http://kourindrug.sakura.ne.jp/files/tde/ChangeLog')
			req2 = Net::HTTP::Get.new(url2.path)
			res2 = Net::HTTP.start(url2.host, url2.port) {|http|
			http.request(req2)
			}
		rescue
			@chagngelog = " "
		else
			@chagngelog =  res2.body
		end
	
	  @updatemassage = @chagngelog + "\r\n###########################\r\n\r\n新しいバージョンが出ています。今、アップデードしますか？"
	  @updateconfirm = msgbox(@updatemassage, "アップデード確認", :yesno)
	  if @updateconfirm == :yes then
	    exec('start tool\harurenkon.bat natsurenkonupdate')
	    open( @currentverfile, "w"){|f| f.write(@latestver)}
		exit()
	  else 
	    open( @currentverfile, "w"){|f| f.write(@latestver)}	  
	  end 
    end
end

vercheck

class MyControl < VRPanel
  include VRMessageParentRelayer
  include VRStdControlContainer
  include VRDropFileTarget
  def construct
    self.caption="春蓮根"
    b = $movie
    c = $audio
    addControl(VRButton,     "btn1","動画または画像ファイルを選択",  10,30,500,20)
    addControl(VRButton,     "btn2","動画とは別の音声を使う場合は音声ファイルを選択",  10,70,500,20)
    addControl(VRStatic,     "txt7","※複数ファイルの連続エンコおよび連番aviの連結はこのウィンドウにファイルまたはフォルダをドロップ",  10,90, 900,20)
    send_parent("btn1",  "clicked")
    send_parent("btn2",  "clicked")
   end
end

module MyForm
  include VRDropFileTarget
  def construct
    self.caption="春蓮根(夏蓮根簡易フロントエンド)    ※※※ファイルまたはフォルダをドロップする場合はこのタイトルバーへ※※※"
     addControl(VRStatic,     "txt0","夏蓮根(ニコニコ動画用エンコード支援ツール)",  100,10, 550,20)
     addControl(MyControl,"cntl1"," ", 10,30,800,110)
     addControl(VRStatic,     "txt1","動画：",  20,40,1200,20)
     addControl(VRStatic,     "txt2","音声：",  20,80,1200,20)
     addControl(VRStatic,     "txt3","簡易設定",  210,160, 120,20)
     addControl(VRStatic,     "txt4","プレミアム会員",  20,180, 500,20)
     addControl(VRRadiobutton,     "rdb1","バランス（9分未満の場合は、画質を重視したい時もこちらを推奨）",  80,200, 550,20)
     addControl(VRRadiobutton,     "rdb2","画質重視（9分を越える動画向け。または、バランスだと重すぎる場合用）",  80,220, 600,20)
     addControl(VRStatic,     "txt5","一般会員",  20,240, 500,20)
     addControl(VRRadiobutton,     "rdb3","バランス",  80,260, 200,20)
     addControl(VRRadiobutton,     "rdb4","音質重視",  80,280, 200,20)
     addControl(VRStatic,     "txt6","エコノミー回避（低画質になるかもしれないが、常に同じ画質・音質\n　　　　　　　　一般会員が混雑時間帯に試聴しても劣化しない）",  20,300, 700,40)
     addControl(VRRadiobutton,     "rdb5","画質重視",  80,340, 800,20)
     addControl(VRRadiobutton,     "rdb6","音質重視（主に画像1枚(+歌詞)の音楽動画向け）",  80,360, 800,20)
     addControl(VRStatic,     "txt7","YouTube推奨設定(アップロード上限解除していない場合は15分まで)", 20,400, 700,20)
     addControl(VRRadiobutton,     "rdb7","高画質・高音質にしたい時は、1280x720か1920x1080で作っておくこと",  80,420, 800,20)
     addControl(VRStatic,     "txt8","1GB以下のmp4やwmv等は、エンコせずに直接投稿したほうが良いかも？",  100,440, 800,20)
     addControl(VRCheckbox,   "chk1","ボイス再生とエンコ終了時のお知らせをオフにする",    150,480, 400,20)
     addControl(VRButton,     "btn101","エンコード開始",  210,520, 200,20)
     @rdb1.check true
     @chk1.check false
     @file1 = "tool/TEMP/HARU/haru_enc_setting1.txt"
     @file2 = "tool/TEMP/HARU/haru_enc_setting2.txt"
     @file3 = "tool/TEMP/HARU/haru_enc_start.bat"
	 harutitle = "夏蓮根" + $currentver + "  (ニコニコ動画用エンコードツール「つんでれんこ」改造版)"
	 @txt0.caption = harutitle
    unless File.exist?("tool/TEMP/HARU") then
    `mkdir "tool/TEMP/HARU"`
    end
    
    open( @file1, "w"){|f| f.write("true")}
    unless $movie == nil then 
      @txt1.caption = "動画：" + $movie
    end
    unless $audio == nil then 
      @txt2.caption = "音声：" + $audio
    end
  end

  def textset(fname)
    a=fname
    if $movie == nil then
      if /(wav|mp3|m4a|aac)$/i =~ a then 
        $audio = "\""+ a + "\""
        @txt2.caption = "音声：" + $audio
      else
        $movie = "\"" + a + "\""
	      @txt1.caption = "動画：" + $movie
      end
    else
      if /(wav|mp3|m4a|aac)$/i =~ a then 
        $audio = "\""+ a + "\""
        @txt2.caption = "音声：" + $audio
      else
        $movie = $movie + " \"" + a + "\""
	      @txt1.caption = "動画：" + $movie
      end
    end
  end

  def self_dropfiles(files)
    textset(files[0])
    1.upto(files.size-1) do |i|
    end
  end

   def cntl1_btn1_clicked
       inmovie = SimpleDialog.select_file(title = "動画または画像ファイルを選択してください", filter = [])
       if not inmovie == nil then
          inmovie.each do |line|
          $movie = "\""+ line + "\""
	      @txt1.caption = "動画："+$movie
          end
       end
	   begin 
       ext_name = File.extname( $movie )
	   rescue
	   else
	       if ext_name == ".mswmm" then
	         puts msgbox("これはプロジェクトファイルです。\nWindowsムービーメーカーで「ムービーの発行」をしてwmvファイルにしてください", "プロジェクトファイル エラー", :ok)
	       elsif ext_name == ".wlmp" then
		     puts msgbox("これはプロジェクトファイルです。\nWindows Liveムービーメーカーで「ムービーの保存」をしてwmvファイルにしてください", "プロジェクトファイル エラー", :ok)
	       elsif ext_name == ".aup" then
	         puts msgbox("これはプロジェクトファイルです。\nAviUtlで	「AVI出力」をしてaviファイルにしてください","プロジェクトファイル エラー",  :ok)
	       elsif ext_name == ".vsp" then
	         puts msgbox("これはプロジェクトファイルです。\nVideoStudioで「ビデオファイルの作成」を選んで動画ファイルにしてください ","プロジェクトファイル エラー",  :ok)
	       elsif ext_name == ".nvp2" then
	         puts msgbox("これはプロジェクトファイルです。\n動画ファイルにしてください ","プロジェクトファイル エラー",  :ok)
	       elsif ext_name == ".nmm" then
	         puts msgbox("これはプロジェクトファイルです。\n動画ファイルにしてください ","プロジェクトファイル エラー",  :ok)
	       end
	   end
   end

   def cntl1_btn12_clicked
       inmovie = SimpleDialog.select_directory(title = "連番aviの入ったフォルダを選択してください")
       if not inmovie == nil then
          inmovie.each do |line|
          $movie = "\""+ line + "\""
	      @txt1.caption = "動画："+$movie
          end
       end
   end

   def cntl1_btn2_clicked
       inaudio = SimpleDialog.select_file(title = "音声ファイルを選択してください", filter = ["音声ファイル(*.wav;*.mp3;*.m4a;*.aac)","*.wav;*.mp3;*.m4a;*.aac"])
       inaudio
       unless inaudio == nil then
          inaudio.each do |line|
#          $audio = line
          $audio = "\""+ line + "\""
          @txt2.caption = "音声："+ $audio
          end
       end
   end

   def chk1_clicked
    if File.exist?(@file1) then 
      a=open(@file1).read
       open( @file1, "w"){|f| f.write("false")}
    end
    if a == "true" then 
       open( @file1, "w"){|f| f.write("false")}
     else
       open( @file1, "w"){|f| f.write("true")}
     end
   end
  
   def rdb1_clicked
     open( @file2 , "w"){|f| f.write("premium")}
   end

   def rdb2_clicked
     open( @file2 , "w"){|f| f.write("premiummovie")}
   end

   def rdb3_clicked
     open( @file2 , "w"){|f| f.write("normalmovie")}
   end

   def rdb4_clicked
     open( @file2 , "w"){|f| f.write("normalaudio")}
   end

   def rdb5_clicked
     open( @file2 , "w"){|f| f.write("economymovie")}
   end

   def rdb6_clicked
     open( @file2 , "w"){|f| f.write("economyaudio")}
   end

   def rdb7_clicked
     open( @file2 , "w"){|f| f.write("youtube")}
   end

   def btn101_clicked
	if not $movie == nil then
		$runfile = 'start tool\harurenkon.bat'
#		$runfile += " "+"\""+$movie+"\""
		$runfile += " "+$movie
		if not $audio == nil then
#			$runfile += " "+"\""+$audio+"\""
			$runfile += " "+ $audio
		end
		open( @file3 , "w"){|f| f.write($runfile)}
		close
		exec($runfile)
	else
		puts msgbox("エンコードしたいファイルを選択してください", "ファイルを選択してください", :ok)
	end
   end
end

VRLocalScreen.showForm(MyForm,100,100,800,590)
VRLocalScreen.messageloop
