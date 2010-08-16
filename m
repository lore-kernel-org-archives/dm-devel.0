From: Malahal Naineni <malahal@us.ibm.com>
Subject: [PATCH] [PATCH] option to multipath to not modify the
	bindinfs file
Date: Mon, 16 Aug 2010 15:57:02 -0700
Message-ID: <e2c6d0d327f64431e5b0.1281999422@malahal>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com, christophe.varoqui@gmail.com
List-Id: dm-devel.ids

initramfs is mounted read-write causing multipath to update the
initramfs bindings file and name all multipath devices it finds using
friendly names. The actual changes to the file are thrown away as they
are only written to the memory image rather than to the disk image. This
may cause the in memory updated initramfs bindings file inconsistent
with the actual bindings file in the active root file system image when
devices are added or removed.

In other words, the boot time updated initramfs bindings file may have
'uuid1 map to mpatha' and 'uuid2 map to mpathb', but the active root fs
bindings file may have 'uuid1 map to mpathb' and 'uuid2 map to mpatha'

The option, -B, will not modify the bindings file. It will only use the
bindings file if needed.  This option to multipath should be used when
invoked in the initramfs context to avoid the inconsistency.

Signed-off-by: Malahal Naineni (malahal@us.ibm.com)

diff -r b359f4953289 -r e2c6d0d327f6 libmultipath/alias.c
--- a/libmultipath/alias.c	Sun Aug 15 10:48:09 2010 -0700
+++ b/libmultipath/alias.c	Mon Aug 16 13:02:41 2010 -0700
@@ -353,7 +353,8 @@ allocate_binding(int fd, char *wwid, int
 }
 
 char *
-get_user_friendly_alias(char *wwid, char *file, char *prefix)
+get_user_friendly_alias(char *wwid, char *file, char *prefix,
+			int bindings_read_only)
 {
 	char *alias;
 	int fd, scan_fd, id;
@@ -394,7 +395,7 @@ get_user_friendly_alias(char *wwid, char
 		return NULL;
 	}
 
-	if (!alias && can_write)
+	if (!alias && can_write && !bindings_read_only)
 		alias = allocate_binding(fd, wwid, id, prefix);
 
 	fclose(f);
diff -r b359f4953289 -r e2c6d0d327f6 libmultipath/alias.h
--- a/libmultipath/alias.h	Sun Aug 15 10:48:09 2010 -0700
+++ b/libmultipath/alias.h	Mon Aug 16 13:02:41 2010 -0700
@@ -8,5 +8,6 @@
 "# alias wwid\n" \
 "#\n"
 
-char *get_user_friendly_alias(char *wwid, char *file, char *prefix);
+char *get_user_friendly_alias(char *wwid, char *file, char *prefix,
+			      int bindings_readonly);
 char *get_user_friendly_wwid(char *alias, char *file);
diff -r b359f4953289 -r e2c6d0d327f6 libmultipath/config.c
--- a/libmultipath/config.c	Sun Aug 15 10:48:09 2010 -0700
+++ b/libmultipath/config.c	Mon Aug 16 13:02:41 2010 -0700
@@ -458,6 +458,7 @@ load_config (char * file)
 	conf->minio = 1000;
 	conf->max_fds = 0;
 	conf->bindings_file = DEFAULT_BINDINGS_FILE;
+	conf->bindings_read_only = 0;
 	conf->multipath_dir = set_default(DEFAULT_MULTIPATHDIR);
 	conf->flush_on_last_del = 0;
 	conf->attribute_flags = 0;
diff -r b359f4953289 -r e2c6d0d327f6 libmultipath/config.h
--- a/libmultipath/config.h	Sun Aug 15 10:48:09 2010 -0700
+++ b/libmultipath/config.h	Mon Aug 16 13:02:41 2010 -0700
@@ -74,6 +74,7 @@ struct config {
 	int rr_weight;
 	int no_path_retry;
 	int user_friendly_names;
+	int bindings_read_only;
 	int pg_timeout;
 	int max_fds;
 	int force_reload;
diff -r b359f4953289 -r e2c6d0d327f6 libmultipath/propsel.c
--- a/libmultipath/propsel.c	Sun Aug 15 10:48:09 2010 -0700
+++ b/libmultipath/propsel.c	Mon Aug 16 13:02:41 2010 -0700
@@ -245,7 +245,7 @@ select_alias (struct multipath * mp)
 		if (conf->user_friendly_names) {
 			select_alias_prefix(mp);
 			mp->alias = get_user_friendly_alias(mp->wwid,
-					conf->bindings_file, mp->alias_prefix);
+					conf->bindings_file, mp->alias_prefix, conf->bindings_read_only);
 		}
 		if (mp->alias == NULL)
 			mp->alias = dm_get_name(mp->wwid);
diff -r b359f4953289 -r e2c6d0d327f6 multipath/main.c
--- a/multipath/main.c	Sun Aug 15 10:48:09 2010 -0700
+++ b/multipath/main.c	Mon Aug 16 13:02:41 2010 -0700
@@ -350,7 +350,7 @@ main (int argc, char *argv[])
 		condlog(0, "multipath tools need sysfs mounted");
 		exit(1);
 	}
-	while ((arg = getopt(argc, argv, ":dhl::FfM:v:p:b:r")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":dhl::FfM:v:p:b:Br")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
 			break;
@@ -364,6 +364,9 @@ main (int argc, char *argv[])
 		case 'b':
 			conf->bindings_file = optarg;
 			break;
+		case 'B':
+			conf->bindings_read_only = 1;
+			break;
 		case 'd':
 			conf->dry_run = 1;
 			break;
diff -r b359f4953289 -r e2c6d0d327f6 multipath/multipath.8
--- a/multipath/multipath.8	Sun Aug 15 10:48:09 2010 -0700
+++ b/multipath/multipath.8	Mon Aug 16 13:02:41 2010 -0700
@@ -6,7 +6,7 @@ multipath \- Device mapper target autoco
 .RB [\| \-v\ \c
 .IR verbosity \|]
 .RB [\| \-d \|]
-.RB [\| \-h | \-l | \-ll | \-f | \-F \|]
+.RB [\| \-h | \-l | \-ll | \-f | \-F | \-B \|]
 .RB [\| \-p\ \c
 .BR failover | multibus | group_by_serial | group_by_prio | group_by_node_name \|]
 .RB [\| device \|]
@@ -47,6 +47,9 @@ flush a multipath device map specified a
 .B \-F
 flush all unused multipath device maps
 .TP
+.B \-B
+treat the bindings file as read only
+.TP
 .BI \-p " policy"
 force maps to specified policy:
 .RS 1.2i
