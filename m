From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH] libmultipath: allow distributions to change
	partition_delim default
Date: Mon, 25 Jun 2018 21:47:23 +0200
Message-ID: <20180625194723.23791-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

partition_delimiter is UNSET by default, falling back to the kernel
default behavior to use "p" for devices ending in a digit, and ""
for others. However, the udev rules for kpartx have always used the
delimiter "-part". If a map name is changed (e.g. if an alias is
reconfigured), multipathd first sets partition names e.g. to name "mpatha1",
which is later changed to "mpatha-part1" by kpartx during udev rule
processing. That's inefficient and superfluous. However, if a distribution
simply changed DEFAULT_PARTITION_DELIM to "-part", users wouldn't be able
to restore the default behavior any more.

This patch allows to set 'partition_delimiter "/UNSET/"' in multipath.conf
to force the previous default behavior, even if the distribution default is
something other than UNSET. The string "/UNSET/" is not a valid partition
delimiter because filenames can't contain slashes, thus user freedom isn't
constrained by this patch.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c      |  3 ++-
 libmultipath/defaults.c    |  2 ++
 libmultipath/defaults.h    |  2 ++
 libmultipath/dict.c        | 24 ++++++++++++++++++++++--
 multipath/multipath.conf.5 | 16 ++++++++++++----
 5 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index fc0ec8d3..afa309da 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -704,7 +704,8 @@ load_config (char * file)
 	conf->checkint = DEFAULT_CHECKINT;
 	conf->max_checkint = 0;
 	conf->force_sync = DEFAULT_FORCE_SYNC;
-	conf->partition_delim = DEFAULT_PARTITION_DELIM;
+	conf->partition_delim = (default_partition_delim != NULL ?
+				 strdup(default_partition_delim) : NULL);
 	conf->processed_main_config = 0;
 	conf->find_multipaths = DEFAULT_FIND_MULTIPATHS;
 	conf->uxsock_timeout = DEFAULT_REPLY_TIMEOUT;
diff --git a/libmultipath/defaults.c b/libmultipath/defaults.c
index 7130e56f..c20bb0d2 100644
--- a/libmultipath/defaults.c
+++ b/libmultipath/defaults.c
@@ -6,6 +6,8 @@
 #include "defaults.h"
 #include "memory.h"
 
+const char * const default_partition_delim = DEFAULT_PARTITION_DELIM;
+
 char *
 set_default (char * str)
 {
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index f076b4b0..7f3839fc 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -36,6 +36,7 @@
 #define DEFAULT_FLUSH		FLUSH_DISABLED
 #define DEFAULT_USER_FRIENDLY_NAMES USER_FRIENDLY_NAMES_OFF
 #define DEFAULT_FORCE_SYNC	0
+#define UNSET_PARTITION_DELIM "/UNSET/"
 #define DEFAULT_PARTITION_DELIM	NULL
 #define DEFAULT_SKIP_KPARTX SKIP_KPARTX_OFF
 #define DEFAULT_DISABLE_CHANGED_WWIDS 1
@@ -59,3 +60,4 @@
 #define MULTIPATH_SHM_BASE	"/dev/shm/multipath/"
 
 char * set_default (char * str);
+extern const char *const default_partition_delim;
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index fc107e9b..d0188806 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -275,8 +275,28 @@ declare_def_snprint(reassign_maps, print_yes_no)
 declare_def_handler(multipath_dir, set_str)
 declare_def_snprint(multipath_dir, print_str)
 
-declare_def_handler(partition_delim, set_str)
-declare_def_snprint(partition_delim, print_str)
+static int def_partition_delim_handler(struct config *conf, vector strvec)
+{
+	int rc = set_str(strvec, &conf->partition_delim);
+
+	if (rc != 0)
+		return rc;
+
+	if (!strcmp(conf->partition_delim, UNSET_PARTITION_DELIM)) {
+		FREE(conf->partition_delim);
+		conf->partition_delim = NULL;
+	}
+	return 0;
+}
+
+static int snprint_def_partition_delim(struct config *conf, char *buff,
+				       int len, const void *data)
+{
+	if (default_partition_delim == NULL || conf->partition_delim != NULL)
+		return print_str(buff, len, conf->partition_delim);
+	else
+		return print_str(buff, len, UNSET_PARTITION_DELIM);
+}
 
 static const char * const find_multipaths_optvals[] = {
 	[FIND_MULTIPATHS_OFF] = "off",
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 109c3dc0..e4b25a05 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -858,10 +858,18 @@ The default is: \fBno\fR
 .
 .TP
 .B partition_delimiter
-If this value is not set, when multipath renames a device, it will act just
-like the kpartx default does, only adding a \fI"p"\fR to names ending in a
-number. If this parameter is set, multipath will act like kpartx does with
-the \fI-p\fR option is used, and always add delimiter.
+This parameter controls how multipath chooses the names of partition devices
+of multipath maps if a multipath map is renamed (e.g. if a map alias is added
+or changed). If this parameter is set to a string other than "/UNSET/" (even
+the empty string), multipath inserts that string between device name and
+partition number to construct the partition device name.
+Otherwise (i.e. if this parameter is unset or has the value "/UNSET/"),
+the behavior depends on the map name: if it ends in a digit, a \fI"p"\fR is
+inserted between name and partition number; otherwise, the partition number is
+simply appended.
+Distributions may use a non-null default value for this option; in this case,
+the user must set it to "/UNSET/" to obtain the original \fB<unset>\fR
+behavior. Use \fImultipath -T\fR to check the current settings.
 .RS
 .TP
 The default is: \fB<unset>\fR
-- 
2.17.1
