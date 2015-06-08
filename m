From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 3/4] libmultipath: add ignore_new_boot_devs option
Date: Mon,  8 Jun 2015 13:16:44 -0500
Message-ID: <1433787405-24716-4-git-send-email-bmarzins@redhat.com>
References: <1433787405-24716-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1433787405-24716-1-git-send-email-bmarzins@redhat.com>
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

When multipath relies on the wwids file to determine whether a device is
a multipath path (with "multipath -c"), it will fail the first time a
new multipathable device is discovered, since the wwid clearly won't be
in the wwids file.  This is usually fine.  Multipath will still set
itself up on the device, and add the wwid to the wwids file. However,
this causes a race, where multipath won't claim the path immediately,
and something else may.  Later multipath will try, and possibly succeed
at, setting itself up on that device.

I've seen cases where this can cause problems during boot on and
immediately after install, where multipath racing with LVM on an already
labelled device can get the machine into a state where boot fails. This
can be avoided if multipath simply doesn't set itself up on any devices
that it didn't claim (with "multipath -c") in the initramfs.  It can
still safely attempt to set itself up on these devices later in boot,
after the regular filesystem has been set up.

To allow this, this patch adds a new option, ignore_new_boot_devs.  When
enabled, this patch simply keeps multipath from being set up on devices
that aren't already in the wwids file (along with all the other checks
that multipath already does). This means that only devices that are
claimed by "multipath -c" will be used by multipath.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c    |  1 +
 libmultipath/config.h    |  1 +
 libmultipath/configure.c |  3 +--
 libmultipath/dict.c      |  4 ++++
 libmultipath/wwids.c     | 21 ++++++++++++++-------
 multipathd/main.c        |  3 +--
 6 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 746459c..773a17a 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -623,6 +623,7 @@ load_config (char * file, struct udev *udev)
 	conf->retrigger_tries = DEFAULT_RETRIGGER_TRIES;
 	conf->retrigger_delay = DEFAULT_RETRIGGER_DELAY;
 	conf->new_bindings_in_boot = 0;
+	conf->ignore_new_boot_devs = 0;
 
 	/*
 	 * preload default hwtable
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 05f1f6d..65a5978 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -138,6 +138,7 @@ struct config {
 	int retrigger_tries;
 	int retrigger_delay;
 	int new_bindings_in_boot;
+	int ignore_new_boot_devs;
 	unsigned int version[3];
 
 	char * dev;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 3c9badd..1ab3324 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -778,8 +778,7 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 			continue;
 
 		/* If find_multipaths was selected check if the path is valid */
-		if (conf->find_multipaths && !refwwid &&
-		    !should_multipath(pp1, pathvec)) {
+		if (!refwwid && !should_multipath(pp1, pathvec)) {
 			orphan_path(pp1, "only one path");
 			continue;
 		}
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 1fabc54..e3a33c6 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -399,6 +399,9 @@ declare_def_snprint(retrigger_delay, print_int)
 declare_def_handler(new_bindings_in_boot, set_yes_no)
 declare_def_snprint(new_bindings_in_boot, print_yes_no)
 
+declare_def_handler(ignore_new_boot_devs, set_yes_no)
+declare_def_snprint(ignore_new_boot_devs, print_yes_no)
+
 static int
 def_config_dir_handler(vector strvec)
 {
@@ -1375,6 +1378,7 @@ init_keywords(void)
 	install_keyword("retrigger_tries", &def_retrigger_tries_handler, &snprint_def_retrigger_tries);
 	install_keyword("retrigger_delay", &def_retrigger_delay_handler, &snprint_def_retrigger_delay);
 	install_keyword("new_bindings_in_boot", &def_new_bindings_in_boot_handler, &snprint_def_new_bindings_in_boot);
+	install_keyword("ignore_new_boot_devs", &def_ignore_new_boot_devs_handler, &snprint_def_ignore_new_boot_devs);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index f6f8ea8..d862d9f 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -15,6 +15,7 @@
 #include "wwids.h"
 #include "defaults.h"
 #include "config.h"
+#include "util.h"
 
 /*
  * Copyright (c) 2010 Benjamin Marzinski, Redhat
@@ -265,15 +266,21 @@ should_multipath(struct path *pp1, vector pathvec)
 {
 	int i;
 	struct path *pp2;
+	int ignore_new_devs = (conf->ignore_new_boot_devs && in_initrd());
+
+	if (!conf->find_multipaths && !ignore_new_devs)
+		return 1;
 
 	condlog(4, "checking if %s should be multipathed", pp1->dev);
-	vector_foreach_slot(pathvec, pp2, i) {
-		if (pp1->dev == pp2->dev)
-			continue;
-		if (strncmp(pp1->wwid, pp2->wwid, WWID_SIZE) == 0) {
-			condlog(3, "found multiple paths with wwid %s, "
-				"multipathing %s", pp1->wwid, pp1->dev);
-			return 1;
+	if (!ignore_new_devs) {
+		vector_foreach_slot(pathvec, pp2, i) {
+			if (pp1->dev == pp2->dev)
+				continue;
+			if (strncmp(pp1->wwid, pp2->wwid, WWID_SIZE) == 0) {
+				condlog(3, "found multiple paths with wwid %s, "
+					"multipathing %s", pp1->wwid, pp1->dev);
+				return 1;
+			}
 		}
 	}
 	if (check_wwids_file(pp1->wwid, 0) < 0) {
diff --git a/multipathd/main.c b/multipathd/main.c
index 09defc9..6c315ad 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -517,8 +517,7 @@ rescan:
 		mpp->flush_on_last_del = FLUSH_UNDEF;
 		mpp->action = ACT_RELOAD;
 	} else {
-		if (conf->find_multipaths &&
-		    !should_multipath(pp, vecs->pathvec)) {
+		if (!should_multipath(pp, vecs->pathvec)) {
 			orphan_path(pp, "only one path");
 			return 0;
 		}
-- 
1.8.3.1
