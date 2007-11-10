From: bmarzins@sourceware.org
Subject: multipath-tools libmultipath/config.c libmulti ...
Date: 10 Nov 2007 00:02:00 -0000
Message-ID: <20071110000200.31229.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2007-11-10 00:01:59

Modified files:
	libmultipath   : config.c dict.c 
	multipath      : main.c 

Log message:
	Fix for bz #356331. Add bindings_file paramter to /etc/multipath.conf, so that
	you can select an alternative location for the user_friendly_names bindings
	file.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.19.2.2&r2=1.19.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17.2.1&r2=1.17.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.44.2.3&r2=1.44.2.4

--- multipath-tools/libmultipath/config.c	2007/07/13 18:30:24	1.19.2.2
+++ multipath-tools/libmultipath/config.c	2007/11/10 00:01:59	1.19.2.3
@@ -323,6 +323,9 @@
 	if (conf->hwhandler)
 		FREE(conf->hwhandler);
 
+	if (conf->bindings_file)
+		FREE(conf->bindings_file);
+
 	free_blacklist(conf->blist_devnode);
 	free_blacklist(conf->blist_wwid);
 	free_blacklist_device(conf->blist_device);
@@ -354,7 +357,6 @@
 
 	conf->dev_type = DEV_NONE;
 	conf->minio = 1000;
-	conf->bindings_file = DEFAULT_BINDINGS_FILE;
 
 	/*
 	 * read the config file
@@ -442,9 +444,12 @@
 	if (conf->hwhandler == NULL)
 		conf->hwhandler = set_default(DEFAULT_HWHANDLER);
 
+	if (conf->bindings_file == NULL)
+		conf->bindings_file = set_default(DEFAULT_BINDINGS_FILE);
+
 	if (!conf->selector  || !conf->udev_dir         ||
 	    !conf->getuid    || !conf->features ||
-	    !conf->hwhandler)
+	    !conf->hwhandler || !conf->bindings_file)
 		goto out;
 
 	if (!conf->checker)
--- multipath-tools/libmultipath/dict.c	2007/01/10 20:08:08	1.17.2.1
+++ multipath-tools/libmultipath/dict.c	2007/11/10 00:01:59	1.17.2.2
@@ -247,6 +247,17 @@
 	return 0;
 }
 
+static int
+bindings_file_handler(vector strvec)
+{
+	conf->bindings_file = set_value(strvec);
+
+	if (!conf->bindings_file)
+		return 1;
+
+	return 0;
+}
+
 /*
  * blacklist block handlers
  */
@@ -1489,6 +1500,18 @@
 }
 
 static int
+snprint_def_bindings_file (char * buff, int len, void * data)
+{
+	if (conf->bindings_file == NULL)
+		return 0;
+	if (strlen(conf->bindings_file) == strlen(DEFAULT_BINDINGS_FILE) &&
+	    !strcmp(conf->bindings_file, DEFAULT_BINDINGS_FILE))
+		return 0;
+
+	return snprintf(buff, len, "%s", conf->bindings_file);
+}
+
+static int
 snprint_ble_simple (char * buff, int len, void * data)
 {
 	struct blentry * ble = (struct blentry *)data;
@@ -1532,6 +1555,7 @@
 	install_keyword("no_path_retry", &def_no_path_retry_handler, &snprint_def_no_path_retry);
 	install_keyword("pg_timeout", &def_pg_timeout_handler, &snprint_def_pg_timeout);
 	install_keyword("user_friendly_names", &names_handler, &snprint_def_user_friendly_names);
+	install_keyword("bindings_file", &bindings_file_handler, &snprint_def_bindings_file);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_getuid_callout", &def_getuid_callout_handler, NULL);
--- multipath-tools/multipath/main.c	2007/06/18 17:37:18	1.44.2.3
+++ multipath-tools/multipath/main.c	2007/11/10 00:01:59	1.44.2.4
@@ -1,7 +1,7 @@
 /*
  * Soft:        multipath device mapper target autoconfig
  *
- * Version:     $Id: main.c,v 1.44.2.3 2007/06/18 17:37:18 bmarzins Exp $
+ * Version:     $Id: main.c,v 1.44.2.4 2007/11/10 00:01:59 bmarzins Exp $
  *
  * Author:      Christophe Varoqui
  *
@@ -335,7 +335,9 @@
 			conf->verbosity = atoi(optarg);
 			break;
 		case 'b':
-			conf->bindings_file = optarg;
+			if (conf->bindings_file)
+				FREE(conf->bindings_file);	
+			conf->bindings_file = STRDUP(optarg);
 			break;
 		case 'd':
 			conf->dry_run = 1;
