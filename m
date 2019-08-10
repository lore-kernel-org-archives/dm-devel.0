From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm integrity: fix a crash due to
 journal_entry_get_sector(je) != logical_sector
Date: Sat, 10 Aug 2019 12:30:27 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1908101226540.31197@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Milan Broz <mbroz@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Fix a crash that was introduced by the commit 724376a04d1a. The crash is
reported here: https://gitlab.com/cryptsetup/cryptsetup/issues/468

When reading from the integrity device, the function
dm_integrity_map_continue calls find_journal_node to find out if the
location to read is present in the journal. Then, it calculates how many
sectors are consecutively stored in the journal. Then, it locks the range
with add_new_range and wait_and_add_new_range.

The problem is that during wait_and_add_new_range, we hold no locks (we
don't hold ic->endio_wait.lock and we don't hold a range lock), so the
journal may change arbitrarily while wait_and_add_new_range sleeps.

The code then goes to __journal_read_write and hits
BUG_ON(journal_entry_get_sector(je) != logical_sector); because the
journal has changed.

In order to fix this bug, we need to re-check the journal location after
wait_and_add_new_range. We restrict the length to one block in order to
not complicate the code too much.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v4.19+
Fixes: 724376a04d1a ("dm integrity: implement fair range locks")

---
 drivers/md/dm-integrity.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2019-08-10 11:56:01.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2019-08-10 12:14:54.000000000 +0200
@@ -1943,7 +1943,22 @@ offload_to_thread:
 			queue_work(ic->wait_wq, &dio->work);
 			return;
 		}
+		if (journal_read_pos != NOT_FOUND)
+			dio->range.n_sectors = ic->sectors_per_block;
 		wait_and_add_new_range(ic, &dio->range);
+		/*
+		 * wait_and_add_new_range drops the spinlock, so the journal
+		 * may have been changed arbitrarily. We need to recheck.
+		 * To simplify the code, we restrict I/O size to just one block.
+		 */
+		if (journal_read_pos != NOT_FOUND) {
+			sector_t next_sector;
+			unsigned new_pos = find_journal_node(ic, dio->range.logical_sector, &next_sector);
+			if (unlikely(new_pos != journal_read_pos)) {
+				remove_range_unlocked(ic, &dio->range);
+				goto retry;
+			}
+		}
 	}
 	spin_unlock_irq(&ic->endio_wait.lock);
 
