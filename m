From: Volker Sameske <sameske@de.ibm.com>
Subject: [Patch] mp-tools: exception list handling
Date: Thu, 7 Dec 2006 15:03:13 +0100
Message-ID: <20061207150313.8b4c4f5b.sameske@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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
To: dm-devel@redhat.com, christophe.varoqui@free.fr
List-Id: dm-devel.ids

mp-tools: exception list handling

Signed-off-by: Volker Sameske <sameske@de.ibm.com>
---

On IBM System z we often have the problem that we have attached
several hundred devices. In case we want to use only a few of them
with mp-tools, we have to blacklist all others. For that reason I have
introduced a blacklist_exception keyword for the multipath.conf  which
fills an internal exception list.

Additionally this patch adds two commands to the multipathd cli to 
display blacklist rules and blacklisted devices.

A multipath.conf like:
------------------- snip --------------------
blacklist {
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^hd[a-z][[0-9]*]"
        devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
        devnode "^dasd[a-z]+[0-9]*"
}
blacklist_exceptions {
        devnode "^dasd[c-d]+[0-9]*"
}
devices {
       device {
               vendor                  "IBM"
               product                 "S/390 DASD ECKD"
               path_grouping_policy    multibus
               getuid_callout          "dasdinfo -u -l %n"
               path_checker            directio
               path_selector           "round-robin 0"
               hardware_handler        "0"
       }
}
------------------- snap --------------------

would activate S/390 DASD ECKD devices. In the blacklist
section all DASD devices are blacklisted except dasdc and
dasdd and corresponding partitions, which are listed in
the blacklist:exceptions section.
This example would produce the following output in the 
"multipathd -k" cli:

------------------- snip --------------------
multipathd> show blacklist
device node rules:
- blacklist:
        (config file rule) ^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*
        (config file rule) ^hd[a-z][[0-9]*]
        (config file rule) ^cciss!c[0-9]d[0-9]*[p[0-9]*]
        (config file rule) ^dasd[a-z]+[0-9]*
        (default rule)     ^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*
        (default rule)     ^hd[a-z]
        (default rule)     ^cciss!c[0-9]d[0-9]*
- exceptions:
        (config file rule) ^dasd[c-d]+[0-9]*
wwid rules:
- blacklist:
        <empty>
- exceptions:
        <empty>
device rules:
- blacklist:
        (default rule)     DGC:LUNZ
multipathd>

multipathd> show devices
available block devices:
    dasda (blacklisted)
    dasdb (blacklisted)
    dasdc
    dasdd
    dm-0 (blacklisted)
    dm-1 (blacklisted)
    dm-2 (blacklisted)
    dm-3 (blacklisted)
    dm-4 (blacklisted)
    dm-5 (blacklisted)
    dm-6 (blacklisted)
    loop0 (blacklisted)
    loop1 (blacklisted)
    loop2 (blacklisted)
    loop3 (blacklisted)
    loop4 (blacklisted)
    loop5 (blacklisted)
    loop6 (blacklisted)
    loop7 (blacklisted)
    ram0 (blacklisted)
    ram10 (blacklisted)
    ram11 (blacklisted)
    ram12 (blacklisted)
    ram13 (blacklisted)
    ram14 (blacklisted)
    ram15 (blacklisted)
    ram1 (blacklisted)
    ram2 (blacklisted)
    ram3 (blacklisted)
    ram4 (blacklisted)
    ram5 (blacklisted)
    ram6 (blacklisted)
    ram7 (blacklisted)
    ram8 (blacklisted)
    ram9 (blacklisted)
    sda
    sdb
    sdc
    sdd
multipathd>
------------------- snap --------------------


# diffstat mp-tools-exception-list-handling.patch
 libmultipath/blacklist.c  |   40 +++++++---
 libmultipath/blacklist.h  |    8 +-
 libmultipath/config.c     |   19 ++++
 libmultipath/config.h     |    5 +
 libmultipath/dict.c       |   49 +++++++++++-
 libmultipath/discovery.c  |    2
 libmultipath/print.c      |  182 ++++++++++++++++++++++++++++++++--------------
 libmultipath/print.h      |    1
 multipath.conf.annotated  |   16 ++++
 multipath.conf.synthetic  |    6 +
 multipath/main.c          |    4 -
 multipathd/cli.c          |    2
 multipathd/cli.h          |    4 +
 multipathd/cli_handlers.c |   80 +++++++++++++++++++-
 multipathd/cli_handlers.h |    2
 multipathd/main.c         |    4 -
 multipathd/multipathd.8   |    6 +
 17 files changed, 353 insertions(+), 77 deletions(-)
#

diff -Nurp --exclude='*~' multipath-tools-mp-bleed-20061130/libmultipath/blacklist.c multipath-tools-mp-bleed-20061130-work/libmultipath/blacklist.c
--- multipath-tools-mp-bleed-20061130/libmultipath/blacklist.c	2006-11-30 13:28:06.000000000 +0100
+++ multipath-tools-mp-bleed-20061130-work/libmultipath/blacklist.c	2006-12-07 10:47:10.000000000 +0100
@@ -14,7 +13,7 @@
 #include "blacklist.h"
 
 extern int
-store_ble (vector blist, char * str)
+store_ble (vector blist, char * str, int origin)
 {
 	struct blentry * ble;
 	
@@ -36,6 +35,7 @@ store_ble (vector blist, char * str)
 		goto out1;
 
 	ble->str = str;
+	ble->origin = origin;
 	vector_set_slot(blist, ble);
 	return 0;
 out1:
@@ -63,7 +63,7 @@ alloc_ble_device (vector blist)
 }
 	
 extern int
-set_ble_device (vector blist, char * vendor, char * product)
+set_ble_device (vector blist, char * vendor, char * product, int origin)
 {
 	struct blentry_device * ble;
 	
@@ -91,6 +91,7 @@ set_ble_device (vector blist, char * ven
 		}
 		ble->product = product;
 	}
+	ble->origin = origin;
 	return 0;
 }
 
@@ -105,19 +106,19 @@ setup_default_blist (struct config * con
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
@@ -128,7 +129,8 @@ setup_default_blist (struct config * con
 					  VECTOR_SIZE(conf->blist_device) -1);
 			if (set_ble_device(conf->blist_device,
 					   STRDUP(hwe->vendor),
-					   STRDUP(hwe->bl_product))) {
+					   STRDUP(hwe->bl_product),
+					   ORIGIN_DEFAULT)) {
 				FREE(ble);
 				return 1;
 			}
@@ -139,11 +141,29 @@ setup_default_blist (struct config * con
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
@@ -172,10 +192,10 @@ blacklist_device (vector blist, char * v
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
diff -Nurp --exclude='*~' multipath-tools-mp-bleed-20061130/libmultipath/blacklist.h multipath-tools-mp-bleed-20061130-work/libmultipath/blacklist.h
--- multipath-tools-mp-bleed-20061130/libmultipath/blacklist.h	2006-11-30 13:28:06.000000000 +0100
+++ multipath-tools-mp-bleed-20061130-work/libmultipath/blacklist.h	2006-12-07 08:27:12.000000000 +0100
@@ -6,6 +6,7 @@
 struct blentry {
 	char * str;
 	regex_t regex;
+	int origin;
 };
 
 struct blentry_device {
@@ -13,15 +14,16 @@ struct blentry_device {
 	char * product;
 	regex_t vendor_reg;
 	regex_t product_reg;
+	int origin;
 };
 
 int setup_default_blist (struct config *);
 int alloc_ble_device (vector);
-int blacklist (vector, char *);
+int blacklist (vector, vector, char *);
 int blacklist_device (vector, char *, char *);
 int blacklist_path (struct config *, struct path *);
-int store_ble (vector, char *);
-int set_ble_device (vector, char *, char *);
+int store_ble (vector, char *, int);
+int set_ble_device (vector, char *, char *, int);
 void free_blacklist (vector);
 void free_blacklist_device (vector);
 
diff -Nurp --exclude='*~' multipath-tools-mp-bleed-20061130/libmultipath/config.c multipath-tools-mp-bleed-20061130-work/libmultipath/config.c
--- multipath-tools-mp-bleed-20061130/libmultipath/config.c	2006-11-30 13:28:06.000000000 +0100
+++ multipath-tools-mp-bleed-20061130-work/libmultipath/config.c	2006-12-04 14:04:51.000000000 +0100
@@ -333,6 +333,12 @@ free_config (struct config * conf)
 	free_blacklist(conf->blist_devnode);
 	free_blacklist(conf->blist_wwid);
 	free_blacklist_device(conf->blist_device);
+
+	if (conf->elist_devnode)
+		FREE(conf->elist_devnode);
+	if (conf->elist_wwid)
+		FREE(conf->elist_wwid);
+
 	free_mptable(conf->mptable);
 	free_hwtable(conf->hwtable);
 	free_keywords(conf->keywords);
@@ -403,6 +409,19 @@ load_config (char * file)
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
 	if (conf->mptable == NULL) {
 		conf->mptable = vector_alloc();
 
diff -Nurp --exclude='*~' multipath-tools-mp-bleed-20061130/libmultipath/config.h multipath-tools-mp-bleed-20061130-work/libmultipath/config.h
--- multipath-tools-mp-bleed-20061130/libmultipath/config.h	2006-11-30 13:28:06.000000000 +0100
+++ multipath-tools-mp-bleed-20061130-work/libmultipath/config.h	2006-12-04 14:32:29.000000000 +0100
@@ -1,6 +1,9 @@
 #ifndef _CONFIG_H
 #define _CONFIG_H
 
+#define ORIGIN_DEFAULT 0
+#define ORIGIN_CONFIG  1
+
 enum devtypes {
 	DEV_NONE,
 	DEV_DEVT,
@@ -75,6 +78,8 @@ struct config {
 	vector blist_devnode;
 	vector blist_wwid;
 	vector blist_device;
+	vector elist_devnode;
+	vector elist_wwid;
 };
 
 struct config * conf;
diff -Nurp --exclude='*~' multipath-tools-mp-bleed-20061130/libmultipath/dict.c multipath-tools-mp-bleed-20061130-work/libmultipath/dict.c
--- multipath-tools-mp-bleed-20061130/libmultipath/dict.c	2006-11-30 13:28:06.000000000 +0100
+++ multipath-tools-mp-bleed-20061130-work/libmultipath/dict.c	2006-12-07 10:33:50.000000000 +0100
@@ -238,6 +238,18 @@ blacklist_handler(vector strvec)
 }
 
 static int
+blacklist_exceptions_handler(vector strvec)
+{
+        conf->elist_devnode = vector_alloc();
+        conf->elist_wwid = vector_alloc();
+
+        if (!conf->elist_devnode || !conf->elist_wwid)
+                return 1;
+
+        return 0;
+}
+
+static int
 ble_devnode_handler(vector strvec)
 {
 	char * buff;
@@ -247,7 +259,20 @@ ble_devnode_handler(vector strvec)
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
@@ -260,7 +285,20 @@ ble_wwid_handler(vector strvec)
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
@@ -279,7 +317,7 @@ ble_vendor_handler(vector strvec)
 	if (!buff)
 		return 1;
 
-	return set_ble_device(conf->blist_device, buff, NULL);
+	return set_ble_device(conf->blist_device, buff, NULL, ORIGIN_CONFIG);
 }
 
 static int
@@ -292,7 +330,7 @@ ble_product_handler(vector strvec)
 	if (!buff)
 		return 1;
 
-	return set_ble_device(conf->blist_device, NULL, buff);
+	return set_ble_device(conf->blist_device, NULL, buff, ORIGIN_CONFIG);
 }
 
 /*
@@ -1336,6 +1374,9 @@ init_keywords(void)
 	install_keyword("vendor", &ble_vendor_handler, &snprint_bled_vendor);
 	install_keyword("product", &ble_product_handler, &snprint_bled_product);
 	install_sublevel_end();
+	install_keyword_root("blacklist_exceptions", &blacklist_exceptions_handler);
+	install_keyword("devnode", &ble_except_devnode_handler, &snprint_ble_simple);
+	install_keyword("wwid", &ble_except_wwid_handler, &snprint_ble_simple);
 
 #if 0
 	__deprecated install_keyword_root("devnode_blacklist", &blacklist_handler);
diff -Nurp --exclude='*~' multipath-tools-mp-bleed-20061130/libmultipath/discovery.c multipath-tools-mp-bleed-20061130-work/libmultipath/discovery.c
--- multipath-tools-mp-bleed-20061130/libmultipath/discovery.c	2006-11-30 13:28:06.000000000 +0100
+++ multipath-tools-mp-bleed-20061130-work/libmultipath/discovery.c	2006-12-04 14:05:31.000000000 +0100
@@ -61,7 +61,7 @@ path_discover (vector pathvec, struct co
 	if (!devname)
 		return 0;
 
-	if (blacklist(conf->blist_devnode, devname))
+	if (blacklist(conf->blist_devnode, conf->elist_devnode, devname))
 		return 0;
 
 	if(safe_sprintf(path, "%s/block/%s/device", sysfs_path,
diff -Nurp --exclude='*~' multipath-tools-mp-bleed-20061130/libmultipath/print.c multipath-tools-mp-bleed-20061130-work/libmultipath/print.c
--- multipath-tools-mp-bleed-20061130/libmultipath/print.c	2006-11-30 13:28:06.000000000 +0100
+++ multipath-tools-mp-bleed-20061130-work/libmultipath/print.c	2006-12-07 12:53:40.000000000 +0100
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
@@ -850,74 +853,147 @@ snprint_defaults (char * buff, int len)
 	
 }
 
-extern int
-snprint_blacklist (char * buff, int len)
+static int
+snprint_blacklist_group (char *buff, int len, int *fwd, vector *vec)
 {
-	int i;
+	int threshold = MAX_LINE_LEN;
 	struct blentry * ble;
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
 	struct blentry_device * bled;
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
+snprint_blacklist (char * buff, int len)
+{
+	int threshold = MAX_LINE_LEN;
 	int fwd = 0;
-	struct keyword *rootkw;
-	struct keyword *kw;
 
-	rootkw = find_keyword(NULL, "blacklist");
-	if (!rootkw)
-		return 0;
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
 
-	fwd += snprintf(buff + fwd, len - fwd, "blacklist {\n");
 	if (fwd > len)
 		return len;
+	return fwd;
+}
 
-	vector_foreach_slot (conf->blist_devnode, ble, i) {
-		kw = find_keyword(rootkw->sub, "devnode");
-		if (!kw)
-			return 0;
-		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
-				       kw, ble);
-		if (fwd > len)
-			return len;
-	}
-	vector_foreach_slot (conf->blist_wwid, ble, i) {
-		kw = find_keyword(rootkw->sub, "wwid");
-		if (!kw)
-			return 0;
-		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
-				       kw, ble);
-		if (fwd > len)
-			return len;
-	}
-	rootkw = find_keyword(rootkw->sub, "device");
-	if (!rootkw)
-		return 0;
+extern int
+snprint_devices (char * buff, int len, struct vectors *vecs)
+{
+        struct dlist * ls;
+        struct sysfs_class * class;
+        struct sysfs_class_device * dev;
+	int threshold = MAX_LINE_LEN;
+	int fwd = 0;
 
-	vector_foreach_slot (conf->blist_device, bled, i) {
-		fwd += snprintf(buff + fwd, len - fwd, "\tdevice {\n");
-		if (fwd > len)
-			return len;
-		kw = find_keyword(rootkw->sub, "vendor");
-		if (!kw)
-			return 0;
-		fwd += snprint_keyword(buff + fwd, len - fwd, "\t\t%k %v\n",
-				       kw, bled);
-		if (fwd > len)
-			return len;
-		kw = find_keyword(rootkw->sub, "product");
-		if (!kw)
-			return 0;
-		fwd += snprint_keyword(buff + fwd, len - fwd, "\t\t%k %v\n",
-				       kw, bled);
-		if (fwd > len)
-			return len;
-		fwd += snprintf(buff + fwd, len - fwd, "\t}\n");
-		if (fwd > len)
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
 			return len;
-	}
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
 
-	fwd += snprintf(buff + fwd, len - fwd, "}\n");
 	if (fwd > len)
 		return len;
 	return fwd;
-	
 }
 
 extern int
diff -Nurp --exclude='*~' multipath-tools-mp-bleed-20061130/libmultipath/print.h multipath-tools-mp-bleed-20061130-work/libmultipath/print.h
--- multipath-tools-mp-bleed-20061130/libmultipath/print.h	2006-11-30 13:28:06.000000000 +0100
+++ multipath-tools-mp-bleed-20061130-work/libmultipath/print.h	2006-12-07 12:33:21.000000000 +0100
@@ -42,6 +42,7 @@ int snprint_multipath_topology (char *, 
 				int verbosity);
 int snprint_defaults (char *, int);
 int snprint_blacklist (char *, int);
+int snprint_devices (char *, int, struct vectors *);
 int snprint_hwtable (char *, int, vector);
 int snprint_mptable (char *, int, vector);
 
diff -Nurp --exclude='*~' multipath-tools-mp-bleed-20061130/multipath/main.c multipath-tools-mp-bleed-20061130-work/multipath/main.c
--- multipath-tools-mp-bleed-20061130/multipath/main.c	2006-11-30 13:28:06.000000000 +0100
+++ multipath-tools-mp-bleed-20061130-work/multipath/main.c	2006-12-04 14:06:01.000000000 +0100
@@ -233,7 +233,7 @@ configure (void)
 			dev = conf->dev;
 	}
 	
-	if (dev && blacklist(conf->blist_devnode, dev))
+	if (dev && blacklist(conf->blist_devnode, conf->elist_devnode, dev))
 		goto out;
 	
 	/*
@@ -249,7 +249,7 @@ configure (void)
 		}
 		condlog(3, "scope limited to %s", refwwid);
 
-		if (blacklist(conf->blist_wwid, refwwid))
+		if (blacklist(conf->blist_wwid, conf->elist_wwid, refwwid))
 			goto out;
 	}
 
diff -Nurp --exclude='*~' multipath-tools-mp-bleed-20061130/multipath.conf.annotated multipath-tools-mp-bleed-20061130-work/multipath.conf.annotated
--- multipath-tools-mp-bleed-20061130/multipath.conf.annotated	2006-11-30 13:28:06.000000000 +0100
+++ multipath-tools-mp-bleed-20061130-work/multipath.conf.annotated	2006-12-07 13:09:32.000000000 +0100
@@ -142,6 +142,22 @@
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
+#}
 #
 ##
 ## name    : multipaths
diff -Nurp --exclude='*~' multipath-tools-mp-bleed-20061130/multipath.conf.synthetic multipath-tools-mp-bleed-20061130-work/multipath.conf.synthetic
--- multipath-tools-mp-bleed-20061130/multipath.conf.synthetic	2006-11-30 13:28:06.000000000 +0100
+++ multipath-tools-mp-bleed-20061130-work/multipath.conf.synthetic	2006-12-07 13:05:14.000000000 +0100
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
diff -Nurp --exclude='*~' multipath-tools-mp-bleed-20061130/multipathd/cli.c multipath-tools-mp-bleed-20061130-work/multipathd/cli.c
--- multipath-tools-mp-bleed-20061130/multipathd/cli.c	2006-11-30 13:28:06.000000000 +0100
+++ multipath-tools-mp-bleed-20061130-work/multipathd/cli.c	2006-12-06 14:16:34.000000000 +0100
@@ -141,6 +141,8 @@ load_keys (void)
 	r += add_key(keys, "stats", STATS, 0);
 	r += add_key(keys, "topology", TOPOLOGY, 0);
 	r += add_key(keys, "config", CONFIG, 0);
+	r += add_key(keys, "blacklist", BLACKLIST, 0);
+	r += add_key(keys, "devices", DEVICES, 0);
 
 	if (r) {
 		free_keys(keys);
diff -Nurp --exclude='*~' multipath-tools-mp-bleed-20061130/multipathd/cli.h multipath-tools-mp-bleed-20061130-work/multipathd/cli.h
--- multipath-tools-mp-bleed-20061130/multipathd/cli.h	2006-11-30 13:28:06.000000000 +0100
+++ multipath-tools-mp-bleed-20061130-work/multipathd/cli.h	2006-12-06 14:20:38.000000000 +0100
@@ -17,6 +17,8 @@ enum {
 	__STATS,
 	__TOPOLOGY,
 	__CONFIG,
+	__BLACKLIST,
+	__DEVICES,
 };
 
 #define LIST		(1 << __LIST)
@@ -37,6 +39,8 @@ enum {
 #define STATS		(1 << __STATS)
 #define TOPOLOGY	(1 << __TOPOLOGY)
 #define CONFIG		(1 << __CONFIG)
+#define BLACKLIST	(1 << __BLACKLIST)
+#define DEVICES  	(1 << __DEVICES)
 
 #define INITIAL_REPLY_LEN 1000
 
diff -Nurp --exclude='*~' multipath-tools-mp-bleed-20061130/multipathd/cli_handlers.c multipath-tools-mp-bleed-20061130-work/multipathd/cli_handlers.c
--- multipath-tools-mp-bleed-20061130/multipathd/cli_handlers.c	2006-11-30 13:28:06.000000000 +0100
+++ multipath-tools-mp-bleed-20061130-work/multipathd/cli_handlers.c	2006-12-07 12:31:26.000000000 +0100
@@ -280,7 +280,7 @@ cli_add_path (void * v, char ** reply, i
 
 	condlog(2, "%s: add path (operator)", param);
 
-	if (blacklist(conf->blist_devnode, param) ||
+	if (blacklist(conf->blist_devnode, conf->elist_devnode, param) ||
 	    (r = ev_add_path(param, vecs)) == 2) {
 		*reply = strdup("blacklisted");
 		*len = strlen(*reply) + 1;
@@ -309,7 +309,7 @@ cli_add_map (void * v, char ** reply, in
 
 	condlog(2, "%s: add map (operator)", param);
 
-	if (blacklist(conf->blist_wwid, param)) {
+	if (blacklist(conf->blist_wwid, conf->elist_wwid, param)) {
 		*reply = strdup("blacklisted");
 		*len = strlen(*reply) + 1;
 		condlog(2, "%s: map blacklisted", param);
@@ -433,3 +433,79 @@ cli_fail(void * v, char ** reply, int * 
 
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
+                c += snprint_blacklist(c, maxlen);
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
diff -Nurp --exclude='*~' multipath-tools-mp-bleed-20061130/multipathd/cli_handlers.h multipath-tools-mp-bleed-20061130-work/multipathd/cli_handlers.h
--- multipath-tools-mp-bleed-20061130/multipathd/cli_handlers.h	2006-11-30 13:28:06.000000000 +0100
+++ multipath-tools-mp-bleed-20061130-work/multipathd/cli_handlers.h	2006-12-06 14:21:41.000000000 +0100
@@ -5,6 +5,8 @@ int cli_list_maps_stats (void * v, char 
 int cli_list_map_topology (void * v, char ** reply, int * len, void * data);
 int cli_list_maps_topology (void * v, char ** reply, int * len, void * data);
 int cli_list_config (void * v, char ** reply, int * len, void * data);
+int cli_list_blacklist (void * v, char ** reply, int * len, void * data);
+int cli_list_devices (void * v, char ** reply, int * len, void * data);
 int cli_add_path (void * v, char ** reply, int * len, void * data);
 int cli_del_path (void * v, char ** reply, int * len, void * data);
 int cli_add_map (void * v, char ** reply, int * len, void * data);
diff -Nurp --exclude='*~' multipath-tools-mp-bleed-20061130/multipathd/main.c multipath-tools-mp-bleed-20061130-work/multipathd/main.c
--- multipath-tools-mp-bleed-20061130/multipathd/main.c	2006-11-30 13:28:06.000000000 +0100
+++ multipath-tools-mp-bleed-20061130-work/multipathd/main.c	2006-12-07 12:25:52.000000000 +0100
@@ -667,7 +667,7 @@ uev_trigger (struct uevent * uev, void *
 	/*
 	 * path add/remove event
 	 */
-	if (blacklist(conf->blist_devnode, devname))
+	if (blacklist(conf->blist_devnode, conf->elist_devnode, devname))
 		goto out;
 
 	if (!strncmp(uev->action, "add", 3)) {
@@ -710,6 +710,8 @@ uxlsnrloop (void * ap)
 	add_handler(LIST+TOPOLOGY, cli_list_maps_topology);
 	add_handler(LIST+MAP+TOPOLOGY, cli_list_map_topology);
 	add_handler(LIST+CONFIG, cli_list_config);
+	add_handler(LIST+BLACKLIST, cli_list_blacklist);
+	add_handler(LIST+DEVICES, cli_list_devices);
 	add_handler(ADD+PATH, cli_add_path);
 	add_handler(DEL+PATH, cli_del_path);
 	add_handler(ADD+MAP, cli_add_map);
diff -Nurp --exclude='*~' multipath-tools-mp-bleed-20061130/multipathd/multipathd.8 multipath-tools-mp-bleed-20061130-work/multipathd/multipathd.8
--- multipath-tools-mp-bleed-20061130/multipathd/multipathd.8	2006-11-30 13:28:06.000000000 +0100
+++ multipath-tools-mp-bleed-20061130-work/multipathd/multipathd.8	2006-12-07 12:54:20.000000000 +0100
@@ -57,6 +57,12 @@ This map could be obtained from "list ma
 .B list|show config
 Show the currently used configuration, derived from default values and values specified within the configuration file /etc/multipath.conf.
 .TP
+.B list|show blacklist
+Show the currently used blacklist rules, derived from default values and values specified within the configuration file /etc/multipath.conf.
+.TP
+.B list|show devices
+Show all available block devices by name including the information if they are blacklisted or not.
+.TP
 .B add path $path
 Add a path to the list of monitored paths. $path is as listed in /sys/block (e.g. sda).
 .TP 
