From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 71/78] Do not automatically fall back to vpd uid
	generation
Date: Mon, 16 Mar 2015 13:36:58 +0100
Message-ID: <1426509425-15978-72-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

When a wwid via uid_attribute cannot be generated we should
not fall back to using sysfs vpd attributes automatically.
The uid_attribute can be set to virtually anything and an
automatic fallback will then generated a different wwid,
leading to an incorrect setup.
A fallback is only valid if the uid_attribute value
is the default setting of 'ID_SERIAL', for which the
format is fixed.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 009ef0c..d1a16e6 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1509,7 +1509,7 @@ static int
 get_uid (struct path * pp)
 {
 	char *c;
-	const char *origin = "none";
+	const char *origin = "unknown";
 	ssize_t len = 0;
 
 	if (!pp->uid_attribute && !pp->getuid)
@@ -1542,35 +1542,28 @@ get_uid (struct path * pp)
 			len = get_udev_uid(pp, pp->uid_attribute);
 			origin = "udev";
 			if (len <= 0)
-				condlog(2,
-					"%s: failed to get UID attribute '%s'",
-					pp->dev, pp->uid_attribute);
+				condlog(1,
+					"%s: failed to get udev uid: %s",
+					pp->dev, strerror(-len));
+
 		}
-		if (len <= 0) {
+		if (len <= 0 &&
+		    !strcmp(pp->uid_attribute, DEFAULT_UID_ATTRIBUTE)) {
 			len = get_vpd_uid(pp);
-			if (len > 0) {
-				origin = "sysfs";
-				pp->uid_attribute = NULL;
-			} else {
-				condlog(2, "%s: failed to get sysfs vpd pg83",
-					pp->dev);
-			}
-		}
-		if (len <= 0) {
-			len = get_vpd_sgio(pp->fd, 0x83, pp->wwid,
-					   WWID_SIZE);
-			if (len > 0) {
+			origin = "sysfs";
+			pp->uid_attribute = NULL;
+			if (len < 0) {
+				condlog(1, "%s: failed to get sysfs uid: %s",
+					pp->dev, strerror(-len));
+				len = get_vpd_sgio(pp->fd, 0x83, pp->wwid,
+						   WWID_SIZE);
 				origin = "sgio";
-				pp->uid_attribute = NULL;
-			} else {
-				condlog(2, "%s: failed to get sgio vpd pg83",
-					pp->dev);
 			}
 		}
 	}
 	if ( len < 0 ) {
-		condlog(1, "%s: failed to get uid: %s",
-			pp->dev, strerror(-len));
+		condlog(1, "%s: failed to get %s uid: %s",
+			pp->dev, origin, strerror(-len));
 		memset(pp->wwid, 0x0, WWID_SIZE);
 	} else {
 		/* Strip any trailing blanks */
-- 
1.8.4.5
