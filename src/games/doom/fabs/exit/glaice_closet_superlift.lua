PREFABS.Exit_glaice_superlift_up =
{
  file   = "exit/glaice_closet_superlift.wad"
  map    = "MAP01"

  prob   = 175

  theme  = "!hell"

  where  = "seeds"
  seed_w = 1
  seed_h = 2

  deep = 16

  height = 96

  bound_z0 = -1024
  bound_z1 = 136

  x_fit  = "frame"
  y_fit  = "bottom"
}

PREFABS.Exit_glaice_superlift_down =
{
  template = "Exit_glaice_superlift_up"

  map = "MAP02"

  bound_z0 = 0
  bound_z1 = 1032+8
}