From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 19/26] prio: use 'multipath_dir' as argument
Date: Mon, 20 Jun 2016 10:09:06 +0200
Message-ID: <1466410153-23896-20-git-send-email-hare@suse.de>
References: <1466410153-23896-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466410153-23896-1-git-send-email-hare@suse.de>
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
for init_prio() and prio_get().

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/prio.c    | 24 ++++++++++++++++--------
 libmultipath/prio.h    |  6 +++---
 libmultipath/propsel.c | 16 ++++++++--------
 multipath/main.c       |  2 +-
 multipathd/main.c      |  2 +-
 5 files changed, 29 insertions(+), 21 deletions(-)

diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index fbf3190..c37d1b0 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -17,9 +17,9 @@ unsigned int get_prio_timeout(unsigned int default_timeout)
 	return default_timeout;
 }
 
-int init_prio (void)
+int init_prio (char *multipath_dir)
 {
-	if (!add_prio(DEFAULT_PRIO))
+	if (!add_prio(multipath_dir, DEFAULT_PRIO))
 		return 1;
 	return 0;
 }
@@ -78,7 +78,7 @@ struct prio * prio_lookup (char * name)
 		if (!strncmp(name, p->name, PRIO_NAME_LEN))
 			return p;
 	}
-	return add_prio(name);
+	return NULL;
 }
 
 int prio_set_args (struct prio * p, char * args)
@@ -86,7 +86,7 @@ int prio_set_args (struct prio * p, char * args)
 	return snprintf(p->args, PRIO_ARGS_LEN, "%s", args);
 }
 
-struct prio * add_prio (char * name)
+struct prio * add_prio (char *multipath_dir, char * name)
 {
 	char libname[LIB_PRIO_NAMELEN];
 	struct stat stbuf;
@@ -98,10 +98,10 @@ struct prio * add_prio (char * name)
 		return NULL;
 	snprintf(p->name, PRIO_NAME_LEN, "%s", name);
 	snprintf(libname, LIB_PRIO_NAMELEN, "%s/libprio%s.so",
-		 conf->multipath_dir, name);
+		 multipath_dir, name);
 	if (stat(libname,&stbuf) < 0) {
 		condlog(0,"Prioritizer '%s' not found in %s",
-			name, conf->multipath_dir);
+			name, multipath_dir);
 		goto out;
 	}
 	condlog(3, "loading %s prioritizer", libname);
@@ -147,10 +147,18 @@ char * prio_args (struct prio * p)
 	return p->args;
 }
 
-void prio_get (struct prio * dst, char * name, char * args)
+void prio_get (char *multipath_dir, struct prio * dst, char * name, char * args)
 {
-	struct prio * src = prio_lookup(name);
+	struct prio * src = NULL;
+
+	if (!dst)
+		return;
 
+	if (name && strlen(name)) {
+		src = prio_lookup(name);
+		if (!src)
+			src = add_prio(multipath_dir, name);
+	}
 	if (!src) {
 		dst->getprio = NULL;
 		return;
diff --git a/libmultipath/prio.h b/libmultipath/prio.h
index 258dee7..ce72a54 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -53,12 +53,12 @@ struct prio {
 };
 
 unsigned int get_prio_timeout(unsigned int default_timeout);
-int init_prio (void);
+int init_prio (char *);
 void cleanup_prio (void);
-struct prio * add_prio (char *);
+struct prio * add_prio (char *, char *);
 struct prio * prio_lookup (char *);
 int prio_getprio (struct prio *, struct path *);
-void prio_get (struct prio *, char *, char *);
+void prio_get (char *, struct prio *, char *, char *);
 void prio_put (struct prio *);
 int prio_selected (struct prio *);
 char * prio_name (struct prio *);
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index c1f3d4e..a97e80f 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -383,13 +383,13 @@ detect_prio(struct path * pp)
 		return;
 	if (get_asymmetric_access_state(pp->fd, ret) < 0)
 		return;
-	prio_get(p, PRIO_ALUA, DEFAULT_PRIO_ARGS);
+	prio_get(conf->multipath_dir, p, PRIO_ALUA, DEFAULT_PRIO_ARGS);
 }
 
-#define set_prio(src, msg)						\
+#define set_prio(dir, src, msg)						\
 do {									\
 	if (src && src->prio_name) {					\
-		prio_get(p, src->prio_name, src->prio_args);		\
+		prio_get(dir, p, src->prio_name, src->prio_args); \
 		origin = msg;						\
 		goto out;						\
 	}								\
@@ -410,11 +410,11 @@ select_prio (struct path * pp)
 		}
 	}
 	mpe = find_mpe(conf->hwtable, pp->wwid);
-	set_prio(mpe, "(LUN setting)");
-	set_prio(conf->overrides, "(overrides setting)");
-	set_prio(pp->hwe, "controller setting)");
-	set_prio(conf, "(config file default)");
-	prio_get(p, DEFAULT_PRIO, DEFAULT_PRIO_ARGS);
+	set_prio(conf->multipath_dir, mpe, "(LUN setting)");
+	set_prio(conf->multipath_dir, conf->overrides, "(overrides setting)");
+	set_prio(conf->multipath_dir, pp->hwe, "controller setting)");
+	set_prio(conf->multipath_dir, conf, "(config file default)");
+	prio_get(conf->multipath_dir, p, DEFAULT_PRIO, DEFAULT_PRIO_ARGS);
 	origin = "(internal default)";
 out:
 	/*
diff --git a/multipath/main.c b/multipath/main.c
index 70412a8..a6f593f 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -626,7 +626,7 @@ main (int argc, char *argv[])
 		condlog(0, "failed to initialize checkers");
 		goto out;
 	}
-	if (init_prio()) {
+	if (init_prio(conf->multipath_dir)) {
 		condlog(0, "failed to initialize prioritizers");
 		goto out;
 	}
diff --git a/multipathd/main.c b/multipathd/main.c
index 09b96c6..a076f71 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2114,7 +2114,7 @@ child (void * param)
 		condlog(0, "failed to initialize checkers");
 		goto failed;
 	}
-	if (init_prio()) {
+	if (init_prio(conf->multipath_dir)) {
 		condlog(0, "failed to initialize prioritizers");
 		goto failed;
 	}
-- 
2.6.6
