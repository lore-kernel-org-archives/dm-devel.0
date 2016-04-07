From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 10/18] multipathd: delay reloads during
	creation
Date: Thu,  7 Apr 2016 18:20:04 -0500
Message-ID: <1460071212-21018-11-git-send-email-bmarzins@redhat.com>
References: <1460071212-21018-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1460071212-21018-1-git-send-email-bmarzins@redhat.com>
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

lvm needs PV devices to not be suspended while the udev rules are
running, for them to be correctly identified as PVs. However, multipathd
will often be in a situation where it will create a multipath device
upon seeing a path, and then immediately reload the device upon seeing
another path.  If multipath is reloading a device while processing the
udev event from its creation, lvm can fail to identify it as a PV. This
can cause systems to fail to boot. Unfortunately, using udev
synchronization cookies to solve this issue would cause a host of other
issues that could only be avoided by a pretty substantial change in how
multipathd does locking and event processing. The good news is that
multipathd is already listening to udev events itself, and can make sure
that it isn't reloading when it shouldn't be.

This patch makes multipathd delay or refuse any reloads that would
happen between the time when it creates a device, and when it receives
the change uevent from the device creation. The only reloads that it
refuses are from the multipathd interactive commands that make no sense
on a not fully started device.  Otherwise, it processes the event or
command, and sets a flag to either mark that device for an update, or
to signal that multipathd needs a reconfigure. When the udev event for
the creation arrives, multipath will reload the device if necessary. If
a reconfigure has been requested, and no devices are currently being
created, multipathd will also do the reconfigure then.

Also this patch adds a configurable timer "missing_uev_wait_timeout"
defaulting to 30 seconds. If the udev creation event has not arrived
after this timeout has triggered, multipathd will print an warning
message, and re-enable device reloads, as if the event had occured.

Users can also manually re-enable device reloads by running

multipathd add map <map_waiting_on_udev>

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c      |   1 +
 libmultipath/config.h      |   2 +
 libmultipath/configure.c   |   4 ++
 libmultipath/defaults.h    |   1 +
 libmultipath/dict.c        |   4 ++
 libmultipath/structs.h     |   2 +
 multipath.conf.defaults    |   1 +
 multipath/multipath.conf.5 |   8 +++
 multipathd/cli_handlers.c  |  65 ++++++++++++++++++----
 multipathd/main.c          | 132 +++++++++++++++++++++++++++++++++++++++++++--
 multipathd/main.h          |   1 +
 11 files changed, 208 insertions(+), 13 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index b038b47..8b9e770 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -621,6 +621,7 @@ load_config (char * file, struct udev *udev)
 	conf->uid_attribute = set_default(DEFAULT_UID_ATTRIBUTE);
 	conf->retrigger_tries = DEFAULT_RETRIGGER_TRIES;
 	conf->retrigger_delay = DEFAULT_RETRIGGER_DELAY;
+	conf->uev_wait_timeout = DEFAULT_UEV_WAIT_TIMEOUT;
 
 	/*
 	 * preload default hwtable
diff --git a/libmultipath/config.h b/libmultipath/config.h
index d6a1d4f..e9828ea 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -138,6 +138,8 @@ struct config {
 	int retrigger_tries;
 	int retrigger_delay;
 	int ignore_new_devs;
+	int delayed_reconfig;
+	int uev_wait_timeout;
 	unsigned int version[3];
 
 	char * dev;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 1ab3324..30c7259 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -676,6 +676,10 @@ domap (struct multipath * mpp, char * params)
 			 */
 			if (mpp->action != ACT_CREATE)
 				mpp->action = ACT_NOTHING;
+			else {
+				mpp->wait_for_udev = 1;
+				mpp->uev_wait_tick = conf->uev_wait_timeout;
+			}
 		}
 		dm_setgeometry(mpp);
 		return DOMAP_OK;
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 7e847ae..bce8bcc 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -22,6 +22,7 @@
 #define DEFAULT_UEVENT_STACKSIZE 256
 #define DEFAULT_RETRIGGER_DELAY 10
 #define DEFAULT_RETRIGGER_TRIES 3
+#define DEFAULT_UEV_WAIT_TIMEOUT 30
 
 #define DEFAULT_CHECKINT	5
 #define MAX_CHECKINT(a)		(a << 2)
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 661456f..89d42a1 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -396,6 +396,9 @@ declare_def_snprint(retrigger_tries, print_int)
 declare_def_handler(retrigger_delay, set_int)
 declare_def_snprint(retrigger_delay, print_int)
 
+declare_def_handler(uev_wait_timeout, set_int)
+declare_def_snprint(uev_wait_timeout, print_int)
+
 static int
 def_config_dir_handler(vector strvec)
 {
@@ -1371,6 +1374,7 @@ init_keywords(void)
 	install_keyword("uxsock_timeout", &def_uxsock_timeout_handler, &snprint_def_uxsock_timeout);
 	install_keyword("retrigger_tries", &def_retrigger_tries_handler, &snprint_def_retrigger_tries);
 	install_keyword("retrigger_delay", &def_retrigger_delay_handler, &snprint_def_retrigger_delay);
+	install_keyword("missing_uev_wait_timeout", &def_uev_wait_timeout_handler, &snprint_def_uev_wait_timeout);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index c56221b..ab7dc25 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -226,6 +226,8 @@ struct multipath {
 	int bestpg;
 	int queuedio;
 	int action;
+	int wait_for_udev;
+	int uev_wait_tick;
 	int pgfailback;
 	int failback_tick;
 	int rr_weight;
diff --git a/multipath.conf.defaults b/multipath.conf.defaults
index 6adff28..a4e68b1 100644
--- a/multipath.conf.defaults
+++ b/multipath.conf.defaults
@@ -29,6 +29,7 @@
 #	config_dir "/etc/multipath/conf.d"
 #	delay_watch_checks no
 #	delay_wait_checks no
+#	missing_uev_wait_timeout 30
 #}
 #blacklist {
 #	devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 6980010..9752c67 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -488,6 +488,14 @@ can be processed. This will result in errors like
 In these cases it is recommended to increase the CLI timeout to avoid
 those issues. The default is
 .I 1000
+.TP
+.B missing_uev_wait_timeout
+Controls how many seconds multipathd will wait, after a new multipath device
+is created, to receive a change event from udev for the device, before
+automatically enabling device reloads. Usually multipathd will delay reloads
+on a device until it receives a change uevent from the initial table load. The
+default is
+.I 30
 .
 .SH "blacklist section"
 The
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index a44281f..21fe00e 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -623,6 +623,11 @@ cli_reload(void *v, char **reply, int *len, void *data)
 		condlog(0, "%s: invalid map name. cannot reload", mapname);
 		return 1;
 	}
+	if (mpp->wait_for_udev) {
+		condlog(2, "%s: device not fully created, failing reload",
+			mpp->alias);
+		return 1;
+	}
 
 	return reload_map(vecs, mpp, 0);
 }
@@ -669,6 +674,12 @@ cli_resize(void *v, char **reply, int *len, void *data)
 		return 1;
 	}
 
+	if (mpp->wait_for_udev) {
+		condlog(2, "%s: device not fully created, failing resize",
+			mpp->alias);
+		return 1;
+	}
+
 	pgp = VECTOR_SLOT(mpp->pg, 0);
 
 	if (!pgp){
@@ -833,6 +844,12 @@ cli_reconfigure(void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 
+	if (need_to_delay_reconfig(vecs)) {
+		conf->delayed_reconfig = 1;
+		condlog(2, "delaying reconfigure (operator)");
+		return 0;
+	}
+
 	condlog(2, "reconfigure (operator)");
 
 	return reconfigure(vecs);
@@ -843,17 +860,25 @@ cli_suspend(void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
-	int r = dm_simplecmd_noflush(DM_DEVICE_SUSPEND, param, 0, 0);
+	int r;
+	struct multipath * mpp;
 
 	param = convert_dev(param, 0);
-	condlog(2, "%s: suspend (operator)", param);
+	mpp = find_mp_by_alias(vecs->mpvec, param);
+	if (!mpp)
+		return 1;
 
-	if (!r) /* error */
+	if (mpp->wait_for_udev) {
+		condlog(2, "%s: device not fully created, failing suspend",
+			mpp->alias);
 		return 1;
+	}
 
-	struct multipath * mpp = find_mp_by_alias(vecs->mpvec, param);
+	r = dm_simplecmd_noflush(DM_DEVICE_SUSPEND, param, 0, 0);
 
-	if (!mpp)
+	condlog(2, "%s: suspend (operator)", param);
+
+	if (!r) /* error */
 		return 1;
 
 	dm_get_info(param, &mpp->dmi);
@@ -865,17 +890,25 @@ cli_resume(void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
-	int r = dm_simplecmd_noflush(DM_DEVICE_RESUME, param, 0, 0);
+	int r;
+	struct multipath * mpp;
 
 	param = convert_dev(param, 0);
-	condlog(2, "%s: resume (operator)", param);
+	mpp = find_mp_by_alias(vecs->mpvec, param);
+	if (!mpp)
+		return 1;
 
-	if (!r) /* error */
+	if (mpp->wait_for_udev) {
+		condlog(2, "%s: device not fully created, failing resume",
+			mpp->alias);
 		return 1;
+	}
 
-	struct multipath * mpp = find_mp_by_alias(vecs->mpvec, param);
+	r = dm_simplecmd_noflush(DM_DEVICE_RESUME, param, 0, 0);
 
-	if (!mpp)
+	condlog(2, "%s: resume (operator)", param);
+
+	if (!r) /* error */
 		return 1;
 
 	dm_get_info(param, &mpp->dmi);
@@ -908,9 +941,21 @@ cli_reinstate(void * v, char ** reply, int * len, void * data)
 int
 cli_reassign (void * v, char ** reply, int * len, void * data)
 {
+	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
+	struct multipath *mpp;
 
 	param = convert_dev(param, 0);
+	mpp = find_mp_by_alias(vecs->mpvec, param);
+	if (!mpp)
+		return 1;
+
+	if (mpp->wait_for_udev) {
+		condlog(2, "%s: device not fully created, failing reassign",
+			mpp->alias);
+		return 1;
+	}
+
 	condlog(3, "%s: reset devices (operator)", param);
 
 	dm_reassign(param);
diff --git a/multipathd/main.c b/multipathd/main.c
index 06876b9..f1fdd21 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -262,6 +262,47 @@ flush_map(struct multipath * mpp, struct vectors * vecs, int nopaths)
 	return 0;
 }
 
+int
+update_map (struct multipath *mpp, struct vectors *vecs)
+{
+	int retries = 3;
+	char params[PARAMS_SIZE] = {0};
+
+retry:
+	condlog(4, "%s: updating new map", mpp->alias);
+	if (adopt_paths(vecs->pathvec, mpp, 1)) {
+		condlog(0, "%s: failed to adopt paths for new map update",
+			mpp->alias);
+		retries = -1;
+		goto fail;
+	}
+	verify_paths(mpp, vecs);
+	mpp->flush_on_last_del = FLUSH_UNDEF;
+	mpp->action = ACT_RELOAD;
+
+	if (setup_map(mpp, params, PARAMS_SIZE)) {
+		condlog(0, "%s: failed to setup new map in update", mpp->alias);
+		retries = -1;
+		goto fail;
+	}
+	if (domap(mpp, params) <= 0 && retries-- > 0) {
+		condlog(0, "%s: map_udate sleep", mpp->alias);
+		sleep(1);
+		goto retry;
+	}
+	dm_lib_release();
+
+fail:
+	if (setup_multipath(vecs, mpp))
+		return 1;
+
+	sync_map_state(mpp);
+
+	if (retries < 0)
+		condlog(0, "%s: failed reload in new map update", mpp->alias);
+	return 0;
+}
+
 static int
 uev_add_map (struct uevent * uev, struct vectors * vecs)
 {
@@ -304,6 +345,20 @@ ev_add_map (char * dev, char * alias, struct vectors * vecs)
 	mpp = find_mp_by_alias(vecs->mpvec, alias);
 
 	if (mpp) {
+		if (mpp->wait_for_udev > 1) {
+			if (update_map(mpp, vecs))
+			/* setup multipathd removed the map */
+				return 1;
+		}
+		if (mpp->wait_for_udev) {
+			mpp->wait_for_udev = 0;
+			if (conf->delayed_reconfig &&
+			    !need_to_delay_reconfig(vecs)) {
+				condlog(2, "reconfigure (delayed)");
+				reconfigure(vecs);
+				return 0;
+			}
+		}
 		/*
 		 * Not really an error -- we generate our own uevent
 		 * if we create a multipath mapped device as a result
@@ -495,7 +550,14 @@ ev_add_path (struct path * pp, struct vectors * vecs)
 		condlog(0, "%s: failed to get path uid", pp->dev);
 		goto fail; /* leave path added to pathvec */
 	}
-	mpp = pp->mpp = find_mp_by_wwid(vecs->mpvec, pp->wwid);
+	mpp = find_mp_by_wwid(vecs->mpvec, pp->wwid);
+	if (mpp && mpp->wait_for_udev) {
+		mpp->wait_for_udev = 2;
+		orphan_path(pp, "waiting for create to complete");
+		return 0;
+	}
+
+	pp->mpp = mpp;
 rescan:
 	if (mpp) {
 		if (mpp->size != pp->size) {
@@ -678,6 +740,12 @@ ev_remove_path (struct path *pp, struct vectors * vecs)
 				" removal of path %s", mpp->alias, pp->dev);
 			goto fail;
 		}
+
+		if (mpp->wait_for_udev) {
+			mpp->wait_for_udev = 2;
+			goto out;
+		}
+
 		/*
 		 * reload the map
 		 */
@@ -735,6 +803,11 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 		condlog(2, "%s: update path write_protect to '%d' (uevent)",
 			uev->kernel, ro);
 		if (pp->mpp) {
+			if (pp->mpp->wait_for_udev) {
+				pp->mpp->wait_for_udev = 2;
+				return 0;
+			}
+
 			retval = reload_map(vecs, pp->mpp, 0);
 
 			condlog(2, "%s: map %s reloaded (retval %d)",
@@ -1075,6 +1148,33 @@ followover_should_failback(struct path * pp)
 }
 
 static void
+missing_uev_wait_tick(struct vectors *vecs)
+{
+	struct multipath * mpp;
+	unsigned int i;
+	int timed_out = 0;
+
+	vector_foreach_slot (vecs->mpvec, mpp, i) {
+		if (mpp->wait_for_udev && --mpp->uev_wait_tick <= 0) {
+			timed_out = 1;
+			condlog(0, "%s: timeout waiting on creation uevent. enabling reloads", mpp->alias);
+			if (mpp->wait_for_udev > 1 && update_map(mpp, vecs)) {
+				/* update_map removed map */
+				i--;
+				continue;
+			}
+			mpp->wait_for_udev = 0;
+		}
+	}
+
+	if (timed_out && conf->delayed_reconfig &&
+	    !need_to_delay_reconfig(vecs)) {
+		condlog(2, "reconfigure (delayed)");
+		reconfigure(vecs);
+	}
+}
+
+static void
 defered_failback_tick (vector mpvec)
 {
 	struct multipath * mpp;
@@ -1378,6 +1478,9 @@ check_path (struct vectors * vecs, struct path * pp)
 
 	pp->state = newstate;
 
+
+	if (pp->mpp->wait_for_udev)
+		return 1;
 	/*
 	 * path prio refreshing
 	 */
@@ -1440,6 +1543,7 @@ checkerloop (void *ap)
 		if (vecs->mpvec) {
 			defered_failback_tick(vecs->mpvec);
 			retry_count_tick(vecs->mpvec);
+			missing_uev_wait_tick(vecs);
 		}
 		if (count)
 			count--;
@@ -1545,6 +1649,22 @@ configure (struct vectors * vecs, int start_waiters)
 }
 
 int
+need_to_delay_reconfig(struct vectors * vecs)
+{
+	struct multipath *mpp;
+	int i;
+
+	if (!VECTOR_SIZE(vecs->mpvec))
+		return 0;
+
+	vector_foreach_slot(vecs->mpvec, mpp, i) {
+		if (mpp->wait_for_udev)
+			return 1;
+	}
+	return 0;
+}
+
+int
 reconfigure (struct vectors * vecs)
 {
 	struct config * old = conf;
@@ -1633,12 +1753,18 @@ void
 handle_signals(void)
 {
 	if (reconfig_sig && running_state == DAEMON_RUNNING) {
-		condlog(2, "reconfigure (signal)");
 		pthread_cleanup_push(cleanup_lock,
 				&gvecs->lock);
 		lock(gvecs->lock);
 		pthread_testcancel();
-		reconfigure(gvecs);
+		if (need_to_delay_reconfig(gvecs)) {
+			conf->delayed_reconfig = 1;
+			condlog(2, "delaying reconfigure (signal)");
+		}
+		else {
+			condlog(2, "reconfigure (signal)");
+			reconfigure(gvecs);
+		}
 		lock_cleanup_pop(gvecs->lock);
 	}
 	if (log_reset_sig) {
diff --git a/multipathd/main.h b/multipathd/main.h
index 10378ef..2f706d2 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -18,6 +18,7 @@ extern pid_t daemon_pid;
 
 void exit_daemon(void);
 const char * daemon_status(void);
+int need_to_delay_reconfig (struct vectors *);
 int reconfigure (struct vectors *);
 int ev_add_path (struct path *, struct vectors *);
 int ev_remove_path (struct path *, struct vectors *);
-- 
1.8.3.1
