From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 3/3] libmultipath: add ignore_udev_uid option
Date: Tue, 15 Sep 2020 16:45:12 -0500
Message-ID: <1600206312-6497-4-git-send-email-bmarzins@redhat.com>
References: <1600206312-6497-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1600206312-6497-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

Setting this option to yes will force multipath to get the uid by using
the fallback sysfs methods, instead of getting it from udev. This will
cause devices that can't get their uid from the standard locations to
not get a uid. It will also disable uevent merging.

It will not stop uevents from being resent for device that failed to
get a WWID, although I'm on the fence about the benefit of this.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.h      |  1 +
 libmultipath/dict.c        |  4 ++++
 libmultipath/discovery.c   | 17 +++++++++++------
 libmultipath/discovery.h   |  8 +++++++-
 libmultipath/uevent.c      |  2 +-
 multipath/multipath.conf.5 | 13 +++++++++++++
 multipathd/main.c          |  7 ++++++-
 7 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index 2bb7153b..4ad905f5 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -191,6 +191,7 @@ struct config {
 	int find_multipaths_timeout;
 	int marginal_pathgroups;
 	int skip_delegate;
+	int ignore_udev_uid;
 	unsigned int version[3];
 	unsigned int sequence_nr;
 
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index feabae56..79de5d3b 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1391,6 +1391,9 @@ declare_hw_snprint(all_tg_pt, print_yes_no_undef)
 declare_def_handler(marginal_pathgroups, set_yes_no)
 declare_def_snprint(marginal_pathgroups, print_yes_no)
 
+declare_def_handler(ignore_udev_uid, set_yes_no)
+declare_def_snprint(ignore_udev_uid, print_yes_no)
+
 static int
 def_uxsock_timeout_handler(struct config *conf, vector strvec)
 {
@@ -1807,6 +1810,7 @@ init_keywords(vector keywords)
 	install_keyword("enable_foreign", &def_enable_foreign_handler,
 			&snprint_def_enable_foreign);
 	install_keyword("marginal_pathgroups", &def_marginal_pathgroups_handler, &snprint_def_marginal_pathgroups);
+	install_keyword("ignore_udev_uid", &def_ignore_udev_uid_handler, &snprint_def_ignore_udev_uid);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 2096fb48..5c0188ba 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2043,7 +2043,7 @@ static bool has_uid_fallback(struct path *pp)
 
 int
 get_uid (struct path * pp, int path_state, struct udev_device *udev,
-	 int allow_fallback)
+	 int fallback)
 {
 	char *c;
 	const char *origin = "unknown";
@@ -2076,7 +2076,9 @@ get_uid (struct path * pp, int path_state, struct udev_device *udev,
 		} else
 			len = strlen(pp->wwid);
 		origin = "callout";
-	} else {
+	} else if (fallback == UID_FALLBACK_FORCE)
+		len = uid_fallback(pp, path_state, &origin);
+	else {
 		bool udev_available = udev && pp->uid_attribute
 			&& *pp->uid_attribute;
 
@@ -2086,8 +2088,9 @@ get_uid (struct path * pp, int path_state, struct udev_device *udev,
 			if (len == 0)
 				condlog(1, "%s: empty udev uid", pp->dev);
 		}
-		if ((!udev_available || (len <= 0 && allow_fallback))
-		    && has_uid_fallback(pp)) {
+		if ((!udev_available ||
+		     (len <= 0 && fallback == UID_FALLBACK_ALLOW)) &&
+		    has_uid_fallback(pp)) {
 			used_fallback = 1;
 			len = uid_fallback(pp, path_state, &origin);
 		}
@@ -2231,8 +2234,10 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 	}
 
 	if ((mask & DI_WWID) && !strlen(pp->wwid)) {
-		get_uid(pp, path_state, pp->udev,
-			(pp->retriggers >= conf->retrigger_tries));
+		int fallback = conf->ignore_udev_uid? UID_FALLBACK_FORCE :
+			       (pp->retriggers >= conf->retrigger_tries)?
+			       UID_FALLBACK_ALLOW : UID_FALLBACK_NONE;
+		get_uid(pp, path_state, pp->udev, fallback);
 		if (!strlen(pp->wwid)) {
 			if (pp->bus == SYSFS_BUS_UNDEF)
 				return PATHINFO_SKIPPED;
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 6444887d..ca8542d6 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -54,8 +54,14 @@ ssize_t sysfs_get_inquiry(struct udev_device *udev,
 			  unsigned char *buff, size_t len);
 int sysfs_get_asymmetric_access_state(struct path *pp,
 				      char *buff, int buflen);
+
+enum {
+	UID_FALLBACK_NONE,
+	UID_FALLBACK_ALLOW,
+	UID_FALLBACK_FORCE,
+};
 int get_uid(struct path * pp, int path_state, struct udev_device *udev,
-	    int allow_fallback);
+	    int fallback);
 
 /*
  * discovery bitmask
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index d3061bf8..05c8543b 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -177,7 +177,7 @@ static bool uevent_need_merge(void)
 	bool need_merge = false;
 
 	conf = get_multipath_config();
-	if (VECTOR_SIZE(&conf->uid_attrs) > 0)
+	if (!conf->ignore_udev_uid && VECTOR_SIZE(&conf->uid_attrs) > 0)
 		need_merge = true;
 	put_multipath_config(conf);
 
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 5adaced6..b2920df5 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -286,6 +286,19 @@ The default is: \fB<unset>\fR
 .
 .
 .TP
+.B ignore_udev_uid
+Setting this option to yes will force multipath to ignore the the uid_attrs
+and uid_attribute settings, and generate the WWID by the \fIsysfs\fR
+method. This will cause devices that cannot get their WWID from the standard
+locations for their device type to not get a WWID; see \fBWWID generation\fR
+below.
+.RS
+.TP
+The default is: \fBno\fR
+.RE
+.
+.
+.TP
 .B prio
 The name of the path priority routine. The specified routine
 should return a numeric value specifying the relative priority
diff --git a/multipathd/main.c b/multipathd/main.c
index f7229a7d..c522b045 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1279,6 +1279,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 	if (pp) {
 		struct multipath *mpp = pp->mpp;
 		char wwid[WWID_SIZE];
+		int fallback;
 
 		if (pp->initialized == INIT_REQUESTED_UDEV) {
 			needs_reinit = 1;
@@ -1290,7 +1291,11 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 			goto out;
 
 		strcpy(wwid, pp->wwid);
-		rc = get_uid(pp, pp->state, uev->udev, 0);
+		conf = get_multipath_config();
+		fallback = conf->ignore_udev_uid? UID_FALLBACK_FORCE:
+			   UID_FALLBACK_NONE;
+		put_multipath_config(conf);
+		rc = get_uid(pp, pp->state, uev->udev, fallback);
 
 		if (rc != 0)
 			strcpy(pp->wwid, wwid);
-- 
2.17.2
