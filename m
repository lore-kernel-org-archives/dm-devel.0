From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 4/4] libmultipath: fix mpcontext initialization
Date: Fri, 13 Sep 2019 17:04:04 -0500
Message-ID: <1568412244-23982-5-git-send-email-bmarzins@redhat.com>
References: <1568412244-23982-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1568412244-23982-1-git-send-email-bmarzins@redhat.com>
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

If a path is discovered before there is a multipath device for it to
belong to, the checker will not have its mpcontext initialized, even if
that path later belongs to a multipath device. A checker's mpcontext is
only set when the checker is selected, and is set to NULL if there is no
multipath device associated with the path. This only impacts the emc
checker. However, it makes the emc checker unable to determine if a
passive path is connected to an inactive snapshot or not.

This can be solved by adding a new checker class function, mp_init().
This is called when the checker is first initialized, and whenever the
checker is called, if the checker's mpcontext hasn't been initialized.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers.c              | 27 +++++++++++++++++++++++++--
 libmultipath/checkers.h              |  1 +
 libmultipath/checkers/emc_clariion.c |  7 +++++++
 libmultipath/discovery.c             |  2 ++
 4 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index f4fdcae9..a08bf418 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -16,6 +16,7 @@ struct checker_class {
 	char name[CHECKER_NAME_LEN];
 	int (*check)(struct checker *);
 	int (*init)(struct checker *);       /* to allocate the context */
+	int (*mp_init)(struct checker *);    /* to allocate the mpcontext */
 	void (*free)(struct checker *);      /* to free the context */
 	const char **msgtable;
 	short msgtable_size;
@@ -140,6 +141,10 @@ static struct checker_class *add_checker_class(const char *multipath_dir,
 	if (!c->init)
 		goto out;
 
+	c->mp_init = (int (*)(struct checker *)) dlsym(c->handle, "libcheck_mp_init");
+	/* NULL mp_init is o.k. call dlerror() to clear out any error string */
+	dlerror();
+
 	c->free = (void (*)(struct checker *)) dlsym(c->handle, "libcheck_free");
 	errstr = dlerror();
 	if (errstr != NULL)
@@ -212,8 +217,26 @@ int checker_init (struct checker * c, void ** mpctxt_addr)
 	if (!c || !c->cls)
 		return 1;
 	c->mpcontext = mpctxt_addr;
-	if (c->cls->init)
-		return c->cls->init(c);
+	if (c->cls->init && c->cls->init(c) != 0)
+		return 1;
+	if (mpctxt_addr && *mpctxt_addr == NULL && c->cls->mp_init &&
+	    c->cls->mp_init(c) != 0) /* continue even if mp_init fails */
+		c->mpcontext = NULL;
+	return 0;
+}
+
+int checker_mp_init(struct checker * c, void ** mpctxt_addr)
+{
+	if (!c || !c->cls)
+		return 1;
+	if (c->mpcontext || !mpctxt_addr)
+		return 0;
+	c->mpcontext = mpctxt_addr;
+	if (*mpctxt_addr == NULL && c->cls->mp_init &&
+	    c->cls->mp_init(c) != 0) {
+		c->mpcontext = NULL;
+		return 1;
+	}
 	return 0;
 }
 
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index dab197f9..5237e7ec 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -138,6 +138,7 @@ const char *checker_state_name(int);
 int init_checkers(const char *);
 void cleanup_checkers (void);
 int checker_init (struct checker *, void **);
+int checker_mp_init(struct checker *, void **);
 void checker_clear (struct checker *);
 void checker_put (struct checker *);
 void checker_reset (struct checker *);
diff --git a/libmultipath/checkers/emc_clariion.c b/libmultipath/checkers/emc_clariion.c
index 6fc89113..5cd63aca 100644
--- a/libmultipath/checkers/emc_clariion.c
+++ b/libmultipath/checkers/emc_clariion.c
@@ -107,11 +107,18 @@ int libcheck_init (struct checker * c)
 		return 1;
 	((struct emc_clariion_checker_path_context *)c->context)->wwn_set = 0;
 
+	return 0;
+}
+
+int libcheck_mp_init (struct checker * c)
+{
 	/*
 	 * Allocate and initialize the multi-path global context.
 	 */
 	if (c->mpcontext && *c->mpcontext == NULL) {
 		void * mpctxt = malloc(sizeof(int));
+		if (!mpctxt)
+			return 1;
 		*c->mpcontext = mpctxt;
 		CLR_INACTIVE_SNAP(c);
 	}
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index acca466c..72f455e8 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1608,6 +1608,8 @@ get_state (struct path * pp, struct config *conf, int daemon, int oldstate)
 			return PATH_UNCHECKED;
 		}
 	}
+	if (pp->mpp && !c->mpcontext)
+		checker_mp_init(c, &pp->mpp->mpcontext);
 	checker_clear_message(c);
 	if (daemon) {
 		if (conf->force_sync == 0)
-- 
2.17.2
