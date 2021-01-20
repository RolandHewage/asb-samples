import ballerina/config;
import ballerina/log;
import ballerinax/asb;

public function main() {

    // Input values
    string stringContent = "This is My Message Body"; 
    byte[] byteContent = stringContent.toBytes();
    json jsonContent = {name: "apple", color: "red", price: 5.36};
    byte[] byteContentFromJson = jsonContent.toJsonString().toBytes();
    json[] jsonArrayContent = [{name: "apple", color: "red", price: 5.36}, {first: "John", last: "Pala"}];
    string[] stringArrayContent = ["apple", "mango", "lemon", "orange"];
    int[] integerArrayContent = [4, 5, 6];
    map<string> parameters = {contentType: "application/json", messageId: "one", to: "sanju", replyTo: "carol", 
        label: "a1", sessionId: "b1", correlationId: "c1", timeToLive: "2"};
    map<string> parameters1 = {contentType: "application/json", messageId: "one"};
    map<string> parameters2 = {contentType: "application/json", messageId: "two", to: "sanju", replyTo: "carol", 
        label: "a1", sessionId: "b1", correlationId: "c1", timeToLive: "2"};
    map<string> parameters3 = {contentType: "application/json"};
    map<string> parameters4 = {contentType: "application/text", timeToLive: "8"};
    map<string> properties = {a: "propertyValue1", b: "propertyValue2"};
    string asyncConsumerMessage = "";
    int maxMessageCount = 3;
    int maxMessageCount1 = 2;
    int serverWaitTime = 5;
    int prefetchCountDisabled = 0;
    int prefetchCountEnabled = 50;
    int messageCount = 100;
    int variableMessageCount = 1000;

    asb:ConnectionConfiguration config = {
        connectionString: config:getAsString("CONNECTION_STRING"),
        entityPath: config:getAsString("QUEUE_PATH")
    };

    log:print("Creating Asb sender connection.");
    asb:SenderConnection? senderConnection = checkpanic new (config);

    log:print("Creating Asb receiver connection.");
    asb:ReceiverConnection? receiverConnection = checkpanic new (config);

    if (senderConnection is asb:SenderConnection) {
        log:print("Sending via Asb sender connection.");
        checkpanic senderConnection->sendMessageWithConfigurableParameters(byteContent, parameters1, properties);
        checkpanic senderConnection->sendMessageWithConfigurableParameters(byteContentFromJson, parameters2, properties);
    } else {
        log:printError("Asb sender connection creation failed.");
    }

    if (receiverConnection is asb:ReceiverConnection) {
        log:print("Receiving from Asb receiver connection.");
        asb:Message|asb:Error? messageReceived = receiverConnection->receiveMessage(serverWaitTime);
        asb:Message|asb:Error? jsonMessageReceived = receiverConnection->receiveMessage(serverWaitTime);
        if (messageReceived is asb:Message && jsonMessageReceived is asb:Message) {
            string messageRead = checkpanic messageReceived.getTextContent();
            log:print("Reading Received Message : " + messageRead);
            json jsonMessageRead = checkpanic jsonMessageReceived.getJSONContent();
            log:print("Reading Received Message : " + jsonMessageRead.toString());
        } 
    }

    if (senderConnection is asb:SenderConnection) {
        log:print("Closing Asb sender connection.");
        checkpanic senderConnection.closeSenderConnection();
    }

    if (receiverConnection is asb:ReceiverConnection) {
        log:print("Closing Asb receiver connection.");
        checkpanic receiverConnection.closeReceiverConnection();
    }
}    
