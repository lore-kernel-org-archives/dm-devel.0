From: Lazar Obradovic <laza@yu.net>
Subject: multipath/gfs lockout under heavy write
Date: Mon, 24 Jan 2005 20:57:28 +0100
Message-ID: <1106596648.13534.79.camel@laza.eunet.yu>
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
To: linux-cluster@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,  

I'm not quite sure if the problem I'm experiencing is GFS or
dm-multi/multipath issue, so I'm writing to both lists... sorry for that
and please trim as soon as you realise who is it for.

This is the scenario: 

I've created two-node cluster and mounted two LVs on each of them: 

/dev/vg/data on /mnt/data type gfs (rw)
/dev/vg/syslog on /var/log/ng type gfs (rw)

Each node is running 2.6.10 with udm2 patch set, GFS and LVM2 fetched
from CVS on Jan, 19th and multipath-tools-0.4.1. Storage controller is
HSV110, and has two paths from each server to it: 

# multipath -v2 
create: 3600508b400013a6c00006000009c0000
[size=500 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [first]
  \_ 0:0:0:1 sda  8:0     [faulty]
  \_ 0:0:1:1 sdb  8:16    [ready ]
  \_ 0:0:2:1 sdc  8:32    [faulty]
  \_ 0:0:3:1 sdd  8:48    [ready ]

I tried to copy 100Gb of large files (each of them is about 15Gb) to
a /mnt/data through SSH connection from the third server to one of the
clustered. Looking at switch statistics, I saw that traffic was indeed
balanced over both FC links, but after copying almost 80Gb, without any
reason or unusual event on SAN/storage side, /dev/vg/data reported: 

SCSI error : <0 0 1 1> return code = 0x20000
end_request: I/O error, dev sdb, sector 401320376
end_request: I/O error, dev sdb, sector 401320384
Device sda not ready.
SCSI error : <0 0 3 1> return code = 0x20000
end_request: I/O error, dev sdd, sector 401321168
end_request: I/O error, dev sdd, sector 401321176
Buffer I/O error on device diapered_dm-2, logical block 37057899
lost page write due to I/O error on diapered_dm-2
Buffer I/O error on device diapered_dm-2, logical block 37057900
lost page write due to I/O error on diapered_dm-2
Buffer I/O error on device diapered_dm-2, logical block 37057901
lost page write due to I/O error on diapered_dm-2
Buffer I/O error on device diapered_dm-2, logical block 37057902
lost page write due to I/O error on diapered_dm-2
Buffer I/O error on device diapered_dm-2, logical block 37057903
lost page write due to I/O error on diapered_dm-2
Buffer I/O error on device diapered_dm-2, logical block 37057904
lost page write due to I/O error on diapered_dm-2
Buffer I/O error on device diapered_dm-2, logical block 37057905
lost page write due to I/O error on diapered_dm-2
Buffer I/O error on device diapered_dm-2, logical block 37057906
lost page write due to I/O error on diapered_dm-2
Buffer I/O error on device diapered_dm-2, logical block 37057907
lost page write due to I/O error on diapered_dm-2
Buffer I/O error on device diapered_dm-2, logical block 37057908
lost page write due to I/O error on diapered_dm-2
GFS: fsid=admin:data.0: fatal: I/O error
GFS: fsid=admin:data.0:   block = 37057898
GFS: fsid=admin:data.0:   function = gfs_dwrite
GFS: fsid=admin:data.0:   file = /usr/src/cluster/gfs-kernel/src/gfs/dio.c, line = 651
GFS: fsid=admin:data.0:   time = 1106582338
GFS: fsid=admin:data.0: about to withdraw from the cluster
GFS: fsid=admin:data.0: waiting for outstanding I/O
SCSI error : <0 0 1 1> return code = 0x20000
Device sdc not ready.
GFS: fsid=admin:data.0: warning: assertion "!buffer_busy(bh)" failed
GFS: fsid=admin:data.0:   function = gfs_logbh_uninit
GFS: fsid=admin:data.0:   file = /usr/src/cluster/gfs-kernel/src/gfs/dio.c, line = 930
GFS: fsid=admin:data.0:   time = 1106582351
printk: 54 messages suppressed.
Buffer I/O error on device diapered_dm-2, logical block 36272387
lost page write due to I/O error on diapered_dm-2
Buffer I/O error on device diapered_dm-2, logical block 37024703
lost page write due to I/O error on diapered_dm-2
GFS: fsid=admin:data.0: telling LM to withdraw
lock_dlm: withdraw abandoned memory
GFS: fsid=admin:data.0: withdrawn
printk: 12 messages suppressed.
Buffer I/O error on device diapered_dm-2, logical block 37005453
lost page write due to I/O error on diapered_dm-2
printk: 1036 messages suppressed.
Buffer I/O error on device diapered_dm-2, logical block 37006489
lost page write due to I/O error on diapered_dm-2
printk: 1035 messages suppressed.
Buffer I/O error on device diapered_dm-2, logical block 37007525
lost page write due to I/O error on diapered_dm-2

while /dev/vg/syslog continued to work as usual (dd-ing /dev/zero to
some file worked like a charm). After that error, SCP died, and I
couldn't umount nor remount that filesystem. Fenced didn't triggered so
I had to reboot the machine in order to make it work again (and I'm
using fence_ibmblade which works on another cluster I have).

Since both LVs are a part of same VG (and, thus, are using the same
physical device seen over multipath), I'd guess the problem is somewhere
inside GFS, but the things that keep confusing me are: 

- those SCSI errors that look like multipath errors
- name 'diapered_dm-2' which I never saw before
- fenced not fencing obviously faulty node

What else do you need to debug this issue?

Once again, sorry for the cross-post... 

-- 
Lazar Obradovic <laza@yu.net>
YUnet International, NOC

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
