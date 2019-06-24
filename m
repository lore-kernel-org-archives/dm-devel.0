From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 25/30] libmultipath: get_uid: straighten the
	fallback logic
Date: Mon, 24 Jun 2019 11:27:51 +0200
Message-ID: <20190624092756.7769-27-mwilck@suse.com>
References: <20190624092756.7769-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190624092756.7769-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The code had two distinct fallback paths, with non-obvious logic.
Try to straighten it out. The "allow_fallback" logic from
ffaf9477d115 "multipathd: Don't use fallback code after getting wwid"
should only apply in the case where get_udev_uid() failed, not
if it wasn't even tried. Moreover, uid_attribute is hardly ever NULL
since ffaf9477; allow the user to set it to the empty string to
skip udev-based WWID determination. This is rather not meant for
production, but it's useful for testing. Finally, only set "origin"
to "udev" if a WWID was actually retrieved from udev.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index b10afdef..d7eaee68 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1876,20 +1876,20 @@ get_uid (struct path * pp, int path_state, struct udev_device *udev,
 			len = strlen(pp->wwid);
 		origin = "callout";
 	} else {
+		bool udev_available = udev && pp->uid_attribute
+			&& *pp->uid_attribute;
 
-		if (udev && pp->uid_attribute) {
+		if (udev_available) {
 			len = get_udev_uid(pp, pp->uid_attribute, udev);
-			origin = "udev";
 			if (len <= 0)
 				condlog(1,
 					"%s: failed to get udev uid: %s",
 					pp->dev, strerror(-len));
-
-		} else if (pp->bus == SYSFS_BUS_SCSI) {
-			len = get_vpd_uid(pp);
-			origin = "sysfs";
+			else
+				origin = "udev";
 		}
-		if (len <= 0 && allow_fallback && has_uid_fallback(pp)) {
+		if ((!udev_available || (len <= 0 && allow_fallback))
+		    && has_uid_fallback(pp)) {
 			used_fallback = 1;
 			len = uid_fallback(pp, path_state, &origin);
 		}
-- 
2.21.0
