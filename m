From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 06/30] multipath-tools: Fix more strncpy(X, Y,
	size - 1) calls
Date: Mon, 24 Jun 2019 11:27:31 +0200
Message-ID: <20190624092756.7769-7-mwilck@suse.com>
References: <20190624092756.7769-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190624092756.7769-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The compiler emitted no warnings for these, but for consistency
it makes sense to fix them, too.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist.c | 2 +-
 libmultipath/configure.c        | 4 ++--
 libmultipath/prio.c             | 3 ++-
 libmultipath/structs_vec.c      | 3 ++-
 multipathd/waiter.c             | 3 ++-
 5 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 4abcaed5..53022f5b 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -618,7 +618,7 @@ int send_prout_activepath(char * dev, int rq_servact, int rq_scope,
 	int rc;
 
 	memset(&thread, 0, sizeof(thread));
-	strncpy(param.dev, dev, FILE_NAME_SIZE - 1);
+	strlcpy(param.dev, dev, FILE_NAME_SIZE);
 	/* Initialize and set thread joinable attribute */
 	pthread_attr_init(&attr);
 	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 0648c0d6..52afa378 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -650,7 +650,7 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 		if (cmpp) {
 			condlog(2, "%s: rename %s to %s", mpp->wwid,
 				cmpp->alias, mpp->alias);
-			strncpy(mpp->alias_old, cmpp->alias, WWID_SIZE - 1);
+			strlcpy(mpp->alias_old, cmpp->alias, WWID_SIZE);
 			mpp->action = ACT_RENAME;
 			if (force_reload) {
 				mpp->force_udev_reload = 1;
@@ -1257,7 +1257,7 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 			if (!deadmap(mpp))
 				continue;
 
-			strncpy(alias, mpp->alias, WWID_SIZE - 1);
+			strlcpy(alias, mpp->alias, WWID_SIZE);
 
 			vector_del_slot(newmp, i);
 			i--;
diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index 0590218d..87de1f97 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -5,6 +5,7 @@
 #include <sys/stat.h>
 
 #include "debug.h"
+#include "util.h"
 #include "prio.h"
 
 static LIST_HEAD(prioritizers);
@@ -166,7 +167,7 @@ void prio_get (char *multipath_dir, struct prio * dst, char * name, char * args)
 
 	strncpy(dst->name, src->name, PRIO_NAME_LEN);
 	if (args)
-		strncpy(dst->args, args, PRIO_ARGS_LEN - 1);
+		strlcpy(dst->args, args, PRIO_ARGS_LEN);
 	dst->getprio = src->getprio;
 	dst->handle = NULL;
 
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index db5d19da..c43b58fb 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -2,6 +2,7 @@
 #include <string.h>
 #include <unistd.h>
 
+#include "util.h"
 #include "checkers.h"
 #include "vector.h"
 #include "defaults.h"
@@ -350,7 +351,7 @@ find_existing_alias (struct multipath * mpp,
 
 	vector_foreach_slot (vecs->mpvec, mp, i)
 		if (strncmp(mp->wwid, mpp->wwid, WWID_SIZE - 1) == 0) {
-			strncpy(mpp->alias_old, mp->alias, WWID_SIZE - 1);
+			strlcpy(mpp->alias_old, mp->alias, WWID_SIZE);
 			return;
 		}
 }
diff --git a/multipathd/waiter.c b/multipathd/waiter.c
index 5895f157..eb8d6996 100644
--- a/multipathd/waiter.c
+++ b/multipathd/waiter.c
@@ -11,6 +11,7 @@
 #include <signal.h>
 #include <urcu.h>
 
+#include "util.h"
 #include "vector.h"
 #include "memory.h"
 #include "checkers.h"
@@ -210,7 +211,7 @@ int start_waiter_thread (struct multipath *mpp, struct vectors *vecs)
 	if (!wp)
 		goto out;
 
-	strncpy(wp->mapname, mpp->alias, WWID_SIZE - 1);
+	strlcpy(wp->mapname, mpp->alias, WWID_SIZE);
 	wp->vecs = vecs;
 
 	if (pthread_create(&wp->thread, &waiter_attr, waitevent, wp)) {
-- 
2.21.0
