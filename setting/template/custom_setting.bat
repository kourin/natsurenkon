set TITLE=�قɂ���p�ݒ�1
rem ���ۂɑI������ۂ́A��́uTITLE=�v�ȍ~���\������܂��B��ʂ̂��悤�ɐ����������Ă����Ɨǂ��ł��傤
rem �������A���p�́u' " & ^ = | > <�v�Ȃǂ͎g��Ȃ��ł��������B���삵�Ȃ��Ȃ�܂��B

rem FlashPlayer�ւ̑Ή�(1�`3����I���j�i�v���Z�b�gy�ȊO�j
rem 2�ɂ���K�v�������: http://www.nicovideo.jp/watch/sm17278404
rem a:�����i�v���Z�b�go-q,y,x��1�B����ȊO��2�j
rem 1:����Ȃ�ɑΉ��i�قƂ�ǂ̏ꍇ����ŏ\���j
rem 2:���������ɑΉ��i�掿�𑽏��]���ɂ��邪�AFlashplayer�R���̃m�C�Y�͂Ȃ��Ȃ�j
rem 3:���S�݊����ڕW�i�掿�����Ȃ�]���ɂ���A���Ƀt�F�[�h��Õ��j
rem 1�ɂ����ꍇ�́A�G���R��̓���m�F�̍ہA Flashplayer�̃n�[�h�E�F�A�A�N�Z�����[�V������
rem off(�����ŉE�N���b�N���ݒ�)�ɂ�����A�y�[�W�������[�h���āA����̊m�F���s�Ȃ�����
set FLASH=a

rem �f�C���^�[���[�X�̑I���ia/y/n����I���j
rem a�͕K�v���ǂ�����������Ay�͋����I�ɂ���An�͋����I�ɂ��Ȃ�
rem �ʏ�́Aa�ŁB
set DEINT=a

rem =============================== �G���R�[�h�ݒ�̎���ւ̓��� =======================================================
rem ����ւ̕ԓ������炩���ߓ��͂��Ă����ƃh���b�O���h���b�v�̌ア����������ɓ����Ȃ��Ă��悭�Ȃ�܂�
rem ���ꂼ��C�R�[���̌��Ɏ���̓����������Ă��������i��F�uset ACTYPE=y�v�uset TEMP_BITRATE=160�v�j
rem ����`�����ێ��������ꍇ�̓C�R�[���̌��͋󗓂̂܂܂ɂ��Ă����Ă��������i�X�y�[�X�����ꂿ�Ⴞ�߁I�j

rem �v���Z�b�g�I���ia,l�`q,t,x,y����I���j
rem �A�j���E�A�C�}�X�EMMD�Ȃǂ�lmn����I��
rem ���ʁEPC�Q�[���Ȃǂ�opq����I��
rem ���ꂼ�ꍶ���瑬�x�d���E�o�����X�E�掿�d��
rem YouTube�p��y�A�j�R�j�R����pCRF�G���R��t
set PRETYPE=

rem �v���~�A���A�J�E���g�̏ꍇ�͉����uset ACTYPE=y�v�ɁA��ʃA�J�E���g�̏ꍇ�͉����uset ACTYPE=n�v�ɕς��Ă�������
set ACTYPE=

rem YouTube�p�̃G���R�[�h�̏ꍇ�A�t�@�C���T�C�Y��1GB�����ł����Ă��K���G���R�[�h����ꍇ�́uset YTCONFIRM=y�v�ɕς��Ă��������B
set YTCONFIRM=

rem YouTube�p�̃G���R�[�h�̏ꍇ�A�p�[�g�i�[�v���O�����ɓo�^���Ă���ꍇ�͉����uset YTTYPE=y�v�ɁA
rem ���Ă��Ȃ��ꍇ�͉����uset YTTYPE=n�v�ɕς��Ă�������
set YTTYPE=

rem ---------------------------------------------------------------------------------------------------------------------
rem �������牺�́Aa���w�肷��Ǝ����Ő����ݒ�ɂȂ�܂�

rem �v���~�A���A�J�E���g�̏ꍇ�̖ڕW�����r�b�g���[�g(�f��+����)�i�P�ʂ�kbps�A���͗�Fset T_BITRATE=1000�j
set T_BITRATE=

rem ��L�A�����ڕW�r�b�g���[�g��2001 kbps�ȏ�ɂ����ꍇ�A���CRF�G���R�����Ďw�肵���r�b�g���[�g��
rem �ړI�Ƃ���掿�ɑ΂��ĉߏ�ɂȂ��Ă��Ȃ����ǂ������e�X�g���邩�ǂ��� (y/n)
set CRF_TEST=

rem �v���Z�b�gt�̏ꍇ�́Ak:�y���d���Am�F�o�����X�Aq�G�掿�d�� ����I��
rem �܂��́Acrf�̐��� ( ���͗�Fset CRFTYPE=m �܂���  set CRFTYPE=23.0 )
set CRFTYPE=

rem �G�R�������ꍇ�͉����uset ENCTYPE=y�v�ɁA�G�R������Ȃ��ꍇ�͉����uset ENCTYPE=n�v�ɕς��Ă�������
set ENCTYPE=

rem ��Đ����׃G���R�ɂ���ꍇ�͉����uset DECTYPE=y�v�ɁA��Đ����׃G���R���Ȃ��ꍇ�͉����uset DECTYPE=n�v�ɕς��Ă�������
set DECTYPE=

rem ���T�C�Y����ꍇ�͉����uset RESIZE=y�v�ɁA���T�C�Y���Ȃ��ꍇ�͉����uset RESIZE=n�v�ɕς��Ă�������
set RESIZE=

rem �����̃r�b�g���[�g���uset TEMP_BITRATE=160�v�̂悤�ɓ��͂��Ă�������
rem �����Ȃ��ŃG���R�[�h����ꍇ�́uset TEMP_BITRATE=0�v�Ɠ��͂��Ă�������
rem ������Ɠ����ɂ���ꍇ�́uset TEMP_BITRATE=a�v�Ɠ��͂��Ă�������
set TEMP_BITRATE=

rem ���Y������
rem y��I������Ǝ����ŏ����An��I������Ə������Ȃ�
rem �蓮�Ŏw�肷��Ƃ��́uA_SYNC=20�v�̂悤�ɐ����������Ă��������i�P�ʂ̓~���b�j
rem �i���Ȃ�`���ɖ�����ǉ��A���Ȃ特���̖`�����J�b�g�j
set A_SYNC=

rem ���ʒ���
rem ���ʒ������Ȃ��ꍇ�́An�B�P�ʂ�dB�B
rem �G���R�[�h���ɒ�����������A���O�ɒ������Ă������Ɛ����Ȃ̂ŁA�ʏ�́An�ŁB
rem A_GAIN=5�Ȃ�A5dB���ʂ��オ��BA_GAIN=-5�Ȃ�A5dB���ʂ�������B
rem �グ�����Ď���ɂ߂Ȃ��悤�ɒ��ӁB�グ������Ɖ����ꂵ�܂����B
set A_GAIN=

rem ����ɍŌ�̊m�F��ʂ��X�L�b�v�������ꍇ�͉����uset SKIP_MODE=true�v�ɕς��Ă�������
set SKIP_MODE=

rem ��L�ȊO�ł��̃t�@�C���Őݒ肵�ėL���ɂȂ�p�����[�^�B
rem �L���ɂ������ꍇ�́Aset �̑O��rem�������Ă��������B
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
rem ���̑��Auser_setting.bat�֘A�̃p�����[�^
rem �����̑I��
rem set KEEPWAV=y
rem set MOVIE_CHECK=y
rem set PLAYER_MODE=NEW
rem set CBROWSER=
rem set SHUTYPE=n

rem �uPRETYPE=c�v�Ƃ������́Ax264�̃I�v�V�����������Ŏw�肷�邱�Ƃ��ł��܂��B
rem ����ȊO�̃v���Z�b�g���w�肵���ꍇ�́A�ȉ��͖�������܂��B
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

rem CRF�̒l���w�肵���ꍇ�́A�V���O���p�X�̕i���VBR�ŃG���R���܂��B
rem �w�肵�Ȃ��ꍇ�̓}���`�p�X�̃r�b�g���[�g�w��ŃG���R
set CRF=

rem ���̑��蓮�w��Œǉ��������I�v�V����������ꍇ�̓X�y�[�X�ŋ�؂�Ȃ���ǉ�
set MISC=--slow-firstpass --merange 24 --partitions all --no-fast-pskip --no-dct-decimate 

set MIN_KEYINT=1
set SCENECUT=50
set QCOMP=0.80
set WEIGHTP=1
set THREADS=0

rem ���̑��蓮�w��Œǉ��������I�v�V����������ꍇ�̓X�y�[�X�ŋ�؂�Ȃ���ǉ�
set COMMON_MISC=--qpmin 10 --direct auto --thread-input --log-level warning --no-interlaced --stats %TEMP_DIR%\x264.log
