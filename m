From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/9] dm-integrity: dont join the paths in
	dm_integrity_map_continue
Date: Wed, 06 Jun 2018 17:33:09 +0200
Message-ID: <20180606153432.395938590@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-integrity-small-refactoring.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Don't join the code paths when we are out of free sectors and when
add_new_range fails. This has no functional change, but it will help with
the next patch.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2018-06-06 15:26:40.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2018-06-06 15:49:01.000000000 +0200
@@ -1599,8 +1599,12 @@ retry:
 
 			dio->range.n_sectors = min(dio->range.n_sectors,
 						   ic->free_sectors << ic->sb->log2_sectors_per_block);
-			if (unlikely(!dio->range.n_sectors))
-				goto sleep;
+			if (unlikely(!dio->range.n_sectors)) {
+				if (from_map)
+					goto offload_to_thread;
+				sleep_on_endio_wait(ic);
+				goto retry;
+			}
 			range_sectors = dio->range.n_sectors >> ic->sb->log2_sectors_per_block;
 			ic->free_sectors -= range_sectors;
 			journal_section = ic->free_section;
@@ -1660,8 +1664,8 @@ retry:
 		 * stall bios on current->bio_list.
 		 * So, we offload the bio to a workqueue if we have to sleep.
 		 */
-sleep:
 		if (from_map) {
+offload_to_thread:
 			spin_unlock_irq(&ic->endio_wait.lock);
 			INIT_WORK(&dio->work, integrity_bio_wait);
 			queue_work(ic->wait_wq, &dio->work);
