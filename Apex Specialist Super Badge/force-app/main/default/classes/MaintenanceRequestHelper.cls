public with sharing class MaintenanceRequestHelper {
    private static List<Id> caseIds = new List<Id>();
        
    public static void updateWorkOrders(List<Case> newCase, List<Case> oldCase) {
        // TODO: Complete the method to update workorders
        List<Case> newCases = new List<Case>();
        Map<Id,Case> mapCases = new Map<Id,Case>();
        Integer i=0;
        for(Case c : newCase){
            if((c.Type == 'Repair' || c.Type == 'Routine Maintenance') && c.Status == 'Closed' && oldCase.get(i).Status != 'Closed'){
                Date dueDate = System.today();
                caseIds.add(c.Id);
                Case newCasee = new Case(
                    Type='Routine Maintenance',Date_Reported__c=dueDate,
                    Subject='How We Roll!',Vehicle__c=c.Vehicle__c,ParentId = c.Id);
                newCases.add(newCasee);
                mapCases.put(c.Id, newCasee);
            }
            i++;
        }
        List<sObject> minDueDate = getMinMaintenanceCycle(caseIds);
        for(sObject s : minDueDate){
            String caseId = s.get('Maintenance_Request__c')+'';
            mapCases.get(caseId).Date_Due__c = System.today().addDays(Integer.valueOf(s.get('expr0')));
        }
        insert newCases;
        updateEquipmentMaintenanceItemRecord(mapCases);
    }  
    
    public static List<sObject> getMinMaintenanceCycle(List<Id> caseIds){
        return [SELECT MIN(Equipment__r.Maintenance_Cycle__c),Maintenance_Request__c FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN:caseIds GROUP BY Maintenance_Request__c];
    }
    
    public static void updateEquipmentMaintenanceItemRecord(Map<Id,Case> mapCases){
        List<Equipment_Maintenance_Item__c> oldEmiList = [SELECT Id,Equipment__c,Maintenance_Request__c FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN:mapCases.keySet()];
        List<Equipment_Maintenance_Item__c> newEmiList = oldEmiList.deepClone();
        for(Equipment_Maintenance_Item__c newEmi : newEmiList){
            newEmi.Maintenance_Request__c = mapCases.get(newEmi.Maintenance_Request__c).Id;
        }
        insert newEmiList;
        delete oldEmiList;
    }
    
}