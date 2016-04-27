From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 32/57] libmultipath: remove 'needsync' argument
	from dm_simplecmd_noflush
Date: Wed, 27 Apr 2016 13:10:33 +0200
Message-ID: <1461755458-29225-33-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Argument is always '1'.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/configure.c | 2 +-
 libmultipath/devmapper.c | 6 +++---
 libmultipath/devmapper.h | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 0076485..d093cfd 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -634,7 +634,7 @@ domap (struct multipath * mpp, char * params)
 	case ACT_RESIZE:
 		r = dm_addmap_reload(mpp, params);
 		if (r)
-			r = dm_simplecmd_flush(DM_DEVICE_RESUME, mpp->alias, 1, 0);
+			r = dm_simplecmd_flush(DM_DEVICE_RESUME, mpp->alias, 0);
 		break;
 
 	case ACT_RENAME:
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 36c1a20..1115216 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -248,8 +248,8 @@ dm_simplecmd (int task, const char *name, int no_flush, int need_sync, uint16_t
 }
 
 extern int
-dm_simplecmd_flush (int task, const char *name, int needsync, uint16_t udev_flags) {
-	return dm_simplecmd(task, name, 0, needsync, udev_flags, 0);
+dm_simplecmd_flush (int task, const char *name, uint16_t udev_flags) {
+	return dm_simplecmd(task, name, 0, 1, udev_flags, 0);
 }
 
 extern int
@@ -833,7 +833,7 @@ dm_suspend_and_flush_map (const char * mapname)
 	if (s)
 		queue_if_no_path = 0;
 	else
-		s = dm_simplecmd_flush(DM_DEVICE_SUSPEND, mapname, 1, 0);
+		s = dm_simplecmd_flush(DM_DEVICE_SUSPEND, mapname, 0);
 
 	if (!dm_flush_map(mapname)) {
 		condlog(4, "multipath map %s removed", mapname);
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 0d27723..8dd0963 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -15,7 +15,7 @@
 void dm_init(void);
 int dm_prereq (void);
 int dm_drv_version (unsigned int * version, char * str);
-int dm_simplecmd_flush (int, const char *, int, uint16_t);
+int dm_simplecmd_flush (int, const char *, uint16_t);
 int dm_simplecmd_noflush (int, const char *, int, uint16_t);
 int dm_addmap_create (struct multipath *mpp, char *params);
 int dm_addmap_reload (struct multipath *mpp, char *params);
-- 
2.6.6
