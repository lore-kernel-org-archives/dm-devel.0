From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 12/12] Add multipath.conf force_sync option
Date: Mon, 30 Jun 2014 00:14:03 -0500
Message-ID: <1404105243-5071-13-git-send-email-bmarzins@redhat.com>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
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

Normally multipathd runs the path checkers asynchronously. However if there
are a lot of paths, this can cause large CPU spikes (for instance, in
cases where they are all competing for the Big Kernel Lock). In these
situations, overall machine performance is better if multipath doesn't have
hundreds or even thousands of path checkers running at the same time. This
patch lets users turn off the asynchronous mode of these checks if they
see this problem.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c      |  1 +
 libmultipath/config.h      |  1 +
 libmultipath/dict.c        | 33 +++++++++++++++++++++++++++++++++
 libmultipath/discovery.c   |  8 ++++++--
 multipath.conf.annotated   | 11 +++++++++++
 multipath/multipath.conf.5 |  9 +++++++++
 6 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index e13c307..39963b4 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -561,6 +561,7 @@ load_config (char * file, struct udev *udev)
 	conf->fast_io_fail = DEFAULT_FAST_IO_FAIL;
 	conf->retain_hwhandler = DEFAULT_RETAIN_HWHANDLER;
 	conf->detect_prio = DEFAULT_DETECT_PRIO;
+	conf->force_sync = 0;
 
 	/*
 	 * preload default hwtable
diff --git a/libmultipath/config.h b/libmultipath/config.h
index ac7c58e..1a23e4b 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -124,6 +124,7 @@ struct config {
 	int reassign_maps;
 	int retain_hwhandler;
 	int detect_prio;
+	int force_sync;
 	unsigned int version[3];
 
 	char * dev;
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 91d9b83..7de7a67 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -685,6 +685,29 @@ def_detect_prio_handler(vector strvec)
 	return 0;
 }
 
+static int
+def_force_sync_handler(vector strvec)
+{
+	char * buff;
+
+	buff = set_value(strvec);
+
+	if (!buff)
+		return 1;
+
+	if ((strlen(buff) == 2 && !strcmp(buff, "no")) ||
+	    (strlen(buff) == 1 && !strcmp(buff, "0")))
+		conf->force_sync = 0;
+	else if ((strlen(buff) == 3 && !strcmp(buff, "yes")) ||
+		 (strlen(buff) == 1 && !strcmp(buff, "1")))
+		conf->force_sync = 1;
+	else
+		conf->force_sync = 0;
+
+	FREE(buff);
+	return 0;
+}
+
 /*
  * blacklist block handlers
  */
@@ -2783,6 +2806,15 @@ snprint_def_detect_prio(char * buff, int len, void * data)
 }
 
 static int
+snprint_def_force_sync(char * buff, int len, void * data)
+{
+	if (conf->force_sync)
+		return snprintf(buff, len, "yes");
+	else
+		return snprintf(buff, len, "no");
+}
+
+static int
 snprint_ble_simple (char * buff, int len, void * data)
 {
 	struct blentry * ble = (struct blentry *)data;
@@ -2849,6 +2881,7 @@ init_keywords(void)
 	install_keyword("reservation_key", &def_reservation_key_handler, &snprint_def_reservation_key);
 	install_keyword("retain_attached_hw_handler", &def_retain_hwhandler_handler, &snprint_def_retain_hwhandler_handler);
 	install_keyword("detect_prio", &def_detect_prio_handler, &snprint_def_detect_prio);
+	install_keyword("force_sync", &def_force_sync_handler, &snprint_def_force_sync);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index b62a59c..a5f5a20 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1053,8 +1053,12 @@ get_state (struct path * pp, int daemon)
 		}
 	}
 	checker_clear_message(c);
-	if (daemon)
-		checker_set_async(c);
+	if (daemon) {
+		if (conf->force_sync == 0)
+			checker_set_async(c);
+		else
+			checker_set_sync(c);
+	}
 	if (!conf->checker_timeout &&
 	    sysfs_get_timeout(pp, &(c->timeout)) <= 0)
 		c->timeout = DEF_TIMEOUT;
diff --git a/multipath.conf.annotated b/multipath.conf.annotated
index f158746..0af1d4c 100644
--- a/multipath.conf.annotated
+++ b/multipath.conf.annotated
@@ -270,6 +270,7 @@
 #	# default : determined by the OS
 #	dev_loss_tmo 600
 #
+#	#
 #	# name    : bindings_file
 #	# scope   : multipath
 #	# desc    : The location of the bindings file that is used with
@@ -278,6 +279,7 @@
 #	# default : "/var/lib/multipath/bindings"
 #	bindings_file "/etc/multipath/bindings"
 #
+#	#
 #	# name    : wwids_file
 #	# scope   : multipath
 #	# desc    : The location of the wwids file multipath uses to
@@ -286,6 +288,7 @@
 #	# default : "/var/lib/multipath/wwids"
 #	wwids_file "/etc/multipath/wwids"
 #
+#	#
 #	# name    : reservation_key
 #	# scope   : multipath
 #	# desc    : Service action reservation key used by mpathpersist.
@@ -293,6 +296,14 @@
 #	# default : (null)
 #	reservation_key "mpathkey"
 #
+#	#
+#	# name    : force_sync
+#	# scope   : multipathd
+#	# desc    : If set to yes, multipath will run all of the checkers in
+#	#           sync mode, even if the checker has an async mode.
+#	# values  : yes|no
+#	# default : no
+#	force_sync yes
 #}
 #	
 ##
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 195e663..cadb34d 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -409,6 +409,15 @@ will automatically use the
 .I alua
 prioritizer. If not, the prioritizer will be selected as usual. Default is
 .I no
+.TP
+.B force_sync
+If set to
+.I yes
+, multipathd will call the path checkers in sync mode only.  This means that
+only one checker will run at a time.  This is useful in the case where many
+multipathd checkers running in parallel causes significant CPU pressure. The
+Default is
+.I no
 .
 .SH "blacklist section"
 The
-- 
1.8.3.1
