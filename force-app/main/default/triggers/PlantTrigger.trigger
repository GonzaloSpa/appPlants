trigger PlantTrigger on Plant__c (before insert, before update) {
     
    PlantTriggerHandler handler = new PlantTriggerHandler();
    // Before Insert
    if(Trigger.isInsert && Trigger.isBefore) {
        handler.beforeInsert(Trigger.new);
    }
    // Before update
    else if (Trigger.isInsert && Trigger.isBefore) {
        handle.beforeUpdate(Trigger.old, Trigger.oldMap, Trigger.new, Trigger.newMap)
    } 
}