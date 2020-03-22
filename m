From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7/7] dm integrity: improve discard in journal mode
Date: Sun, 22 Mar 2020 20:42:27 +0100
Message-ID: <20200322194427.785921240@debian-a64.vm>
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
Content-Disposition: inline; filename=dm-integrity-discard-journal.patch
To: Mike Snitzer <msnitzer@redhat.com>, David Teigland <teigland@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

When we discard something that is present in the journal, we flush the
journal first, so that discarded blocks are not overwritten by the journal
content.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2020-03-20 17:41:22.000000000 +0100
+++ linux-2.6/drivers/md/dm-integrity.c	2020-03-22 17:30:24.000000000 +0100
@@ -1941,6 +1941,7 @@ static void dm_integrity_map_continue(st
 	unsigned journal_section, journal_entry;
 	unsigned journal_read_pos;
 	struct completion read_comp;
+	bool discard_retried = false;
 	bool need_sync_io = ic->internal_hash && dio->op == REQ_OP_READ;
 	if (unlikely(dio->op == REQ_OP_DISCARD) && ic->mode != 'D')
 		need_sync_io = true;
@@ -2057,6 +2058,20 @@ offload_to_thread:
 			}
 		}
 	}
+	if (ic->mode == 'J' && likely(dio->op == REQ_OP_DISCARD) && !discard_retried) {
+		sector_t next_sector;
+		unsigned new_pos = find_journal_node(ic, dio->range.logical_sector, &next_sector);
+		if (unlikely(new_pos != NOT_FOUND) || unlikely(next_sector < dio->range.logical_sector - dio->range.n_sectors)) {
+			remove_range_unlocked(ic, &dio->range);
+			spin_unlock_irq(&ic->endio_wait.lock);
+			queue_work(ic->commit_wq, &ic->commit_work);
+			flush_workqueue(ic->commit_wq);
+			queue_work(ic->writer_wq, &ic->writer_work);
+			flush_workqueue(ic->writer_wq);
+			discard_retried = true;
+			goto lock_retry;
+		}
+	}
 	spin_unlock_irq(&ic->endio_wait.lock);
 
 	if (unlikely(journal_read_pos != NOT_FOUND)) {
