From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 07/17] dm exception store: snapshot-merge
	usage accounting
Date: Tue, 20 Oct 2009 18:46:55 -0400
Message-ID: <1256078825-11331-8-git-send-email-snitzer@redhat.com>
References: <1256078825-11331-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1256078825-11331-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Conditionally adjust snapshot usage accounting if snapshot-merge is in
progress.  Care is taken to preserve the established kernel<->userspace
interface.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-snap-persistent.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 4015923..2cac778 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -91,6 +91,7 @@ struct pstore {
 	struct dm_exception_store *store;
 	int version;
 	int valid;
+	int merging;	/* 1 if there is merging going on */
 	uint32_t exceptions_per_area;
 
 	/*
@@ -506,7 +507,20 @@ static void persistent_usage(struct dm_exception_store *store,
 {
 	struct pstore *ps = get_info(store);
 
-	*sectors_allocated = ps->next_free * store->chunk_size;
+	/*
+	 * Must maintain the fact that DM reports all metadata chunks
+	 * in 'sectors_allocated'
+	 * - preserves the established kernel<->userspace interface
+	 * - snapshot-merge must account for the first two metadata
+	 *   chunks in its 'sectors_allocated'
+	 */
+	if (!ps->merging) {
+		*sectors_allocated = ps->next_free * store->chunk_size;
+	} else {
+		*sectors_allocated =
+			(area_location(ps, ps->current_area) - 1 +
+			 ps->current_committed + 2) * store->chunk_size;
+	}
 	*total_sectors = get_dev_size(dm_snap_cow(store->snap)->bdev);
 
 	/*
@@ -609,6 +623,8 @@ static int persistent_prepare_exception(struct dm_exception_store *store,
 	chunk_t next_free;
 	sector_t size = get_dev_size(dm_snap_cow(store->snap)->bdev);
 
+	ps->merging = 0;
+
 	/* Is there enough room ? */
 	if (size < ((ps->next_free + 1) * store->chunk_size))
 		return -ENOSPC;
@@ -697,6 +713,8 @@ static int persistent_prepare_merge(struct dm_exception_store *store,
 	struct pstore *ps = get_info(store);
 	struct disk_exception de;
 
+	ps->merging = 1;
+
 	if (!ps->current_committed) {
 		if (!ps->current_area)
 			return 0;
@@ -768,6 +786,7 @@ static int persistent_ctr(struct dm_exception_store *store,
 
 	ps->store = store;
 	ps->valid = 1;
+	ps->merging = 0;
 	ps->version = SNAPSHOT_DISK_VERSION;
 	ps->area = NULL;
 	ps->zero_area = NULL;
-- 
1.6.5.rc2
