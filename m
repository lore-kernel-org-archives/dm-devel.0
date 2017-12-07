From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 10/12] multipathd: clean up set_no_path_retry
Date: Thu,  7 Dec 2017 12:49:04 -0600
Message-ID: <1512672546-12785-11-git-send-email-bmarzins@redhat.com>
References: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

set_no_path_retry() was always updating the queue_if_no_path setting,
even if it was unnecessary.  This caused problems when no_path_retry was
set to a number, where any time __setup_multipath() was called with
reset, queuing automatically restarted, even if there were no usable
paths.

Instead, set_no_path_retry() should just fix the queueing if it is set
to an incorrect value.  This is simple to detect if no_path_retry is set
to "queue" or "fail".  When it is set to a number, multipathd needs to
see if there are usable paths. If so, queueing should be enabled.  If
not, queueing may be either enabled or disabled, but if it is enabled
and the device isn't already in recovery mode, it should be.

Also, calling dm_map_present() is pointless in __setup_multipath(),
since the existence of the map was just checked in dm_get_info().

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 2f1f277..fbab61f 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -325,21 +325,27 @@ void enter_recovery_mode(struct multipath *mpp)
 
 static void set_no_path_retry(struct multipath *mpp)
 {
-	mpp->retry_tick = 0;
+	char is_queueing = 0;
+
 	mpp->nr_active = pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOST);
+	if (mpp->features && strstr(mpp->features, "queue_if_no_path"))
+		is_queueing = 1;
 
 	switch (mpp->no_path_retry) {
 	case NO_PATH_RETRY_UNDEF:
 		break;
 	case NO_PATH_RETRY_FAIL:
-		dm_queue_if_no_path(mpp->alias, 0);
+		if (is_queueing)
+			dm_queue_if_no_path(mpp->alias, 0);
 		break;
 	case NO_PATH_RETRY_QUEUE:
-		dm_queue_if_no_path(mpp->alias, 1);
+		if (!is_queueing)
+			dm_queue_if_no_path(mpp->alias, 1);
 		break;
 	default:
-		dm_queue_if_no_path(mpp->alias, 1);
-		if (mpp->nr_active == 0)
+		if (mpp->nr_active > 0)
+			dm_queue_if_no_path(mpp->alias, 1);
+		else if (is_queueing && mpp->retry_tick == 0)
 			enter_recovery_mode(mpp);
 		break;
 	}
@@ -354,12 +360,6 @@ int __setup_multipath(struct vectors *vecs, struct multipath *mpp,
 		goto out;
 	}
 
-	if (!dm_map_present(mpp->alias)) {
-		/* Table has been removed */
-		condlog(3, "%s: table does not exist", mpp->alias);
-		goto out;
-	}
-
 	if (update_multipath_strings(mpp, vecs->pathvec, 1)) {
 		condlog(0, "%s: failed to setup multipath", mpp->alias);
 		goto out;
-- 
2.7.4
