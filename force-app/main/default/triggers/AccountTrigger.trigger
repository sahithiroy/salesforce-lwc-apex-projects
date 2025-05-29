trigger AccountTrigger on Account (after insert, after update) {
        AccountHelper.createRelatedContacts(Trigger.new);
}