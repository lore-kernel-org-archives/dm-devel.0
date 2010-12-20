From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: add allow users to set revision
	in	multipath.conf
Date: Mon, 20 Dec 2010 00:02:09 -0600
Message-ID: <20101220060209.GN25172@ether.msp.redhat.com>
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

Since multipath is able to select hardware entries based on the revision
parameter, users should be allowed to set it in their devices configurations.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dict.c        |   28 ++++++++++++++++++++++++++++
 multipath/multipath.conf.5 |    5 ++++-
 2 files changed, 32 insertions(+), 1 deletion(-)

Index: multipath-tools-101104/libmultipath/dict.c
===================================================================
--- multipath-tools-101104.orig/libmultipath/dict.c
+++ multipath-tools-101104/libmultipath/dict.c
@@ -730,6 +730,22 @@ product_handler(vector strvec)
 }
 
 static int
+revision_handler(vector strvec)
+{
+	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
+
+	if (!hwe)
+		return 1;
+
+	hwe->revision = set_value(strvec);
+
+	if (!hwe->revision)
+		return 1;
+
+	return 0;
+}
+
+static int
 bl_product_handler(vector strvec)
 {
 	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
@@ -1617,6 +1633,17 @@ snprint_hw_product (char * buff, int len
 }
 
 static int
+snprint_hw_revision (char * buff, int len, void * data)
+{
+	struct hwentry * hwe = (struct hwentry *)data;
+
+	if (!hwe->revision)
+		return 0;
+
+	return snprintf(buff, len, "\"%s\"", hwe->revision);
+}
+
+static int
 snprint_hw_bl_product (char * buff, int len, void * data)
 {
 	struct hwentry * hwe = (struct hwentry *)data;
@@ -2212,6 +2239,7 @@ init_keywords(void)
 	install_sublevel();
 	install_keyword("vendor", &vendor_handler, &snprint_hw_vendor);
 	install_keyword("product", &product_handler, &snprint_hw_product);
+	install_keyword("revision", &revision_handler, &snprint_hw_revision);
 	install_keyword("product_blacklist", &bl_product_handler, &snprint_hw_bl_product);
 	install_keyword("path_grouping_policy", &hw_pgpolicy_handler, &snprint_hw_path_grouping_policy);
 	install_keyword("getuid_callout", &hw_getuid_callout_handler, &snprint_hw_getuid_callout);
Index: multipath-tools-101104/multipath/multipath.conf.5
===================================================================
--- multipath-tools-101104.orig/multipath/multipath.conf.5
+++ multipath-tools-101104/multipath/multipath.conf.5
@@ -406,8 +406,11 @@ subsection recognizes the following attr
 .B product
 (Mandatory) Product identifier
 .TP
+.B revision
+(Optional) Revision identfier
+.TP
 .B product_blacklist
-Product strings to blacklist for this vendor
+(Optional) Product strings to blacklist for this vendor
 .TP
 .B hardware_handler
 (Optional) The hardware handler to use for this device type.
