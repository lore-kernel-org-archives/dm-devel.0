From: Mikulas Patocka <mpatocka@redhat.com>
Subject: ANNOUNCE: new dm statistics patches
Date: Thu, 4 Jul 2013 16:48:32 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1307041623530.17516@file01.intranet.prod.int.rdu2.redhat.com>
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
To: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Hi

I uploaded new statistics patches for 3.10 to 
http://people.redhat.com/mpatocka/patches/kernel/dm-statistics/current/

You need to apply the patch dm-optimize.patch, then apply 
dm-statistics.patch.

Use the Makefile to compile the userspace tool.



Basic usage:
============

./stats -c /dev/mapper/device

--- start collecting statistics, by default, statistics are collected for 
segments, each segment has 64MB. The segment size can be changed with -g. 
If the argument to -g is a positive number, it is the size of segment in 
512-byte sectors. If the the argument to -g is a negative number, the 
segment size is set so that device is divided into the specified number of 
segments.

./stats -q /dev/mapper/device
--- query the collected statistics (use --clear to clear them)

Query can be combined with --raw (report raw counters), --bi (use 
mebibytes), --nomerge (treat merged I/Os as separate). --seek (show 
approximate seek time instead of latency).

./stats -d /dev/mapper/device
--- delete the statistics

./stats -l
--- list all devices that have statistics collected


If the device is omitted, the command works on all active device mapper 
devices.


Advanced usage:
===============

./stats /dev/mapper/device -s <sector> -g <sectors>

--- subdivide the existing range into a smaller range. <sector> must be an 
start of some segment where statistics are already being collected. The 
command will subdivide the segment into many smaller segments, each having 
<sectors> sectors.

./stats -d /dev/mapper/device -s <sector>

--- delete a range that was previously created using the subdivide 
function.


./stats -a /dev/mapper/device

--- schedule the device for automatic subdivide. This option can be 
combined with the '-c' option to create initial statistics for the device.

For automatic subdivide to work, you need to run the "stats" program 
periodically from cron with no parameters.

When the device is scheduled for automatic subdivide, the system waits the 
specified amount of time (by default 600 seconds, can be set with 
--auto-subdivide-time), then takes 3 ranges with most I/O requests (can be 
set with --auto-subdivide-number) and subdivides them into 256 pieces (can 
be set with --auto-subdivide-granularity). If you specify 
--auto-subdivide-depth greater than 1, then the process is repeated at 
next interval (by default --auto-subdivide-depth is 1, which means that 
just one automatic subdivision is done).

./stats -da /dev/mapper/device

--- delete all statistics that were collected as a result of automatic 
subdivision.


Mikulas
