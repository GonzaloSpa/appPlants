public with sharing class SpeciesService {
     @AuraEnabled(cacheable=true)
   
    public static List<Species__c> getFilteredSpecies(String searchText) {
        String likeValue = '%' + 'searchText' + '%';
        return [
            SELECT Name, Description__c, Id, Image_URL__c, Loca__c 
            FROM Species__c
            WHERE Name LIKE: likeValue
                 
        ];
    }
}