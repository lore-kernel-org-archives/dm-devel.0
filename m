From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: revert 8f50e358153d ("dm: limit the max bio
 size as BIO_MAX_PAGES * PAGE_SIZE")
Date: Thu, 21 Mar 2019 16:46:12 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1903211644400.994@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Ming Lei <ming.lei@redhat.com>, dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

The limit was already incorporated to dm-crypt (4e870e948fba - "dm crypt:
fix error with too large bios"), so we don't need to apply it globally to
all targets. The quantity BIO_MAX_PAGES * PAGE_SIZE is wrong anyway because
the variable ti->max_io_len it is supposed to be in the units of 512-byte
sectors not in bytes.

Reduction of the limit to 1048576 sectors could even cause data corruption
in rare cases - suppose that we have a dm-striped device with stripe size
768MiB. The target will call dm_set_target_max_io_len with the value
1572864. The buggy code would reduce it to 1048576. Now, the dm-core will
errorneously split the bios on 1048576-sector boundary insetad of
1572864-sector boundary and pass these stripe-crossing bios to the striped
target.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v4.16+
Fixes: 8f50e358153d ("dm: limit the max bio size as BIO_MAX_PAGES * PAGE_SIZE")

---
 drivers/md/dm.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2019-03-18 10:28:50.000000000 +0100
+++ linux-2.6/drivers/md/dm.c	2019-03-21 19:49:23.000000000 +0100
@@ -1042,15 +1042,7 @@ int dm_set_target_max_io_len(struct dm_t
 		return -EINVAL;
 	}
 
-	/*
-	 * BIO based queue uses its own splitting. When multipage bvecs
-	 * is switched on, size of the incoming bio may be too big to
-	 * be handled in some targets, such as crypt.
-	 *
-	 * When these targets are ready for the big bio, we can remove
-	 * the limit.
-	 */
-	ti->max_io_len = min_t(uint32_t, len, BIO_MAX_PAGES * PAGE_SIZE);
+	ti->max_io_len = (uint32_t) len;
 
 	return 0;
 }
