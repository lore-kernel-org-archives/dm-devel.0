From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 15/20] libmultipath: implement
	find_multipaths_timeout
Date: Mon, 19 Mar 2018 16:01:50 +0100
Message-ID: <20180319150155.5363-16-mwilck@suse.com>
References: <20180319150155.5363-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180319150155.5363-1-mwilck@suse.com>
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

This makes the timeout for "find_multipaths smart" configurable.
If the timeout has a negative value (default), it's applied only
to "known" hardware which is either in the hwtable or in a "device" section in
multipath.conf. For typical non-multipath hardware, which is not in the
hwtable, a short timeout of 1s is used, so that boot delays caused by
pointlessly waiting e.g. for SATA devices will be minimal.

It's expected that a "reasonable" timeout value depends less on the storage
hardware itself but on other properties of the data center such as network
latencies or distances. find_multipaths_timeout is therefore just a "defaults"
section setting.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.h      |  1 +
 libmultipath/defaults.h    |  2 ++
 libmultipath/dict.c        |  6 ++++++
 libmultipath/propsel.c     | 25 +++++++++++++++++++++++++
 libmultipath/propsel.h     |  1 +
 libmultipath/structs.h     |  1 +
 multipath/main.c           | 13 +++++++++++--
 multipath/multipath.conf.5 | 18 ++++++++++++++++++
 8 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index 21d8e72a2492..72d66018893b 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -174,6 +174,7 @@ struct config {
 	int remove_retries;
 	int max_sectors_kb;
 	int ghost_delay;
+	int find_multipaths_timeout;
 	unsigned int version[3];
 
 	char * multipath_dir;
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 690182c368d9..018eb01c1830 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -41,6 +41,8 @@
 #define DEFAULT_DISABLE_CHANGED_WWIDS 1
 #define DEFAULT_MAX_SECTORS_KB MAX_SECTORS_KB_UNDEF
 #define DEFAULT_GHOST_DELAY GHOST_DELAY_OFF
+#define DEFAULT_FIND_MULTIPATHS_TIMEOUT -10
+#define DEFAULT_UNKNOWN_FIND_MULTIPATHS_TIMEOUT 1
 
 #define DEFAULT_CHECKINT	5
 #define MAX_CHECKINT(a)		(a << 2)
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index a952c60a6f98..d59fdc85a9cb 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -484,6 +484,10 @@ declare_hw_snprint(max_sectors_kb, print_nonzero)
 declare_mp_handler(max_sectors_kb, set_int)
 declare_mp_snprint(max_sectors_kb, print_nonzero)
 
+declare_def_handler(find_multipaths_timeout, set_int)
+declare_def_snprint_defint(find_multipaths_timeout, print_int,
+			   DEFAULT_FIND_MULTIPATHS_TIMEOUT)
+
 static int
 def_config_dir_handler(struct config *conf, vector strvec)
 {
@@ -1518,6 +1522,8 @@ init_keywords(vector keywords)
 	install_keyword("remove_retries", &def_remove_retries_handler, &snprint_def_remove_retries);
 	install_keyword("max_sectors_kb", &def_max_sectors_kb_handler, &snprint_def_max_sectors_kb);
 	install_keyword("ghost_delay", &def_ghost_delay_handler, &snprint_def_ghost_delay);
+	install_keyword("find_multipaths_timeout", &def_find_multipaths_timeout_handler,
+			&snprint_def_find_multipaths_timeout);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 58a6a42fe333..87d6865d17e6 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -911,3 +911,28 @@ out:
 	condlog(3, "%s: ghost_delay = %s %s", mp->alias, buff, origin);
 	return 0;
 }
+
+int select_find_multipaths_timeout(struct config *conf, struct path *pp)
+{
+	char *origin;
+
+	pp_set_conf(find_multipaths_timeout);
+	pp_set_default(find_multipaths_timeout,
+		       DEFAULT_FIND_MULTIPATHS_TIMEOUT);
+out:
+	/*
+	 * If configured value is negative, and this "unkown" hardware
+	 * (no hwentry), use very small timeout to avoid delays.
+	 */
+	if (pp->find_multipaths_timeout < 0) {
+		pp->find_multipaths_timeout = - pp->find_multipaths_timeout;
+		if (!pp->hwe) {
+			pp->find_multipaths_timeout =
+				DEFAULT_UNKNOWN_FIND_MULTIPATHS_TIMEOUT;
+			origin = "(default for unkown hardware)";
+		}
+	}
+	condlog(3, "%s: timeout for find_multipaths \"smart\" = %ds %s",
+		pp->dev, pp->find_multipaths_timeout, origin);
+	return 0;
+}
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index 136f90605b91..b6475d0d9c71 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -8,6 +8,7 @@ int select_hwhandler (struct config *conf, struct multipath * mp);
 int select_checker(struct config *conf, struct path *pp);
 int select_getuid (struct config *conf, struct path * pp);
 int select_prio (struct config *conf, struct path * pp);
+int select_find_multipaths_timeout(struct config *conf, struct path * pp);
 int select_no_path_retry(struct config *conf, struct multipath *mp);
 int select_flush_on_last_del(struct config *conf, struct multipath *mp);
 int select_minio(struct config *conf, struct multipath *mp);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 32f4b2d0696c..d4e18df940ea 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -281,6 +281,7 @@ struct path {
 	int io_err_disable_reinstate;
 	int io_err_pathfail_cnt;
 	int io_err_pathfail_starttime;
+	int find_multipaths_timeout;
 	/* configlet pointers */
 	struct hwentry * hwe;
 	struct gen_path generic_path;
diff --git a/multipath/main.c b/multipath/main.c
index 9b53c13b3a78..b41621d267f7 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -60,6 +60,7 @@
 #include "uxsock.h"
 #include "mpath_cmd.h"
 #include "foreign.h"
+#include "propsel.h"
 
 int logsink;
 struct udev *udev;
@@ -350,7 +351,8 @@ out:
 	return r;
 }
 
-static int print_cmd_valid(int k)
+static int print_cmd_valid(int k, const vector pathvec,
+			   struct config *conf)
 {
 	int vals[] = { 1, 0, 2 };
 
@@ -358,6 +360,13 @@ static int print_cmd_valid(int k)
 		return 1;
 
 	printf("DM_MULTIPATH_DEVICE_PATH=\"%d\"\n", vals[k]);
+	if (vals[k] == 2 && VECTOR_SIZE(pathvec) > 0) {
+		struct path *pp = VECTOR_SLOT(pathvec, 0);
+
+		select_find_multipaths_timeout(conf, pp);
+		printf("FIND_MULTIPATHS_PATH_TMO=\"%d\"\n",
+		       pp->find_multipaths_timeout);
+	}
 	return k == 1;
 }
 
@@ -523,7 +532,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 
 print_valid:
 	if (cmd == CMD_VALID_PATH)
-		r = print_cmd_valid(r);
+		r = print_cmd_valid(r, pathvec, conf);
 
 out:
 	if (refwwid)
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 6965dacb5c68..94c419a078bf 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -983,6 +983,24 @@ The default is: \fBstrict\fR
 .
 .
 .TP
+.B find_multipaths_timeout
+Timeout, in seconds, to wait for additional paths after detecting the first
+one, if \fIfind_multipaths
+"smart"\fR (see above) is set. If the value is \fBpositive\fR, this timeout is used for all
+unkown, non-blacklisted devices encountered. If the value is \fBnegative\fR
+(recommended), it's only
+applied to "known" devices that have an entry in multipath's hardware table,
+either in the built-in table or in a \fIdevice\fR section; other ("unknown") devices will
+use a timeout of only 1 second to avoid booting delays. The value 0 means
+"use the built-in default". If \fIfind_multipath\fR has a value
+other than \fIsmart\fR, this option has no effect. 
+.RS
+.TP
+The default is: \fB-10\fR (10s for known and 1s for unknown hardware)
+.RE
+.
+.
+.TP
 .B uxsock_timeout
 CLI receive timeout in milliseconds. For larger systems CLI commands
 might timeout before the multipathd lock is released and the CLI command
-- 
2.16.1
