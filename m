From: Peter Rajnoha <prajnoha@redhat.com>
Subject: [PATCH] Add name checks in dmsetup
Date: Tue, 06 Jan 2009 23:19:12 +0100
Message-ID: <4963D8E0.4080208@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: agk@redhat.com
List-Id: dm-devel.ids

Checks added for DM device names to allow only names < DM_NAME_LEN, otherwise a part of
lengthy name would be silently ignored and could cause confusion while using dmsetup.
Also, the name should not contain '/' character, if it is used in context of creating
a new device or renaming the existing one (because we do not consider full path to devices,
they do not exist in filesystem yet) and appropriate error messages are shown.


diff --git a/libdm/ioctl/libdm-iface.c b/libdm/ioctl/libdm-iface.c
index 05b6894..1dce40e 100644
--- a/libdm/ioctl/libdm-iface.c
+++ b/libdm/ioctl/libdm-iface.c
@@ -1018,6 +1018,16 @@ int dm_task_suppress_identical_reload(struct dm_task *dmt)

  int dm_task_set_newname(struct dm_task *dmt, const char *newname)
  {
+	if (strchr(newname, '/')) {
+		log_error("Name \"%s\" invalid, contains \"/\"", newname);
+		return 0;
+	}
+
+	if (strlen(newname) >= DM_NAME_LEN) {
+		log_error("Name \"%s\" too long", newname);
+		return 0;
+	}
+
  	if (!(dmt->newname = dm_strdup(newname))) {
  		log_error("dm_task_set_newname: strdup(%s) failed", newname);
  		return 0;
diff --git a/libdm/libdm-common.c b/libdm/libdm-common.c
index 26fc043..deff03f 100644
--- a/libdm/libdm-common.c
+++ b/libdm/libdm-common.c
@@ -143,18 +143,27 @@ int dm_task_set_name(struct dm_task *dmt, const char *name)
  	 * as its last component.
  	 */
  	if ((pos = strrchr(name, '/'))) {
+		if (dmt->type == DM_DEVICE_CREATE) {
+			log_error("Name \"%s\" invalid, contains \"/\"", name);
+			return 0;
+		}
+
  		snprintf(path, sizeof(path), "%s/%s", _dm_dir, pos + 1);

  		if (stat(name, &st1) || stat(path, &st2) ||
  		    !(st1.st_dev == st2.st_dev)) {
-			log_error("dm_task_set_name: Device %s not found",
-				  name);
+			log_error("Device %s not found", name);
  			return 0;
  		}

  		name = pos + 1;
  	}

+	if (strlen(name) >= DM_NAME_LEN) {
+		log_error("Name \"%s\" too long", name);
+		return 0;
+	}
+
  	if (!(dmt->dev_name = dm_strdup(name))) {
  		log_error("dm_task_set_name: strdup(%s) failed", name);
  		return 0;
