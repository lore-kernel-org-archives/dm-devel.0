From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 05/16] Only load a multipath device RO if RW load
	fails with EROFS
Date: Wed, 11 Dec 2013 00:42:59 -0600
Message-ID: <1386744190-1295-6-git-send-email-bmarzins@redhat.com>
References: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

If a transient error keeps multipath from being able to reload a
multipath device read/write, it will retry the reload with the
device set to read-only.  This can suddenly turn a read/write
multipath device read-only.  If device-mapper cannot load the
device read/write because a path device can't be opened for writing,
it will return EROFS.  This is the only time it makes sense to
reload the device read-only.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c |  7 -------
 libmultipath/devmapper.c | 53 +++++++++++++++++++++++-------------------------
 libmultipath/devmapper.h |  2 --
 3 files changed, 25 insertions(+), 37 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index aad3c9f..8c09791 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -383,24 +383,17 @@ domap (struct multipath * mpp, char * params)
 
 		r = dm_addmap_create(mpp, params);
 
-		if (!r)
-			r = dm_addmap_create_ro(mpp, params);
-
 		lock_multipath(mpp, 0);
 		break;
 
 	case ACT_RELOAD:
 		r = dm_addmap_reload(mpp, params);
-		if (!r)
-			r = dm_addmap_reload_ro(mpp, params);
 		if (r)
 			r = dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias);
 		break;
 
 	case ACT_RESIZE:
 		r = dm_addmap_reload(mpp, params);
-		if (!r)
-			r = dm_addmap_reload_ro(mpp, params);
 		if (r)
 			r = dm_simplecmd_flush(DM_DEVICE_RESUME, mpp->alias, 1);
 		break;
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 3da109c..6eb2d96 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -300,42 +300,39 @@ dm_addmap (int task, const char *target, struct multipath *mpp, char * params,
 	return r;
 }
 
-static int
-_dm_addmap_create (struct multipath *mpp, char * params, int ro) {
-	int r;
-	r = dm_addmap(DM_DEVICE_CREATE, TGT_MPATH, mpp, params, 1, ro);
-	/*
-	 * DM_DEVICE_CREATE is actually DM_DEV_CREATE + DM_TABLE_LOAD.
-	 * Failing the second part leaves an empty map. Clean it up.
-	 */
-	if (!r && dm_map_present(mpp->alias)) {
-		condlog(3, "%s: failed to load map (a path might be in use)",
-			mpp->alias);
-		dm_flush_map_nosync(mpp->alias);
+extern int
+dm_addmap_create (struct multipath *mpp, char * params) {
+	int ro;
+
+	for (ro = 0; ro <= 1; ro++) {
+		int err;
+
+		if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH, mpp, params, 1, ro))
+			return 1;
+		/*
+		 * DM_DEVICE_CREATE is actually DM_DEV_CREATE + DM_TABLE_LOAD.
+		 * Failing the second part leaves an empty map. Clean it up.
+		 */
+		err = errno;
+		if (dm_map_present(mpp->alias)) {
+			condlog(3, "%s: failed to load map (a path might be in use)", mpp->alias);
+			dm_flush_map_nosync(mpp->alias);
+		}
+		if (err != EROFS)
+			break;
 	}
-	return r;
+	return 0;
 }
 
 #define ADDMAP_RW 0
 #define ADDMAP_RO 1
 
 extern int
-dm_addmap_create (struct multipath *mpp, char *params) {
-	return _dm_addmap_create(mpp, params, ADDMAP_RW);
-}
-
-extern int
-dm_addmap_create_ro (struct multipath *mpp, char *params) {
-	return _dm_addmap_create(mpp, params, ADDMAP_RO);
-}
-
-extern int
 dm_addmap_reload (struct multipath *mpp, char *params) {
-	return dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params, 0, ADDMAP_RW);
-}
-
-extern int
-dm_addmap_reload_ro (struct multipath *mpp, char *params) {
+	if (dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params, 0, ADDMAP_RW))
+		return 1;
+	if (errno != EROFS)
+		return 0;
 	return dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params, 0, ADDMAP_RO);
 }
 
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index a144bfb..58cd718 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -12,9 +12,7 @@ int dm_drv_version (unsigned int * version, char * str);
 int dm_simplecmd_flush (int, const char *, int);
 int dm_simplecmd_noflush (int, const char *);
 int dm_addmap_create (struct multipath *mpp, char *params);
-int dm_addmap_create_ro (struct multipath *mpp, char *params);
 int dm_addmap_reload (struct multipath *mpp, char *params);
-int dm_addmap_reload_ro (struct multipath *mpp, char *params);
 int dm_map_present (const char *);
 int dm_get_map(const char *, unsigned long long *, char *);
 int dm_get_status(char *, char *);
-- 
1.8.4.2
