From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 16/17] multipathd: Don't use fallback code
	after getting wwid
Date: Sat, 30 Mar 2019 01:06:05 -0500
Message-ID: <1553925966-20958-17-git-send-email-bmarzins@redhat.com>
References: <1553925966-20958-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1553925966-20958-1-git-send-email-bmarzins@redhat.com>
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

The fallback code is necessary to set up mutipath devices, if multipath
temporarily can't get the information from udev.  However, once the
devices are set up, udev is the definitive source of this information.

The wwid gotten from the fallback code and the udev code should always
be the same, in which case it doesn't matter where we get the wwid
from. But if they are different, it's important to try to do the
right thing.

Working under the assumption that udev will either never give us this
information, or that it usually will. multipath should assume that if
there are multiple paths to a device, either they will all never get
a wwid from udev, or some of them will likely already have gotten the
correct wwid from udev.  In this case, we should fix this as soon as
possible.

This does mean that devices where udev will never give out the uuid
will not notice if the wwid changes, but that's a small price to pay
for doing the right thing most of the time.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 22 +++++++++-------------
 libmultipath/discovery.h |  3 ++-
 multipathd/main.c        |  2 +-
 3 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 3ec60d6..744cf2c 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1763,7 +1763,6 @@ static ssize_t uid_fallback(struct path *pp, int path_state,
 	    !strcmp(pp->uid_attribute, DEFAULT_UID_ATTRIBUTE)) {
 		len = get_vpd_uid(pp);
 		*origin = "sysfs";
-		pp->uid_attribute = NULL;
 		if (len < 0 && path_state == PATH_UP) {
 			condlog(1, "%s: failed to get sysfs uid: %s",
 				pp->dev, strerror(-len));
@@ -1787,7 +1786,6 @@ static ssize_t uid_fallback(struct path *pp, int path_state,
 			len = WWID_SIZE;
 		}
 		*origin = "sysfs";
-		pp->uid_attribute = NULL;
 	}
 	return len;
 }
@@ -1800,12 +1798,14 @@ static int has_uid_fallback(struct path *pp)
 }
 
 int
-get_uid (struct path * pp, int path_state, struct udev_device *udev)
+get_uid (struct path * pp, int path_state, struct udev_device *udev,
+	 int allow_fallback)
 {
 	char *c;
 	const char *origin = "unknown";
 	ssize_t len = 0;
 	struct config *conf;
+	int used_fallback = 0;
 
 	if (!pp->uid_attribute && !pp->getuid) {
 		conf = get_multipath_config();
@@ -1846,14 +1846,9 @@ get_uid (struct path * pp, int path_state, struct udev_device *udev)
 			len = get_vpd_uid(pp);
 			origin = "sysfs";
 		}
-		if (len <= 0 && has_uid_fallback(pp)) {
-			int retrigger_tries;
-
-			conf = get_multipath_config();
-			retrigger_tries = conf->retrigger_tries;
-			put_multipath_config(conf);
-			if (pp->retriggers >= retrigger_tries)
-				len = uid_fallback(pp, path_state, &origin);
+		if (len <= 0 && allow_fallback && has_uid_fallback(pp)) {
+			used_fallback = 1;
+			len = uid_fallback(pp, path_state, &origin);
 		}
 	}
 	if ( len < 0 ) {
@@ -1870,7 +1865,7 @@ get_uid (struct path * pp, int path_state, struct udev_device *udev)
 			c--;
 		}
 	}
-	condlog(3, "%s: uid = %s (%s)", pp->dev,
+	condlog((used_fallback)? 1 : 3, "%s: uid = %s (%s)", pp->dev,
 		*pp->wwid == '\0' ? "<empty>" : pp->wwid, origin);
 	return 0;
 }
@@ -1994,7 +1989,8 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 	}
 
 	if ((mask & DI_WWID) && !strlen(pp->wwid)) {
-		get_uid(pp, path_state, pp->udev);
+		get_uid(pp, path_state, pp->udev,
+			(pp->retriggers >= conf->retrigger_tries));
 		if (!strlen(pp->wwid)) {
 			if (pp->bus == SYSFS_BUS_UNDEF)
 				return PATHINFO_SKIPPED;
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 9aacf75..8fd126b 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -52,7 +52,8 @@ ssize_t sysfs_get_vpd (struct udev_device * udev, int pg, unsigned char * buff,
 		       size_t len);
 int sysfs_get_asymmetric_access_state(struct path *pp,
 				      char *buff, int buflen);
-int get_uid(struct path * pp, int path_state, struct udev_device *udev);
+int get_uid(struct path * pp, int path_state, struct udev_device *udev,
+	    int allow_fallback);
 
 /*
  * discovery bitmask
diff --git a/multipathd/main.c b/multipathd/main.c
index e4f95a0..1413c6d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1227,7 +1227,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 			goto out;
 
 		strcpy(wwid, pp->wwid);
-		rc = get_uid(pp, pp->state, uev->udev);
+		rc = get_uid(pp, pp->state, uev->udev, 0);
 
 		if (rc != 0)
 			strcpy(pp->wwid, wwid);
-- 
2.17.2
