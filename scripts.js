'use strict';

angular.module('app').controller('ScriptsController', ['$scope', '$http', 'scriptsRepository', 'NgTableParams', function ($scope, $http, scriptsRepo, NgTableParams)
{
  // TODO: make this common across both controllers
  this.githubRootUrl = "https://raw.githubusercontent.com/ashes999/rpg-maker-mv-resources/gh-pages/resources/vxa";
  
  this.tableParams = new NgTableParams({}, { dataset: scriptsRepo.getData()});  
}]);

