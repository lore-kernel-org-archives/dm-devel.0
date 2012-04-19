From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCHES]: dm lock optimization
Date: Wed, 18 Apr 2012 23:03:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1204182249060.12984@file.rdu.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I placed dm lock optimization patches here

http://people.redhat.com/mpatocka/patches/kernel/dm-lock-optimization/

The patches remove cache-line bouncing from device mapper when multiple 
processors submit requests simultaneously.


I was able to measure performance improvement, although in a very specific 
setup (it is unmeasurable with normal disks).

The setup to measure it is:
- two quad-core Opterons
- use ramdisk as a block device, leave it empty
- create 11 nested dm-linear mappings on it (so that each i/o passes 
through 11 levels of dm-linear and then goes to the ramdisk)
- run fio with 8 threads, using direct-io to read 512-byte blocks
(time fio --rw=randread --size=1G --bsrange=512-512 --direct=1 
--filename=/dev/mapper/dm-test --name=job1 --name=job2 --name=job3 
--name=job4 --name=job5 --name=job6 --name=job7 --name=job8)

With this setup it can be measured that the patches help:

no patch (3.3 kernel):  68.9s
patch 1:                64.3s
patch 1,2:              52.3s
patch 1,2,3:            45.2s
patch 1,2,3,4:          41.2s
patch 1,2,3,4,5:        34.0s

Mikulas
