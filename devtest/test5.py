import time
import datetime

with open("E:\devtest\logs\log.log") as file:
    datetime1 = datetime.datetime.strptime(file.readline()[4:23], "%Y-%m-%dT%H:%M:%S")
    timestamp1 = time.mktime(datetime1.timetuple()) + (datetime1.microsecond / 1000000)
    
    sum = 0
    line_count = 0

    line = file.readline()
    eofFlag = True
    if not line:
        eofFlag = False
    while eofFlag:
        datetime2 = datetime.datetime.strptime(line[4:23], "%Y-%m-%dT%H:%M:%S")
        timestamp2 = time.mktime(datetime2.timetuple()) + (datetime2.microsecond / 1000000)

        curr_diff = timestamp2 - timestamp1
        
        line_count+=1
        sum += curr_diff

        timestamp1 = timestamp2
        line = file.readline()
        if not line:
            eofFlag = False
    
    print(sum / line_count)