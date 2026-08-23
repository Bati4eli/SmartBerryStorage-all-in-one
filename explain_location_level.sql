SET jit = off;
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
WITH location_points AS (
    SELECT
        ei.location_id,
        AVG(ei.gps_latitude) AS latitude,
        AVG(ei.gps_longitude) AS longitude,
        MAX(ei.file_id) AS file_id,
        COUNT(*) AS amount,
        MIN(ei.point::geometry) AS point_geom
    FROM exif_info ei
    JOIN file_info fi
        ON fi.file_id = ei.file_id AND fi.user_id = ei.user_id
    WHERE ei.user_id = 100
        AND NOT fi.deleted
        AND fi.nsfw_level >= 0
    GROUP BY ei.location_id
),
clustered_locations AS (
    SELECT
        ST_ClusterDBSCAN(ST_Transform(point_geom, 4326), eps := 4.882882882882883, minpoints := 1) OVER () AS cluster_id,
        location_id,
        latitude,
        longitude,
        file_id,
        amount
    FROM location_points
)
SELECT cluster_id, COUNT(*) AS locations_in_cluster, SUM(amount) AS photos_in_cluster
FROM clustered_locations
GROUP BY cluster_id
ORDER BY cluster_id;
