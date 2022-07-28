#MQ Setup
#========

#Check if the user has authority to administrate MQ


#Create a Queue Manager
crtmqm -q QMAJ

#Start the Queue Manager
strmqm QMAJ

runmqsc QMAJ

#Create a Listener Port
DEFINE LISTENER(LISTENER.AJ) TRPTYPE(TCP) PORT(1987)

#Start the Listener Port
START LISTENER(LISTENER.AJ)

#Create a Channel
DEFINE CHANNEL(CHNL.AJ) CHLTYPE(SVRCONN) TRPTYPE(TCP)

#Create a Queuee
DEFINE QLOCAL(QAJ)

#Create a user in the MQ server for Messaging
'ashlin' user requires enough authority to connect to the queue manager and its objects

SET AUTHREC OBJTYPE(QMGR) PRINCIPAL('ashlin') AUTHADD(ALL)
SET AUTHREC OBJTYPE(QUEUE) PROFILE('') PRINCIPAL('ashlin') AUTHADD(ALL)
SET AUTHREC OBJTYPE(CHANNEL) PROFILE('') PRINCIPAL('ashlin') AUTHADD(ALL)

#Set authrec on the channel


#Back Stop Rule
SET CHLAUTH('*') TYPE(ADDRESSMAP) ADDRESS('*') USERSRC(NOACCESS) DESCR('Back-stop rule')

#Removing chlauth
SET CHLAUTH(*) TYPE(ADDRESSMAP) ADDRESS(*) ACTION(REMOVE)

SET CHLAUTH('ADMIN.AJ') TYPE(USERMAP) CLNTUSER('aj') MCAUSER('mqa') USERSRC(MAP) ADDRESS('9.*') DESCR('Mapping aj from 9.145.30.187 to mca user in ADMIN.AJ') ACTION(ADD)
=======


DISPLAY CHLAUTH('CHNL.AJ') MATCH(RUNCHECK) ALL ADDRESS('9.145.158.226') CLNTUSER('ajm')
DISPLAY CHLAUTH('ADMIN.AJ') MATCH(RUNCHECK) ALL ADDRESS('9.145.152.176') CLNTUSER('mqa')


SET CHLAUTH('ADMIN.AJ') TYPE(USERMAP) CLNTUSER('mqa') USERSRC(MAP) MCAUSER('mqa') ADDRESS('9.145.152.176') ACTION(REPLACE)

SET CHLAUTH('ADMIN.AJ') TYPE(USERMAP) CLNTUSER('mqa') ADDRESS('9.145.152.176') ACTION(REMOVE)

ALTER CHL(ADMIN.AJ) CHLTYPE(SVRCONN) MCAUSER('mqa')

<Blocking Rule>

SET CHLAUTH(*) TYPE(BLOCKUSER) DESCR(Default rule to disallow privileged users) USERLIST(*MQADMIN)

<Configure floating IPs>
https://www.ibm.com/developerworks/community/blogs/messaging/entry/Floating_IP_support_for_the_IBM_MQ_Appliance?lang=en

SET AUTHREC



ALTER CHL(CHNL.AJ) CHLTYPE(SVRCONN) SSLCIPH(TLS_RSA_WITH_AES_128_CBC_SHA)
===========

runmqckm -keydb -create -db aj -pw passw0rd -type cms -stash

runmqckm -cert -create -db aj.kdb -stashed -label SelfSignedAJ -dn "CN=AJ, OU=LabServices, O=IBM, C=GB" -size 2048 -expire 365

runmqckm -cert -extract -db aj.kdb -stashed -label SelfSignedAJ -target publicAJ -format ascii
------

runmqckm -keydb -create -db javaclient.jks -type jks -pw passw0rd -stashed

runmqckm -cert -add -db javaclient.jks -pw passw0rd -label publicAJ -file publicAJ -format ascii
-------