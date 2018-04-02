From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 07/20] libmultipath: change find_multipaths
	option to multi-value
Date: Mon,  2 Apr 2018 21:50:38 +0200
Message-ID: <20180402195051.26854-8-mwilck@suse.com>
References: <20180402195051.26854-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180402195051.26854-1-mwilck@suse.com>
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
Cc: Julian Andres Klode <julian.klode@canonical.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Change the "find_multipaths" option from yes/no to multi-value. This
option now covers the effects of "find_multipaths" as it used to be,
plus the -i option to multipath (ignore_wwids) and the -n option to
multipathd (ignore_new_devs), excluding such combinations of the former
options that are dangerous or inconsistent.

The possible values for "find_multipaths" are now:

 - strict: strictly stick to the WWIDs file; never add new maps automatically
   (new default; upstream behaviour with with find_multipaths "yes" and
   commit 64e27ec "multipathd: imply -n if find_multipaths is set")
 - off|no: multipath like "strict", multipathd like "greedy" (previous
   upstream default)
 - on|yes: set up multipath if >1 paths are seen (current Red Hat/Ubuntu
   behavior with find_multipaths "yes")
 - greedy: set up multipath for all non-blacklisted devices (current SUSE
   default)
 - smart: Like "yes", but try to avoid inconsistencies between udev processing
   and multipathd processing by waiting for path siblings to
   appear (fully implemented in follow-up patches)

The default has been changed to "strict", because "no" may cause inconsistent
behavior between "multipath -u" and multipathd. This is deliberately a
conservative choice.

The patch also updates the related man pages.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.h      |  2 --
 libmultipath/defaults.h    |  2 +-
 libmultipath/dict.c        | 47 ++++++++++++++++++++++++++++++++++++++++++++--
 libmultipath/structs.h     | 26 +++++++++++++++++++++++++
 libmultipath/wwids.c       |  8 ++++----
 multipath/main.c           |  6 +++---
 multipath/multipath.8      |  9 ++++++++-
 multipath/multipath.conf.5 | 46 +++++++++++++++++++++++++--------------------
 multipathd/main.c          |  6 +-----
 multipathd/multipathd.8    |  8 +++++---
 10 files changed, 119 insertions(+), 41 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index a20ac2a..21d8e72 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -139,7 +139,6 @@ struct config {
 	int max_fds;
 	int force_reload;
 	int queue_without_daemon;
-	int ignore_wwids;
 	int checker_timeout;
 	int flush_on_last_del;
 	int attribute_flags;
@@ -168,7 +167,6 @@ struct config {
 	int strict_timing;
 	int retrigger_tries;
 	int retrigger_delay;
-	int ignore_new_devs;
 	int delayed_reconfig;
 	int uev_wait_timeout;
 	int skip_kpartx;
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 2b270ca..690182c 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -17,7 +17,7 @@
 #define DEFAULT_NO_PATH_RETRY	NO_PATH_RETRY_UNDEF
 #define DEFAULT_VERBOSITY	2
 #define DEFAULT_REASSIGN_MAPS	0
-#define DEFAULT_FIND_MULTIPATHS	0
+#define DEFAULT_FIND_MULTIPATHS	FIND_MULTIPATHS_STRICT
 #define DEFAULT_FAST_IO_FAIL	5
 #define DEFAULT_DEV_LOSS_TMO	600
 #define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_ON
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index ea273dd..a952c60 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -233,8 +233,51 @@ declare_def_snprint(multipath_dir, print_str)
 declare_def_handler(partition_delim, set_str)
 declare_def_snprint(partition_delim, print_str)
 
-declare_def_handler(find_multipaths, set_yes_no)
-declare_def_snprint(find_multipaths, print_yes_no)
+static const char *find_multipaths_optvals[] = {
+	[FIND_MULTIPATHS_OFF] = "off",
+	[FIND_MULTIPATHS_ON] = "on",
+	[FIND_MULTIPATHS_STRICT] = "strict",
+	[FIND_MULTIPATHS_GREEDY] = "greedy",
+};
+
+static int
+def_find_multipaths_handler(struct config *conf, vector strvec)
+{
+	char *buff;
+	int i;
+
+	if (set_yes_no_undef(strvec, &conf->find_multipaths) == 0 &&
+	    conf->find_multipaths != YNU_UNDEF)
+		return 0;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	for (i = FIND_MULTIPATHS_OFF; i < __FIND_MULTIPATHS_LAST; i++) {
+		if (find_multipaths_optvals[i] != NULL &&
+		    !strcmp(buff, find_multipaths_optvals[i])) {
+			conf->find_multipaths = i;
+			break;
+		}
+	}
+
+	if (conf->find_multipaths == YNU_UNDEF) {
+		condlog(0, "illegal value for find_multipaths: %s", buff);
+		conf->find_multipaths = DEFAULT_FIND_MULTIPATHS;
+	}
+
+	FREE(buff);
+	return 0;
+}
+
+static int
+snprint_def_find_multipaths(struct config *conf, char *buff, int len,
+			    const void *data)
+{
+	return print_str(buff, len,
+			 find_multipaths_optvals[conf->find_multipaths]);
+}
 
 declare_def_handler(selector, set_str)
 declare_def_snprint_defstr(selector, print_str, DEFAULT_SELECTOR)
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 88a4b78..d6482f8 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -102,6 +102,32 @@ enum yes_no_undef_states {
 	YNU_YES,
 };
 
+#define _FIND_MULTIPATHS_F (1 << 1)
+#define _FIND_MULTIPATHS_I (1 << 2)
+#define _FIND_MULTIPATHS_N (1 << 3)
+/*
+ * _FIND_MULTIPATHS_F must have the same value as YNU_YES.
+ * Generate a compile time error if that isn't the case.
+ */
+char ___error1___[-(_FIND_MULTIPATHS_F != YNU_YES)];
+
+#define find_multipaths_on(conf) \
+	(!!((conf)->find_multipaths & _FIND_MULTIPATHS_F))
+#define ignore_wwids(conf) \
+	(!!((conf)->find_multipaths & _FIND_MULTIPATHS_I))
+#define ignore_new_devs(conf) \
+	(!!((conf)->find_multipaths & _FIND_MULTIPATHS_N))
+
+enum find_multipaths_states {
+	FIND_MULTIPATHS_UNDEF = YNU_UNDEF,
+	FIND_MULTIPATHS_OFF = YNU_NO,
+	FIND_MULTIPATHS_ON = _FIND_MULTIPATHS_F,
+	FIND_MULTIPATHS_STRICT = _FIND_MULTIPATHS_F|_FIND_MULTIPATHS_N,
+	FIND_MULTIPATHS_GREEDY = _FIND_MULTIPATHS_I,
+	FIND_MULTIPATHS_SMART = _FIND_MULTIPATHS_F|_FIND_MULTIPATHS_I,
+	__FIND_MULTIPATHS_LAST,
+};
+
 enum flush_states {
 	FLUSH_UNDEF = YNU_UNDEF,
 	FLUSH_DISABLED = YNU_NO,
diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index ea56911..5a2e86d 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -274,20 +274,20 @@ out:
 int
 should_multipath(struct path *pp1, vector pathvec, vector mpvec)
 {
-	int i, ignore_new_devs;
+	int i, ignore_new;
 	struct path *pp2;
 	struct config *conf;
 
 	conf = get_multipath_config();
-	ignore_new_devs = conf->ignore_new_devs;
-	if (!conf->find_multipaths && !ignore_new_devs) {
+	ignore_new = ignore_new_devs(conf);
+	if (!find_multipaths_on(conf) && !ignore_new) {
 		put_multipath_config(conf);
 		return 1;
 	}
 	put_multipath_config(conf);
 
 	condlog(4, "checking if %s should be multipathed", pp1->dev);
-	if (!ignore_new_devs) {
+	if (!ignore_new) {
 		char tmp_wwid[WWID_SIZE];
 		struct multipath *mp = find_mp_by_wwid(mpvec, pp1->wwid);
 
diff --git a/multipath/main.c b/multipath/main.c
index 19c729d..3944fd5 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -441,11 +441,11 @@ configure (struct config *conf, enum mpath_cmds cmd,
 		 * Paths listed in the wwids file are always considered valid.
 		 */
 		if (cmd == CMD_VALID_PATH) {
-			if ((!conf->find_multipaths && conf->ignore_wwids) ||
+			if ((!find_multipaths_on(conf) && ignore_wwids(conf)) ||
 			    check_wwids_file(refwwid, 0) == 0)
 				r = 0;
 			if (r == 0 ||
-			    !conf->find_multipaths || !conf->ignore_wwids) {
+			    !find_multipaths_on(conf) || !ignore_wwids(conf)) {
 				printf("%s %s a valid multipath device path\n",
 				       devpath, r == 0 ? "is" : "is not");
 				goto out;
@@ -737,7 +737,7 @@ main (int argc, char *argv[])
 			conf->force_reload = FORCE_RELOAD_YES;
 			break;
 		case 'i':
-			conf->ignore_wwids = 1;
+			conf->find_multipaths |= _FIND_MULTIPATHS_I;
 			break;
 		case 't':
 			r = dump_config(conf);
diff --git a/multipath/multipath.8 b/multipath/multipath.8
index 56f8703..329658d 100644
--- a/multipath/multipath.8
+++ b/multipath/multipath.8
@@ -94,7 +94,14 @@ Force devmap reload.
 .
 .TP
 .B \-i
-Ignore WWIDs file when processing devices.
+Ignore WWIDs file when processing devices. If 
+\fIfind_multipaths strict\fR or \fIfind_multipaths no\fR is set in
+\fImultipath.conf\fR, multipath only considers devices that are
+listed in the WWIDs file. This option overrides that behavior. For other values
+of \fIfind_multipaths\fR, this option has no effect. See the description of
+\fIfind_multipaths\fR in 
+.BR multipath.conf (5).
+This option should only be used in rare circumstances.
 .
 .TP
 .B \-B
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index c4d0789..6965dac 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -951,28 +951,34 @@ The default is: \fBno\fR
 .
 .TP
 .B find_multipaths
-If set to
-.I yes
-, instead of trying to create a multipath device for every non-blacklisted
-path, multipath will only create a device if one of three condidions are
-met.
-.I 1
-There are at least two non-blacklisted paths with the same WWID,
-.I 2
-the user manually forces the creation, by specifying a device with the multipath
-command, or
-.I 3
-a path has the same WWID as a multipath device that was previously created
-while find_multipaths was set (even if that multipath device doesn't currently
-exist).
-Whenever a multipath device is created with find_multipaths set, multipath will
-remember the WWID of the device, so that it will automatically create the
-device again, as soon as it sees a path with that WWID. This should allow most
-users to have multipath automatically choose the correct paths to make into
-multipath devices, without having to edit the blacklist.
+This option controls whether multipath and multipathd try to create multipath
+maps over non-blacklisted devices they encounter. This matters a) when a device is
+encountered by \fBmultipath -u\fR during udev rule processing (a device is
+blocked from further processing by higher layers - such as LVM - if and only
+if it\'s considered a valid multipath device path), and b) when multipathd
+detects a new device. The following values are possible:
 .RS
+.TP 10
+.I strict
+Both multipath and multipathd treat only such devices as multipath devices
+which have been part of a multipath map previously, and which are therefore
+listed in the \fBwwids_file\fR. Users can manually set up multipath maps using the
+\fBmultipathd add map\fR command. Once set up manually, the map is
+remembered in the wwids file and will be set up automatically in the future.
 .TP
-The default is: \fBno\fR
+.I no
+Multipath behaves like \fBstrict\fR. Multipathd behaves like \fBgreedy\fR.
+.TP
+.I yes
+Both multipathd and multipath treat a device as multipath device if the
+conditions for \fBstrict\fR are met, or if at least two non-blacklisted paths
+with the same WWID have been detected.
+.TP
+.I greedy
+Both multipathd and multipath treat every non-blacklisted device as multipath
+device path.
+.TP
+The default is: \fBstrict\fR
 .RE
 .
 .
diff --git a/multipathd/main.c b/multipathd/main.c
index da40595..bfbe5f6 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2390,8 +2390,6 @@ reconfigure (struct vectors * vecs)
 		conf->verbosity = verbosity;
 	if (bindings_read_only)
 		conf->bindings_read_only = bindings_read_only;
-	if (ignore_new_devs)
-		conf->ignore_new_devs = ignore_new_devs;
 	uxsock_timeout = conf->uxsock_timeout;
 
 	old = rcu_dereference(multipath_conf);
@@ -2620,8 +2618,6 @@ child (void * param)
 		conf->verbosity = verbosity;
 	if (bindings_read_only)
 		conf->bindings_read_only = bindings_read_only;
-	if (ignore_new_devs)
-		conf->ignore_new_devs = ignore_new_devs;
 	uxsock_timeout = conf->uxsock_timeout;
 	rcu_assign_pointer(multipath_conf, conf);
 	if (init_checkers(conf->multipath_dir)) {
@@ -2975,7 +2971,7 @@ main (int argc, char *argv[])
 			bindings_read_only = 1;
 			break;
 		case 'n':
-			ignore_new_devs = 1;
+			condlog(0, "WARNING: ignoring deprecated option -n, use 'ignore_wwids = no' instead");
 			break;
 		case 'w':
 			poll_dmevents = 0;
diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
index 5c96680..e78ac9e 100644
--- a/multipathd/multipathd.8
+++ b/multipathd/multipathd.8
@@ -25,7 +25,6 @@ multipathd \- Multipath daemon.
 .RB [\| \-v\ \c
 .IR verbosity \|]
 .RB [\| \-B \|]
-.RB [\| \-n \|]
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -73,8 +72,11 @@ be viewed by entering '\fIhelp\fR'. When you are finished entering commands, pre
 .
 .TP
 .B \-n
-Ignore new devices. multipathd will not create a multipath device unless the
-WWID for the device is already listed in the WWIDs file.
+\fBIGNORED\fR. Use the option
+\fIfind_multipaths\fR to control the treatment of newly detected devices by
+multipathd. See
+.BR multipath.conf(5).
+.
 .
 .
 .\" ----------------------------------------------------------------------------
-- 
2.16.1
