trigger PlantTrigger on Plant__c (before insert, before update) {
     

    // Trigger.isBefore, Trigger.isInsert ...
    
    // Cuando se crea o actualiza una planta (cambiando su fecha de regado) --> calcular sig fecha riego
    
    if (Trigger.isInsert || Trigger.isUpdate) {
         //Precargar informacion necesaria de objetos relacionados
        Set<Id> specieIds = new Set<Id>();
        for (Plant__c newPlant : Trigger.new) {
            Plant__c oldPlant = Trigger.oldMap.get(newPlant.Id);
                if (oldPlant == null || (oldPlant.Last_Watered__c != newPlant.Last_Watered__c)){
                    specieIds.add(newPlant.Species__c);
                }          
        }
    }

    List<Species__c> species = [SELECT Summer_Watering_Frecuency__c FROM Species__c WHERE Id IN :specieIds];
    Map<Id, Species__c> speciesById = new Map<Id, Species__c>(species);
    
    if (Trigger.isInsert || Trigger.isUpdate) {
        // Si esta cambiando la fecha de riego
        // Trigger.old / Trigger.new / Trigger.oldMap / Trigger.newMap
        // Obtener valor nuevo fecha riego de Trigger.new
        // Obtener valor antiguo fecha riego de Trigger.oldMap
        for (Plant__c newPlant : Trigger.new){
            Plant__c oldPlant = Trigger.oldMap.get(newPlant.Id);
            if (oldPlant == null || (oldPlant.Last_Watered__c != newPlant.Last_Watered__c)) {
            // Calcular sig fecha de riego
            // Ver de que especie es mi planta
            id specieId = newPlant.Species__c;
            // Traer objeto especie
            // Pedir freq de riego para esa especie
            Integer daysToAdd = FrequencyService.getWateringDays(specie);
            // Sig fecha de riego = ultima fecha de riego + días devueltos
            newPlant.Next_Water__c = newPlant.Last_Watered__c.addDays(daysToAdd);
            }            
        } 
    }
    // Cuando se crea o actualiza una planta (cambiando su fecha de abonado) --> calcular sig fecha abonado
 
}