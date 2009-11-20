From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v4 07/13] dm snapshot: do not allow more than one
 merging snapshot.
Date: Fri, 20 Nov 2009 16:04:48 -0500
Message-ID: <20091120210447.GD9458@redhat.com>
References: <1258748873-24185-1-git-send-email-snitzer@redhat.com>
	<1258748873-24185-8-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1258748873-24185-8-git-send-email-snitzer@redhat.com>
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
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

Merging more than one snapshot is not supported.
__find_merging_snapshot() will find the merging snapshot for a given
origin device.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -332,9 +332,29 @@ out:
 	return count;
 }
 
+static struct dm_snapshot *__find_merging_snapshot(struct block_device *origin)
+{
+	struct dm_snapshot *s, *merging_snap;
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
@@ -346,8 +366,19 @@ static int __validate_exception_handover
 		goto out;
 	}
 
-	if (snap_src)
+	if (snap_src) {
+		if (is_merge(snap->ti)) {
+			/* Do not allow more than one merging snapshot */
+			if (__find_merging_snapshot(bdev)) {
+				snap->ti->error = "A snapshot is already "
+						  "merging.";
+				r = -EINVAL;
+				goto out;
+			}
+		}
+
 		r = 1;
+	}
 
 out:
 	return r;
