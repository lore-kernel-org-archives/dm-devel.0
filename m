From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/7] devmapper: remove 'udev_sync' argument from
	dm_simplecmd_noflush()
Date: Mon,  9 May 2016 12:53:04 +0200
Message-ID: <1462791185-2903-7-git-send-email-hare@suse.de>
References: <1462791185-2903-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1462791185-2903-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

The 'udev_sync' argument is always '1', so we can remove it.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/configure.c  | 4 ++--
 libmultipath/devmapper.c  | 9 +++++----
 libmultipath/devmapper.h  | 2 +-
 multipathd/cli_handlers.c | 4 ++--
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 9c6904a..708dae8 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -628,7 +628,7 @@ domap (struct multipath * mpp, char * params)
 		r = dm_addmap_reload(mpp, params);
 		if (r)
 			r = dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias,
-						 1, MPATH_UDEV_RELOAD_FLAG);
+						 MPATH_UDEV_RELOAD_FLAG);
 		break;
 
 	case ACT_RESIZE:
@@ -647,7 +647,7 @@ domap (struct multipath * mpp, char * params)
 			r = dm_addmap_reload(mpp, params);
 			if (r)
 				r = dm_simplecmd_noflush(DM_DEVICE_RESUME,
-							 mpp->alias, 1,
+							 mpp->alias,
 							 MPATH_UDEV_RELOAD_FLAG);
 		}
 		break;
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 8a89f46..6983ab6 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -254,8 +254,8 @@ dm_simplecmd_flush (int task, const char *name, uint16_t udev_flags) {
 }
 
 extern int
-dm_simplecmd_noflush (int task, const char *name, int needsync, uint16_t udev_flags) {
-	return dm_simplecmd(task, name, 1, needsync, udev_flags, 0);
+dm_simplecmd_noflush (int task, const char *name, uint16_t udev_flags) {
+	return dm_simplecmd(task, name, 1, 1, udev_flags, 0);
 }
 
 static int
@@ -847,7 +847,7 @@ dm_suspend_and_flush_map (const char * mapname)
 		return 0;
 	}
 	condlog(2, "failed to remove multipath map %s", mapname);
-	dm_simplecmd_noflush(DM_DEVICE_RESUME, mapname, 1, 0);
+	dm_simplecmd_noflush(DM_DEVICE_RESUME, mapname, 0);
 	if (queue_if_no_path)
 		s = dm_queue_if_no_path((char *)mapname, 1);
 	return 1;
@@ -1486,7 +1486,8 @@ int dm_reassign_table(const char *name, char *old, char *new)
 			condlog(3, "%s: failed to reassign targets", name);
 			goto out_reload;
 		}
-		dm_simplecmd_noflush(DM_DEVICE_RESUME, name, 1, MPATH_UDEV_RELOAD_FLAG);
+		dm_simplecmd_noflush(DM_DEVICE_RESUME, name,
+				     MPATH_UDEV_RELOAD_FLAG);
 	}
 	r = 1;
 
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 8dd0963..bc13b07 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -16,7 +16,7 @@ void dm_init(void);
 int dm_prereq (void);
 int dm_drv_version (unsigned int * version, char * str);
 int dm_simplecmd_flush (int, const char *, uint16_t);
-int dm_simplecmd_noflush (int, const char *, int, uint16_t);
+int dm_simplecmd_noflush (int, const char *, uint16_t);
 int dm_addmap_create (struct multipath *mpp, char *params);
 int dm_addmap_reload (struct multipath *mpp, char *params);
 int dm_map_present (const char *);
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 5112786..8b3cb9d 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -937,7 +937,7 @@ cli_suspend(void * v, char ** reply, int * len, void * data)
 		return 1;
 	}
 
-	r = dm_simplecmd_noflush(DM_DEVICE_SUSPEND, param, 0, 0);
+	r = dm_simplecmd_noflush(DM_DEVICE_SUSPEND, param, 0);
 
 	condlog(2, "%s: suspend (operator)", param);
 
@@ -967,7 +967,7 @@ cli_resume(void * v, char ** reply, int * len, void * data)
 		return 1;
 	}
 
-	r = dm_simplecmd_noflush(DM_DEVICE_RESUME, param, 1, 0);
+	r = dm_simplecmd_noflush(DM_DEVICE_RESUME, param, 0);
 
 	condlog(2, "%s: resume (operator)", param);
 
-- 
2.6.6
