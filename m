From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 04/18] retrigger uevents to try and get the uid
	through udev
Date: Thu,  8 Oct 2015 14:44:37 -0500
Message-ID: <1444333491-16265-5-git-send-email-bmarzins@redhat.com>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
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

Ideally, udev will be able to grab the wwid when a path device is
discovered, but sometimes this isn't possible. In these cases, the
best thing that could happen would be for udev to actually get the
information, and add it to its database. This patch makes multipath
retrigger uevents a limited number of times before giving up and
trying to get the information itself.

There are two configurables that control how it does this,
"retrigger_tries" and "retrigger_delay". The first sets the number of
times it will try to retrigger a uevent to get the wwid, the second
sets the amount of time to wait between retriggers.

This patch currently only tries reinitializing the path on change events
after multipathd has triggered a change event, and it only tries once
per triggered change event.  Now, its possible that other change events
could occur on the device without multipathd tirggering them.  As the
patch stands now, it won't try to initialize the device on those.  It will,
however still try in the checkerloop, but only after it has finished
retriggering the uevents. We could be much more aggressive here, and assume
that devices that simply won't have a WWID should already be taken care of
by the blacklists, so it would be always a good idea to recheck devices on
change events. What would be ideal is if udev would let us know when it had
problems or timed out when processing a uevent, so we would know if
retiggering the uevent would be useful.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c    |  2 ++
 libmultipath/config.h    |  2 ++
 libmultipath/defaults.h  |  2 ++
 libmultipath/dict.c      |  8 ++++++++
 libmultipath/discovery.c | 28 ++++++++++++++++------------
 libmultipath/structs.h   |  8 ++++++++
 multipathd/main.c        | 25 ++++++++++++++++++-------
 7 files changed, 56 insertions(+), 19 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index c788cf6..cfcc685 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -619,6 +619,8 @@ load_config (char * file, struct udev *udev)
 	conf->find_multipaths = DEFAULT_FIND_MULTIPATHS;
 	conf->uxsock_timeout = DEFAULT_UXSOCK_TIMEOUT;
 	conf->uid_attribute = set_default(DEFAULT_UID_ATTRIBUTE);
+	conf->retrigger_tries = DEFAULT_RETRIGGER_TRIES;
+	conf->retrigger_delay = DEFAULT_RETRIGGER_DELAY;
 
 	/*
 	 * preload default hwtable
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 0183969..372eace 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -135,6 +135,8 @@ struct config {
 	int delay_watch_checks;
 	int delay_wait_checks;
 	int uxsock_timeout;
+	int retrigger_tries;
+	int retrigger_delay;
 	unsigned int version[3];
 
 	char * dev;
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 79d6b91..025a016 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -21,6 +21,8 @@
 #define DEFAULT_DELAY_CHECKS DELAY_CHECKS_OFF
 #define DEFAULT_UEVENT_STACKSIZE 256
 #define DEFAULT_UXSOCK_TIMEOUT  1000
+#define DEFAULT_RETRIGGER_DELAY 10
+#define DEFAULT_RETRIGGER_TRIES 3
 
 #define DEFAULT_CHECKINT	5
 #define MAX_CHECKINT(a)		(a << 2)
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 5c2da43..e3bc67e 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -389,6 +389,12 @@ declare_hw_snprint(deferred_remove, print_yes_no_undef)
 declare_mp_handler(deferred_remove, set_yes_no_undef)
 declare_mp_snprint(deferred_remove, print_yes_no_undef)
 
+declare_def_handler(retrigger_tries, set_int)
+declare_def_snprint(retrigger_tries, print_int)
+
+declare_def_handler(retrigger_delay, set_int)
+declare_def_snprint(retrigger_delay, print_int)
+
 static int
 def_config_dir_handler(vector strvec)
 {
@@ -1365,6 +1371,8 @@ init_keywords(void)
 	install_keyword("delay_wait_checks", &def_delay_wait_checks_handler, &snprint_def_delay_wait_checks);
 	install_keyword("find_multipaths", &def_find_multipaths_handler, &snprint_def_find_multipaths);
 	install_keyword("uxsock_timeout", &def_uxsock_timeout_handler, &snprint_def_uxsock_timeout);
+	install_keyword("retrigger_tries", &def_retrigger_tries_handler, &snprint_def_retrigger_tries);
+	install_keyword("retrigger_delay", &def_retrigger_delay_handler, &snprint_def_retrigger_delay);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 4582a20..bd65354 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1547,7 +1547,7 @@ get_uid (struct path * pp)
 					pp->dev, strerror(-len));
 
 		}
-		if (len <= 0 &&
+		if (len <= 0 && pp->retriggers >= conf->retrigger_tries &&
 		    !strcmp(pp->uid_attribute, DEFAULT_UID_ATTRIBUTE)) {
 			len = get_vpd_uid(pp);
 			origin = "sysfs";
@@ -1651,11 +1651,19 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 		}
 	}
 
-	if ((mask & DI_WWID) && !strlen(pp->wwid))
+	if ((mask & DI_WWID) && !strlen(pp->wwid)) {
 		get_uid(pp);
+		if (!strlen(pp->wwid)) {
+			pp->initialized = INIT_MISSING_UDEV;
+			pp->tick = conf->retrigger_delay;
+			return PATHINFO_OK;
+		}
+		else
+			pp->tick = 1;
+	}
+
 	if (mask & DI_BLACKLIST && mask & DI_WWID) {
-		if (!strlen(pp->wwid) ||
-		    filter_wwid(conf->blist_wwid, conf->elist_wwid,
+		if (filter_wwid(conf->blist_wwid, conf->elist_wwid,
 				pp->wwid, pp->dev) > 0) {
 			return PATHINFO_SKIPPED;
 		}
@@ -1665,17 +1673,13 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 	  * Retrieve path priority, even for PATH_DOWN paths if it has never
 	  * been successfully obtained before.
 	  */
-	if ((mask & DI_PRIO) && path_state == PATH_UP) {
+	if ((mask & DI_PRIO) && path_state == PATH_UP && strlen(pp->wwid)) {
 		if (pp->state != PATH_DOWN || pp->priority == PRIO_UNDEF) {
-			if (!strlen(pp->wwid))
-				get_uid(pp);
-			if (!strlen(pp->wwid))
-				return PATHINFO_SKIPPED;
 			get_prio(pp);
 		}
 	}
 
-	pp->initialized = 1;
+	pp->initialized = INIT_OK;
 	return PATHINFO_OK;
 
 blank:
@@ -1684,7 +1688,7 @@ blank:
 	 */
 	memset(pp->wwid, 0, WWID_SIZE);
 	pp->chkrstate = pp->state = PATH_DOWN;
-	pp->initialized = 0;
+	pp->initialized = INIT_FAILED;
 
-	return 0;
+	return PATHINFO_OK;
 }
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index c1fce04..85a8fdc 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -145,6 +145,13 @@ enum delay_checks_states {
 	DELAY_CHECKS_UNDEF = 0,
 };
 
+enum initialized_states {
+	INIT_FAILED,
+	INIT_MISSING_UDEV,
+	INIT_REQUESTED_UDEV,
+	INIT_OK,
+};
+
 struct sg_id {
 	int host_no;
 	int channel;
@@ -201,6 +208,7 @@ struct path {
 	struct multipath * mpp;
 	int fd;
 	int initialized;
+	int retriggers;
 
 	/* configlet pointers */
 	struct hwentry * hwe;
diff --git a/multipathd/main.c b/multipathd/main.c
index 360a584..ea67324 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -457,11 +457,6 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 		condlog(3, "%s: failed to get path info", uev->kernel);
 		return 1;
 	}
-	if (!strlen(pp->wwid)) {
-		condlog(3, "%s: Failed to get path wwid", uev->kernel);
-		free_path(pp);
-		return 1;
-	}
 	ret = store_path(vecs->pathvec, pp);
 	if (!ret) {
 		pp->checkint = conf->checkint;
@@ -729,6 +724,10 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 			uev->kernel);
 		return 1;
 	}
+
+	if (pp->initialized == INIT_REQUESTED_UDEV)
+		return uev_add_path(uev, vecs);
+
 	/* reinit the prio values on change event, in case something is
 	 * different */
 	prio_init(&pp->prio);
@@ -1164,12 +1163,24 @@ check_path (struct vectors * vecs, struct path * pp)
 	int add_active;
 	int oldchkrstate = pp->chkrstate;
 
-	if (pp->initialized && !pp->mpp)
+	if ((pp->initialized == INIT_OK ||
+	     pp->initialized == INIT_REQUESTED_UDEV) && !pp->mpp)
 		return 0;
 
 	if (pp->tick && --pp->tick)
 		return 0; /* don't check this path yet */
 
+	if (!pp->mpp && pp->initialized == INIT_MISSING_UDEV &&
+	    pp->retriggers < conf->retrigger_tries) {
+		condlog(2, "%s: triggering change event to reinitialize",
+			pp->dev);
+		pp->initialized = INIT_REQUESTED_UDEV;
+		pp->retriggers++;
+		sysfs_attr_set_value(pp->udev, "uevent", "change",
+				     strlen("change"));
+		return 0;
+	} 
+
 	/*
 	 * provision a next check soonest,
 	 * in case we exit abnormaly from here
@@ -1196,7 +1207,7 @@ check_path (struct vectors * vecs, struct path * pp)
 		return 1;
 	}
 	if (!pp->mpp) {
-		if (!strlen(pp->wwid) &&
+		if (!strlen(pp->wwid) && pp->initialized != INIT_MISSING_UDEV &&
 		    (newstate == PATH_UP || newstate == PATH_GHOST)) {
 			condlog(2, "%s: add missing path", pp->dev);
 			if (pathinfo(pp, conf->hwtable, DI_ALL) == 0) {
-- 
1.8.3.1
