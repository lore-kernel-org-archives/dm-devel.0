From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 18/26] checkers: use 'multipath_dir' as argument
Date: Mon,  4 Jul 2016 09:08:38 +0200
Message-ID: <1467616126-10036-19-git-send-email-hare@suse.de>
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

Pass in the 'multipath_dir' config setting as explicit argument
for init_checkers() and checker_get(). With this we can remove
references to struct config.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/checkers.c | 22 +++++++++++++---------
 libmultipath/checkers.h |  6 +++---
 libmultipath/propsel.c  |  2 +-
 multipath/main.c        |  2 +-
 multipathd/main.c       |  2 +-
 5 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index ef1d099..ad7d96c 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -7,7 +7,6 @@
 #include "debug.h"
 #include "checkers.h"
 #include "vector.h"
-#include "config.h"
 
 char *checker_state_names[] = {
       "wild",
@@ -29,9 +28,9 @@ char * checker_state_name (int i)
 	return checker_state_names[i];
 }
 
-int init_checkers (void)
+int init_checkers (char *multipath_dir)
 {
-	if (!add_checker(DEFAULT_CHECKER))
+	if (!add_checker(multipath_dir, DEFAULT_CHECKER))
 		return 1;
 	return 0;
 }
@@ -89,10 +88,10 @@ struct checker * checker_lookup (char * name)
 		if (!strncmp(name, c->name, CHECKER_NAME_LEN))
 			return c;
 	}
-	return add_checker(name);
+	return NULL;
 }
 
-struct checker * add_checker (char * name)
+struct checker * add_checker (char *multipath_dir, char * name)
 {
 	char libname[LIB_CHECKER_NAMELEN];
 	struct stat stbuf;
@@ -104,10 +103,10 @@ struct checker * add_checker (char * name)
 		return NULL;
 	snprintf(c->name, CHECKER_NAME_LEN, "%s", name);
 	snprintf(libname, LIB_CHECKER_NAMELEN, "%s/libcheck%s.so",
-		 conf->multipath_dir, name);
+		 multipath_dir, name);
 	if (stat(libname,&stbuf) < 0) {
 		condlog(0,"Checker '%s' not found in %s",
-			name, conf->multipath_dir);
+			name, multipath_dir);
 		goto out;
 	}
 	condlog(3, "loading %s checker", libname);
@@ -253,13 +252,18 @@ void checker_clear_message (struct checker *c)
 	c->message[0] = '\0';
 }
 
-void checker_get (struct checker * dst, char * name)
+void checker_get (char *multipath_dir, struct checker * dst, char * name)
 {
-	struct checker * src = checker_lookup(name);
+	struct checker * src = NULL;
 
 	if (!dst)
 		return;
 
+	if (name && strlen(name)) {
+		src = checker_lookup(name);
+		if (!src)
+			src = add_checker(multipath_dir, name);
+	}
 	if (!src) {
 		dst->check = NULL;
 		return;
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index a935b3f..a24b12e 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -119,9 +119,9 @@ struct checker {
 #define MSG(c, fmt, args...) snprintf((c)->message, CHECKER_MSG_LEN, fmt, ##args);
 
 char * checker_state_name (int);
-int init_checkers (void);
+int init_checkers (char *);
 void cleanup_checkers (void);
-struct checker * add_checker (char *);
+struct checker * add_checker (char *, char *);
 struct checker * checker_lookup (char *);
 int checker_init (struct checker *, void **);
 void checker_put (struct checker *);
@@ -136,6 +136,6 @@ int checker_selected (struct checker *);
 char * checker_name (struct checker *);
 char * checker_message (struct checker *);
 void checker_clear_message (struct checker *c);
-void checker_get (struct checker *, char *);
+void checker_get (char *, struct checker *, char *);
 
 #endif /* _CHECKERS_H */
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 71a0941..c1d9192 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -328,7 +328,7 @@ select_checker(struct path *pp)
 	do_set(checker_name, conf, checker_name, "(config file setting)");
 	do_default(checker_name, DEFAULT_CHECKER);
 out:
-	checker_get(c, checker_name);
+	checker_get(conf->multipath_dir, c, checker_name);
 	condlog(3, "%s: path_checker = %s %s", pp->dev, c->name, origin);
 	if (conf->checker_timeout) {
 		c->timeout = conf->checker_timeout;
diff --git a/multipath/main.c b/multipath/main.c
index ca4c1f5..70412a8 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -622,7 +622,7 @@ main (int argc, char *argv[])
 				conf->max_fds, strerror(errno));
 	}
 
-	if (init_checkers()) {
+	if (init_checkers(conf->multipath_dir)) {
 		condlog(0, "failed to initialize checkers");
 		goto out;
 	}
diff --git a/multipathd/main.c b/multipathd/main.c
index 61ef2e6..5a12007 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2110,7 +2110,7 @@ child (void * param)
 
 	dm_init(conf->verbosity);
 	dm_drv_version(conf->version, TGT_MPATH);
-	if (init_checkers()) {
+	if (init_checkers(conf->multipath_dir)) {
 		condlog(0, "failed to initialize checkers");
 		goto failed;
 	}
-- 
2.6.6
