--Checking if each column has the correct data type based on the values inside.
--This ensures the accuracy for analysis
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'forest_health_data';

--Counting the missing values inside data set if there is one to identify.
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE Latitude IS NULL) AS missing_latitude,
    COUNT(*) FILTER (WHERE Longitude IS NULL) AS missing_longitude,
    COUNT(*) FILTER (WHERE DBH IS NULL) AS missing_dbh,
    COUNT(*) FILTER (WHERE Tree_Height IS NULL) AS missing_tree_height,
    COUNT(*) FILTER (WHERE Crown_Width_North_South IS NULL) AS missing_crown_width_north_south,
    COUNT(*) FILTER (WHERE Crown_Width_East_West IS NULL) AS missing_crown_width_east_west,
    COUNT(*) FILTER (WHERE Slope IS NULL) AS missing_slope,
    COUNT(*) FILTER (WHERE Elevation IS NULL) AS missing_elevation,
    COUNT(*) FILTER (WHERE Temperature IS NULL) AS missing_temperature,
    COUNT(*) FILTER (WHERE Humidity IS NULL) AS missing_humidity,
    COUNT(*) FILTER (WHERE Soil_TN IS NULL) AS missing_soil_TN,
    COUNT(*) FILTER (WHERE Soil_TP IS NULL) AS missing_soil_TP,
    COUNT(*) FILTER (WHERE Soil_AP IS NULL) AS missing_soil_AP,
    COUNT(*) FILTER (WHERE Soil_AN IS NULL) AS missing_soil_AN,
    COUNT(*) FILTER (WHERE Menhinick_Index IS NULL) AS missing_menhinick_index,
    COUNT(*) FILTER (WHERE Gleason_Index IS NULL) AS missing_gleason_index,
    COUNT(*) FILTER (WHERE Disturbance_Level IS NULL) AS missing_disturbance_level,
    COUNT(*) FILTER (WHERE Fire_Risk_Index IS NULL) AS missing_fire_risk_index,
    COUNT(*) FILTER (WHERE Health_Status IS NULL) AS missing_health_status
FROM forest_health_data;


--to detect the outliers, we calculate the minimum, maximum, mean and standard deviation.
--provides summary of basic statistics for each numerical column
--Latitude and Longitude tables are excluded from analysis since they represent geographic coordinates
SELECT MIN(DBH) AS min_dbh, MAX(DBH) AS max_dbh, AVG(DBH) AS avg_dbh, STDDEV(DBH) AS stddev_dbh,
       MIN(Tree_Height) AS min_tree_height, MAX(Tree_Height) AS max_tree_height, AVG(Tree_Height) AS avg_tree_height, STDDEV(Tree_Height) AS stddev_tree_height,
       MIN(Crown_Width_North_South) AS min_crown_width_north_south, MAX(Crown_Width_North_South) AS max_crown_width_north_south, AVG(Crown_Width_North_South) AS avg_crown_width_north_south, STDDEV(Crown_Width_North_South) AS stddev_crown_width_north_south,
       MIN(Crown_Width_East_West) AS min_crown_width_east_west, MAX(Crown_Width_East_West) AS max_crown_width_east_west, AVG(Crown_Width_East_West) AS avg_crown_width_east_west, STDDEV(Crown_Width_East_West) AS stddev_crown_width_east_west,
       MIN(Slope) AS min_slope, MAX(Slope) AS max_slope, AVG(Slope) AS avg_slope, STDDEV(Slope) AS stddev_slope,
       MIN(Elevation) AS min_elevation, MAX(Elevation) AS max_elevation, AVG(Elevation) AS avg_elevation, STDDEV(Elevation) AS stddev_elevation,
       MIN(Temperature) AS min_temperature, MAX(Temperature) AS max_temperature, AVG(Temperature) AS avg_temperature, STDDEV(Temperature) AS stddev_temperature,
       MIN(Humidity) AS min_humidity, MAX(Humidity) AS max_humidity, AVG(Humidity) AS avg_humidity, STDDEV(Humidity) AS stddev_humidity,
       MIN(Soil_TN) AS min_soil_tn, MAX(Soil_TN) AS max_soil_tn, AVG(Soil_TN) AS avg_soil_tn, STDDEV(Soil_TN) AS stddev_soil_tn,
       MIN(Soil_TP) AS min_soil_tp, MAX(Soil_TP) AS max_soil_tp, AVG(Soil_TP) AS avg_soil_tp, STDDEV(Soil_TP) AS stddev_soil_tp,
       MIN(Soil_AP) AS min_soil_ap, MAX(Soil_AP) AS max_soil_ap, AVG(Soil_AP) AS avg_soil_ap, STDDEV(Soil_AP) AS stddev_soil_ap,
       MIN(Soil_AN) AS min_soil_an, MAX(Soil_AN) AS max_soil_an, AVG(Soil_AN) AS avg_soil_an, STDDEV(Soil_AN) AS stddev_soil_an,
       MIN(Menhinick_Index) AS min_menhinick_index, MAX(Menhinick_Index) AS max_menhinick_index, AVG(Menhinick_Index) AS avg_menhinick_index, STDDEV(Menhinick_Index) AS stddev_menhinick_index,
       MIN(Gleason_Index) AS min_gleason_index, MAX(Gleason_Index) AS max_gleason_index, AVG(Gleason_Index) AS avg_gleason_index, STDDEV(Gleason_Index) AS stddev_gleason_index,
       MIN(Disturbance_Level) AS min_disturbance_level, MAX(Disturbance_Level) AS max_disturbance_level, AVG(Disturbance_Level) AS avg_disturbance_level, STDDEV(Disturbance_Level) AS stddev_disturbance_level,
       MIN(Fire_Risk_Index) AS min_fire_risk_index, MAX(Fire_Risk_Index) AS max_fire_risk_index, AVG(Fire_Risk_Index) AS avg_fire_risk_index, STDDEV(Fire_Risk_Index) AS stddev_fire_risk_index
FROM forest_health_data;


--Implementing IQR method, if there are rows/row that fall outside the typical iqr range we will see it as a result
WITH stats AS (
    SELECT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY DBH) AS q1_dbh,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY DBH) AS q3_dbh,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Tree_Height) AS q1_tree_height,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Tree_Height) AS q3_tree_height,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Crown_Width_North_South) AS q1_crown_width_north_south,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Crown_Width_North_South) AS q3_crown_width_north_south,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Crown_Width_East_West) AS q1_crown_width_east_west,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Crown_Width_East_West) AS q3_crown_width_east_west,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Slope) AS q1_slope,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Slope) AS q3_slope,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Elevation) AS q1_elevation,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Elevation) AS q3_elevation,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Temperature) AS q1_temperature,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Temperature) AS q3_temperature,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Humidity) AS q1_humidity,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Humidity) AS q3_humidity,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Soil_TN) AS q1_soil_tn,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Soil_TN) AS q3_soil_tn,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Soil_TP) AS q1_soil_tp,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Soil_TP) AS q3_soil_tp,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Soil_AP) AS q1_soil_ap,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Soil_AP) AS q3_soil_ap,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Soil_AN) AS q1_soil_an,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Soil_AN) AS q3_soil_an,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Menhinick_Index) AS q1_menhinick_index,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Menhinick_Index) AS q3_menhinick_index,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Gleason_Index) AS q1_gleason_index,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Gleason_Index) AS q3_gleason_index,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Disturbance_Level) AS q1_disturbance_level,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Disturbance_Level) AS q3_disturbance_level,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Fire_Risk_Index) AS q1_fire_risk_index,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Fire_Risk_Index) AS q3_fire_risk_index
    FROM forest_health_data
)
SELECT *
FROM forest_health_data, stats
WHERE DBH < (q1_dbh - 1.5 * (q3_dbh - q1_dbh))
   OR DBH > (q3_dbh + 1.5 * (q3_dbh - q1_dbh))
   OR Tree_Height < (q1_tree_height - 1.5 * (q3_tree_height - q1_tree_height))
   OR Tree_Height > (q3_tree_height + 1.5 * (q3_tree_height - q1_tree_height))
   OR Crown_Width_North_South < (q1_crown_width_north_south - 1.5 * (q3_crown_width_north_south - q1_crown_width_north_south))
   OR Crown_Width_North_South > (q3_crown_width_north_south + 1.5 * (q3_crown_width_north_south - q1_crown_width_north_south))
   OR Crown_Width_East_West < (q1_crown_width_east_west - 1.5 * (q3_crown_width_east_west - q1_crown_width_east_west))
   OR Crown_Width_East_West > (q3_crown_width_east_west + 1.5 * (q3_crown_width_east_west - q1_crown_width_east_west))
   OR Slope < (q1_slope - 1.5 * (q3_slope - q1_slope))
   OR Slope > (q3_slope + 1.5 * (q3_slope - q1_slope))
   OR Elevation < (q1_elevation - 1.5 * (q3_elevation - q1_elevation))
   OR Elevation > (q3_elevation + 1.5 * (q3_elevation - q1_elevation))
   OR Temperature < (q1_temperature - 1.5 * (q3_temperature - q1_temperature))
   OR Temperature > (q3_temperature + 1.5 * (q3_temperature - q1_temperature))
   OR Humidity < (q1_humidity - 1.5 * (q3_humidity - q1_humidity))
   OR Humidity > (q3_humidity + 1.5 * (q3_humidity - q1_humidity))
   OR Soil_TN < (q1_soil_tn - 1.5 * (q3_soil_tn - q1_soil_tn))
   OR Soil_TN > (q3_soil_tn + 1.5 * (q3_soil_tn - q1_soil_tn))
   OR Soil_TP < (q1_soil_tp - 1.5 * (q3_soil_tp - q1_soil_tp))
   OR Soil_TP > (q3_soil_tp + 1.5 * (q3_soil_tp - q1_soil_tp))
   OR Soil_AP < (q1_soil_ap - 1.5 * (q3_soil_ap - q1_soil_ap))
   OR Soil_AP > (q3_soil_ap + 1.5 * (q3_soil_ap - q1_soil_ap))
   OR Soil_AN < (q1_soil_an - 1.5 * (q3_soil_an - q1_soil_an))
   OR Soil_AN > (q3_soil_an + 1.5 * (q3_soil_an - q1_soil_an))
   OR Menhinick_Index < (q1_menhinick_index - 1.5 * (q3_menhinick_index - q1_menhinick_index))
   OR Menhinick_Index > (q3_menhinick_index + 1.5 * (q3_menhinick_index - q1_menhinick_index))
   OR Gleason_Index < (q1_gleason_index - 1.5 * (q3_gleason_index - q1_gleason_index))
   OR Gleason_Index > (q3_gleason_index + 1.5 * (q3_gleason_index - q1_gleason_index))
   OR Disturbance_Level < (q1_disturbance_level - 1.5 * (q3_disturbance_level - q1_disturbance_level))
   OR Disturbance_Level > (q3_disturbance_level + 1.5 * (q3_disturbance_level - q1_disturbance_level))
   OR Fire_Risk_Index < (q1_fire_risk_index - 1.5 * (q3_fire_risk_index - q1_fire_risk_index))
   OR Fire_Risk_Index > (q3_fire_risk_index + 1.5 * (q3_fire_risk_index - q1_fire_risk_index));


--z-score implementation.
--Data points that are more than 3 standard deviations away from the mean are considered as outliers.
WITH stats AS (
    SELECT
        AVG(DBH) AS avg_dbh, STDDEV(DBH) AS stddev_dbh,
        AVG(Tree_Height) AS avg_tree_height, STDDEV(Tree_Height) AS stddev_tree_height,
        AVG(Crown_Width_North_South) AS avg_crown_width_north_south, STDDEV(Crown_Width_North_South) AS stddev_crown_width_north_south,
        AVG(Crown_Width_East_West) AS avg_crown_width_east_west, STDDEV(Crown_Width_East_West) AS stddev_crown_width_east_west,
        AVG(Slope) AS avg_slope, STDDEV(Slope) AS stddev_slope,
        AVG(Elevation) AS avg_elevation, STDDEV(Elevation) AS stddev_elevation,
        AVG(Temperature) AS avg_temperature, STDDEV(Temperature) AS stddev_temperature,
        AVG(Humidity) AS avg_humidity, STDDEV(Humidity) AS stddev_humidity,
        AVG(Soil_TN) AS avg_soil_tn, STDDEV(Soil_TN) AS stddev_soil_tn,
        AVG(Soil_TP) AS avg_soil_tp, STDDEV(Soil_TP) AS stddev_soil_tp,
        AVG(Soil_AP) AS avg_soil_ap, STDDEV(Soil_AP) AS stddev_soil_ap,
        AVG(Soil_AN) AS avg_soil_an, STDDEV(Soil_AN) AS stddev_soil_an,
        AVG(Menhinick_Index) AS avg_menhinick_index, STDDEV(Menhinick_Index) AS stddev_menhinick_index,
        AVG(Gleason_Index) AS avg_gleason_index, STDDEV(Gleason_Index) AS stddev_gleason_index,
        AVG(Disturbance_Level) AS avg_disturbance_level, STDDEV(Disturbance_Level) AS stddev_disturbance_level,
        AVG(Fire_Risk_Index) AS avg_fire_risk_index, STDDEV(Fire_Risk_Index) AS stddev_fire_risk_index
    FROM forest_health_data
)
SELECT *
FROM forest_health_data, stats
WHERE ABS((DBH - avg_dbh) / stddev_dbh) > 3 OR
     ABS((Tree_Height - avg_tree_height) / stddev_tree_height) > 3 OR
     ABS((Crown_Width_North_South - avg_crown_width_north_south) / stddev_crown_width_north_south) > 3 OR
     ABS((Crown_Width_East_West - avg_crown_width_east_west) / stddev_crown_width_east_west) > 3 OR
     ABS((Slope - avg_slope) / stddev_slope) > 3 OR
     ABS((Elevation - avg_elevation) / stddev_elevation) > 3 OR
     ABS((Temperature - avg_temperature) / stddev_temperature) > 3 OR
     ABS((Humidity - avg_humidity) / stddev_humidity) > 3 OR
     ABS((Soil_TN - avg_soil_tn) / stddev_soil_tn) > 3 OR
     ABS((Soil_TP - avg_soil_tp) / stddev_soil_tp) > 3 OR
     ABS((Soil_AP - avg_soil_ap) / stddev_soil_ap) > 3 OR
     ABS((Soil_AN - avg_soil_an) / stddev_soil_an) > 3 OR
     ABS((Menhinick_Index - avg_menhinick_index) / stddev_menhinick_index) > 3 OR
     ABS((Gleason_Index - avg_gleason_index) / stddev_gleason_index) > 3 OR
     ABS((Disturbance_Level - avg_disturbance_level) / stddev_disturbance_level) > 3 OR
     ABS((Fire_Risk_Index - avg_fire_risk_index) / stddev_fire_risk_index) > 3;

--you should not be able to see any data from the last 2 query(z-score and IQR).

