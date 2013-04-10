---
layout: post
title: Converting to and from Google map tile coordinates in PostGIS
published: true
author: pete
tags:
- postgis
- sql
---

Google Maps' system of power-of-two tiles has become a defacto standard, widely used by all sorts of web mapping software. I've found it handy to use as a caching scheme for our data, but the PostGIS calls to use it were getting pretty messy, so I wrapped them up in a few functions. The code is up at https://github.com/petewarden/postgis2gmap, and here's a quick rundown:

**tile_indices_for_lonlat(lonlat geography, zoom_level int)**

Takes a PostGIS latitude/longitude point and a zoom level, and returns a geometry object where the X component is the longitude index of the tile, and the Y component is the latitude index. These values are not rounded, so for a lot of purposes you'll need to FLOOR() them both, eg;

    SELECT FLOOR(X(tile_indices_for_lonlat(checkins.lonlat, 4))) AS grid_lon, FLOOR(Y(tile_indices_for_lonlat(checkins.lonlat, 4))) AS grid_lat FROM checkins;

**lonlat_for_tile_indices(lat_index float8, lon_index float8, zoom_level int)**

Does the inverse of the function above, turning a Google Maps tile index for a given zoom level into a PostGIS geometry point. You may notice that the coordinates are given as separate arguments rather than a single geometry object. That's an artifact of how my data is stored. Here's an example:

    SELECT X(lonlat_for_tile_indices(6, 2, 4)::geometry), Y(lonlat_for_tile_indices(6, 2, 4)::geometry);

**bounds_for_tile_indices(lat_index float8, lon_index float8, zoom_level int)**

This takes latitude and longitude coordinates for a tile, and a zoom level, and returns a geography object containing the bounding box for that tile. I mainly use this for limiting queries on geographic data to a particular tile, eg;

    SELECT * FROM checkins WHERE ST_Intersects(lonlat, bounds_for_tile_indices(6, 2, 4);