From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 3/7] multipathd: print error message if checkint
	is not initialized
Date: Wed, 24 Oct 2018 00:05:48 +0200
Message-ID: <20181023220552.1306-4-mwilck@suse.com>
References: <20181023220552.1306-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181023220552.1306-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

This is just a safety measure in case I overlooked something wrt
the checkint initialization. It could be reverted once we know the
error message isn't triggered.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/defaults.h |  1 +
 libmultipath/dict.c     | 14 ++++++++++++--
 libmultipath/structs.c  |  1 +
 multipathd/main.c       |  6 ++++++
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 7f3839fc..65769398 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -46,6 +46,7 @@
 #define DEFAULT_UNKNOWN_FIND_MULTIPATHS_TIMEOUT 1
 #define DEFAULT_ALL_TG_PT ALL_TG_PT_OFF
 
+#define CHECKINT_UNDEF		(~0U)
 #define DEFAULT_CHECKINT	5
 #define MAX_CHECKINT(a)		(a << 2)
 
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index c3f5a6e6..a81c051f 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -264,7 +264,17 @@ snprint_mp_ ## option (struct config *conf, char * buff, int len,	\
 	return function (buff, len, mpe->option);			\
 }
 
-declare_def_handler(checkint, set_int)
+static int checkint_handler(struct config *conf, vector strvec)
+{
+	int rc = set_int(strvec, &conf->checkint);
+
+	if (rc)
+		return rc;
+	if (conf->checkint == CHECKINT_UNDEF)
+		conf->checkint--;
+	return 0;
+}
+
 declare_def_snprint(checkint, print_int)
 
 declare_def_handler(max_checkint, set_int)
@@ -1563,7 +1573,7 @@ init_keywords(vector keywords)
 {
 	install_keyword_root("defaults", NULL);
 	install_keyword("verbosity", &def_verbosity_handler, &snprint_def_verbosity);
-	install_keyword("polling_interval", &def_checkint_handler, &snprint_def_checkint);
+	install_keyword("polling_interval", &checkint_handler, &snprint_def_checkint);
 	install_keyword("max_polling_interval", &def_max_checkint_handler, &snprint_def_max_checkint);
 	install_keyword("reassign_maps", &def_reassign_maps_handler, &snprint_def_reassign_maps);
 	install_keyword("multipath_dir", &def_multipath_dir_handler, &snprint_def_multipath_dir);
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index caa178a6..fee899bd 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -100,6 +100,7 @@ alloc_path (void)
 		pp->fd = -1;
 		pp->tpgs = TPGS_UNDEF;
 		pp->priority = PRIO_UNDEF;
+		pp->checkint = CHECKINT_UNDEF;
 		checker_clear(&pp->checker);
 		dm_path_to_gen(pp)->ops = &dm_gen_path_ops;
 		pp->hwe = vector_alloc();
diff --git a/multipathd/main.c b/multipathd/main.c
index 3464ebfa..083abf28 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1840,6 +1840,12 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	max_checkint = conf->max_checkint;
 	verbosity = conf->verbosity;
 	put_multipath_config(conf);
+
+	if (pp->checkint == CHECKINT_UNDEF) {
+		condlog(0, "%s: BUG: checkint is not set", pp->dev);
+		pp->checkint = checkint;
+	};
+
 	if (!pp->mpp && pp->initialized == INIT_MISSING_UDEV) {
 		if (pp->retriggers < retrigger_tries) {
 			condlog(2, "%s: triggering change event to reinitialize",
-- 
2.19.1
