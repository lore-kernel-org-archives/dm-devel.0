From: tormen <tormen@gmx.net>
Subject: Questions about dm-raid isw (device naming and partition
	table)
Date: Fri, 06 Aug 2010 11:42:41 -0400
Message-ID: <4C5C2D71.7010706@gmx.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

 Hi everybody,

I am new to dm-raid and have a couple of questions regarding how it works
(specifically regarding the device naming and access to the partition
table).

Any answer (or references to documentation) would be great!

Before I start with my questions: A short description of my use case for
dm-raid isw:

I am having a notebook with a RAID-0 (stripe) intel fake hardware raid
(on 4 sata devices :)).

Out of the box (setup by the manufacturer - with Win7) when starting
with the linux rescue cd (that used dm-raid isw),
I got these partitions:
    dm-0 (seemed to be everything == the 4 drives combined)
    dm-1 (primary partition)
    dm-2 (primary partition, active)
    dm-3 (primary parition)

After repartioning (with linux based acronis disk-director that also
uses dm-raid isw)
now I have:
    dm-0, dm-1, ... dm-10 where dm-0 still seems to be the WHOLE
raid-disk and dm-1 to dm-10 represent the 10 partitions (logical and/or
primary).

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

/1st/ question:
With dm-raid isw and 1 RAID: dm-0 is everything (like the whole virtual
(raid) disk)?

/2nd/ question:
Can I use cfdisk to access the parition table / view the partioning
under linux?
... because when I try
        cfdisk /dev/dm-0
I get this error message:
        "FATAL ERROR: Bad primary partition 1: Partition ends in the
final partial cyllinder
And the same when I try to print the partition table with cfdisk.

If I start cfdisk -z /dev/dm-0 it works and could (from scratch)
partition the raid-drive.
But I noticed that then the partitions seem to be called dm-0p1, dm-0p2
(I hope I recall the naming correctly).

/3rd/ question:
Why would the partitions be called dm-0p1, dm0p2, ... within cfdisk
while otherwise I see dm-1, dm-2, ... ?
What is the difference between dm-0p1 and dm-1?

/4th/ question:
So regardless of logical / primary partitions the devices are always
named consecutively (1, 2, 3...)?
(in contrast to: /dev/sda1.../dev/sda4 beging primary paritions and
/dev/sda5 being the first logical partition)

/5th/ question:
Is there a way to partition the raid (e.g. with cfdisk) under linux
(without using third party software like acronis) so that Win7 and Linux
can access the raid-drive / partition table ((and don't complain about
fatal errors))?

/6th/ question:
Does the "partition 1" from the above cfdisk fatal error message refer
to /dev/dm-1
(because that is the 1st partition on the raid device /dev/dm-0) or what
partition / device
does it refer to?

Thanks a lot in advance for any hint / advise!

Best,

Knuth
