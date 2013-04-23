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

# Optimize connection
cur.execute("""PRAGMA synchronous=0""")
cur.execute("""PRAGMA locking_mode=EXCLUSIVE""")
cur.execute("""PRAGMA journal_mode=DELETE""")
query = """insert into osm_changeset
    (rowid, user_id, osm_user, lon, lat, timestamp, version, changeset)
    values (?, ?, ?, ?, ?, ?, ?, ?)"""

counter = 0
def save(attrib):
    global counter
    
    print counter 
    #attrib_id = int(attrib['id'])    
    attrib_user = attrib.get('user', "none")
    print (int(parse(attrib["timestamp"]).strftime('%s')))
    if((int(parse(attrib["timestamp"]).strftime('%s'))>=1366416000) & (int(parse(attrib["timestamp"]).strftime('%s'))<1366502400)): #from 04/20/2013 1366416000
     counter = counter +1
     cur.execute(query,
        (counter,
        int(attrib.get('uid', -1)),
	    attrib_user,
        float(attrib.get('lon', 0)),
        float(attrib.get('lat', 0)),
        int(parse(attrib["timestamp"]).strftime('%s')),       
        int(attrib['version']),
        int(attrib['changeset'])))
    if ((counter % 100000 == 0) | (counter == 1158216)):
       conn.commit()
       print("%d done===================================================================" % counter)

def start_element(name, attrs):
    if name == 'node':
        save(attrs)

p = xml.parsers.expat.ParserCreate()
p.StartElementHandler = start_element

p.ParseFile(open(osm_filename))
