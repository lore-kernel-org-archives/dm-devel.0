From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/26] dmparser: use 'is_daemon' as argument for
	disassemble_map()
Date: Mon,  4 Jul 2016 09:08:25 +0200
Message-ID: <1467616126-10036-6-git-send-email-hare@suse.de>
References: <1467616126-10036-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467616126-10036-1-git-send-email-hare@suse.de>
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

Use 'is_daemon' as argument for disassemble_map() so that
dmparser.c doesn't need to access 'struct config' anymore.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmpathpersist/mpath_persist.c | 2 +-
 libmultipath/dmparser.c         | 6 +++---
 libmultipath/dmparser.h         | 2 +-
 libmultipath/structs_vec.c      | 2 +-
 multipath/main.c                | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 35e8837..ad6aec9 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -395,7 +395,7 @@ get_mpvec (vector curmp, vector pathvec, char * refwwid)
 		condlog(3, "params = %s", params);
 		dm_get_status(mpp->alias, status);
 		condlog(3, "status = %s", status);
-		disassemble_map (pathvec, params, mpp);
+		disassemble_map (pathvec, params, mpp, conf->daemon);
 
 		/*
 		 * disassemble_map() can add new paths to pathvec.
diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 98fb559..9e79ecd 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -13,7 +13,6 @@
 #include "structs.h"
 #include "util.h"
 #include "debug.h"
-#include "config.h"
 
 #define WORD_SIZE 64
 
@@ -142,7 +141,8 @@ assemble_map (struct multipath * mp, char * params, int len)
 }
 
 extern int
-disassemble_map (vector pathvec, char * params, struct multipath * mpp)
+disassemble_map (vector pathvec, char * params, struct multipath * mpp,
+		 int is_daemon)
 {
 	char * word;
 	char * p;
@@ -351,7 +351,7 @@ disassemble_map (vector pathvec, char * params, struct multipath * mpp)
 						WWID_SIZE - 1);
 				}
 				/* Only call this in multipath client mode */
-				if (!conf->daemon && store_path(pathvec, pp))
+				if (!is_daemon && store_path(pathvec, pp))
 					goto out1;
 			} else {
 				if (!strlen(pp->wwid) &&
diff --git a/libmultipath/dmparser.h b/libmultipath/dmparser.h
index 1b45df0..e1badb0 100644
--- a/libmultipath/dmparser.h
+++ b/libmultipath/dmparser.h
@@ -1,3 +1,3 @@
 int assemble_map (struct multipath *, char *, int);
-int disassemble_map (vector, char *, struct multipath *);
+int disassemble_map (vector, char *, struct multipath *, int);
 int disassemble_status (char *, struct multipath *);
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 38df71b..eea8ddd 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -259,7 +259,7 @@ update_multipath_table (struct multipath *mpp, vector pathvec)
 		return 1;
 	}
 
-	if (disassemble_map(pathvec, params, mpp)) {
+	if (disassemble_map(pathvec, params, mpp, conf->daemon)) {
 		condlog(3, "%s: cannot disassemble map", mpp->alias);
 		return 1;
 	}
diff --git a/multipath/main.c b/multipath/main.c
index 0dbe281..30710ea 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -206,7 +206,7 @@ get_dm_mpvec (vector curmp, vector pathvec, char * refwwid)
 		dm_get_status(mpp->alias, status);
 		condlog(3, "status = %s", status);
 
-		disassemble_map(pathvec, params, mpp);
+		disassemble_map(pathvec, params, mpp, conf->daemon);
 
 		/*
 		 * disassemble_map() can add new paths to pathvec.
-- 
2.6.6
