meta_op=`curl -s -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01" | jq '.'`
echo "enter the path of the key to find, eg: a/b/c"
read pathvar
jqpath=''
for i in $pathvar
do
        if [[ $i == '/' ]]
        then
                continue
        else
                jqpath='.'$jqpath$i
        fi
done
echo "path is $jqpath"
(echo "$meta_op" | jq -r "$jqpath")