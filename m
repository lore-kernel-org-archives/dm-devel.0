From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.annotated ./m ...
Date: 10 Jan 2007 20:08:12 -0000
Message-ID: <20070110200812.2109.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2007-01-10 20:08:10

Modified files:
	.              : multipath.conf.annotated 
	                 multipath.conf.defaults 
	                 multipath.conf.synthetic 
	libmultipath   : blacklist.c blacklist.h config.c config.h 
	                 dict.c discovery.c hwtable.c print.c print.h 
	multipath      : main.c multipath.conf.redhat 
	multipathd     : cli.c cli.h cli_handlers.c cli_handlers.h 
	                 main.c 

Log message:
	Resolves: bz 219804
	Pulled in the blacklist_exceptions patch from upstream. Made dasds blacklisted
	by default again. Added some a commented out blacklist_exceptions section to
	the default /etc/multipath.conf file, so that it's easy to unblacklist the
	dasd devices.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18&r2=1.18.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.1&r2=1.5.4.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.synthetic.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11&r2=1.11.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/blacklist.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11&r2=1.11.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/blacklist.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.6&r2=1.6.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.19&r2=1.19.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18&r2=1.18.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17&r2=1.17.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.32&r2=1.32.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.2&r2=1.20.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/print.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5&r2=1.5.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/print.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.3&r2=1.3.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.44&r2=1.44.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.conf.redhat.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.6.2.1&r2=1.6.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5&r2=1.5.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5&r2=1.5.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli_handlers.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.6&r2=1.6.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli_handlers.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.3&r2=1.3.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69&r2=1.69.2.1

--- multipath-tools/multipath.conf.annotated	2006/08/02 21:37:22	1.18
+++ multipath-tools/multipath.conf.annotated	2007/01/10 20:08:07	1.18.2.1
@@ -142,6 +142,26 @@
 #               product MSA[15]00
 #       }
 #}
+##
+## name    : blacklist_exceptions
+## scope   : multipath & multipathd
+## desc    : list of device names to be treated as multipath candidates
+##           even if they are on the blacklist.
+##           Note: blacklist exceptions are only valid in the same class.
+##           It is not possible to blacklist devices using the devnode keyword
+##           and to exclude some devices of them using the wwid keyword.
+## default : -
+##
+#blacklist_exceptions {
+#       devnode "^dasd[c-d]+[0-9]*"
+#       wwid    "IBM.75000000092461.4d00.34"
+#       wwid    "IBM.75000000092461.4d00.35"
+#       wwid    "IBM.75000000092461.4d00.36"
+#	device {
+#		vendor "IBM"
+#		product "S/390.*"
+#	}
+#}
 #
 ##
 ## name    : multipaths
--- multipath-tools/multipath.conf.defaults	2006/12/19 22:51:31	1.5.4.1
+++ multipath-tools/multipath.conf.defaults	2007/01/10 20:08:07	1.5.4.2
@@ -118,7 +118,7 @@
 #       device {
 #               vendor                  "DGC"
 #		product			".*"
-#		bl_product		"LUN_Z"
+#		product_blacklist	"LUN_Z"
 #		getuid_callout          "/sbin/scsi_id -g -u -s"
 #		prio_callout		"/sbin/mpath_prio_emc /dev/%n"
 #		features		"1 queue_if_no_path"
@@ -264,6 +264,7 @@
 #	device {
 #		vendor			"IBM"
 #		product			"S/390 DASD ECKD"
+#		product_blacklist	"S/390.*"
 #		getuid_callout		"/sbin/dasd_id /dev/%n"
 #		features		"0"
 #		hardware_handler	"0"
--- multipath-tools/multipath.conf.synthetic	2006/06/06 18:32:43	1.11
+++ multipath-tools/multipath.conf.synthetic	2007/01/10 20:08:07	1.11.2.1
@@ -16,7 +16,7 @@
 #	no_path_retry		fail
 #	user_friendly_names	no
 #}
-#devnode_blacklist {
+#blacklist {
 #       wwid 26353900f02796769
 #	devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
 #	devnode "^hd[a-z][[0-9]*]"
@@ -26,6 +26,10 @@
 #		product MSA[15]00
 #	}
 #}
+#blacklist_exceptions {
+#       devnode "^dasd[c-d]+[0-9]*"
+#       wwid    "IBM.75000000092461.4d00.34"
+#}
 #multipaths {
 #	multipath {
 #		wwid			3600508b4000156d700012000000b0000
--- multipath-tools/libmultipath/blacklist.c	2006/06/06 18:32:43	1.11
+++ multipath-tools/libmultipath/blacklist.c	2007/01/10 20:08:08	1.11.2.1
@@ -2,7 +2,6 @@
  * Copyright (c) 2004, 2005 Christophe Varoqui
  */
 #include <stdio.h>
-
 #include <checkers.h>
 
 #include "memory.h"
@@ -14,7 +13,7 @@
 #include "blacklist.h"
 
 extern int
-store_ble (vector blist, char * str)
+store_ble (vector blist, char * str, int origin)
 {
 	struct blentry * ble;
 	
@@ -36,6 +35,7 @@
 		goto out1;
 
 	ble->str = str;
+	ble->origin = origin;
 	vector_set_slot(blist, ble);
 	return 0;
 out1:
@@ -63,7 +63,7 @@
 }
 	
 extern int
-set_ble_device (vector blist, char * vendor, char * product)
+set_ble_device (vector blist, char * vendor, char * product, int origin)
 {
 	struct blentry_device * ble;
 	
@@ -91,6 +91,7 @@
 		}
 		ble->product = product;
 	}
+	ble->origin = origin;
 	return 0;
 }
 
@@ -105,19 +106,19 @@
 	str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*");
 	if (!str)
 		return 1;
-	if (store_ble(conf->blist_devnode, str))
+	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
 		return 1;
 
 	str = STRDUP("^hd[a-z]");
 	if (!str)
 		return 1;
-	if (store_ble(conf->blist_devnode, str))
+	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
 		return 1;
 	
 	str = STRDUP("^cciss!c[0-9]d[0-9]*");
 	if (!str)
 		return 1;
-	if (store_ble(conf->blist_devnode, str))
+	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
 		return 1;
 
 	vector_foreach_slot (conf->hwtable, hwe, i) {
@@ -128,7 +129,8 @@
 					  VECTOR_SIZE(conf->blist_device) -1);
 			if (set_ble_device(conf->blist_device,
 					   STRDUP(hwe->vendor),
-					   STRDUP(hwe->bl_product))) {
+					   STRDUP(hwe->bl_product),
+					   ORIGIN_DEFAULT)) {
 				FREE(ble);
 				return 1;
 			}
@@ -139,11 +141,29 @@
 }
 
 int
-blacklist (vector blist, char * str)
+blacklist_exceptions (vector elist, char * str)
+{
+        int i;
+        struct blentry * ele;
+
+        vector_foreach_slot (elist, ele, i) {
+                if (!regexec(&ele->regex, str, 0, NULL, 0)) {
+			condlog(3, "%s: exception-listed", str);
+			return 1;
+		}
+	}
+        return 0;
+}
+
+int
+blacklist (vector blist, vector elist, char * str)
 {
 	int i;
 	struct blentry * ble;
 
+	if (blacklist_exceptions(elist, str))
+		return 0;
+
 	vector_foreach_slot (blist, ble, i) {
 		if (!regexec(&ble->regex, str, 0, NULL, 0)) {
 			condlog(3, "%s: blacklisted", str);
@@ -154,15 +174,36 @@
 }
 
 int
-blacklist_device (vector blist, char * vendor, char * product)
+blacklist_exceptions_device(vector elist, char *str, char * vendor, char * product)
+{
+	int i;
+	struct blentry_device * ble;
+
+	vector_foreach_slot (elist, ble, i) {
+		if (!regexec(&ble->vendor_reg, vendor, 0, NULL, 0) &&
+		    !regexec(&ble->product_reg, product, 0, NULL, 0)) {
+			condlog(3, "%s: (%s:%s) exception-listed by product",
+				str, vendor, product);
+			return 1;
+		}
+	}
+	return 0;
+}
+
+int
+blacklist_device (vector blist, vector elist, char *str, char * vendor, char * product)
 {
 	int i;
 	struct blentry_device * ble;
 
+	if (blacklist_exceptions_device(elist, str, vendor, product))
+		return 0;
+
 	vector_foreach_slot (blist, ble, i) {
 		if (!regexec(&ble->vendor_reg, vendor, 0, NULL, 0) &&
 		    !regexec(&ble->product_reg, product, 0, NULL, 0)) {
-			condlog(3, "%s:%s: blacklisted", vendor, product);
+			condlog(3, "%s: (%s:%s) blacklisted by product",
+				str, vendor, product);
 			return 1;
 		}
 	}
@@ -172,14 +213,15 @@
 int
 blacklist_path (struct config * conf, struct path * pp)
 {
-	if (blacklist(conf->blist_devnode, pp->dev))
+	if (blacklist(conf->blist_devnode, conf->elist_devnode, pp->dev))
 		return 1;
 
-	if (blacklist(conf->blist_wwid, pp->wwid))
+	if (blacklist(conf->blist_wwid, conf->elist_wwid, pp->wwid))
 		return 1;
 
 	if (pp->vendor_id && pp->product_id &&
-	    blacklist_device(conf->blist_device, pp->vendor_id, pp->product_id))
+	    blacklist_device(conf->blist_device, conf->elist_device, pp->dev,
+			     pp->vendor_id, pp->product_id))
 		return 1;
 
 	return 0;
--- multipath-tools/libmultipath/blacklist.h	2006/06/06 18:32:43	1.6
+++ multipath-tools/libmultipath/blacklist.h	2007/01/10 20:08:08	1.6.2.1
@@ -6,6 +6,7 @@
 struct blentry {
 	char * str;
 	regex_t regex;
+	int origin;
 };
 
 struct blentry_device {
@@ -13,15 +14,16 @@
 	char * product;
 	regex_t vendor_reg;
 	regex_t product_reg;
+	int origin;
 };
 
 int setup_default_blist (struct config *);
 int alloc_ble_device (vector);
-int blacklist (vector, char *);
-int blacklist_device (vector, char *, char *);
+int blacklist (vector, vector, char *);
+int blacklist_device (vector, vector, char *,char *, char *);
 int blacklist_path (struct config *, struct path *);
-int store_ble (vector, char *);
-int set_ble_device (vector, char *, char *);
+int store_ble (vector, char *, int);
+int set_ble_device (vector, char *, char *, int);
 void free_blacklist (vector);
 void free_blacklist_device (vector);
 
--- multipath-tools/libmultipath/config.c	2006/11/30 23:25:13	1.19
+++ multipath-tools/libmultipath/config.c	2007/01/10 20:08:08	1.19.2.1
@@ -324,6 +324,11 @@
 	free_blacklist(conf->blist_devnode);
 	free_blacklist(conf->blist_wwid);
 	free_blacklist_device(conf->blist_device);
+
+	free_blacklist(conf->elist_devnode);
+	free_blacklist(conf->elist_wwid);
+	free_blacklist_device(conf->elist_device);
+
 	free_mptable(conf->mptable);
 	free_hwtable(conf->hwtable);
 	free_keywords(conf->keywords);
@@ -394,6 +399,26 @@
 	if (setup_default_blist(conf))
 		goto out;
 
+	if (conf->elist_devnode == NULL) {
+                conf->elist_devnode = vector_alloc();
+
+                if (!conf->elist_devnode)
+			goto out;
+	}
+	if (conf->elist_wwid == NULL) {
+		conf->elist_wwid = vector_alloc();
+
+                if (!conf->elist_wwid)
+			goto out;
+	}
+
+	if (conf->elist_device == NULL) {
+		conf->elist_device = vector_alloc();
+		
+		if (!conf->elist_device)
+			goto out;
+	}
+
 	if (conf->mptable == NULL) {
 		conf->mptable = vector_alloc();
 
--- multipath-tools/libmultipath/config.h	2006/06/06 18:32:43	1.18
+++ multipath-tools/libmultipath/config.h	2007/01/10 20:08:08	1.18.2.1
@@ -1,6 +1,9 @@
 #ifndef _CONFIG_H
 #define _CONFIG_H
 
+#define ORIGIN_DEFAULT 0
+#define ORIGIN_CONFIG  1
+
 enum devtypes {
 	DEV_NONE,
 	DEV_DEVT,
@@ -77,6 +80,9 @@
 	vector blist_devnode;
 	vector blist_wwid;
 	vector blist_device;
+	vector elist_devnode;
+	vector elist_wwid;
+	vector elist_device;
 };
 
 struct config * conf;
--- multipath-tools/libmultipath/dict.c	2006/06/06 18:32:43	1.17
+++ multipath-tools/libmultipath/dict.c	2007/01/10 20:08:08	1.17.2.1
@@ -264,6 +264,19 @@
 }
 
 static int
+blacklist_exceptions_handler(vector strvec)
+{
+        conf->elist_devnode = vector_alloc();
+        conf->elist_wwid = vector_alloc();
+	conf->elist_device = vector_alloc();
+
+        if (!conf->elist_devnode || !conf->elist_wwid || !conf->blist_device)
+                return 1;
+
+        return 0;
+}
+
+static int
 ble_devnode_handler(vector strvec)
 {
 	char * buff;
@@ -273,7 +286,20 @@
 	if (!buff)
 		return 1;
 
-	return store_ble(conf->blist_devnode, buff);
+	return store_ble(conf->blist_devnode, buff, ORIGIN_CONFIG);
+}
+
+static int
+ble_except_devnode_handler(vector strvec)
+{
+        char * buff;
+
+        buff = set_value(strvec);
+
+        if (!buff)
+                return 1;
+
+	return store_ble(conf->elist_devnode, buff, ORIGIN_CONFIG);
 }
 
 static int
@@ -286,7 +312,20 @@
 	if (!buff)
 		return 1;
 
-	return store_ble(conf->blist_wwid, buff);
+	return store_ble(conf->blist_wwid, buff, ORIGIN_CONFIG);
+}
+
+static int
+ble_except_wwid_handler(vector strvec)
+{
+        char * buff;
+
+        buff = set_value(strvec);
+
+        if (!buff)
+                return 1;
+
+	return store_ble(conf->elist_wwid, buff, ORIGIN_CONFIG);
 }
 
 static int
@@ -296,6 +335,12 @@
 }
 
 static int
+ble_except_device_handler(vector strvec)
+{
+	return alloc_ble_device(conf->elist_device);
+}
+
+static int
 ble_vendor_handler(vector strvec)
 {
 	char * buff;
@@ -305,7 +350,20 @@
 	if (!buff)
 		return 1;
 
-	return set_ble_device(conf->blist_device, buff, NULL);
+	return set_ble_device(conf->blist_device, buff, NULL, ORIGIN_CONFIG);
+}
+
+static int
+ble_except_vendor_handler(vector strvec)
+{
+	char * buff;
+
+	buff = set_value(strvec);
+
+	if (!buff)
+		return 1;
+
+	return set_ble_device(conf->elist_device, buff, NULL, ORIGIN_CONFIG);
 }
 
 static int
@@ -318,7 +376,20 @@
 	if (!buff)
 		return 1;
 
-	return set_ble_device(conf->blist_device, NULL, buff);
+	return set_ble_device(conf->blist_device, NULL, buff, ORIGIN_CONFIG);
+}
+
+static int
+ble_except_product_handler(vector strvec)
+{
+	char * buff;
+
+	buff = set_value(strvec);
+
+	if (!buff)
+		return 1;
+
+	return set_ble_device(conf->elist_device, NULL, buff, ORIGIN_CONFIG);
 }
 
 /*
@@ -1476,6 +1547,14 @@
 	install_keyword("vendor", &ble_vendor_handler, &snprint_bled_vendor);
 	install_keyword("product", &ble_product_handler, &snprint_bled_product);
 	install_sublevel_end();
+	install_keyword_root("blacklist_exceptions", &blacklist_exceptions_handler);
+	install_keyword("devnode", &ble_except_devnode_handler, &snprint_ble_simple);
+	install_keyword("wwid", &ble_except_wwid_handler, &snprint_ble_simple);
+	install_keyword("device", &ble_except_device_handler, NULL);
+	install_sublevel();
+	install_keyword("vendor", &ble_except_vendor_handler, &snprint_bled_vendor);
+	install_keyword("product", &ble_except_product_handler, &snprint_bled_product);
+	install_sublevel_end();
 
 #if 0
 	__deprecated install_keyword_root("devnode_blacklist", &blacklist_handler);
--- multipath-tools/libmultipath/discovery.c	2006/10/12 16:16:09	1.32
+++ multipath-tools/libmultipath/discovery.c	2007/01/10 20:08:08	1.32.2.1
@@ -104,7 +104,7 @@
 	if (!devname)
 		return 0;
 
-	if (blacklist(conf->blist_devnode, devname))
+	if (blacklist(conf->blist_devnode, conf->elist_devnode, devname))
 		return 0;
 
 	if(safe_sprintf(path, "%s/block/%s/device", sysfs_path,
--- multipath-tools/libmultipath/hwtable.c	2006/12/19 22:51:32	1.20.2.2
+++ multipath-tools/libmultipath/hwtable.c	2007/01/10 20:08:08	1.20.2.3
@@ -371,6 +371,7 @@
 		/* IBM S/390 ECKD DASD */
 		.vendor        = "IBM",
 		.product       = "S/390 DASD ECKD",
+		.bl_product    = "S/390.*",
 		.getuid        = "/sbin/dasd_id /dev/%n",
 		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
--- multipath-tools/libmultipath/print.c	2006/07/13 19:49:23	1.5
+++ multipath-tools/libmultipath/print.c	2007/01/10 20:08:08	1.5.2.1
@@ -5,6 +5,8 @@
 #include <string.h>
 #include <libdevmapper.h>
 #include <stdarg.h>
+#include <sysfs/dlist.h>
+#include <sysfs/libsysfs.h>
 
 #include <checkers.h>
 
@@ -18,6 +20,7 @@
 #include "pgpolicies.h"
 #include "defaults.h"
 #include "parser.h"
+#include "blacklist.h"
 
 #define MAX(x,y) (x > y) ? x : y
 #define TAIL     (line + len - 1 - c)
@@ -850,6 +853,110 @@
 	
 }
 
+static int
+snprint_blacklist_group (char *buff, int len, int *fwd, vector *vec)
+{
+	int threshold = MAX_LINE_LEN;
+	struct blentry * ble;
+	int pos;
+	int i;
+
+	pos = *fwd;
+	if (!VECTOR_SIZE(*vec)) {
+		if ((len - pos - threshold) <= 0)
+			return 0;
+		pos += snprintf(buff + pos, len - pos, "        <empty>\n");
+	} else vector_foreach_slot (*vec, ble, i) {
+		if ((len - pos - threshold) <= 0)
+			return 0;
+		if (ble->origin == ORIGIN_CONFIG)
+			pos += snprintf(buff + pos, len - pos, "        (config file rule) ");
+		else if (ble->origin == ORIGIN_DEFAULT)
+			pos += snprintf(buff + pos, len - pos, "        (default rule)     ");
+		pos += snprintf(buff + pos, len - pos, "%s\n", ble->str);
+	}
+
+	*fwd = pos;
+	return pos;
+}
+
+static int
+snprint_blacklist_devgroup (char *buff, int len, int *fwd, vector *vec)
+{
+	int threshold = MAX_LINE_LEN;
+	struct blentry_device * bled;
+	int pos;
+	int i;
+
+	pos = *fwd;
+	if (!VECTOR_SIZE(*vec)) {
+		if ((len - pos - threshold) <= 0)
+			return 0;
+		pos += snprintf(buff + pos, len - pos, "        <empty>\n");
+	} else vector_foreach_slot (*vec, bled, i) {
+		if ((len - pos - threshold) <= 0)
+			return 0;
+		if (bled->origin == ORIGIN_CONFIG)
+			pos += snprintf(buff + pos, len - pos, "        (config file rule) ");
+		else if (bled->origin == ORIGIN_DEFAULT)
+			pos += snprintf(buff + pos, len - pos, "        (default rule)     ");
+		pos += snprintf(buff + pos, len - pos, "%s:%s\n", bled->vendor, bled->product);
+	}
+
+	*fwd = pos;
+	return pos;
+}
+
+extern int
+snprint_blacklist_report (char * buff, int len)
+{
+	int threshold = MAX_LINE_LEN;
+	int fwd = 0;
+
+	if ((len - fwd - threshold) <= 0)
+		return len;
+	fwd += snprintf(buff + fwd, len - fwd, "device node rules:\n"
+			                       "- blacklist:\n");
+	if (!snprint_blacklist_group(buff, len, &fwd, &conf->blist_devnode))
+		return len;
+
+	if ((len - fwd - threshold) <= 0)
+		return len;
+	fwd += snprintf(buff + fwd, len - fwd, "- exceptions:\n");
+	if (snprint_blacklist_group(buff, len, &fwd, &conf->elist_devnode) == 0)
+		return len;
+
+	if ((len - fwd - threshold) <= 0)
+		return len;
+	fwd += snprintf(buff + fwd, len - fwd, "wwid rules:\n"
+			                       "- blacklist:\n");
+	if (snprint_blacklist_group(buff, len, &fwd, &conf->blist_wwid) == 0)
+		return len;
+
+	if ((len - fwd - threshold) <= 0)
+		return len;
+	fwd += snprintf(buff + fwd, len - fwd, "- exceptions:\n");
+	if (snprint_blacklist_group(buff, len, &fwd, &conf->elist_wwid) == 0)
+		return len;
+
+	if ((len - fwd - threshold) <= 0)
+		return len;
+	fwd += snprintf(buff + fwd, len - fwd, "device rules:\n"
+			                       "- blacklist:\n");
+	if (snprint_blacklist_devgroup(buff, len, &fwd, &conf->blist_device) == 0)
+		return len;
+
+	if ((len - fwd - threshold) <= 0)
+		return len;
+	fwd += snprintf(buff + fwd, len - fwd, "- exceptions:\n");
+	if (snprint_blacklist_devgroup(buff, len, &fwd, &conf->elist_device) == 0)
+		return len;
+
+	if (fwd > len)
+		return len;
+	return fwd;
+}
+
 extern int
 snprint_blacklist (char * buff, int len)
 {
@@ -912,12 +1019,123 @@
 		if (fwd > len)
 			return len;
 	}
+	fwd += snprintf(buff + fwd, len - fwd, "}\n");
+	if (fwd > len)
+		return len;
+	return fwd;
+}
 
+extern int
+snprint_blacklist_except (char * buff, int len)
+{
+	int i;
+	struct blentry * ele;
+	struct blentry_device * eled;
+	int fwd = 0;
+	struct keyword *rootkw;
+	struct keyword *kw;
+
+	rootkw = find_keyword(NULL, "blacklist_exceptions");
+	if (!rootkw)
+		return 0;
+
+	fwd += snprintf(buff + fwd, len - fwd, "blacklist_exceptions {\n");
+	if (fwd > len)
+		return len;
+
+	vector_foreach_slot (conf->elist_devnode, ele, i) {
+		kw = find_keyword(rootkw->sub, "devnode");
+		if (!kw)
+			return 0;
+		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
+				       kw, ele);
+		if (fwd > len)
+			return len;
+	}
+	vector_foreach_slot (conf->elist_wwid, ele, i) {
+		kw = find_keyword(rootkw->sub, "wwid");
+		if (!kw)
+			return 0;
+		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
+				       kw, ele);
+		if (fwd > len)
+			return len;
+	}
+	rootkw = find_keyword(rootkw->sub, "device");
+	if (!rootkw)
+		return 0;
+
+	vector_foreach_slot (conf->elist_device, eled, i) {
+		fwd += snprintf(buff + fwd, len - fwd, "\tdevice {\n");
+		if (fwd > len)
+			return len;
+		kw = find_keyword(rootkw->sub, "vendor");
+		if (!kw)
+			return 0;
+		fwd += snprint_keyword(buff + fwd, len - fwd, "\t\t%k %v\n",
+				       kw, eled);
+		if (fwd > len)
+			return len;
+		kw = find_keyword(rootkw->sub, "product");
+		if (!kw)
+			return 0;
+		fwd += snprint_keyword(buff + fwd, len - fwd, "\t\t%k %v\n",
+				       kw, eled);
+		if (fwd > len)
+			return len;
+		fwd += snprintf(buff + fwd, len - fwd, "\t}\n");
+		if (fwd > len)
+			return len;
+	}
 	fwd += snprintf(buff + fwd, len - fwd, "}\n");
 	if (fwd > len)
 		return len;
 	return fwd;
-	
+}
+
+extern int
+snprint_devices (char * buff, int len, struct vectors *vecs)
+{
+        struct dlist * ls;
+        struct sysfs_class * class;
+        struct sysfs_class_device * dev;
+	int threshold = MAX_LINE_LEN;
+	int fwd = 0;
+
+
+	struct path * pp;
+
+
+
+        if (!(class = sysfs_open_class("block")))
+                return 0;
+
+        if (!(ls = sysfs_get_class_devices(class))) {
+                sysfs_close_class(class);
+                return 0;
+        }
+
+	if ((len - fwd - threshold) <= 0)
+		return len;
+	fwd += snprintf(buff + fwd, len - fwd, "available block devices:\n");
+
+        dlist_for_each_data(ls, dev, struct sysfs_class_device) {
+		if ((len - fwd - threshold)  <= 0)
+			return len;
+		fwd += snprintf(buff + fwd, len - fwd, "    %s ", dev->name);
+		pp = find_path_by_dev(vecs->pathvec, dev->name);
+		if (blacklist(conf->blist_devnode, conf->elist_devnode,
+			      dev->name) || pp == NULL)
+			fwd += snprintf(buff + fwd, len - fwd,
+					"(blacklisted)\n");
+                else
+			fwd += snprintf(buff + fwd, len - fwd, "\n");
+        }
+        sysfs_close_class(class);
+
+	if (fwd > len)
+		return len;
+	return fwd;
 }
 
 extern int
--- multipath-tools/libmultipath/print.h	2006/06/06 18:32:43	1.3
+++ multipath-tools/libmultipath/print.h	2007/01/10 20:08:08	1.3.2.1
@@ -42,6 +42,9 @@
 				int verbosity);
 int snprint_defaults (char *, int);
 int snprint_blacklist (char *, int);
+int snprint_blacklist_except (char *, int);
+int snprint_blacklist_report (char *, int);
+int snprint_devices (char *, int, struct vectors *);
 int snprint_hwtable (char *, int, vector);
 int snprint_mptable (char *, int, vector);
 
--- multipath-tools/multipath/main.c	2006/11/30 23:25:13	1.44
+++ multipath-tools/multipath/main.c	2007/01/10 20:08:08	1.44.2.1
@@ -1,7 +1,7 @@
 /*
  * Soft:        multipath device mapper target autoconfig
  *
- * Version:     $Id: main.c,v 1.44 2006/11/30 23:25:13 bmarzins Exp $
+ * Version:     $Id: main.c,v 1.44.2.1 2007/01/10 20:08:08 bmarzins Exp $
  *
  * Author:      Christophe Varoqui
  *
@@ -232,7 +232,7 @@
 			dev = conf->dev;
 	}
 	
-	if (dev && blacklist(conf->blist_devnode, dev))
+	if (dev && blacklist(conf->blist_devnode, conf->elist_devnode, dev))
 		goto out;
 	
 	/*
@@ -248,7 +248,7 @@
 		}
 		condlog(3, "scope limited to %s", refwwid);
 
-		if (blacklist(conf->blist_wwid, refwwid))
+		if (blacklist(conf->blist_wwid, conf->elist_wwid, refwwid))
 			goto out;
 	}
 
--- multipath-tools/multipath/multipath.conf.redhat	2006/12/14 23:44:33	1.6.2.1
+++ multipath-tools/multipath/multipath.conf.redhat	2007/01/10 20:08:08	1.6.2.2
@@ -11,6 +11,16 @@
         devnode "*"
 }
 
+## By default, devices with vendor = "IBM" and product = "S/390.*" are
+## blacklisted. To enable mulitpathing on these devies, uncomment the
+## following lines.
+#blacklist_exceptions {
+#	device {
+#		vendor	"IBM"
+#		product	"S/390.*"
+#	}
+#}
+
 ## Use user friendly names, instead of using WWIDs as names.
 defaults {
 	user_friendly_names yes
--- multipath-tools/multipathd/cli.c	2006/06/06 18:32:44	1.5
+++ multipath-tools/multipathd/cli.c	2007/01/10 20:08:09	1.5.2.1
@@ -141,6 +141,8 @@
 	r += add_key(keys, "stats", STATS, 0);
 	r += add_key(keys, "topology", TOPOLOGY, 0);
 	r += add_key(keys, "config", CONFIG, 0);
+	r += add_key(keys, "blacklist", BLACKLIST, 0);
+	r += add_key(keys, "devices", DEVICES, 0);
 
 	if (r) {
 		free_keys(keys);
--- multipath-tools/multipathd/cli.h	2006/06/06 18:32:44	1.5
+++ multipath-tools/multipathd/cli.h	2007/01/10 20:08:09	1.5.2.1
@@ -17,6 +17,8 @@
 	__STATS,
 	__TOPOLOGY,
 	__CONFIG,
+	__BLACKLIST,
+	__DEVICES,
 };
 
 #define LIST		(1 << __LIST)
@@ -37,6 +39,8 @@
 #define STATS		(1 << __STATS)
 #define TOPOLOGY	(1 << __TOPOLOGY)
 #define CONFIG		(1 << __CONFIG)
+#define BLACKLIST	(1 << __BLACKLIST)
+#define DEVICES  	(1 << __DEVICES)
 
 #define INITIAL_REPLY_LEN 1000
 
--- multipath-tools/multipathd/cli_handlers.c	2006/07/13 19:49:23	1.6
+++ multipath-tools/multipathd/cli_handlers.c	2007/01/10 20:08:09	1.6.2.1
@@ -143,6 +143,12 @@
 			reply = REALLOC(reply, maxlen *= 2);
 			continue;
 		}
+		c += snprint_blacklist_except(c, reply + maxlen - c);
+		again = ((c - reply) == maxlen);
+		if (again) {
+			reply = REALLOC(reply, maxlen *= 2);
+			continue;
+		}
 		c += snprint_hwtable(c, reply + maxlen - c, conf->hwtable);
 		again = ((c - reply) == maxlen);
 		if (again) {
@@ -280,7 +286,7 @@
 
 	condlog(2, "%s: add path (operator)", param);
 
-	if (blacklist(conf->blist_devnode, param) ||
+	if (blacklist(conf->blist_devnode, conf->elist_devnode, param) ||
 	    (r = ev_add_path(param, vecs)) == 2) {
 		*reply = strdup("blacklisted");
 		*len = strlen(*reply) + 1;
@@ -309,7 +315,7 @@
 
 	condlog(2, "%s: add map (operator)", param);
 
-	if (blacklist(conf->blist_wwid, param)) {
+	if (blacklist(conf->blist_wwid, conf->elist_wwid, param)) {
 		*reply = strdup("blacklisted");
 		*len = strlen(*reply) + 1;
 		condlog(2, "%s: map blacklisted", param);
@@ -433,3 +439,79 @@
 
 	return dm_fail_path(pp->mpp->alias, pp->dev_t);
 }
+
+int
+show_blacklist (char ** r, int * len)
+{
+        char *c = NULL;
+        char *reply = NULL;
+        unsigned int maxlen = INITIAL_REPLY_LEN;
+        int again = 1;
+
+        while (again) {
+		reply = MALLOC(maxlen);
+		if (!reply)
+			return 1;
+
+                c = reply;
+                c += snprint_blacklist_report(c, maxlen);
+                again = ((c - reply) == maxlen);
+                if (again) {
+			maxlen  *= 2;
+			FREE(reply);
+                        continue;
+                }
+        }
+
+        *r = reply;
+        *len = (int)(c - reply + 1);
+
+        return 0;
+}
+
+int
+cli_list_blacklist (void * v, char ** reply, int * len, void * data)
+{
+        condlog(3, "list blacklist (operator)");
+
+        return show_blacklist(reply, len);
+}
+
+int
+show_devices (char ** r, int * len, struct vectors *vecs)
+{
+        char *c = NULL;
+        char *reply = NULL;
+        unsigned int maxlen = INITIAL_REPLY_LEN;
+        int again = 1;
+
+        while (again) {
+                reply = MALLOC(maxlen);
+                if (!reply)
+                        return 1;
+
+                c = reply;
+                c += snprint_devices(c, maxlen, vecs);
+                again = ((c - reply) == maxlen);
+                if (again) {
+                        maxlen  *= 2;
+                        FREE(reply);
+                        continue;
+                }
+        }
+
+        *r = reply;
+        *len = (int)(c - reply + 1);
+
+        return 0;
+}
+
+int
+cli_list_devices (void * v, char ** reply, int * len, void * data)
+{
+	struct vectors * vecs = (struct vectors *)data;
+
+        condlog(3, "list devices (operator)");
+
+        return show_devices(reply, len, vecs);
+}
--- multipath-tools/multipathd/cli_handlers.h	2006/06/06 18:32:44	1.3
+++ multipath-tools/multipathd/cli_handlers.h	2007/01/10 20:08:09	1.3.2.1
@@ -5,6 +5,8 @@
 int cli_list_map_topology (void * v, char ** reply, int * len, void * data);
 int cli_list_maps_topology (void * v, char ** reply, int * len, void * data);
 int cli_list_config (void * v, char ** reply, int * len, void * data);
+int cli_list_blacklist (void * v, char ** reply, int * len, void * data);
+int cli_list_devices (void * v, char ** reply, int * len, void * data);
 int cli_add_path (void * v, char ** reply, int * len, void * data);
 int cli_del_path (void * v, char ** reply, int * len, void * data);
 int cli_add_map (void * v, char ** reply, int * len, void * data);
--- multipath-tools/multipathd/main.c	2006/10/12 16:16:09	1.69
+++ multipath-tools/multipathd/main.c	2007/01/10 20:08:09	1.69.2.1
@@ -675,7 +675,7 @@
 	/*
 	 * path add/remove event
 	 */
-	if (blacklist(conf->blist_devnode, devname))
+	if (blacklist(conf->blist_devnode, conf->elist_devnode, devname))
 		goto out;
 
 	if (!strncmp(uev->action, "add", 3)) {
@@ -718,6 +718,8 @@
 	add_handler(LIST+TOPOLOGY, cli_list_maps_topology);
 	add_handler(LIST+MAP+TOPOLOGY, cli_list_map_topology);
 	add_handler(LIST+CONFIG, cli_list_config);
+	add_handler(LIST+BLACKLIST, cli_list_blacklist);
+	add_handler(LIST+DEVICES, cli_list_devices);
 	add_handler(ADD+PATH, cli_add_path);
 	add_handler(DEL+PATH, cli_del_path);
 	add_handler(ADD+MAP, cli_add_map);
