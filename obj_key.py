import json
def obj_key(object1,key1):
    val = 'object1'
    for i in key1:
        if i == '/':
            continue
        else:
            val = val+'[\''+i+'\']'
    try:
        finalval= eval(val)
        return "value is : "+ finalval
    except:
        finalval=  "ERROR: Wrong input, no such key found"
        return finalval

object1 = input("enter the object: ")
key1 = input("enter the key: ")
if key1 == "" or object1 == "":
    print("ERROR: Input can't be empty")
else:
    obj=json.loads(object1)
    val = obj_key(obj,key1)
    print(val)