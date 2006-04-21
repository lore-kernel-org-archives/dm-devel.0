From: Steve Feehan <sfeehan@sbb.uvm.edu>
Subject: Failover on StorageWorks HSG80
Date: Fri, 21 Apr 2006 12:32:30 -0400
Message-ID: <20060421163230.GA18905@ingress.sbb.uvm.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

First I want to thank everyone for helping with my original
question:

  http://www.redhat.com/archives/dm-devel/2006-April/msg00086.html

Now that I have basic connectivity working I have started
to test failover. Here is what I see before initiating failover:

sfeehan@dogwood:~$ sudo multipath -ll
red (360001fe10015bf500009947159810015)
[size=203 GB][features=1 queue_if_no_path][hwhandler=1 hp_sw]
\_ round-robin 0 [prio=2][active]
 \_ 0:0:0:1 sda 8:0   [active][ready]
 \_ 0:0:1:1 sdb 8:16  [active][ready]
\_ round-robin 0 [prio=2][enabled]
 \_ 0:0:2:1 sdc 8:32  [active][ghost]
 \_ 0:0:3:1 sdd 8:48  [active][ghost]

I connect to the controller that is not "active" for the unit and do:

>>> shutdown other

Things seem to go well at first. In syslog I see:

Apr 21 11:52:22 dogwood -- MARK --
Apr 21 11:53:12 dogwood kernel: [42950687.100000]  rport-0:0-0: blocked FC remote port time out: removing target and saving binding
Apr 21 11:53:12 dogwood kernel: [42950687.210000]  rport-0:0-1: blocked FC remote port time out: removing target and saving binding
Apr 21 11:53:12 dogwood kernel: [42950687.330000]  0:0:0:1: SCSI error: return code = 0x10000
Apr 21 11:53:12 dogwood kernel: [42950687.400000] end_request: I/O error, dev sda, sector 20981638
Apr 21 11:53:12 dogwood kernel: [42950687.480000] end_request: I/O error, dev sda, sector 20981646
Apr 21 11:53:12 dogwood kernel: [42950687.560000] device-mapper: dm-multipath: Failing path 8:0.
Apr 21 11:53:12 dogwood multipathd: 8:0: hp_sw checker reports path is down
Apr 21 11:53:12 dogwood kernel: [42950687.630000]  0:0:1:1: rejecting I/O to dead device
Apr 21 11:53:12 dogwood kernel: [42950687.700000] device-mapper: dm-multipath: Failing path 8:16.
Apr 21 11:53:12 dogwood kernel: [42950687.770000] device-mapper: hp_sw: queueing START_STOP command on 8:48
Apr 21 11:53:12 dogwood kernel: [42950687.860000]  0:0:1:1: rejecting I/O to dead device
Apr 21 11:53:12 dogwood multipathd: checker failed path 8:0 in map red
Apr 21 11:53:12 dogwood multipathd: red: remaining active paths: 3
Apr 21 11:53:12 dogwood kernel: [42950687.930000] device-mapper: hp_sw: hp_sw_endio 0x8000002
Apr 21 11:53:13 dogwood kernel: [42950687.930000] dm-hp-sw: Current: sense key: Unit Attention
Apr 21 11:53:13 dogwood kernel: [42950687.930000]     <<vendor>> ASC=0xa0 ASCQ=0x8ASC=0xa0 ASCQ=0x8
Apr 21 11:53:13 dogwood multipathd: 8:16: hp_sw checker reports path is down
Apr 21 11:53:13 dogwood multipathd: checker failed path 8:16 in map red
Apr 21 11:53:13 dogwood multipathd: red: remaining active paths: 2
Apr 21 11:53:13 dogwood multipathd: 8:48: hp_sw checker reports path is up
Apr 21 11:53:13 dogwood multipathd: 8:48: reinstated
Apr 21 11:53:13 dogwood kernel: [42950688.200000] device-mapper: dm-multipath: error getting device
Apr 21 11:53:13 dogwood kernel: [42950688.280000] device-mapper: error adding target to table
Apr 21 11:53:13 dogwood multipathd: sda: remove path (uevent)
Apr 21 11:53:13 dogwood multipathd: red: failed in domap for removal of path sda
Apr 21 11:53:13 dogwood multipathd: uevent trigger error
Apr 21 11:53:13 dogwood multipathd: sdb: remove path (uevent)
Apr 21 11:53:13 dogwood multipathd: red: load table [0 426583554 multipath 1 queue_if_no_path 1 hp_sw 1 1 round-robin 0 2 1 8:32 1000 8:48 1000]
Apr 21 11:53:13 dogwood kernel: [42950688.350000] device-mapper: hp_sw: queueing START_STOP command on 8:48
Apr 21 11:53:33 dogwood multipathd: 8:32: hp_sw checker reports path is up
Apr 21 11:53:33 dogwood multipathd: 8:32: reinstated


So far I think everything is OK. IO appears to continue. And this is
what 'multipath -ll' says:

sfeehan@dogwood:~$ sudo multipath -ll
Password:
red (360001fe10015bf500009947159810015)
[size=203 GB][features=1 queue_if_no_path][hwhandler=1 hp_sw]
\_ round-robin 0 [prio=2][active]
 \_ 0:0:2:1 sdc 8:32  [active][ready]
 \_ 0:0:3:1 sdd 8:48  [active][ready]

And then I restart the down controller. A few seconds later, 
the devices (sda and sdb) are detected and I get the "READ CAPACITY
failed" errors and these errors (repeated continuosly):

Apr 21 12:04:15 dogwood multipathd: red: failed in domap for addition of new path sda
Apr 21 12:04:15 dogwood multipathd: red: uev_add_path sleep
Apr 21 12:04:16 dogwood kernel: [42951351.920000] device-mapper: device 8:0 too small for target
Apr 21 12:04:16 dogwood kernel: [42951352.000000] device-mapper: dm-multipath: error getting device
Apr 21 12:04:17 dogwood kernel: [42951352.080000] device-mapper: error adding target to table
Apr 21 12:04:17 dogwood multipathd: red: failed in domap for addition of new path sda
Apr 21 12:04:17 dogwood multipathd: red: uev_add_path sleep
Apr 21 12:04:18 dogwood kernel: [42951353.160000] device-mapper: device 8:0 too small for target
Apr 21 12:04:18 dogwood kernel: [42951353.240000] device-mapper: dm-multipath: error getting device
Apr 21 12:04:18 dogwood kernel: [42951353.320000] device-mapper: error adding target to table

So I suspsect that I need to do the "force path size redetection" trick
(which is also done by the init script at boot):

root@dogwood:~# sg_start -start /dev/sda; sleep 1; \
  echo 1 > /sys/block/sda/device/rescan
root@dogwood:~# sg_start -start /dev/sdb; sleep 1; \
  echo 1 > /sys/block/sdb/device/rescan

But it doesn't seem to make a difference. The errors continue.
And on top of all this, I see:

root@dogwood:~# multipath -ll
red (360001fe10015bf500009947159810015)
[size=203 GB][features=1 queue_if_no_path][hwhandler=1 hp_sw]
\_ round-robin 0 [prio=2][enabled]
 \_ 0:0:2:1 sdc 8:32  [failed][ghost]
 \_ 0:0:3:1 sdd 8:48  [failed][ghost]

At this point, I do:

root@dogwood:~# multipath -v2
device-mapper ioctl cmd 9 failed: Invalid argument
device-mapper ioctl cmd 9 failed: Invalid argument
device-mapper ioctl cmd 9 failed: Invalid argument
device-mapper ioctl cmd 9 failed: Invalid argument
root@dogwood:~#
root@dogwood:~# multipath -ll
red (360001fe10015bf500009947159810015)
[size=203 GB][features=1 queue_if_no_path][hwhandler=1 hp_sw]
\_ round-robin 0 [prio=2][active]
 \_ 0:0:2:1 sdc 8:32  [active][ready]
 \_ 0:0:3:1 sdd 8:48  [active][ready]


And then IO /appears/ (at least according to iostat) to continue 
on that path. But it's still complaining about the size of device
8:0 (sda). So I do the "force path size reduction" trick again,
and again it fails. And on top of that, IO stops and I get the same 
output from 'multipath -ll':

root@dogwood:~# multipath -ll
red (360001fe10015bf500009947159810015)
[size=203 GB][features=1 queue_if_no_path][hwhandler=1 hp_sw]
\_ round-robin 0 [prio=2][enabled]
 \_ 0:0:2:1 sdc 8:32  [failed][ghost]
 \_ 0:0:3:1 sdd 8:48  [failed][ghost]

Doing:

root@dogwood:~# multipath -v2
device-mapper ioctl cmd 9 failed: Invalid argument
device-mapper ioctl cmd 9 failed: Invalid argument
device-mapper ioctl cmd 9 failed: Invalid argument
device-mapper ioctl cmd 9 failed: Invalid argument
root@dogwood:~# multipath -ll
red (360001fe10015bf500009947159810015)
[size=203 GB][features=1 queue_if_no_path][hwhandler=1 hp_sw]
\_ round-robin 0 [prio=2][active]
 \_ 0:0:2:1 sdc 8:32  [active][ready]
 \_ 0:0:3:1 sdd 8:48  [active][ready]

Seems to get me right back where I was before.

I hope I've described the problem accurately (and I apologize
for the length of the post). So does anyone have a comment on 
what's going on and how to resolve this? How can I bring the
devices (sda and sdb) back into the multipath configruration
short of rebooting the system?

Thanks.

ps. I have started (and will continue) to document all of
this on the Wiki. Here is what I have so far (very incomplete):

http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=UbuntuHsg80Install

-- 
Steve Feehan
