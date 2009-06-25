From: Charlie Brady <charlieb-dm-devel@budge.apana.org.au>
Subject: Re: RDAC path checker status change messages
Date: Thu, 25 Jun 2009 12:57:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0906251253570.4229@e-smith.charlieb.ott.istop.com>
References: <Pine.LNX.4.64.0906231548060.18687@e-smith.charlieb.ott.istop.com>
	<1245867321.26915.13.camel@chandra-ubuntu>
	<Pine.LNX.4.64.0906241615210.22601@e-smith.charlieb.ott.istop.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0906241615210.22601@e-smith.charlieb.ott.istop.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


On Wed, 24 Jun 2009, Charlie Brady wrote:

>>  If your concern is that the last message is "down", then we should be
>>  having a static variable and print up or ghost message only once (when
>>  we toggle from down to up/ghost).
>
> You do have a static variable, so that messages are only printed when the 
> status changes.

I think I need to retract that. The messages appear to be printed when the 
status is not changing, at least for the "path down" messages.

I've patched scsi_dh_rdac.c so that SUN/LCSM100_I is included in 
rdac_dev_list[], and restarted iscsi and multipathd. I've now provoked a 
path failure via iptables. Here are the logs I see (with unpatched 
multipathd) - the duplicate message suppression from the rdac path 
checker is not working:

Jun 25 12:35:02 sun4150node1 kernel: device-mapper: multipath: Using 
scsi_dh module scsi_dh_rdac for failover/failback and
  device management.
Jun 25 12:35:08 sun4150node1 multipathd: cannot open /sbin/dasd_id : No 
such file or directory
Jun 25 12:35:08 sun4150node1 multipathd: cannot open /sbin/gnbd_import : 
No such file or directory
Jun 25 12:35:08 sun4150node1 multipathd: [copy.c] cannot open 
/sbin/dasd_id
Jun 25 12:35:08 sun4150node1 multipathd: cannot copy /sbin/dasd_id in 
ramfs : No such file or directory
Jun 25 12:35:08 sun4150node1 multipathd: [copy.c] cannot open 
/sbin/gnbd_import
Jun 25 12:35:08 sun4150node1 multipathd: cannot copy /sbin/gnbd_import in 
ramfs : No such file or directory
Jun 25 12:35:08 sun4150node1 multipathd: mpath0: event checker started
Jun 25 12:35:02 sun4150node1 kernel: device-mapper: multipath: Using 
scsi_dh module scsi_dh_rdac for failover/failback and
  device management.
Jun 25 12:46:55 sun4150node1 kernel: ping timeout of 5 secs expired, last 
rx 1703243, last ping 1708243, now 1713243
Jun 25 12:46:55 sun4150node1 kernel:  connection3:0: iscsi: detected conn 
error (1011)
Jun 25 12:46:55 sun4150node1 iscsid: Kernel reported iSCSI connection 3:0 
error (1011) state (3)
Jun 25 12:48:55 sun4150node1 kernel:  session3: iscsi: session recovery 
timed out after 120 secs
Jun 25 12:48:55 sun4150node1 kernel: iscsi: cmd 0x12 is not queued (8)
Jun 25 12:48:55 sun4150node1 multipathd: path checkers start up
Jun 25 12:48:55 sun4150node1 multipathd: sdd: rdac checker reports path is 
down
Jun 25 12:48:55 sun4150node1 kernel: device-mapper: multipath: Failing 
path 8:48.
Jun 25 12:48:55 sun4150node1 multipathd: checker failed path 8:48 in map 
mpath0
Jun 25 12:48:55 sun4150node1 multipathd: mpath0: remaining active paths: 1
Jun 25 12:48:55 sun4150node1 multipathd: dm-2: add map (uevent)
Jun 25 12:48:55 sun4150node1 multipathd: dm-2: devmap already registered
Jun 25 12:49:00 sun4150node1 kernel: iscsi: cmd 0x12 is not queued (8)
Jun 25 12:49:00 sun4150node1 multipathd: sdd: rdac checker reports path is 
down
Jun 25 12:49:35 sun4150node1 last message repeated 7 times
Jun 25 12:49:35 sun4150node1 last message repeated 7 times
Jun 25 12:50:05 sun4150node1 last message repeated 6 times
Jun 25 12:50:05 sun4150node1 kernel: iscsi: cmd 0x28 is not queued (8)
Jun 25 12:50:05 sun4150node1 kernel: sd 14:0:0:0: SCSI error: return code 
= 0x00010000
Jun 25 12:50:05 sun4150node1 kernel: end_request: I/O error, dev sdd, 
sector 0
Jun 25 12:50:05 sun4150node1 kernel: Buffer I/O error on device sdd, 
logical block 0
Jun 25 12:50:05 sun4150node1 kernel: Buffer I/O error on device sdd, 
logical block 1
Jun 25 12:50:05 sun4150node1 kernel: Buffer I/O error on device sdd, 
logical block 2
Jun 25 12:50:05 sun4150node1 kernel: Buffer I/O error on device sdd, 
logical block 3
Jun 25 12:50:05 sun4150node1 kernel: iscsi: cmd 0x28 is not queued (8)
