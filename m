From: Craig <craig@haquarter.de>
Subject: [PATCH] fix-linebreaks
Date: Sat, 20 Aug 2011 00:16:55 +0200
Message-ID: <4E4EE0D7.9020706@haquarter.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010006030605060707000502"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------010006030605060707000502
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi,

error messages (DM message failed) in the logs look like this in multipath:

Jul 24 06:17:47 onosendai multipathd: DM message failed [queue_if_no_path
Jul 24 06:17:47 onosendai ]
Jul 24 06:17:47 onosendai multipathd: sdc: alua not supported
Jul 24 06:17:47 onosendai multipathd: sdd: alua not supported
Jul 24 06:17:47 onosendai multipathd: DM message failed [queue_if_no_path
Jul 24 06:17:47 onosendai ]

The patch fixes the unneccessary \n in libmultipath/devmapper.c

Best regards,

Craig

--------------010006030605060707000502
Content-Type: text/plain;
 name="0001-fix-linebreaks.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-fix-linebreaks.patch"

From bb1354f917b7bd205605a41016e0a3e1aff6feac Mon Sep 17 00:00:00 2001
From: craig <craig@haquarter.de>
Date: Sun, 24 Jul 2011 06:38:55 +0200
Subject: [PATCH] fix linebreaks

---
 libmultipath/devmapper.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index a70ae0a..de7d446 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -776,7 +776,7 @@ dm_fail_path(char * mapname, char * path)
 {
 	char message[32];
 
-	if (snprintf(message, 32, "fail_path %s\n", path) > 32)
+	if (snprintf(message, 32, "fail_path %s", path) > 32)
 		return 1;
 
 	return dm_message(mapname, message);
@@ -787,7 +787,7 @@ dm_reinstate_path(char * mapname, char * path)
 {
 	char message[32];
 
-	if (snprintf(message, 32, "reinstate_path %s\n", path) > 32)
+	if (snprintf(message, 32, "reinstate_path %s", path) > 32)
 		return 1;
 
 	return dm_message(mapname, message);
@@ -799,9 +799,9 @@ dm_queue_if_no_path(char *mapname, int enable)
 	char *message;
 
 	if (enable)
-		message = "queue_if_no_path\n";
+		message = "queue_if_no_path";
 	else
-		message = "fail_if_no_path\n";
+		message = "fail_if_no_path";
 
 	return dm_message(mapname, message);
 }
@@ -821,7 +821,7 @@ dm_groupmsg (char * msg, char * mapname, int index)
 {
 	char message[32];
 
-	if (snprintf(message, 32, "%s_group %i\n", msg, index) > 32)
+	if (snprintf(message, 32, "%s_group %i", msg, index) > 32)
 		return 1;
 
 	return dm_message(mapname, message);
-- 
1.7.3.4


--------------010006030605060707000502
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------010006030605060707000502--
