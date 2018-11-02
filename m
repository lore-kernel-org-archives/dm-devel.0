From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 21/21] libmultipath/checkers: cleanup
	class/instance model
Date: Fri,  2 Nov 2018 13:21:25 +0100
Message-ID: <20181102122125.30906-22-mwilck@suse.com>
References: <20181102122125.30906-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181102122125.30906-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The checkers code implicitly uses a sort-of OOP class/instance model,
but very clumsily. Separate the checker "class" and "instance" cleanly,
and do a few further cleanups (constifications etc) on the way.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers.c          | 131 ++++++++++++++++---------------
 libmultipath/checkers.h          |  23 ++----
 libmultipath/checkers/directio.c |   2 +-
 libmultipath/checkers/tur.c      |   2 +-
 libmultipath/print.c             |   2 +-
 libmultipath/propsel.c           |  19 ++---
 6 files changed, 89 insertions(+), 90 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 90313c35..848c4c34 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -8,6 +8,19 @@
 #include "checkers.h"
 #include "vector.h"
 
+struct checker_class {
+	struct list_head node;
+	void *handle;
+	int refcount;
+	int sync;
+	char name[CHECKER_NAME_LEN];
+	int (*check)(struct checker *);
+	int (*init)(struct checker *);       /* to allocate the context */
+	void (*free)(struct checker *);      /* to free the context */
+	const char **msgtable;
+	short msgtable_size;
+};
+
 char *checker_state_names[] = {
 	"wild",
 	"unchecked",
@@ -23,38 +36,30 @@ char *checker_state_names[] = {
 
 static LIST_HEAD(checkers);
 
-char * checker_state_name (int i)
+const char *checker_state_name(int i)
 {
 	return checker_state_names[i];
 }
 
-int init_checkers (char *multipath_dir)
-{
-	if (!add_checker(multipath_dir, DEFAULT_CHECKER))
-		return 1;
-	return 0;
-}
-
-struct checker * alloc_checker (void)
+static struct checker_class *alloc_checker_class(void)
 {
-	struct checker *c;
+	struct checker_class *c;
 
-	c = MALLOC(sizeof(struct checker));
+	c = MALLOC(sizeof(struct checker_class));
 	if (c) {
 		INIT_LIST_HEAD(&c->node);
 		c->refcount = 1;
-		c->fd = -1;
 	}
 	return c;
 }
 
-void free_checker (struct checker * c)
+void free_checker_class(struct checker_class *c)
 {
 	if (!c)
 		return;
 	c->refcount--;
 	if (c->refcount) {
-		condlog(3, "%s checker refcount %d",
+		condlog(4, "%s checker refcount %d",
 			c->name, c->refcount);
 		return;
 	}
@@ -71,17 +76,17 @@ void free_checker (struct checker * c)
 
 void cleanup_checkers (void)
 {
-	struct checker * checker_loop;
-	struct checker * checker_temp;
+	struct checker_class *checker_loop;
+	struct checker_class *checker_temp;
 
 	list_for_each_entry_safe(checker_loop, checker_temp, &checkers, node) {
-		free_checker(checker_loop);
+		free_checker_class(checker_loop);
 	}
 }
 
-struct checker * checker_lookup (char * name)
+static struct checker_class *checker_class_lookup(const char *name)
 {
-	struct checker * c;
+	struct checker_class *c;
 
 	if (!name || !strlen(name))
 		return NULL;
@@ -92,14 +97,15 @@ struct checker * checker_lookup (char * name)
 	return NULL;
 }
 
-struct checker * add_checker (char *multipath_dir, char * name)
+static struct checker_class *add_checker_class(const char *multipath_dir,
+					       const char *name)
 {
 	char libname[LIB_CHECKER_NAMELEN];
 	struct stat stbuf;
-	struct checker * c;
+	struct checker_class *c;
 	char *errstr;
 
-	c = alloc_checker();
+	c = alloc_checker_class();
 	if (!c)
 		return NULL;
 	snprintf(c->name, CHECKER_NAME_LEN, "%s", name);
@@ -158,12 +164,11 @@ struct checker * add_checker (char *multipath_dir, char * name)
 		c->name, c->msgtable_size);
 
 done:
-	c->fd = -1;
 	c->sync = 1;
 	list_add(&c->node, &checkers);
 	return c;
 out:
-	free_checker(c);
+	free_checker_class(c);
 	return NULL;
 }
 
@@ -176,16 +181,16 @@ void checker_set_fd (struct checker * c, int fd)
 
 void checker_set_sync (struct checker * c)
 {
-	if (!c)
+	if (!c || !c->cls)
 		return;
-	c->sync = 1;
+	c->cls->sync = 1;
 }
 
 void checker_set_async (struct checker * c)
 {
-	if (!c)
+	if (!c || !c->cls)
 		return;
-	c->sync = 0;
+	c->cls->sync = 0;
 }
 
 void checker_enable (struct checker * c)
@@ -204,11 +209,11 @@ void checker_disable (struct checker * c)
 
 int checker_init (struct checker * c, void ** mpctxt_addr)
 {
-	if (!c)
+	if (!c || !c->cls)
 		return 1;
 	c->mpcontext = mpctxt_addr;
-	if (c->init)
-		return c->init(c);
+	if (c->cls->init)
+		return c->cls->init(c);
 	return 0;
 }
 
@@ -220,15 +225,16 @@ void checker_clear (struct checker *c)
 
 void checker_put (struct checker * dst)
 {
-	struct checker * src;
+	struct checker_class *src;
 
-	if (!dst || !strlen(dst->name))
+	if (!dst)
 		return;
-	src = checker_lookup(dst->name);
-	if (dst->free)
-		dst->free(dst);
+	src = dst->cls;
+
+	if (src && src->free)
+		src->free(dst);
 	checker_clear(dst);
-	free_checker(src);
+	free_checker_class(src);
 }
 
 int checker_check (struct checker * c, int path_state)
@@ -243,32 +249,35 @@ int checker_check (struct checker * c, int path_state)
 		c->msgid = CHECKER_MSGID_DISABLED;
 		return PATH_UNCHECKED;
 	}
-	if (!strncmp(c->name, NONE, 4))
+	if (!strncmp(c->cls->name, NONE, 4))
 		return path_state;
 
 	if (c->fd < 0) {
 		c->msgid = CHECKER_MSGID_NO_FD;
 		return PATH_WILD;
 	}
-	r = c->check(c);
+	r = c->cls->check(c);
 
 	return r;
 }
 
-int checker_selected (struct checker * c)
+int checker_selected(const struct checker *c)
 {
 	if (!c)
 		return 0;
-	if (!strncmp(c->name, NONE, 4))
-		return 1;
-	return (c->check) ? 1 : 0;
+	return c->cls != NULL;
 }
 
 const char *checker_name(const struct checker *c)
 {
-	if (!c)
+	if (!c || !c->cls)
 		return NULL;
-	return c->name;
+	return c->cls->name;
+}
+
+int checker_is_sync(const struct checker *c)
+{
+	return c && c->cls && c->cls->sync;
 }
 
 static const char *generic_msg[CHECKER_GENERIC_MSGTABLE_SIZE] = {
@@ -309,31 +318,29 @@ void checker_clear_message (struct checker *c)
 	c->msgid = CHECKER_MSGID_NONE;
 }
 
-void checker_get (char *multipath_dir, struct checker * dst, char * name)
+void checker_get(const char *multipath_dir, struct checker *dst,
+		 const char *name)
 {
-	struct checker * src = NULL;
+	struct checker_class *src = NULL;
 
 	if (!dst)
 		return;
 
 	if (name && strlen(name)) {
-		src = checker_lookup(name);
+		src = checker_class_lookup(name);
 		if (!src)
-			src = add_checker(multipath_dir, name);
+			src = add_checker_class(multipath_dir, name);
 	}
-	if (!src) {
-		dst->check = NULL;
+	dst->cls = src;
+	if (!src)
 		return;
-	}
-	dst->fd = src->fd;
-	dst->sync = src->sync;
-	strncpy(dst->name, src->name, CHECKER_NAME_LEN);
-	dst->msgid = CHECKER_MSGID_NONE;
-	dst->check = src->check;
-	dst->init = src->init;
-	dst->free = src->free;
-	dst->msgtable = src->msgtable;
-	dst->msgtable_size = src->msgtable_size;
-	dst->handle = NULL;
+
 	src->refcount++;
 }
+
+int init_checkers(const char *multipath_dir)
+{
+	if (!add_checker_class(multipath_dir, DEFAULT_CHECKER))
+		return 1;
+	return 0;
+}
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 3cd46bdf..b2e8f9aa 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -116,32 +116,22 @@ enum {
 	CHECKER_MSGTABLE_SIZE = 100,	/* max msg table size for checkers */
 };
 
+struct checker_class;
 struct checker {
-	struct list_head node;
-	void *handle;
-	int refcount;
+	struct checker_class *cls;
 	int fd;
-	int sync;
 	unsigned int timeout;
 	int disable;
-	char name[CHECKER_NAME_LEN];
 	short msgid;		             /* checker-internal extra status */
 	void * context;                      /* store for persistent data */
 	void ** mpcontext;                   /* store for persistent data shared
 						multipath-wide. Use MALLOC if
 						you want to stuff data in. */
-	int (*check)(struct checker *);
-	int (*init)(struct checker *);       /* to allocate the context */
-	void (*free)(struct checker *);      /* to free the context */
-	const char**msgtable;
-	short msgtable_size;
 };
 
-char * checker_state_name (int);
-int init_checkers (char *);
+const char *checker_state_name(int);
+int init_checkers(const char *);
 void cleanup_checkers (void);
-struct checker * add_checker (char *, char *);
-struct checker * checker_lookup (char *);
 int checker_init (struct checker *, void **);
 void checker_clear (struct checker *);
 void checker_put (struct checker *);
@@ -152,7 +142,8 @@ void checker_set_fd (struct checker *, int);
 void checker_enable (struct checker *);
 void checker_disable (struct checker *);
 int checker_check (struct checker *, int);
-int checker_selected (struct checker *);
+int checker_selected(const struct checker *);
+int checker_is_sync(const struct checker *);
 const char *checker_name (const struct checker *);
 /*
  * This returns a string that's best prepended with "$NAME checker",
@@ -160,7 +151,7 @@ const char *checker_name (const struct checker *);
  */
 const char *checker_message(const struct checker *);
 void checker_clear_message (struct checker *c);
-void checker_get (char *, struct checker *, char *);
+void checker_get(const char *, struct checker *, const char *);
 
 /* Prototypes for symbols exported by path checker dynamic libraries (.so) */
 int libcheck_check(struct checker *);
diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
index c4a0712e..1b00b775 100644
--- a/libmultipath/checkers/directio.c
+++ b/libmultipath/checkers/directio.c
@@ -202,7 +202,7 @@ int libcheck_check (struct checker * c)
 	if (!ct)
 		return PATH_UNCHECKED;
 
-	ret = check_state(c->fd, ct, c->sync, c->timeout);
+	ret = check_state(c->fd, ct, checker_is_sync(c), c->timeout);
 
 	switch (ret)
 	{
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index a27474f9..63b19624 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -323,7 +323,7 @@ int libcheck_check(struct checker * c)
 	if (!ct)
 		return PATH_UNCHECKED;
 
-	if (c->sync)
+	if (checker_is_sync(c))
 		return tur_check(c->fd, c->timeout, &c->msgid);
 
 	/*
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 7b610b94..fc40b0f0 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -615,7 +615,7 @@ static int
 snprint_path_checker (char * buff, size_t len, const struct path * pp)
 {
 	const struct checker * c = &pp->checker;
-	return snprint_str(buff, len, c->name);
+	return snprint_str(buff, len, checker_name(c));
 }
 
 static int
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index fdb5953a..970a3b5c 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -479,26 +479,27 @@ check_rdac(struct path * pp)
 int select_checker(struct config *conf, struct path *pp)
 {
 	const char *origin;
-	char *checker_name;
+	char *ckr_name;
 	struct checker * c = &pp->checker;
 
 	if (pp->detect_checker == DETECT_CHECKER_ON) {
 		origin = autodetect_origin;
 		if (check_rdac(pp)) {
-			checker_name = RDAC;
+			ckr_name = RDAC;
 			goto out;
 		} else if (pp->tpgs > 0) {
-			checker_name = TUR;
+			ckr_name = TUR;
 			goto out;
 		}
 	}
-	do_set(checker_name, conf->overrides, checker_name, overrides_origin);
-	do_set_from_hwe(checker_name, pp, checker_name, hwe_origin);
-	do_set(checker_name, conf, checker_name, conf_origin);
-	do_default(checker_name, DEFAULT_CHECKER);
+	do_set(checker_name, conf->overrides, ckr_name, overrides_origin);
+	do_set_from_hwe(checker_name, pp, ckr_name, hwe_origin);
+	do_set(checker_name, conf, ckr_name, conf_origin);
+	do_default(ckr_name, DEFAULT_CHECKER);
 out:
-	checker_get(conf->multipath_dir, c, checker_name);
-	condlog(3, "%s: path_checker = %s %s", pp->dev, c->name, origin);
+	checker_get(conf->multipath_dir, c, ckr_name);
+	condlog(3, "%s: path_checker = %s %s", pp->dev,
+		checker_name(c), origin);
 	if (conf->checker_timeout) {
 		c->timeout = conf->checker_timeout;
 		condlog(3, "%s: checker timeout = %u s %s",
-- 
2.19.1
