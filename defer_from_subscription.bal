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

    asb:ConnectionConfiguration senderConfig = {
        connectionString: config:getAsString("CONNECTION_STRING"),
        entityPath: config:getAsString("TOPIC_PATH")
    };

    asb:ConnectionConfiguration receiverConfig1 = {
        connectionString: config:getAsString("CONNECTION_STRING"),
        entityPath: config:getAsString("SUBSCRIPTION_PATH1")
    };

    asb:ConnectionConfiguration receiverConfig2 = {
        connectionString: config:getAsString("CONNECTION_STRING"),
        entityPath: config:getAsString("SUBSCRIPTION_PATH2")
    };

    asb:ConnectionConfiguration receiverConfig3 = {
        connectionString: config:getAsString("CONNECTION_STRING"),
        entityPath: config:getAsString("SUBSCRIPTION_PATH3")
    };

    log:print("Creating Asb sender connection.");
    asb:SenderConnection? senderConnection = checkpanic new (senderConfig);

    log:print("Creating Asb receiver connection.");
    asb:ReceiverConnection? receiverConnection1 = checkpanic new (receiverConfig1);
    asb:ReceiverConnection? receiverConnection2 = checkpanic new (receiverConfig2);
    asb:ReceiverConnection? receiverConnection3 = checkpanic new (receiverConfig3);

    if (senderConnection is asb:SenderConnection) {
        log:print("Sending via Asb sender connection.");
        checkpanic senderConnection->sendMessageWithConfigurableParameters(byteContent, parameters1, properties);
        checkpanic senderConnection->sendMessageWithConfigurableParameters(byteContentFromJson, parameters2, properties);
    } else {
        log:printError("Asb sender connection creation failed.");
    }

    if (receiverConnection1 is asb:ReceiverConnection) {
        log:print("Defer message from Asb receiver connection.");
        var sequenceNumber = receiverConnection1->deferMessage();
        log:print("Done Deferring a message using its lock token.");
        log:print("Receiving from Asb receiver connection.");
        asb:Message|asb:Error? jsonMessageReceived = receiverConnection1->receiveMessage(serverWaitTime);
        if (jsonMessageReceived is asb:Message) {
            json jsonMessageRead = checkpanic jsonMessageReceived.getJSONContent();
            log:print("Reading Received Message : " + jsonMessageRead.toString());
        } else {
            log:printError("Receiving message via Asb receiver connection failed.");
        }
        log:print("Receiving Deferred Message from Asb receiver connection.");
        if(sequenceNumber is int) {
            if(sequenceNumber == 0) {
                log:printError("No message in the queue");
            }
            asb:Message|asb:Error? messageReceived = receiverConnection1->receiveDeferredMessage(sequenceNumber);
            if (messageReceived is asb:Message) {
                string messageRead = checkpanic messageReceived.getTextContent();
                log:print("Reading Received Message : " + messageRead);
            } else if (messageReceived is ()) {
                log:printError("No deferred message received with given sequence number");
            } else {
                log:printError(msg = messageReceived.message());
            }
        } else {
            log:printError(msg = sequenceNumber.message());
        }
    } else {
        log:printError("Asb receiver connection creation failed.");
    }

    if (receiverConnection2 is asb:ReceiverConnection) {
        log:print("Defer message from Asb receiver connection.");
        var sequenceNumber = receiverConnection2->deferMessage();
        log:print("Done Deferring a message using its lock token.");
        log:print("Receiving from Asb receiver connection.");
        asb:Message|asb:Error? jsonMessageReceived = receiverConnection2->receiveMessage(serverWaitTime);
        if (jsonMessageReceived is asb:Message) {
            json jsonMessageRead = checkpanic jsonMessageReceived.getJSONContent();
            log:print("Reading Received Message : " + jsonMessageRead.toString());
        } else {
            log:printError("Receiving message via Asb receiver connection failed.");
        }
        log:print("Receiving Deferred Message from Asb receiver connection.");
        if(sequenceNumber is int) {
            if(sequenceNumber == 0) {
                log:printError("No message in the queue");
            }
            asb:Message|asb:Error? messageReceived = receiverConnection2->receiveDeferredMessage(sequenceNumber);
            if (messageReceived is asb:Message) {
                string messageRead = checkpanic messageReceived.getTextContent();
                log:print("Reading Received Message : " + messageRead);
            } else if (messageReceived is ()) {
                log:printError("No deferred message received with given sequence number");
            } else {
                log:printError(msg = messageReceived.message());
            }
        } else {
            log:printError(msg = sequenceNumber.message());
        }
    } else {
        log:printError("Asb receiver connection creation failed.");
    }

    if (receiverConnection3 is asb:ReceiverConnection) {
        log:print("Defer message from Asb receiver connection.");
        var sequenceNumber = receiverConnection3->deferMessage();
        log:print("Done Deferring a message using its lock token.");
        log:print("Receiving from Asb receiver connection.");
        asb:Message|asb:Error? jsonMessageReceived = receiverConnection3->receiveMessage(serverWaitTime);
        if (jsonMessageReceived is asb:Message) {
            json jsonMessageRead = checkpanic jsonMessageReceived.getJSONContent();
            log:print("Reading Received Message : " + jsonMessageRead.toString());
        } else {
            log:printError("Receiving message via Asb receiver connection failed.");
        }
        log:print("Receiving Deferred Message from Asb receiver connection.");
        if(sequenceNumber is int) {
            if(sequenceNumber == 0) {
                log:printError("No message in the queue");
            }
            asb:Message|asb:Error? messageReceived = receiverConnection3->receiveDeferredMessage(sequenceNumber);
            if (messageReceived is asb:Message) {
                string messageRead = checkpanic messageReceived.getTextContent();
                log:print("Reading Received Message : " + messageRead);
            } else if (messageReceived is ()) {
                log:printError("No deferred message received with given sequence number");
            } else {
                log:printError(msg = messageReceived.message());
            }
        } else {
            log:printError(msg = sequenceNumber.message());
        }
    } else {
        log:printError("Asb receiver connection creation failed.");
    }

    if (senderConnection is asb:SenderConnection) {
        log:print("Closing Asb sender connection.");
        checkpanic senderConnection.closeSenderConnection();
    }

    if (receiverConnection1 is asb:ReceiverConnection) {
        log:print("Closing Asb receiver connection 1.");
        checkpanic receiverConnection1.closeReceiverConnection();
    }

    if (receiverConnection2 is asb:ReceiverConnection) {
        log:print("Closing Asb receiver connection 2.");
        checkpanic receiverConnection2.closeReceiverConnection();
    }

    if (receiverConnection3 is asb:ReceiverConnection) {
        log:print("Closing Asb receiver connection 3.");
        checkpanic receiverConnection3.closeReceiverConnection();
    }
}    
