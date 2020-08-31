From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] Re: bug 1872049 - integrity bitmap
Date: Mon, 31 Aug 2020 09:25:41 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2008310921420.3813@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200828200906.GB17233@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200828200906.GB17233@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: David Teigland <teigland@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com, Corey Marthaler <cmarthal@redhat.com>
List-Id: dm-devel.ids



On Fri, 28 Aug 2020, David Teigland wrote:

> Hi Mikulas, it looks to me like this bz could be a problem with the bitmap
> mode, since both Corey and I have seen unrepaired data without any crash,
> and the same tests work fine with journal mode.  One clue might be that I
> did not see the problem if the corruption occured while the LV was
> inactive.

Hi

Here I'm submitting a patch for this bug. Try it.

Mikulas



From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-integrity: fix error reporting in bitmap mode after creation

The dm-integrity target did not report errors in bitmap mode just after
creation. The reason is that the function integrity_recalc didn't clean up
ic->recalc_bitmap as it proceeded with recalculation. This patch makes it
update the bitmap.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v5.2+
Fixes: 468dfca38b1a ("dm integrity: add a bitmap mode")

---
 drivers/md/dm-integrity.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2020-08-31 13:59:43.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2020-08-31 14:24:17.000000000 +0200
@@ -2487,6 +2487,7 @@ next_chunk:
 	range.logical_sector = le64_to_cpu(ic->sb->recalc_sector);
 	if (unlikely(range.logical_sector >= ic->provided_data_sectors)) {
 		if (ic->mode == 'B') {
+			block_bitmap_op(ic, ic->recalc_bitmap, 0, ic->provided_data_sectors, BITMAP_OP_CLEAR);
 			DEBUG_print("queue_delayed_work: bitmap_flush_work\n");
 			queue_delayed_work(ic->commit_wq, &ic->bitmap_flush_work, 0);
 		}
@@ -2564,6 +2565,17 @@ next_chunk:
 		goto err;
 	}
 
+	if (ic->mode == 'B') {
+		sector_t start, end;
+		start = range.logical_sector
+			>> (ic->sb->log2_sectors_per_block + ic->log2_blocks_per_bitmap_bit)
+			<< (ic->sb->log2_sectors_per_block + ic->log2_blocks_per_bitmap_bit);
+		end = (range.logical_sector + range.n_sectors)
+			>> (ic->sb->log2_sectors_per_block + ic->log2_blocks_per_bitmap_bit)
+			<< (ic->sb->log2_sectors_per_block + ic->log2_blocks_per_bitmap_bit);
+		block_bitmap_op(ic, ic->recalc_bitmap, start, end - start, BITMAP_OP_CLEAR);
+	}
+
 advance_and_next:
 	cond_resched();
 
