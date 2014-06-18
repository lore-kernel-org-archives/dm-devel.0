From: "Merla, ShivaKrishna" <ShivaKrishna.Merla@netapp.com>
Subject: [PATCH ] multipath: Fall back to getuid_callout if
 ID_SERIAL attribute is missing.
Date: Wed, 18 Jun 2014 00:17:11 +0000
Message-ID: <229730203dc540ef9cae7b665577519c@hioexcmbx01-prd.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

 Sometimes whenever a path is added, scsi_id call during udev rule processing
 can fail and ID_SERIAL attribute will not be set. This causes multipathd to add
 the path as orphan. We have seen several instances of this happening during
 testing.

      Jun 17 10:14:43 ictm-vader multipathd[474]: sda: uid_attribute = ID_SERIAL (config file default)
      Jun 17 10:14:43 ictm-vader multipathd[474]: sda: no ID_SERIAL attribute
      Jun 17 10:14:43 ictm-vader multipathd[474]: sda: uid = <empty> (udev)
      Jun 17 10:14:43 ictm-vader multipathd[474]: sda: no ID_SERIAL attribute
      Jun 17 10:14:43 ictm-vader multipathd[474]: sda: uid = <empty> (udev)
      Jun 17 10:14:43 ictm-vader multipathd[474]: sda: failed to get path uid
      Jun 17 10:14:43 ictm-vader multipathd[474]: sda: orphan path, failed to add path
 
 This patch handles this case by allowing to fall back to explict getuid_callout
 incase if ID_SERIAL attribute is not set. This way support for deprecated
 getuid_callout is not lost for older versions where ID_SERIAL attribute is not
 present but also serves good purpose in the scenario mentioned above.

Signed-off-by: Shiva Krishna Merla<shivakrishna.merla@netapp.com>
 ---
 libmultipath/defaults.h  |    1 +
 libmultipath/discovery.c |   59 +++++++++++++++++++++------------------------
 libmultipath/propsel.c   |   29 ++++++++++++----------
 3 files changed, 45 insertions(+), 44 deletions(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index b83d9fb..47bd7ba 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -1,4 +1,5 @@
 #define DEFAULT_UID_ATTRIBUTE	"ID_SERIAL"
+#define DEFAULT_GETUID		"/lib/udev/scsi_id --whitelisted --device=/dev/%n"
 #define DEFAULT_UDEVDIR		"/dev"
 #define DEFAULT_MULTIPATHDIR	"/" LIB_STRING "/multipath"
 #define DEFAULT_SELECTOR	"service-time 0"
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 786e1de..7cf674d 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1098,7 +1098,8 @@ static int
 get_uid (struct path * pp)
 {
 	char *c;
-	const char *origin;
+	const char *origin = "udev";
+	const char *value;
 
 	if (!pp->uid_attribute && !pp->getuid)
 		select_getuid(pp);
@@ -1109,40 +1110,36 @@ get_uid (struct path * pp)
 	}
 
 	memset(pp->wwid, 0, WWID_SIZE);
-	if (pp->getuid) {
-		char buff[CALLOUT_MAX_SIZE];
-
-		/* Use 'getuid' callout, deprecated */
-		condlog(1, "%s: using deprecated getuid callout", pp->dev);
-		if (apply_format(pp->getuid, &buff[0], pp)) {
-			condlog(0, "error formatting uid callout command");
-			memset(pp->wwid, 0, WWID_SIZE);
-		} else if (execute_program(buff, pp->wwid, WWID_SIZE)) {
-			condlog(3, "error calling out %s", buff);
-			memset(pp->wwid, 0, WWID_SIZE);
+
+	value = udev_device_get_property_value(pp->udev,
+					       pp->uid_attribute);
+	if ((!value || strlen(value) == 0) && conf->dry_run == 2)
+		value = getenv(pp->uid_attribute);
+	if (value && strlen(value)) {
+		size_t len = WWID_SIZE;
+
+		if (strlen(value) + 1 > WWID_SIZE) {
+			condlog(0, "%s: wwid overflow", pp->dev);
+		} else {
+			len = strlen(value);
 		}
-		origin = "callout";
+		strncpy(pp->wwid, value, len);
 	} else {
-		const char *value;
-
-		value = udev_device_get_property_value(pp->udev,
-						       pp->uid_attribute);
-		if ((!value || strlen(value) == 0) && conf->dry_run == 2)
-			value = getenv(pp->uid_attribute);
-		if (value && strlen(value)) {
-			size_t len = WWID_SIZE;
-
-			if (strlen(value) + 1 > WWID_SIZE) {
-				condlog(0, "%s: wwid overflow", pp->dev);
-			} else {
-				len = strlen(value);
+		condlog(3, "%s: no %s attribute", pp->dev,
+			pp->uid_attribute);
+		if (pp->getuid) {
+			char buff[CALLOUT_MAX_SIZE];
+			/* Use 'getuid' callout, deprecated */
+			 condlog(1, "%s: using deprecated getuid callout", pp->dev);
+			if (apply_format(pp->getuid, &buff[0], pp)) {
+				condlog(0, "error formatting uid callout command");
+				memset(pp->wwid, 0, WWID_SIZE);
+			} else if (execute_program(buff, pp->wwid, WWID_SIZE)) {
+				condlog(3, "error calling out %s", buff);
+				memset(pp->wwid, 0, WWID_SIZE);
 			}
-			strncpy(pp->wwid, value, len);
-		} else {
-			condlog(3, "%s: no %s attribute", pp->dev,
-				pp->uid_attribute);
+			origin = "callout";
 		}
-		origin = "udev";
 	}
 	/* Strip any trailing blanks */
 	c = strchr(pp->wwid, '\0');
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index ee6cea6..b8a155c 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -379,29 +379,32 @@ select_getuid (struct path * pp)
 		pp->uid_attribute = pp->hwe->uid_attribute;
 		condlog(3, "%s: uid_attribute = %s (controller setting)",
 			pp->dev, pp->uid_attribute);
-		return 0;
+	}
+	else if (conf->uid_attribute) {
+		pp->uid_attribute = conf->uid_attribute;
+		condlog(3, "%s: uid_attribute = %s (config file default)",
+			pp->dev, pp->uid_attribute);
+	}
+	else {
+		pp->uid_attribute = STRDUP(DEFAULT_UID_ATTRIBUTE);
+		condlog(3, "%s: uid_attribute = %s (internal default)",
+		pp->dev, pp->uid_attribute);
 	}
 	if (pp->hwe && pp->hwe->getuid) {
 		pp->getuid = pp->hwe->getuid;
 		condlog(3, "%s: getuid = %s (deprecated) (controller setting)",
 			pp->dev, pp->getuid);
-		return 0;
 	}
-	if (conf->uid_attribute) {
-		pp->uid_attribute = conf->uid_attribute;
-		condlog(3, "%s: uid_attribute = %s (config file default)",
-			pp->dev, pp->uid_attribute);
-		return 0;
-	}
-	if (conf->getuid) {
+	else if (conf->getuid) {
 		pp->getuid = conf->getuid;
 		condlog(3, "%s: getuid = %s (deprecated) (config file default)",
 			pp->dev, pp->getuid);
-		return 0;
 	}
-	pp->uid_attribute = STRDUP(DEFAULT_UID_ATTRIBUTE);
-	condlog(3, "%s: uid_attribute = %s (internal default)",
-		pp->dev, pp->uid_attribute);
+	else {
+		pp->getuid = STRDUP(DEFAULT_GETUID);
+		condlog(3, "%s: getuid = %s (deprecated) (internal default)",
+			pp->dev, pp->getuid);
+	}
 	return 0;
 }
--
