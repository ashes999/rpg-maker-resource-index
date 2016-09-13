/*============================================================================
 *    ## Plugin Info                                                          
 *----------------------------------------------------------------------------
 *    # Plugin Name                                                           
 *      DoubleX RMMV Dynamic Data                                             
 *----------------------------------------------------------------------------
 *    # Terms Of Use                                                          
 *      You shall keep this plugin's Plugin Info part's contents intact       
 *      You shalln't claim that this plugin's written by anyone other than    
 *      DoubleX or his aliases                                                
 *      None of the above applies to DoubleX or his aliases                   
 *----------------------------------------------------------------------------
 *    # Prerequisites                                                         
 *      Abilities:                                                            
 *      1. Thorough comprehensions to the other custom plugins to edit their  
 *         data loaded and cached during game executions                      
 *----------------------------------------------------------------------------
 *    # Links                                                                 
 *      This plugin:                                                          
 *      1. http://pastebin.com/6qxskYb9                                       
 *----------------------------------------------------------------------------
 *    # Author                                                                
 *      DoubleX                                                               
 *----------------------------------------------------------------------------
 *    # Changelog                                                             
 *      v1.01d(GMT 1400 27-1-2016):                                           
 *      1. Fixed undefined DD and DoubleX_RMMV.Dynamic_Data in defining latter
 *      2. Fixed caching original data before they're completed loaded bug    
 *      v1.01c(GMT 0100 26-12-2015):                                          
 *      1. Fixed corupting the database upon reloading it on the title screen 
 *      2. Fixed some syntax errors due to typos                              
 *      v1.01b(GMT 0900 25-11-2015):                                          
 *      1. Fixed missing param dynamic_data_states in the plugin manager bug  
 *      2. Fixed accessing private variables inside $gameSystem bug           
 *      3. The aliased function names becomes more unique to this plugin      
 *      v1.01a(GMT 1200 16-11-2015):                                          
 *      1. Lets users set which part of the database changes will be saved    
 *      2. The aliased functions can be accessed by other custom plugins now  
 *      v1.00b(GMT 0800 11-11-2015):                                          
 *      1. Added descriptions that will be shown in the plugin manager        
 *      v1.00a(GMT 0100 31-10-2015):                                          
 *      1. 1st version of this plugin finished                                
 *============================================================================*/
/*:
 * @plugindesc Stores the database changes done by users during game executions
 *             Can't be used with data read from the database files upon use
 *             Can't be used with any map data
 * @author DoubleX
 *
 * @param dynamicDataActors
 * @desc Saves the actors part of the database changes in savefiles if and only
 *       if dynamicDataActors is set as true
 * @default false
 *
 * @param dynamicDataClasses
 * @desc Saves the classes part of the database changes in savefiles if and only
 *       if dynamicDataClasses is set as true
 * @default false
 *
 * @param dynamicDataSkills
 * @desc Saves the skills part of the database changes in savefiles if and only
 *       if dynamicDataSkills is set as true
 * @default false
 *
 * @param dynamicDataItems
 * @desc Saves the items part of the database changes in savefiles if and only
 *       if dynamicDataItems is set as true
 * @default false
 *
 * @param dynamicDataWeapons
 * @desc Saves the weapons part of the database changes in savefiles if and only
 *       if dynamicDataWeapons is set as true
 * @default false
 *
 * @param dynamicDataArmors
 * @desc Saves the armors part of the database changes in savefiles if and only
 *       if dynamicDataArmors is set as true
 * @default false
 *
 * @param dynamicDataEnemies
 * @desc Saves the enemies part of the database changes in savefiles if and only
 *       if dynamicDataEnemies is set as true
 * @default false
 *
 * @param dynamicDataTroops
 * @desc Saves the troops part of the database changes in savefiles if and only
 *       if dynamicDataTroops is set as true
 * @default false
 *
 * @param dynamicDataStates
 * @desc Saves the states part of the database changes in savefiles if and only
 *       if dynamicDataStates is set as true
 * @default false
 *
 * @param dynamicDataAnimations
 * @desc Saves the animations part of the database changes in savefiles if and
 *       only if dynamicDataAnimations is set as true
 * @default false
 *
 * @param dynamicDataTilesets
 * @desc Saves the tilesets part of the database changes in savefiles if and
 *       only if dynamicDataTilesets is set as true
 * @default false
 *
 * @param dynamicDataCommonEvents
 * @desc Saves the common events part of the database changes in savefiles if
 *       and only if dynamicDataCommonEvents is set as true
 * @default false
 *
 * @param dynamicDataSystem
 * @desc Saves the system part of the database changes in savefiles if and only
 *       if dynamicDataSystem is set as true
 * @default false
 *
 * @help
 * In the default RMMV setting, you can edit the loaded parts of the database
 * but you can't save those changes, as the database's always loaded from the
 * raw json files upon game start
 * With this plugin, all the loaded parts of the database will be saved in
 * savefiles and loaded from those savefiles upon loading those savefiles
 * The default plugin file name is DoubleX RMMV Dynamic Data v101d
 * If you want to change that, you must edit the value of
 * DoubleX_RMMV.Dynamic_Data_File, which must be done via opening the plugin
 * js file directly
 */

"use strict";
var DoubleX_RMMV = DoubleX_RMMV || {};
DoubleX_RMMV["Dynamic Data"] = "v1.01d";

// The plugin file name must be the same as DoubleX_RMMV.Dynamic_Data_File
DoubleX_RMMV.Dynamic_Data_File = "DoubleX RMMV Dynamic Data v101d";

/*============================================================================
 *    ## Plugin Implementations                                               
 *       You need not edit this part as it's about how this plugin works      
 *----------------------------------------------------------------------------
 *    # Plugin Support Info:                                                  
 *      1. Prerequisites                                                      
 *         - Some Javascript coding proficiency to fully comprehend this      
 *           plugin                                                           
 *      2. Function documentation                                             
 *         - The 1st part describes why this function's rewritten/extended for
 *           rewritten/extended functions or what the function does for new   
 *           functions                                                        
 *         - The 2nd part describes what the arguments of the function are    
 *         - The 3rd part informs which version rewritten, extended or created
 *           this function                                                    
 *         - The 4th part informs whether the function's rewritten or new     
 *         - The 5th part informs whether the function's a real or potential  
 *           hotspot                                                          
 *         - The 6th part describes how this function works for new functions 
 *           only, and describes the parts added, removed or rewritten for    
 *           rewritten or extended functions only                             
 *         Example:                                                           
 * /*----------------------------------------------------------------------
 *  *    Why rewrite/extended/What this function does                      
 *  *----------------------------------------------------------------------*/ 
/* // arguments: What these arguments are                                     
 * functionName = function(arguments) { // Version X+; Hotspot                
 *     // Added/Removed/Rewritten to do something/How this function works     
 *     functionContents                                                       
 *     //                                                                     
 * } // functionName                                                          
 *----------------------------------------------------------------------------*/

DoubleX_RMMV.Dynamic_Data = {

    // Stores all this plugin's parameters that are shown in the plugin manager
    params: PluginManager.parameters(DoubleX_RMMV.Dynamic_Data_File),

    baseData: {}

};

(function(DD) {

    Object.keys(DD.params).forEach(function(param) {
        DD[param] = DD.params[param] === "true";
    });

    DD.storeBaseData = function() {
        var data = [$dataActors, $dataClasses, $dataSkills, $dataItems];
        data = data.concat([$dataWeapons, $dataArmors, $dataEnemies]);
        data = data.concat([$dataTroops, $dataStates, $dataAnimations]);
        data = data.concat([$dataTilesets, $dataCommonEvents, $dataSystem]);
        var params = Object.keys(DD.params);
        var baseData = DD.baseData;
        for (var index = 0, length = data.length; index < length; index++) {
            baseData[params[index]] = data[index];
        }
    }; // DD.storeBaseData

    DD.restoreBaseData = function() {
        var baseData = DD.baseData;
        $dataActors = baseData.dynamicDataActors;
        $dataClasses = baseData.dynamicDataClasses;
        $dataSkills = baseData.dynamicDataSkills;
        $dataItems = baseData.dynamicDataItems;
        $dataWeapons = baseData.dynamicDataWeapons;
        $dataArmors = baseData.dynamicDataArmors;
        $dataEnemies = baseData.dynamicDataEnemies;
        $dataTroops = baseData.dynamicDataTroops;
        $dataStates = baseData.dynamicDataStates;
        $dataAnimations = baseData.dynamicDataAnimations;
        $dataTilesets = baseData.dynamicDataTilesets;
        $dataCommonEvents = baseData.dynamicDataCommonEvents;
        $dataSystem = baseData.dynamicDataSystem;
    }; // DD.restoreBaseData

    DD.DataManager = {};
    var DM = DD.DataManager;

    DM.saveGameWithoutRescue = DataManager.saveGameWithoutRescue;
    DataManager.saveGameWithoutRescue = function(savefileId) {
        DM.saveDynamicData.call(this); // Added
        DM.saveGameWithoutRescue.apply(this, arguments);
    }; // DataManager.saveGameWithoutRescue

    DM.extractSaveContents = DataManager.extractSaveContents;
    DataManager.extractSaveContents = function(savefileId) {
        DM.extractSaveContents.apply(this, arguments);
        DM.loadDynamicData.call(this); // Added
    }; // DataManager.extractSaveContents

    DM.saveDynamicData = function() { // New
        var data = [$dataActors, $dataClasses, $dataSkills, $dataItems];
        data = data.concat([$dataWeapons, $dataArmors, $dataEnemies]);
        data = data.concat([$dataTroops, $dataStates, $dataAnimations]);
        data = data.concat([$dataTilesets, $dataCommonEvents, $dataSystem]);
        var params = Object.keys(DD.params);
        if (params.length !== data.length) {
            throw new Error("Errors in reading params from the plugin manager");
        }
        for (var index = 0, length = data.length; index < length; index++) {
            if (DD[params[index]]) { $gameSystem[params[index]] = data[index]; }
        }
    }; // DM.saveDynamicData

    DM.loadDynamicData = function() { // New
        if (DD.dynamicDataActors) {
            $dataActors = $gameSystem.dynamicDataActors;
        }
        if (DD.dynamicDataClasses) {
            $dataClasses = $gameSystem.dynamicDataClasses;
        }
        if (DD.dynamicDataSkills) {
            $dataSkills = $gameSystem.dynamicDataSkills;
        }
        if (DD.dynamicDataItems) {
            $dataItems = $gameSystem.dynamicDataItems;
        }
        if (DD.dynamicDataWeapons) {
            $dataWeapons = $gameSystem.dynamicDataWeapons;
        }
        if (DD.dynamicDataArmors) {
            $dataArmors = $gameSystem.dynamicDataArmors;
        }
        if (DD.dynamicDataEnemies) {
            $dataEnemies = $gameSystem.dynamicDataEnemies;
        }
        if (DD.dynamicDataTroops) {
            $dataTroops = $gameSystem.dynamicDataTroops;
        }
        if (DD.dynamicDataStates) {
            $dataStates = $gameSystem.dynamicDataStates;
        }
        if (DD.dynamicDataAnimations) {
            $dataAnimations = $gameSystem.dynamicDataAnimations;
        }
        if (DD.dynamicDataTilesets) {
            $dataTilesets = $gameSystem.dynamicDataTilesets;
        }
        if (DD.dynamicDataCommonEvents) {
            $dataCommonEvents = $gameSystem.dynamicDataCommonEvents;
        }
        if (DD.dynamicDataSystem) {
            $dataSystem = $gameSystem.dynamicDataSystem;
        }
    }; // DM.loadDynamicData

    /*------------------------------------------------------------------------
     *    New public instance variables                                       
     *------------------------------------------------------------------------*/
    // The copies of all database parts that will be saved into save files
    Object.keys(DD.params).forEach(function(param) {
        Object.defineProperty(Game_System.prototype, param, {
            get: function() { return this["_" + param]; },
            set: function(data) { this["_" + param] = data; },
            configurable: true
        });
    });

    DD.Scene_Boot = {};
    var SB = DD.Scene_Boot;

    SB.start = Scene_Boot.prototype.start;
    Scene_Boot.prototype.start = function() {
        SB.start.apply(this, arguments);
        DD.storeBaseData(); // Added to allow using original data for new game
    }; // Scene_Boot.prototype.start

    DD.Scene_Title = {};
    var ST = DD.Scene_Title;

    ST.start = Scene_Title.prototype.start;
    Scene_Title.prototype.start = function(savefileId) {
        ST.start.apply(this, arguments);
        DD.restoreBaseData(); // Added to use the original data for new game
    }; // Scene_Title.prototype.start

})(DoubleX_RMMV.Dynamic_Data);

/*============================================================================*/
