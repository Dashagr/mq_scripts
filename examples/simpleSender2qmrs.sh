#MQ Setup
#========

#Check if the user has authority to administrate MQ


#Create a Queue Managers
crtmqm QM1
crtmqm QM2

#Start the Queue Manager
strmqm QM1
strmqm QM2

runmqsc QM1

#Create a Listener Port
DEFINE LISTENER(LISTENER.QM1) TRPTYPE(TCP) PORT(1901)

#Start the Listener Port
START LISTENER(LISTENER.QM1)

#Create a Channel to connect the sender app and QM1
DEFINE CHANNEL(CHNL.APPTOQM1) CHLTYPE(SVRCONN) TRPTYPE(TCP)

#Create a Queuees
DEFINE QLOCAL(QM1QUEUE)

#Create a user in the MQ server for Messaging
'daria' user requires enough authority to connect to the queue manager and its objects

SET AUTHREC OBJTYPE(QMGR) PRINCIPAL('daria') AUTHADD(ALL)
SET AUTHREC OBJTYPE(QUEUE) PROFILE('**') PRINCIPAL('daria') AUTHADD(ALL)
SET AUTHREC OBJTYPE(CHANNEL) PROFILE('**') PRINCIPAL('daria') AUTHADD(ALL)
REFRESH SECURITY(*)

#==============
#Transmission part

# Define and start a transmittion Listener. 
define listener(LISTENER.TRANSMISSION) trptype(tcp) control(qmgr) port(1900)
start listener(LISTENER.TRANSMISSION)

# Define a local queue:

# Define a local queue (used for transmission):
define qlocal(QM_QM2) usage(xmitq)

# Define a remote queue
define qremote(Q2QUEUE_QM_QM2) rname(Q2QUEUE) rqmname(QM2) xmitq(QM_QM2)

# Define a receiving channel
define channel(CHNL.QM_QM2.QM_QM1) chltype(RCVR) trptype(TCP)
start channel(CHNL.QM_QM2.QM_QM1)

# Define a sender channel:
define channel(CHNL.QM_QM1.QM_QM2) chltype(SDR) conname('localhost(1900)') xmitq(QM_QM2) trptype(TCP)

# Start the sender channel
start channel(CHNL.QM_QM1.QM_QM2)

#CREATE AN ALIAS
#DEFINE QALIAS (QM2.IMAGE) TARGET ()


#=========
#QM2 setup

runmqsc QM2

#Create a Listener Port
DEFINE LISTENER(LISTENER.QM2) TRPTYPE(TCP) PORT(1902)

#Start the Listener Port
START LISTENER(LISTENER.QM2)

#Create a Channel to connect the sender app and QM1
DEFINE CHANNEL(CHNL.QM2TOAPP) CHLTYPE(SVRCONN) TRPTYPE(TCP)

#Create a Queuees
DEFINE QLOCAL(Q2QUEUE)

#Create a user in the MQ server for Messaging

SET AUTHREC OBJTYPE(QMGR) PRINCIPAL('daria') AUTHADD(ALL)
SET AUTHREC OBJTYPE(QUEUE) PROFILE('**') PRINCIPAL('daria') AUTHADD(ALL)
SET AUTHREC OBJTYPE(CHANNEL) PROFILE('**') PRINCIPAL('daria') AUTHADD(ALL)
REFRESH SECURITY(*)

#==============
#Transmission part

#Define and start a Listener
define listener(LISTENER.TRANSMISSION) trptype(tcp) control(qmgr) port(1910)
start listener(LISTENER.TRANSMISSION)

# Define a local queue (used for transmission)
define qlocal(QM_QM1) usage(xmitq)

# Define a remote queue:
define qremote(Q1QUEUE_QM_QM1) rname(Q1QUEUE) rqmname(QM1) xmitq(QM_QM1)

# Define a receiving channel
define channel(CHNL.QM_QM1.QM_QM2) chltype(RCVR) trptype(TCP)

# Define a sender channel
define channel(CHNL.QM_QM2.QM_QM1) chltype(SDR) conname('localhost(1910)') xmitq(QM_QM1) trptype(TCP)

# Start the sender channel
start channel(CHNL.QM_QM2.QM_QM1)

#===
# Backstop rules
# To block everyone
SET CHLAUTH('*') TYPE(ADDRESSMAP) ADDRESS('*') USERSRC(NOACCESS) DESCR('Back-stop rule') 

# Let this address come
SET CHLAUTH('CHNL.APPTOQM1') TYPE(ADDRESSMAP) ADDRESS('127.0.0.1') USERSRC(CHANNEL)

# The address that knocking you can see in the logs in the error




#sender

-Dhostname=localhost
-Dport=1414
-Dchannel=CHNL.QMDASHANOTLS
-Dqmgr=QMDasha
-DsenderQ=QMDASHAQUEUE
-Duser=appuser
-Dpwd=appuser
-Dnumsgs=2
-DlogFile=/home/daria/Documents/SimpleSender.log

#receiver

-Dhostname=localhost
-Dport=1414
-Dchannel=CHNL.QMDASHANOTLS
-Dqmgr=QMDasha
-DreceiverQ=QMDASHAQUEUE
-Duser=appuser
-Dpwd=appuser
-Dnumsgs=2
-DlogFile=/home/daria/Documents/SimpleSender.log