initdb -D $HOME/eaw92 --encoding=KOI8-R --locale=ru_RU.KOI8-R --username=postgres1 --waldir=$HOME/agt19

pg_ctl -D $HOME/eaw92 -l logfile start