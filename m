From: sbp <sbp@extio.de>
Subject: dm-cache always dirty in writethrough mode
Date: Sun, 4 Oct 2015 13:52:58 +0200
Message-ID: <5611131A.6080705@extio.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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

Hi,

I've set up a SSD cache of a data hard drive via dm-cache. The dm-cache 
is set up in writethrough mode. As far as I understand writethrough mode 
all writes are sent to the underlying device immediately, so there 
should be no need to write back the cache later to the device.

What I encounter is that every time I reboot the machine, the whole 
cache is marked as dirty and written to the hard drive, even when there 
were 0 interactions with the cache before.

Is this behaviour expected? Can it be configured differently, so that 
not the whole cache is written back in writethrough mode every time it 
is assembled?

There is one special point about my setup: I don't use extra partitions 
for cache and meta data devices, but mapped files on the (SSD) root file 
system as loop devices. But this should not matter?

Information about my setup:

* Kernel version 4.2.1

* Script to set up dm cache on boot:

losetup /dev/loop0 /root/dm-cache
losetup /dev/loop1 /root/dm-cache-meta
dmsetup create cache_sdb1 --table "0 3907026944 cache /dev/loop1 
/dev/loop0 /dev/disk/by-id/ata-ST2000DL003-9VT166_5YD2RBZH-part1 128 1 
writethrough smq 0"

* Script to tear down cache on shutdown:

dmsetup suspend cache_sdb1
dmsetup remove cache_sdb1
losetup -d /dev/loop0
losetup -d /dev/loop1

Symptoms:

Every time after I booted the machine, dmsetup status tells me that all 
cache pages are dirty:

cruncher2 ~ # dmsetup status cache_sdb1
0 3907026944 cache 8 788/5120 128 262144/262144 381147 12035523 263945 
491215 0 0 218414 1 writethrough 2 migration_threshold 2048 smq 0 rw -

I've entered the command after some pages were already written back, 
that's why below command show a lot, but not all pages dirty. But pages 
are really written from SSD cache to the hard disk:

cruncher2 ~ # iostat -dm 0
Linux 4.2.1-gentoo (cruncher2)  10/04/2015      _x86_64_        (2 CPU)

Device:            tps    MB_read/s    MB_wrtn/s    MB_read MB_wrtn
loop0           781.38        48.71         0.00       1731 0
loop1            15.64         0.07         0.00          2 0
sda             694.88        58.81         0.22       2090 7
sdb             729.03         0.02        48.67          0 1730
dm-0              0.53         0.00         0.00          0 0

Devices:
loop0: cache
loop1: cache meta
sda: SSD holding l0 and l1
sdb: Hard drive

I'm wondering whether the tear down has to be done differently, but I've 
already googled a lot and could not find any similar case. So I hope 
that you can explain me whether this behaviour is expected or not and if 
there is a way to prevent the cache written back every time.

Thanks in advance!
