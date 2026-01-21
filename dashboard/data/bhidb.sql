-- SQL schema for BHI database
-- Complete schema for bhi.db

CREATE TABLE [IndexScores] (
  [region_id] INT,
  [dimension] TEXT,
  [goal] TEXT,
  [score] REAL,
  [year] INTEGER,
  PRIMARY KEY (region_id, dimension, goal, year)
) WITHOUT ROWID;

CREATE TABLE [Regions] (
  [region_id] INT PRIMARY KEY,
  [subbasin] TEXT,
  [eez] TEXT,
  [region_name] TEXT,
  [area_km2] REAL,
  [region_order] INTEGER,
  FOREIGN KEY (region_id) REFERENCES IndexScores (region_id)
) WITHOUT ROWID;

CREATE TABLE [Subbasins] (
  [helcom_id] NVARCHAR,
  [region_id] INT PRIMARY KEY,
  [subbasin] TEXT,
  [area_km2] REAL,
  [subbasin_order] INTEGER,
  FOREIGN KEY (region_id) REFERENCES IndexScores (region_id)
) WITHOUT ROWID;

CREATE UNIQUE INDEX idx_subbasin ON Subbasins (subbasin);

CREATE TABLE [Goals] (
  [goal] TEXT PRIMARY KEY,
  [goal_name] TEXT,
  [description] TEXT,
  FOREIGN KEY (goal_name) REFERENCES Pressures (goal_name),
  FOREIGN KEY (goal_name) REFERENCES Resilience (goal_name),
  FOREIGN KEY (goal) REFERENCES IndexScores (goal)
) WITHOUT ROWID;

CREATE TABLE [FlowerConf] (
  [goal] TEXT PRIMARY KEY,
  [parent] TEXT,
  [name_flower] TEXT,
  [petalweight] REAL,
  [order_hierarchy] REAL,
  FOREIGN KEY (goal) REFERENCES Goals (goal)
) WITHOUT ROWID;

CREATE TABLE [DataSources] (
  [goal] TEXT,
  [dataset] TEXT,
  [description] TEXT,
  [source] TEXT,
  PRIMARY KEY (goal, dataset),
  FOREIGN KEY (goal) REFERENCES FlowerConf (goal)
);

CREATE TABLE [Pressures] (
  [goal_name] TEXT,
  [layer] NVARCHAR,
  [weight] INTEGER,
  PRIMARY KEY (goal_name, layer)
) WITHOUT ROWID;

CREATE TABLE [Resilience] (
  [goal_name] TEXT,
  [layer] NVARCHAR,
  [weight] INTEGER,
  [category] NVARCHAR,
  [category_type] NVARCHAR,
  [subcategory] NVARCHAR,
  PRIMARY KEY (goal_name, layer)
) WITHOUT ROWID;

CREATE TABLE [DataLayers] (
  [layer] NVARCHAR PRIMARY KEY,
  [full_layer_name] TEXT,
  FOREIGN KEY (layer) REFERENCES Pressures (layer),
  FOREIGN KEY (layer) REFERENCES Resilience (layer)
) WITHOUT ROWID;
