#!/bin/bash
[ "$DEBUG" = "YES" ] && set -x

[ -n "$1" ] && source $1

U=$(basename $1 .conf)

[ -n "$U" ] || exit 1

D=$U-root


up()
{
				mkdir -p $D/EMPTY
				[ -f $D/bin/bash ] || \
				for i in bin etc lib lib64 sbin usr home tmp
				do
					case $i in
						# empty dir for later mount of writable dir
						home)
							mkdir -p $D/$i
							;;
						# rw mount
						tmp)
							mkdir -p $D/$i
							mount -o rbind /$i $D/$i
							;;
						# ro mount
						*)
							mkdir -p $D/$i
							mount -o rbind /$i $D/$i
							mount -o remount,ro,rbind $D/$i
							;;
					esac
				done

				[ -f $D/home/$U/.profile ] || \
				mkdir -p $D/home/$U
				mount -o rbind $H/$U $D/home/$U

				for i in $P
				do
					mkdir -p $D/DATA/$i
					mount -o rbind $i $D/DATA/$i
				done

				for i in $F
				do
					mount -o bind $D/EMPTY $D$F
				done
}

down()
{
				for i in $P
				do
					umount $D/DATA$i
				done

				for i in $F
				do
					umount $D$F
				done

				umount $D/home/$U

				umount $D/home

				umount $D/*

				echo ======
				[ -n "$(find $D -type f 2>/dev/null)" ] && echo FAILED || echo OK
}

$2 2>log.err
