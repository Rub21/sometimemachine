#!/usr/bin/env python

import sys
import xml.parsers.expat
from dateutil.parser import parse
import json

if (len(sys.argv) < 2):
    raise 'Usage: stm.py changeset.osm changeset.json'

osm_filename = sys.argv[1]
json_filename = sys.argv[2]

print("piping %s -> %s" % (osm_filename, json_filename))

geojson = { "type": "FeatureCollection", "features": [] }
counter = 0
def save(attrib):
    global counter
    counter = counter +1   
    print counter  
    attrib_user = attrib.get('user', "none")
    pt = {
            "type": "Feature",
            "geometry": {
                "type": 'Point',
                "coordinates": [float(attrib.get('lon', 0)), float(attrib.get('lat', 0))]
            },
            "properties": {
                "user": attrib_user,
                "version": int(attrib['version']),
                "timestamp": int(parse(attrib["timestamp"]).strftime('%s'))
            }
        } 
    geojson['features'].append(pt)
    if ((counter % 100000 == 0) | (counter == 1158216)):
        json.dump(geojson, open(json_filename, 'w'))
        print("%d done===================================================================" % counter)   


def start_element(name, attrs):
    if name == 'node':
        save(attrs)

p = xml.parsers.expat.ParserCreate()
p.StartElementHandler = start_element

p.ParseFile(open(osm_filename))

