From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] Fix for setting '0' to fast_io_fail
Date: Mon, 12 Mar 2012 20:43:55 +0900
Message-ID: <4F5DE17B.5090003@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
To: device-mapper development <dm-devel@redhat.com>, christophe.varoqui@free.fr
List-Id: dm-devel.ids

Hi Christophe,

In kernel, '0' is valid value for fast_io_fail, meaning immediate
termination of ios on rport delete.
However, '0' is treated as 'not-configured' in various places of
multipath-tools and it is not possible to set 0 to fast_io_fail.

Attached patch fixes that by introducing MP_FAST_IO_FAIL_ZERO
as internal representation of zero value.

-- 
Jun'ichi Nomura, NEC Corporation


diff --git a/libmultipath/config.h b/libmultipath/config.h
index 234e7e6..6fcd45e 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -7,6 +7,13 @@
 #define ORIGIN_DEFAULT 0
 #define ORIGIN_CONFIG  1
 
+/*
+ * In kernel, fast_io_fail == 0 means immediate failure on rport delete.
+ * OTOH '0' means not-configured in various places in multipath-tools.
+ */
+#define MP_FAST_IO_FAIL_OFF (-1)
+#define MP_FAST_IO_FAIL_ZERO (-2)
+
 enum devtypes {
 	DEV_NONE,
 	DEV_DEVT,
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index dd567bd..4df3d9b 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -44,10 +44,12 @@ def_fast_io_fail_handler(vector strvec)
 
 	buff = set_value(strvec);
 	if (strlen(buff) == 3 && !strcmp(buff, "off"))
-		conf->fast_io_fail = -1;
+		conf->fast_io_fail = MP_FAST_IO_FAIL_OFF;
 	else if (sscanf(buff, "%d", &conf->fast_io_fail) != 1 ||
-		 conf->fast_io_fail < -1)
+		 conf->fast_io_fail < MP_FAST_IO_FAIL_ZERO)
 		conf->fast_io_fail = 0;
+	else if (conf->fast_io_fail == 0)
+		conf->fast_io_fail = MP_FAST_IO_FAIL_ZERO;
 
 	FREE(buff);
 	return 0;
@@ -873,10 +875,12 @@ hw_fast_io_fail_handler(vector strvec)
 
 	buff = set_value(strvec);
 	if (strlen(buff) == 3 && !strcmp(buff, "off"))
-		hwe->fast_io_fail = -1;
+		hwe->fast_io_fail = MP_FAST_IO_FAIL_OFF;
 	else if (sscanf(buff, "%d", &hwe->fast_io_fail) != 1 ||
-		 hwe->fast_io_fail < -1)
+		 hwe->fast_io_fail < MP_FAST_IO_FAIL_ZERO)
 		hwe->fast_io_fail = 0;
+	else if (hwe->fast_io_fail == 0)
+		hwe->fast_io_fail = MP_FAST_IO_FAIL_ZERO;
 
 	FREE(buff);
 	return 0;
@@ -1900,8 +1904,10 @@ snprint_hw_fast_io_fail(char * buff, int len, void * data)
 		return 0;
 	if (hwe->fast_io_fail == conf->fast_io_fail)
 		return 0;
-	if (hwe->fast_io_fail == -1)
+	if (hwe->fast_io_fail == MP_FAST_IO_FAIL_OFF)
 		return snprintf(buff, len, "off");
+	if (hwe->fast_io_fail == MP_FAST_IO_FAIL_ZERO)
+		return snprintf(buff, len, "0");
 	return snprintf(buff, len, "%d", hwe->fast_io_fail);
 }
 
@@ -2190,8 +2196,10 @@ snprint_def_fast_io_fail(char * buff, int len, void * data)
 {
 	if (!conf->fast_io_fail)
 		return 0;
-	if (conf->fast_io_fail == -1)
+	if (conf->fast_io_fail == MP_FAST_IO_FAIL_OFF)
 		return snprintf(buff, len, "off");
+	if (conf->fast_io_fail == MP_FAST_IO_FAIL_ZERO)
+		return snprintf(buff, len, "0");
 	return snprintf(buff, len, "%d", conf->fast_io_fail);
 }
 
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 16f786d..2019554 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -334,7 +334,7 @@ sysfs_set_scsi_tmo (struct multipath *mpp)
 			if (sysfs_attr_set_value(attr_path, "dev_loss_tmo",
 						 value, 11) < 0) {
 				int err = 1;
-				if (mpp->fast_io_fail <= 0 && mpp->dev_loss > 600) {
+				if ((!mpp->fast_io_fail || mpp->fast_io_fail == MP_FAST_IO_FAIL_OFF) && mpp->dev_loss > 600) {
 					strncpy(value, "600", 4);
 					condlog(3, "%s: limiting dev_loss_tmo to 600, since fast_io_fail is not set", mpp->alias);
 					if (sysfs_attr_set_value(attr_path, "dev_loss_tmo", value, 11) >= 0)
@@ -347,8 +347,10 @@ sysfs_set_scsi_tmo (struct multipath *mpp)
 			}
 		}
 		if (mpp->fast_io_fail){
-			if (mpp->fast_io_fail == -1)
+			if (mpp->fast_io_fail == MP_FAST_IO_FAIL_OFF)
 				sprintf(value, "off");
+			else if (mpp->fast_io_fail == MP_FAST_IO_FAIL_ZERO)
+				sprintf(value, "0");
 			else
 				snprintf(value, 11, "%u", mpp->fast_io_fail);
 			if (sysfs_attr_set_value(attr_path, "fast_io_fail_tmo",
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index b241ecb..10aec29 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -550,18 +550,20 @@ select_fast_io_fail(struct multipath *mp)
 {
 	if (mp->hwe && mp->hwe->fast_io_fail) {
 		mp->fast_io_fail = mp->hwe->fast_io_fail;
-		if (mp->fast_io_fail == -1)
+		if (mp->fast_io_fail == MP_FAST_IO_FAIL_OFF)
 			condlog(3, "%s: fast_io_fail_tmo = off (controller default)", mp->alias);
 		else
-			condlog(3, "%s: fast_io_fail_tmo = %d (controller default)", mp->alias, mp->fast_io_fail);
+			condlog(3, "%s: fast_io_fail_tmo = %d (controller default)", mp->alias,
+				mp->fast_io_fail == MP_FAST_IO_FAIL_ZERO ? 0 : mp->fast_io_fail);
 		return 0;
 	}
 	if (conf->fast_io_fail) {
 		mp->fast_io_fail = conf->fast_io_fail;
-		if (mp->fast_io_fail == -1)
+		if (mp->fast_io_fail == MP_FAST_IO_FAIL_OFF)
 			condlog(3, "%s: fast_io_fail_tmo = off (config file default)", mp->alias);
 		else
-			condlog(3, "%s: fast_io_fail_tmo = %d (config file default)", mp->alias, mp->fast_io_fail);
+			condlog(3, "%s: fast_io_fail_tmo = %d (config file default)", mp->alias,
+				mp->fast_io_fail == MP_FAST_IO_FAIL_ZERO ? 0 : mp->fast_io_fail);
 		return 0;
 	}
 	mp->fast_io_fail = 0;
