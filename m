From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 38/57] libmultipath: Fixup 'DM_DEVICE_RELOAD'
	handling
Date: Wed, 27 Apr 2016 13:10:39 +0200
Message-ID: <1461755458-29225-39-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

libdevmapper has the 'quirk' that DM_DEVICE_CREATE is translated
internally into a create/load/resume sequence, and the associated
cookie will wait for the last 'resume' to complete.
However, DM_DEVICE_RELOAD has no such translation, so if there
is a cookie assigned to it the caller _cannot_ wait for it,
as the cookie will only ever be completed upon the next
DM_DEVICE_RESUME.
multipathd already has some provisions for that (but even there
the cookie handling is dodgy), but 'multipath -r' doesn't know
about this.
So to avoid any future irritations this patch updates the
dm_addmad_reload() call to handle the cookie correctly,
and removes the special handling from multipathd.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/configure.c | 16 ++++------------
 libmultipath/devmapper.c | 39 +++++++++++++++++++++++++++------------
 libmultipath/devmapper.h |  2 +-
 3 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index d093cfd..dee749b 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -625,16 +625,11 @@ domap (struct multipath * mpp, char * params)
 		break;
 
 	case ACT_RELOAD:
-		r = dm_addmap_reload(mpp, params);
-		if (r)
-			r = dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias,
-						 0, MPATH_UDEV_RELOAD_FLAG);
+		r = dm_addmap_reload(mpp, params, 0);
 		break;
 
 	case ACT_RESIZE:
-		r = dm_addmap_reload(mpp, params);
-		if (r)
-			r = dm_simplecmd_flush(DM_DEVICE_RESUME, mpp->alias, 0);
+		r = dm_addmap_reload(mpp, params, 1);
 		break;
 
 	case ACT_RENAME:
@@ -643,11 +638,8 @@ domap (struct multipath * mpp, char * params)
 
 	case ACT_RENAME2:
 		r = dm_rename(mpp->alias_old, mpp->alias);
-		if (r) {
-			r = dm_addmap_reload(mpp, params);
-			if (r)
-				r = dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias, 0, MPATH_UDEV_RELOAD_FLAG);
-		}
+		if (r)
+			r = dm_addmap_reload(mpp, params, 0);
 		break;
 
 	default:
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 12ccf1a..15c91c9 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -315,12 +315,13 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
 	if (mpp->attribute_flags & (1 << ATTR_GID) &&
 	    !dm_task_set_gid(dmt, mpp->gid))
 		goto freeout;
-	condlog(4, "%s: addmap [0 %llu %s %s]", mpp->alias, mpp->size,
+	condlog(4, "%s: %s [0 %llu %s %s]", mpp->alias,
+		task == DM_DEVICE_RELOAD ? "reload" : "addmap", mpp->size,
 		target, params);
 
 	dm_task_no_open_count(dmt);
 
-	if (task == DM_DEVICE_CREATE &&
+	if (cookie &&
 	    !dm_task_set_cookie(dmt, cookie,
 				DM_UDEV_DISABLE_LIBRARY_FALLBACK)) {
 		dm_udev_complete(*cookie);
@@ -328,10 +329,11 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
 	}
 	r = dm_task_run (dmt);
 
-	if (task == DM_DEVICE_CREATE) {
+	if (cookie) {
 		if (!r)
 			dm_udev_complete(*cookie);
-		else
+		else if (task != DM_DEVICE_CREATE)
+			/* Do not wait on a cookie for DM_DEVICE_RELOAD */
 			dm_udev_wait(*cookie);
 	}
 	freeout:
@@ -377,16 +379,29 @@ dm_addmap_create (struct multipath *mpp, char * params) {
 #define ADDMAP_RO 1
 
 extern int
-dm_addmap_reload (struct multipath *mpp, char *params) {
+dm_addmap_reload (struct multipath *mpp, char *params, int flush) {
+	int r;
 	uint32_t cookie = 0;
+	uint16_t udev_flags = flush ? 0 : MPATH_UDEV_RELOAD_FLAG;
 
-	if (dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params,
-		      ADDMAP_RW, &cookie))
-		return 1;
-	if (errno != EROFS)
-		return 0;
-	return dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params,
-			 ADDMAP_RO, &cookie);
+	/*
+	 * DM_DEVICE_RELOAD cannot wait on a cookie, as
+	 * the cookie will only ever be released after an
+	 * DM_DEVICE_RESUME. So call DM_DEVICE_RESUME
+	 * after each DM_DEVICE_RELOAD.
+	 */
+	r = dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params,
+		      ADDMAP_RW, &cookie);
+	if (!r) {
+		if (errno != EROFS)
+			return 0;
+		r = dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params,
+			      ADDMAP_RO, &cookie);
+	}
+	if (r)
+		r = dm_simplecmd(DM_DEVICE_RESUME, mpp->alias, flush,
+				 udev_flags, 0, &cookie);
+	return r;
 }
 
 extern int
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 8dd0963..97f3742 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -18,7 +18,7 @@ int dm_drv_version (unsigned int * version, char * str);
 int dm_simplecmd_flush (int, const char *, uint16_t);
 int dm_simplecmd_noflush (int, const char *, int, uint16_t);
 int dm_addmap_create (struct multipath *mpp, char *params);
-int dm_addmap_reload (struct multipath *mpp, char *params);
+int dm_addmap_reload (struct multipath *mpp, char *params, int flush);
 int dm_map_present (const char *);
 int dm_get_map(const char *, unsigned long long *, char *);
 int dm_get_status(char *, char *);
-- 
2.6.6
