extends Node

var words = [
  "car", "dog", "tree", "food", "cake", "milk", "rain", "snow", "wind", "fire",
  "book", "love", "home", "road", "lake", "fish", "bird", "game", "play", "ball",
  "ship", "moon", "star", "sun", "hill", "farm", "town", "city", "shop", "door",
  "desk", "jump", "walk", "read", "sing", "ride", "door", "cook", "draw", "life",
  "true", "wild", "fast", "slow", "warm", "cold", "soft", "hard", "dark", "light",
  "loud", "quiet", "happy", "sad", "young", "old", "new", "water", "river", "park",
  "mount", "cloud", "plane", "train", "apple", "fruit", "grape", "plant", "beach",
  "ocean", "earth", "north", "south", "east", "west", "dance", "laugh", "smile",
  "build", "break", "brick", "stone", "chair", "table", "glass", "pencil", "paper",
  "watch", "clock", "shirt", "shoes", "phone", "radio", "movie", "story", "paint"
];

func get_prompt() -> String:
	return words.pick_random()
