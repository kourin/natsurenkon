@echo off

rem 2014-08-17

set VER_URL="http://bit.ly/xcX4gp"
set VER_PATH=".\latest_version"

rem set UPD_URL="http://dl.dropbox.com/u/9397178/update.zip"
set UPD_URL="http://kourindrug.sakura.ne.jp/files/tde/update.zip"
set UPD_PATH="..\Archives\update.zip"

rem set UPD_URL2="http://dl.dropbox.com/u/9397178/update.7z"
set UPD_URL="http://kourindrug.sakura.ne.jp/files/tde/update.zip"
set UPD_PATH2="..\Archives\update.7z"

set UPD_URL3="http://dl.dropbox.com/u/9397178/update2.7z"

rem set UPDEX_URL="http://dl.dropbox.com/u/9397178/Extra.7z"
set UPD_URL="http://kourindrug.sakura.ne.jp/files/tde/Extra.7z"
set UPDEX_PATH="..\Archives\Extra.7z"

set EXV_URL="http://dl.dropbox.com/u/9397178/latest_Extra_version"
set EXV_PATH=".\latest_Extra_version"

set LOG_URL="http://bit.ly/K1tQg7"
set LOG_PATH=".\ChangeLog"

REM 7z
REM License: LGPL
set 7Z_URL="http://downloads.sourceforge.net/project/sevenzip/7-Zip/9.22/7z922.exe"
set 7Z_SIZE=384846

REM avs2avi
REM License: GPL 2.0
set A2P_VER=140a
set A2A_URL="http://www.avisynth.info/?plugin=attach&refer=%%A5%%A2%%A1%%BC%%A5%%AB%%A5%%A4%%A5%%D6&openfile=avs2avi-140a.zip"
set A2A_URL2="http://bit.ly/wUq0PJ"
set A2A_PATH="..\Archives\avs2avi-140a.zip"
set A2A_SIZE=155054

REM avs2pipemod
REM License: GPL 3.0
set A2P_VER=0.4.2
set A2P_URL="http://205.196.122.117/ukawaz3646dg/7uxi5odc84wafar/avs2pipemod-0.4.2.7z"
set A2P_URL2="http://bit.ly/Q4JWoF"
set A2P_URL3="http://bit.ly/Q4JJBD"
set A2P_PATH="..\Archives\avs2pipemod-0.4.2.7z"
set A2P_SIZE=44115

REM avs4x264mod
REM License: GPL 2 or later
set A4X_VER=0.9.0-git-r62(691c5c4)
set A4X_URL="http://www.nmm-hd.org/upload/get~QPKRk5r31r0/avs4x264mod-%A4X_VER%.7z"
set A4X_URL2="http://dl.dropbox.com/u/9397178/avs4x264mod-%A4X_VER%.7z"
set A4X_PATH="..\Archives\avs4x264mod-%A4X_VER%.7z"
set A4X_SIZE=15203

REM AviSynth
REM License: GPL 2 or later
set AVS_VER=2.6.0alpha5
set AVS_URL="http://downloads.sourceforge.net/project/avisynth2/AviSynth_Alpha_Releases/AVS%%202.6.0%%20Alpha%%205%%20%%5B130918%%5D/AviSynth_130918.exe"
set AVS_URL3="http://jaist.dl.sourceforge.net/project/avisynth2/AviSynth_Alpha_Releases/AVS%%202.6.0%%20Alpha%%205%%20%%5B130918%%5D/AviSynth_130918.exe"
set AVS_URL2="http://dl.dropbox.com/u/9397178/binary/AviSynth_130918.exe"
set AVS_PATH="..\Archives\Avisynth_130918.exe"
set AVS_SIZE=5270621

REM curl
REM License: MIT/X derivate
set CURL_URL="http://www.paehl.com/open_source/?download=curl_726_0_ssh2_ssl.zip"
set CURL_SIZE=1387925

REM DevIL
REM License: LGPL
set DIL_URL="http://downloads.sourceforge.net/project/openil/DevIL%%20Win32/1.7.8/DevIL-EndUser-x86-1.7.8.zip"
set DIL_URL3="http://jaist.dl.sourceforge.net/project/openil/DevIL%%20Win32/1.7.8/DevIL-EndUser-x86-1.7.8.zip"
set DIL_URL2="http://dl.dropbox.com/u/9397178/DevIL-EndUser-x86-1.7.8.zip"
set DIL_PATH="..\Archives\DevIL-EndUser-x86-1.7.8.zip"
set DIL_SIZE=676737

REM DirectShow File Reader plugin for AviUtl
REM License: freeware
set DSF_URL="http://videoinfo.tenchi.ne.jp/index.php?plugin=attach^&refer=DirectShow%%20File%%20Reader%%20%%A5%%D7%%A5%%E9%%A5%%B0%%A5%%A4%%A5%%F3%%20for%%20AviUtl^&openfile=ds_input026a.lzh"
set DSF_URL2="http://dl.dropbox.com/u/9397178/ds_input026a.lzh"
set DSF_PATH="..\Archives\ds_input026a.lzh"
set DSF_SIZE=68895

REM DirectShowSource
REM License: GPL 2
set DSS_VER=2601
set DSS_URL="http://downloads.sourceforge.net/project/avisynth2/AviSynth_Alpha_Releases/AVS%%202.6.0%%20Alpha%%204%%20%%5B130114%%5D/DirectShowSource_2601.zip"
set DSS_URL3="http://jaist.dl.sourceforge.net/project/avisynth2/AviSynth_Alpha_Releases/AVS%%202.6.0%%20Alpha%%204%%20%%5B130114%%5D//DirectShowSource_2601.zip"
set DSS_URL2="http://dl.dropbox.com/u/9397178/DirectShowSource_2601.zip"
set DSS_PATH="..\Archives\DirectShowSource_2601.zip"
set DSS_SIZE=40860

REM fdkaac builder
REM License: freeware + MinGW (GPL + other)
set FDKB_VER=r2
set FDKB_URL="http://bit.ly/1r3BwGy"
set FDKB_URL2="http://dl.dropbox.com/u/9397178/binary/fdkaac_builder_%FDKB_VER%.zip"
set FDKB_PATH="..\Archives\fdkaac_builder_%FDKB_VER%.zip"
set FDKB_SIZE=19903053

REM FFmpeg
REM License: LGPL 2.1+
set FFM_VER=20140427-git-6956b04
set FFM_URL="http://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-%FFM_VER%-win32-static.7z"
set FFM_URL2="http://dl.dropbox.com/u/9397178/binary/ffmpeg-%FFM_VER%-win32-static.7z"
set FFM_PATH="..\Archives\ffmpeg-%FFM_VER%-win32-static.7z"
set FFM_SIZE=11323170

REM ffmpegsource
REM License: GPL 3
set FFS_VER=2.20
rem set FSS_URL="https://github.com/FFMS/ffms2/releases/download/%FFS_VER%/ffms-%FFS_VER%.7z"
if "%CPU%"=="Intel" (
rem Intel
   set FSS_URL="https://github.com/FFMS/ffms2/releases/download/2.20/ffms2-%FFS_VER%-icl.7z"
   set FSS_URL2="http://dl.dropbox.com/u/9397178/binary/ffms2-%FFS_VER%-icl.7z"
   set FSS_PATH="..\Archives\ffms2-%FFS_VER%-icl.7z"
   set FSS_SIZE=7109200
) else (
   set FSS_URL="https://github.com/FFMS/ffms2/releases/download/2.20/ffms2-%FFS_VER%-msvc.7z"
   set FSS_URL2="http://dl.dropbox.com/u/9397178/binary/ffms2-%FFS_VER%-msvc.7z"
   set FSS_PATH="..\Archives\ffms2-%FFS_VER%-msvc.7z"
   set FSS_SIZE=5341340
)

REM JWplayer
REM License: CC BY-NC-SA 2.0
rem set JWP_URL="http://www.longtailvideo.com/jw/upload/mediaplayer.zip"
set JWP_URL="http://dl.dropbox.com/u/9397178/binary/mediaplayer.zip"
set JWP_PATH="..\Archives\mediaplayer.zip"
set JWP_SIZE=507325

REM libiconv2.dll
REM License: GPL
set LIC_URL="http://downloads.sourceforge.net/project/gnuwin32/libiconv/1.9.2-1/libiconv-1.9.2-1-bin.zip"
set LIC_URL3="http://jaist.dl.sourceforge.net/project/gnuwin32/libiconv/1.9.2-1/libiconv-1.9.2-1-bin.zip"
set LIC_URL2="http://dl.dropbox.com/u/9397178/libiconv-1.9.2-1-bin.zip"
set LIC_PATH="..\Archives\libiconv-1.9.2-1-bin.zip"
set LIC_SIZE=828380

REM libintl3.dll
REM License: GPL
set LIN_URL="http://downloads.sourceforge.net/project/gnuwin32/libintl/0.14.4/libintl-0.14.4-bin.zip"
set LIN_URL3="http://jaist.dl.sourceforge.net/project/gnuwin32/libintl/0.14.4/libintl-0.14.4-bin.zip"
set LIN_URL2="http://dl.dropbox.com/u/9397178/libintl-0.14.4-bin.zip"
set LIN_PATH="..\Archives\libintl-0.14.4-bin.zip"
set LIN_SIZE=394081

REM L-SMASH Works
REM License: LGPL
set LSS_VER=r726-g7a8d8a7
rem set LSS_URL="http://pop.4-bit.jp/bin/l-smash/L-SMASH_Works_%LSS_VER%_plugin-set.zip"
rem set LSS_URL2="http://dl.dropbox.com/u/9397178/binary/L-SMASH_Works_%LSS_VER%_plugin-set.zip"
rem set LSS_PATH="..\Archives\L-SMASH_Works_%LSS_VER%_plugin-set.zip"
rem LSS_URL0="https://drive.google.com/file/d/0BwV03nn6LPd9eW0zekRGajVibzQ/edit?usp=sharing"
set LSS_URL="http://dl.dropbox.com/u/9397178/binary/L-SMASH-Works_%LSS_VER%.7z"
set LSS_URL2="http://kourindrug.sakura.ne.jp/files/tde/Sources/L-SMASH-Works_%LSS_VER%.7z"
set LSS_PATH="..\Archives\L-SMASH-Works_%LSS_VER%.7z"
set LSS_SIZE=11353463

REM MediaInfo
REM License: LGPL 3 or later
set MIFN_VER=0.7.68
set MIFN_URL="http://mediaarea.net/download/binary/mediainfo/%MIF_VER%/MediaInfo_CLI_%MIF_VER%_Windows_i386.zip"
set MIFN_URL3="http://voxel.dl.sourceforge.net/project/mediainfo/binary/mediainfo/%MIF_VER%/MediaInfo_CLI_%MIF_VER%_Windows_i386.zip"
set MIFN_URL2="http://dl.dropbox.com/u/9397178/binary/MediaInfo_CLI_%MIF_VER%_Windows_i386.zip"
set MIFN_PATH="..\Archives\MediaInfo_CLI_%MIF_VER%_Windows_i386.zip"
set MIFN_SIZE=1609268

set MIF_VER=0.7.61
set MIF_URL="http://mediaarea.net/download/binary/mediainfo/%MIF_VER%/MediaInfo_CLI_%MIF_VER%_Windows_i386.zip"
set MIF_URL3="http://voxel.dl.sourceforge.net/project/mediainfo/binary/mediainfo/%MIF_VER%/MediaInfo_CLI_%MIF_VER%_Windows_i386.zip"
set MIF_URL2="http://dl.dropbox.com/u/9397178/binary/MediaInfo_CLI_%MIF_VER%_Windows_i386.zip"
set MIF_PATH="..\Archives\MediaInfo_CLI_%MIF_VER%_Windows_i386.zip"
set MIF_SIZE=1437806

REM Minimal DirectShow Player
REM License: GPL 2 or later
set MDP_VER=1.0.0
set MDP_URL="http://umezawa.dyndns.info/archive/mdsplay/mdsplay-%MDP_VER%-bin.zip"
set MDP_URL2="http://dl.dropbox.com/u/9397178/mdsplay-%MDP_VER%-bin.zip"
set MDP_PATH="..\Archives\mdsplay-%MDP_VER%-bin.zip"
set MDP_SIZE=103446

REM mkvtoolnix
REM License: GPL
set MKV_VER=5.8.0
set MKV_URL="http://www.bunkus.org/videotools/mkvtoolnix/win32/mkvtoolnix-unicode-%MKV_VER%.7z"
set MKV_URL2="http://dl.dropbox.com/u/9397178/mkvtoolnix-unicode-%MKV_VER%.7z"
set MKV_PATH="..\Archives\mkvtoolnix-unicode-%MKV_VER%.7z"
set MKV_SIZE=7445176

REM MP4Box
REM License: LGPL
set MP4B_VER=0.4.6-r3745
set MP4B_URL="http://pop.4-bit.jp/bin/MP4Box_%MP4B_VER%.zip"
set MP4B_URL2="http://dl.dropbox.com/u/9397178/MP4Box_%MP4B_VER%.zip"
set MP4B_PATH="..\Archives\MP4Box_%MP4B_VER%.zip"
set MP4B_SIZE=2894104

REM mp4fpsmod
REM License: Public Domain (+ MOZILLA PUBLIC LICENSE 1.1 + Boost software licence + BSD)
set MP4F_VER=0.24
set MP4F_URL2="http://sites.google.com/site/qaacpage/cabinet/mp4fpsmod_%MP4F_VER%.zip"
set MP4F_URL="http://dl.dropbox.com/u/9397178/mp4fpsmod_%MP4F_VER%.zip"
set MP4F_PATH="..\Archives\mp4fpsmod_%MP4F_VER%.zip"
set MP4F_SIZE=813611

REM neroAacEnc.dll
REM License: Nero
set NERO_URL="http://ftp6.nero.com/tools/NeroAACCodec-1.5.1.zip"
set NERO_URL2="http://www.nero.com/jpn/company/about-nero/nero-aac-codec.php"
set NERO_PATH="..\Archives\NeroAACCodec-1.5.1.zip"
set NERO_SIZE=2050564

REM openssl
REM License: GPL
set OSSL_URL="http://www.paehl.com/open_source/?download=libssl.zip"
set OSSL_PATH="..\Archives\libssl.zip"
set OSSL_SIZE=638572

REM pcre.dll
REM License: BSD
set PCRE_URL="http://downloads.sourceforge.net/project/gnuwin32/pcre/7.0/pcre-7.0-bin.zip"
set PCRE_URL3="http://jaist.dl.sourceforge.net/project/gnuwin32/pcre/7.0/pcre-7.0-bin.zip"
set PCRE_URL2="http://dl.dropbox.com/u/9397178/pcre-7.0-bin.zip"
set PCRE_PATH="..\Archives\pcre-7.0-bin.zip"
set PCRE_SIZE=302480

REM playwav.exe
REM License: freeware
set PLW_URL="http://dl.dropbox.com/u/9397178/playwav.zip"
set PLW_PATH="..\Archives\playwav.zip"
set PLW_SIZE=6028

REM preaac
REM License: freeware
set PREA_VER=v1.0.0
set PREA_URL="http://www1.axfc.net/u/3285901"
set PREA_URL2="http://dl.dropbox.com/u/9397178/binary/preqaac_%PREA_VER%.zip"
set PREA_URL3="http://kourindrug.sakura.ne.jp/files/tde/Sources/preqaac_%PREA_VER%.zip"
set PREA_PATH="..\Archives\preqaac_%PREA_VER%.zip"
set PREA_SIZE=397264

REM qaac
REM License: Public Domain
set QAA_VER=2.42
set QAA_URL="https://sites.google.com/site/qaacpage/cabinet/qaac_%QAA_VER%.zip"
set QAA_URL2="https://dl.dropboxusercontent.com/u/9397178/binary/qaac_%QAA_VER%.zip"
set QAA_URL3="http://kourindrug.sakura.ne.jp/files/tde/Sources/qaac_%QAA_VER%.zip"
set QAA_PATH="..\Archives\qaac_%QAA_VER%.zip"
set QAA_SIZE=2921433

REM qtaacenc
REM License: MIT
set QAE_VER=20110816
set QAE_URL="http://tmkk.pv.land.to/qtaacenc/qtaacenc-%QAE_VER%.zip"
set QAE_URL2="http://bit.ly/wnbcpb"
set QAE_PATH="..\Archives\qtaacenc-%QAE_VER%.zip"
set QAE_SIZE=48775

REM QTSource
REM License freeware
set QTS_URL="http://www.tateu.net/software/download/QTSource_20110528_bin.zip?q=php"
set QTS_URL2="http://bit.ly/ze8LOD"
set QTS_PATH="..\Archives\QTSource.zip"
set QTS_SIZE=71577

REM regex.dll
REM License: GPL
set REG_URL="http://downloads.sourceforge.net/project/gnuwin32/regex/2.7/regex-2.7-bin.zip"
set REG_URL3="http://jaist.dl.sourceforge.net/project/gnuwin32/regex/2.7/regex-2.7-bin.zip"
set REG_URL2="http://dl.dropbox.com/u/9397178/regex-2.7-bin.zip"
set REG_PATH="..\Archives\regex-2.7-bin.zip"
set REG_SIZE=73283

REM sed
REM License: GPL
set SED_URL="http://downloads.sourceforge.net/project/gnuwin32/sed/4.2.1/sed-4.2.1-bin.zip"
set SED_URL3="http://jaist.dl.sourceforge.net/project/gnuwin32/sed/4.2.1/sed-4.2.1-bin.zip"
set SED_URL2="http://dl.dropbox.com/u/9397178/sed-4.2.1-bin.zip"
set SED_PATH="..\Archives\sed-4.2.1-bin.zip"
set SED_SIZE=317930

REM sort.exe
REM License: GPL
set SORT_URL="http://downloads.sourceforge.net/project/gnuwin32/coreutils/5.3.0/coreutils-5.3.0-bin.zip"
set SORT_URL3="http://jaist.dl.sourceforge.net/project/gnuwin32/coreutils/5.3.0/coreutils-5.3.0-bin.zip"
set SORT_URL2="http://dl.dropbox.com/u/9397178/coreutils-5.3.0-bin.zip"
set SORT_PATH="..\Archives\coreutils-5.3.0-bin.zip"
set SORT_SIZE=5176996

REM warpsharp (seraphy ver.)
REM License: GPL
set WSS_URL="http://www.avisynth.info/?plugin=attach^&refer=%%A5%%A2%%A1%%BC%%A5%%AB%%A5%%A4%%A5%%D6^&openfile=warpsharp_20080325.rar"
set WSS_URL2="http://dl.dropbox.com/u/9397178/warpsharp_20080325.rar"
set WSS_PATH="..\Archives\warpsharp_20080325.rar"
set WSS_SIZE=191955

REM wavi
REM License: GPL 2
rem set WVI_URL="http://downloads.sourceforge.net/project/wavi-avi2wav/wavi/1.06/wavi106.zip"
set WVI_URL="http://forum.doom9.org/attachment.php?attachmentid=12312&d=1308245080"
set WVI_URL2="http://bit.ly/z5kCs5"
set WVI_PATH="..\Archives\wavi106m.zip"
set WVI_SIZE=26320

REM yadif
REM License: GPL
set YDF_URL2="http://avisynth.org.ru/yadif/yadif17.zip"
set YDF_URL="http://bit.ly/xzbAnd"
set YDF_PATH="..\Archives\yadif17.zip"
set YDF_SIZE=52095

REM x264
REM License: GPL
set X264_VERSION=2431
if "%XARCH%"=="32bit" (
rem  set X264_URL1="http://pop.4-bit.jp/bin/x264/x264-r%X264_VERSION%_win32_lsmash.zip"
  set X264_URL1="http://komisar.gin.by/old/%X264_VERSION%/x264.%X264_VERSION%.x86.exe"
  set X264_URL2="http://dl.dropbox.com/u/9397178/binary/x264.%X264_VERSION%.x86.7z"
  set X264_URL3="http://kourindrug.sakura.ne.jp/files/tde/Sources/x264.%X264_VERSION%.x86.7z"
  set X264_PATH="..\Archives\x264.%X264_VERSION%.x86.7z"
  set X264_SIZE=2828127
  set X264EXE=x264_x86.exe
) else (
rem  set X264_URL1="http://pop.4-bit.jp/bin/x264/x264-r%X264_VERSION%_win64_lsmash.zip"
  set X264_URL1="http://komisar.gin.by/old/%X264_VERSION%/x264.%X264_VERSION%.x86_64.exe"
  set X264_URL2="http://dl.dropbox.com/u/9397178/binary/x264.%X264_VERSION%.x86_64.7z"
  set X264_URL3="http://kourindrug.sakura.ne.jp/files/tde/Sources/x264.%X264_VERSION%.x86_64.7z"
  set X264_PATH="..\Archives\x264.%X264_VERSION%.x86_64.7z"
  set X264EXE=x264_x64.exe
  set X264_SIZE=3068478
  set X264_X64_SIZE=3068478
)
rem set X264_URL1="https://drive.google.com/folderview?id=0BwV03nn6LPd9SC1zVnFxVmN2QTQ&usp=sharing&tid=0BwV03nn6LPd9clpDcnl0bjU0NDg"
rem set X264_URL2="http://dl.dropbox.com/u/9397178/binary/x264.p.r%X264_VERSION%.7z"
rem set X264_URL3="http://kourindrug.sakura.ne.jp/files/tde/Sources/x264.p.r%X264_VERSION%.7z"
rem set X264_PATH="..\Archives\x264.p.r%X264_VERSION%.7z"
rem set X264_SIZE=6115730
rem set X264_X64_SIZE=6115730
