SET jit = off;
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
WITH clustered_points AS (
    SELECT
        ST_ClusterDBSCAN(ST_Transform(ei.point::geometry, 4326), eps := 4.882882882882883, minpoints := 1) OVER () AS cluster_id,
        ei.file_id,
        ei.gps_latitude,
        ei.gps_longitude,
        ei.location_id
    FROM exif_info ei
    JOIN file_info fi
        ON fi.file_id = ei.file_id AND fi.user_id = ei.user_id
    WHERE ei.user_id = 100
        AND NOT fi.deleted
        AND fi.nsfw_level >= 0
),
cluster_stats AS (
    SELECT cluster_id AS album_id, AVG(gps_latitude) AS latitude, AVG(gps_longitude) AS longitude, MAX(file_id) AS file_id, COUNT(*) AS amount
    FROM clustered_points
    GROUP BY cluster_id
),
cluster_names AS (
    SELECT cp.cluster_id AS album_id,
           COALESCE(
             CASE WHEN (COUNT(DISTINCT NULLIF(TRIM(raw_road), '')) = 1 AND COUNT(raw_road) = COUNT(*)) THEN MIN(NULLIF(TRIM(raw_road), '')) END,
             CASE WHEN (COUNT(DISTINCT NULLIF(TRIM(raw_allotments), '')) = 1 AND COUNT(raw_allotments) = COUNT(*)) THEN MIN(NULLIF(TRIM(raw_allotments), '')) END,
             CASE WHEN (COUNT(DISTINCT NULLIF(TRIM(raw_suburb), '')) = 1 AND COUNT(raw_suburb) = COUNT(*)) THEN MIN(NULLIF(TRIM(raw_suburb), '')) END,
             CASE WHEN (COUNT(DISTINCT NULLIF(TRIM(raw_town), '')) = 1 AND COUNT(raw_town) = COUNT(*)) THEN MIN(NULLIF(TRIM(raw_town), '')) END,
             CASE WHEN (COUNT(DISTINCT NULLIF(TRIM(raw_village), '')) = 1 AND COUNT(raw_village) = COUNT(*)) THEN MIN(NULLIF(TRIM(raw_village), '')) END,
             CASE WHEN (COUNT(DISTINCT NULLIF(TRIM(raw_county), '')) = 1 AND COUNT(raw_county) = COUNT(*)) THEN MIN(NULLIF(TRIM(raw_county), '')) END,
             CASE WHEN (COUNT(DISTINCT NULLIF(TRIM(raw_province), '')) = 1 AND COUNT(raw_province) = COUNT(*)) THEN MIN(NULLIF(TRIM(raw_province), '')) END,
             CASE WHEN (COUNT(DISTINCT NULLIF(TRIM(city_place_name), '')) = 1 AND COUNT(city_place_name) = COUNT(*)) THEN MIN(NULLIF(TRIM(city_place_name), '')) END,
             CASE WHEN (COUNT(DISTINCT NULLIF(TRIM(state), '')) = 1 AND COUNT(state) = COUNT(*)) THEN MIN(NULLIF(TRIM(state), '')) END,
             CASE WHEN (COUNT(DISTINCT NULLIF(TRIM(region), '')) = 1 AND COUNT(region) = COUNT(*)) THEN MIN(NULLIF(TRIM(region), '')) END,
             CASE WHEN (COUNT(DISTINCT NULLIF(TRIM(country), '')) = 1 AND COUNT(country) = COUNT(*)) THEN MIN(NULLIF(TRIM(country), '')) END,
             'Unknown') AS album_name
    FROM (SELECT DISTINCT cluster_id, location_id FROM clustered_points) cp
    JOIN location l ON l.location_id = cp.location_id
    GROUP BY cp.cluster_id
)
SELECT cs.album_id, cn.album_name, cs.latitude, cs.longitude, cs.file_id, cs.amount
FROM cluster_stats cs
JOIN cluster_names cn ON cn.album_id = cs.album_id
ORDER BY cs.album_id;
