From: Harald Milz <hm@seneca.muc.de>
Subject: Followup: multipath setup with emc clariion
Date: Sat, 10 Feb 2007 15:19:59 +0100
Message-ID: <20070210141959.GA24225@seneca.muc.de>
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

Hi,

I had a problem similar to the one described in
http://www.redhat.com/archives/dm-devel/2006-July/msg00034.html at  a
customer site (RHEL/RHCS 4.4) and found out that the solution is actually
quite easy. You just have to blacklist the LUNZ's WWID. Since I found
no related information anywhere I thought I'd post it here.

Our setup: a pair of Sun x4200 servers w/ Emulex LP11000 HBAs, RHEL4.4,
CLARiiON CX3-20, EMC / Broadcom FC Switches.

So what I did was:
- boot up the machine with FC cables pulled
- rmmod / modprobe lpfc - this re-scans the bus and creates the necessary
  kernel devices. You'll see the LUNZ's in /proc/scsi/scsi. 
- modprobe dm-multipath and run "multipath -v2" with just sda and sdb 
  blacklisted (internal disks)
- the command gives you the WWID of the LUNZ (size 1 GB, it's almost
  certainly mpath0), plus lots of error messages that dm-emc (or was it
  dm-multipath itself?) has failed paths for one of the devices. 
- add this WWID to the blacklist in /etc/multipath.conf
- you'll have to reset the machine or switch it off hard because kpartx is
  sitting on /dev/mapper/mpath0 in state "D". RHEL will wait forever and
  not shut down if you only do a "halt". 
- next time the box comes up, everything is fine. 
- I usually give all other WWIDs aliases in a multipaths{} section in order
  to have a consistent naming scheme, and use the alias names in /etc/fstab
  or wherever. Very handy in a HA/failover setup. 


Strange thing is, and this is almost certainly related to the CLARiiON
CX3-20 setup, on a second pair of machines attached to the same CX box, we
have no LUNZ whatsoever. Any insight why and when this is so? The point is,
you usually don't want the LUNZ devices if you want to do multipathing. 




-- 
Harris's Lament:
	All the good ones are taken.
