From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 22/29] multipath: Implement 'property' blacklist
Date: Mon, 15 Jul 2013 15:00:23 +0200
Message-ID: <1373893230-26077-23-git-send-email-hare@suse.de>
References: <1373893230-26077-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373893230-26077-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Multipath can only handle device properly which support the VPD
page 0x83. Originally this was ensured by 'scsi_id', which would
not present an ID_SERIAL value in these cases.
With the move to udev 'ID_SERIAL' is now always present, so
multipath would try to attach to _all_ SCSI devices.
This patch implements an 'property' blacklist, which allows to
blacklist a device based on the existence of udev properties.
Any device not providing the udev property from the whitelist
will be ignored.
The default whitelist is set to '(ID_WWN|ID_SCSI_VPD)'.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/blacklist.c   |  105 +++++++++++++++++++++++++++++++++++---------
 libmultipath/blacklist.h   |   19 +++++---
 libmultipath/config.c      |   19 +++++++-
 libmultipath/config.h      |    2 +
 libmultipath/dict.c        |   36 ++++++++++++++-
 libmultipath/discovery.c   |    3 ++
 libmultipath/print.c       |   31 +++++++++++++
 multipath.conf.defaults    |    1 +
 multipath/multipath.conf.5 |   19 +++++++-
 9 files changed, 203 insertions(+), 32 deletions(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index 49a40f9..d597350 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004, 2005 Christophe Varoqui
  */
 #include <stdio.h>
+#include <libudev.h>
 
 #include "checkers.h"
 #include "memory.h"
@@ -96,7 +97,7 @@ set_ble_device (vector blist, char * vendor, char * product, int origin)
 }
 
 int
-_blacklist_exceptions (vector elist, char * str)
+_blacklist_exceptions (vector elist, const char * str)
 {
 	int i;
 	struct blentry * ele;
@@ -109,7 +110,7 @@ _blacklist_exceptions (vector elist, char * str)
 }
 
 int
-_blacklist (vector blist, char * str)
+_blacklist (vector blist, const char * str)
 {
 	int i;
 	struct blentry * ble;
@@ -175,6 +176,12 @@ setup_default_blist (struct config * conf)
 	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
 		return 1;
 
+	str = STRDUP("(ID_SCSI_VPD|ID_WWN)");
+	if (!str)
+		return 1;
+	if (store_ble(conf->elist_property, str, ORIGIN_DEFAULT))
+		return 1;
+
 	vector_foreach_slot (conf->hwtable, hwe, i) {
 		if (hwe->bl_product) {
 			if (_blacklist_device(conf->blist_device, hwe->vendor,
@@ -196,16 +203,20 @@ setup_default_blist (struct config * conf)
 	return 0;
 }
 
-#define LOG_BLIST(M) \
-	if (vendor && product)						 \
-		condlog(3, "%s: (%s:%s) %s", dev, vendor, product, (M)); \
-	else if (wwid)							 \
-		condlog(3, "%s: (%s) %s", dev, wwid, (M));		 \
-	else								 \
-		condlog(3, "%s: %s", dev, (M))
+#define LOG_BLIST(M,S)							\
+	if (vendor && product)						\
+		condlog(3, "%s: (%s:%s) %s %s",				\
+			dev, vendor, product, (M), (S));		\
+	else if (wwid)							\
+		condlog(3, "%s: %s %s %s", dev, (M), wwid, (S));	\
+	else if (env)							\
+		condlog(3, "%s: %s %s %s", dev, (M), env, (S));		\
+	else								\
+		condlog(3, "%s: %s %s", dev, (M), (S))
 
 void
-log_filter (char *dev, char *vendor, char *product, char *wwid, int r)
+log_filter (const char *dev, char *vendor, char *product, char *wwid,
+	    const char *env, int r)
 {
 	/*
 	 * Try to sort from most likely to least.
@@ -214,22 +225,31 @@ log_filter (char *dev, char *vendor, char *product, char *wwid, int r)
 	case MATCH_NOTHING:
 		break;
 	case MATCH_DEVICE_BLIST:
-		LOG_BLIST("vendor/product blacklisted");
+		LOG_BLIST("vendor/product", "blacklisted");
 		break;
 	case MATCH_WWID_BLIST:
-		LOG_BLIST("wwid blacklisted");
+		LOG_BLIST("wwid", "blacklisted");
 		break;
 	case MATCH_DEVNODE_BLIST:
-		LOG_BLIST("device node name blacklisted");
+		LOG_BLIST("device node name", "blacklisted");
+		break;
+	case MATCH_PROPERTY_BLIST:
+		LOG_BLIST("udev property", "blacklisted");
 		break;
 	case MATCH_DEVICE_BLIST_EXCEPT:
-		LOG_BLIST("vendor/product whitelisted");
+		LOG_BLIST("vendor/product", "whitelisted");
 		break;
 	case MATCH_WWID_BLIST_EXCEPT:
-		LOG_BLIST("wwid whitelisted");
+		LOG_BLIST("wwid", "whitelisted");
 		break;
 	case MATCH_DEVNODE_BLIST_EXCEPT:
-		LOG_BLIST("device node name whitelisted");
+		LOG_BLIST("device node name", "whitelisted");
+		break;
+	case MATCH_PROPERTY_BLIST_EXCEPT:
+		LOG_BLIST("udev property", "whitelisted");
+		break;
+	case MATCH_PROPERTY_BLIST_MISSING:
+		LOG_BLIST("blacklisted,", "udev property missing");
 		break;
 	}
 }
@@ -250,7 +270,7 @@ int
 filter_device (vector blist, vector elist, char * vendor, char * product)
 {
 	int r = _filter_device(blist, elist, vendor, product);
-	log_filter(NULL, vendor, product, NULL, r);
+	log_filter(NULL, vendor, product, NULL, NULL, r);
 	return r;
 }
 
@@ -270,7 +290,7 @@ int
 filter_devnode (vector blist, vector elist, char * dev)
 {
 	int r = _filter_devnode(blist, elist, dev);
-	log_filter(dev, NULL, NULL, NULL, r);
+	log_filter(dev, NULL, NULL, NULL, NULL, r);
 	return r;
 }
 
@@ -290,7 +310,7 @@ int
 filter_wwid (vector blist, vector elist, char * wwid)
 {
 	int r = _filter_wwid(blist, elist, wwid);
-	log_filter(NULL, NULL, NULL, wwid, r);
+	log_filter(NULL, NULL, NULL, wwid, NULL, r);
 	return r;
 }
 
@@ -314,10 +334,55 @@ int
 filter_path (struct config * conf, struct path * pp)
 {
 	int r=_filter_path(conf, pp);
-	log_filter(pp->dev, pp->vendor_id, pp->product_id, pp->wwid, r);
+	log_filter(pp->dev, pp->vendor_id, pp->product_id, pp->wwid, NULL, r);
 	return r;
 }
 
+int
+_filter_property (struct config *conf, const char *env)
+{
+	if (_blacklist_exceptions(conf->elist_property, env))
+		return MATCH_PROPERTY_BLIST_EXCEPT;
+	if (_blacklist(conf->blist_property, env))
+		return MATCH_PROPERTY_BLIST;
+
+	return 0;
+}
+
+int
+filter_property(struct config * conf, struct udev_device * udev)
+{
+	const char *devname = udev_device_get_sysname(udev);
+	struct udev_list_entry *list_entry;
+	int r;
+
+	if (!udev)
+		return 0;
+
+	udev_list_entry_foreach(list_entry,
+				udev_device_get_properties_list_entry(udev)) {
+		const char *env;
+
+		env = udev_list_entry_get_name(list_entry);
+		if (!env)
+			continue;
+
+		r = _filter_property(conf, env);
+		if (r) {
+			log_filter(devname, NULL, NULL, NULL, env, r);
+			return r;
+		}
+	}
+
+	/*
+	 * This is the inverse of the 'normal' matching;
+	 * the environment variable _has_ to match.
+	 */
+	log_filter(devname, NULL, NULL, NULL, NULL,
+		   MATCH_PROPERTY_BLIST_MISSING);
+	return MATCH_PROPERTY_BLIST_MISSING;
+}
+
 void
 free_blacklist (vector blist)
 {
diff --git a/libmultipath/blacklist.h b/libmultipath/blacklist.h
index cdbebef..0e90e9a 100644
--- a/libmultipath/blacklist.h
+++ b/libmultipath/blacklist.h
@@ -1,15 +1,19 @@
 #ifndef _BLACKLIST_H
 #define _BLACKLIST_H
 
+#include <libudev.h>
 #include "regex.h"
 
-#define MATCH_NOTHING       0
-#define MATCH_WWID_BLIST    1
-#define MATCH_DEVICE_BLIST  2
-#define MATCH_DEVNODE_BLIST 3
-#define MATCH_WWID_BLIST_EXCEPT    -MATCH_WWID_BLIST
-#define MATCH_DEVICE_BLIST_EXCEPT  -MATCH_DEVICE_BLIST
-#define MATCH_DEVNODE_BLIST_EXCEPT -MATCH_DEVNODE_BLIST
+#define MATCH_NOTHING        0
+#define MATCH_WWID_BLIST     1
+#define MATCH_DEVICE_BLIST   2
+#define MATCH_DEVNODE_BLIST  3
+#define MATCH_PROPERTY_BLIST 4
+#define MATCH_PROPERTY_BLIST_MISSING 5
+#define MATCH_WWID_BLIST_EXCEPT     -MATCH_WWID_BLIST
+#define MATCH_DEVICE_BLIST_EXCEPT   -MATCH_DEVICE_BLIST
+#define MATCH_DEVNODE_BLIST_EXCEPT  -MATCH_DEVNODE_BLIST
+#define MATCH_PROPERTY_BLIST_EXCEPT -MATCH_PROPERTY_BLIST
 
 struct blentry {
 	char * str;
@@ -31,6 +35,7 @@ int filter_devnode (vector, vector, char *);
 int filter_wwid (vector, vector, char *);
 int filter_device (vector, vector, char *, char *);
 int filter_path (struct config *, struct path *);
+int filter_property(struct config *, struct udev_device *);
 int store_ble (vector, char *, int);
 int set_ble_device (vector, char *, char *, int);
 void free_blacklist (vector);
diff --git a/libmultipath/config.c b/libmultipath/config.c
index 8013a07..9b7adda 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -513,10 +513,12 @@ free_config (struct config * conf)
 
 	free_blacklist(conf->blist_devnode);
 	free_blacklist(conf->blist_wwid);
+	free_blacklist(conf->blist_property);
 	free_blacklist_device(conf->blist_device);
 
 	free_blacklist(conf->elist_devnode);
 	free_blacklist(conf->elist_wwid);
+	free_blacklist(conf->elist_property);
 	free_blacklist_device(conf->elist_device);
 
 	free_mptable(conf->mptable);
@@ -619,8 +621,12 @@ load_config (char * file, struct udev *udev)
 		if (!conf->blist_device)
 			goto out;
 	}
-	if (setup_default_blist(conf))
-		goto out;
+	if (conf->blist_property == NULL) {
+		conf->blist_property = vector_alloc();
+
+		if (!conf->blist_property)
+			goto out;
+	}
 
 	if (conf->elist_devnode == NULL) {
 		conf->elist_devnode = vector_alloc();
@@ -642,6 +648,15 @@ load_config (char * file, struct udev *udev)
 			goto out;
 	}
 
+	if (conf->elist_property == NULL) {
+		conf->elist_property = vector_alloc();
+
+		if (!conf->elist_property)
+			goto out;
+	}
+	if (setup_default_blist(conf))
+		goto out;
+
 	if (conf->mptable == NULL) {
 		conf->mptable = vector_alloc();
 		if (!conf->mptable)
diff --git a/libmultipath/config.h b/libmultipath/config.h
index ca65f88..9c467e8 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -136,9 +136,11 @@ struct config {
 	vector blist_devnode;
 	vector blist_wwid;
 	vector blist_device;
+	vector blist_property;
 	vector elist_devnode;
 	vector elist_wwid;
 	vector elist_device;
+	vector elist_property;
 };
 
 struct config * conf;
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 0408e03..0bf9587 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -691,8 +691,10 @@ blacklist_handler(vector strvec)
 	conf->blist_devnode = vector_alloc();
 	conf->blist_wwid = vector_alloc();
 	conf->blist_device = vector_alloc();
+	conf->blist_property = vector_alloc();
 
-	if (!conf->blist_devnode || !conf->blist_wwid || !conf->blist_device)
+	if (!conf->blist_devnode || !conf->blist_wwid ||
+	    !conf->blist_device || !conf->blist_property)
 		return 1;
 
 	return 0;
@@ -704,8 +706,10 @@ blacklist_exceptions_handler(vector strvec)
 	conf->elist_devnode = vector_alloc();
 	conf->elist_wwid = vector_alloc();
 	conf->elist_device = vector_alloc();
+	conf->elist_property = vector_alloc();
 
-	if (!conf->elist_devnode || !conf->elist_wwid || !conf->elist_device)
+	if (!conf->elist_devnode || !conf->elist_wwid ||
+	    !conf->elist_device || !conf->elist_property)
 		return 1;
 
 	return 0;
@@ -764,6 +768,32 @@ ble_except_wwid_handler(vector strvec)
 }
 
 static int
+ble_property_handler(vector strvec)
+{
+	char * buff;
+
+	buff = set_value(strvec);
+
+	if (!buff)
+		return 1;
+
+	return store_ble(conf->blist_property, buff, ORIGIN_CONFIG);
+}
+
+static int
+ble_except_property_handler(vector strvec)
+{
+	char * buff;
+
+	buff = set_value(strvec);
+
+	if (!buff)
+		return 1;
+
+	return store_ble(conf->elist_property, buff, ORIGIN_CONFIG);
+}
+
+static int
 ble_device_handler(vector strvec)
 {
 	return alloc_ble_device(conf->blist_device);
@@ -2830,6 +2860,7 @@ init_keywords(void)
 	install_keyword_root("blacklist", &blacklist_handler);
 	install_keyword_multi("devnode", &ble_devnode_handler, &snprint_ble_simple);
 	install_keyword_multi("wwid", &ble_wwid_handler, &snprint_ble_simple);
+	install_keyword_multi("property", &ble_property_handler, &snprint_ble_simple);
 	install_keyword_multi("device", &ble_device_handler, NULL);
 	install_sublevel();
 	install_keyword("vendor", &ble_vendor_handler, &snprint_bled_vendor);
@@ -2838,6 +2869,7 @@ init_keywords(void)
 	install_keyword_root("blacklist_exceptions", &blacklist_exceptions_handler);
 	install_keyword_multi("devnode", &ble_except_devnode_handler, &snprint_ble_simple);
 	install_keyword_multi("wwid", &ble_except_wwid_handler, &snprint_ble_simple);
+	install_keyword_multi("property", &ble_except_property_handler, &snprint_ble_simple);
 	install_keyword_multi("device", &ble_except_device_handler, NULL);
 	install_sublevel();
 	install_keyword("vendor", &ble_except_vendor_handler, &snprint_bled_vendor);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 82f086b..e9c6a50 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -82,6 +82,9 @@ path_discover (vector pathvec, struct config * conf,
 	if (!devname)
 		return 0;
 
+	if (filter_property(conf, udevice) > 0)
+		return 0;
+
 	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
 			   (char *)devname) > 0)
 		return 0;
diff --git a/libmultipath/print.c b/libmultipath/print.c
index b6d08b7..7feeb26 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -1078,6 +1078,19 @@ snprint_blacklist_report (char * buff, int len)
 
 	if ((len - fwd - threshold) <= 0)
 		return len;
+	fwd += snprintf(buff + fwd, len - fwd, "udev property rules:\n"
+					       "- blacklist:\n");
+	if (!snprint_blacklist_group(buff, len, &fwd, &conf->blist_property))
+		return len;
+
+	if ((len - fwd - threshold) <= 0)
+		return len;
+	fwd += snprintf(buff + fwd, len - fwd, "- exceptions:\n");
+	if (snprint_blacklist_group(buff, len, &fwd, &conf->elist_property) == 0)
+		return len;
+
+	if ((len - fwd - threshold) <= 0)
+		return len;
 	fwd += snprintf(buff + fwd, len - fwd, "wwid rules:\n"
 					       "- blacklist:\n");
 	if (snprint_blacklist_group(buff, len, &fwd, &conf->blist_wwid) == 0)
@@ -1143,6 +1156,15 @@ snprint_blacklist (char * buff, int len)
 		if (fwd > len)
 			return len;
 	}
+	vector_foreach_slot (conf->blist_property, ble, i) {
+		kw = find_keyword(rootkw->sub, "property");
+		if (!kw)
+			return 0;
+		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
+				       kw, ble);
+		if (fwd > len)
+			return len;
+	}
 	rootkw = find_keyword(rootkw->sub, "device");
 	if (!rootkw)
 		return 0;
@@ -1211,6 +1233,15 @@ snprint_blacklist_except (char * buff, int len)
 		if (fwd > len)
 			return len;
 	}
+	vector_foreach_slot (conf->elist_property, ele, i) {
+		kw = find_keyword(rootkw->sub, "property");
+		if (!kw)
+			return 0;
+		fwd += snprint_keyword(buff + fwd, len - fwd, "\t%k %v\n",
+				       kw, ele);
+		if (fwd > len)
+			return len;
+	}
 	rootkw = find_keyword(rootkw->sub, "device");
 	if (!rootkw)
 		return 0;
diff --git a/multipath.conf.defaults b/multipath.conf.defaults
index f278f1f..636c1e6 100644
--- a/multipath.conf.defaults
+++ b/multipath.conf.defaults
@@ -70,6 +70,7 @@
 #	}
 #}
 #blacklist_exceptions {
+#	property "(ID_SCSI_VPD|ID_WWN)"
 #}
 #devices {
 #	device {
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index a937db9..0fd3035 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -422,6 +422,9 @@ The \fIWorld Wide Identification\fR of a device.
 .B devnode
 Regular expression of the device nodes to be excluded.
 .TP
+.B property
+Regular expresion of the udev property to be excluded.
+.TP
 .B device
 Subsection for the device description. This subsection recognizes the
 .I vendor
@@ -446,8 +449,12 @@ The following keywords are recognized:
 .B wwid
 The \fIWorld Wide Identification\fR of a device.
 .TP
+.B property
+Regular expresion of the udev property to be whitelisted. Defaults to
+.I (ID_WWN|ID_SCSI_VPD)
+.TP
 .B devnode
-Regular expression of the device nodes to be excluded.
+Regular expression of the device nodes to be whitelisted.
 .TP
 .B device
 Subsection for the device description. This subsection recognizes the
@@ -457,6 +464,16 @@ and
 keywords. For a full description of these keywords please see the
 .I devices
 section description.
+.LP
+The
+.I property
+blacklist and whitelist handling is different from the usual handling
+in the sense that the whitelist
+.B has
+to be set, otherwise the device will be blacklisted.
+In these cases the message
+.I blacklisted, udev property missing
+will be displayed.
 .SH "multipaths section"
 The only recognized attribute for the
 .B multipaths
-- 
1.7.10.4
