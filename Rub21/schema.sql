CREATE TABLE osm_changeset (
  user_id INTEGER,
  osm_user VARCHAR(100),
  lon REAL,
  lat REAL,
  timestamp INTEGER,
  version INTEGER,
  changeset INTEGER
);
