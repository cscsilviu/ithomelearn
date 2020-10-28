def send_messages(unsent_messages, sent_messages):

    while unsent_messages:
        current_message = unsent_messages.pop()
        print(current_message)
        sent_messages.append(current_message)
    
def show_sent_messages(sent_messages):
    print("The following messages has been sent:")
    for send_message in sent_messages:
        print(send_message)


unsend_messages = ["Bla Bla", "haha", "Muie gigi"]

sent_messages = []

send_messages(unsend_messages, sent_messages)

show_sent_messages(sent_messages)

print(unsend_messages)

print(sent_messages)