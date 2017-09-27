From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/4] The dm-writecache target
Date: Wed, 27 Sep 2017 11:43:41 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1709271122410.9676@file01.intranet.prod.int.rdu2.redhat.com>
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
To: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Edward Thornber <thornber@redhat.com>
List-Id: dm-devel.ids

Hi

Here I'm sending the work-in-progress dm-writecache target. It supports 
kernels 4.13 and 4.14-rc.

It supports write caching on persistent memory or SSD. On first use, the 
first sector of the cache device must be zeroed. If the first sector 
doesn't contain valid superblock or zeroes, it is considered error.
Example use:

Persistent memory cache (/dev/sda5 is the base device, /dev/pmem0 is cache):
dmsetup create wc --table "0 24709688 writecache p /dev/sda5 /dev/pmem0 4096 0"

SSD caching:
dmsetup create wc --table "0 24709688 writecache s /dev/sda5 /dev/sdb1 4096 0"

For testing (if you don't have a system with persistent memory), it can 
also use ramdisk as persistent memory. You must enable CONFIG_BLK_DEV_RAM_DAX
dmsetup create wb --table "0 24709688 writecache p /dev/sda5 /dev/ram0 4096 0"

Note: It turned out that on a Broadwell system the clwb instruction is 
really slow (the performance of flushing contiguous range of memory is 
about 350MB/s), so it needs to be changed to use non-temporal store 
instructions that bypass the cache.

The metadata format is "struct wc_memory_superblock" and "struct 
wc_memory_entry" (if seq_count for a particular entry is smaller than 
seq_count in the superblock, the block is considered committed). In 
memory, it builds a tree of structures "struct wc_entry". The tree is 
built on each activation and it is not stored in persistent memory.

Mikulas
