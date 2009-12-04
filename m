From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v5 06/13] dm snapshot: do not allow more than one
	merging snapshot.
Date: Thu,  3 Dec 2009 21:23:47 -0500
Message-ID: <1259893434-10792-7-git-send-email-snitzer@redhat.com>
References: <1259893434-10792-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1259893434-10792-1-git-send-email-snitzer@redhat.com>
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

Merging more than one snapshot is not supported.
__find_merging_snapshot() will find the merging snapshot for a given
origin device.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |   36 +++++++++++++++++++++++++++++++++++-
 1 files changed, 35 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index c232460..a0ac29f 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -331,9 +331,29 @@ out:
 	return count;
 }
 
+static struct dm_snapshot *__find_merging_snapshot(struct block_device *origin)
+{
+	struct dm_snapshot *s, *merging_snap = NULL;
+	struct origin *o;
+
+	o = __lookup_origin(origin);
+	if (!o)
+		return NULL;
+
+	list_for_each_entry(s, &o->snapshots, list) {
+		if (is_merge(s->ti)) {
+			merging_snap = s;
+			break;
+		}
+	}
+
+	return merging_snap;
+}
+
 static int __validate_exception_handover(struct dm_snapshot *snap)
 {
 	struct dm_snapshot *snap_src = NULL, *snap_dest = NULL;
+	struct block_device *bdev = snap->origin->bdev;
 	int r = 0;
 
 	/* Does snapshot need exceptions handed over to it? */
@@ -345,8 +365,22 @@ static int __validate_exception_handover(struct dm_snapshot *snap)
 		goto out;
 	}
 
-	if (snap_src)
+	if (snap_src) {
+		/* This snapshot is a handover destination */
+		if (!is_merge(snap->ti)) {
+			r = 1;
+			goto out;
+		}
+
+		/* Do not allow more than one merging snapshot */
+		if (__find_merging_snapshot(bdev)) {
+			snap->ti->error = "A snapshot is already merging.";
+			r = -EINVAL;
+			goto out;
+		}
+
 		r = 1;
+	}
 
 out:
 	return r;
-- 
1.6.5.2
