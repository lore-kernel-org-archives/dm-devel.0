From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 1/5] multipathd: move set_no_path_retry() back
 to libmultipath
Date: Wed, 27 Nov 2019 15:05:48 +0000
Message-ID: <20191127150604.31417-2-martin.wilck@suse.com>
References: <20191127150604.31417-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191127150604.31417-1-martin.wilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Chongyun Wu <wu.chongyun@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

This function is useful elsewhere, too. No code changes except
for changing the linkage.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 30 ++++++++++++++++++++++++++++++
 libmultipath/structs_vec.h |  1 +
 multipathd/main.c          | 30 ------------------------------
 3 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 6991f9ac..fbe97662 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -308,6 +308,36 @@ void enter_recovery_mode(struct multipath *mpp)
 		mpp->alias, mpp->no_path_retry);
 }
 
+void set_no_path_retry(struct multipath *mpp)
+{
+	char is_queueing = 0;
+
+	mpp->nr_active = pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOST);
+	if (mpp->features && strstr(mpp->features, "queue_if_no_path"))
+		is_queueing = 1;
+
+	switch (mpp->no_path_retry) {
+	case NO_PATH_RETRY_UNDEF:
+		break;
+	case NO_PATH_RETRY_FAIL:
+		if (is_queueing)
+			dm_queue_if_no_path(mpp->alias, 0);
+		break;
+	case NO_PATH_RETRY_QUEUE:
+		if (!is_queueing)
+			dm_queue_if_no_path(mpp->alias, 1);
+		break;
+	default:
+		if (mpp->nr_active > 0) {
+			mpp->retry_tick = 0;
+			if (!is_queueing)
+				dm_queue_if_no_path(mpp->alias, 1);
+		} else if (is_queueing && mpp->retry_tick == 0)
+			enter_recovery_mode(mpp);
+		break;
+	}
+}
+
 void
 sync_map_state(struct multipath *mpp)
 {
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index f8b9f63e..d3219278 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -11,6 +11,7 @@ struct vectors {
 	vector mpvec;
 };
 
+void set_no_path_retry(struct multipath *mpp);
 void enter_recovery_mode(struct multipath *mpp);
 
 int adopt_paths (vector pathvec, struct multipath * mpp);
diff --git a/multipathd/main.c b/multipathd/main.c
index bb5c1f1d..a21d96e4 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -409,36 +409,6 @@ set_multipath_wwid (struct multipath * mpp)
 	dm_get_uuid(mpp->alias, mpp->wwid, WWID_SIZE);
 }
 
-static void set_no_path_retry(struct multipath *mpp)
-{
-	char is_queueing = 0;
-
-	mpp->nr_active = pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOST);
-	if (mpp->features && strstr(mpp->features, "queue_if_no_path"))
-		is_queueing = 1;
-
-	switch (mpp->no_path_retry) {
-	case NO_PATH_RETRY_UNDEF:
-		break;
-	case NO_PATH_RETRY_FAIL:
-		if (is_queueing)
-			dm_queue_if_no_path(mpp->alias, 0);
-		break;
-	case NO_PATH_RETRY_QUEUE:
-		if (!is_queueing)
-			dm_queue_if_no_path(mpp->alias, 1);
-		break;
-	default:
-		if (mpp->nr_active > 0) {
-			mpp->retry_tick = 0;
-			if (!is_queueing)
-				dm_queue_if_no_path(mpp->alias, 1);
-		} else if (is_queueing && mpp->retry_tick == 0)
-			enter_recovery_mode(mpp);
-		break;
-	}
-}
-
 int __setup_multipath(struct vectors *vecs, struct multipath *mpp,
 		      int reset)
 {
-- 
2.24.0
