From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: add detect_prio option to autodetect
	prioitizer
Date: Mon, 7 Jan 2013 23:42:20 -0600
Message-ID: <20130108054220.GY19059@ether.msp.redhat.com>
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

This patch adds a new multipath.conf option, detect_prio.  If set to yes,
multipathd will try to determine the correct prioritizer for the device. If
it finds one, that will be used instead of its configured prioritizer.  If
none is found, the configured prioritizer will be used.  It can currently
only detect ALUA devices.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/Makefile    |    2 -
 libmultipath/config.c    |    3 +
 libmultipath/config.h    |    2 +
 libmultipath/defaults.h  |    1 
 libmultipath/dict.c      |   74 +++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/discovery.c |    1 
 libmultipath/propsel.c   |   41 ++++++++++++++++++++++++++
 libmultipath/propsel.h   |    1 
 libmultipath/structs.h   |    7 ++++
 9 files changed, 131 insertions(+), 1 deletion(-)

Index: multipath-tools-120821/libmultipath/config.c
===================================================================
--- multipath-tools-120821.orig/libmultipath/config.c
+++ multipath-tools-120821/libmultipath/config.c
@@ -330,6 +330,7 @@ merge_hwe (struct hwentry * dst, struct
 	merge_num(dev_loss);
 	merge_num(user_friendly_names);
 	merge_num(retain_hwhandler);
+	merge_num(detect_prio);
 
 	return 0;
 }
@@ -390,6 +391,7 @@ store_hwe (vector hwtable, struct hwentr
 	hwe->dev_loss = dhwe->dev_loss;
 	hwe->user_friendly_names = dhwe->user_friendly_names;
 	hwe->retain_hwhandler = dhwe->retain_hwhandler;
+	hwe->detect_prio = dhwe->detect_prio;
 
 	if (dhwe->bl_product && !(hwe->bl_product = set_param_str(dhwe->bl_product)))
 		goto out;
@@ -530,6 +532,7 @@ load_config (char * file)
 	conf->max_checkint = MAX_CHECKINT(conf->checkint);
 	conf->fast_io_fail = 5;
 	conf->retain_hwhandler = DEFAULT_RETAIN_HWHANDLER;
+	conf->detect_prio = DEFAULT_DETECT_PRIO;
 
 	/*
 	 * preload default hwtable
Index: multipath-tools-120821/libmultipath/config.h
===================================================================
--- multipath-tools-120821.orig/libmultipath/config.h
+++ multipath-tools-120821/libmultipath/config.h
@@ -46,6 +46,7 @@ struct hwentry {
 	unsigned int dev_loss;
 	int user_friendly_names;
 	int retain_hwhandler;
+	int detect_prio;
 	char * bl_product;
 };
 
@@ -109,6 +110,7 @@ struct config {
 	uint32_t cookie;
 	int reassign_maps;
 	int retain_hwhandler;
+	int detect_prio;
 	unsigned int version[3];
 
 	char * dev;
Index: multipath-tools-120821/libmultipath/defaults.h
===================================================================
--- multipath-tools-120821.orig/libmultipath/defaults.h
+++ multipath-tools-120821/libmultipath/defaults.h
@@ -16,6 +16,7 @@
 #define DEFAULT_VERBOSITY	2
 #define DEFAULT_REASSIGN_MAPS	1
 #define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_OFF
+#define DEFAULT_DETECT_PRIO DETECT_PRIO_OFF
 
 #define DEFAULT_CHECKINT	5
 #define MAX_CHECKINT(a)		(a << 2)
Index: multipath-tools-120821/libmultipath/dict.c
===================================================================
--- multipath-tools-120821.orig/libmultipath/dict.c
+++ multipath-tools-120821/libmultipath/dict.c
@@ -652,6 +652,29 @@ def_retain_hwhandler_handler(vector strv
 	return 0;
 }
 
+static int
+def_detect_prio_handler(vector strvec)
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
+		conf->detect_prio = DETECT_PRIO_OFF;
+	else if ((strlen(buff) == 3 && !strcmp(buff, "yes")) ||
+		 (strlen(buff) == 1 && !strcmp(buff, "1")))
+		conf->detect_prio = DETECT_PRIO_ON;
+	else
+		conf->detect_prio = DETECT_PRIO_UNDEF;
+
+	FREE(buff);
+	return 0;
+}
+
 /*
  * blacklist block handlers
  */
@@ -1300,6 +1323,33 @@ hw_retain_hwhandler_handler(vector strve
 	return 0;
 }
 
+static int
+hw_detect_prio_handler(vector strvec)
+{
+	struct hwentry *hwe = VECTOR_LAST_SLOT(conf->hwtable);
+	char * buff;
+
+	if (!hwe)
+		return 1;
+
+	buff = set_value(strvec);
+
+	if (!buff)
+		return 1;
+
+	if ((strlen(buff) == 2 && !strcmp(buff, "no")) ||
+	    (strlen(buff) == 1 && !strcmp(buff, "0")))
+		hwe->detect_prio = DETECT_PRIO_OFF;
+	else if ((strlen(buff) == 3 && !strcmp(buff, "yes")) ||
+		 (strlen(buff) == 1 && !strcmp(buff, "1")))
+		hwe->detect_prio = DETECT_PRIO_ON;
+	else
+		hwe->detect_prio = DETECT_PRIO_UNDEF;
+
+	FREE(buff);
+	return 0;
+}
+
 /*
  * multipaths block handlers
  */
@@ -2337,6 +2387,19 @@ snprint_hw_retain_hwhandler_handler(char
 }
 
 static int
+snprint_detect_prio(char * buff, int len, void * data)
+{
+	struct hwentry * hwe = (struct hwentry *)data;
+
+	if (hwe->detect_prio == DETECT_PRIO_ON)
+		return snprintf(buff, len, "yes");
+	else if (hwe->detect_prio == DETECT_PRIO_OFF)
+		return snprintf(buff, len, "no");
+	else
+		return 0;
+}
+
+static int
 snprint_def_polling_interval (char * buff, int len, void * data)
 {
 	return snprintf(buff, len, "%i", conf->checkint);
@@ -2671,6 +2734,15 @@ snprint_def_retain_hwhandler_handler(cha
 }
 
 static int
+snprint_def_detect_prio(char * buff, int len, void * data)
+{
+	if (conf->detect_prio == DETECT_PRIO_ON)
+		return snprintf(buff, len, "yes");
+	else
+		return snprintf(buff, len, "no");
+}
+
+static int
 snprint_ble_simple (char * buff, int len, void * data)
 {
 	struct blentry * ble = (struct blentry *)data;
@@ -2735,6 +2807,7 @@ init_keywords(void)
 	install_keyword("log_checker_err", &def_log_checker_err_handler, &snprint_def_log_checker_err);
 	install_keyword("reservation_key", &def_reservation_key_handler, &snprint_def_reservation_key);
 	install_keyword("retain_attached_hw_handler", &def_retain_hwhandler_handler, &snprint_def_retain_hwhandler_handler);
+	install_keyword("detect_prio", &def_detect_prio_handler, &snprint_def_detect_prio);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
@@ -2797,6 +2870,7 @@ init_keywords(void)
 	install_keyword("dev_loss_tmo", &hw_dev_loss_handler, &snprint_hw_dev_loss);
 	install_keyword("user_friendly_names", &hw_names_handler, &snprint_hw_user_friendly_names);
 	install_keyword("retain_attached_hw_handler", &hw_retain_hwhandler_handler, &snprint_hw_retain_hwhandler_handler);
+	install_keyword("detect_prio", &hw_detect_prio_handler, &snprint_detect_prio);
 	install_sublevel_end();
 
 	install_keyword_root("multipaths", &multipaths_handler);
Index: multipath-tools-120821/libmultipath/structs.h
===================================================================
--- multipath-tools-120821.orig/libmultipath/structs.h
+++ multipath-tools-120821/libmultipath/structs.h
@@ -105,6 +105,12 @@ enum retain_hwhandler_states {
 	RETAIN_HWHANDLER_ON,
 };
 
+enum detect_prio_states {
+	DETECT_PRIO_UNDEF,
+	DETECT_PRIO_OFF,
+	DETECT_PRIO_ON,
+};
+
 struct scsi_idlun {
 	int dev_id;
 	int host_unique_id;
@@ -162,6 +168,7 @@ struct path {
 	int failcount;
 	int priority;
 	int pgindex;
+	int detect_prio;
 	char * uid_attribute;
 	struct prio * prio;
 	struct checker checker;
Index: multipath-tools-120821/libmultipath/propsel.c
===================================================================
--- multipath-tools-120821.orig/libmultipath/propsel.c
+++ multipath-tools-120821/libmultipath/propsel.c
@@ -17,6 +17,7 @@
 #include "devmapper.h"
 #include "prio.h"
 #include "discovery.h"
+#include "prioritizers/alua_rtpg.h"
 #include <inttypes.h>
 
 pgpolicyfn *pgpolicies[] = {
@@ -379,11 +380,33 @@ select_getuid (struct path * pp)
 	return 0;
 }
 
+struct prio *
+detect_prio(struct path * pp)
+{
+	struct prio *prio;
+
+	if (get_target_port_group_support(pp->fd) > 0) {
+		prio = prio_lookup(PRIO_ALUA);
+		prio_set_args(prio, DEFAULT_PRIO_ARGS);
+		return prio;
+	}
+	return NULL;
+}
+
 extern int
 select_prio (struct path * pp)
 {
 	struct mpentry * mpe;
 
+	if (pp->detect_prio == DETECT_PRIO_ON) {
+		pp->prio = detect_prio(pp);
+		if (pp->prio) {
+			condlog(3, "%s: prio = %s (detected setting)",
+				pp->dev, pp->prio->name);
+			return 0;
+		}
+	}
+
 	if ((mpe = find_mpe(pp->wwid))) {
 		if (mpe->prio_name) {
 			pp->prio = prio_lookup(mpe->prio_name);
@@ -701,3 +724,21 @@ select_retain_hwhandler (struct multipat
 	condlog(3, "%s: retain_attached_hw_handler = %d (compiled in default)", mp->alias, mp->retain_hwhandler);
 	return 0;
 }
+
+extern int
+select_detect_prio (struct path * pp)
+{
+	if (pp->hwe && pp->hwe->detect_prio) {
+		pp->detect_prio = pp->hwe->detect_prio;
+		condlog(3, "%s: detect_prio = %d (controller default)", pp->dev, pp->detect_prio);
+		return 0;
+	}
+	if (conf->detect_prio) {
+		pp->detect_prio = conf->detect_prio;
+		condlog(3, "%s: detect_prio = %d (config file default)", pp->dev, pp->detect_prio);
+		return 0;
+	}
+	pp->detect_prio = 0;
+	condlog(3, "%s: detect_prio = %d (compiled in default)", pp->dev, pp->detect_prio);
+	return 0;
+}
Index: multipath-tools-120821/libmultipath/Makefile
===================================================================
--- multipath-tools-120821.orig/libmultipath/Makefile
+++ multipath-tools-120821/libmultipath/Makefile
@@ -15,7 +15,7 @@ OBJS = memory.o parser.o vector.o devmap
        pgpolicies.o debug.o regex.o defaults.o uevent.o \
        switchgroup.o uxsock.o print.o alias.o log_pthread.o \
        log.o configure.o structs_vec.o sysfs.o prio.o checkers.o \
-       lock.o waiter.o file.o wwids.o
+       lock.o waiter.o file.o wwids.o prioritizers/alua_rtpg.o
 
 LIBDM_API_FLUSH = $(shell grep -Ecs '^[a-z]*[[:space:]]+dm_task_no_flush' /usr/include/libdevmapper.h)
 
Index: multipath-tools-120821/libmultipath/discovery.c
===================================================================
--- multipath-tools-120821.orig/libmultipath/discovery.c
+++ multipath-tools-120821/libmultipath/discovery.c
@@ -778,6 +778,7 @@ get_prio (struct path * pp)
 		return 0;
 
 	if (!pp->prio) {
+		select_detect_prio(pp);
 		select_prio(pp);
 		if (!pp->prio) {
 			condlog(3, "%s: no prio selected", pp->dev);
Index: multipath-tools-120821/libmultipath/propsel.h
===================================================================
--- multipath-tools-120821.orig/libmultipath/propsel.h
+++ multipath-tools-120821/libmultipath/propsel.h
@@ -19,3 +19,4 @@ int select_fast_io_fail(struct multipath
 int select_dev_loss(struct multipath *mp);
 int select_reservation_key(struct multipath *mp);
 int select_retain_hwhandler (struct multipath * mp);
+int select_detect_prio(struct path * pp);
