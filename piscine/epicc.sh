#!/bin/bash
## epicc.sh for epicc.sh in /home/hervie_g/epitools/piscine
## 
## Made by guillaume hervier
## Login   <hervie_g@epitech.net>
## 
## Started on  Thu Oct  4 17:40:48 2012 guillaume hervier
## Last update Wed Oct 10 11:55:33 2012 guillaume hervier
##

source ./config.sh

USAGE="$0 <create|edit|norme|rendu|test|fix|conf|help <command>>"

if [ $# == 0 ]; then
    echo $USAGE
fi

function rendu {
    if [ -e "$1/.pproject" ]; then
	if [ "$1" == "${1/skel/}" ]; then
	    source $1/conf.sh

	    echo "Rendering ${EXO_FUNCNAME}..."
	    echo "- Copying '$1/code.c' to '$RENDU_DIR/$EXO_DIR/$EXO_FILENAME'"
	    echo ""
	    cp $1/code.c $RENDU_DIR/$EXO_DIR/$EXO_FILENAME
	fi
    fi
}

function help {
    if [ "$1" != "" ]; then
	echo "Help for '$1':"
	case $1 in
	    "create")
		echo "$0 create <folder> <function name>"
		;;
	    "edit")
		echo "$0 edit <folder> <filename (without .c)"
		;;
	    "norme")
		echo "$0 norme <folder>"
		;;
	    "rendu")
		echo "$0 rendu [folder search pattern] - Ex: $0 rendu 'exo*'"
		;;
	    "test")
		echo "$0 test <folder>"
		;;
	    "help")
		echo "$0 help <command>"
		;;
	    "clean")
		echo "$0 clean"
		;;
	    "conf")
		echo "$0 conf <folder>"
		;;
	    "fix")
		echo "$0 fix <folder> <function name>"
		;;
	esac
    else
	echo $USAGE
    fi
    exit 0
}

case $1 in
    "create")
	if [ $# -lt 3 ]; then
	    help "create"
	fi
	cp -r skel $2
	touch $2/.pproject

	find $2 -type f -exec sed -i "s/FNAME/$3/g" {} \;
	find $2 -type f -exec sed -i "s/DAY/$DAY/g" {} \;
	find $2 -type f -exec sed -i "s/DDIR/$2/g" {} \;
	echo "Done."
	;;
    "fix")
	if [ $# -le 2 ]; then
	    help "fix"
	fi
	cp skel/conf.sh $2/conf.sh

	sed -i "s/FNAME/$3/g" $2/conf.sh
	sed -i "s/DDIR/$2/g" $2/conf.sh
	;;
    "edit")
	if [ $# = 1 ]; then
	    help "edit"
	fi

	EXO_FILE="code"

	if [ $# = 3 ]; then
	    EXO_FILE=$3
	fi
	
	emacs -nw $2/$EXO_FILE.c
	;;
    "conf")
	if [ $# = 1 ]; then
	    help "conf"
	fi

	emacs -nw $2/conf.sh
	;;
    "norme")
	if [ $# = 1 ]; then
	    help "norme"
	fi
	python $NORME_EXECUTABLE_PATH $2/code.c $NORME_ARGS
	;;
    "rendu")
	EXO_SEARCH="*"

	if [ $# = 2 ]; then
	    EXO_SEARCH=$2
	fi

	for d in `find -type d -name "$EXO_SEARCH"`
	do
	    rendu $d
	done
	echo "Done."
	;;
    "test")
	if [ $# = 1 ]; then
	    help "test"
	fi
	cc $2/code.c $2/main.c -o $2/a.out -L/home/hervie_g/epitest/libmy -lmy -I/home/hervie_g/epitest/include

	_ARGS=""
	args=("$@")

	for (( i = 2 ; i < $# ; i++ )); do
	    arg=${args[$i]}
	    _ARGS="$_ARGS \"$arg\""
	done

	bash -c "$2/a.out $_ARGS"
	;;
    "help")
	help $2
	;;
    "clean")
	find . -depth \( -name "*~" -o -name "#*#" \) -type f -delete
	;;
esac
