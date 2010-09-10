From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath dict.c
Date: 10 Sep 2010 14:25:21 -0000
Message-ID: <20100910142521.32075.qmail@sourceware.org>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2010-09-10 14:25:20

Modified files:
	libmultipath   : dict.c 

Log message:
	Fix for bz #585225.  The print function for the configuration variables no
	longer ignore options set to the default.  This allows users to see exactly
	how multipath is configured.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17.2.15&r2=1.17.2.16

--- multipath-tools/libmultipath/dict.c	2010/09/08 21:40:30	1.17.2.15
+++ multipath-tools/libmultipath/dict.c	2010/09/10 14:25:20	1.17.2.16
@@ -262,6 +262,10 @@
 	    !strcmp(buff, "priorities"))
 		conf->rr_weight = RR_WEIGHT_PRIO;
 
+	if (strlen(buff) == strlen("uniform") &&
+	    !strcmp(buff, "uniform"))
+		conf->rr_weight = RR_WEIGHT_NONE;
+
 	FREE(buff);
 
 	return 0;
@@ -850,6 +854,10 @@
 	    !strcmp(buff, "priorities"))
 		hwe->rr_weight = RR_WEIGHT_PRIO;
 
+	if (strlen(buff) == strlen("uniform") &&
+	    !strcmp(buff, "uniform"))
+		hwe->rr_weight = RR_WEIGHT_NONE;
+
 	FREE(buff);
 
 	return 0;
@@ -1118,6 +1126,10 @@
 	    !strcmp(buff, "priorities"))
 		mpe->rr_weight = RR_WEIGHT_PRIO;
 
+	if (strlen(buff) == strlen("uniform") &&
+	    !strcmp(buff, "uniform"))
+		mpe->rr_weight = RR_WEIGHT_NONE;
+
 	FREE(buff);
 
 	return 0;
@@ -1311,7 +1323,7 @@
 {
 	struct mpentry * mpe = (struct mpentry *)data;
 
-	return snprintf(buff, len, "%s", mpe->wwid);
+	return snprintf(buff, len, "\"%s\"", mpe->wwid);
 }
 
 static int
@@ -1322,12 +1334,7 @@
 	if (!mpe->alias)
 		return 0;
 
-	if (conf->user_friendly_names &&
-	    (strlen(mpe->alias) == strlen("mpath")) &&
-	    !strcmp(mpe->alias, "mpath"))
-		return 0;
-
-	return snprintf(buff, len, "%s", mpe->alias);
+	return snprintf(buff, len, "\"%s\"", mpe->alias);
 }
 
 static int
@@ -1351,7 +1358,7 @@
 	if (!mpe->selector)
 		return 0;
 
-	return snprintf(buff, len, "%s", mpe->selector);
+	return snprintf(buff, len, "\"%s\"", mpe->selector);
 }
 
 static int
@@ -1410,19 +1417,10 @@
 {
 	struct mpentry * mpe = (struct mpentry *)data;
 
-	if (!conf->getprio && !mpe->getprio)
-		return 0;
-	if (!conf->getprio && mpe->getprio)
-		return snprintf(buff, len, "%s", mpe->getprio);
-	if (conf->getprio && !mpe->getprio)
-		return snprintf(buff, len, "none");
-
-	/* conf->getprio && mpe->getprio */
-	if (strlen(mpe->getprio) == strlen(conf->getprio) &&
-	    !strcmp(mpe->getprio, conf->getprio))
+	if (!mpe->getprio)
 		return 0;
 
-	return snprintf(buff, len, "%s", mpe->getprio);
+	return snprintf(buff, len, "\"%s\"", mpe->getprio);
 }
 
 static int
@@ -1434,6 +1432,8 @@
 		return 0;
 	if (mpe->rr_weight == RR_WEIGHT_PRIO)
 		return snprintf(buff, len, "priorities");
+	if (mpe->rr_weight == RR_WEIGHT_NONE)
+		return snprintf(buff, len, "uniform");
 
 	return 0;
 }
@@ -1509,7 +1509,7 @@
 	if (!hwe->vendor)
 		return 0;
 
-	return snprintf(buff, len, "%s", hwe->vendor);
+	return snprintf(buff, len, "\"%s\"", hwe->vendor);
 }
 
 static int
@@ -1520,7 +1520,7 @@
 	if (!hwe->product)
 		return 0;
 
-	return snprintf(buff, len, "%s", hwe->product);
+	return snprintf(buff, len, "\"%s\"", hwe->product);
 }
 
 static int
@@ -1541,11 +1541,8 @@
 
 	if (!hwe->getuid)
 		return 0;
-	if (strlen(hwe->getuid) == strlen(conf->getuid) &&
-	    !strcmp(hwe->getuid, conf->getuid))
-		return 0;
 
-	return snprintf(buff, len, "%s", hwe->getuid);
+	return snprintf(buff, len, "\"%s\"", hwe->getuid);
 }
 
 static int
@@ -1553,19 +1550,10 @@
 {
 	struct hwentry * hwe = (struct hwentry *)data;
 
-	if (!conf->getprio && !hwe->getprio)
-		return 0;
-	if (!conf->getprio && hwe->getprio)
-		return snprintf(buff, len, "%s", hwe->getprio);
-	if (conf->getprio && !hwe->getprio)
-		return snprintf(buff, len, "none");
-
-	/* conf->getprio && hwe->getprio */
-	if (strlen(hwe->getprio) == strlen(conf->getprio) &&
-	    !strcmp(hwe->getprio, conf->getprio))
+	if (!hwe->getprio)
 		return 0;
 
-	return snprintf(buff, len, "%s", hwe->getprio);
+	return snprintf(buff, len, "\"%s\"", hwe->getprio);
 }
 
 static int
@@ -1575,11 +1563,8 @@
 
 	if (!hwe->features)
 		return 0;
-	if (strlen(hwe->features) == strlen(conf->features) &&
-	    !strcmp(hwe->features, conf->features))
-		return 0;
 
-	return snprintf(buff, len, "%s", hwe->features);
+	return snprintf(buff, len, "\"%s\"", hwe->features);
 }
 
 static int
@@ -1589,11 +1574,8 @@
 
 	if (!hwe->hwhandler)
 		return 0;
-	if (strlen(hwe->hwhandler) == strlen(conf->hwhandler) &&
-	    !strcmp(hwe->hwhandler, conf->hwhandler))
-		return 0;
 
-	return snprintf(buff, len, "%s", hwe->hwhandler);
+	return snprintf(buff, len, "\"%s\"", hwe->hwhandler);
 }
 
 static int
@@ -1603,11 +1585,8 @@
 
 	if (!hwe->selector)
 		return 0;
-	if (strlen(hwe->selector) == strlen(conf->selector) &&
-	    !strcmp(hwe->selector, conf->selector))
-		return 0;
 
-	return snprintf(buff, len, "%s", hwe->selector);
+	return snprintf(buff, len, "\"%s\"", hwe->selector);
 }
 
 static int
@@ -1619,8 +1598,6 @@
 
 	if (!hwe->pgpolicy)
 		return 0;
-	if (hwe->pgpolicy == conf->pgpolicy)
-		return 0;
 
 	get_pgpolicy_name(str, POLICY_NAME_SIZE, hwe->pgpolicy);
 	
@@ -1634,8 +1611,6 @@
 
 	if (!hwe->pgfailback)
 		return 0;
-	if (hwe->pgfailback == conf->pgfailback)
-		return 0;
 
 	switch(hwe->pgfailback) {
 	case  FAILBACK_UNDEF:
@@ -1657,10 +1632,10 @@
 
 	if (!hwe->rr_weight)
 		return 0;
-	if (hwe->rr_weight == conf->rr_weight)
-		return 0;
 	if (hwe->rr_weight == RR_WEIGHT_PRIO)
 		return snprintf(buff, len, "priorities");
+	if (hwe->rr_weight == RR_WEIGHT_NONE)
+		return snprintf(buff, len, "uniform");
 
 	return 0;
 }
@@ -1672,8 +1647,6 @@
 
 	if (!hwe->no_path_retry)
 		return 0;
-	if (hwe->no_path_retry == conf->no_path_retry)
-		return 0;
 
 	switch(hwe->no_path_retry) {
 	case NO_PATH_RETRY_UNDEF:
@@ -1696,8 +1669,6 @@
 
 	if (!hwe->minio)
 		return 0;
-	if (hwe->minio == conf->minio)
-		return 0;
 
 	return snprintf(buff, len, "%u", hwe->minio);
 }
@@ -1723,8 +1694,6 @@
 
 	if (!hwe->pg_timeout)
 		return 0;
-	if (hwe->pg_timeout == conf->pg_timeout)
-		return 0;
 
 	switch (hwe->pg_timeout) {
 	case PGTIMEOUT_UNDEF:
@@ -1746,8 +1715,6 @@
 		return 0;
 	if (!checker_selected(hwe->checker))
 		return 0;
-	if (hwe->checker == conf->checker)
-		return 0;
 	
 	return snprintf(buff, len, "%s", checker_name(hwe->checker));
 }
@@ -1755,16 +1722,12 @@
 static int
 snprint_def_polling_interval (char * buff, int len, void * data)
 {
-	if (conf->checkint == DEFAULT_CHECKINT)
-		return 0;
 	return snprintf(buff, len, "%i", conf->checkint);
 }
 
 static int
 snprint_def_verbosity (char * buff, int len, void * data)
 {
-	if (conf->checkint == DEFAULT_VERBOSITY)
-		return 0;
 	return snprintf(buff, len, "%i", conf->verbosity);
 }
 
@@ -1772,37 +1735,30 @@
 snprint_def_udev_dir (char * buff, int len, void * data)
 {
 	if (!conf->udev_dir)
-		return 0;
-	if (strlen(DEFAULT_UDEVDIR) == strlen(conf->udev_dir) &&
-	    !strcmp(conf->udev_dir, DEFAULT_UDEVDIR))
-		return 0;
+		return snprintf(buff, len, "\"%s\"", DEFAULT_UDEVDIR);
 
-	return snprintf(buff, len, "%s", conf->udev_dir);
+	return snprintf(buff, len, "\"%s\"", conf->udev_dir);
 }
 
 static int
 snprint_def_selector (char * buff, int len, void * data)
 {
 	if (!conf->selector)
-		return 0;
-	if (strlen(conf->selector) == strlen(DEFAULT_SELECTOR) &&
-	    !strcmp(conf->selector, DEFAULT_SELECTOR))
-		return 0;
+		return snprintf(buff, len, "\"%s\"", DEFAULT_SELECTOR);
 
-	return snprintf(buff, len, "%s", conf->selector);
+	return snprintf(buff, len, "\"%s\"", conf->selector);
 }
 
 static int
 snprint_def_path_grouping_policy (char * buff, int len, void * data)
 {
+	int policy = conf->pgpolicy;
 	char str[POLICY_NAME_SIZE];
 
-	if (!conf->pgpolicy)
-		return 0;
-	if (conf->pgpolicy == DEFAULT_PGPOLICY)
-		return 0;
+	if (!policy)
+		policy = DEFAULT_PGPOLICY;
 
-	get_pgpolicy_name(str, POLICY_NAME_SIZE, conf->pgpolicy);
+	get_pgpolicy_name(str, POLICY_NAME_SIZE, policy);
 	
 	return snprintf(buff, len, "%s", str);
 }
@@ -1811,42 +1767,34 @@
 snprint_def_getuid_callout (char * buff, int len, void * data)
 {
 	if (!conf->getuid)
-		return 0;
-	if (strlen(conf->getuid) == strlen(DEFAULT_GETUID) &&
-	    !strcmp(conf->getuid, DEFAULT_GETUID))
-		return 0;
+		return snprintf(buff, len, "\"%s\"", DEFAULT_GETUID);
 
-	return snprintf(buff, len, "%s", conf->getuid);
+	return snprintf(buff, len, "\"%s\"", conf->getuid);
 }
 
 static int
 snprint_def_getprio_callout (char * buff, int len, void * data)
 {
 	if (!conf->getprio)
-		return 0;
+		return snprintf(buff, len, "none");
 
-	return snprintf(buff, len, "%s", conf->getprio);
+	return snprintf(buff, len, "\"%s\"", conf->getprio);
 }
 
 static int
 snprint_def_features (char * buff, int len, void * data)
 {
 	if (!conf->features)
-		return 0;
-	if (strlen(conf->features) == strlen(DEFAULT_FEATURES) &&
-	    !strcmp(conf->features, DEFAULT_FEATURES))
-		return 0;
+		return snprintf(buff, len, "\"%s\"", DEFAULT_FEATURES);
 
-	return snprintf(buff, len, "%s", conf->features);
+	return snprintf(buff, len, "\"%s\"", conf->features);
 }
 
 static int
 snprint_def_path_checker (char * buff, int len, void * data)
 {
 	if (!conf->checker)
-		return 0;
-	if (conf->checker == checker_default())
-		return 0;
+		return snprintf(buff, len, "%s", DEFAULT_CHECKER);
 	
 	return snprintf(buff, len, "%s", checker_name(conf->checker));
 }
@@ -1854,20 +1802,17 @@
 static int
 snprint_def_failback (char * buff, int len, void * data)
 {
-	if (!conf->pgfailback)
-		return 0;
-	if (conf->pgfailback == DEFAULT_FAILBACK)
-		return 0;
+	int failback = conf->pgfailback;
 
-	switch(conf->pgfailback) {
-	case  FAILBACK_UNDEF:
-		break;
+	if (failback == FAILBACK_UNDEF)
+		failback = DEFAULT_FAILBACK;
+	switch(failback) {
 	case -FAILBACK_MANUAL:
 		return snprintf(buff, len, "manual");
 	case -FAILBACK_IMMEDIATE:
 		return snprintf(buff, len, "immediate");
 	default:
-		return snprintf(buff, len, "%i", conf->pgfailback);
+		return snprintf(buff, len, "%i", failback);
 	}
 	return 0;
 }
@@ -1876,9 +1821,7 @@
 snprint_def_rr_min_io (char * buff, int len, void * data)
 {
 	if (!conf->minio)
-		return 0;
-	if (conf->minio == DEFAULT_MINIO)
-		return 0;
+		return snprintf(buff, len, "%u", DEFAULT_MINIO);
 
 	return snprintf(buff, len, "%u", conf->minio);
 }
@@ -1921,12 +1864,14 @@
 static int
 snprint_def_rr_weight (char * buff, int len, void * data)
 {
-	if (!conf->rr_weight)
-		return 0;
-	if (conf->rr_weight == DEFAULT_RR_WEIGHT)
-		return 0;
-	if (conf->rr_weight == RR_WEIGHT_PRIO)
+	int weight = conf->rr_weight;
+
+	if (weight == RR_WEIGHT_UNDEF)
+		weight = DEFAULT_RR_WEIGHT;
+	if (weight == RR_WEIGHT_PRIO)
 		return snprintf(buff, len, "priorities");
+	if (weight == RR_WEIGHT_NONE)
+		return snprintf(buff, len, "uniform");
 
 	return 0;
 }
@@ -1934,9 +1879,6 @@
 static int
 snprint_def_no_path_retry (char * buff, int len, void * data)
 {
-	if (conf->no_path_retry == DEFAULT_NO_PATH_RETRY)
-		return 0;
-
 	switch(conf->no_path_retry) {
 	case NO_PATH_RETRY_UNDEF:
 		break;
@@ -1957,6 +1899,7 @@
 	switch (conf->queue_without_daemon) {
 	case QUE_NO_DAEMON_OFF:
 		return snprintf(buff, len, "no");
+	case QUE_NO_DAEMON_UNDEF:
 	case QUE_NO_DAEMON_ON:
 		return snprintf(buff, len, "yes");
 	}
@@ -1967,6 +1910,7 @@
 snprint_def_flush_on_last_del (char * buff, int len, void * data)
 {
 	switch (conf->flush_on_last_del) {
+	case FLUSH_UNDEF:
 	case FLUSH_DISABLED:
 		return snprintf(buff, len, "no");
 	case FLUSH_ENABLED:
@@ -1987,12 +1931,12 @@
 static int
 snprint_def_pg_timeout (char * buff, int len, void * data)
 {
-	if (conf->pg_timeout == DEFAULT_PGTIMEOUT)
+	int timeout = conf->pg_timeout;
+
+	if (timeout == PGTIMEOUT_UNDEF)
 		return 0;
 
 	switch (conf->pg_timeout) {
-	case PGTIMEOUT_UNDEF:
-		break;
 	case -PGTIMEOUT_NONE:
 		return snprintf(buff, len, "none");
 	default:
@@ -2004,8 +1948,6 @@
 static int
 snprint_def_user_friendly_names (char * buff, int len, void * data)
 {
-	if (conf->user_friendly_names == DEFAULT_USER_FRIENDLY_NAMES)
-		return 0;
 	if (!conf->user_friendly_names)
 		return snprintf(buff, len, "no");
 
@@ -2032,12 +1974,9 @@
 snprint_def_bindings_file (char * buff, int len, void * data)
 {
 	if (conf->bindings_file == NULL)
-		return 0;
-	if (strlen(conf->bindings_file) == strlen(DEFAULT_BINDINGS_FILE) &&
-	    !strcmp(conf->bindings_file, DEFAULT_BINDINGS_FILE))
-		return 0;
+		return snprintf(buff, len, "\"%s\"", DEFAULT_BINDINGS_FILE);
 
-	return snprintf(buff, len, "%s", conf->bindings_file);
+	return snprintf(buff, len, "\"%s\"", conf->bindings_file);
 }
 
 static int
@@ -2045,7 +1984,7 @@
 {
 	struct blentry * ble = (struct blentry *)data;
 
-	return snprintf(buff, len, "%s", ble->str);
+	return snprintf(buff, len, "\"%s\"", ble->str);
 }
 
 static int
@@ -2053,7 +1992,7 @@
 {
 	struct blentry_device * bled = (struct blentry_device *)data;
 
-	return snprintf(buff, len, "%s", bled->vendor);
+	return snprintf(buff, len, "\"%s\"", bled->vendor);
 }
 	
 static int
@@ -2061,7 +2000,7 @@
 {
 	struct blentry_device * bled = (struct blentry_device *)data;
 
-	return snprintf(buff, len, "%s", bled->product);
+	return snprintf(buff, len, "\"%s\"", bled->product);
 }
 	
 #define __deprecated
