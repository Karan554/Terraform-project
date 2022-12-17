#!/usr/bin/python3.8

import json
with open('/home/ubuntu/data.json') as f:
        data = json.load(f)
        for i in data['Volumes']:
          a = i["Size"]
          if a == 11:
            ID = i["VolumeId"]
            print(ID)
f.close()