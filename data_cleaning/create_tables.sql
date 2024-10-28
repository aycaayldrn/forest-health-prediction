--creation of tables under the column name
CREATE TABLE forest_health_data (
    Plot_ID SERIAL PRIMARY KEY,
    Latitude DECIMAL,
    Longitude DECIMAL,
    DBH DECIMAL,
    Tree_Height DECIMAL,
    Crown_Width_North_South DECIMAL,
    Crown_Width_East_West DECIMAL,
    Slope DECIMAL,
    Elevation DECIMAL,
    Temperature DECIMAL,
    Humidity DECIMAL,
    Soil_TN DECIMAL,
    Soil_TP DECIMAL,
    Soil_AP DECIMAL,
    Soil_AN DECIMAL,
    Menhinick_Index DECIMAL,
    Gleason_Index DECIMAL,
    Disturbance_Level DECIMAL,
    Fire_Risk_Index DECIMAL,
    Health_Status VARCHAR(20)
);

