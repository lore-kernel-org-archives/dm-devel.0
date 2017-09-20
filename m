From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH] libmultipath: ensure checker->fd == -1 if not set
Date: Wed, 20 Sep 2017 22:28:15 +0200
Message-ID: <20170920202815.26068-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>
Cc: Martin Wilck <mwilck@suse.de>, dm-devel@redhat.com
List-Id: dm-devel.ids

Since 2be1fbf06c90 "libmultipath: sanitize fd handling", we treat
fd == 0 as a valid value. Make sure that this value isn't accidentally
set. Also, fix one more case where fd == 0 was considered invalid.

Fixes: 2be1fbf06c90 libmultipath: sanitize fd handling
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers.c           | 9 ++++++++-
 libmultipath/checkers.h           | 3 ++-
 libmultipath/checkers/cciss_tur.c | 2 +-
 libmultipath/discovery.c          | 2 +-
 libmultipath/structs.c            | 1 +
 5 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index cd6d6a369faf..9c464e42c7bf 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -44,6 +44,7 @@ struct checker * alloc_checker (void)
 	if (c) {
 		INIT_LIST_HEAD(&c->node);
 		c->refcount = 1;
+		c->fd = -1;
 	}
 	return c;
 }
@@ -203,6 +204,12 @@ int checker_init (struct checker * c, void ** mpctxt_addr)
 	return 0;
 }
 
+void checker_clear (struct checker *c)
+{
+	memset(c, 0x0, sizeof(struct checker));
+	c->fd = -1;
+}
+
 void checker_put (struct checker * dst)
 {
 	struct checker * src;
@@ -212,7 +219,7 @@ void checker_put (struct checker * dst)
 	src = checker_lookup(dst->name);
 	if (dst->free)
 		dst->free(dst);
-	memset(dst, 0x0, sizeof(struct checker));
+	checker_clear(dst);
 	free_checker(src);
 }
 
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 713399faa9ee..52154ca06129 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -11,7 +11,7 @@
  *
  * PATH_WILD:
  * - Use: None of the checkers (returned if we don't have an fd)
- * - Description: Corner case where "fd <= 0" for path fd (see checker_check())
+ * - Description: Corner case where "fd < 0" for path fd (see checker_check())
  *
  * PATH_UNCHECKED:
  * - Use: Only in directio checker
@@ -128,6 +128,7 @@ void cleanup_checkers (void);
 struct checker * add_checker (char *, char *);
 struct checker * checker_lookup (char *);
 int checker_init (struct checker *, void **);
+void checker_clear (struct checker *);
 void checker_put (struct checker *);
 void checker_reset (struct checker *);
 void checker_set_sync (struct checker *);
diff --git a/libmultipath/checkers/cciss_tur.c b/libmultipath/checkers/cciss_tur.c
index 9d79f965fbb2..436470c7ddbd 100644
--- a/libmultipath/checkers/cciss_tur.c
+++ b/libmultipath/checkers/cciss_tur.c
@@ -73,7 +73,7 @@ int libcheck_check(struct checker * c)
 	LogvolInfo_struct    lvi;       // logical "volume" info
 	IOCTL_Command_struct cic;       // cciss ioctl command
 
-	if ((c->fd) <= 0) {
+	if ((c->fd) < 0) {
 		MSG(c,"no usable fd");
 		ret = -1;
 		goto out;
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index efac82458ffc..cadf4617894f 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1573,7 +1573,7 @@ get_state (struct path * pp, struct config *conf, int daemon, int oldstate)
 		}
 		checker_set_fd(c, pp->fd);
 		if (checker_init(c, pp->mpp?&pp->mpp->mpcontext:NULL)) {
-			memset(c, 0x0, sizeof(struct checker));
+			checker_clear(c);
 			condlog(3, "%s: checker init failed", pp->dev);
 			return PATH_UNCHECKED;
 		}
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 828e7907073a..3e057f503fa8 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -99,6 +99,7 @@ alloc_path (void)
 		pp->fd = -1;
 		pp->tpgs = TPGS_UNDEF;
 		pp->priority = PRIO_UNDEF;
+		checker_clear(&pp->checker);
 	}
 	return pp;
 }
-- 
2.14.0
