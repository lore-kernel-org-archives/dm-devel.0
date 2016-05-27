From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-crypt: Fix error with too large bios (was: bcache gets
 stuck flushing writeback cache when used in combination with LUKS/dm-crypt
 and non-default bucket size)
Date: Fri, 27 May 2016 10:47:02 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1605271037470.2109@file01.intranet.prod.int.rdu2.redhat.com>
References: <044401d1a958$ea7ef4e0$bf7cdea0$@codenest.com> <5739F07A.5090608@buttersideup.com> <alpine.LRH.2.11.1605191618560.22436@mx.ewheeler.net> <02b101d1b265$2bc46fb0$834d4f10$@codenest.com> <alpine.LRH.2.11.1605201322530.26328@mx.ewheeler.net>
 <034e01d1b3e2$1de2f910$59a8eb30$@codenest.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <034e01d1b3e2$1de2f910$59a8eb30$@codenest.com>
Sender: linux-bcache-owner@vger.kernel.org
To: James Johnston <johnstonj.public@codenest.com>
Cc: 'Eric Wheeler' <bcache@lists.ewheeler.net>, 'Tim Small' <tim@buttersideup.com>, 'Kent Overstreet' <kent.overstreet@gmail.com>, 'Alasdair Kergon' <agk@redhat.com>, 'Mike Snitzer' <snitzer@redhat.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, dm-crypt@saout.de, 'Neil Brown' <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

Hi

Here I'm sending a patch for this bug.

BTW. I found several other bugs in bcache when testing this.

1) make-bcache and the other tools do not perform endian conversion - 
consequently bcache doesn't work on big-endian machines.

2) bcache cannot be compiled on newer gcc because of inline keyword. Note 
that in GNU C, the inline keyword is just a hint that doesn't change 
correntness or behavior of a program. However, according to ANSI C, the 
inline keywork changes meaning of a program - GCC recently switched to 
ANSI C by default and so the code doesn't compile. This is a patch:

	--- bcache-tools.orig/bcache.c
	+++ bcache-tools/bcache.c
	@@ -115,7 +115,7 @@ static const uint64_t crc_table[256] = {
	        0x9AFCE626CE85B507ULL
	 };

	-inline uint64_t crc64(const void *_data, size_t len)
	+uint64_t crc64(const void *_data, size_t len)
	 {
	        uint64_t crc = 0xFFFFFFFFFFFFFFFFULL;
	        const unsigned char *data = _data;

3) dm-crypt returns large bios with -EIO and bcache responds by attempting 
to submit the bios again and again (which results in the reported loop). 
The patch below fixes dm-crypt to not return errors, however you should 
also fix bcache to handle errors gracefully (i.e. stop using the device on 
I/O error, and don't submit the bios over and over again).

Mikulas



On Sun, 22 May 2016, James Johnston wrote:

> > On Fri, 20 May 2016, James Johnston wrote:
> > 
> > > > On Mon, 16 May 2016, Tim Small wrote:
> > > >
> > > > > On 08/05/16 19:39, James Johnston wrote:
> > > > > > I've run into a problem where the bcache writeback cache can't be flushed to
> > > > > > disk when the backing device is a LUKS / dm-crypt device and the cache set has
> > > > > > a non-default bucket size.  Basically, only a few megabytes will be flushed to
> > > > > > disk, and then it gets stuck.  Stuck means that the bcache writeback task
> > > > > > thrashes the disk by constantly reading hundreds of MB/second from the cache set
> > > > > > in an infinite loop, while not actually progressing (dirty_data never decreases
> > > > > > beyond a certain point).
> > > > >
> > > > > > [...]
> > > > >
> > > > > > The situation is basically unrecoverable as far as I can tell: if you attempt
> > > > > > to detach the cache set then the cache set disk gets thrashed extra-hard
> > > > > > forever, and it's impossible to actually get the cache set detached.  The only
> > > > > > solution seems to be to back up the data and destroy the volume...
> > > > >
> > > > > You can boot an older kernel to flush the device without destroying it
> > > > > (I'm guessing that's because older kernels split down the big requests
> > > > > which are failing on the 4.4 kernel).  Once flushed you could put the
> > > > > cache into writethrough mode, or use a smaller bucket size.
> > > >
> > > > Indeed, can someone test 4.1.y and see if the problem persists with a 2M
> > > > bucket size?  (If someone has already tested 4.1, then appologies as I've
> > > > not yet seen that report.)
> > > >
> > > > If 4.1 works, then I think a bisect is in order.  Such a bisect would at
> > > > least highlight the problem and might indicate a (hopefully trivial) fix.
> > >
> > > To help narrow this down, I tested the following generic pre-compiled mainline kernels
> > > on Ubuntu 15.10:
> > >
> > >  * WORKS:  http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.3.6-wily/
> > >  * DOES NOT WORK:  http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.4-rc1+cod1-wily/
> > >
> > > I also tried the default & latest distribution-provided 4.2 kernel.  It worked.
> > > This one also worked:
> > >
> > >  * WORKS:  http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.2.8-wily/
> > >
> > > So it seems to me that it is a regression from 4.3.6 kernel to any 4.4 kernel.  That
> > > should help save time with bisection...
> > 
> > Below is the patchlist for md and block that might help with a place to
> > start.  Are there any other places in the Linux tree where we should watch
> > for changes?
> > 
> > I'm wondering if it might be in dm-4.4-changes since this is dm-crypt
> > related, but it could be ac322de which was quite large.
> > 
> > James or Tim,
> > 
> > Can you try building ac322de?  If that produces the problem, then there
> > are only 3 more to try (unless this was actually a problem in 4.3 which
> > was fixed in 4.3.y, but hopefully that isn't so).
> > 
> > ccf21b6 is probably the next to test to rule out neil's big md patch,
> > which Linus abreviated in the commit log so it must be quite long.  OTOH,
> > if dm-4.4-changes works, then I'm not sure what commit might produce the
> > problem because the rest are not obviously relevant to the issue that are
> > more recent. 
> 
> So I decided to go ahead and bisect it today.  Looks like the bad commit is
> this one.  The commit prior flushed the bcache writeback cache without
> incident; this one does not and I guess caused this bcache regression.
> (FWIW ac322de came up during bisection, and tested good.)
> 
> johnstonj@kernel-build:~/linux$ git bisect bad
> dbba42d8a9ebddcc1c1412e8457f79f3cb6ef6e7 is the first bad commit
> commit dbba42d8a9ebddcc1c1412e8457f79f3cb6ef6e7
> Author: Mikulas Patocka <mpatocka@redhat.com>
> Date:   Wed Oct 21 16:34:20 2015 -0400
> 
>     dm: eliminate unused "bioset" process for each bio-based DM device
> 
>     Commit 54efd50bfd873e2dbf784e0b21a8027ba4299a3e ("block: make
>     generic_make_request handle arbitrarily sized bios") makes it possible
>     for block devices to process large bios.  In doing so that commit
>     allocates a new queue->bio_split bioset for each block device, this
>     bioset is used for allocating bios when the driver needs to split large
>     bios.
> 
>     Each bioset allocates a workqueue process, thus the above commit
>     increases the number of processes allocated per block device.
> 
>     DM doesn't need the queue->bio_split bioset, thus we can deallocate it.
>     This reduces the number of allocated processes per bio-based DM device
>     from 3 to 2.  Also remove the call to blk_queue_split(), it is not
>     needed because DM does its own splitting.
> 
>     Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>     Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> 
> The patch for this commit is very brief; reproduced here:
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 9555843..64b50b7 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1763,8 +1763,6 @@ static void dm_make_request(struct request_queue *q, struct bio *bio)
> 
>         map = dm_get_live_table(md, &srcu_idx);
> 
> -       blk_queue_split(q, &bio, q->bio_split);
> -
>         generic_start_io_acct(rw, bio_sectors(bio), &dm_disk(md)->part0);
> 
>         /* if we're suspended, we have to queue this io for later */
> @@ -2792,6 +2790,12 @@ int dm_setup_md_queue(struct mapped_device *md)
>         case DM_TYPE_BIO_BASED:
>                 dm_init_old_md_queue(md);
>                 blk_queue_make_request(md->queue, dm_make_request);
> +               /*
> +                * DM handles splitting bios as needed.  Free the bio_split bioset
> +                * since it won't be used (saves 1 process per bio-based DM device).
> +                */
> +               bioset_free(md->queue->bio_split);
> +               md->queue->bio_split = NULL;
>                 break;
>         }
> 
> Here is the bisect log:
> 
> johnstonj@kernel-build:~/linux$ git bisect log
> git bisect start
> # good: [6a13feb9c82803e2b815eca72fa7a9f5561d7861] Linux 4.3
> git bisect good 6a13feb9c82803e2b815eca72fa7a9f5561d7861
> # bad: [8005c49d9aea74d382f474ce11afbbc7d7130bec] Linux 4.4-rc1
> git bisect bad 8005c49d9aea74d382f474ce11afbbc7d7130bec
> # bad: [118c216e16c5ccb028cd03a0dcd56d17a07ff8d7] Merge tag 'staging-4.4-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
> git bisect bad 118c216e16c5ccb028cd03a0dcd56d17a07ff8d7
> # good: [e627078a0cbdc0c391efeb5a2c4eb287328fd633] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux
> git bisect good e627078a0cbdc0c391efeb5a2c4eb287328fd633
> # good: [c17c6da659571a115c7b4983da6c6ac464317c34] staging: wilc1000: rename pfScanResult of struct scan_attr
> git bisect good c17c6da659571a115c7b4983da6c6ac464317c34
> # good: [7bdb7d554e0e433b92b63f3472523cc3067f8ab4] Staging: rtl8192u: ieee80211: corrected indent
> git bisect good 7bdb7d554e0e433b92b63f3472523cc3067f8ab4
> # good: [ac322de6bf5416cb145b58599297b8be73cd86ac] Merge tag 'md/4.4' of git://neil.brown.name/md
> git bisect good ac322de6bf5416cb145b58599297b8be73cd86ac
> # good: [a4d8e93c3182a54d8d21a4d1cec6538ae1be9e16] Merge tag 'usb-for-v4.4' of git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb into usb-next
> git bisect good a4d8e93c3182a54d8d21a4d1cec6538ae1be9e16
> # good: [4f56f3fdca43c9a18339b6e0c3b1aa2f57f6d0b0] serial: 8250: Tolerate clock variance for max baud rate
> git bisect good 4f56f3fdca43c9a18339b6e0c3b1aa2f57f6d0b0
> # good: [e052c6d15c61cc4caff2f06cbca72b183da9f15e] tty: Use unbound workqueue for all input workers
> git bisect good e052c6d15c61cc4caff2f06cbca72b183da9f15e
> # good: [b9ca0c948c921e960006aaf319a29c004917cdf6] uwb: neh: Use setup_timer
> git bisect good b9ca0c948c921e960006aaf319a29c004917cdf6
> # bad: [aad9ae4550755edc020b5c511a8b54f0104b2f47] dm switch: simplify conditional in alloc_region_table()
> git bisect bad aad9ae4550755edc020b5c511a8b54f0104b2f47
> # good: [a3d939ae7b5f82688a6d3450f95286eaea338328] dm: convert ffs to __ffs
> git bisect good a3d939ae7b5f82688a6d3450f95286eaea338328
> # bad: [00272c854ee17b804ce81ef706f611dac17f4f89] dm linear: remove redundant target name from error messages
> git bisect bad 00272c854ee17b804ce81ef706f611dac17f4f89
> # bad: [4c7da06f5a780bbf44ebd7547789e48536d0a823] dm persistent data: eliminate unnecessary return values
> git bisect bad 4c7da06f5a780bbf44ebd7547789e48536d0a823
> # bad: [dbba42d8a9ebddcc1c1412e8457f79f3cb6ef6e7] dm: eliminate unused "bioset" process for each bio-based DM device
> git bisect bad dbba42d8a9ebddcc1c1412e8457f79f3cb6ef6e7
> # first bad commit: [dbba42d8a9ebddcc1c1412e8457f79f3cb6ef6e7] dm: eliminate unused "bioset" process for each bio-based DM device
> 
> Commands used for testing:
> 
> # Make cache set
> make-bcache --bucket 2M -C /dev/sdb
> # Set up backing device crypto
> cryptsetup luksFormat /dev/sdc
> cryptsetup open --type luks /dev/sdc backCrypt
> # Make backing device & enable writeback
> make-bcache -B /dev/mapper/backCrypt
> bcache-super-show /dev/sdb | grep cset.uuid | cut -f 3 > /sys/block/bcache0/bcache/attach
> echo writeback > /sys/block/bcache0/bcache/cache_mode
> 
> # KILL SEQUENCE
> 
> cd /sys/block/bcache0/bcache
> echo 0 > sequential_cutoff
> # Verify that the cache is attached (i.e. does not say "no cache")
> cat state
> dd if=/dev/urandom of=/dev/bcache0 bs=1M count=250
> cat dirty_data
> cat state
> # Next line causes severe disk thrashing and failure to flush writeback cache
> # on bad commits.
> echo 1 > detach
> cat dirty_data
> cat state
> 
> Hope this provides some insight into the problem...
> 
> James

dm-crypt: Fix error with too large bios

When dm-crypt processes writes, it allocates a new bio in the function
crypt_alloc_buffer. The bio is allocated from a bio set and it can have at
most BIO_MAX_PAGES vector entries, however the incoming bio can be larger
if it was allocated by other means. For example, bcache creates bios
larger than BIO_MAX_PAGES. If the incoming bio is larger, bio_alloc_bioset
fails and error is returned.

To avoid the error, we test for too large bio in the function crypt_map
and dm_accept_partial_bio to split the bio. dm_accept_partial_bio trims
the current bio to the desired size and requests that the device mapper
core sends another bio with the rest of the data.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v3.16+

Index: linux-4.6/drivers/md/dm-crypt.c
===================================================================
--- linux-4.6.orig/drivers/md/dm-crypt.c
+++ linux-4.6/drivers/md/dm-crypt.c
@@ -2137,6 +2137,10 @@ static int crypt_map(struct dm_target *t
 	struct dm_crypt_io *io;
 	struct crypt_config *cc = ti->private;
 
+	if (unlikely(bio->bi_iter.bi_size > BIO_MAX_SIZE) &&
+	    (bio->bi_rw & (REQ_FLUSH | REQ_DISCARD | REQ_WRITE)) == REQ_WRITE)
+		dm_accept_partial_bio(bio, BIO_MAX_SIZE >> SECTOR_SHIFT);
+
 	/*
 	 * If bio is REQ_FLUSH or REQ_DISCARD, just bypass crypt queues.
 	 * - for REQ_FLUSH device-mapper core ensures that no IO is in-flight
