rem �v���Z�b�g�p�I�v�V�����ݒ�i���d�j 

rem #####�ݒ�t�@�C���Ǘ��p######
set USER_PRESETX=1
rem #############################

set BFRAMES=8
set B_ADAPT=2
set B_PYRAMID=normal
set REF=8
set RC_LOOKAHEAD=60
set QPSTEP=12
set AQ_MODE=2
set AQ_STRENGTH=0.80
set ME=tesa
set SUBME=11
set PSY_RD=0.8:0
set TRELLIS=2

rem CRF�̒l���w�肵���ꍇ�́A�V���O���p�X�̕i���VBR�ŃG���R���܂��B
rem �w�肵�Ȃ��ꍇ�̓}���`�p�X�̃r�b�g���[�g�w��ŃG���R
set CRF=

rem ���̑��蓮�w��Œǉ��������I�v�V����������ꍇ�̓X�y�[�X�ŋ�؂�Ȃ���ǉ�
set MISC=--slow-firstpass --merange 24 --partitions all --no-fast-pskip --no-dct-decimate 
