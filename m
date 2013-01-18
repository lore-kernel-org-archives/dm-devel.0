From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: dm-integrity: integrity protection device-mapper target
Date: Fri, 18 Jan 2013 23:43:34 +0200
Message-ID: <CALLzPKZVo3ng=Hz4cg0qrw0nDYsPjKy5AR=AJtMg+3PU=epz1w@mail.gmail.com>
References: <Pine.LNX.4.64.1301151955280.7468@file.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1301151955280.7468@file.rdu.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com, alan.cox@intel.com, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Hi Mikulas,

Thanks for looking into it.

On Thu, Jan 17, 2013 at 6:54 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> Hi Dmitry
>
> I looked at dm-integrity. The major problem is that if crash happens when
> data were written and checksum wasn't, the block has incorrect checksum
> and can't be read again.
>

This is how it works.
This is a purpose of integrity protection - do not allow "bad" content
to load and use.

But even with encryption it might happen that some blocks have been
updated and some not.
Even if  reading the blocks succeeds, the content can be a mess from
old and new blocks.

This patch I sent out has one missing feature what I have not pushed yet.
In the case of none-matching blocks, it just zeros blocks and returns
no error (zero-on-mismatch).
Writing to the block replaces the hmac.
It works quite nicely. mkfs and fsck is able to read and write/fix the
filesystem.


> How is this integrity target going to be used? Will you use it in an
> environment where destroying data on crash doesn't matter? (can you
> describe such environment?)
>

We are looking for possibility to use it in LSM based environment,
where we do not want
attacker could make offline modification of the filesystem and modify
the TCB related stuff.


> It could possibly be used with ext3 or ext4 with data=journal mode - in
> this mode, the filesystem writes everything to journal and overwrites data
> and metadata with copy from journal on reboot, so it wouldn't matter if a
> block that was being written is unreadable after the reboot. But even with
> data=journal there are still some corner cases where metadata are
> overwritten without journaling (for example fsck or tune2fs utilities) -
> and if a crash happens, it could make metadata unreadable.
>

In normal environment, if fsck crashes, it might corrupt file system
in the same way.
zero-on-mismatch makes block device still accessible/fixable for fsck.


> The big problem is that this "make blocks unreadable on crash" behavior
> cannot be easily fixed, fixing it means complete redesign.
>
>

zero-on-mismatch help here...

>
> Some minor comments about the code:
>
> DM_INT_STATS: there are existing i/o counters in dm, you can use them
>
> "static DEFINE_MUTEX(mutex);
> static LIST_HEAD(dmi_list);
> static int sync_mode;
> static struct dm_int_notifier;" - you can have per-device reboot notifier
> and then you don't have to use global variables
>

But why it would be better?

> "loff_t" - use sector_t instead. On 32-bit machines, sector_t can be
> 32-bit or 64-bit (according to user's selection), but loff_t is always
> 64-bit. loff_t should be generally used for indexing bytes within a file,
> sector_t for indexing sectors.

OK.

>
> "struct dm_int->mutex" - unused variable
> "struct dm_int->delay", DM_INT_FLUSH_DELAY - unused variable and macro
>

Left over when I switched from own metadata reading to BUFIO.

> "struct kmem_cache *io_cache, mempool_t *io_pool" - use per-bio data
> instead (so you can remove the cache and mempool and simplify the code).
> Per-bio data were committed to 3.8-rc1, see commits
> c0820cf5ad09522bdd9ff68e84841a09c9f339d8,
> 39cf0ed27ec70626e416c2f4780ea0449d405941,
> e42c3f914da79102c54a7002329a086790c15327,
> 42bc954f2a4525c9034667dedc9bd1c342208013
>

I have seen patch on dm-devel 2-3 or 3 months ago.
Did not know that it came to upstream yet.
Will do.

> "struct dm_int->count" - this in-flight i/o count is not needed. Device
> mapper makes sure that when the device is suspended or unloaded, there are
> no bios in flight, so you don't have to duplicate this logic in the target
> driver. "struct dm_int->count" is used in dm_int_sync, dm_int_sync is
> called from ioctl BLKFLSBUF and dm_int_postsuspend.
> - for BLKFLSBUF, it doesn't guarantee that in-progress io gets flushed, so
> you don't have to wait for it, doing just dm_bufio_write_dirty_buffers
> would be ok.
> - for dm_int_postsuspend, dm guarantees that there is no io in progress at
> this point, so you don't have to wait for dm_int->count
> - so you can remove "dm_int->count" and "dm_int->wait"
>

The purpose of dmint->count was to ensure that there is not only data blocks,
but also that there is no pending metadata writing is happening.
It was necessary before i switched to dm_bufio.
But yes, with a fresh look it seems it is not needed if
dm_bufio_write_dirty_buffer()
returns only after metadata is on the storage....

> dm_bufio_prefetch can be called directly from dm_int_map routine (and
> maybe it should be called from there so that prefetch overlaps with
> workqueue processing)
>

Will check.

> dm_int_ctr at various places jumps to err label without setting ti->error.
> This results in message "table: 254:0: integrity: Unknown error".
>

ok.

> It reports multiple messages when verification fails:
> ERROR: HMACs do not match
> ERROR: size is not zero: 4096
> ERROR: io done: -5
> And there is extra empty line after each error in the log (you shouldn't
> use '\n' in DMERR and DMWARN because there macros already append it).
> I think just one message could be sufficient (maybe you can also add the
> block number of the failed block).
>

right.

> Mikulas

Thanks for looking...
Will come back with fixes.

Dmitry
