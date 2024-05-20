// /*
// API : 50
// Source : lwcFactory.com
// */
// public class DistributorController {
//     // Method to fetch lookup search result   
//      @AuraEnabled(cacheable=true)
//      public static list<sObject> fetchLookupData(string searchKey , string sObjectApiName) {    
//          List < sObject > returnList = new List < sObject > ();
 
//          string sWildCardText = '%' + searchKey + '%';
//          string sQuery = 'SELECT Id, Name FROM ' + sObjectApiName + ' WHERE Name LIKE :sWildCardText AND inwiB2C_TypePartenaire__c = \'Distributeur\'  ORDER BY CreatedDate DESC LIMIT 5';
//          for (sObject obj: database.query(sQuery)) {
//              returnList.add(obj);
//          }
//          return returnList;
//      }
     
//      // Method to fetch lookup default value 
//      @AuraEnabled
//      public static sObject fetchDefaultRecord(string recordId , string sObjectApiName) {
//          string sRecId = recordId;    
//          string sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Id = : sRecId LIMIT 1';
//          for (sObject obj: database.query(sQuery)) {
//              return obj;
//          }
//          return null;
//      }
     
//  }

public class DistributorController {
    // Method to fetch lookup search result   
    @AuraEnabled(cacheable=true)
    public static List<sObject> fetchLookupData(String searchKey , String sObjectApiName) {    
        List<sObject> returnList = new List<sObject>();
        
        String sWildCardText = '%' + searchKey + '%';
        String sQuery = 'SELECT Id, Name FROM ' + sObjectApiName + ' WHERE Name LIKE :sWildCardText  AND RecordType.Name = \'Partenaire\' AND inwiB2C_TypePartenaire__c = \'inwiB2C_Distributeur\' ORDER BY CreatedDate DESC LIMIT 5';
        
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
    public static sObject fetchDefaultRecord(String recordId , String sObjectApiName) {
        String sRecId = recordId;    
        String sQuery = 'SELECT Id, Name FROM ' + sObjectApiName + ' WHERE Id = :sRecId LIMIT 1';
        
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
