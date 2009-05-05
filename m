From: Flemming Frandsen <flemming.frandsen@stibo.com>
Subject: DM vs. MD: The showdown
Date: Tue, 5 May 2009 14:51:39 +0200
Message-ID: <4A00365B.7030500@stibo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I've searched high and low for any info, but my google-fu has failed me, 
so feel free to redirect me to a more appropriate mailing list or 
documentation if this is too OT.

I have a box that had a working md RAID 1+0 setup, iow:
* /dev/md1 is a mirror containing /dev/sda2 and /dev/sdc2
* /dev/md2 is a mirror containing /dev/sdb2 and /dev/sdd2
* /dev/md3 is a stripe set of /dev/md1 and /dev/md2

The problem is that I recently had to enable multipath to hook up to the 
SAN, that part went ok, but afterwards my /proc/mdstat shows that dm 
seems to have renamed all my disks:
md1 : active raid1 dm-2[0]
       48829440 blocks [2/1] [U_]
md2 : active raid1 dm-3[0]
       48829440 blocks [2/1] [U_]

and mdadm can no longer create md3 because:
mdadm: no devices found for /dev/md3.

For some reason dm has found it funny to grab the md1 and md2 mirrors 
and use them to create the stripe set: /dev/mapper/md|md3

I've mounted the /dev/mapper/md|md3 device and it seems to contain my 
file system, but I'd really like to get dm out of the way and only use 
it to handle the multipath bits needed for the SAN.

How do I tell dm to keep its paws to itself?

I'm running Linux 2.6.20 (on a Ubuntu 7.04), btw.

-- 
  Regards Flemming Frandsen - Stibo Systems - DK - STEP Release Manager
