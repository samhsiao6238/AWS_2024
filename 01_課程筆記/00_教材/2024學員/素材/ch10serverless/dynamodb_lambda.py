import boto3
bucket_name = '202208292'
def query_test(event, context):
    print ("Dynamodb-table.html已建立"+'\n')
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('db202208292')
    response = table.scan()
    tests = response['Items']
    table_header = ['Platform','Synchronize', 'Asyn', 'Hybrid’]
   file_name = 'Dynamodb-table.html'
    fileout = open("/tmp/"+file_name, "w")
    table = "<table align='center' border='3' border cellpadding='10' cellspacing='0'>\n"
    data="Platform,Synchronize,Asyn,Hybrid"  
    header = data.split(",")
    table += " <tr><font size='5'>\n"
    for column in header:
        table += " <th>{0}</th>\n".format(column.strip())
    table += " </fone></tr>\n"
    for test in tests:
        line=test['Platform']+","+str(test['Synchronize'])+","+str(test['Asyn'])+","+str(test['Hybrid'])
        row = line.split(",")
        table += " <tr align=center><font size='3'>\n"
        for column in row:
            table += " <td>{0}</td>\n".format(column.strip())
        table += " </fone></tr>\n"
    table += "</table>"
    fileout.writelines(table)
    fileout.close()
    s3 = boto3.resource('s3') 
    with open("/tmp/"+file_name, "rb") as f:
        s3.Object(bucket_name, file_name).upload_fileobj(f)

if __name__ == '__main__':
    query_test()