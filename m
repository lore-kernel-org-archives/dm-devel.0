From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 01/15] correctly set partition delimiter on rename
Date: Sat,  7 Mar 2015 21:31:32 -0600
Message-ID: <1425785506-20419-2-git-send-email-bmarzins@redhat.com>
References: <1425785506-20419-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1425785506-20419-1-git-send-email-bmarzins@redhat.com>
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

When multipath renames a device and the name switches from ending in a
number to ending in a letter or vice versa, it currently just keeps any
existing delimiter between the device name and partition number.
However the default behaviour in kpartx is to only use the 'p' delimiter
when the name ends in a number. Unfortunately, without adding a
kpartx.conf that kpartx uses to set the delimiter behavior, there's no
way for multipath to know how kpartx was run for certain device names
(ones ending in a number with a 'p' delimiter).

The patch adds a new multipath.conf defaults parameter,
"partition_delimiter". If this value is not set, when multipath renames
a device, it will act just like the kpartx default does, only adding a
'p' to names ending in a number.  If this parameter is set, multipath
will act like kpartx does with the -p option is used, and always add
delimiter.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c    |  3 +++
 libmultipath/config.h    |  1 +
 libmultipath/devmapper.c | 14 ++++++++++++--
 libmultipath/dict.c      |  4 ++++
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 7f7bd5a..cbc8e4b 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -502,6 +502,8 @@ free_config (struct config * conf)
 
 	if (conf->alias_prefix)
 		FREE(conf->alias_prefix);
+	if (conf->partition_delim)
+		FREE(conf->partition_delim);
 
 	if (conf->prio_args)
 		FREE(conf->prio_args);
@@ -563,6 +565,7 @@ load_config (char * file, struct udev *udev)
 	conf->retain_hwhandler = DEFAULT_RETAIN_HWHANDLER;
 	conf->detect_prio = DEFAULT_DETECT_PRIO;
 	conf->force_sync = 0;
+	conf->partition_delim = NULL;
 
 	/*
 	 * preload default hwtable
diff --git a/libmultipath/config.h b/libmultipath/config.h
index ef1d7c3..b942a27 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -140,6 +140,7 @@ struct config {
 	char * prio_args;
 	char * checker_name;
 	char * alias_prefix;
+	char * partition_delim;
 	unsigned char * reservation_key;
 
 	vector keywords;
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 3d4c111..9e585f9 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1142,6 +1142,8 @@ dm_rename_partmaps (char * old, char * new)
 	unsigned long long size;
 	char dev_t[32];
 	int r = 1;
+	int offset;
+	char *delim;
 
 	if (!(dmt = dm_task_create(DM_DEVICE_LIST)))
 		return 1;
@@ -1162,6 +1164,13 @@ dm_rename_partmaps (char * old, char * new)
 	if (dm_dev_t(old, &dev_t[0], 32))
 		goto out;
 
+	if (conf->partition_delim)
+		delim = conf->partition_delim;
+	if (isdigit(new[strlen(new)-1]))
+		delim = "p";
+	else
+		delim = "";
+
 	do {
 		if (
 		    /*
@@ -1189,8 +1198,9 @@ dm_rename_partmaps (char * old, char * new)
 				 * then it's a kpartx generated partition.
 				 * Rename it.
 				 */
-				snprintf(buff, PARAMS_SIZE, "%s%s",
-					 new, names->name + strlen(old));
+				for (offset = strlen(old); names->name[offset] && !(isdigit(names->name[offset])); offset++); /* do nothing */
+				snprintf(buff, PARAMS_SIZE, "%s%s%s",
+					 new, delim, names->name + offset);
 				dm_rename(names->name, buff);
 				condlog(4, "partition map %s renamed",
 					names->name);
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 737c9b0..ab313f3 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -230,6 +230,9 @@ declare_def_snprint(reassign_maps, print_yes_no)
 declare_def_handler(multipath_dir, set_str)
 declare_def_snprint(multipath_dir, print_str)
 
+declare_def_handler(partition_delim, set_str)
+declare_def_snprint(partition_delim, print_str)
+
 declare_def_handler(selector, set_str)
 declare_def_snprint_defstr(selector, print_str, DEFAULT_SELECTOR)
 declare_hw_handler(selector, set_str)
@@ -1242,6 +1245,7 @@ init_keywords(void)
 	install_keyword("retain_attached_hw_handler", &def_retain_hwhandler_handler, &snprint_def_retain_hwhandler);
 	install_keyword("detect_prio", &def_detect_prio_handler, &snprint_def_detect_prio);
 	install_keyword("force_sync", &def_force_sync_handler, &snprint_def_force_sync);
+	install_keyword("partition_delimiter", &def_partition_delim_handler, &snprint_def_partition_delim);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
-- 
1.8.3.1
