From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] add the ability to have blacklist exceptions for
	specific vendor:product
Date: Tue, 9 Jan 2007 18:17:25 -0600
Message-ID: <20070110001725.GB13146@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ZPt4rx8FFjLCG7dd"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr, dm-devel@redhat.com
List-Id: dm-devel.ids


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This patch adds the ability to have blacklist exceptions for vendor:product
devices.  Also, the wwid and devnode exceptions weren't getting freed properly
in free_config, so that is fixed as well.

-Ben

Benjamin E. Marzinski
bmarzins@redhat.com

--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="blacklist_exception_device.patch"

diff -urpN mp-devel-clean/libmultipath/blacklist.c mp-devel-patched/libmultipath/blacklist.c
--- mp-devel-clean/libmultipath/blacklist.c	2007-01-09 10:12:30.000000000 -0600
+++ mp-devel-patched/libmultipath/blacklist.c	2007-01-09 13:59:20.000000000 -0600
@@ -174,11 +174,30 @@ blacklist (vector blist, vector elist, c
 }
 
 int
-blacklist_device (vector blist, char * vendor, char * product)
+blacklist_exceptions_device(vector elist, char * vendor, char * product)
 {
 	int i;
 	struct blentry_device * ble;
 
+	vector_foreach_slot (elist, ble, i) {
+		if (!regexec(&ble->vendor_reg, vendor, 0, NULL, 0) &&
+		    !regexec(&ble->product_reg, product, 0, NULL, 0)) {
+			condlog(3, "%s:%s: exception-listed", vendor, product);
+			return 1;
+		}
+	}
+	return 0;
+}
+
+int
+blacklist_device (vector blist, vector elist, char * vendor, char * product)
+{
+	int i;
+	struct blentry_device * ble;
+
+	if (blacklist_exceptions_device(elist, vendor, product))
+		return 0;
+
 	vector_foreach_slot (blist, ble, i) {
 		if (!regexec(&ble->vendor_reg, vendor, 0, NULL, 0) &&
 		    !regexec(&ble->product_reg, product, 0, NULL, 0)) {
@@ -199,7 +218,7 @@ blacklist_path (struct config * conf, st
 		return 1;
 
 	if (pp->vendor_id && pp->product_id &&
-	    blacklist_device(conf->blist_device, pp->vendor_id, pp->product_id))
+	    blacklist_device(conf->blist_device, conf->elist_device, pp->vendor_id, pp->product_id))
 		return 1;
 
 	return 0;
diff -urpN mp-devel-clean/libmultipath/blacklist.h mp-devel-patched/libmultipath/blacklist.h
--- mp-devel-clean/libmultipath/blacklist.h	2007-01-09 10:12:30.000000000 -0600
+++ mp-devel-patched/libmultipath/blacklist.h	2007-01-09 13:59:20.000000000 -0600
@@ -20,7 +20,7 @@ struct blentry_device {
 int setup_default_blist (struct config *);
 int alloc_ble_device (vector);
 int blacklist (vector, vector, char *);
-int blacklist_device (vector, char *, char *);
+int blacklist_device (vector, vector, char *, char *);
 int blacklist_path (struct config *, struct path *);
 int store_ble (vector, char *, int);
 int set_ble_device (vector, char *, char *, int);
diff -urpN mp-devel-clean/libmultipath/config.c mp-devel-patched/libmultipath/config.c
--- mp-devel-clean/libmultipath/config.c	2007-01-09 10:12:30.000000000 -0600
+++ mp-devel-patched/libmultipath/config.c	2007-01-09 13:59:20.000000000 -0600
@@ -334,10 +334,9 @@ free_config (struct config * conf)
 	free_blacklist(conf->blist_wwid);
 	free_blacklist_device(conf->blist_device);
 
-	if (conf->elist_devnode)
-		FREE(conf->elist_devnode);
-	if (conf->elist_wwid)
-		FREE(conf->elist_wwid);
+	free_blacklist(conf->elist_devnode);
+	free_blacklist(conf->elist_wwid);
+	free_blacklist_device(conf->elist_device);
 
 	free_mptable(conf->mptable);
 	free_hwtable(conf->hwtable);
@@ -422,6 +421,13 @@ load_config (char * file)
 			goto out;
 	}
 
+	if (conf->elist_device == NULL) {
+		conf->elist_device = vector_alloc();
+		
+		if (!conf->elist_device)
+			goto out;
+	}
+
 	if (conf->mptable == NULL) {
 		conf->mptable = vector_alloc();
 
diff -urpN mp-devel-clean/libmultipath/config.h mp-devel-patched/libmultipath/config.h
--- mp-devel-clean/libmultipath/config.h	2007-01-09 10:12:30.000000000 -0600
+++ mp-devel-patched/libmultipath/config.h	2007-01-09 13:59:20.000000000 -0600
@@ -80,6 +80,7 @@ struct config {
 	vector blist_device;
 	vector elist_devnode;
 	vector elist_wwid;
+	vector elist_device;
 };
 
 struct config * conf;
diff -urpN mp-devel-clean/libmultipath/dict.c mp-devel-patched/libmultipath/dict.c
--- mp-devel-clean/libmultipath/dict.c	2007-01-09 10:12:30.000000000 -0600
+++ mp-devel-patched/libmultipath/dict.c	2007-01-09 13:59:20.000000000 -0600
@@ -242,8 +242,9 @@ blacklist_exceptions_handler(vector strv
 {
         conf->elist_devnode = vector_alloc();
         conf->elist_wwid = vector_alloc();
+	conf->elist_device = vector_alloc();
 
-        if (!conf->elist_devnode || !conf->elist_wwid)
+        if (!conf->elist_devnode || !conf->elist_wwid || !conf->blist_device)
                 return 1;
 
         return 0;
@@ -308,6 +309,12 @@ ble_device_handler(vector strvec)
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
@@ -321,6 +328,20 @@ ble_vendor_handler(vector strvec)
 }
 
 static int
+ble_except_vendor_handler(vector strvec)
+{
+	char * buff;
+	int r;
+
+	buff = set_value(strvec);
+
+	if (!buff)
+		return 1;
+
+	return set_ble_device(conf->elist_device, buff, NULL, ORIGIN_CONFIG);
+}
+
+static int
 ble_product_handler(vector strvec)
 {
 	char * buff;
@@ -333,6 +354,19 @@ ble_product_handler(vector strvec)
 	return set_ble_device(conf->blist_device, NULL, buff, ORIGIN_CONFIG);
 }
 
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
+}
+
 /*
  * devices block handlers
  */
@@ -1377,6 +1411,11 @@ init_keywords(void)
 	install_keyword_root("blacklist_exceptions", &blacklist_exceptions_handler);
 	install_keyword("devnode", &ble_except_devnode_handler, &snprint_ble_simple);
 	install_keyword("wwid", &ble_except_wwid_handler, &snprint_ble_simple);
+	install_keyword("device", &ble_except_device_handler, NULL);
+	install_sublevel();
+	install_keyword("vendor", &ble_except_vendor_handler, &snprint_bled_vendor);
+	install_keyword("product", &ble_except_product_handler, &snprint_bled_product);
+	install_sublevel_end();
 
 #if 0
 	__deprecated install_keyword_root("devnode_blacklist", &blacklist_handler);
diff -urpN mp-devel-clean/libmultipath/print.c mp-devel-patched/libmultipath/print.c
--- mp-devel-clean/libmultipath/print.c	2007-01-09 10:12:31.000000000 -0600
+++ mp-devel-patched/libmultipath/print.c	2007-01-09 13:59:20.000000000 -0600
@@ -946,6 +946,12 @@ snprint_blacklist_report (char * buff, i
 	if (snprint_blacklist_devgroup(buff, len, &fwd, &conf->blist_device) == 0)
 		return len;
 
+	if ((len - fwd - threshold) <= 0)
+		return len;
+	fwd += snprintf(buff + fwd, len - fwd, "- exceptions:\n");
+	if (snprint_blacklist_devgroup(buff, len, &fwd, &conf->elist_device) == 0)
+		return len;
+
 	if (fwd > len)
 		return len;
 	return fwd;
@@ -1024,6 +1030,7 @@ snprint_blacklist_except (char * buff, i
 {
 	int i;
 	struct blentry * ele;
+	struct blentry_device * eled;
 	int fwd = 0;
 	struct keyword *rootkw;
 	struct keyword *kw;
@@ -1054,6 +1061,32 @@ snprint_blacklist_except (char * buff, i
 		if (fwd > len)
 			return len;
 	}
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

--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--ZPt4rx8FFjLCG7dd--
