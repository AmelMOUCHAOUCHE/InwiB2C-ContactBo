/*
API : 50
Source : lwcFactory.com
*/
public class AgenceController {
    // Method to fetch lookup search result   
     @AuraEnabled(cacheable=true)
     public static list<sObject> fetchLookupData(string searchKey , string sObjectApiName , string selectedType, String distributorId) {    
        // public static list<sObject> fetchLookupData(string searchKey , string sObjectApiName , string selectedType) {    

         List < sObject > returnList = new List < sObject > ();
         string sQuery ;
         string sWildCardText = '%' + searchKey + '%';
         if (selectedType == '') {
            sQuery = 'SELECT Id, Name FROM ' + sObjectApiName + ' WHERE Name LIKE :sWildCardText AND RecordType.Name = \'Partenaire\' AND inwiB2C_TypePartenaire__c = \'inwiB2C_Agence\'   ORDER BY CreatedDate DESC LIMIT 5';
        } else if (selectedType == 'Utilisateur BO') {
            sQuery = 'SELECT Id, Name FROM ' + sObjectApiName + ' WHERE Name LIKE :sWildCardText AND RecordType.Name = \'Partenaire\' AND inwiB2C_TypePartenaire__c = \'inwiB2C_Agence\' AND InwiB2C_IsBoAgence__c = true AND ParentId = :distributorId ORDER BY CreatedDate DESC LIMIT 5';
        } else if (selectedType == 'Animateur' || selectedType == 'Livreur') {
            sQuery = 'SELECT Id, Name FROM ' + sObjectApiName + ' WHERE Name LIKE :sWildCardText AND RecordType.Name = \'Partenaire\' AND inwiB2C_TypePartenaire__c = \'inwiB2C_Agence\' AND InwiB2C_IsBoAgence__c = false AND  InwiB2C_CelluleBO__c != null AND ParentId = :distributorId ORDER BY CreatedDate DESC LIMIT 5';
        }
        // if (selectedType == '') {
        //     sQuery = 'SELECT Id, Name FROM ' + sObjectApiName + ' WHERE Name LIKE :sWildCardText AND InwiB2C_Type_Paretenaire__c = \'Partenaire\' AND InwiB2C_Record_Type__c = \'Distributeur\'   ORDER BY CreatedDate DESC LIMIT 5';
        // } else if (selectedType == 'Utilisateur BO') {
        //     sQuery = 'SELECT Id, Name FROM ' + sObjectApiName + ' WHERE Name LIKE :sWildCardText AND InwiB2C_Type_Paretenaire__c = \'Partenaire\' AND InwiB2C_Record_Type__c = \'Distributeur\' AND InwiB2C_Is_Bo_Agence__c = true  ORDER BY CreatedDate DESC LIMIT 5';
        // } else if (selectedType == 'Animateur' || selectedType == 'Livreur') {
        //     sQuery = 'SELECT Id, Name FROM ' + sObjectApiName + ' WHERE Name LIKE :sWildCardText AND InwiB2C_Type_Paretenaire__c = \'Partenaire\' AND InwiB2C_Record_Type__c = \'Distributeur\' AND InwiB2C_Is_Bo_Agence__c = false ANDInwiB2C_Cellul_Bo__c != null  ORDER BY CreatedDate DESC LIMIT 5';
        // }   
        try {
            for (sObject obj : Database.query(sQuery)) {
                returnList.add(obj);
            }
        } catch (Exception e) {
            // Gérer l'exception ici
            System.debug('An error occurred: ' + e.getMessage());
        }
        
        return returnList;
    }
         
     // Method to fetch lookup default value 
     @AuraEnabled
     public static sObject fetchDefaultRecord(string recordId , string sObjectApiName) {
         string sRecId = recordId;    
         string sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Id = : sRecId LIMIT 1';
         try {
            for (sObject obj : Database.query(sQuery)) {
                return obj;
            }
        } catch (Exception e) {
            // Gérer l'exception ici
            System.debug('An error occurred: ' + e.getMessage());
        }
        
        return null;
    }
     
 }