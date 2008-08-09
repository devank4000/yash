echo $LINENO
cat <<EOF
some
here
document
EOF
cat <<\END
another
here-document
END
echo $LINENO
echo line \
continuation
echo $LINENO

printlineno () {
	echo function
	echo $LINENO
}
printlineno
echo $LINENO

echo ===== 1 =====

var=var
echo $var
var='v'"a"r
echo $var
var=xxx echo $var

foo='123  456  789'
bar=-${foo}-
echo $bar
echo "$bar"

echo ===== 2 =====

func () {
	var=xyz
	echo $var
}
func
echo $var

echo ===== set export =====

export save="$(env -i foo=123 $INVOKE $TESTEE -c 'bar=456; set')"
$INVOKE $TESTEE -c 'eval $save; echo $foo $bar'

unset save
echo - $save -
echo save ${save-unset}

export var
setvar="$(set | grep '^var=')"
var=123
echo $var
eval "$setvar"
echo $var
exportvar="$(export | grep -E '^export[[:blank:]]+var=')"
unset var
echo var ${var-unset}
eval "$exportvar"
$INVOKE $TESTEE -c 'echo $var'

unset null
export null
exportnull="$(export | grep -E '^export[[:blank:]]+null$')"
unset null
eval "$exportnull"
null=null
$INVOKE $TESTEE -c 'echo $null'

echo ===== readonly =====

readonly var ro=readonly! empty
echo $var $ro -$empty-
(var=no; echo $var) 2>/dev/null
(empty=no; echo -$empty-) 2>/dev/null
(unset var; echo $var) 2>/dev/null
export readonlyvar="$(readonly | grep -E '^readonly[[:blank:]]+var=')"
$INVOKE $TESTEE -s <<\END
eval $readonlyvar
(var=no; echo $var) 2>/dev/null
END
export readonlyempty="$(readonly | grep -E '^readonly[[:blank:]]+empty$')"
$INVOKE $TESTEE -s <<\END
eval $readonlyempty
(empty=no; echo -$empty-) 2>/dev/null
END

echo ===== function unset =====

echo () { :; }
echo ng
unset -f echo
echo ok

echo ===== set shift =====

set 1 2 3 a b c
shift
echo "$@"
shift 2
echo "$@"
shift 4 2>/dev/null || echo shift 4

loop ()
while [ $# -ne 0 ]; do
	echo "$@"
	shift
done
loop x y z
echo "$@"
shift 3
echo $# "$@"

echo ===== read =====

unset IFS a b c d e

read a b c <<END
1 2 3
END
echo "${a-error}"
echo "${b-error}"
echo "${c-error}"

read a b c <<END
1 2 3 4  5
END
echo "${a-error}"
echo "${b-error}"
echo "${c-error}"

read a b c <<END
1 2 3
4 5
END
echo "${a-error}"
echo "${b-error}"
echo "${c-error}"

read a b c <<END
1 2 3\
4  5
6 7
END
echo "${a-error}"
echo "${b-error}"
echo "${c-error}"

read a b c d e <<END
1 2 3
4 5
END
echo "${a-error}"
echo "${b-error}"
echo "${c-error}"
echo "${d-error}"
echo "${e-error}"

echo =====

IFS=- read a b c <<END
1 2\-3-4 5\-6-7\-8-9
END
echo "${a-error}"
echo "${b-error}"
echo "${c-error}"

IFS=- read -r a b c <<\END
1 2\-3-4 5\-6-7\-8-9\
0
END
echo "${a-error}"
echo "${b-error}"
echo "${c-error}"

while read a b
do
	echo $b
done <<END
1 2 3 4
5 6 7 8
9 0 1 2
END

echo ${IFS-unset}
