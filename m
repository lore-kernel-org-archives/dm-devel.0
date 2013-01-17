From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-integrity: integrity protection device-mapper target
Date: Wed, 16 Jan 2013 23:54:23 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1301151955280.7468@file.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com, alan.cox@intel.com, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Hi Dmitry

I looked at dm-integrity. The major problem is that if crash happens when 
data were written and checksum wasn't, the block has incorrect checksum 
and can't be read again.

How is this integrity target going to be used? Will you use it in an 
environment where destroying data on crash doesn't matter? (can you 
describe such environment?)

It could possibly be used with ext3 or ext4 with data=journal mode - in 
this mode, the filesystem writes everything to journal and overwrites data 
and metadata with copy from journal on reboot, so it wouldn't matter if a 
block that was being written is unreadable after the reboot. But even with 
data=journal there are still some corner cases where metadata are 
overwritten without journaling (for example fsck or tune2fs utilities) - 
and if a crash happens, it could make metadata unreadable.

The big problem is that this "make blocks unreadable on crash" behavior 
cannot be easily fixed, fixing it means complete redesign.



Some minor comments about the code:

DM_INT_STATS: there are existing i/o counters in dm, you can use them

"static DEFINE_MUTEX(mutex);
static LIST_HEAD(dmi_list);
static int sync_mode;
static struct dm_int_notifier;" - you can have per-device reboot notifier 
and then you don't have to use global variables

"loff_t" - use sector_t instead. On 32-bit machines, sector_t can be 
32-bit or 64-bit (according to user's selection), but loff_t is always 
64-bit. loff_t should be generally used for indexing bytes within a file, 
sector_t for indexing sectors.

"struct dm_int->mutex" - unused variable
"struct dm_int->delay", DM_INT_FLUSH_DELAY - unused variable and macro

"struct kmem_cache *io_cache, mempool_t *io_pool" - use per-bio data 
instead (so you can remove the cache and mempool and simplify the code).
Per-bio data were committed to 3.8-rc1, see commits 
c0820cf5ad09522bdd9ff68e84841a09c9f339d8, 
39cf0ed27ec70626e416c2f4780ea0449d405941, 
e42c3f914da79102c54a7002329a086790c15327, 
42bc954f2a4525c9034667dedc9bd1c342208013

"struct dm_int->count" - this in-flight i/o count is not needed. Device 
mapper makes sure that when the device is suspended or unloaded, there are 
no bios in flight, so you don't have to duplicate this logic in the target 
driver. "struct dm_int->count" is used in dm_int_sync, dm_int_sync is 
called from ioctl BLKFLSBUF and dm_int_postsuspend.
- for BLKFLSBUF, it doesn't guarantee that in-progress io gets flushed, so 
you don't have to wait for it, doing just dm_bufio_write_dirty_buffers 
would be ok.
- for dm_int_postsuspend, dm guarantees that there is no io in progress at 
this point, so you don't have to wait for dm_int->count
- so you can remove "dm_int->count" and "dm_int->wait"

dm_bufio_prefetch can be called directly from dm_int_map routine (and 
maybe it should be called from there so that prefetch overlaps with 
workqueue processing)

dm_int_ctr at various places jumps to err label without setting ti->error. 
This results in message "table: 254:0: integrity: Unknown error".

It reports multiple messages when verification fails:
ERROR: HMACs do not match
ERROR: size is not zero: 4096
ERROR: io done: -5
And there is extra empty line after each error in the log (you shouldn't 
use '\n' in DMERR and DMWARN because there macros already append it).
I think just one message could be sufficient (maybe you can also add the 
block number of the failed block).

Mikulas
