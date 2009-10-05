From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 05/12] dm-snapshot-no-more-merging-snapshots
Date: Mon,  5 Oct 2009 15:02:40 -0400
Message-ID: <1254769367-12111-6-git-send-email-snitzer@redhat.com>
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

Do not allow more than one merging snapshot.

It is pointless to merge two snapshots simultaneously.
Allowing multiple merging snapshots would complicate things later.
Adds function to find merging snapshot for a given origin device.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 31040f9..2cb0636 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -285,6 +285,22 @@ static void __insert_origin(struct origin *o)
 	list_add_tail(&o->hash_list, sl);
 }
 
+static struct dm_snapshot *__find_merging_snapshot(struct block_device *origin)
+{
+	struct origin *o;
+	struct dm_snapshot *snap;
+
+	o = __lookup_origin(origin);
+	if (!o)
+		return NULL;
+
+	list_for_each_entry(snap, &o->snapshots, list)
+		if (is_merge(snap->ti))
+			return snap;
+
+	return NULL;
+}
+
 /*
  * Make a note of the snapshot and its origin so we can look it
  * up when the origin has a write on it.
@@ -299,6 +315,13 @@ static int register_snapshot(struct dm_snapshot *snap)
 		return -ENOMEM;
 
 	down_write(&_origins_lock);
+
+	/* Do not allow more than one merging snapshot */
+	if (is_merge(snap->ti) && __find_merging_snapshot(bdev)) {
+		up_write(&_origins_lock);
+		return -EINVAL;
+	}
+
 	o = __lookup_origin(bdev);
 
 	if (o)
-- 
1.6.2.5
