From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: make "show config" show the whole
	config.
Date: Fri, 3 Dec 2010 18:13:21 -0600
Message-ID: <20101204001321.GN25172@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Show config wasn't displaying particularly useful results. It only showed
the configuration values if they were different from what they would default
to.  This made it harder for users to figure out how multipath was actually
configured. If multipath.conf.defaults was not uptodate, they were
occasionally forced to read the source, wade through debugging output, or
find out experimentally.  Even more confusing, after looking at the devices
section, users would mistakenly believe that a device didn't set any value
for an attribute, because the device had it configured to the same thing
as the defaults section.  Only after the user tried to change the value
by editting the defaults section, would the attribute appear the devices
section. This has caused some annoyance.

This patch makes the defaults section print out all the default configuration
values, unless they really do have an undefined value when left unconfigured.
For the multipaths and hardware handler sections, all attributes that are
configured are printed.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dict.c |  166 ++++++++++++++--------------------------------------
 1 file changed, 47 insertions(+), 119 deletions(-)

Index: multipath-tools-101104/libmultipath/dict.c
===================================================================
--- multipath-tools-101104.orig/libmultipath/dict.c
+++ multipath-tools-101104/libmultipath/dict.c
@@ -338,6 +338,10 @@ def_weight_handler(vector strvec)
 	    !strcmp(buff, "priorities"))
 		conf->rr_weight = RR_WEIGHT_PRIO;
 
+	if (strlen(buff) == strlen("uniform") &&
+	    !strcmp(buff, "uniform"))
+		conf->rr_weight = RR_WEIGHT_NONE;
+
 	FREE(buff);
 
 	return 0;
@@ -954,6 +958,10 @@ hw_weight_handler(vector strvec)
 	    !strcmp(buff, "priorities"))
 		hwe->rr_weight = RR_WEIGHT_PRIO;
 
+	if (strlen(buff) == strlen("uniform") &&
+	    !strcmp(buff, "uniform"))
+		hwe->rr_weight = RR_WEIGHT_NONE;
+
 	FREE(buff);
 
 	return 0;
@@ -1282,6 +1290,10 @@ mp_weight_handler(vector strvec)
 	    !strcmp(buff, "priorities"))
 		mpe->rr_weight = RR_WEIGHT_PRIO;
 
+	if (strlen(buff) == strlen("uniform") &&
+	    !strcmp(buff, "uniform"))
+		mpe->rr_weight = RR_WEIGHT_NONE;
+
 	FREE(buff);
 
 	return 0;
@@ -1406,11 +1418,6 @@ snprint_mp_alias (char * buff, int len, 
 	if (!mpe->alias)
 		return 0;
 
-	if (conf->user_friendly_names &&
-	    (strlen(mpe->alias) == strlen("mpath")) &&
-	    !strcmp(mpe->alias, "mpath"))
-		return 0;
-
 	return snprintf(buff, len, "%s", mpe->alias);
 }
 
@@ -1435,7 +1442,7 @@ snprint_mp_selector (char * buff, int le
 	if (!mpe->selector)
 		return 0;
 
-	return snprintf(buff, len, "%s", mpe->selector);
+	return snprintf(buff, len, "\"%s\"", mpe->selector);
 }
 
 static int
@@ -1498,6 +1505,8 @@ snprint_mp_rr_weight (char * buff, int l
 		return 0;
 	if (mpe->rr_weight == RR_WEIGHT_PRIO)
 		return snprintf(buff, len, "priorities");
+	if (mpe->rr_weight == RR_WEIGHT_NONE)
+		return snprintf(buff, len, "uniform");
 
 	return 0;
 }
@@ -1625,10 +1634,6 @@ snprint_hw_getuid_callout (char * buff, 
 
 	if (!hwe->getuid)
 		return 0;
-	if (conf->getuid &&
-	    strlen(hwe->getuid) == strlen(conf->getuid) &&
-	    !strcmp(hwe->getuid, conf->getuid))
-		return 0;
 
 	return snprintf(buff, len, "\"%s\"", hwe->getuid);
 }
@@ -1638,9 +1643,7 @@ snprint_hw_prio (char * buff, int len, v
 {
 	struct hwentry * hwe = (struct hwentry *)data;
 
-	if (!hwe->prio_name || (strlen(hwe->prio_name) == 0))
-		return 0;
-	if (conf->prio_name && !strcmp(hwe->prio_name, conf->prio_name))
+	if (!hwe->prio_name)
 		return 0;
 
 	return snprintf(buff, len, "%s", hwe->prio_name);
@@ -1651,12 +1654,10 @@ snprint_hw_alias_prefix (char * buff, in
 {
 	struct hwentry * hwe = (struct hwentry *)data;
 
-	if (!hwe->alias_prefix || (strlen(hwe->alias_prefix) == 0))
-		return 0;
-	if (conf->alias_prefix && !strcmp(hwe->alias_prefix, conf->alias_prefix))
+	if (!hwe->alias_prefix)
 		return 0;
 
-	return snprintf(buff, len, "%s", hwe->alias_prefix);
+	return snprintf(buff, len, "\"%s\"", hwe->alias_prefix);
 }
 
 static int
@@ -1664,12 +1665,10 @@ snprint_hw_prio_args (char * buff, int l
 {
 	struct hwentry * hwe = (struct hwentry *)data;
 
-        if (!hwe->prio_args || (strlen(hwe->prio_args) == 0))
-                return 0;
-        if (conf->prio_args && !strcmp(hwe->prio_args, conf->prio_args))
+        if (!hwe->prio_args)
                 return 0;
 
-	return snprintf(buff, len, "%s", hwe->prio_args);
+	return snprintf(buff, len, "\"%s\"", hwe->prio_args);
 }
 
 static int
@@ -1679,10 +1678,6 @@ snprint_hw_features (char * buff, int le
 
 	if (!hwe->features)
 		return 0;
-	if (conf->features &&
-	    strlen(hwe->features) == strlen(conf->features) &&
-	    !strcmp(hwe->features, conf->features))
-		return 0;
 
 	return snprintf(buff, len, "\"%s\"", hwe->features);
 }
@@ -1694,10 +1689,6 @@ snprint_hw_hardware_handler (char * buff
 
 	if (!hwe->hwhandler)
 		return 0;
-	if (conf->hwhandler &&
-	    strlen(hwe->hwhandler) == strlen(conf->hwhandler) &&
-	    !strcmp(hwe->hwhandler, conf->hwhandler))
-		return 0;
 
 	return snprintf(buff, len, "\"%s\"", hwe->hwhandler);
 }
@@ -1709,12 +1700,8 @@ snprint_hw_selector (char * buff, int le
 
 	if (!hwe->selector)
 		return 0;
-	if (conf->selector &&
-	    strlen(hwe->selector) == strlen(conf->selector) &&
-	    !strcmp(hwe->selector, conf->selector))
-		return 0;
 
-	return snprintf(buff, len, "%s", hwe->selector);
+	return snprintf(buff, len, "\"%s\"", hwe->selector);
 }
 
 static int
@@ -1726,8 +1713,6 @@ snprint_hw_path_grouping_policy (char * 
 
 	if (!hwe->pgpolicy)
 		return 0;
-	if (conf->pgpolicy && hwe->pgpolicy == conf->pgpolicy)
-		return 0;
 
 	get_pgpolicy_name(str, POLICY_NAME_SIZE, hwe->pgpolicy);
 
@@ -1741,8 +1726,6 @@ snprint_hw_failback (char * buff, int le
 
 	if (!hwe->pgfailback)
 		return 0;
-	if (conf->pgfailback && hwe->pgfailback == conf->pgfailback)
-		return 0;
 
 	switch(hwe->pgfailback) {
 	case  FAILBACK_UNDEF:
@@ -1764,10 +1747,10 @@ snprint_hw_rr_weight (char * buff, int l
 
 	if (!hwe->rr_weight)
 		return 0;
-	if (conf->rr_weight && hwe->rr_weight == conf->rr_weight)
-		return 0;
 	if (hwe->rr_weight == RR_WEIGHT_PRIO)
 		return snprintf(buff, len, "priorities");
+	if (hwe->rr_weight == RR_WEIGHT_NONE)
+		return snprintf(buff, len, "uniform");
 
 	return 0;
 }
@@ -1779,8 +1762,6 @@ snprint_hw_no_path_retry (char * buff, i
 
 	if (!hwe->no_path_retry)
 		return 0;
-	if (hwe->no_path_retry == conf->no_path_retry)
-		return 0;
 
 	switch(hwe->no_path_retry) {
 	case NO_PATH_RETRY_UNDEF:
@@ -1803,8 +1784,6 @@ snprint_hw_rr_min_io (char * buff, int l
 
 	if (!hwe->minio)
 		return 0;
-	if (hwe->minio == conf->minio)
-		return 0;
 
 	return snprintf(buff, len, "%u", hwe->minio);
 }
@@ -1816,8 +1795,6 @@ snprint_hw_pg_timeout (char * buff, int 
 
 	if (!hwe->pg_timeout)
 		return 0;
-	if (hwe->pg_timeout == conf->pg_timeout)
-		return 0;
 
 	switch (hwe->pg_timeout) {
 	case PGTIMEOUT_UNDEF:
@@ -1851,9 +1828,6 @@ snprint_hw_path_checker (char * buff, in
 
 	if (!hwe->checker_name)
 		return 0;
-	if (conf->checker_name &&
-	    !strcmp(hwe->checker_name, conf->checker_name))
-		return 0;
 
 	return snprintf(buff, len, "%s", hwe->checker_name);
 }
@@ -1861,8 +1835,6 @@ snprint_hw_path_checker (char * buff, in
 static int
 snprint_def_polling_interval (char * buff, int len, void * data)
 {
-	if (conf->checkint == DEFAULT_CHECKINT)
-		return 0;
 	return snprintf(buff, len, "%i", conf->checkint);
 }
 
@@ -1887,8 +1859,6 @@ snprint_def_dev_loss(char * buff, int le
 static int
 snprint_def_verbosity (char * buff, int len, void * data)
 {
-	if (conf->checkint == DEFAULT_VERBOSITY)
-		return 0;
 	return snprintf(buff, len, "%i", conf->verbosity);
 }
 
@@ -1897,9 +1867,6 @@ snprint_def_udev_dir (char * buff, int l
 {
 	if (!conf->udev_dir)
 		return 0;
-	if (strlen(DEFAULT_UDEVDIR) == strlen(conf->udev_dir) &&
-	    !strcmp(conf->udev_dir, DEFAULT_UDEVDIR))
-		return 0;
 
 	return snprintf(buff, len, "\"%s\"", conf->udev_dir);
 }
@@ -1909,9 +1876,6 @@ snprint_def_multipath_dir (char * buff, 
 {
 	if (!conf->udev_dir)
 		return 0;
-	if (strlen(DEFAULT_MULTIPATHDIR) == strlen(conf->multipath_dir) &&
-	    !strcmp(conf->multipath_dir, DEFAULT_MULTIPATHDIR))
-		return 0;
 
 	return snprintf(buff, len, "\"%s\"", conf->multipath_dir);
 }
@@ -1920,25 +1884,21 @@ static int
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
 	char str[POLICY_NAME_SIZE];
+	int pgpolicy = conf->pgpolicy;
 
-	if (!conf->pgpolicy)
-		return 0;
-	if (conf->pgpolicy == DEFAULT_PGPOLICY)
-		return 0;
+	if (!pgpolicy)
+		pgpolicy = DEFAULT_PGPOLICY;
 
-	get_pgpolicy_name(str, POLICY_NAME_SIZE, conf->pgpolicy);
+	get_pgpolicy_name(str, POLICY_NAME_SIZE, pgpolicy);
 
 	return snprintf(buff, len, "%s", str);
 }
@@ -1947,10 +1907,7 @@ static int
 snprint_def_getuid_callout (char * buff, int len, void * data)
 {
 	if (!conf->getuid)
-		return 0;
-	if (strlen(conf->getuid) == strlen(DEFAULT_GETUID) &&
-	    !strcmp(conf->getuid, DEFAULT_GETUID))
-		return 0;
+		return snprintf(buff, len, "\"%s\"", DEFAULT_GETUID);
 
 	return snprintf(buff, len, "\"%s\"", conf->getuid);
 }
@@ -1959,11 +1916,7 @@ static int
 snprint_def_prio (char * buff, int len, void * data)
 {
 	if (!conf->prio_name)
-		return 0;
-
-	if (strlen(conf->prio_name) == strlen(DEFAULT_PRIO) &&
-	    !strcmp(conf->prio_name, DEFAULT_PRIO))
-		return 0;
+		return snprintf(buff, len, "%s", DEFAULT_PRIO);
 
 	return snprintf(buff, len, "%s", conf->prio_name);
 }
@@ -1972,23 +1925,16 @@ static int
 snprint_def_prio_args (char * buff, int len, void * data)
 {
 	if (!conf->prio_args)
-		return 0;
+		return snprintf(buff, len, "\"%s\"", DEFAULT_PRIO_ARGS);
 
-	if (strlen(conf->prio_args) == strlen(DEFAULT_PRIO_ARGS) &&
-	    !strcmp(conf->prio_args, DEFAULT_PRIO_ARGS))
-		return 0;
-
-	return snprintf(buff, len, "%s", conf->prio_args);
+	return snprintf(buff, len, "\"%s\"", conf->prio_args);
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
 
 	return snprintf(buff, len, "\"%s\"", conf->features);
 }
@@ -1997,10 +1943,7 @@ static int
 snprint_def_path_checker (char * buff, int len, void * data)
 {
 	if (!conf->checker_name)
-		return 0;
-	if (strlen(conf->checker_name) == strlen(DEFAULT_CHECKER) &&
-	    !strcmp(conf->checker_name, DEFAULT_CHECKER))
-		return 0;
+		return snprintf(buff, len, "%s", DEFAULT_CHECKER);
 
 	return snprintf(buff, len, "%s", conf->checker_name);
 }
@@ -2008,10 +1951,9 @@ snprint_def_path_checker (char * buff, i
 static int
 snprint_def_failback (char * buff, int len, void * data)
 {
-	if (!conf->pgfailback)
-		return 0;
-	if (conf->pgfailback == DEFAULT_FAILBACK)
-		return 0;
+	int pgfailback = conf->pgfailback;
+	if (!pgfailback)
+		pgfailback = DEFAULT_FAILBACK;
 
 	switch(conf->pgfailback) {
 	case  FAILBACK_UNDEF:
@@ -2031,8 +1973,6 @@ snprint_def_rr_min_io (char * buff, int 
 {
 	if (!conf->minio)
 		return 0;
-	if (conf->minio == DEFAULT_MINIO)
-		return 0;
 
 	return snprintf(buff, len, "%u", conf->minio);
 }
@@ -2073,10 +2013,8 @@ snprint_def_gid(char * buff, int len, vo
 static int
 snprint_def_rr_weight (char * buff, int len, void * data)
 {
-	if (!conf->rr_weight)
-		return 0;
-	if (conf->rr_weight == DEFAULT_RR_WEIGHT)
-		return 0;
+	if (!conf->rr_weight || conf->rr_weight == RR_WEIGHT_NONE)
+		return snprintf(buff, len, "uniform");
 	if (conf->rr_weight == RR_WEIGHT_PRIO)
 		return snprintf(buff, len, "priorities");
 
@@ -2086,9 +2024,6 @@ snprint_def_rr_weight (char * buff, int 
 static int
 snprint_def_no_path_retry (char * buff, int len, void * data)
 {
-	if (conf->no_path_retry == DEFAULT_NO_PATH_RETRY)
-		return 0;
-
 	switch(conf->no_path_retry) {
 	case NO_PATH_RETRY_UNDEF:
 		break;
@@ -2110,6 +2045,7 @@ snprint_def_queue_without_daemon (char *
 	case QUE_NO_DAEMON_OFF:
 		return snprintf(buff, len, "no");
 	case QUE_NO_DAEMON_ON:
+	case QUE_NO_DAEMON_UNDEF:
 		return snprintf(buff, len, "yes");
 	}
 	return 0;
@@ -2127,12 +2063,8 @@ snprint_def_checker_timeout (char *buff,
 static int
 snprint_def_pg_timeout (char * buff, int len, void * data)
 {
-	if (conf->pg_timeout == DEFAULT_PGTIMEOUT)
-		return 0;
-
 	switch (conf->pg_timeout) {
 	case PGTIMEOUT_UNDEF:
-		break;
 	case -PGTIMEOUT_NONE:
 		return snprintf(buff, len, "none");
 	default:
@@ -2145,9 +2077,11 @@ static int
 snprint_def_flush_on_last_del (char * buff, int len, void * data)
 {
 	switch (conf->flush_on_last_del) {
+	case FLUSH_UNDEF:
 	case FLUSH_DISABLED:
 		return snprintf(buff, len, "no");
 	case FLUSH_ENABLED:
+	case FLUSH_IN_PROGRESS:
 		return snprintf(buff, len, "yes");
 	}
 	return 0;
@@ -2156,8 +2090,6 @@ snprint_def_flush_on_last_del (char * bu
 static int
 snprint_def_find_multipaths (char * buff, int len, void * data)
 {
-	if (conf->find_multipaths == DEFAULT_FIND_MULTIPATHS)
-		return 0;
 	if (!conf->find_multipaths)
 		return snprintf(buff, len, "no");
 
@@ -2168,8 +2100,6 @@ snprint_def_find_multipaths (char * buff
 static int
 snprint_def_user_friendly_names (char * buff, int len, void * data)
 {
-	if (conf->user_friendly_names == DEFAULT_USER_FRIENDLY_NAMES)
-		return 0;
 	if (!conf->user_friendly_names)
 		return snprintf(buff, len, "no");
 
@@ -2180,10 +2110,8 @@ static int
 snprint_def_alias_prefix (char * buff, int len, void * data)
 {
 	if (!conf->alias_prefix)
-		return 0;
-	if (!strcmp(conf->alias_prefix, DEFAULT_ALIAS_PREFIX))
-		return 0;
-	return snprintf(buff, len, conf->alias_prefix);
+		return snprintf(buff, len, "\"%s\"", DEFAULT_ALIAS_PREFIX);
+	return snprintf(buff, len, "\"%s\"", conf->alias_prefix);
 }
 
 static int
@@ -2227,7 +2155,7 @@ init_keywords(void)
 	install_keyword("prio_args", &def_prio_args_handler, &snprint_def_prio_args);
 	install_keyword("features", &def_features_handler, &snprint_def_features);
 	install_keyword("path_checker", &def_path_checker_handler, &snprint_def_path_checker);
-	install_keyword("checker", &def_path_checker_handler, &snprint_def_path_checker);
+	install_keyword("checker", &def_path_checker_handler, NULL);
 	install_keyword("alias_prefix", &def_alias_prefix_handler, &snprint_def_alias_prefix);
 	install_keyword("failback", &default_failback_handler, &snprint_def_failback);
 	install_keyword("rr_min_io", &def_minio_handler, &snprint_def_rr_min_io);
@@ -2289,7 +2217,7 @@ init_keywords(void)
 	install_keyword("getuid_callout", &hw_getuid_callout_handler, &snprint_hw_getuid_callout);
 	install_keyword("path_selector", &hw_selector_handler, &snprint_hw_selector);
 	install_keyword("path_checker", &hw_path_checker_handler, &snprint_hw_path_checker);
-	install_keyword("checker", &hw_path_checker_handler, &snprint_hw_path_checker);
+	install_keyword("checker", &hw_path_checker_handler, NULL);
 	install_keyword("alias_prefix", &hw_alias_prefix_handler, &snprint_hw_alias_prefix);
 	install_keyword("features", &hw_features_handler, &snprint_hw_features);
 	install_keyword("hardware_handler", &hw_handler_handler, &snprint_hw_hardware_handler);
