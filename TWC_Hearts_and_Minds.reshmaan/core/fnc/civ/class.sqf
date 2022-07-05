
/* ----------------------------------------------------------------------------
Function: btc_civ_fnc_class

Description:
    Return civilian classe names sorted by units, boats and vehicules based on faction name.

Parameters:
    _factions - Faction name used to get civilian classe name sorted. [Array]

Returns:
    _civilian_classe_names - Array of units, boats and vehicules classe names. [Array]

Examples:
    (begin example)
        _civilian_classe_names = ["CIV_F"] call btc_civ_fnc_class;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

params [
    ["_factions", [], [[]]]
];

private _type_units = [];
private _type_boats = [];
private _type_veh = [];

//Get all vehicles
private _cfgVehicles = configFile >> "CfgVehicles";
private _allClass = ("(configName _x) isKindOf 'AllVehicles'" configClasses _cfgVehicles) apply {configName _x};
_allClass = _allClass select {getNumber(_cfgVehicles >> _x >> "scope") isEqualTo 2};

//Check if faction existe
private _cfgFactionClasses = configFile >> "CfgFactionClasses";
_factions = _factions apply {
    if !(isClass(_cfgFactionClasses >> _x)) then {
        "CIV_F"
    } else {
        _x
    };
};

{
    private _faction = _x;

    //Get all vehicles of the _faction selected
    private _allClass_f = _allClass select {(toUpper getText(_cfgVehicles >> _x >> "faction")) isEqualTo _faction};

    //Units
    _type_units append (_allClass_f select {_x isKindOf "Man"});
    if (_type_units isEqualTo []) then {
        _type_units append ["CUP_C_TK_Man_01_Coat", "CUP_C_TK_Man_01_Jack", "CUP_C_TK_Man_01_Waist","CUP_C_TK_Man_02", "CUP_C_TK_Man_02_Jack", "CUP_C_TK_Man_02_Waist","CUP_C_TK_Man_03_Coat", "CUP_C_TK_Man_03_Jack", "CUP_C_TK_Man_03_Waist", "CUP_C_TK_Man_04", "CUP_C_TK_Man_04_Jack", "CUP_C_TK_Man_04_Waist", "CUP_C_TK_Man_05_Coat", "CUP_C_TK_Man_05_Jack", "CUP_C_TK_Man_05_Waist", "CUP_C_TK_Man_06_Coat", "CUP_C_TK_Man_06_Jack", "CUP_C_TK_Man_06_Waist", "CUP_C_TK_Man_05_Coat", "CUP_C_TK_Man_05_Jack", "CUP_C_TK_Man_05_Waist","CUP_C_TK_Man_05_Coat", "CUP_C_TK_Man_05_Jack", "CUP_C_TK_Man_05_Waist", "CUP_C_TK_Man_06_Coat", "CUP_C_TK_Man_06_Jack", "CUP_C_TK_Man_06_Waist", "CUP_C_TK_Man_07", "CUP_C_TK_Man_07_Coat", "CUP_C_TK_Man_07_Waist", "CUP_C_TK_Man_08", "CUP_C_TK_Man_08_Jack", "CUP_C_TK_Man_08_Waist"]
    };

    //Vehicles
    _type_boats append (_allClass_f select {_x isKindOf "Ship"});
    if (_type_boats isEqualTo []) then {
        _type_boats append ["C_Rubberboat","C_Boat_Civil_01_F","C_Boat_Civil_01_rescue_F","C_Boat_Civil_01_police_F","C_Boat_Transport_02_F","C_Scooter_Transport_01_F"];
    };

    _type_veh append (_allClass_f select {(_x isKindOf "Car") || (_x isKindOf "Truck") || (_x isKindOf "Truck_F")});
    if (_type_veh isEqualTo []) then {
        _type_veh append ["CUP_C_Lada_GreenTK_CIV", "CUP_C_Lada_TK2_CIV", "CUP_C_Lada_TK_CIV", "CUP_C_Ural_Civ_01", "CUP_C_UAZ_Open_TK_CIV", "CUP_C_UAZ_Unarmed_TK_CIV", "CUP_C_V3S_Covered_TKC", "CUP_C_V3S_Open_TKC", "CUP_C_Ikarus_TKC", "CUP_O_Hilux_unarmed_TK_CIV"]
    };
} forEach _factions;

//Final filter unwanted units type
_type_units = _type_units select {
    getText (_cfgVehicles >> _x >> "role") isNotEqualTo "Crewman" &&
    (_x find "_unarmed_") isEqualTo -1 &&
    getText (_cfgVehicles >> _x >> "vehicleClass") isNotEqualTo "MenVR"
};
_type_veh = _type_veh select {(getNumber (_cfgVehicles >> _x >> "isUav") isNotEqualTo 1) && !(_x isKindOf "Kart_01_Base_F")};

[_type_units, _type_boats, _type_veh]
