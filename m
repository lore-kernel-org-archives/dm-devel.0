From: Eric Wheeler <dm-devel@lists.ewheeler.net>
Subject: [PATCH] Re: dm-crypt: Fix error with too large bios
Date: Wed, 10 Aug 2016 20:56:39 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1608102050200.10662@mail.ewheeler.net>
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
To: mpatocka@redhat.com
Cc: dm-devel@redhat.com, johnstonj.public@codenest.com
List-Id: dm-devel.ids

Hello Mikulas and dm-devel list,

The simple patch below with is confirmed to fix James Johnston's issue and 
doesn't appear to be in v4.8-rc1:

This references the following patchwork entry:
  https://patchwork.kernel.org/patch/9138595/

Can we get this pushed upstream for v4.8?

--
Eric Wheeler


On Fri, 27 May 2016, Mikulas Patocka wrote:
> dm-crypt: Fix error with too large bios
> 
> When dm-crypt processes writes, it allocates a new bio in the function
> crypt_alloc_buffer. The bio is allocated from a bio set and it can have at
> most BIO_MAX_PAGES vector entries, however the incoming bio can be larger
> if it was allocated by other means. For example, bcache creates bios
> larger than BIO_MAX_PAGES. If the incoming bio is larger, bio_alloc_bioset
> fails and error is returned.
> 
> To avoid the error, we test for too large bio in the function crypt_map
> and dm_accept_partial_bio to split the bio. dm_accept_partial_bio trims
> the current bio to the desired size and requests that the device mapper
> core sends another bio with the rest of the data.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org	# v3.16+

Tested-by: James Johnston <johnstonj.public@codenest.com>

I tested this patch by:

1.  Building v4.7-rc1 from Torvalds git repo.  Confirmed that original bug
    still occurs on Ubuntu 15.10.

2.  Applying your patch to v4.7-rc1.  My kill sequence no longer works,
    and the writeback cache is now successfully flushed to disk, and the
    cache can be detached from the backing device.

3.  To check data integrity, copied 250 MB of /dev/urandom to some file
    on main volume.  Then, dd copy this file to /dev/bcache0.  Then,
    detached the cache device from the backing device.  Then, rebooted.
    Then, dd copy /dev/bcache0 to another file on main volume.  Then,
    diff the files and confirm no changes.

So it looks like it works, based on this admittedly brief testing.  Thanks!

Best regards,

James Johnston


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

Patch

Index: linux-4.6/drivers/md/dm-crypt.c
===================================================================
--- linux-4.6.orig/drivers/md/dm-crypt.c
+++ linux-4.6/drivers/md/dm-crypt.c
@@ -2137,6 +2137,10 @@  static int crypt_map(struct dm_target *t
 	struct dm_crypt_io *io;
 	struct crypt_config *cc = ti->private;
 
+	if (unlikely(bio->bi_iter.bi_size > BIO_MAX_SIZE) &&
+	    (bio->bi_rw & (REQ_FLUSH | REQ_DISCARD | REQ_WRITE)) == REQ_WRITE)
+		dm_accept_partial_bio(bio, BIO_MAX_SIZE >> SECTOR_SHIFT);
+
 	/*
 	 * If bio is REQ_FLUSH or REQ_DISCARD, just bypass crypt queues.
 	 * - for REQ_FLUSH device-mapper core ensures that no IO is in-flight
