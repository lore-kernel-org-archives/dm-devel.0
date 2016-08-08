From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 2/4] multipath-tools: add checker callout to
	repair path
Date: Mon,  8 Aug 2016 07:01:48 -0500
Message-ID: <1470657710-28081-3-git-send-email-mchristi@redhat.com>
References: <1470657710-28081-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470657710-28081-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: dm-devel.ids

This patch adds a callback which can be used to repair a path
if check() has determined it is in the PATH_DOWN state.

The next patch that adds rbd checker support which will use this to
handle the case where a rbd device is blacklisted.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 libmultipath/checkers.c              | 23 +++++++++++++++++++++++
 libmultipath/checkers.h              |  4 ++++
 libmultipath/checkers/cciss_tur.c    |  5 +++++
 libmultipath/checkers/directio.c     |  5 +++++
 libmultipath/checkers/emc_clariion.c |  5 +++++
 libmultipath/checkers/hp_sw.c        |  5 +++++
 libmultipath/checkers/rdac.c         |  5 +++++
 libmultipath/checkers/readsector0.c  |  5 +++++
 libmultipath/checkers/tur.c          |  5 +++++
 multipathd/main.c                    |  9 +++++++++
 10 files changed, 71 insertions(+)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 42baa86..8976c89 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -138,6 +138,14 @@ struct checker * add_checker (char *multipath_dir, char * name)
 	if (!c->free)
 		goto out;
 
+	c->repair = (void (*)(struct checker *)) dlsym(c->handle,
+						       "libcheck_repair");
+	errstr = dlerror();
+	if (errstr != NULL)
+		condlog(0, "A dynamic linking error occurred: (%s)", errstr);
+	if (!c->repair)
+		goto out;
+
 	c->fd = 0;
 	c->sync = 1;
 	list_add(&c->node, &checkers);
@@ -203,6 +211,20 @@ void checker_put (struct checker * dst)
 	free_checker(src);
 }
 
+void checker_repair (struct checker * c)
+{
+	if (!c)
+		return;
+
+	c->message[0] = '\0';
+	if (c->disable) {
+		MSG(c, "checker disabled");
+		return;
+	}
+
+	c->repair(c);
+}
+
 int checker_check (struct checker * c)
 {
 	int r;
@@ -272,6 +294,7 @@ void checker_get (char *multipath_dir, struct checker * dst, char * name)
 	dst->sync = src->sync;
 	strncpy(dst->name, src->name, CHECKER_NAME_LEN);
 	strncpy(dst->message, src->message, CHECKER_MSG_LEN);
+	dst->repair = src->repair;
 	dst->check = src->check;
 	dst->init = src->init;
 	dst->free = src->free;
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 8fc8616..502d2d9 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -113,6 +113,9 @@ struct checker {
 						multipath-wide. Use MALLOC if
 						you want to stuff data in. */
 	int (*check)(struct checker *);
+	void (*repair)(struct checker *);     /* called if check returns
+					        PATH_DOWN to bring path into
+						usable state */
 	int (*init)(struct checker *);       /* to allocate the context */
 	void (*free)(struct checker *);      /* to free the context */
 };
@@ -132,6 +135,7 @@ void checker_set_async (struct checker *);
 void checker_set_fd (struct checker *, int);
 void checker_enable (struct checker *);
 void checker_disable (struct checker *);
+void checker_repair (struct checker *);
 int checker_check (struct checker *);
 int checker_selected (struct checker *);
 char * checker_name (struct checker *);
diff --git a/libmultipath/checkers/cciss_tur.c b/libmultipath/checkers/cciss_tur.c
index 81500dc..a0ffffe 100644
--- a/libmultipath/checkers/cciss_tur.c
+++ b/libmultipath/checkers/cciss_tur.c
@@ -59,6 +59,11 @@ void libcheck_free (struct checker * c)
 	return;
 }
 
+void libcheck_repair (struct checker * c)
+{
+	return;
+}
+
 extern int
 libcheck_check (struct checker * c)
 {
diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
index 94bf8f7..eec12d5 100644
--- a/libmultipath/checkers/directio.c
+++ b/libmultipath/checkers/directio.c
@@ -118,6 +118,11 @@ void libcheck_free (struct checker * c)
 	free(ct);
 }
 
+void libcheck_repair (struct checker * c)
+{
+	return;
+}
+
 static int
 check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
 {
diff --git a/libmultipath/checkers/emc_clariion.c b/libmultipath/checkers/emc_clariion.c
index 5e416a0..a7b9f86 100644
--- a/libmultipath/checkers/emc_clariion.c
+++ b/libmultipath/checkers/emc_clariion.c
@@ -91,6 +91,11 @@ void libcheck_free (struct checker * c)
 	free(c->context);
 }
 
+void libcheck_repair (struct checker * c)
+{
+	return;
+}
+
 int libcheck_check (struct checker * c)
 {
 	unsigned char sense_buffer[128] = { 0, };
diff --git a/libmultipath/checkers/hp_sw.c b/libmultipath/checkers/hp_sw.c
index fe5e0f9..0cc1111 100644
--- a/libmultipath/checkers/hp_sw.c
+++ b/libmultipath/checkers/hp_sw.c
@@ -44,6 +44,11 @@ void libcheck_free (struct checker * c)
 	return;
 }
 
+void libcheck_repair (struct checker * c)
+{
+	return;
+}
+
 static int
 do_inq(int sg_fd, int cmddt, int evpd, unsigned int pg_op,
        void *resp, int mx_resp_len, int noisy, unsigned int timeout)
diff --git a/libmultipath/checkers/rdac.c b/libmultipath/checkers/rdac.c
index 00e3c44..68682c8 100644
--- a/libmultipath/checkers/rdac.c
+++ b/libmultipath/checkers/rdac.c
@@ -139,6 +139,11 @@ void libcheck_free (struct checker * c)
 	return;
 }
 
+void libcheck_repair (struct checker * c)
+{
+	return;
+}
+
 static int
 do_inq(int sg_fd, unsigned int pg_op, void *resp, int mx_resp_len,
        unsigned int timeout)
diff --git a/libmultipath/checkers/readsector0.c b/libmultipath/checkers/readsector0.c
index 1c2a868..8fccb46 100644
--- a/libmultipath/checkers/readsector0.c
+++ b/libmultipath/checkers/readsector0.c
@@ -23,6 +23,11 @@ void libcheck_free (struct checker * c)
 	return;
 }
 
+void libcheck_repair (struct checker * c)
+{
+	return;
+}
+
 int libcheck_check (struct checker * c)
 {
 	unsigned char buf[4096];
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index c4ef8a8..219afc3 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -97,6 +97,11 @@ void libcheck_free (struct checker * c)
 	return;
 }
 
+void libcheck_repair (struct checker * c)
+{
+	return;
+}
+
 #define TUR_MSG(msg, fmt, args...) snprintf(msg, CHECKER_MSG_LEN, fmt, ##args);
 
 int
diff --git a/multipathd/main.c b/multipathd/main.c
index 20589a7..f34500c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1725,6 +1725,14 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	return 1;
 }
 
+void repair_path(struct vectors * vecs, struct path * pp)
+{
+	if (pp->state != PATH_DOWN)
+		return;
+
+	checker_repair(&pp->checker);
+}
+
 static void *
 checkerloop (void *ap)
 {
@@ -1796,6 +1804,7 @@ checkerloop (void *ap)
 					i--;
 				} else
 					num_paths += rc;
+				repair_path(vecs, pp);
 			}
 			lock_cleanup_pop(vecs->lock);
 		}
-- 
2.7.2
