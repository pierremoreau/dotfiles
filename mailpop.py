#!/bin/python

import gi
import email
import re
import sys

gi.require_version('Notify', '0.7')
from gi.repository import Notify

message_path = sys.argv[1]
with open(message_path, 'r') as message_file:
    message_content = message_file.read()

# Assuming that the mail path has the format
# `$some_random_path/mail/$accountname/$foldername/new/$other_stuff`, extract
# the `$accountname/$foldername` for display.
maildir = re.sub(r"^.*mail\/", "", re.sub(r"\/new.*$", "", message_path))

message = email.message_from_string(message_content)

sender = str(email.header.make_header(email.header.decode_header(message['From'])))
# If the name is surrounded by double quotes, remove them.
sender = re.sub(r"\"([^\"]*)\"", "\g<1>", sender)
# If the name is in format “$last_name, $first_name”, reorder to have it in
# format “$first_name $last_name”
sender = re.sub(r"([^,]+), ?([^<]*)", "\g<2>\g<1> ", sender)
# The address will fail to display if surrounded by angles. Replace those by
# square brackets.
sender = re.sub(r"<([^>]*)>", "[\g<1>]", sender)

subject = str(email.header.make_header(email.header.decode_header(message['Subject'])))
# Remove any newline from the subject, as the notification displayer will
# already take care of the wrapping
subject = re.sub(r"\n", "", re.sub(r" \n", " ", subject))

Notify.init("offlineimap")
notif = Notify.Notification.new("New e-mail in \"{0}\"".format(maildir),
        "From: {0}\nSubject: {1}".format(sender, subject), "mail-message-new")
notif.set_timeout(5000)
notif.set_urgency(Notify.Urgency.NORMAL)
notif.show()
