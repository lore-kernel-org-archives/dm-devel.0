From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 14/31] libmultipath: add dm_get_multipath
Date: Sun,  3 Sep 2017 00:38:43 +0200
Message-ID: <20170902223900.7339-15-mwilck@suse.com>
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

This function is simply factored out from dm_get_maps.
No functional difference.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 43 +++++++++++++++++++++++++++----------------
 libmultipath/devmapper.h |  1 +
 2 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 6e3abe3e..fcac6bc7 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1004,6 +1004,31 @@ dm_disablegroup(char * mapname, int index)
 	return dm_groupmsg("disable", mapname, index);
 }
 
+struct multipath *dm_get_multipath(const char *name)
+{
+	struct multipath *mpp = NULL;
+
+	mpp = alloc_multipath();
+	if (!mpp)
+		return NULL;
+
+	mpp->alias = STRDUP(name);
+
+	if (!mpp->alias)
+		goto out;
+
+	if (dm_get_map(name, &mpp->size, NULL))
+		goto out;
+
+	dm_get_uuid(name, mpp->wwid);
+	dm_get_info(name, &mpp->dmi);
+
+	return mpp;
+out:
+	free_multipath(mpp, KEEP_PATHS);
+	return NULL;
+}
+
 int
 dm_get_maps (vector mp)
 {
@@ -1036,24 +1061,12 @@ dm_get_maps (vector mp)
 		if (!dm_is_mpath(names->name))
 			goto next;
 
-		mpp = alloc_multipath();
-
+		mpp = dm_get_multipath(names->name);
 		if (!mpp)
 			goto out;
 
-		mpp->alias = STRDUP(names->name);
-
-		if (!mpp->alias)
-			goto out1;
-
-		if (dm_get_map(names->name, &mpp->size, NULL))
-			goto out1;
-
-		dm_get_uuid(names->name, mpp->wwid);
-		dm_get_info(names->name, &mpp->dmi);
-
 		if (!vector_alloc_slot(mp))
-			goto out1;
+			goto out;
 
 		vector_set_slot(mp, mpp);
 		mpp = NULL;
@@ -1064,8 +1077,6 @@ next:
 
 	r = 0;
 	goto out;
-out1:
-	free_multipath(mpp, KEEP_PATHS);
 out:
 	dm_task_destroy (dmt);
 	return r;
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 5c824a21..62e14d1c 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -65,6 +65,7 @@ int dm_rename (const char * old, char * new, char * delim, int skip_kpartx);
 int dm_reassign(const char * mapname);
 int dm_reassign_table(const char *name, char *old, char *new);
 int dm_setgeometry(struct multipath *mpp);
+struct multipath *dm_get_multipath(const char *name);
 
 #define VERSION_GE(v, minv) ( \
 	(v[0] > minv[0]) || \
-- 
2.14.0
