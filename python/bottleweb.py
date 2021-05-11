
#coding=utf-8  
from bottle import (run, route, get, post, put, delete, request, hook, response, static_file, app)  
import json  
import MySQLdb #本例子需要操作数据库，否则可以不写这行，这个数据库包pip估计安装不会成功，我是用yum install MySQL-python成功的  
import sys  
reload(sys)    
sys.setdefaultencoding('utf8')  
import bottle  
app = bottle.default_app()#处理静态资源需要定义，没有静态资源可以不写这行  
#搭建vue脚手架前后台联调时要下面两个@hook内容，否则会报跨域访问资源的错误  
@hook('before_request')  
def validate():  
    REQUEST_METHOD = request.environ.get('REQUEST_METHOD')  
    HTTP_ACCESS_CONTROL_REQUEST_METHOD = request.environ.get('HTTP_ACCESS_CONTROL_REQUEST_METHOD')  
    if REQUEST_METHOD == 'OPTIONS' and HTTP_ACCESS_CONTROL_REQUEST_METHOD:  
        request.environ['REQUEST_METHOD'] = HTTP_ACCESS_CONTROL_REQUEST_METHOD  
@hook('after_request')  
def enable_cors():  
    response.headers['Access-Control-Allow-Origin'] = '*'  
    response.headers['Access-Control-Allow-Methods'] = 'GET,POST,PUT,DELETE,OPTIONS'  
    response.headers['Access-Control-Allow-Headers'] = '*'  
@route('/test2020/dist/<path>')#静态资源在web服务下的地址，没放前端的静态资源这几个route和app.route可以不写  
def stat(path):  
    return static_file(path, root='./dist/')  
@app.route('/test2020/dist/static/js/<path>')    
def js(path):  #这几个目录我写成这样是因为vue打包完后目录结构就是dist 里面static等等  
    return static_file(path, root='./dist/static/js/')  
@app.route('/test2020/dist/static/css/<path>')   
def css(path):   
    return static_file(path, root='./dist/static/css/')  
    
@get('/test2020/date')#返回某个表中的日期，看sql你就明白了  
def helloins():  
    db = MySQLdb.connect("127.0.0.1", "yourusername", "yourpassword", "yourDBname", charset='utf8' )  
    cursor = db.cursor()  
    sql = "select DISTINCT date from testtable"  
    print sql  
    cursor.execute(sql)  
    data = cursor.fetchall()  
    jsondata={}  
    results=[]  
    for row in data:  
        result = {}  
        result['DATE'] = row[0]  
        results.append(result)  
    jsondata['code']=0  
    jsondata['datas']=results  
    return jsondata  #返回json格式为了方便前端vue接收处理，其实返回各种类型都可以  
    
@get('/test2020/helloworld')  
def helloworld():  
    return 'hello world!'  
    
if __name__ == '__main__':  
    run(host='0.0.0.0', port=2020, debug=True, reloader=True)  




#pip install bottle 

#python bottleweb.py

