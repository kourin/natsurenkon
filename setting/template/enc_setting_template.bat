set ENC_VERSION=32

rem �����̑I���ȂǁA�G���R�[�h�ȊO�̐ݒ�́Auser_setting.bat�ɂ���܂��B
rem �����l���킩��Ȃ��Ȃ����ꍇ�́Atemplate\enc_setting_template.bat���R�s�[���Ă��������B
rem ���������牺��K���ɘM���Ď����D�݂̐ݒ�ɂ��Ă���������

rem ��ʃA�J�E���g�p�G���R�[�h�Ŗڎw�����r�b�g���[�g�ikbps�j
rem �r�b�g���[�g�I�[�o�[�ɂȂ�Ƃ��́A���̐��l��������(�����l��640)
set I_TARGET_BITRATE=640
rem ��ʃA�J�E���g�p�̌��E���r�b�g���[�g�ikbps�j
set I_MAX_BITRATE=654

rem �G�R�m�~�[���[�h���p�G���R�[�h�Ŗڎw�����r�b�g���[�g�ikbps�j
rem �r�b�g���[�g�I�[�o�[�ɂȂ�Ƃ��́A���̐��l��������(�����l��430)
set E_TARGET_BITRATE=430
rem �G�R�m�~�[���[�h���p�̌��E���r�b�g���[�g�ikbps�j
set E_MAX_BITRATE=445

rem ���T�C�Y�̎��⎞��y�𓚂����Ƃ��̕��ƍ����̐ݒ� (16:9�p�B�ʏ�͂�������g�p�j
rem ���̃f�t�H���g��854pixels�B�ς������Ƃ��́uDEFAULT_WIDTHW=640�v�Ȃǂ̂悤�ɂ���
rem �����̃f�t�H���g�́uDEFAULT_HEIGHTW=�v�ŁA�󗓂̂Ƃ��͎����v�Z�i����t�@�C���̃A�X�y�N�g����ێ��j
rem �w�肵�����ꍇ�́uDEFAULT_HEIGHTW=360�v�Ȃǂ̂悤�ɂ���
set DEFAULT_WIDTHW=854
set DEFAULT_HEIGHTW=

rem ���T�C�Y�̎��⎞��y�𓚂����Ƃ��̕��ƍ����̐ݒ� (4:3�p�j
rem �����̃f�t�H���g��480pixels�B�ς������Ƃ��́uDEFAULT_HEIGHT=360�v�Ȃǂ̂悤�ɂ���
rem ���̃f�t�H���g�́uDEFAULT_WIDTH=�v�ŁA�󗓂̂Ƃ��͎����v�Z�i����t�@�C���̃A�X�y�N�g����ێ��j
rem �w�肵�����ꍇ�́uDEFAULT_WIDTH=854�v�Ȃǂ̂悤�ɂ���
set DEFAULT_WIDTH=
set DEFAULT_HEIGHT=480

rem ��ʃA�J�E���g�̉𑜓x�̏���̐ݒ�
rem ���̃f�t�H���g��1280pixels�A�����̃f�t�H���g��720pixels (2012�N5��1�����_�ł̃j�R�j�R����̎d�l)
set I_MAX_WIDTH=1280
set I_MAX_HEIGHT=720

rem ���T�C�U�̎w��
rem Avisynth�̃��T�C�U����I��ł��������iSpline36Resize�ALanczos4Resize�Ȃǁj
rem �悭�킩��Ȃ��l�͋󗓂̂܂܂ɂ��Ă�������
set RESIZER=

rem FPS���w�肵�����Ƃ��́A�uDEFAULT_FPS=24�v�Ȃǂ̂悤�ɂ���
rem ���̓���Ɠ����̂܂܂Ȃ�󗓂̂܂܂ɂ��Ă���
set DEFAULT_FPS=

rem �Î~��1���Ɖ�������mp4�����ꍇ�̃t���[�����[�g�ƃL�[�t���[���Ԋu
rem IMAGE_FPS=1�ɂ���ƍĐ����ɂ���Ă͍ŏ��̐��b���X�L�b�v�����̂ŁA���R��������΂�����Ȃ�����
rem IMAGE_KEYINT�͍Đ����ɃV�[�N�o�[�𓮂�����Ԋu(�f�t�H���g�ł�10�b����)�B
rem IMAGE_KEYINT=%IMAGE_FPS%*5�ɂ����5�b�����ɂȂ邪�A�掿�ێ��̂��߂ɂ͂�荂���f���r�b�g���[�g���K�v�ɂȂ�B
set /a IMAGE_FPS=10
set /a IMAGE_KEYINT=%IMAGE_FPS%*10

rem �v���~�A��������v���Z�b�ga��I�񂾏ꍇ�ɁA�i���VBR�ɂ����l
rem �ő呍���r�b�g���[�g�Ŏw��
rem 30fps�ȉ��̏ꍇ
rem �f�t�H���g�́A1500 kbps�B
rem 99 MB * 1024 * 1024 * 8 / (1500 * 1000) = 553.6�c �b (= 9��13�b)�ȉ�
rem �������A�G���R����100MB���z�����ꍇ�́A���񂩂�����������
rem setting�t�H���_��beginner_enc_record.txt���폜����Ə����l�ɖ߂�
set AUTO_ENC_LIMIT=1500

rem 30fps���z����ꍇ
rem �f�t�H���g�́A2760 kbps�B
rem 99 MB * 1024 * 1024 * 8 / (2760 * 1000) = 300.8�c �b(= 5��0�b)�ȉ�
set AUTO_ENC_LIMIT2=2760

rem �����ݒ�ɂ����ꍇ�̉����r�b�g���[�g (kbps)
rem �v���~�A��������A�����r�b�g���[�g�������ɂ����ꍇ�̖ڕW�r�b�g���[�g
rem ��莞�Ԃ�蒷������̏ꍇ�́A���̐ݒ�Ƃ͖��֌W�ɁA96�܂���128 kbps�ɂȂ�
rem �������d�v�ȏꍇ�́A�uAUTO_A_BITRATE=320�v�A
rem �����͏d�v�ł͂Ȃ��A������y���������ꍇ�́A�uAUTO_A_BITRATE=96�v�A�ȂǂƐݒ�
set AUTO_A_BITRATE=320

rem �f�R�[�_�̑I��
rem auto�Aavi�Affmpeg�Adirectshow�Aqt�ALSMASH�Ads_input����I��(�f�t�H���g��auto�𐄏�)
rem auto�͎����I���Aavi��AVISource�Affmpeg��FFMpegSource�Adirectshow��DirectShowSource
rem LSMASH��LSMASHsource�Ads_input��directshow file reader plugin for AviUtl
rem �f�R�[�h�Ɏ��s������ʂ̂��̂������Ŏ����̂ŁA���ʂ����������ꍇ�ȊO�́Aauto�̂܂܂�
rem qt��QuickTime(QuickTime7�ȍ~���K�v�ł��A�ꕔ�R�[�f�b�N�ł͔��ɒx���ł�)
rem qt�̓t�@�C�����E�t�H���_���Ȃǂɓ��{�ꓙ���܂܂�Ă���Ǝ��s����̂�
rem �A���t�@�x�b�g�݂̂ɂ���AC�h���C�u�����ɒu�������đΏ����Ă���g�p���Ă�������
rem �f�R�[�h����肭�����Ȃ��ꍇ�ALSMASH��directshow��ffmeg���w�肷��Ƃ��܂��s���ꍇ��
rem ������ł���肭�����Ȃ��ꍇ�́A�uFFPIPE=n�v���uFFPIPE=y�v�ɕύX���Ď����Ă݂Ă�������
rem directshow�ŃG���R���̂͏o���邯��ǁA���Y�����铙�̖�肪����ꍇ�́Ads_input�ɂ��Ă�������
set DECODER=auto
set FFPIPE=n

rem FlashPlayer�ւ̑Ή�(a�܂���1�`3����I���j�i�v���Z�b�gy�ȊO�j
rem 2�ɂ���K�v�������: http://www.nicovideo.jp/watch/sm17278404
rem a:�����i�v���Z�b�go-q,y,x��1�B����ȊO��2�j
rem 1:����Ȃ�ɑΉ��i�قƂ�ǂ̏ꍇ����ŏ\���j
rem 2:���������ɑΉ��i�掿�𑽏��]���ɂ��邪�AFlashplayer�R���̃m�C�Y�͂Ȃ��Ȃ�j
rem 3:���S�݊����ڕW�i�掿�����Ȃ�]���ɂ���A���Ƀt�F�[�h��Õ��j
rem 1�ɂ����ꍇ�́A�G���R��̓���m�F�̍ہA Flashplayer�̃n�[�h�E�F�A�A�N�Z�����[�V������
rem off(�����ŉE�N���b�N���ݒ�)�ɂ�����A�y�[�W�������[�h���āA����̊m�F���s�Ȃ�����
set FLASH=a

rem �f�C���^�[���[�X�̑I���ia/b/d/y/n����I���j
rem a�͕K�v���ǂ�����������Ay�͋����I�ɂ���An�͋����I�ɂ��Ȃ�
rem b�͕K�v���ǂ����������肵�A�K�v�Ȏ���2�{�̃t���[�����[�g�ɂ���(60i�Ȃ�A60p)�ɁB
rem d�͋����I�ɃC���^�[���[�X�������A��������2�{�̃t���[�����[�g�ɂ���
rem �ʏ�́Aa�ŁB
set DEINT=a

rem AAC�G���R�[�_�̑I���iNeroAacEnc��QuickTime���j
rem nero��qt�iQuickTime���C���X�g�[������Ă�K�v������܂��j����I��
set AAC_ENCODER=nero

rem AAC�G���R�[�h�̃v���t�@�C���I��(hev2��AAC_ENCODER=nero�̎��̂ݗL��)
rem auto�Alc�Ahe�Ahev2����I��(�f�t�H���g��auto�𐄏�)
set AAC_PROFILE=auto

rem �����̃T���v�����[�g�̏�� (Hz)
rem AAC�̎d�l��A96000 Hz���ő�B����ȏ�ɂ���ƃG���R�Ɏ��s���܂�
rem 2011�N12�����݁A�j�R�j�R����̍ăG���R��������T���v�����O���[�g����͓P�p����Ă���悤�ł�
rem �����l��48000�B��قǎ��Ɏ��M������̂łȂ���΁A����ȏ㍂�����Ă��ǂ����Ƃ͂Ȃ������B
set MAX_SAMPLERATE=48000

rem �����̖����J�b�g
rem ����Ɖ������h���b�v���A������������������ꍇ�ɁA�����̍Ō�̕������J�b�g���邩�ǂ���
rem �J�b�g���Ȃ��ꍇ�A�f����蒷�������ɂ��Ă͍���ʂɂȂ�A���̕����̓V�[�N�ł��Ȃ��Ȃ�܂��B
rem �J�b�g����ꍇ�́uTRIM_AUDIO=true�v�ɂ���i�f�t�H���g�j
rem �J�b�g�����Ɏc���ꍇ�́uTRIM_AUDIO=false�v�ɂ���
rem 10���ȏ�̓���̏ꍇ�́A������false�ɂȂ�̂ŁA���O�Ɋe���ŃJ�b�g���Ă�������
set TRIM_AUDIO=true

rem �J���[�}�g���N�X
rem �悭������Ȃ��ꍇ�͘M��Ȃ��̂��g
rem BT.601��BT.709��I������
rem Adobe Flash Player�̎d�l���R���R���ς��̂ŁA��قǂ̂��Ƃ��Ȃ���΃C�W��Ȃ��̂��g 
set COLORMATRIX=BT.601

rem �t�������W��L���ɂ������ꍇ��on�ɂ���
rem �t�������W�ɂ����ꍇ�̃f�����b�g(�v���C���[�݊���)��F�����Ă���l�̂ݎg�p���Ă�������
rem ������ƐF��Ԃ��l�����Ȃ��ƁAAvisynth�ŃG���[�ɂȂ�܂�
rem Flash Player�̃o�[�W�����ɂ���ẮAon�ɂ��Ă���������܂�
rem ���ɗ��R���Ȃ���΁A�f�t�H���g��off�𐄏�
set FULL_RANGE=off

rem MP4�̗e�ʂ̐ݒ� (MB)
rem �G���R�[�h��̗e�ʂ�100MB�i�v���A�J�j��40MB�i��ʃA�J�j�𒴂��Ă��܂��Ƃ�
rem ���̒l�����������Ă݂�Ƃ�������
rem DEFAULT_SIZE_PREMIUM���v���A�J�p�̐ݒ�ADEFAULT_SIZE_NOMAL����ʃA�J�p�̐ݒ�
rem �����ݒ�́uDEFAULT_SIZE_PREMIUM=100�v�A�uDEFAULT_SIZE_NOMAL=40�v
rem 
rem �j�R�j�R����ȊO�ɓ��e����ȂǁA100MB���z���Ă��ǂ��ꍇ�́A DEFAULT_SIZE_PREMIUM�̂ق���ύX���Ă�������
rem �������A2048MB���z����T�C�Y�͎w��ł��܂���B
set DEFAULT_SIZE_PREMIUM=100
set DEFAULT_SIZE_NORMAL=40

rem MP4�̗e�ʂɂǂꂾ���]�T�����邩(%)
rem �ڕW�t�@�C���T�C�Y=DEFAULT_SIZE_PREMIUM(�܂���DEFAULT_SIZE_NORMAL) * DEFAULT_SIZE_PERCENT/100
rem �����ݒ�ł́A�v���~�A������̏ꍇ�́A100*0.99 = 99 MB�A��ʉ���̏ꍇ�́A40*0.99=39.6 MB
rem �e�ʃI�[�o�[����Ƃ��́uDEFAULT_SIZE_PERCENT=98.5�v�ȂǂƏ��������Ă݂�
set DEFAULT_SIZE_PERCENT=99.0

rem YouTube�p�̐ݒ� (GB)
rem �����128 GB�ł��B (2014�N9��20������)
rem 15�����z���铮��̓��e�ɂ́A�F�؂����āA����������グ��K�v������܂��B(�Œ� 11���ԁB(2014�N9��20������))
set DEFAULT_SIZE_YOUTUBE_PARTNER=128
set DEFAULT_SIZE_YOUTUBE_NORMAL=128
rem YouTube�p��CRF�̐ݒ�́Ay\high.bat ��ҏW���Ďw�肵�Ă�������

rem FLV�pmp3�̗e�ʂ̐ݒ� (MB)
rem �摜(jpg�Apng�Abmp)��mp3���ꏏ�Ƀh���b�v�����ۂ́A(�\�Ȃ�)FLV�𐶐����܂����A���̏ꍇ�AFLV�̃t�@�C���T�C�Y�w�肪�ł��Ȃ����߁A
rem mp3�̃t�@�C���T�C�Y�̏����݂��邱�ƂŁAFLV�̗e�ʂ�100MB�i�v���A�J�j��40MB�i��ʃA�J�j�𒴂��Ă��܂��̂�h���܂��B
rem ���DEFAULT_SIZE_PREMIUM��DEFAULT_SIZE_NORMAL���1.5-2MB�قǏ����������l���w�肵�Ă��������B
set MP3_SIZE_PREMIUM=97
set MP3_SIZE_NORMAL=37

rem �p�X���̐ݒ�i�摜�������̓���D&D�̂Ƃ��͂��̐ݒ�͖����ł��j
rem �����I��1pass��2pass��3pass�ɂ������Ƃ��͂�����M��
rem �uDEFAULT_PASS_**=1�v�uDEFAULT_PASS_**=2�v�uDEFAULT_PASS_**=3�v�ł��ꂼ��1pass�A2pass�A3pass����������
rem �uDEFAULT_PASS_**=0�v�i�f�t�H���g�j���Ǝ�������i2pass��̃r�b�g���[�g����3pass���K�v���𔻒f�j
rem ���x�d���A�o�����X�A�掿�d���̊e�v���Z�b�g���Ƃɐݒ肵�Ă�������
rem SPEED�ABALANCE�AQUALITY�����ꂼ�ꑬ�x�d���A�o�����X�A�掿�d����I�񂾎��̃p�X���ݒ�ɂȂ�܂�
set DEFAULT_PASS_SPEED=1
set DEFAULT_PASS_BALANCE=0
set DEFAULT_PASS_QUALITY=0

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

rem YouTube�p�̃G���R�[�h�̏ꍇ�A�A�b�v���[�h��������̐ݒ�����Ă���ꍇ�͉����uset YTTYPE=y�v�ɁA
rem ���Ă��Ȃ��ꍇ�͉����uset YTTYPE=n�v�ɕς��Ă�������
set YTTYPE=

rem ---------------------------------------------------------------------------------------------------------------------
rem �������牺�́Aa���w�肷��Ǝ����Ő����ݒ�ɂȂ�܂�

rem �v���~�A���A�J�E���g�̏ꍇ�̖ڕW�����r�b�g���[�g(�f��+����)�i�P�ʂ�kbps�A���͗�Fset T_BITRATE=1000�j
set T_BITRATE=

rem ��L�A�����ڕW�r�b�g���[�g���特���r�b�g���[�g���������l��2001 kbps�ȏ�ɂ����ꍇ�A���CRF�G���R�����Ďw�肵���r�b�g���[�g��
rem �ړI�Ƃ���掿�ɑ΂��ĉߏ�ɂȂ��Ă��Ȃ����ǂ������e�X�g���邩�ǂ��� (y/n�A�܂��́Acrf�̐���)
rem YouTube�p��CRF�̒l�́Ay\high.bat ��ҏW���Ďw�肵�Ă�������
set CRF_TEST=

rem �v���Z�b�gt�̏ꍇ�́Ak:�y���d���Am�F�o�����X�Aq�G�掿�d�� ����I��
rem �܂��́Acrf�̐��� ( ���͗�Fset CRFTYPE=m �܂���  set CRFTYPE=23.0 )
set CRFTYPE=

rem �G�R�������ꍇ�͉����uset ENCTYPE=y�v�ɁA�G�R������Ȃ��ꍇ�͉����uset ENCTYPE=n�v�ɕς��Ă�������
set ENCTYPE=

rem ��Đ����׃G���R�ɂ���ꍇ�͉����uset DECTYPE=y�v�ɁA��Đ����׃G���R���Ȃ��ꍇ�͉����uset DECTYPE=n�v�ɕς��Ă�������
set DECTYPE=

rem �������T�C�Y����ꍇ�͉����uset RESIZE=y�v�ɁA���T�C�Y���Ȃ��ꍇ�͉����uset RESIZE=n�v�ɕς��Ă�������
rem �蓮�Ń��T�C�Y����ꍇ�ɂ́A���p�́u:�v��؂�Łu��:�����v����͂��Ă��������B(��: 640:360 ��)
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
rem ���ʒ������Ȃ��ꍇ�́An�B�P�ʂ�dB�B(���͗�Fset A_GAIN=5�j
rem �G���R�[�h���ɒ�����������A���O�ɒ������Ă������Ɛ����Ȃ̂ŁA�ʏ�́An�ŁB
rem A_GAIN=5�Ȃ�A5dB���ʂ��オ��BA_GAIN=-5�Ȃ�A5dB���ʂ�������B
rem �グ�����Ď���ɂ߂Ȃ��悤�ɒ��ӁB�グ������Ɖ����ꂵ�܂����B
set A_GAIN=

rem ����ɍŌ�̊m�F��ʂ��X�L�b�v�������ꍇ�͉����uset SKIP_MODE=true�v�ɕς��Ă�������
set SKIP_MODE=
