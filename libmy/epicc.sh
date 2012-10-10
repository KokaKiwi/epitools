#!/bin/bash
## epicc.sh for epicc_libmy in /home/hervie_g/epitools/libmy
## 
## Made by guillaume hervier
## Login   <hervie_g@epitech.net>
## 
## Started on  Tue Oct  9 10:17:48 2012 guillaume hervier
## Last update Wed Oct 10 15:29:01 2012 guillaume hervier
##

source ./config.sh

USAGE="$0 <create|edit|compile|norme|rendu|list|clean|help [command]>"

if [ $# == 0 ]; then
    echo $USAGE
    exit 0
fi

function help {
    if [ "$1" != "" ]; then
	echo "Help for '$1':"
	case $1 in
	    "create")
		;;
	esac
    else
	echo $USAGE
    fi
    exit 0
}

case $1 in
    "create")
	if [ $# = 1 ]; then
	    help "create"
	fi
	FN_DIR=fn_$2
	mkdir -p $FN_DIR
	touch $FN_DIR/$2.c
	cat << EOF > $FN_DIR/conf.sh
FN_NAME=$2
EOF

	echo "Done."
	;;
    "edit")
	if [ $# = 1]; then
	    help "edit"
	fi

	FN_DIR=fn_$2
	emacs -nw $FN_DIR/$2.c
	;;
    "compile")
	FN_PATTERN="fn_*"
	BUILD_DIR="target"
	
	rm -rf $BUILD_DIR libmy.a
	mkdir $BUILD_DIR
	
	for d in `find -type d -name "$FN_PATTERN"`; do
	    source $d/conf.sh

	    cc -c -o $BUILD_DIR/$FN_NAME.o $d/$FN_NAME.c 
	done
	ar rc libmy.a target/*.o
	ranlib libmy.a
	;;
    "norme")
	FN_PATTERN="fn_*"

	for d in `find -type d -name "$FN_PATTERN"`; do
	    source $d/conf.sh

	    NORME=`~/epitools/norme.py $d/$FN_NAME.c -score`
	    printf "%25s : %s\n" "$FN_NAME" "$NORME"
	done
	;;
    "list")
	FN_PATTERN="fn_*"

	for d in `find -type d -name "$FN_PATTERN"`; do
	    source $d/conf.sh

	    printf "%-8s\n" "$FN_NAME"
	done | column
	;;
    "test")
	cc main.c -L. -lmy -I/home/hervie_g/epitest/include
	./a.out
	;;
    "rendu")
	cp libmy.a ~/afs/rendu/lib/my
	echo "Done."
	;;
    "clean")
	rm -rf target
	find . -depth \( -name "*~" -o -name "#*#" \) -type f -delete
	;;
    "help")
	help $2
	;;
esac
