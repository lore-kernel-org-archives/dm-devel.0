From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [patch 7/8] dm-integrity: flush journal on suspend when
	using separate device
Date: Tue, 01 May 2018 15:55:23 +0200
Message-ID: <20180501135606.772829393@debian.vm>
References: <20180501135516.961417937@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-integrity-flush-on-suspend.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Flush the journal on suspend when using separate data and metadata device,
so that the metadata device can be discarded and the table can be reloaded
with a linear target pointing to the data device.

Note: we deliberately don't flush the journal when using the same device
for metadata and data, so that the journal replay code is tested.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2018-05-01 00:39:27.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2018-05-01 00:39:27.000000000 +0200
@@ -2000,7 +2000,7 @@ static void integrity_writer(struct work
 	unsigned prev_free_sectors;
 
 	/* the following test is not needed, but it tests the replay code */
-	if (READ_ONCE(ic->suspending))
+	if (READ_ONCE(ic->suspending) && !ic->meta_dev)
 		return;
 
 	spin_lock_irq(&ic->endio_wait.lock);
@@ -2235,6 +2235,8 @@ static void dm_integrity_postsuspend(str
 	drain_workqueue(ic->commit_wq);
 
 	if (ic->mode == 'J') {
+		if (ic->meta_dev)
+			queue_work(ic->writer_wq, &ic->writer_work);
 		drain_workqueue(ic->writer_wq);
 		dm_integrity_flush_buffers(ic);
 	}
