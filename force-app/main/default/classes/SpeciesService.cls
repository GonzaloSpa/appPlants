public with sharing class SpeciesService {
     @AuraEnabled(cacheable=true)
   
    public static List<Species__c> getAllSpecies() {
        return [
            SELECT Name, Description__c, Id, Image_URL__c, Loca__c 
            FROM Species__c
        ];
    }
}