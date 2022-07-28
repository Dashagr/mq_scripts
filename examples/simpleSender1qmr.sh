#MQ Setup
#========

#Check if the user has authority to administrate MQ


#Create a Queue Manager
crtmqm KEYY

#Start the Queue Manager
strmqm KEYY

runmqsc KEYY

#Create a Listener Port
DEFINE LISTENER(LISTENER.KEYY) TRPTYPE(TCP)  control(qmgr) PORT(1998)

#Start the Listener Port
START LISTENER(LISTENER.KEYY)

#Create a Channel
DEFINE CHANNEL(CHNL.KEYY) CHLTYPE(SVRCONN) TRPTYPE(TCP)

#Create a Queuee
DEFINE QLOCAL(KEYYQUEUE)

#OPTIONAL
#DEFINE CHANNEL(CHNL.KEYYNOTLS) CHLTYPE(SVRCONN) TRPTYPE(TCP)


#Create a user in the MQ server for Messaging
'daria' user requires enough authority to connect to the queue manager and its objects

SET AUTHREC OBJTYPE(QMGR) PRINCIPAL('daria') AUTHADD(ALL)
SET AUTHREC OBJTYPE(QMGR) PRINCIPAL('daria') AUTHADD(ALL)
SET AUTHREC OBJTYPE(CHANNEL) PROFILE('**') PRINCIPAL('daria') AUTHADD(ALL)
REFRESH SECURITY(*)

#Set authrec on the channel

SET AUTHREC OBJTYPE(QMGR) PRINCIPAL('aj') AUTHADD(ALL)
SET AUTHREC OBJTYPE(QUEUE) PROFILE('**') PRINCIPAL('aj') AUTHADD(ALL)
SET AUTHREC OBJTYPE(CHANNEL) PROFILE('**') PRINCIPAL('aj') AUTHADD(ALL)
REFRESH SECURITY(*)


#SET AUTHREC OBJTYPE (QMGR) PRINCIPAL('appuser') AUTHADD(CONNECT, INQ)
#SET AUTHREC OBJTYPE (QUEUE) PROFILE(KEYYQueue) PRINCIPAL('appuser') AUTHADD(PUT, GET, INQ, BROWSE)
#SET AUTHREC OBJTYPE (CHANNEL) PROFILE('CHNL.KEYY') PRINCIPAL('appuser') AUTHADD(CONNECT)


# parameters 
# -Dhostname=localhost
# -Dport=1414
# -Dchannel=CHNL.KEYY
# -Dqmgr=KEYY
# -DreceiverQ=KEYYQUEUE
# -Duser=appuser
# -Dpwd=appuser
# -Dnumsgs=2
# -DlogFile=/home/daria/Documents/SimpleSender.log

#  parameters
# -Dhostname=localhost
# -Dport=1414
# -Dchannel=CHNL.KEYY
# -Dqmgr=KEYY
# -DsenderQ=KEYYQUEUE
# -Duser=appuser
# -Dpwd=appuser
# -Dnumsgs=2
# -DlogFile=/home/daria/Documents/SimpleSender.log