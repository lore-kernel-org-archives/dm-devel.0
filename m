From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 05/12] dm snapshot: do not allow more than one
	merging snapshot.
Date: Tue, 17 Nov 2009 11:12:17 -0500
Message-ID: <1258474344-10886-6-git-send-email-snitzer@redhat.com>
References: <1258474344-10886-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1258474344-10886-1-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

It is pointless to merge two snapshots simultaneously.
Allowing multiple merging snapshots would complicate things later.
Adds function to find merging snapshot for a given origin device.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 5fd7055..2a9fae9 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -561,6 +561,30 @@ out:
 	return handover_snap;
 }
 
+static struct dm_snapshot *find_merging_snapshot(struct block_device *origin)
+{
+	struct dm_snapshot *s, *merging_snap = NULL;
+	struct origin *o;
+
+	down_read(&_origins_lock);
+
+	o = __lookup_origin(origin);
+	if (!o)
+		goto out;
+
+	list_for_each_entry(s, &o->snapshots, list) {
+		if (is_merge(s->ti)) {
+			merging_snap = s;
+			break;
+		}
+	}
+
+out:
+	up_read(&_origins_lock);
+
+	return merging_snap;
+}
+
 #define min_not_zero(l, r) (((l) == 0) ? (r) : (((r) == 0) ? (l) : min(l, r)))
 
 /*
@@ -732,6 +756,15 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	/* Does snapshot need exceptions handed over to it? */
 	handover_snap = find_snapshot_using_cow(s);
 	if (handover_snap) {
+		if (is_merge(s->ti)) {
+			r = -EINVAL;
+			/* Do not allow more than one merging snapshot */
+			if (find_merging_snapshot(s->origin->bdev)) {
+				ti->error = "A snapshot is already merging.";
+				goto bad_load_and_register;
+			}
+		}
+
 		down_write(&handover_snap->lock);
 		if (handover_snap->is_handover_source) {
 			up_write(&handover_snap->lock);
-- 
1.6.5.2
