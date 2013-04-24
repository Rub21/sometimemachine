--este archivo es para eliminar los puntos que no pertenecen a US 
--eso se realizopara mostrara la seciciones de un dia 20 april 2013 in US


CREATE INDEX osm_changeset_index ON osm_changeset(ogc_fid);

ALTER TABLE osm_changeset ADD COLUMN geom GEOMETRY;
CREATE INDEX geom_osm_changeset_index  ON osm_changeset using gist(geom);

--ALTER TABLE osm_changeset DROP  COLUMN lon RESTRICT;
--ALTER TABLE osm_changeset DROP  COLUMN lat RESTRICT;
--ALTER TABLE osm_changeset DROP COLUMN geom RESTRICT;

  
   
---geometry
  UPDATE osm_changeset
   SET geom=(SELECT ST_PointFromText('POINT(' || lon || ' ' || lat ||')', 4326))
   --WHERE ogc_fid<100;


----------------------------funcion que conprueba si un punto pertenece a US
CREATE OR REPLACE FUNCTION check_contained(_geom Geometry)
RETURNS  boolean
AS $$
DECLARE
	_name VARCHAR(200);
	_bandera boolean;
	BEGIN
		_bandera=false;

		_name=(SELECT name_0 FROM us_admin WHERE st_contains(us_admin.geom, _geom));
		IF (_name IS NULL) THEN	
			_bandera=false;
		ELSE
			_bandera=true;	
		END IF;	
	RETURN _bandera;
	END;
$$ LANGUAGE plpgsql;


--TEST
select check_contained(ST_PointFromText('POINT(-98.711 39.31513)', 4326));
select check_contained(ST_PointFromText('POINT(-12 -74)', 4326));

-------------------------------------------Funccion para eliminar Filas que no estan en US
CREATE OR REPLACE FUNCTION remove_changes(init INTEGER,final INTEGER) 
RETURNS INT
AS $$
DECLARE
	_geom GEOMETRY;
	_bandera boolean;
      
BEGIN		        
        FOR _i IN init..final
        
		LOOP 	
		    RAISE  NOTICE '====================ID=%', _i;
			_geom=(select geom from osm_changeset where ogc_fid=_i);
			_bandera=check_contained(_geom);
			--RAISE  NOTICE '===========================%', _bandera ;
			IF (_bandera=false) THEN
			RAISE  NOTICE '===========================%', 'Elimina' ;			
				DELETE FROM osm_changeset
				WHERE ogc_fid=_i;					 				    
			END IF;				
 
		END LOOP;		
	       RETURN final;
END;
$$ LANGUAGE plpgsql;


--Ejecutar Funcion para ajecutar mmas rapido el procesamiento y aprovechar al maxino La Maquina
--select remove_changes(1,100000);
select remove_changes(1,100000);
select remove_changes(100001,200000);
select remove_changes(200001,300000);
select remove_changes(300001,400000);
select remove_changes(400001,500000);
select remove_changes(500001,600000);
select remove_changes(600001,700000);
select remove_changes(700001,800000);
select remove_changes(800001,900000);
select remove_changes(900001,1000000);

select count(*) from osm_changeset

select * from osm_changeset limit 10 ogc_fid
