From: mwilck@suse.com
Subject: [PATCH 22/23] multipath: fix leaks in check_path_valid()
Date: Thu, 24 Sep 2020 15:40:53 +0200
Message-ID: <20200924134054.14632-23-mwilck@suse.com>
References: <20200924134054.14632-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924134054.14632-1-mwilck@suse.com>
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
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

There were two leaks in check_path_valid(): if path status was
successfully determined before calling store_pathvec(), free_path()
wasn't called. Also, if an error exit occured, neither cleanup
function was called.

This patch fixes both, at the cost of using "static" for the pp and
pathvec variables.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 55 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 43 insertions(+), 12 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index 049a36f..9974993 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -93,7 +93,7 @@ void rcu_register_thread_memb(void) {}
 void rcu_unregister_thread_memb(void) {}
 
 static int
-filter_pathvec (vector pathvec, char * refwwid)
+filter_pathvec (vector pathvec, const char *refwwid)
 {
 	int i;
 	struct path * pp;
@@ -592,12 +592,37 @@ out:
 	return r;
 }
 
+static void cleanup_pathvec(__attribute__((unused)) int dummy, void *arg)
+{
+	vector *ppv = arg;
+
+	if (ppv && *ppv) {
+		free_pathvec(*ppv, FREE_PATHS);
+		*ppv = NULL;
+	}
+}
+
+static void cleanup_path(__attribute__((unused)) int dummy, void *arg)
+{
+	struct path **ppp = arg;
+
+	if (ppp && *ppp) {
+		free_path(*ppp);
+		*ppp = NULL;
+	}
+}
+
 static int
 check_path_valid(const char *name, struct config *conf, bool is_uevent)
 {
 	int fd, r = PATH_IS_ERROR;
-	struct path *pp = NULL;
-	vector pathvec = NULL;
+	static struct path *pp = NULL;
+	static vector pathvec = NULL;
+	const char *wwid;
+
+	/* register these as exit handlers in case we exit irregularly */
+	on_exit(cleanup_path, &pp);
+	on_exit(cleanup_pathvec, &pathvec);
 
 	pp = alloc_path();
 	if (!pp)
@@ -667,13 +692,17 @@ check_path_valid(const char *name, struct config *conf, bool is_uevent)
 	if (store_path(pathvec, pp) != 0) {
 		free_path(pp);
 		goto fail;
+	} else {
+		/* make sure path isn't freed twice */
+		wwid = pp->wwid;
+		pp = NULL;
 	}
 
 	/* For find_multipaths = SMART, if there is more than one path
 	 * matching the refwwid, then the path is valid */
 	if (path_discovery(pathvec, DI_SYSFS | DI_WWID) < 0)
 		goto fail;
-	filter_pathvec(pathvec, pp->wwid);
+	filter_pathvec(pathvec, wwid);
 	if (VECTOR_SIZE(pathvec) > 1)
 		r = PATH_IS_VALID;
 	else
@@ -681,21 +710,23 @@ check_path_valid(const char *name, struct config *conf, bool is_uevent)
 
 out:
 	r = print_cmd_valid(r, pathvec, conf);
-	free_pathvec(pathvec, FREE_PATHS);
 	/*
 	 * multipath -u must exit with status 0, otherwise udev won't
 	 * import its output.
 	 */
 	if (!is_uevent && r == PATH_IS_NOT_VALID)
-		return RTVL_FAIL;
-	return RTVL_OK;
+		r = RTVL_FAIL;
+	else
+		r = RTVL_OK;
+	goto cleanup;
 
 fail:
-	if (pathvec)
-		free_pathvec(pathvec, FREE_PATHS);
-	else
-		free_path(pp);
-	return RTVL_FAIL;
+	r = RTVL_FAIL;
+
+cleanup:
+	cleanup_path(0, &pp);
+	cleanup_pathvec(0, &pathvec);
+	return r;
 }
 
 static int
-- 
2.28.0
