From: "Nicholas A. Bellinger" <nick@pyxtechnologies.com>
Subject: dm-multipath + iscsi-initiator-core success, example,
	and questions
Date: Thu, 31 Mar 2005 15:52:11 -0800
Message-ID: <1112313131.14802.59.camel@haakon>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: iscsi-initiator-core-devel <iscsi-initiator-core-devel@iscsi-initiator-core.org>, dm-devel <dm-devel@redhat.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Ming Zhang <mingz@ele.uri.edu>, Christoph Hellwig <hch@lst.de>, Mike Christie <mikenc@us.ibm.com>
List-Id: dm-devel.ids

Greetings all,

While doing testing and gathering data for dm+multipath
+iscsi-initiator-core documentation, I had a few questions as to when
paths are considered offline when a path is blocked, and online when a
path is unblocked.

A little background on iSCSI Channels first:  An iSCSI Channel maps to a
struct Scsi_Host within the SCSI Midlayer.  It is an abstraction for
iSCSI Initiator management purposes that can keep track of IO and
settings once an iSCSI Session that is attached to said iSCSI Channel
has been logged out, or failed due to various exceptions.

Now, consider the examples using two iSCSI Channels defined
in /etc/sysconfig/initiator:

CHANNEL="20 1 eth0 192.168.0.60 3260 0 AuthMethod=CHAP,None"
CHANNEL="21 1 eth0 192.168.1.60 3260 0 AuthMethod=CHAP,None"

iSCSI Channels 20 and 21 are pointing to the same iSCSI Target Node, but
to different iSCSI Target Portal Groups with the _SAME_ LUN view behind
both Target Portals.

 Initiator Node	       Target Node
   ------------          ---------------------
  | Channel 20 | <----> | TPG 0 : 192.168.0.60| \
  |            |        |                     |  [LUN 0]
  | Channel 21 | <----> | TPG 1 : 192.168.1.60| /
   ------------          ---------------------

iSCSI Sessions with a single iSCSI Connection are started on Channels 20
and 21 with the following:

	/etc/rc.d/init.d/initiator start 20

iCHANNEL[20] - Allocated Linux SCSI Host with ID: 4
Received OK response from PyX Authentication Daemon, continuing.	
Received OK response from PyX Authentication Daemon, continuing.
iSCSI mutual authetication completed successfully.
iCHANNEL[20] - iSCSI login successful on CID: 0 to 192.168.0.60:3260,0
iCHANNEL[20] - Incremented iSCSI connection count to 1 to node:
iqn.2002-07.com.pyxtechnologies.target:sn.114364923233
iCHANNEL[20] - Established iSCSI session to node:
iqn.2002-07.com.pyxtechnologies.target:sn.114364923233
iSCSI Core Stack[1] - Incremented number of active iSCSI sessions to 1.
  Vendor: SEAGATE   Model: ST373454LC        Rev: 0002
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdb: 143374744 512-byte hdwr sectors (73408 MB)
SCSI device sdb: drive cache: write back
SCSI device sdb: 143374744 512-byte hdwr sectors (73408 MB)
SCSI device sdb: drive cache: write back
 sdb: unknown partition table

(... other output removed for example purposes)

	/etc/rc.d/init.d/initiator start 21

iCHANNEL[21] - Allocated Linux SCSI Host with ID: 5
Received OK response from PyX Authentication Daemon, continuing.
Received OK response from PyX Authentication Daemon, continuing.
iSCSI mutual authetication completed successfully.
iCHANNEL[21] - iSCSI login successful on CID: 0 to 192.168.1.60:3260,1
iCHANNEL[21] - Incremented iSCSI connection count to 1 to node:
iqn.2002-07.com.pyxtechnologies.target:sn.114364923233
iCHANNEL[21] - Established iSCSI session to node:
iqn.2002-07.com.pyxtechnologies.target:sn.114364923233
iSCSI Core Stack[1] - Incremented number of active iSCSI sessions to 2.
iSCSI Core Stack[1] - Incremented number of active iSCSI sessions to 2.
  Vendor: SEAGATE   Model: ST373454LC        Rev: 0002
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sdh: 143374744 512-byte hdwr sectors (73408 MB)
SCSI device sdh: drive cache: write back
SCSI device sdh: 143374744 512-byte hdwr sectors (73408 MB)
SCSI device sdh: drive cache: write back
 sdh: unknown partition table
 
(... other output removed for example purposes)

Consider the following simple table for dm-multipath, piped directly
into dmsetup:

echo "0 143374744 multipath 0 0 2 1 round-robin 0 2 1 8:16 1000 8:112
1000 round-robin 0 2 1 8:16 1000 8:112 1000" | dmsetup create dm0

Major/Minor 8:16 corresponds to iSCSI Channel 20, LUN 0 (/dev/sdb)
Major/Minor 8:112 corresponds to iSCSI Channel 21, LUN 0 (/dev/sdh)

Now consider the following example iSCSI management scenario while doing
READs to device-mapper:

lmdd if=/dev/mapper/dm0 of=/dev/null bs=4096

Now lets pause iSCSI Channel 20: (Note that pausing an iSCSI Channel
puts the attached struct Scsi_Host's struct scsi_devices into a blocked
state with scsi_internal_device_block()).

/etc/rc.d/init.d/initiator pause 20

iCHANNEL[20] - Stopped session on iSCSI Channel
iCHANNEL[20] - Stopped all action on iSCSI Channel
iCHANNEL[20] - Decremented iSCSI connection count to 0 to node:
iqn.2002-07.com.pyxtechnologies.target:sn.114364923233
SCSI error : <4 0 0 0> return code = 0x20000
end_request: I/O error, dev sdb, sector 9293248
device-mapper: dm-multipath: Failing path 8:16.
end_request: I/O error, dev sdb, sector 9293256
SCSI error : <4 0 0 0> return code = 0x20000
end_request: I/O error, dev sdb, sector 9293504
end_request: I/O error, dev sdb, sector 9293512
iCHANNEL[20] - released iSCSI session to node:
iqn.2002-07.com.pyxtechnologies.target:sn.114364923233
iSCSI Core Stack[1] - Decremented number of active iSCSI sessions to 1

Data on iSCSI Channel 21 continues to flow, but even once iSCSI Channel
20 is restarted with:

/etc/rc.d/init.d/initiator start 20 (Note that starting a paused iSCSI
Channel puts the attached struct Scsi_Host's struct scsi_devices into a
unblocked state with scsi_internal_device_unblock()). 

iCHANNEL[20] - Allocated Linux SCSI Host with ID: 4
Received OK response from PyX Authentication Daemon, continuing.
Received OK response from PyX Authentication Daemon, continuing.
iSCSI mutual authetication completed successfully.
iCHANNEL[20] - iSCSI login successful on CID: 0 to 192.168.0.60:3260,0
iCHANNEL[20] - Incremented iSCSI connection count to 1 to node:
iqn.2002-07.com.pyxtechnologies.target:sn.114364923233
iCHANNEL[20] - Established iSCSI session to node:
iqn.2002-07.com.pyxtechnologies.target:sn.114364923233
iSCSI Core Stack[1] - Incremented number of active iSCSI sessions to 2.

IO never goes back across iSCSI Channel 20.  I also noticed that this
does not occur every time iSCSI Channel 20 is paused.  Sometimes IO will
stop over iSCSI Channel 21 as well, but iSCSI Channel 20 can be started
and IO resumes correctly to both iSCSI Channels.

So my main question is this, once the iSCSI Channel is restarted and IO
is allowed to flow again, how does dm-multipath know that the device is
unlocked and online?

Thanks!

-- 
Nicholas A. Bellinger <nick@pyxtechnologies.com>
