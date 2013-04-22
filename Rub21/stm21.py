#!/usr/bin/env python

import sqlite3, sys
import xml.parsers.expat
from dateutil.parser import parse

if (len(sys.argv) < 2):
    raise 'Usage: stm.py changeset.osm db.sqlite'

osm_filename = sys.argv[1]
sqlite_filename = sys.argv[2]

print("piping %s -> %s" % (osm_filename, sqlite_filename))

conn = sqlite3.connect(sqlite_filename)

cur = conn.cursor()
print(cur)

# Optimize connection
cur.execute("""PRAGMA synchronous=0""")
cur.execute("""PRAGMA locking_mode=EXCLUSIVE""")
cur.execute("""PRAGMA journal_mode=DELETE""")
print(cur)
#id="207785" lat="52.5240094" lon="-1.8713573" version="4" timestamp="2013-04-19T15:22:11Z"
#changeset="15786682" uid="735" user="blackadder"
query = """insert into osm_changeset
    (user_id, osm_user, lon, lat, timestamp, version, changeset)
    values (?, ?, ?, ?, ?, ?, ?)"""
#print(query)
#print("----------attrib")
def save(attrib):
    attrib_id = int(attrib['id'])
    #print attrib_id
    attrib_user = attrib.get('user', "none")
    print(attrib.get('user'))
    if(int(parse(attrib["timestamp"]).strftime('%s'))>=1364774400): #from 04/20/2013 1366416000
     cur.execute(query,
        (int(attrib.get('uid', -1)),
	    attrib_user,
        float(attrib.get('lon', 0)),
        float(attrib.get('lat', 0)),
        int(parse(attrib["timestamp"]).strftime('%s')),       
        int(attrib['version']),
        int(attrib['changeset'])))
    if (attrib_id % 100000 == 0):
        conn.commit()
        print("%d done===================================" % int(attrib['id']))

def start_element(name, attrs):
    if name == 'node':
        save(attrs)

p = xml.parsers.expat.ParserCreate()
p.StartElementHandler = start_element

p.ParseFile(open(osm_filename))
