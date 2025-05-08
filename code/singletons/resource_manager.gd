# ResourceManager.gd
extends Node


var rations: int = 100
var energy_cells: int = 20
var oxen: int = 4 


func modify_resource(type: String, amount: int):

    match type:
        "rations":
            rations += amount
        "energy":
            energy_cells += amount
        "ox":
            oxen += amount
    SignalBus.resource_changed.emit(type, get_resource(type))


func get_resource(type: String) -> int:
    match type:
        "rations":
            return rations
        "energy":
            return energy_cells
        "ox":
            return oxen
    return 0

func get_resources():
    return {
        "rations": rations,
        "energy": energy_cells,
        "ox": oxen
    }

