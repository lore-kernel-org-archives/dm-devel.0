From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 2/7] libmultipath: add detect_checker option
Date: Fri, 10 Feb 2017 23:28:47 -0600
Message-ID: <1486790932-30917-3-git-send-email-bmarzins@redhat.com>
References: <1486790932-30917-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1486790932-30917-1-git-send-email-bmarzins@redhat.com>
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
List-Id: dm-devel.ids

This patch adds a detect_checker option that works just like the
detect_prio option.  It currently only detects ALUA devices, and
if it finds ALUA support, it sets the priortizier to TUR. This is
useful for devices like the VNX2, where it should be using the
TUR checker when in ALUA mode (or so I have been told). It is set on by
default just like detect_prio and retain_attached_hw_handler.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c      |  3 +++
 libmultipath/config.h      |  2 ++
 libmultipath/defaults.h    |  1 +
 libmultipath/dict.c        | 10 ++++++++
 libmultipath/discovery.c   |  1 +
 libmultipath/hwtable.c     |  1 +
 libmultipath/propsel.c     | 59 ++++++++++++++++++++++++++++++++++++++--------
 libmultipath/propsel.h     |  1 +
 libmultipath/structs.h     |  7 ++++++
 multipath/multipath.conf.5 | 18 ++++++++++++++
 10 files changed, 93 insertions(+), 10 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 15ddbd8..68a1692 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -343,6 +343,7 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_num(user_friendly_names);
 	merge_num(retain_hwhandler);
 	merge_num(detect_prio);
+	merge_num(detect_checker);
 	merge_num(deferred_remove);
 	merge_num(delay_watch_checks);
 	merge_num(delay_wait_checks);
@@ -420,6 +421,7 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
 	hwe->user_friendly_names = dhwe->user_friendly_names;
 	hwe->retain_hwhandler = dhwe->retain_hwhandler;
 	hwe->detect_prio = dhwe->detect_prio;
+	hwe->detect_checker = dhwe->detect_checker;
 
 	if (dhwe->bl_product && !(hwe->bl_product = set_param_str(dhwe->bl_product)))
 		goto out;
@@ -607,6 +609,7 @@ load_config (char * file)
 	conf->fast_io_fail = DEFAULT_FAST_IO_FAIL;
 	conf->retain_hwhandler = DEFAULT_RETAIN_HWHANDLER;
 	conf->detect_prio = DEFAULT_DETECT_PRIO;
+	conf->detect_checker = DEFAULT_DETECT_CHECKER;
 	conf->force_sync = DEFAULT_FORCE_SYNC;
 	conf->partition_delim = DEFAULT_PARTITION_DELIM;
 	conf->processed_main_config = 0;
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 9670020..4a785ca 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -62,6 +62,7 @@ struct hwentry {
 	int user_friendly_names;
 	int retain_hwhandler;
 	int detect_prio;
+	int detect_checker;
 	int deferred_remove;
 	int delay_watch_checks;
 	int delay_wait_checks;
@@ -133,6 +134,7 @@ struct config {
 	int reassign_maps;
 	int retain_hwhandler;
 	int detect_prio;
+	int detect_checker;
 	int force_sync;
 	int deferred_remove;
 	int processed_main_config;
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index b9b0a37..1e5a527 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -22,6 +22,7 @@
 #define DEFAULT_DEV_LOSS_TMO	600
 #define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_ON
 #define DEFAULT_DETECT_PRIO	DETECT_PRIO_ON
+#define DEFAULT_DETECT_CHECKER	DETECT_CHECKER_ON
 #define DEFAULT_DEFERRED_REMOVE	DEFERRED_REMOVE_OFF
 #define DEFAULT_DELAY_CHECKS	DELAY_CHECKS_OFF
 #define DEFAULT_UEVENT_STACKSIZE 256
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index dc21846..53f78ea 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -379,6 +379,13 @@ declare_ovr_snprint(detect_prio, print_yes_no_undef)
 declare_hw_handler(detect_prio, set_yes_no_undef)
 declare_hw_snprint(detect_prio, print_yes_no_undef)
 
+declare_def_handler(detect_checker, set_yes_no_undef)
+declare_def_snprint_defint(detect_checker, print_yes_no_undef, YNU_NO)
+declare_ovr_handler(detect_checker, set_yes_no_undef)
+declare_ovr_snprint(detect_checker, print_yes_no_undef)
+declare_hw_handler(detect_checker, set_yes_no_undef)
+declare_hw_snprint(detect_checker, print_yes_no_undef)
+
 declare_def_handler(force_sync, set_yes_no)
 declare_def_snprint(force_sync, print_yes_no)
 
@@ -1397,6 +1404,7 @@ init_keywords(vector keywords)
 	install_keyword("reservation_key", &def_reservation_key_handler, &snprint_def_reservation_key);
 	install_keyword("retain_attached_hw_handler", &def_retain_hwhandler_handler, &snprint_def_retain_hwhandler);
 	install_keyword("detect_prio", &def_detect_prio_handler, &snprint_def_detect_prio);
+	install_keyword("detect_checker", &def_detect_checker_handler, &snprint_def_detect_checker);
 	install_keyword("force_sync", &def_force_sync_handler, &snprint_def_force_sync);
 	install_keyword("strict_timing", &def_strict_timing_handler, &snprint_def_strict_timing);
 	install_keyword("deferred_remove", &def_deferred_remove_handler, &snprint_def_deferred_remove);
@@ -1483,6 +1491,7 @@ init_keywords(vector keywords)
 	install_keyword("user_friendly_names", &hw_user_friendly_names_handler, &snprint_hw_user_friendly_names);
 	install_keyword("retain_attached_hw_handler", &hw_retain_hwhandler_handler, &snprint_hw_retain_hwhandler);
 	install_keyword("detect_prio", &hw_detect_prio_handler, &snprint_hw_detect_prio);
+	install_keyword("detect_checker", &hw_detect_checker_handler, &snprint_hw_detect_checker);
 	install_keyword("deferred_remove", &hw_deferred_remove_handler, &snprint_hw_deferred_remove);
 	install_keyword("delay_watch_checks", &hw_delay_watch_checks_handler, &snprint_hw_delay_watch_checks);
 	install_keyword("delay_wait_checks", &hw_delay_wait_checks_handler, &snprint_hw_delay_wait_checks);
@@ -1512,6 +1521,7 @@ init_keywords(vector keywords)
 	install_keyword("user_friendly_names", &ovr_user_friendly_names_handler, &snprint_ovr_user_friendly_names);
 	install_keyword("retain_attached_hw_handler", &ovr_retain_hwhandler_handler, &snprint_ovr_retain_hwhandler);
 	install_keyword("detect_prio", &ovr_detect_prio_handler, &snprint_ovr_detect_prio);
+	install_keyword("detect_checker", &ovr_detect_checker_handler, &snprint_ovr_detect_checker);
 	install_keyword("deferred_remove", &ovr_deferred_remove_handler, &snprint_ovr_deferred_remove);
 	install_keyword("delay_watch_checks", &ovr_delay_watch_checks_handler, &snprint_ovr_delay_watch_checks);
 	install_keyword("delay_wait_checks", &ovr_delay_wait_checks_handler, &snprint_ovr_delay_wait_checks);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index d1aec31..f38ae3c 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1489,6 +1489,7 @@ get_state (struct path * pp, struct config *conf, int daemon)
 				return PATH_UNCHECKED;
 			}
 		}
+		select_detect_checker(conf, pp);
 		select_checker(conf, pp);
 		if (!checker_selected(c)) {
 			condlog(3, "%s: No checker selected", pp->dev);
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index f5a5f7b..6e7c453 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1112,6 +1112,7 @@ static struct hwentry default_hw[] = {
 		.dev_loss      = 600,
 		.retain_hwhandler = RETAIN_HWHANDLER_ON,
 		.detect_prio   = DETECT_PRIO_ON,
+		.detect_checker = DETECT_CHECKER_ON,
 		.deferred_remove = DEFERRED_REMOVE_OFF,
 		.delay_watch_checks = DELAY_CHECKS_OFF,
 		.delay_wait_checks = DELAY_CHECKS_OFF,
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index c0bc616..546f735 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -307,11 +307,44 @@ out:
 	return 0;
 }
 
+int
+detect_alua(struct config *conf, struct path * pp)
+{
+	int ret;
+	int tpgs = 0;
+	unsigned int timeout = conf->checker_timeout;
+
+	if ((tpgs = get_target_port_group_support(pp->fd, timeout)) <= 0)
+		return 0;
+	pp->tpgs = tpgs;
+	ret = get_target_port_group(pp, timeout);
+	if (ret < 0)
+		return 0;
+	if (get_asymmetric_access_state(pp->fd, ret, timeout) < 0)
+		return 0;
+	return 1;
+}
+
+char *
+detect_checker(struct config *conf, struct path *pp)
+{
+	if (detect_alua(conf, pp))
+		return TUR;
+	return NULL;
+}
+
 int select_checker(struct config *conf, struct path *pp)
 {
 	char *origin, *checker_name;
 	struct checker * c = &pp->checker;
 
+	if (pp->detect_checker == DETECT_CHECKER_ON) {
+		checker_name = detect_checker(conf, pp);
+		if (checker_name) {
+			origin = "(setting: array autodetected)";
+			goto out;
+		}
+	}
 	do_set(checker_name, conf->overrides, checker_name, "(setting: multipath.conf overrides section)");
 	do_set(checker_name, pp->hwe, checker_name, "(setting: array configuration)");
 	do_set(checker_name, conf, checker_name, "(setting: multipath.conf defaults/devices section)");
@@ -359,20 +392,11 @@ out:
 void
 detect_prio(struct config *conf, struct path * pp)
 {
-	int ret;
 	struct prio *p = &pp->prio;
-	int tpgs = 0;
-	unsigned int timeout = conf->checker_timeout;
 	char buff[512];
 	char *default_prio = PRIO_ALUA;
 
-	if ((tpgs = get_target_port_group_support(pp->fd, timeout)) <= 0)
-		return;
-	pp->tpgs = tpgs;
-	ret = get_target_port_group(pp, timeout);
-	if (ret < 0)
-		return;
-	if (get_asymmetric_access_state(pp->fd, ret, timeout) < 0)
+	if (!detect_alua(conf, pp))
 		return;
 	if (sysfs_get_asymmetric_access_state(pp, buff, 512) >= 0)
 		default_prio = PRIO_SYSFS;
@@ -588,6 +612,21 @@ out:
 	return 0;
 }
 
+int select_detect_checker(struct config *conf, struct path *pp)
+{
+	char *origin;
+
+	pp_set_ovr(detect_checker);
+	pp_set_hwe(detect_checker);
+	pp_set_conf(detect_checker);
+	pp_set_default(detect_checker, DEFAULT_DETECT_CHECKER);
+out:
+	condlog(3, "%s: detect_checker = %s %s", pp->dev,
+		(pp->detect_checker == DETECT_CHECKER_ON)? "yes" : "no",
+		origin);
+	return 0;
+}
+
 int select_deferred_remove(struct config *conf, struct multipath *mp)
 {
 	char *origin;
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index ad98fa5..8bf3c6a 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -19,6 +19,7 @@ int select_dev_loss(struct config *conf, struct multipath *mp);
 int select_reservation_key(struct config *conf, struct multipath *mp);
 int select_retain_hwhandler (struct config *conf, struct multipath * mp);
 int select_detect_prio(struct config *conf, struct path * pp);
+int select_detect_checker(struct config *conf, struct path * pp);
 int select_deferred_remove(struct config *conf, struct multipath *mp);
 int select_delay_watch_checks (struct config *conf, struct multipath * mp);
 int select_delay_wait_checks (struct config *conf, struct multipath * mp);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 396f69d..99d5184 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -121,6 +121,12 @@ enum detect_prio_states {
 	DETECT_PRIO_ON = YNU_YES,
 };
 
+enum detect_checker_states {
+	DETECT_CHECKER_UNDEF = YNU_UNDEF,
+	DETECT_CHECKER_OFF = YNU_NO,
+	DETECT_CHECKER_ON = YNU_YES,
+};
+
 enum deferred_remove_states {
 	DEFERRED_REMOVE_UNDEF = YNU_UNDEF,
 	DEFERRED_REMOVE_OFF = YNU_NO,
@@ -210,6 +216,7 @@ struct path {
 	int priority;
 	int pgindex;
 	int detect_prio;
+	int detect_checker;
 	int watch_checks;
 	int wait_checks;
 	int tpgs;
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 36589f5..2eef4b0 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -683,6 +683,20 @@ The default is: \fByes\fR
 .
 .
 .TP
+.B detect_checker
+if set to
+.I yes
+, multipath will try to detect if the device supports SCSI-3 ALUA. If so, the
+device will automatically use the \fItur\fR checker. If set to
+.I no
+, the checker will be selected as usual.
+.RS
+.TP
+The default is: \fByes\fR
+.RE
+.
+.
+.TP
 .B force_sync
 If set to
 .I yes
@@ -1126,6 +1140,8 @@ section:
 .TP
 .B detect_prio
 .TP
+.B detect_checker
+.TP
 .B deferred_remove
 .TP
 .B delay_watch_checks
@@ -1190,6 +1206,8 @@ the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
 .TP
 .B detect_prio
 .TP
+.B detect_checker
+.TP
 .B deferred_remove
 .TP
 .B delay_watch_checks
-- 
1.8.3.1
