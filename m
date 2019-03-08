From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 12/12] multipathd: change failed get_uid
	handling
Date: Fri,  8 Mar 2019 17:12:05 -0600
Message-ID: <1552086725-18476-13-git-send-email-bmarzins@redhat.com>
References: <1552086725-18476-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1552086725-18476-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Instead of ignoring failed get_uid() calls, multipathd now fails the
path as it originally did. However, if the result of calling get_uid()
is a blank wwid (which is always the case when it fails), multipathd now
tries to get the wwid in check_path() as well, using the uid_fallback()
methods to attempt to get a valid wwid.

Multipathd can't use the uid_attribute methods, since pp->udev still has
the old uevent information with the uid_attribute of the original wwid.
This means that the uid_attribute methods would always return the
original wwid, even if it had changed.

To make the get_uid() use the fallback methods, pathinfo now sets
pp->retriggers to the retrigger_tries once a WWID has be successfully
obtained, so that it uid_fallback() doesn't need to be called
retrigger_tries times before trying the fallback methods.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c |  4 +++-
 libmultipath/structs.h   |  6 ++++++
 multipathd/main.c        | 36 +++++++++++++++++++++++++-----------
 3 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index bece67c..15568ca 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2018,8 +2018,10 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 		}
 	}
 
-	if ((mask & DI_ALL) == DI_ALL)
+	if ((mask & DI_ALL) == DI_ALL) {
+		pp->retriggers = conf->retrigger_tries;
 		pp->initialized = INIT_OK;
+	}
 	return PATHINFO_OK;
 
 blank:
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index b794b0d..6e4b871 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -221,6 +221,12 @@ enum all_tg_pt_states {
 	ALL_TG_PT_ON = YNU_YES,
 };
 
+enum wwid_changed_states {
+	WWID_SAME = 0,
+	WWID_ZEROED,
+	WWID_CHANGED,
+};
+
 struct sg_id {
 	int host_no;
 	int channel;
diff --git a/multipathd/main.c b/multipathd/main.c
index 7a317d9..2331c41 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1234,27 +1234,27 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 			goto out;
 
 		strcpy(wwid, pp->wwid);
-		rc = get_uid(pp, pp->state, uev->udev);
+		get_uid(pp, pp->state, uev->udev);
 
-		if (rc != 0)
-			strcpy(pp->wwid, wwid);
-		else if (strncmp(wwid, pp->wwid, WWID_SIZE) != 0) {
+		if (strncmp(wwid, pp->wwid, WWID_SIZE) != 0) {
+			int wwid_changed = (strlen(pp->wwid))? WWID_CHANGED :
+							       WWID_ZEROED;
 			condlog(0, "%s: path wwid changed from '%s' to '%s'. %s",
 				uev->kernel, wwid, pp->wwid,
 				(disable_changed_wwids ? "disallowing" :
 				 "continuing"));
 			strcpy(pp->wwid, wwid);
 			if (disable_changed_wwids) {
-				if (!pp->wwid_changed) {
-					pp->wwid_changed = 1;
+				if (pp->wwid_changed == WWID_SAME) {
 					pp->tick = 1;
 					if (pp->mpp)
 						dm_fail_path(pp->mpp->alias, pp->dev_t);
 				}
+				pp->wwid_changed = wwid_changed;
 				goto out;
 			}
 		} else {
-			pp->wwid_changed = 0;
+			pp->wwid_changed = WWID_SAME;
 			udev_device_unref(pp->udev);
 			pp->udev = udev_device_ref(uev->udev);
 			conf = get_multipath_config();
@@ -2017,10 +2017,24 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	if (newstate == PATH_REMOVED)
 		newstate = PATH_DOWN;
 
-	if (pp->wwid_changed) {
-		condlog(2, "%s: path wwid has changed. Refusing to use",
-			pp->dev);
-		newstate = PATH_DOWN;
+	if (pp->wwid_changed != WWID_SAME) {
+		if (pp->wwid_changed == WWID_ZEROED) {
+			char wwid[WWID_SIZE];
+
+			strcpy(wwid, pp->wwid);
+			get_uid(pp, newstate, NULL);
+			if (strncmp(wwid, pp->wwid, WWID_SIZE) == 0)
+				pp->wwid_changed = WWID_SAME;
+			else {
+				pp->wwid_changed = (strlen(pp->wwid))? WWID_CHANGED : WWID_ZEROED;
+				strcpy(pp->wwid, wwid);
+			}
+		}
+		if (pp->wwid_changed != WWID_SAME) {
+			condlog(2, "%s: path wwid has changed. Refusing to use",
+				pp->dev);
+			newstate = PATH_DOWN;
+		}
 	}
 
 	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED) {
-- 
2.17.2
