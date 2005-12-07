From: Maxim Kozover <maximkoz@netvision.net.il>
Subject: kpartx issues
Date: Wed, 07 Dec 2005 16:27:00 +0300
Message-ID: <15410384490.20051207162700@netvision.net.il>
Reply-To: Maxim Kozover <maximkoz@netvision.net.il>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
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

Hi!
I'd like to report the following issues:
1. 
Suppose I have a disk I use in Solaris x86. It has a partition created in Solaris and slices inside. 
Linux understands Solaris x86 slices inside Solaris partitions and makes the slices available as Linux partitions 
(as if Solaris partitions were extended partitions and Solaris slices were logical partitions). 
sdb: assuming drive cache: write through 
sdb1: <solaris: [s2] sdb5 > 

I added strace to kpartx entry in udev rules and we see that it's endlessly called: 
execve("/sbin/kpartx", ["/sbin/kpartx", "-a", "/dev/mapper/1MY-STOR_AGE1030_____10140______1"], [/* 11 vars */]) = 0 
execve("/sbin/kpartx", ["/sbin/kpartx", "-a", "/dev/mapper/1MY-STOR_AGE1030_____10140______1p1"], [/* 11 vars */]) = 0 
execve("/sbin/kpartx", ["/sbin/kpartx", "-a", "/dev/mapper/1MY-STOR_AGE1030_____10140______1p1p1"], [/* 11 vars */]) = 0 
until crashes. 

Indeed
# kpartx -l /dev/sdb
sdb1 : 0 192780 /dev/sdb 16065

# kpartx -l /dev/mapper/1MY-STOR_AGE1030_____10140______1
1MY-STOR_AGE1030_____10140______1p1 : 0 192780 /dev/mapper/1MY-STOR_AGE1030_____10140______1 16065

But
# kpartx -l /dev/sdb1
sdb1p1 : 0 160650 /dev/sdb1 0

When kpartx adds partition, a dm-device is also added for it (map created).
Then the process becomes recursive since kpartx is called for every dm-device.
When Solaris slices/disklabel are not present, this process ends at /dev/sdb1,
cause kpartx doesn't find inner partitions.
But when they are present it becomes recursive.

2. Why is there a need in a separate kpartx code? Doesn't default
kernel partition scanning work reliably and finds correctly Solaris
slices etc.? Can't we find a way to use a kernel partitioning info
like in /sys/block/sdx/sdxn for feeding parameters to device-mapper?

Thanks, 

Maxim. 
