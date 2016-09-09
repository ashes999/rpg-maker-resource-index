'use strict';

angular.module("app").factory("resourcesRepository", [function() {
  return {
    getData: function() {
      return [
        // Portraits
        {
	        "name": "Yoda",
	        "description": "Portrait of Yoda from Star Wars",
	        "url": "https://grandmadebslittlebits.wordpress.com/2015/08/13/edeus-modernscifi-portraits/",
	        "fileName": "faces/yoda.png",
        },
        // Tilesets
        {
	        "name": "Beach Tiles",
	        "description": "Tiles for beach towels, umbrellas, sea shells, starfish, a lifeguard hut, and a beach ball",
	        "commercialUseAllowed": "unknown",
	        "url": "https://grandmadebslittlebits.wordpress.com/2015/06/12/guths-summer-beach-and-pool-tiles/",
	        "fileName": "tilesets/beach.png",
        }
      ];
    }
  }
}]);
