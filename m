From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: add option to change the number of
	error	messages
Date: Mon, 19 Dec 2011 13:42:51 -0600
Message-ID: <20111219194251.GN24133@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

This patch adds a new default config parameter, log_checker_err.  It accepts
two values, "once" and "always", and defaults of "always".  It controls
how multipathd logs checker error messages.  If it's set to "once", only the
first checker error message is logged at logging level 2. All future messages
are logged at level 3, until the device is restored or removed. If it's set
to "always", all messages are logged at level 2, like multipathd currently does.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.h      |    1 +
 libmultipath/dict.c        |   28 ++++++++++++++++++++++++++++
 libmultipath/structs.h     |    5 +++++
 multipath/multipath.conf.5 |   10 ++++++++++
 multipathd/main.c          |    8 ++++++--
 5 files changed, 50 insertions(+), 2 deletions(-)

Index: multipath-tools-111111/libmultipath/config.h
===================================================================
--- multipath-tools-111111.orig/libmultipath/config.h
+++ multipath-tools-111111/libmultipath/config.h
@@ -37,6 +37,7 @@ struct hwentry {
 	int flush_on_last_del;
 	int fast_io_fail;
 	unsigned int dev_loss;
+	int log_checker_err;
 	char * bl_product;
 };
 
Index: multipath-tools-111111/libmultipath/dict.c
===================================================================
--- multipath-tools-111111.orig/libmultipath/dict.c
+++ multipath-tools-111111/libmultipath/dict.c
@@ -525,6 +525,25 @@ def_flush_on_last_del_handler(vector str
 }
 
 static int
+def_log_checker_err_handler(vector strvec)
+{
+	char * buff;
+
+	buff = set_value(strvec);
+
+	if (!buff)
+		return 1;
+
+	if (strlen(buff) == 4 && !strcmp(buff, "once"))
+		conf->log_checker_err = LOG_CHKR_ERR_ONCE;
+	else if (strlen(buff) == 6 && !strcmp(buff, "always"))
+		conf->log_checker_err = LOG_CHKR_ERR_ALWAYS;
+
+	free(buff);
+	return 0;
+}
+
+static int
 names_handler(vector strvec)
 {
 	char * buff;
@@ -2338,6 +2357,14 @@ snprint_def_flush_on_last_del (char * bu
 }
 
 static int
+snprint_def_log_checker_err (char * buff, int len, void * data)
+{
+	if (conf->log_checker_err == LOG_CHKR_ERR_ONCE)
+		return snprintf(buff, len, "once");
+	return snprintf(buff, len, "always");
+}
+
+static int
 snprint_def_user_friendly_names (char * buff, int len, void * data)
 {
 	if (!conf->user_friendly_names)
@@ -2428,6 +2455,7 @@ init_keywords(void)
 	install_keyword("fast_io_fail_tmo", &def_fast_io_fail_handler, &snprint_def_fast_io_fail);
 	install_keyword("dev_loss_tmo", &def_dev_loss_handler, &snprint_def_dev_loss);
 	install_keyword("bindings_file", &bindings_file_handler, &snprint_def_bindings_file);
+	install_keyword("log_checker_err", &def_log_checker_err_handler, &snprint_def_log_checker_err);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_getuid_callout", &def_getuid_callout_handler, NULL);
Index: multipath-tools-111111/libmultipath/structs.h
===================================================================
--- multipath-tools-111111.orig/libmultipath/structs.h
+++ multipath-tools-111111/libmultipath/structs.h
@@ -87,6 +87,11 @@ enum flush_states {
 	FLUSH_IN_PROGRESS,
 };
 
+enum log_checker_err_states {
+	LOG_CHKR_ERR_ALWAYS,
+	LOG_CHKR_ERR_ONCE,
+};
+
 struct scsi_idlun {
 	int dev_id;
 	int host_unique_id;
Index: multipath-tools-111111/multipathd/main.c
===================================================================
--- multipath-tools-111111.orig/multipathd/main.c
+++ multipath-tools-111111/multipathd/main.c
@@ -1193,8 +1193,12 @@ check_path (struct vectors * vecs, struc
 				pp->dev_t, pp->tick);
 		}
 	}
-	else if (newstate == PATH_DOWN)
-		LOG_MSG(2, checker_message(&pp->checker));
+	else if (newstate == PATH_DOWN) {
+		if (conf->log_checker_err == LOG_CHKR_ERR_ONCE)
+			LOG_MSG(3, checker_message(&pp->checker));
+		else
+			LOG_MSG(2, checker_message(&pp->checker));
+	}
 
 	pp->state = newstate;
 
Index: multipath-tools-111111/multipath/multipath.conf.5
===================================================================
--- multipath-tools-111111.orig/multipath/multipath.conf.5
+++ multipath-tools-111111/multipath/multipath.conf.5
@@ -316,9 +316,19 @@ cannot be told to stop queueing IO. Sett
 .I no
 , avoids this problem. Default is
 .I yes
+.TP
 .B bindings_file
 The full pathname of the binding file to be used when the user_friendly_names option is set. Defaults to
 .I /var/lib/multipath/bindings
+.TP
+.B log_checker_err
+If set to
+.I once
+, multipathd logs the first path checker error at logging level 2. Any later
+errors are logged at level 3 until the device is restored. If set to
+.I always
+, multipathd always logs the path checker error at logging level 2. Default is
+.I always
 .
 .SH "blacklist section"
 The
