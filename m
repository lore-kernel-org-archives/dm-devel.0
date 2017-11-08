From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 6/6] multipath: add "ghost_delay" parameter
Date: Tue,  7 Nov 2017 18:15:16 -0600
Message-ID: <1510100116-6206-7-git-send-email-bmarzins@redhat.com>
References: <1510100116-6206-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1510100116-6206-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

If the lower-priority passive paths for a multipath device appear first,
IO can go to them and cause the hardware handler to activate them,
before the higher priority paths appear, causing the devices to
failback. Setting the "ghost_delay" parameter to a value greater than
0 can avoid this ping-ponging by causing udev to not mark the device as
Ready after its initial creation until either an active path appears,
or ghost_delay seconds have passed. Multipathd does this by setting
the MPATH_UDEV_NO_PATHS_FLAG.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c      |  3 +++
 libmultipath/config.h      |  3 +++
 libmultipath/configure.c   | 11 +++++++++++
 libmultipath/defaults.h    |  1 +
 libmultipath/devmapper.c   |  2 +-
 libmultipath/dict.c        | 14 ++++++++++++++
 libmultipath/hwtable.c     |  1 +
 libmultipath/propsel.c     | 15 +++++++++++++++
 libmultipath/propsel.h     |  1 +
 libmultipath/structs.h     |  7 +++++++
 multipath/multipath.conf.5 | 19 +++++++++++++++++++
 multipathd/main.c          | 28 +++++++++++++++++++++++++++-
 12 files changed, 103 insertions(+), 2 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index ea2359a..9486116 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -351,6 +351,7 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_num(delay_wait_checks);
 	merge_num(skip_kpartx);
 	merge_num(max_sectors_kb);
+	merge_num(ghost_delay);
 	merge_num(san_path_err_threshold);
 	merge_num(san_path_err_forget_rate);
 	merge_num(san_path_err_recovery_time);
@@ -422,6 +423,7 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
 	hwe->retain_hwhandler = dhwe->retain_hwhandler;
 	hwe->detect_prio = dhwe->detect_prio;
 	hwe->detect_checker = dhwe->detect_checker;
+	hwe->ghost_delay = dhwe->ghost_delay;
 
 	if (dhwe->bl_product && !(hwe->bl_product = set_param_str(dhwe->bl_product)))
 		goto out;
@@ -622,6 +624,7 @@ load_config (char * file)
 	conf->uev_wait_timeout = DEFAULT_UEV_WAIT_TIMEOUT;
 	conf->disable_changed_wwids = DEFAULT_DISABLE_CHANGED_WWIDS;
 	conf->remove_retries = 0;
+	conf->ghost_delay = DEFAULT_GHOST_DELAY;
 
 	/*
 	 * preload default hwtable
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 240730b..67ff983 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -80,6 +80,7 @@ struct hwentry {
 	int san_path_err_recovery_time;
 	int skip_kpartx;
 	int max_sectors_kb;
+	int ghost_delay;
 	char * bl_product;
 };
 
@@ -112,6 +113,7 @@ struct mpentry {
 	int san_path_err_recovery_time;
 	int skip_kpartx;
 	int max_sectors_kb;
+	int ghost_delay;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
@@ -170,6 +172,7 @@ struct config {
 	int disable_changed_wwids;
 	int remove_retries;
 	int max_sectors_kb;
+	int ghost_delay;
 	unsigned int version[3];
 
 	char * multipath_dir;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 7a3db31..e2f393f 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -300,6 +300,7 @@ int setup_map(struct multipath *mpp, char *params, int params_size)
 	select_san_path_err_recovery_time(conf, mpp);
 	select_skip_kpartx(conf, mpp);
 	select_max_sectors_kb(conf, mpp);
+	select_ghost_delay(conf, mpp);
 
 	sysfs_set_scsi_tmo(mpp, conf->checkint);
 	put_multipath_config(conf);
@@ -760,6 +761,9 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 		}
 
 		sysfs_set_max_sectors_kb(mpp, 0);
+		if (is_daemon && mpp->ghost_delay > 0 && mpp->nr_active &&
+		    pathcount(mpp, PATH_GHOST) == mpp->nr_active)
+			mpp->ghost_delay_tick = mpp->ghost_delay;
 		r = dm_addmap_create(mpp, params);
 
 		lock_multipath(mpp, 0);
@@ -767,11 +771,15 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 
 	case ACT_RELOAD:
 		sysfs_set_max_sectors_kb(mpp, 1);
+		if (mpp->ghost_delay_tick > 0 && pathcount(mpp, PATH_UP))
+			mpp->ghost_delay_tick = 0;
 		r = dm_addmap_reload(mpp, params, 0);
 		break;
 
 	case ACT_RESIZE:
 		sysfs_set_max_sectors_kb(mpp, 1);
+		if (mpp->ghost_delay_tick > 0 && pathcount(mpp, PATH_UP))
+			mpp->ghost_delay_tick = 0;
 		r = dm_addmap_reload(mpp, params, 1);
 		break;
 
@@ -789,6 +797,9 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 		put_multipath_config(conf);
 		if (r) {
 			sysfs_set_max_sectors_kb(mpp, 1);
+			if (mpp->ghost_delay_tick > 0 &&
+			    pathcount(mpp, PATH_UP))
+				mpp->ghost_delay_tick = 0;
 			r = dm_addmap_reload(mpp, params, 0);
 		}
 		break;
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 740ccf4..c9e3411 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -40,6 +40,7 @@
 #define DEFAULT_SKIP_KPARTX SKIP_KPARTX_OFF
 #define DEFAULT_DISABLE_CHANGED_WWIDS 0
 #define DEFAULT_MAX_SECTORS_KB MAX_SECTORS_KB_UNDEF
+#define DEFAULT_GHOST_DELAY GHOST_DELAY_OFF
 
 #define DEFAULT_CHECKINT	5
 #define MAX_CHECKINT(a)		(a << 2)
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index fcac6bc..573fc75 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -378,7 +378,7 @@ static uint16_t build_udev_flags(const struct multipath *mpp, int reload)
 	/* DM_UDEV_DISABLE_LIBRARY_FALLBACK is added in dm_addmap */
 	return	(mpp->skip_kpartx == SKIP_KPARTX_ON ?
 		 MPATH_UDEV_NO_KPARTX_FLAG : 0) |
-		(mpp->nr_active == 0 ?
+		((mpp->nr_active == 0 || mpp->ghost_delay_tick > 0)?
 		 MPATH_UDEV_NO_PATHS_FLAG : 0) |
 		(reload && !mpp->force_udev_reload ?
 		 MPATH_UDEV_RELOAD_FLAG : 0);
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 36cccc9..54652d4 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1110,6 +1110,16 @@ declare_hw_handler(san_path_err_recovery_time, set_off_int_undef)
 declare_hw_snprint(san_path_err_recovery_time, print_off_int_undef)
 declare_mp_handler(san_path_err_recovery_time, set_off_int_undef)
 declare_mp_snprint(san_path_err_recovery_time, print_off_int_undef)
+
+declare_def_handler(ghost_delay, set_off_int_undef)
+declare_def_snprint(ghost_delay, print_off_int_undef)
+declare_ovr_handler(ghost_delay, set_off_int_undef)
+declare_ovr_snprint(ghost_delay, print_off_int_undef)
+declare_hw_handler(ghost_delay, set_off_int_undef)
+declare_hw_snprint(ghost_delay, print_off_int_undef)
+declare_mp_handler(ghost_delay, set_off_int_undef)
+declare_mp_snprint(ghost_delay, print_off_int_undef)
+
 static int
 def_uxsock_timeout_handler(struct config *conf, vector strvec)
 {
@@ -1456,6 +1466,7 @@ init_keywords(vector keywords)
 	install_keyword("disable_changed_wwids", &def_disable_changed_wwids_handler, &snprint_def_disable_changed_wwids);
 	install_keyword("remove_retries", &def_remove_retries_handler, &snprint_def_remove_retries);
 	install_keyword("max_sectors_kb", &def_max_sectors_kb_handler, &snprint_def_max_sectors_kb);
+	install_keyword("ghost_delay", &def_ghost_delay_handler, &snprint_def_ghost_delay);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
@@ -1535,6 +1546,7 @@ init_keywords(vector keywords)
 	install_keyword("san_path_err_recovery_time", &hw_san_path_err_recovery_time_handler, &snprint_hw_san_path_err_recovery_time);
 	install_keyword("skip_kpartx", &hw_skip_kpartx_handler, &snprint_hw_skip_kpartx);
 	install_keyword("max_sectors_kb", &hw_max_sectors_kb_handler, &snprint_hw_max_sectors_kb);
+	install_keyword("ghost_delay", &hw_ghost_delay_handler, &snprint_hw_ghost_delay);
 	install_sublevel_end();
 
 	install_keyword_root("overrides", &overrides_handler);
@@ -1569,6 +1581,7 @@ init_keywords(vector keywords)
 
 	install_keyword("skip_kpartx", &ovr_skip_kpartx_handler, &snprint_ovr_skip_kpartx);
 	install_keyword("max_sectors_kb", &ovr_max_sectors_kb_handler, &snprint_ovr_max_sectors_kb);
+	install_keyword("ghost_delay", &ovr_ghost_delay_handler, &snprint_ovr_ghost_delay);
 
 	install_keyword_root("multipaths", &multipaths_handler);
 	install_keyword_multi("multipath", &multipath_handler, NULL);
@@ -1600,5 +1613,6 @@ init_keywords(vector keywords)
 	install_keyword("san_path_err_recovery_time", &mp_san_path_err_recovery_time_handler, &snprint_mp_san_path_err_recovery_time);
 	install_keyword("skip_kpartx", &mp_skip_kpartx_handler, &snprint_mp_skip_kpartx);
 	install_keyword("max_sectors_kb", &mp_max_sectors_kb_handler, &snprint_mp_max_sectors_kb);
+	install_keyword("ghost_delay", &mp_ghost_delay_handler, &snprint_mp_ghost_delay);
 	install_sublevel_end();
 }
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 78de1fa..7226fb1 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -72,6 +72,7 @@
 		.delay_wait_checks = DELAY_CHECKS_OFF,
 		.skip_kpartx   = SKIP_KPARTX_OFF,
 		.max_sectors_kb = MAX_SECTORS_KB_UNDEF,
+		.ghost_delay = GHOST_DELAY_OFF
 	},
 #endif
 
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 00adc0d..6721cc6 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -835,3 +835,18 @@ out:
 		origin);
 	return 0;
 }
+
+int select_ghost_delay (struct config *conf, struct multipath * mp)
+{
+	char *origin, buff[12];
+
+	mp_set_mpe(ghost_delay);
+	mp_set_ovr(ghost_delay);
+	mp_set_hwe(ghost_delay);
+	mp_set_conf(ghost_delay);
+	mp_set_default(ghost_delay, DEFAULT_GHOST_DELAY);
+out:
+	print_off_int_undef(buff, 12, &mp->ghost_delay);
+	condlog(3, "%s: ghost_delay = %s %s", mp->alias, buff, origin);
+	return 0;
+}
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index f8e96d8..494fb10 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -25,6 +25,7 @@ int select_delay_watch_checks (struct config *conf, struct multipath * mp);
 int select_delay_wait_checks (struct config *conf, struct multipath * mp);
 int select_skip_kpartx (struct config *conf, struct multipath * mp);
 int select_max_sectors_kb (struct config *conf, struct multipath * mp);
+int select_ghost_delay(struct config *conf, struct multipath * mp);
 int select_san_path_err_forget_rate(struct config *conf, struct multipath *mp);
 int select_san_path_err_threshold(struct config *conf, struct multipath *mp);
 int select_san_path_err_recovery_time(struct config *conf, struct multipath *mp);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index f06824a..d2d7701 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -167,6 +167,11 @@ enum no_undef_states {
 	NU_UNDEF = 0,
 };
 
+enum ghost_delay_states {
+	GHOST_DELAY_OFF = NU_NO,
+	GHOST_DELAY_UNDEF = NU_UNDEF,
+};
+
 enum initialized_states {
 	INIT_FAILED,
 	INIT_MISSING_UDEV,
@@ -282,6 +287,8 @@ struct multipath {
 	int max_sectors_kb;
 	int force_readonly;
 	int force_udev_reload;
+	int ghost_delay;
+	int ghost_delay_tick;
 	unsigned int dev_loss;
 	uid_t uid;
 	gid_t gid;
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 4bd1a8d..8783124 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1017,6 +1017,19 @@ The default is: \fB<device dependent>\fR
 .RE
 .
 .
+.TP
+.B ghost_delay
+Sets the number of seconds that multipath will wait after creating a device
+with only ghost paths before marking it ready for use in systemd. This gives
+the active paths time to appear before the multipath runs the hardware handler
+to switch the ghost paths to active ones. Setting this to \fI0\fR or \fIon\fR
+makes multipath immediately mark a device with only ghost paths as ready.
+.RS
+.TP
+The default is \fBno\fR
+.RE
+.
+.
 .\" ----------------------------------------------------------------------------
 .SH "blacklist section"
 .\" ----------------------------------------------------------------------------
@@ -1157,6 +1170,8 @@ are taken from the \fIdefaults\fR or \fIdevices\fR section:
 .B skip_kpartx
 .TP
 .B max_sectors_kb
+.TP
+.B ghost_delay
 .RE
 .PD
 .LP
@@ -1284,6 +1299,8 @@ section:
 .B skip_kpartx
 .TP
 .B max_sectors_kb
+.TP
+.B ghost_delay
 .RE
 .PD
 .LP
@@ -1354,6 +1371,8 @@ the values are taken from the \fIdevices\fR or \fIdefaults\fR sections:
 .B delay_wait_checks
 .TP
 .B skip_kpartx
+.TP
+.B ghost_delay
 .RE
 .PD
 .LP
diff --git a/multipathd/main.c b/multipathd/main.c
index 8049da2..c475fcd 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -351,6 +351,8 @@ sync_map_state(struct multipath *mpp)
 			    pp->state == PATH_WILD ||
 			    pp->state == PATH_DELAYED)
 				continue;
+			if (mpp->ghost_delay_tick > 0)
+				continue;
 			if ((pp->dmstate == PSTATE_FAILED ||
 			     pp->dmstate == PSTATE_UNDEF) &&
 			    (pp->state == PATH_UP || pp->state == PATH_GHOST))
@@ -735,7 +737,8 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
 	mpp = find_mp_by_wwid(vecs->mpvec, pp->wwid);
 	if (mpp && mpp->wait_for_udev &&
 	    (pathcount(mpp, PATH_UP) > 0 ||
-	     (pathcount(mpp, PATH_GHOST) > 0 && pp->tpgs != TPGS_IMPLICIT))) {
+	     (pathcount(mpp, PATH_GHOST) > 0 && pp->tpgs != TPGS_IMPLICIT &&
+	      mpp->ghost_delay_tick <= 0))) {
 		/* if wait_for_udev is set and valid paths exist */
 		condlog(2, "%s: delaying path addition until %s is fully initialized", pp->dev, mpp->alias);
 		mpp->wait_for_udev = 2;
@@ -1416,6 +1419,28 @@ missing_uev_wait_tick(struct vectors *vecs)
 }
 
 static void
+ghost_delay_tick(struct vectors *vecs)
+{
+	struct multipath * mpp;
+	unsigned int i;
+
+	vector_foreach_slot (vecs->mpvec, mpp, i) {
+		if (mpp->ghost_delay_tick <= 0)
+			continue;
+		if (--mpp->ghost_delay_tick <= 0) {
+			condlog(0, "%s: timed out waiting for active path",
+				mpp->alias);
+			mpp->force_udev_reload = 1;
+			if (update_map(mpp, vecs) != 0) {
+				/* update_map removed map */
+				i--;
+				continue;
+			}
+		}
+	}
+}
+
+static void
 defered_failback_tick (vector mpvec)
 {
 	struct multipath * mpp;
@@ -1961,6 +1986,7 @@ checkerloop (void *ap)
 		defered_failback_tick(vecs->mpvec);
 		retry_count_tick(vecs->mpvec);
 		missing_uev_wait_tick(vecs);
+		ghost_delay_tick(vecs);
 		lock_cleanup_pop(vecs->lock);
 
 		if (count)
-- 
2.7.4
