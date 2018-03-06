From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/4] libmultipath: get_uid: don't quit
	prematurely without udev
Date: Tue,  6 Mar 2018 23:15:48 +0100
Message-ID: <20180306221550.10030-3-mwilck@suse.com>
References: <20180306221550.10030-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180306221550.10030-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Chongyun Wu <wu.chongyun@h3c.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Not all the implemented methods to derive the UID rely on udev
information being present. For example getuid callout, rbd,
and the SCSI vpd code work fine without it. It's unlikely that
we don't get udev data, but we want to be as good as possible
at deriving the uid.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 53182a85fa10..9f2a9c907914 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1853,11 +1853,6 @@ get_uid (struct path * pp, int path_state, struct udev_device *udev)
 		put_multipath_config(conf);
 	}
 
-	if (!udev) {
-		condlog(1, "%s: no udev information", pp->dev);
-		return 1;
-	}
-
 	memset(pp->wwid, 0, WWID_SIZE);
 	if (pp->getuid) {
 		char buff[CALLOUT_MAX_SIZE];
@@ -1881,7 +1876,7 @@ get_uid (struct path * pp, int path_state, struct udev_device *udev)
 		origin = "sysfs";
 	} else {
 
-		if (pp->uid_attribute) {
+		if (udev && pp->uid_attribute) {
 			len = get_udev_uid(pp, pp->uid_attribute, udev);
 			origin = "udev";
 			if (len <= 0)
@@ -1900,6 +1895,7 @@ get_uid (struct path * pp, int path_state, struct udev_device *udev)
 		condlog(1, "%s: failed to get %s uid: %s",
 			pp->dev, origin, strerror(-len));
 		memset(pp->wwid, 0x0, WWID_SIZE);
+		return 1;
 	} else {
 		/* Strip any trailing blanks */
 		c = strchr(pp->wwid, '\0');
-- 
2.16.1
