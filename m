From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 02/12] dm-exception-store-merge-accounting
Date: Mon,  5 Oct 2009 15:02:37 -0400
Message-ID: <1254769367-12111-3-git-send-email-snitzer@redhat.com>
References: <1254769367-12111-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1254769367-12111-1-git-send-email-snitzer@redhat.com>
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

From: Mikulas Patocka <mpatocka@redhat.com>

Conditionally adjust snapshot usage accounting if snapshot-merge is in
progress.  Care is taken to preserve the established kernel<->userspace
interface.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-snap-persistent.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 2523056..005c60c 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -91,6 +91,7 @@ struct pstore {
 	struct dm_exception_store *store;
 	int version;
 	int valid;
+	int merging;	/* 1 if there is merging going on */
 	uint32_t exceptions_per_area;
 
 	/*
@@ -502,7 +503,18 @@ static struct pstore *get_info(struct dm_exception_store *store)
 static void persistent_fraction_full(struct dm_exception_store *store,
 				     sector_t *numerator, sector_t *denominator)
 {
-	*numerator = get_info(store)->next_free * store->chunk_size;
+	struct pstore *ps = get_info(store);
+	/*
+	 * Must maintain the fact that DM reports the first two chunks as used
+	 * (externally) even though they should've been hidden (used internally).
+	 * - this preserves the established (flawed) kernel<->userspace interface
+	 * - snapshot-merge must add these two chunks into its usage reporting
+	 */
+	if (!ps->merging)
+		*numerator = ps->next_free * store->chunk_size;
+	else
+		*numerator = (area_location(ps, ps->current_area) - 1 +
+			      ps->current_committed + 2) * store->chunk_size;
 	*denominator = get_dev_size(dm_snap_get_cow(store->snap)->bdev);
 }
 
@@ -598,6 +610,8 @@ static int persistent_prepare_exception(struct dm_exception_store *store,
 	chunk_t next_free;
 	sector_t size = get_dev_size(dm_snap_get_cow(store->snap)->bdev);
 
+	ps->merging = 0;
+
 	/* Is there enough room ? */
 	if (size < ((ps->next_free + 1) * store->chunk_size))
 		return -ENOSPC;
@@ -686,6 +700,8 @@ static int persistent_prepare_merge(struct dm_exception_store *store,
 	struct pstore *ps = get_info(store);
 	struct disk_exception de;
 
+	ps->merging = 1;
+
 	if (!ps->current_committed) {
 		if (!ps->current_area)
 			return 0;
@@ -757,6 +773,7 @@ static int persistent_ctr(struct dm_exception_store *store,
 
 	ps->store = store;
 	ps->valid = 1;
+	ps->merging = 0;
 	ps->version = SNAPSHOT_DISK_VERSION;
 	ps->area = NULL;
 	ps->zero_area = NULL;
-- 
1.6.2.5
