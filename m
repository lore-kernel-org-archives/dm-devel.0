From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 3/3] add "max_sectors_kb" config parameter
Date: Fri, 11 Nov 2016 16:58:23 -0600
Message-ID: <1478905103-9735-4-git-send-email-bmarzins@redhat.com>
References: <1478905103-9735-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1478905103-9735-1-git-send-email-bmarzins@redhat.com>
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

This patch adds the "max_sectors_kb" parameter to all multipath.conf
sections. Setting this will cause multipath to set the max_sectors_kb
queue parameter to the specified value on all of the paths before
creating the multipath device, which will inherit the value from the
paths.

If max_sectors_kb is out of sync between the multipath device and the
path devices, it's possible for multpiath to send down a request that is
too large for the path to handle.  When devices are discovered,
multipathd automatically sets up multipath devices on top of them. LVM
and filesystems can get mounted on top of that.  This means that users
who what to modify max_sectors_kb manually, may have to do it after
these devices are already in use.  This config option lets them simply
have multipath set up the values before creating the device.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c      |  2 ++
 libmultipath/config.h      |  3 +++
 libmultipath/configure.c   |  2 ++
 libmultipath/defaults.h    |  1 +
 libmultipath/dict.c        | 13 +++++++++++++
 libmultipath/discovery.c   | 23 +++++++++++++++++++++++
 libmultipath/discovery.h   |  1 +
 libmultipath/propsel.c     | 16 ++++++++++++++++
 libmultipath/propsel.h     |  1 +
 libmultipath/structs.h     |  6 ++++++
 multipath/multipath.conf.5 | 14 ++++++++++++++
 11 files changed, 82 insertions(+)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 342f326..2e02061 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -349,6 +349,7 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_num(delay_watch_checks);
 	merge_num(delay_wait_checks);
 	merge_num(skip_kpartx);
+	merge_num(max_sectors_kb);
 
 	/*
 	 * Make sure features is consistent with
@@ -621,6 +622,7 @@ load_config (char * file)
 	conf->skip_kpartx = DEFAULT_SKIP_KPARTX;
 	conf->disable_changed_wwids = DEFAULT_DISABLE_CHANGED_WWIDS;
 	conf->remove_retries = 0;
+	conf->max_sectors_kb = DEFAULT_MAX_SECTORS_KB;
 
 	/*
 	 * preload default hwtable
diff --git a/libmultipath/config.h b/libmultipath/config.h
index eee28e7..9670020 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -66,6 +66,7 @@ struct hwentry {
 	int delay_watch_checks;
 	int delay_wait_checks;
 	int skip_kpartx;
+	int max_sectors_kb;
 	char * bl_product;
 };
 
@@ -93,6 +94,7 @@ struct mpentry {
 	int delay_watch_checks;
 	int delay_wait_checks;
 	int skip_kpartx;
+	int max_sectors_kb;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
@@ -146,6 +148,7 @@ struct config {
 	int skip_kpartx;
 	int disable_changed_wwids;
 	int remove_retries;
+	int max_sectors_kb;
 	unsigned int version[3];
 
 	char * multipath_dir;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index d428099..0002d14 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -296,8 +296,10 @@ setup_map (struct multipath * mpp, char * params, int params_size)
 	select_delay_watch_checks(conf, mpp);
 	select_delay_wait_checks(conf, mpp);
 	select_skip_kpartx(conf, mpp);
+	select_max_sectors_kb(conf, mpp);
 
 	sysfs_set_scsi_tmo(mpp, conf->checkint);
+	sysfs_set_max_sectors_kb(mpp);
 	put_multipath_config(conf);
 	/*
 	 * assign paths to path groups -- start with no groups and all paths
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index a72078f..b9b0a37 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -37,6 +37,7 @@
 #define DEFAULT_PARTITION_DELIM	NULL
 #define DEFAULT_SKIP_KPARTX SKIP_KPARTX_OFF
 #define DEFAULT_DISABLE_CHANGED_WWIDS 0
+#define DEFAULT_MAX_SECTORS_KB MAX_SECTORS_KB_UNDEF
 
 #define DEFAULT_CHECKINT	5
 #define MAX_CHECKINT(a)		(a << 2)
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 6e4ec71..dc21846 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -418,6 +418,15 @@ declare_def_snprint(disable_changed_wwids, print_yes_no)
 declare_def_handler(remove_retries, set_int)
 declare_def_snprint(remove_retries, print_int)
 
+declare_def_handler(max_sectors_kb, set_int)
+declare_def_snprint(max_sectors_kb, print_nonzero)
+declare_ovr_handler(max_sectors_kb, set_int)
+declare_ovr_snprint(max_sectors_kb, print_nonzero)
+declare_hw_handler(max_sectors_kb, set_int)
+declare_hw_snprint(max_sectors_kb, print_nonzero)
+declare_mp_handler(max_sectors_kb, set_int)
+declare_mp_snprint(max_sectors_kb, print_nonzero)
+
 static int
 def_config_dir_handler(struct config *conf, vector strvec)
 {
@@ -1403,6 +1412,7 @@ init_keywords(vector keywords)
 	install_keyword("skip_kpartx", &def_skip_kpartx_handler, &snprint_def_skip_kpartx);
 	install_keyword("disable_changed_wwids", &def_disable_changed_wwids_handler, &snprint_def_disable_changed_wwids);
 	install_keyword("remove_retries", &def_remove_retries_handler, &snprint_def_remove_retries);
+	install_keyword("max_sectors_kb", &def_max_sectors_kb_handler, &snprint_def_max_sectors_kb);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
@@ -1477,6 +1487,7 @@ init_keywords(vector keywords)
 	install_keyword("delay_watch_checks", &hw_delay_watch_checks_handler, &snprint_hw_delay_watch_checks);
 	install_keyword("delay_wait_checks", &hw_delay_wait_checks_handler, &snprint_hw_delay_wait_checks);
 	install_keyword("skip_kpartx", &hw_skip_kpartx_handler, &snprint_hw_skip_kpartx);
+	install_keyword("max_sectors_kb", &hw_max_sectors_kb_handler, &snprint_hw_max_sectors_kb);
 	install_sublevel_end();
 
 	install_keyword_root("overrides", &overrides_handler);
@@ -1505,6 +1516,7 @@ init_keywords(vector keywords)
 	install_keyword("delay_watch_checks", &ovr_delay_watch_checks_handler, &snprint_ovr_delay_watch_checks);
 	install_keyword("delay_wait_checks", &ovr_delay_wait_checks_handler, &snprint_ovr_delay_wait_checks);
 	install_keyword("skip_kpartx", &ovr_skip_kpartx_handler, &snprint_ovr_skip_kpartx);
+	install_keyword("max_sectors_kb", &ovr_max_sectors_kb_handler, &snprint_ovr_max_sectors_kb);
 
 	install_keyword_root("multipaths", &multipaths_handler);
 	install_keyword_multi("multipath", &multipath_handler, NULL);
@@ -1532,5 +1544,6 @@ init_keywords(vector keywords)
 	install_keyword("delay_watch_checks", &mp_delay_watch_checks_handler, &snprint_mp_delay_watch_checks);
 	install_keyword("delay_wait_checks", &mp_delay_wait_checks_handler, &snprint_mp_delay_wait_checks);
 	install_keyword("skip_kpartx", &mp_skip_kpartx_handler, &snprint_mp_skip_kpartx);
+	install_keyword("max_sectors_kb", &mp_max_sectors_kb_handler, &snprint_mp_max_sectors_kb);
 	install_sublevel_end();
 }
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 756344f..0d73ff7 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -212,6 +212,29 @@ declare_sysfs_get_str(rev);
 declare_sysfs_get_str(access_state);
 declare_sysfs_get_str(preferred_path);
 
+int
+sysfs_set_max_sectors_kb(struct multipath *mpp)
+{
+	struct path *pp;
+	char buff[11];
+	int i, ret, err = 0;
+
+	if (mpp->max_sectors_kb == MAX_SECTORS_KB_UNDEF)
+		return 0;
+	snprintf(buff, 11, "%d", mpp->max_sectors_kb);
+
+	vector_foreach_slot(mpp->paths, pp, i) {
+		ret = sysfs_attr_set_value(pp->udev, "queue/max_sectors_kb",
+					   buff, strlen(buff));
+		if (ret < 0) {
+			condlog(0, "failed setting max_sectors_kb on %s : %s",
+				pp->dev, strerror(-ret));
+			err = 1;
+		}
+	}
+	return err;
+}
+
 ssize_t
 sysfs_get_vpd (struct udev_device * udev, int pg,
 	       unsigned char * buff, size_t len)
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 176eac1..97e5a32 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -50,6 +50,7 @@ ssize_t sysfs_get_vpd (struct udev_device * udev, int pg, unsigned char * buff,
 int sysfs_get_asymmetric_access_state(struct path *pp,
 				      char *buff, int buflen);
 int get_uid(struct path * pp, int path_state, struct udev_device *udev);
+int sysfs_set_max_sectors_kb(struct multipath *mpp);
 
 /*
  * discovery bitmask
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index ec1fd92..ac7c417 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -684,3 +684,19 @@ out:
 		origin);
 	return 0;
 }
+
+extern int
+select_max_sectors_kb (struct config *conf, struct multipath * mp)
+{
+	char *origin;
+
+	mp_set_mpe(max_sectors_kb);
+	mp_set_ovr(max_sectors_kb);
+	mp_set_hwe(max_sectors_kb);
+	mp_set_conf(max_sectors_kb);
+	return 0;
+out:
+	condlog(3, "%s: max_sectors_kb = %i %s", mp->alias, mp->max_sectors_kb,
+		origin);
+	return 0;
+}
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index 3e6d607..ad98fa5 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -23,3 +23,4 @@ int select_deferred_remove(struct config *conf, struct multipath *mp);
 int select_delay_watch_checks (struct config *conf, struct multipath * mp);
 int select_delay_wait_checks (struct config *conf, struct multipath * mp);
 int select_skip_kpartx (struct config *conf, struct multipath * mp);
+int select_max_sectors_kb (struct config *conf, struct multipath * mp);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 58508f6..396f69d 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -134,6 +134,11 @@ enum skip_kpartx_states {
 	SKIP_KPARTX_ON = YNU_YES,
 };
 
+enum max_sectors_kb_states {
+	MAX_SECTORS_KB_UNDEF = 0,
+	MAX_SECTORS_KB_MIN = 4,  /* can't be smaller than page size */
+};
+
 enum scsi_protocol {
 	SCSI_PROTOCOL_FCP = 0,	/* Fibre Channel */
 	SCSI_PROTOCOL_SPI = 1,	/* parallel SCSI */
@@ -251,6 +256,7 @@ struct multipath {
 	int delay_watch_checks;
 	int delay_wait_checks;
 	int skip_kpartx;
+	int max_sectors_kb;
 	unsigned int dev_loss;
 	uid_t uid;
 	gid_t gid;
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 266f06b..eafd48a 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -874,6 +874,16 @@ Default value is \fB0\fR
 .RE
 .
 .
+.TP
+.B max_sectors_kb
+Sets the max_sectors_kb device parameter on all path devices and the multipath
+device to the specified value.
+.RS
+.TP
+Default is device dependent.
+.RE
+.
+.
 .\" ----------------------------------------------------------------------------
 .SH "blacklist section"
 .\" ----------------------------------------------------------------------------
@@ -1006,6 +1016,8 @@ are taken from the \fIdefaults\fR or \fIdevices\fR section:
 .B delay_wait_checks
 .TP
 .B skip_kpartx
+.TP
+.B max_sectors_kb
 .RE
 .PD
 .LP
@@ -1117,6 +1129,8 @@ section:
 .B delay_wait_checks
 .TP
 .B skip_kpartx
+.TP
+.B max_sectors_kb
 .RE
 .PD
 .LP
-- 
1.8.3.1
