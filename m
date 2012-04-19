From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/12] Use udev attribute instead of
	getuid_callout()
Date: Thu, 19 Apr 2012 11:09:04 +0200
Message-ID: <1334826546-32039-11-git-send-email-hare@suse.de>
References: <1334826546-32039-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1334826546-32039-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Device-mapper Development <dm-devel@redhat.com>
List-Id: dm-devel.ids

By the time we're receiving an event udev already figured out
a unique ID. So we can just use that and get rid of the
callout.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/config.c      |   16 +++---
 libmultipath/config.h      |    6 +-
 libmultipath/defaults.h    |    2 +-
 libmultipath/dict.c        |   32 +++++++-------
 libmultipath/discovery.c   |   32 ++++++++++----
 libmultipath/hwtable.c     |  102 ++++++++-----------------------------------
 libmultipath/propsel.c     |   22 +++++-----
 libmultipath/structs.h     |    2 +-
 libmultipath/structs_vec.c |    2 +-
 multipath/multipath.conf.5 |   16 +++---
 10 files changed, 91 insertions(+), 141 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 75eab38..2263e19 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -161,8 +161,8 @@ free_hwe (struct hwentry * hwe)
 	if (hwe->revision)
 		FREE(hwe->revision);
 
-	if (hwe->getuid)
-		FREE(hwe->getuid);
+	if (hwe->uid_attribute)
+		FREE(hwe->uid_attribute);
 
 	if (hwe->features)
 		FREE(hwe->features);
@@ -218,8 +218,8 @@ free_mpe (struct mpentry * mpe)
 	if (mpe->selector)
 		FREE(mpe->selector);
 
-	if (mpe->getuid)
-		FREE(mpe->getuid);
+	if (mpe->uid_attribute)
+		FREE(mpe->uid_attribute);
 
 	if (mpe->alias)
 		FREE(mpe->alias);
@@ -306,7 +306,7 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_str(vendor);
 	merge_str(product);
 	merge_str(revision);
-	merge_str(getuid);
+	merge_str(uid_attribute);
 	merge_str(features);
 	merge_str(hwhandler);
 	merge_str(selector);
@@ -349,7 +349,7 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
 	if (dhwe->revision && !(hwe->revision = set_param_str(dhwe->revision)))
 		goto out;
 
-	if (dhwe->getuid && !(hwe->getuid = set_param_str(dhwe->getuid)))
+	if (dhwe->uid_attribute && !(hwe->uid_attribute = set_param_str(dhwe->uid_attribute)))
 		goto out;
 
 	if (dhwe->features && !(hwe->features = set_param_str(dhwe->features)))
@@ -440,8 +440,8 @@ free_config (struct config * conf)
 	if (conf->selector)
 		FREE(conf->selector);
 
-	if (conf->getuid)
-		FREE(conf->getuid);
+	if (conf->uid_attribute)
+		FREE(conf->uid_attribute);
 
 	if (conf->features)
 		FREE(conf->features);
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 147eedf..590dde2 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -25,7 +25,7 @@ struct hwentry {
 	char * vendor;
 	char * product;
 	char * revision;
-	char * getuid;
+	char * uid_attribute;
 	char * features;
 	char * hwhandler;
 	char * selector;
@@ -50,7 +50,7 @@ struct hwentry {
 struct mpentry {
 	char * wwid;
 	char * alias;
-	char * getuid;
+	char * uid_attribute;
 	char * selector;
 	char * features;
 
@@ -114,7 +114,7 @@ struct config {
 	char * udev_dir;
 	char * multipath_dir;
 	char * selector;
-	char * getuid;
+	char * uid_attribute;
 	char * features;
 	char * hwhandler;
 	char * bindings_file;
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 294646a..7697195 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -1,4 +1,4 @@
-#define DEFAULT_GETUID		"/lib/udev/scsi_id --whitelisted --replace-whitespace --device=/dev/%n"
+#define DEFAULT_UID_ATTRIBUTE	"ID_SERIAL"
 #define DEFAULT_UDEVDIR		"/dev"
 #define DEFAULT_MULTIPATHDIR	"/" LIB_STRING "/multipath"
 #define DEFAULT_SELECTOR	"round-robin 0"
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 4df3d9b..c51e005 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -161,11 +161,11 @@ def_pgpolicy_handler(vector strvec)
 }
 
 static int
-def_getuid_callout_handler(vector strvec)
+def_uid_attribute_handler(vector strvec)
 {
-	conf->getuid = set_value(strvec);
+	conf->uid_attribute = set_value(strvec);
 
-	if (!conf->getuid)
+	if (!conf->uid_attribute)
 		return 1;
 
 	return 0;
@@ -923,13 +923,13 @@ hw_pgpolicy_handler(vector strvec)
 }
 
 static int
-hw_getuid_callout_handler(vector strvec)
+hw_uid_attribute_handler(vector strvec)
 {
 	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
 
-	hwe->getuid = set_value(strvec);
+	hwe->uid_attribute = set_value(strvec);
 
-	if (!hwe->getuid)
+	if (!hwe->uid_attribute)
 		return 1;
 
 	return 0;
@@ -1970,14 +1970,14 @@ snprint_hw_bl_product (char * buff, int len, void * data)
 }
 
 static int
-snprint_hw_getuid_callout (char * buff, int len, void * data)
+snprint_hw_uid_attribute (char * buff, int len, void * data)
 {
 	struct hwentry * hwe = (struct hwentry *)data;
 
-	if (!hwe->getuid)
+	if (!hwe->uid_attribute)
 		return 0;
 
-	return snprintf(buff, len, "\"%s\"", hwe->getuid);
+	return snprintf(buff, len, "\"%s\"", hwe->uid_attribute);
 }
 
 static int
@@ -2278,12 +2278,12 @@ snprint_def_path_grouping_policy (char * buff, int len, void * data)
 }
 
 static int
-snprint_def_getuid_callout (char * buff, int len, void * data)
+snprint_def_uid_attribute (char * buff, int len, void * data)
 {
-	if (!conf->getuid)
-		return snprintf(buff, len, "\"%s\"", DEFAULT_GETUID);
+	if (!conf->uid_attribute)
+		return snprintf(buff, len, "\"%s\"", DEFAULT_UID_ATTRIBUTE);
 
-	return snprintf(buff, len, "\"%s\"", conf->getuid);
+	return snprintf(buff, len, "\"%s\"", conf->uid_attribute);
 }
 
 static int
@@ -2551,7 +2551,7 @@ init_keywords(void)
 	install_keyword("multipath_dir", &multipath_dir_handler, &snprint_def_multipath_dir);
 	install_keyword("path_selector", &def_selector_handler, &snprint_def_selector);
 	install_keyword("path_grouping_policy", &def_pgpolicy_handler, &snprint_def_path_grouping_policy);
-	install_keyword("getuid_callout", &def_getuid_callout_handler, &snprint_def_getuid_callout);
+	install_keyword("uid_attribute", &def_uid_attribute_handler, &snprint_def_uid_attribute);
 	install_keyword("prio", &def_prio_handler, &snprint_def_prio);
 	install_keyword("prio_args", &def_prio_args_handler, &snprint_def_prio_args);
 	install_keyword("features", &def_features_handler, &snprint_def_features);
@@ -2579,7 +2579,7 @@ init_keywords(void)
 	install_keyword("reservation_key", &def_reservation_key_handler, &snprint_def_reservation_key);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
-	__deprecated install_keyword("default_getuid_callout", &def_getuid_callout_handler, NULL);
+	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
 	__deprecated install_keyword("default_features", &def_features_handler, NULL);
 	__deprecated install_keyword("default_path_checker", &def_path_checker_handler, NULL);
 
@@ -2619,7 +2619,7 @@ init_keywords(void)
 	install_keyword("revision", &revision_handler, &snprint_hw_revision);
 	install_keyword("product_blacklist", &bl_product_handler, &snprint_hw_bl_product);
 	install_keyword("path_grouping_policy", &hw_pgpolicy_handler, &snprint_hw_path_grouping_policy);
-	install_keyword("getuid_callout", &hw_getuid_callout_handler, &snprint_hw_getuid_callout);
+	install_keyword("uid_attribute", &hw_uid_attribute_handler, &snprint_hw_uid_attribute);
 	install_keyword("path_selector", &hw_selector_handler, &snprint_hw_selector);
 	install_keyword("path_checker", &hw_path_checker_handler, &snprint_hw_path_checker);
 	install_keyword("checker", &hw_path_checker_handler, NULL);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index fa8cfa0..452c709 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -922,19 +922,33 @@ get_prio (struct path * pp)
 static int
 get_uid (struct path * pp)
 {
-	char buff[CALLOUT_MAX_SIZE], *c;
+	char *c;
+	const char *value;
 
-	if (!pp->getuid)
+	if (!pp->uid_attribute)
 		select_getuid(pp);
 
-	if (apply_format(pp->getuid, &buff[0], pp)) {
-		condlog(0, "error formatting uid callout command");
-		memset(pp->wwid, 0, WWID_SIZE);
-	} else if (execute_program(buff, pp->wwid, WWID_SIZE)) {
-		condlog(3, "error calling out %s", buff);
-		memset(pp->wwid, 0, WWID_SIZE);
+	if (!pp->udev) {
+		condlog(1, "%s: no udev information", pp->dev);
 		return 1;
 	}
+
+	memset(pp->wwid, 0, WWID_SIZE);
+	value = udev_device_get_property_value(pp->udev, pp->uid_attribute);
+	if (value && strlen(value)) {
+		size_t len = WWID_SIZE;
+
+		if (strlen(value) + 1 > WWID_SIZE) {
+			condlog(0, "%s: wwid overflow", pp->dev);
+		} else {
+			len = strlen(value);
+		}
+		strncpy(pp->wwid, value, len);
+	} else {
+		condlog(3, "%s: no %s attribute", pp->dev,
+			pp->uid_attribute);
+	}
+
 	/* Strip any trailing blanks */
 	c = strchr(pp->wwid, '\0');
 	c--;
@@ -942,7 +956,7 @@ get_uid (struct path * pp)
 		*c = '\0';
 		c--;
 	}
-	condlog(3, "%s: uid = %s (callout)", pp->dev,
+	condlog(3, "%s: uid = %s (udev)", pp->dev,
 		*pp->wwid == '\0' ? "<empty>" : pp->wwid);
 	return 0;
 }
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 3fcc659..a3d1908 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -26,7 +26,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "COMPELNT",
 		.product       = "Compellent Vol",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -49,7 +48,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "APPLE*",
 		.product       = "Xserve RAID ",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -72,7 +70,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "3PARdata",
 		.product       = "VV",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -89,7 +86,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "DEC",
 		.product       = "HSG80",
-		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 hp_sw",
 		.selector      = DEFAULT_SELECTOR,
@@ -106,7 +102,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "HP",
 		.product       = "A6189A",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -124,7 +119,6 @@ static struct hwentry default_hw[] = {
 		/* MSA 1000/MSA1500 EVA 3000/5000 with old firmware */
 		.vendor        = "(COMPAQ|HP)",
 		.product       = "(MSA|HSV)1.0.*",
-		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 hp_sw",
 		.selector      = DEFAULT_SELECTOR,
@@ -141,7 +135,6 @@ static struct hwentry default_hw[] = {
 		/* MSA 1000/1500 with new firmware */
 		.vendor        = "(COMPAQ|HP)",
 		.product       = "MSA VOLUME",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -158,7 +151,6 @@ static struct hwentry default_hw[] = {
 		/* EVA 3000/5000 with new firmware, EVA 4000/6000/8000 */
 		.vendor        = "(COMPAQ|HP)",
 		.product       = "HSV1[01]1|HSV2[01]0|HSV300|HSV4[05]0",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -175,7 +167,6 @@ static struct hwentry default_hw[] = {
 		/* HP MSA2000 product family with old firmware */
 		.vendor        = "HP",
 		.product       = "MSA2[02]12fc|MSA2012i",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -192,7 +183,6 @@ static struct hwentry default_hw[] = {
 		/* HP MSA2000 product family with new firmware */
 		.vendor        = "HP",
 		.product       = "MSA2012sa|MSA23(12|24)(fc|i|sa)|MSA2000s VOLUME",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -210,7 +200,6 @@ static struct hwentry default_hw[] = {
 		/* HP SVSP */
 		.vendor        = "HP",
 		.product       = "HSVX700",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 alua",
 		.selector      = DEFAULT_SELECTOR,
@@ -228,7 +217,6 @@ static struct hwentry default_hw[] = {
 		/* HP Smart Array */
 		.vendor        = "HP",
 		.product       = "LOGICAL VOLUME.*",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -246,7 +234,6 @@ static struct hwentry default_hw[] = {
 		/* HP P2000 family arrays */
 		.vendor        = "HP",
 		.product       = "P2000 G3 FC|P2000G3 FC/iSCSI|P2000 G3 SAS|P2000 G3 iSCSI",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -269,7 +256,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "DDN",
 		.product       = "SAN DataDirector",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -292,7 +278,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "EMC",
 		.product       = "SYMMETRIX",
-		.getuid        = "/lib/udev/scsi_id --page=pre-spc3-83 --whitelisted --device=/dev/%n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -310,7 +295,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "DGC",
 		.product       = ".*",
 		.bl_product    = "LUNZ",
-		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 emc",
 		.selector      = DEFAULT_SELECTOR,
@@ -328,7 +312,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "EMC",
 		.product       = "Invista",
 		.bl_product    = "LUNZ",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -351,7 +334,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "FSC",
 		.product       = "CentricStor",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -368,7 +350,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "FUJITSU",
 		.product       = "ETERNUS_DX(L|400|8000)",
-		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -390,7 +371,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "(HITACHI|HP)",
 		.product       = "OPEN-.*",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -407,7 +387,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "HITACHI",
 		.product       = "DF.*",
-		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -430,7 +409,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "IBM",
 		.product       = "ProFibre 4000R",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -449,7 +427,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^1722-600",
 		.bl_product    = "Universal Xport",
-		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
@@ -468,7 +445,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^1724",
 		.bl_product    = "Universal Xport",
-		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
@@ -487,7 +463,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^1726",
 		.bl_product    = "Universal Xport",
-		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
@@ -506,7 +481,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^1742",
 		.bl_product    = "Universal Xport",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
@@ -524,7 +498,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^1745|^1746",
 		.bl_product    = "Universal Xport",
-		.getuid        = DEFAULT_GETUID,
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
@@ -543,7 +516,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^1814",
 		.bl_product    = "Universal Xport",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
@@ -562,7 +534,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^1815",
 		.bl_product    = "Universal Xport",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
@@ -581,7 +552,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^1818",
 		.bl_product    = "Universal Xport",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
@@ -600,7 +570,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "^3526",
 		.bl_product    = "Universal Xport",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
@@ -618,7 +587,6 @@ static struct hwentry default_hw[] = {
 		/* IBM DS4200 / FAStT200 */
 		.vendor        = "IBM",
 		.product       = "^3542",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -636,7 +604,6 @@ static struct hwentry default_hw[] = {
 		/* IBM ESS F20 aka Shark */
 		.vendor        = "IBM",
 		.product       = "^2105800",
-		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -654,7 +621,6 @@ static struct hwentry default_hw[] = {
 		/* IBM ESS F20 aka Shark */
 		.vendor        = "IBM",
 		.product       = "^2105F20",
-		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -672,7 +638,6 @@ static struct hwentry default_hw[] = {
 		/* IBM DS6000 */
 		.vendor        = "IBM",
 		.product       = "^1750500",
-		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -690,7 +655,6 @@ static struct hwentry default_hw[] = {
 		/* IBM DS8000 */
 		.vendor        = "IBM",
 		.product       = "^2107900",
-		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -708,7 +672,6 @@ static struct hwentry default_hw[] = {
 		/* IBM SAN Volume Controller */
 		.vendor        = "IBM",
 		.product       = "^2145",
-		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -727,7 +690,7 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "S/390 DASD ECKD",
 		.bl_product       = "S/390.*",
-		.getuid        = "/sbin/dasdinfo -u -b %n",
+		.uid_attribute = "ID_UID",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -746,7 +709,7 @@ static struct hwentry default_hw[] = {
 		.vendor        = "IBM",
 		.product       = "S/390 DASD FBA",
 		.bl_product       = "S/390.*",
-		.getuid        = "/sbin/dasdinfo -u -b %n",
+		.uid_attribute = "ID_UID",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -764,7 +727,6 @@ static struct hwentry default_hw[] = {
 		/* IBM IPR */
 		.vendor        = "IBM",
 		.product       = "^IPR.*",
-		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 alua",
 		.selector      = DEFAULT_SELECTOR,
@@ -782,7 +744,6 @@ static struct hwentry default_hw[] = {
 		/* IBM RSSM */
 		.vendor        = "IBM",
 		.product       = "1820N00",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -796,24 +757,23 @@ static struct hwentry default_hw[] = {
 		.prio_name     = PRIO_ALUA,
 		.prio_args     = NULL,
 	},
-        {
-                /* IBM XIV Storage System */
-                .vendor        = "IBM",
-                .product       = "2810XIV",
-                .getuid        = DEFAULT_GETUID,
-                .features      = "1 queue_if_no_path",
-                .hwhandler     = DEFAULT_HWHANDLER,
-                .selector      = DEFAULT_SELECTOR,
-                .pgpolicy      = MULTIBUS,
-                .pgfailback    = 15,
-                .rr_weight     = RR_WEIGHT_NONE,
-                .no_path_retry = NO_PATH_RETRY_UNDEF,
-                .minio         = 15,
-                .minio_rq      = DEFAULT_MINIO_RQ,
-                .checker_name  = TUR,
-                .prio_name     = DEFAULT_PRIO,
-                .prio_args     = NULL,
-        },
+	{
+	    /* IBM XIV Storage System */
+		.vendor        = "IBM",
+		.product       = "2810XIV",
+		.features      = "1 queue_if_no_path",
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = MULTIBUS,
+		.pgfailback    = 15,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.minio         = 15,
+		.minio_rq      = DEFAULT_MINIO_RQ,
+		.checker_name  = TUR,
+		.prio_name     = DEFAULT_PRIO,
+		.prio_args     = NULL,
+	},
 	/*
 	 * IBM Power Virtual SCSI Devices
 	 *
@@ -824,7 +784,6 @@ static struct hwentry default_hw[] = {
 		/* AIX VDASD */
 		.vendor        = "AIX",
 		.product       = "VDASD",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -842,7 +801,6 @@ static struct hwentry default_hw[] = {
 		/* IBM 3303      NVDISK */
 		.vendor        = "IBM",
 		.product       = "3303      NVDISK",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -860,7 +818,6 @@ static struct hwentry default_hw[] = {
 		/* AIX NVDISK */
 		.vendor        = "AIX",
 		.product       = "NVDISK",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 alua",
 		.selector      = DEFAULT_SELECTOR,
@@ -879,7 +836,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "DELL",
 		.product       = "MD3000",
 		.bl_product    = "Universal Xport",
-		.getuid        = DEFAULT_GETUID,
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
@@ -898,7 +854,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "DELL",
 		.product       = "MD3000i",
 		.bl_product    = "Universal Xport",
-		.getuid        = DEFAULT_GETUID,
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
@@ -917,7 +872,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "DELL",
 		.product       = "MD32xx",
 		.bl_product    = "Universal Xport",
-		.getuid        = DEFAULT_GETUID,
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
@@ -936,7 +890,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "DELL",
 		.product       = "MD32xxi",
 		.bl_product    = "Universal Xport",
-		.getuid        = DEFAULT_GETUID,
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
@@ -959,7 +912,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "NETAPP",
 		.product       = "LUN.*",
-		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -981,7 +933,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "NEXENTA",
 		.product       = "COMSTAR",
-		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -1003,7 +954,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "IBM",
 		.product       = "Nseries.*",
-		.getuid        = DEFAULT_GETUID,
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -1025,7 +975,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "Pillar",
 		.product       = "Axiom.*",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -1049,7 +998,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "SGI",
 		.product       = "TP9[13]00",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -1067,7 +1015,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "SGI",
 		.product       = "TP9[45]00",
 		.bl_product    = "Universal Xport",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
@@ -1085,7 +1032,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "SGI",
 		.product       = "IS.*",
 		.bl_product    = "Universal Xport",
-		.getuid        = DEFAULT_GETUID,
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
@@ -1103,7 +1049,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "NEC",
 		.product       = "DISK ARRAY",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 alua",
 		.selector      = DEFAULT_SELECTOR,
@@ -1127,7 +1072,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "STK",
 		.product       = "OPENstorage D280",
 		.bl_product    = "Universal Xport",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
@@ -1150,7 +1094,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "SUN",
 		.product       = "(StorEdge 3510|T4)",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -1167,7 +1110,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "EUROLOGC",
 		.product       = "FC2502",
-		.getuid        ="/lib/udev/scsi_id --page=0x80 --whitelisted --device=/dev/%n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -1190,7 +1132,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = "PIVOT3",
 		.product       = "RAIGE VOLUME",
-		.getuid        = "/lib/udev/scsi_id --page=0x80 --whitelisted --device=/dev/%n",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
@@ -1207,7 +1148,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "SUN",
 		.product       = "CSM200_R",
 		.bl_product    = "Universal Xport",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
@@ -1226,7 +1166,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "SUN",
 		.product       = "LCSM100_[IEFS]",
 		.bl_product    = "Universal Xport",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
@@ -1245,7 +1184,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "(LSI|ENGENIO)",
 		.product       = "INF-01-00",
 		.bl_product    = "Universal Xport",
-		.getuid        = DEFAULT_GETUID,
 		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
@@ -1263,7 +1201,6 @@ static struct hwentry default_hw[] = {
 		.vendor        = "STK",
 		.product       = "FLEXLINE 380",
 		.bl_product    = "Universal Xport",
-		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
@@ -1283,7 +1220,6 @@ static struct hwentry default_hw[] = {
 	{
 		.vendor        = NULL,
 		.product       = NULL,
-		.getuid        = NULL,
 		.features      = NULL,
 		.hwhandler     = NULL,
 		.selector      = NULL,
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index f38af86..9c06203 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -349,21 +349,21 @@ out:
 extern int
 select_getuid (struct path * pp)
 {
-	if (pp->hwe && pp->hwe->getuid) {
-		pp->getuid = pp->hwe->getuid;
-		condlog(3, "%s: getuid = %s (controller setting)",
-			pp->dev, pp->getuid);
+	if (pp->hwe && pp->hwe->uid_attribute) {
+		pp->uid_attribute = pp->hwe->uid_attribute;
+		condlog(3, "%s: uid_attribute = %s (controller setting)",
+			pp->dev, pp->uid_attribute);
 		return 0;
 	}
-	if (conf->getuid) {
-		pp->getuid = conf->getuid;
-		condlog(3, "%s: getuid = %s (config file default)",
-			pp->dev, pp->getuid);
+	if (conf->uid_attribute) {
+		pp->uid_attribute = conf->uid_attribute;
+		condlog(3, "%s: uid_attribute = %s (config file default)",
+			pp->dev, pp->uid_attribute);
 		return 0;
 	}
-	pp->getuid = STRDUP(DEFAULT_GETUID);
-	condlog(3, "%s: getuid = %s (internal default)",
-		pp->dev, pp->getuid);
+	pp->uid_attribute = STRDUP(DEFAULT_UID_ATTRIBUTE);
+	condlog(3, "%s: uid_attribute = %s (internal default)",
+		pp->dev, pp->uid_attribute);
 	return 0;
 }
 
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 16aa0ff..4f643ef 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -148,7 +148,7 @@ struct path {
 	int failcount;
 	int priority;
 	int pgindex;
-	char * getuid;
+	char * uid_attribute;
 	struct prio * prio;
 	struct checker checker;
 	struct multipath * mpp;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index b7dd7c4..e1fb4b1 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -82,7 +82,7 @@ orphan_path (struct path * pp)
 {
 	pp->mpp = NULL;
 	pp->dmstate = PSTATE_UNDEF;
-	pp->getuid = NULL;
+	pp->uid_attribute = NULL;
 	pp->prio = NULL;
 	checker_put(&pp->checker);
 	if (pp->fd >= 0)
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index dfaf532..b04a2a9 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -55,8 +55,9 @@ section.
 .TP
 .B multipaths
 This section defines the multipath topologies. They are indexed by a
-\fIWorld Wide Identifier\fR(wwid), which is the result of the
-\fIgetuid_callout\fR program.
+\fIWorld Wide Identifier\fR(wwid), which is taken to be the value of
+the udev attribute given by the
+\fIuid_attribute\fR keyword.
 .TP
 .B devices
 This section defines the device-specific settings.
@@ -142,11 +143,10 @@ in /sys/class/fc_transport/target*/node_name.
 Default value is \fImultibus\fR.
 .RE
 .TP
-.B getuid_callout
-The default program and args to callout to obtain a unique path
-identifier. Should be specified with an absolute path. Default value
-is
-.I /lib/udev/scsi_id --whitelisted --replace-whitespace --device=/dev/%n
+.B uid_attribute
+The udev attribute providing a unique path
+identifier. Default value is
+.I ID_SERIAL
 .TP
 .B prio
 The name of the path priority routine. The specified routine
@@ -520,7 +520,7 @@ section:
 .TP 18
 .B path_grouping_policy
 .TP
-.B getuid_callout
+.B uid_attribute
 .TP
 .B path_selector
 .TP
-- 
1.7.3.4
