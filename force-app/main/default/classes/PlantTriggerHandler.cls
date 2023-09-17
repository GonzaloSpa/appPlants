public with sharing class PlantTriggerHandler {
   
    public void beforeInsert(List<Plant__c> newSObject) {
            //Precargar informacion necesaria de objetos relacionados
        Set<Id> specieIds = new Set<Id>();
        for (Plant__c newPlant : newSObject) {
            specieIds.add(newPlant.Species__c);
        }                              
       
       // Query precarga objetos relacionados
       Map<Id, Species__c> speciesById = preloadRelatedSpecies(specieIds);

       // Prepopulete Next Watering Date
       for (Plant__c newPlant : newSObject){
            populeteNextWateringDate(newPlant, speciesById);
       }
          
    }



    public void beforeUpdate(
        List<Plant__c> oldSObject,
        Map<ID, Plant__c> oldSObjectMap,
        List<Plant__c>    updatedSObjects,
        Map<ID, Plant__c> updatedSObjectsMap
    ) {
        // Cuando se crea o actualiza una planta (cambiando fecha de riego) ---> calcular sig fecha riego
        // Precargar info necesaria de objeto relacionado
        Set<Id> specieIds = new Set<Id>();
        for (Plant__c newPlant : updatedSObjects) {
            Plant__c oldPlant = oldSObjectMap.get(newPlant.Id);
            if (oldPlant.Last_Watered__c != newPlant.Last_Watered__c){
                specieIds.add(newPlant.Species__c);
           
            }                              
        }         

        // Query precarga objetos relacionados
        Map<Id, Species__c> speciesById = preloadRelatedSpecies(specieIds);
    
        // Si esta cambiando la fecha de riego
        // Trigger.old / Trigger.new / Trigger.oldMap / Trigger.newMap
        // Obtener valor nuevo fecha riego de Trigger.new
        // Obtener valor antiguo fecha riego de Trigger.oldMap
        for (Plant__c newPlant : updatedSObjects) {
            Plant__c oldPlant = oldSObjectMap.get(newPlant.Id);
            if (oldPlant.Last_Watered__c != newPlant.Last_Watered__c){
                populateNextWateringDate(newPlant, speciesById);   
            }      
        }
    
    }

    private static Map<Id, Species__c> preloadRelatedSpecies(Set<Id> specieIds) {
        List<Species__c> species = [
          SELECT Summer_Watering_Frequency__c, Winter_Watering_Frequency__c
          FROM Species__c
          WHERE Id IN :specieIds
          WITH SECURITY_ENFORCED
        ];
        return new Map<Id, Species__c>(species);
    }

    private static void populateNextWateringDate(Plant__c newPlant,Map<Id, Species__c> speciesById) {
        // Calcular sig fecha de riego
        // Ver de qué especie es mi planta
        Id specieId = newPlant.Species__c;
        // Traer objeto especie
        // MAL --> Species__c specie = [SELECT Summer_Watering_Frequency__c FROM Species__c WHERE Id = :specieId];
        Species__c specie = speciesById.get(specieId); // BIEN!!!
        // Pedir freq de riego para esa especie
        Integer daysToAdd = FrequencyService.getWateringDays(specie);

        // sig fecha riego = ultima fecha riego + dias devueltos
        newPlant.Next_Water__c = newPlant.Last_Watered__c.addDays(daysToAdd);
      }

}    

