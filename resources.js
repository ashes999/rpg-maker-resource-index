'use strict';

angular.module('app').controller('ResourcesController', ['$scope', '$http', 'resourcesRepository', 'NgTableParams', function ($scope, $http, resourcesRepo, NgTableParams) {
  // TODO: make this common across both controllers
  this.githubRootUrl = "https://raw.githubusercontent.com/ashes999/rpg-maker-mv-resources/gh-pages/resources/vxa";
  
  this.tableParams = new NgTableParams({}, { dataset: resourcesRepo.getData() });  
}]);

