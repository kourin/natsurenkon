set USER_VERSION=28

rem �G���R�[�h���̂��̂Ɋ֘A����ݒ�́Aenc_setting.bat �ɂ���܂�
rem �����l���킩��Ȃ��Ȃ����ꍇ�́Atemplate\user_setting_template.bat���R�s�[���Ă��������B
rem ���������牺��K���ɘM���Ď����D�݂̐ݒ�ɂ��Ă���������

rem �w�i�F�̑I��
rem �uBG_COLOR=F0�v�i���n�ɍ������j�A�uBG_COLOR=07�v�i���n�ɔ�����)
rem ���Ɏw��ł���F�ɂ��ẮA�R�}���h�v�����v�g�ŁAcolor /? �Ɠ��͂��Ē��ׂĂ��������B
set BG_COLOR=07

rem �����̑I��
call ..\setting\message_tsundere.bat
rem �f�t�H���g�̃c���f���ȊO�ɂ������ꍇ�́ucall�v�̑O�́urem�v���폜���Ă�������
rem �m�[�}������
rem call ..\setting\message_normal.bat 
rem �ł�ł��
rem call ..\setting\message_deredere.bat 
rem �C�����
rem call ..\setting\message_shuzo.bat
rem �������ŃJ�X�^�}�C�Y�����ꍇ�̓t���p�X�Ŏw�肵�Ă������� 
rem ���L�͗�ł��B�L����󔒂��܂܂�Ă���Ɛ��퓮�삵�Ȃ���������܂���
rem call "C:\encode\message_custom.bat"

rem �����̗L��
rem �ꕔ�̃��b�Z�[�W��ǂݏグ�܂�
rem ��������Ȃ�uVOICE=true�v�A�����Ȃ��Ȃ�uVOICE=false�v
set VOICE=true

rem �����̑I��
rem �f�t�H���g�̂��Ƃ�������ȊO�ɂ������ꍇ�́uset�v�̑O�́urem�v���폜���Ă�������
rem ���Ƃ�������
set VOICE_DIR=sasara_mp3
rem �������
rem set VOICE_DIR=tsundere_mp3
rem ore (���[�U�[�����)
rem set VOICE_DIR=ore_mp3

rem ����̉�����Extra\Voice\default�ɂ�����̂Ɠ����t�@�C�����ŗp�ӂ��邱�ƂŃJ�X�^�}�C�Y�\�ł�
rem �g�p���Ă���{�C�X�̈ꗗ�́AExtra\Voice\VOICE_list.txt �ɂ���܂�
rem ����̃{�C�X���g�������ꍇ�́AExtra\Voice �̉��Ƀt�H���_������āA�t�H���_�����L�q���Ă��������B
rem ���L�͗�ł��B�L����󔒂��܂܂�Ă���Ɛ��퓮�삵�Ȃ���������܂���
rem VOICE_DIR=MyVoice
rem (���܂̂Ƃ���A���̏ꏊ�Ƀ{�C�X�t�@�C����u���ăt���p�X�������Ƃ����Ă������܂���B)

rem �G���R�[�h�I���̂��m�点���́A���̃t�@�C����ҏW����̂ł͂Ȃ�
rem end_sound_setting.bat�ōs�����Aend_sound.txt�Ƀt���p�X�ŋL�����Ă�������

rem �G���R�[�h���wav�t�@�C�����c�����ǂ���
rem �f�t�H���g(�uKEEPWAV=y�v�ł͉��Y���C���p��wav���c���܂�
rem �s�v�ȏꍇ�́A�uKEEPWAV=n�v�ɂ��Ă�������
set KEEPWAV=y

rem �G���R�[�h��Ƀv���C���[���J�����ǂ����i�J���ꍇ��y�A�J���Ȃ��ꍇ��n�j
rem �ق��̃v���C���[�Ō���ƁA�j�R�j�R�����Ō���Ƃ��ƌ��������Ⴄ�ꍇ������̂�
rem �f�t�H���g��y�������߂��܂�
set MOVIE_CHECK=y

rem �G���R�[�h��ɊJ���v���[���[�̃X�^�C���B
rem �uPLAYER_MODE=NEW�v���ƃj�R�j�R����Q�d�l�B�uPLAYER_MODE=OLD�v���ƁA�j�R�j�R����(���h)�d�l�B
set PLAYER_MODE=NEW

rem ����̊m�F�Ɏg�p����u���E�U
rem �f�t�H���g�̃u���E�U�ŊJ���ꍇ�́A�uCBROWSER=�v��
rem �f�t�H���g�ȊO�̃u���E�U�ŊJ�������ꍇ�́A�t���p�X�ŋL�q
set CBROWSER=

rem �ȉ��A�ݒ肷��ꍇ�̗�B�Y���̍s�̖`����rem���폜����Γ����͂��B�C���X�g�[���ꏊ��ύX���Ă����ꍇ�͏��������Ă�������
rem set CBROWSER="%ProgramFiles%\Internet Explorer\iexplore.exe"
rem set CBROWSER="%ProgramFiles(x86)%\Internet Explorer\iexplore.exe"
rem set CBROWSER="%ProgramFiles%\Mozilla Firefox\firefox.exe"
rem set CBROWSER="%ProgramFiles(x86)%\Mozilla Firefox\firefox.exe"
rem set CBROWSER="%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe"
rem set CBROWSER="%ProgramFiles%\Opera\Opera.exe"
rem set CBROWSER="%ProgramFiles(x86)%\Opera\Opera.exe"
rem set CBROWSER="%ProgramFiles%\Safari\safari.exe"
rem set CBROWSER="%ProgramFiles(x86)%\Safari\safari.exe"

rem �v���L�V�ݒ�
rem �l�b�g���[�N�ڑ���proxy�̐ݒ肪�K�v�ȏꍇ�͎w�肵�Ă�������
rem �T�[�o�[[:�|�[�g] ��F wwwcache.example.com �܂��� wwwcache.example.com:8080
rem �����ݒ�X�N���v�g�ɂ͖��Ή�
rem �F�؂��K�v�ȏꍇ�́APROXY=wwwcache.example.com:8080 --proxy-user user:pass  (:pass�͏ȗ���)
set PROXY=

rem �����o�[�W�����`�F�b�N�@�\�̐ݒ�
rem �I���ɂ���ꍇ�́uDEFAULT_VERSION_CHECK=true�v�ɂ���i�f�t�H���g�������������j
rem �I�t�ɂ���ꍇ�́uDEFAULT_VERSION_CHECK=false�v�ɂ���i�������u��v�����j
set DEFAULT_VERSION_CHECK=true

rem �t�@�C���̏o�͐�̎w��i�f�t�H���g�����j
rem �w�肵���t�H���_�ɓ�����mp4������ꍇ�͈ȑO�̃t�@�C����old.mp4�ɕς��Ă��܂��܂�
rem �܂��p�X�A�t�@�C�����ɓ��{�ꂪ����ꍇ�͕s����N����ꍇ������܂�
set MP4_DIR=..\MP4

rem 8.3�`���̒Z���t�@�C�����̎g�p
rem 8.3�`���̒Z���t�@�C�����𐶐����Ȃ��悤�ɐݒ肵�Ă�����́A�uSHORTNAME=false�v�ɂ��Ă�������
rem ���̏ꍇ�A�t�@�C������p�X�Ɉꕔ�̋L���Ȃǂ��g���Ă���ƃ��l�[������悤�Ɍ����邱�Ƃ�����܂�
set SHORTNAME=true

rem �G���R�[�h�I����̋����i�f�t�H���g��n�����j
rem n���Ƃ��̂܂�(MP4�t�H���_���J���ɍs���܂�)�Ao����120�b�ҋ@��ɃV���b�g�_�E��
rem �����o�ɕς������Ƃő��̃A�v���P�[�V�����̖��ۑ��̃f�[�^�������Ă��ӔC�͎��܂���
set SHUTYPE=n
