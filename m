From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [LVM PATCH 2/4] cache:  New 'cachepool' segment type
Date: Thu, 23 Jan 2014 09:05:46 -0600
Message-ID: <1390489548-18076-3-git-send-email-jbrassow@redhat.com>
References: <1390489548-18076-1-git-send-email-jbrassow@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1390489548-18076-1-git-send-email-jbrassow@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: agk@redhat.com, zkabelac@redhat.com
List-Id: dm-devel.ids

This patch adds the new cachepool segment type - the first of two
necessary to eventually create 'cache' logical volumes.  In addition
to the new segment type, updates to makefiles, configure files, the
lv_segment struct, and some necessary libdevmapper flags.

The cachepool is the LV and corresponding segment type that will hold
all information pertinent to the cache itself - it's size, cachemode,
cache policy, core arguments (like migration_threshold), etc.
---
 configure                        |   32 +++++++++++++++++++++++++++++++-
 configure.in                     |   22 ++++++++++++++++++++++
 lib/Makefile.in                  |   11 ++++++++++-
 lib/commands/toolcontext.c       |    9 +++++++--
 lib/metadata/metadata-exported.h |    7 +++++++
 lib/metadata/segtype.h           |   10 ++++++++++
 lib/misc/configure.h.in          |    3 +++
 libdm/libdevmapper.h             |    4 ++++
 8 files changed, 94 insertions(+), 4 deletions(-)

diff --git a/configure b/configure
index a156460..20d99dd 100755
--- a/configure
+++ b/configure
@@ -606,6 +606,7 @@ kernelvsn
 missingkernel
 kerneldir
 interface
+CACHE
 CMIRRORD_PIDFILE
 CLVMD_PIDFILE
 LVMETAD_PIDFILE
@@ -839,6 +840,7 @@ with_thin
 with_thin_check
 with_thin_dump
 with_thin_repair
+with_cache
 enable_readline
 enable_realtime
 enable_ocf
@@ -1615,6 +1617,7 @@ Optional Packages:
   --with-mirrors=TYPE     mirror support: internal/shared/none
                           [[TYPE=internal]]
   --with-raid=TYPE        raid support: internal/shared/none [[TYPE=internal]]
+  --with-cache=TYPE       cache support: internal/shared/none [[TYPE=internal]]
   --with-replicators=TYPE replicator support: internal/shared/none
                           [[TYPE=none]]
   --with-thin=TYPE        thin provisioning support: internal/shared/none
@@ -7117,6 +7120,31 @@ $as_echo "#define RAID_INTERNAL 1" >>confdefs.h
 fi
 
 ################################################################################
+{ $as_echo "$as_me:${as_lineno-$LINENO}: checking whether to include cache" >&5
+$as_echo_n "checking whether to include cache... " >&6; }
+
+# Check whether --with-cache was given.
+if test "${with_cache+set}" = set; then :
+  withval=$with_cache; CACHE=$withval
+else
+  CACHE=internal
+fi
+
+{ $as_echo "$as_me:${as_lineno-$LINENO}: result: $CACHE" >&5
+$as_echo "$CACHE" >&6; }
+
+if [ "x$CACHE" != xnone -a "x$CACHE" != xinternal -a "x$CACHE" != xshared ];
+ then  as_fn_error $? "--with-cache parameter invalid
+" "$LINENO" 5
+fi;
+
+if test x$CACHE = xinternal; then
+
+$as_echo "#define CACHE_INTERNAL 1" >>confdefs.h
+
+fi
+
+################################################################################
 { $as_echo "$as_me:${as_lineno-$LINENO}: checking whether to include replicators" >&5
 $as_echo_n "checking whether to include replicators... " >&6; }
 
@@ -10150,6 +10178,7 @@ fi
 if [ \( "x$LVM1" = xshared -o "x$POOL" = xshared -o "x$CLUSTER" = xshared \
       -o "x$SNAPSHOTS" = xshared -o "x$MIRRORS" = xshared \
       -o "x$RAID" = xshared \
+      -o "x$CACHE" = xshared \
       \) -a "x$STATIC_LINK" = xyes ];
  then  as_fn_error $? "Features cannot be 'shared' when building statically
 " "$LINENO" 5
@@ -11424,7 +11453,7 @@ LVM_LIBAPI=`echo "$VER" | $AWK -F '[()]' '{print $2}'`
 
 
 ################################################################################
-ac_config_files="$ac_config_files Makefile make.tmpl daemons/Makefile daemons/clvmd/Makefile daemons/cmirrord/Makefile daemons/dmeventd/Makefile daemons/dmeventd/libdevmapper-event.pc daemons/dmeventd/plugins/Makefile daemons/dmeventd/plugins/lvm2/Makefile daemons/dmeventd/plugins/raid/Makefile daemons/dmeventd/plugins/mirror/Makefile daemons/dmeventd/plugins/snapshot/Makefile daemons/dmeventd/plugins/thin/Makefile daemons/lvmetad/Makefile conf/Makefile conf/example.conf conf/default.profile include/.symlinks include/Makefile lib/Makefile lib/format1/Makefile lib/format_pool/Makefile lib/locking/Makefile lib/mirror/Makefile lib/replicator/Makefile lib/misc/lvm-version.h lib/raid/Makefile lib/snapshot/Makefile lib/thin/Makefile libdaemon/Makefile libdaemon/client/Makefile libdaemon/server/
 Makefile libdm/Makefile libdm/libdevmapper.pc liblvm/Makefile liblvm/liblvm2app.pc man/Makefile po/Makefile python/Makefile python/setup.py scripts/blkdeactivate.sh scripts/blk_availability!
 _init_red_hat scripts/blk_availability_systemd_red_hat.service scripts/clvmd_init_red_hat scripts/cmirrord_init_red_hat scripts/lvm2_lvmetad_init_red_hat scripts/lvm2_lvmetad_systemd_red_hat.socket scripts/lvm2_lvmetad_systemd_red_hat.service scripts/lvm2_pvscan_systemd_red_hat@.service scripts/lvm2_monitoring_init_red_hat scripts/dm_event_systemd_red_hat.socket scripts/dm_event_systemd_red_hat.service scripts/lvm2_monitoring_systemd_red_hat.service scripts/lvm2_tmpfiles_red_hat.conf scripts/Makefile test/Makefile test/api/Makefile test/unit/Makefile tools/Makefile udev/Makefile unit-tests/datastruct/Makefile unit-tests/regex/Makefile unit-tests/mm/Makefile"
+ac_config_files="$ac_config_files Makefile make.tmpl daemons/Makefile daemons/clvmd/Makefile daemons/cmirrord/Makefile daemons/dmeventd/Makefile daemons/dmeventd/libdevmapper-event.pc daemons/dmeventd/plugins/Makefile daemons/dmeventd/plugins/lvm2/Makefile daemons/dmeventd/plugins/raid/Makefile daemons/dmeventd/plugins/mirror/Makefile daemons/dmeventd/plugins/snapshot/Makefile daemons/dmeventd/plugins/thin/Makefile daemons/lvmetad/Makefile conf/Makefile conf/example.conf conf/default.profile include/.symlinks include/Makefile lib/Makefile lib/format1/Makefile lib/format_pool/Makefile lib/locking/Makefile lib/mirror/Makefile lib/replicator/Makefile lib/misc/lvm-version.h lib/raid/Makefile lib/cache_segtype/Makefile lib/snapshot/Makefile lib/thin/Makefile libdaemon/Makefile libdaemon/client
 /Makefile libdaemon/server/Makefile libdm/Makefile libdm/libdevmapper.pc liblvm/Makefile liblvm/liblvm2app.pc man/Makefile po/Makefile python/Makefile python/setup.py scripts/blkdeactivate.!
 sh scripts/blk_availability_init_red_hat scripts/blk_availability_systemd_red_hat.service scripts/clvmd_init_red_hat scripts/cmirrord_init_red_hat scripts/lvm2_lvmetad_init_red_hat scripts/lvm2_lvmetad_systemd_red_hat.socket scripts/lvm2_lvmetad_systemd_red_hat.service scripts/lvm2_pvscan_systemd_red_hat@.service scripts/lvm2_monitoring_init_red_hat scripts/dm_event_systemd_red_hat.socket scripts/dm_event_systemd_red_hat.service scripts/lvm2_monitoring_systemd_red_hat.service scripts/lvm2_tmpfiles_red_hat.conf scripts/Makefile test/Makefile test/api/Makefile test/unit/Makefile tools/Makefile udev/Makefile unit-tests/datastruct/Makefile unit-tests/regex/Makefile unit-tests/mm/Makefile"
 
 cat >confcache <<\_ACEOF
 # This file is a shell script that caches the results of configure
@@ -12140,6 +12169,7 @@ do
     "lib/replicator/Makefile") CONFIG_FILES="$CONFIG_FILES lib/replicator/Makefile" ;;
     "lib/misc/lvm-version.h") CONFIG_FILES="$CONFIG_FILES lib/misc/lvm-version.h" ;;
     "lib/raid/Makefile") CONFIG_FILES="$CONFIG_FILES lib/raid/Makefile" ;;
+    "lib/cache_segtype/Makefile") CONFIG_FILES="$CONFIG_FILES lib/cache_segtype/Makefile" ;;
     "lib/snapshot/Makefile") CONFIG_FILES="$CONFIG_FILES lib/snapshot/Makefile" ;;
     "lib/thin/Makefile") CONFIG_FILES="$CONFIG_FILES lib/thin/Makefile" ;;
     "libdaemon/Makefile") CONFIG_FILES="$CONFIG_FILES libdaemon/Makefile" ;;
diff --git a/configure.in b/configure.in
index 3e0e508..7b56b13 100644
--- a/configure.in
+++ b/configure.in
@@ -476,6 +476,25 @@ AC_DEFINE_UNQUOTED([THIN_DUMP_CMD], ["$THIN_DUMP_CMD"],
 AC_DEFINE_UNQUOTED([THIN_REPAIR_CMD], ["$THIN_REPAIR_CMD"],
 		   [The path to 'thin_repair', if available.])
 
+################################################################################
+dnl -- cache inclusion type
+AC_MSG_CHECKING(whether to include cache)
+AC_ARG_WITH(cache,
+	    AC_HELP_STRING([--with-cache=TYPE],
+			   [cache support: internal/shared/none
+			    [[TYPE=internal]]]),
+	    CACHE=$withval, CACHE=internal)
+AC_MSG_RESULT($CACHE)
+
+if [[ "x$CACHE" != xnone -a "x$CACHE" != xinternal -a "x$CACHE" != xshared ]];
+ then  AC_MSG_ERROR(
+--with-cache parameter invalid
+)
+fi;
+
+if test x$CACHE = xinternal; then
+	AC_DEFINE([CACHE_INTERNAL], 1, [Define to 1 to include built-in support for cache.])
+fi
 
 ################################################################################
 dnl -- Disable readline
@@ -1241,6 +1260,7 @@ dnl -- Check for shared/static conflicts
 if [[ \( "x$LVM1" = xshared -o "x$POOL" = xshared -o "x$CLUSTER" = xshared \
       -o "x$SNAPSHOTS" = xshared -o "x$MIRRORS" = xshared \
       -o "x$RAID" = xshared \
+      -o "x$CACHE" = xshared \
       \) -a "x$STATIC_LINK" = xyes ]];
  then  AC_MSG_ERROR(
 Features cannot be 'shared' when building statically
@@ -1596,6 +1616,7 @@ AC_SUBST(BLKID_WIPING)
 AC_SUBST(BUILD_CMIRRORD)
 AC_SUBST(BUILD_DMEVENTD)
 AC_SUBST(BUILD_LVMETAD)
+AC_SUBST(CACHE)
 AC_SUBST(CFLAGS)
 AC_SUBST(CFLOW_CMD)
 AC_SUBST(CLDFLAGS)
@@ -1752,6 +1773,7 @@ lib/misc/lvm-version.h
 lib/raid/Makefile
 lib/snapshot/Makefile
 lib/thin/Makefile
+lib/cache_segtype/Makefile
 libdaemon/Makefile
 libdaemon/client/Makefile
 libdaemon/server/Makefile
diff --git a/lib/Makefile.in b/lib/Makefile.in
index c3ace5f..3808269 100644
--- a/lib/Makefile.in
+++ b/lib/Makefile.in
@@ -1,6 +1,6 @@
 #
 # Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
-# Copyright (C) 2004-2013 Red Hat, Inc. All rights reserved.
+# Copyright (C) 2004-2014 Red Hat, Inc. All rights reserved.
 #
 # This file is part of LVM2.
 #
@@ -44,6 +44,10 @@ ifeq ("@THIN@", "shared")
   SUBDIRS += thin
 endif
 
+ifeq ("@CACHE@", "shared")
+  SUBDIRS += cache_segtype
+endif
+
 SOURCES =\
 	activate/activate.c \
 	cache/lvmcache.c \
@@ -165,6 +169,10 @@ ifeq ("@THIN@", "internal")
   SOURCES += thin/thin.c
 endif
 
+ifeq ("@CACHE@", "internal")
+  SOURCES += cache_segtype/cache.c
+endif
+
 ifeq ("@DEVMAPPER@", "yes")
   SOURCES +=\
 	activate/dev_manager.c \
@@ -199,6 +207,7 @@ ifeq ($(MAKECMDGOALS),distclean)
 	raid \
 	replicator \
 	thin \
+	cache_segtype \
 	locking
 endif
 
diff --git a/lib/commands/toolcontext.c b/lib/commands/toolcontext.c
index 9d6ef5e..a709284 100644
--- a/lib/commands/toolcontext.c
+++ b/lib/commands/toolcontext.c
@@ -1,6 +1,6 @@
-		/*
+/*
  * Copyright (C) 2001-2004 Sistina Software, Inc. All rights reserved.
- * Copyright (C) 2004-2012 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004-2014 Red Hat, Inc. All rights reserved.
  *
  * This file is part of LVM2.
  *
@@ -1181,6 +1181,11 @@ static int _init_segtypes(struct cmd_context *cmd)
 		return 0;
 #endif
 
+#ifdef CACHE_INTERNAL
+	if (!init_cache_segtypes(cmd, &seglib))
+		return 0;
+#endif
+
 #ifdef HAVE_LIBDL
 	/* Load any formats in shared libs unless static */
 	if (!is_static() &&
diff --git a/lib/metadata/metadata-exported.h b/lib/metadata/metadata-exported.h
index 6e7987d..f2a08c6 100644
--- a/lib/metadata/metadata-exported.h
+++ b/lib/metadata/metadata-exported.h
@@ -384,6 +384,13 @@ struct lv_segment {
 	struct logical_volume *pool_lv;		/* For thin */
 	uint32_t device_id;			/* For thin, 24bit */
 
+	uint32_t feature_flags;			/* For cache */
+	int core_argc;				/* For cache */
+	char **core_argv;			/* For cache */
+	char *policy_name;			/* For cache */
+	int policy_argc;			/* For cache */
+	char **policy_argv;			/* For cache */
+
 	struct logical_volume *replicator;/* For replicator-devs - link to replicator LV */
 	struct logical_volume *rlog_lv;	/* For replicators */
 	const char *rlog_type;		/* For replicators */
diff --git a/lib/metadata/segtype.h b/lib/metadata/segtype.h
index 2c02d1b..b5ce503 100644
--- a/lib/metadata/segtype.h
+++ b/lib/metadata/segtype.h
@@ -41,8 +41,12 @@ struct dev_manager;
 #define SEG_RAID		0x00000400U
 #define SEG_THIN_POOL		0x00000800U
 #define SEG_THIN_VOLUME		0x00001000U
+#define SEG_CACHE		0x00002000U
+#define SEG_CACHEPOOL		0x00004000U
 #define SEG_UNKNOWN		0x80000000U
 
+#define segtype_is_cache(segtype)	((segtype)->flags & SEG_CACHE ? 1 : 0)
+#define segtype_is_cachepool(segtype)	((segtype)->flags & SEG_CACHEPOOL ? 1 : 0)
 #define segtype_is_mirrored(segtype)	((segtype)->flags & SEG_AREAS_MIRRORED ? 1 : 0)
 #define segtype_is_raid(segtype)	((segtype)->flags & SEG_RAID ? 1 : 0)
 #define segtype_is_striped(segtype)	((segtype)->flags & SEG_AREAS_STRIPED ? 1 : 0)
@@ -51,6 +55,8 @@ struct dev_manager;
 #define segtype_is_thin_volume(segtype)	((segtype)->flags & SEG_THIN_VOLUME ? 1 : 0)
 #define segtype_is_virtual(segtype)	((segtype)->flags & SEG_VIRTUAL ? 1 : 0)
 
+#define seg_is_cache(seg)	segtype_is_cache((seg)->segtype)
+#define seg_is_cachepool(seg)	segtype_is_cachepool((seg)->segtype)
 #define seg_is_linear(seg)	(seg_is_striped(seg) && ((seg)->area_count == 1))
 #define seg_is_mirrored(seg)	segtype_is_mirrored((seg)->segtype)
 #define seg_is_raid(seg)	segtype_is_raid((seg)->segtype)
@@ -147,6 +153,10 @@ int init_replicator_segtype(struct cmd_context *cmd, struct segtype_library *seg
 int init_thin_segtypes(struct cmd_context *cmd, struct segtype_library *seglib);
 #endif
 
+#ifdef CACHE_INTERNAL
+int init_cache_segtypes(struct cmd_context *cmd, struct segtype_library *seglib);
+#endif
+
 #ifdef SNAPSHOT_INTERNAL
 struct segment_type *init_snapshot_segtype(struct cmd_context *cmd);
 #endif
diff --git a/lib/misc/configure.h.in b/lib/misc/configure.h.in
index 4e9ffd1..0acb9b7 100644
--- a/lib/misc/configure.h.in
+++ b/lib/misc/configure.h.in
@@ -558,6 +558,9 @@
 /* The path to 'thin_repair', if available. */
 #undef THIN_REPAIR_CMD
 
+/* Define to 1 to include built-in support for cache[pool] segment types. */
+#undef CACHE_INTERNAL
+
 /* Define to 1 if you can safely include both <sys/time.h> and <time.h>. */
 #undef TIME_WITH_SYS_TIME
 
diff --git a/libdm/libdevmapper.h b/libdm/libdevmapper.h
index 3bf8bd6..3074500 100644
--- a/libdm/libdevmapper.h
+++ b/libdm/libdevmapper.h
@@ -712,6 +712,10 @@ int dm_tree_node_add_raid_target_with_params(struct dm_tree_node *node,
 					     uint64_t size,
 					     struct dm_tree_node_raid_params *p);
 
+/* Cache feature_flags */
+#define DM_CACHE_FEATURE_WRITEBACK    0x00000001
+#define DM_CACHE_FEATURE_WRITETHROUGH 0x00000002
+
 /*
  * Replicator operation mode
  * Note: API for Replicator is not yet stable
-- 
1.7.7.6
