From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 13/15] libmultipath: add new checker class
	functions
Date: Thu, 16 Jan 2020 20:18:18 -0600
Message-ID: <1579227500-17196-14-git-send-email-bmarzins@redhat.com>
References: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

This commit adds the optional functions libcheck_load, libcheck_unload,
and libcheck_reset. libcheck_load is called when a checker is first
loaded, libcheck_unload is called when it is unloaded, and
libcheck_reset is called during reconfigure, after all the current
paths have been removed. They are designed to setup, reset, and destroy
global state that all checkers of this class use. They will be used
in future commits.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers.c | 29 ++++++++++++++++++++++++++++-
 libmultipath/checkers.h |  1 +
 multipathd/main.c       |  1 +
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index a08bf418..5c7d3004 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -18,6 +18,9 @@ struct checker_class {
 	int (*init)(struct checker *);       /* to allocate the context */
 	int (*mp_init)(struct checker *);    /* to allocate the mpcontext */
 	void (*free)(struct checker *);      /* to free the context */
+	int (*load)(void);                   /* to allocate global variables */
+	void (*unload)(void);                /* to free global variables */
+	int (*reset)(void);		     /* to reset the global variables */
 	const char **msgtable;
 	short msgtable_size;
 };
@@ -66,6 +69,8 @@ void free_checker_class(struct checker_class *c)
 	}
 	condlog(3, "unloading %s checker", c->name);
 	list_del(&c->node);
+	if (c->unload)
+		c->unload();
 	if (c->handle) {
 		if (dlclose(c->handle) != 0) {
 			condlog(0, "Cannot unload checker %s: %s",
@@ -98,6 +103,18 @@ static struct checker_class *checker_class_lookup(const char *name)
 	return NULL;
 }
 
+int reset_checker_classes(void)
+{
+	int ret = 0;
+	struct checker_class *c;
+
+	list_for_each_entry(c, &checkers, node) {
+		if (c->reset)
+			ret = ret? ret : c->reset();
+	}
+	return ret;
+}
+
 static struct checker_class *add_checker_class(const char *multipath_dir,
 					       const char *name)
 {
@@ -142,7 +159,11 @@ static struct checker_class *add_checker_class(const char *multipath_dir,
 		goto out;
 
 	c->mp_init = (int (*)(struct checker *)) dlsym(c->handle, "libcheck_mp_init");
-	/* NULL mp_init is o.k. call dlerror() to clear out any error string */
+	c->load = (int (*)(void)) dlsym(c->handle, "libcheck_load");
+	c->unload = (void (*)(void)) dlsym(c->handle, "libcheck_unload");
+	c->reset = (int (*)(void)) dlsym(c->handle, "libcheck_reset");
+	/* These 4 functions can be NULL. call dlerror() to clear out any
+	 * error string */
 	dlerror();
 
 	c->free = (void (*)(struct checker *)) dlsym(c->handle, "libcheck_free");
@@ -168,6 +189,12 @@ static struct checker_class *add_checker_class(const char *multipath_dir,
 	condlog(3, "checker %s: message table size = %d",
 		c->name, c->msgtable_size);
 
+	if (c->load && c->load() != 0) {
+		condlog(0, "%s: failed to load checker", c->name);
+		c->unload = NULL;
+		goto out;
+	}
+
 done:
 	c->sync = 1;
 	list_add(&c->node, &checkers);
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 5237e7ec..d9930467 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -150,6 +150,7 @@ void checker_disable (struct checker *);
 int checker_check (struct checker *, int);
 int checker_is_sync(const struct checker *);
 const char *checker_name (const struct checker *);
+int reset_checker_classes(void);
 /*
  * This returns a string that's best prepended with "$NAME checker",
  * where $NAME is the return value of checker_name().
diff --git a/multipathd/main.c b/multipathd/main.c
index 9e01cfaa..8ee8a77d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2607,6 +2607,7 @@ reconfigure (struct vectors * vecs)
 	vecs->pathvec = NULL;
 	delete_all_foreign();
 
+	reset_checker_classes();
 	/* Re-read any timezone changes */
 	tzset();
 
-- 
2.17.2
