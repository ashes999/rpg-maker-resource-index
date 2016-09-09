# RPG Maker MV Resources

[View the website](http://ashes999.github.io/rpg-maker-resources) where you can search for resources (eg. tilesets, portraits) and scripts (eg. time of day) for RPG Maker VXA games.

**We keep a copy of everything.** You can still access scripts and resources even if the original author's website becomes unavailable.

# How to Find Resources

- Click the "scripts" link (to search scripts) or the "resources" link (to search resources)
- Type in whatever you want in the search filters to find what you need.
- Click the homepage link to view the script/resource homepage, or the download link to download the version from our repository (may not be the latest version)

# How to Add Resources

Want to add or update your own script or resource to the repository? Update the right JSON file in `data`, add your resource to `resources`, and you're done.

- Fork and clone the repository locally
- Run an HTTP server in the root directory. If you're on Linux, you can use `python -m SimpleHTTPServer`
- Edit the right JSON file in `data` to add your resource
- Download a copy of the script/resource, and add it to the appropriate `resources` . This matches the game folders in RPG Maker.
- Browse to `localhost:8000` (if you used `SimpleHTTPServer`) and make sure everything works (try a couple searhces)
- Commit, push, and create a pull request to merge your changes back to the master repository.




