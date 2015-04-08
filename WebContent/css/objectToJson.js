function objToJson(obj){
    //花未眠
    //bravfing@126.com
    //2011.8.19
    return _toStr(obj);
}


function _toStr(obj){
    var type = Object.prototype.toString.call(obj).slice(8,-1) , rs;
    
    //如果是html节点(不完全判断,可伪造)
/*    if(obj.nodeType!=null){
        return "HTMLNODE"
    }*/
    
    switch(type){
        case "Undefined" : 
        case "Null" : 
        case "Number" :  
        case "Boolean" : 
        case "Date" : 
        case "Function" :
        case "Error" :
        case "RegExp" :  rs = obj ; break;
        
        case "String" : rs = '"' + obj + '"'; break;
        case "Array" :
            rs = "";
            for(var i=0,len=obj.length;i<len;i++){
                rs+=_toStr(obj[i])+",";
            }
            rs = "[" + rs.slice(0,-1) + "]";
            break;
        
        case "Object" :
            rs = [];    
            for(var k in obj){
                rs.push('"' + k.toString() + '":' + _toStr(obj[k]));
            }
            rs = "{" + rs.join(",") + "}";
            break;
    }
    return rs;
}