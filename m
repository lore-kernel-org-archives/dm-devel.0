From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 06/31] kpartx: fix part deletion without
	partition table
Date: Sun,  3 Sep 2017 00:38:35 +0200
Message-ID: <20170902223900.7339-7-mwilck@suse.com>
References: <20170902223900.7339-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170902223900.7339-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

If we are deleting partition mappings, there's no need to
parse the partition table. We just look for mappings created
by kpartx and destroy them. Without this patch, kpartx fails
to delete partition mappings on devices on which the partition
table has been destroyed.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/kpartx.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 62f54308..442b6bd9 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -394,6 +394,22 @@ main(int argc, char **argv){
 
 	/* add/remove partitions to the kernel devmapper tables */
 	int r = 0;
+
+	if (what == DELETE) {
+		r = dm_remove_partmaps(mapname, uuid, buf.st_rdev,
+				       verbose);
+		if (loopdev) {
+			if (del_loop(loopdev)) {
+				if (verbose)
+					fprintf(stderr, "can't del loop : %s\n",
+					       loopdev);
+				r = 1;
+			} else
+				fprintf(stderr, "loop deleted : %s\n", loopdev);
+		}
+		goto end;
+	}
+
 	for (i = 0; i < ptct; i++) {
 		ptp = &pts[i];
 
@@ -461,20 +477,6 @@ main(int argc, char **argv){
 
 			break;
 
-		case DELETE:
-			r = dm_remove_partmaps(mapname, uuid, buf.st_rdev,
-					       verbose);
-			if (loopdev) {
-				if (del_loop(loopdev)) {
-					if (verbose)
-						printf("can't del loop : %s\n",
-						       loopdev);
-					exit(1);
-				}
-				printf("loop deleted : %s\n", loopdev);
-			}
-			break;
-
 		case ADD:
 		case UPDATE:
 			/* ADD and UPDATE share the same code that adds new partitions. */
@@ -656,6 +658,7 @@ main(int argc, char **argv){
 		printf("loop deleted : %s\n", device);
 	}
 
+end:
 	dm_lib_release();
 	dm_lib_exit();
 
-- 
2.14.0
