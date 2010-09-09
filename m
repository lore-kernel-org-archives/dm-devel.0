From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm: use cpu_relax when busy waiting for condition
Date: Thu, 9 Sep 2010 18:07:16 -0400
Message-ID: <20100909220716.GA27774@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Switch busy loops from using msleep(1) to cpu_relax().

Any improvement is negligible given the rare nature of these busy wait
conditions -- but cpu_relax() is considered the more polite method to
use for busy loops.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c  |    6 +++---
 drivers/md/dm-table.c |    2 +-
 drivers/md/dm.c       |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index eed2101..d1f44c1 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -264,12 +264,12 @@ static int __chunk_is_tracked(struct dm_snapshot *s, chunk_t chunk)
 
 /*
  * This conflicting I/O is extremely improbable in the caller,
- * so msleep(1) is sufficient and there is no need for a wait queue.
+ * so cpu_relax() is sufficient and there is no need for a wait queue.
  */
 static void __check_for_conflicting_io(struct dm_snapshot *s, chunk_t chunk)
 {
 	while (__chunk_is_tracked(s, chunk))
-		msleep(1);
+		cpu_relax();
 }
 
 /*
@@ -1302,7 +1302,7 @@ static void snapshot_dtr(struct dm_target *ti)
 	unregister_snapshot(s);
 
 	while (atomic_read(&s->pending_exceptions_count))
-		msleep(1);
+		cpu_relax();
 	/*
 	 * Ensure instructions in mempool_destroy aren't reordered
 	 * before atomic_read.
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index f9fc07d..2955d46 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -245,7 +245,7 @@ void dm_table_destroy(struct dm_table *t)
 		return;
 
 	while (atomic_read(&t->holders))
-		msleep(1);
+		cpu_relax();
 	smp_mb();
 
 	/* free the indexes */
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f934e98..4e699e4 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2228,7 +2228,7 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
 	 */
 	if (wait)
 		while (atomic_read(&md->holders))
-			msleep(1);
+			cpu_relax();
 	else if (atomic_read(&md->holders))
 		DMWARN("%s: Forcibly removing mapped_device still in use! (%d users)",
 		       dm_device_name(md), atomic_read(&md->holders));
