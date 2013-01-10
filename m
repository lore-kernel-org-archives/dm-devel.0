From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2] multipath: remove duplicates from
	multipath	configuration
Date: Thu, 10 Jan 2013 14:10:22 -0600
Message-ID: <20130110201022.GR19059@ether.msp.redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Added code to remove duplcate entries in the devices section, and the
blacklist devices section of the builtin configuration table. The only
change to setup_default_blist is the addition of _blacklist_device()
to check if the device's bl_product entry already exists.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/blacklist.c |   91 ++++++++++++++++++++++++-----------------------
 libmultipath/config.c    |   16 ++++++--
 2 files changed, 60 insertions(+), 47 deletions(-)

Index: multipath-tools-120821/libmultipath/blacklist.c
===================================================================
--- multipath-tools-120821.orig/libmultipath/blacklist.c
+++ multipath-tools-120821/libmultipath/blacklist.c
@@ -96,50 +96,6 @@ set_ble_device (vector blist, char * ven
 }
 
 int
-setup_default_blist (struct config * conf)
-{
-	struct blentry * ble;
-	struct hwentry *hwe;
-	char * str;
-	int i;
-
-	str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*");
-	if (!str)
-		return 1;
-	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
-		return 1;
-
-	str = STRDUP("^hd[a-z]");
-	if (!str)
-		return 1;
-	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
-		return 1;
-
-	str = STRDUP("^dcssblk[0-9]*");
-	if (!str)
-		return 1;
-	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
-		return 1;
-
-	vector_foreach_slot (conf->hwtable, hwe, i) {
-		if (hwe->bl_product) {
-			if (alloc_ble_device(conf->blist_device))
-				return 1;
-			ble = VECTOR_SLOT(conf->blist_device,
-					  VECTOR_SIZE(conf->blist_device) -1);
-			if (set_ble_device(conf->blist_device,
-					   STRDUP(hwe->vendor),
-					   STRDUP(hwe->bl_product),
-					   ORIGIN_DEFAULT)) {
-				FREE(ble);
-				return 1;
-			}
-		}
-	}
-	return 0;
-}
-
-int
 _blacklist_exceptions (vector elist, char * str)
 {
 	int i;
@@ -192,6 +148,53 @@ _blacklist_device (vector blist, char *
 	}
 	return 0;
 }
+
+int
+setup_default_blist (struct config * conf)
+{
+	struct blentry * ble;
+	struct hwentry *hwe;
+	char * str;
+	int i;
+
+	str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*");
+	if (!str)
+		return 1;
+	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
+		return 1;
+
+	str = STRDUP("^hd[a-z]");
+	if (!str)
+		return 1;
+	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
+		return 1;
+
+	str = STRDUP("^dcssblk[0-9]*");
+	if (!str)
+		return 1;
+	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
+		return 1;
+
+	vector_foreach_slot (conf->hwtable, hwe, i) {
+		if (hwe->bl_product) {
+			if (_blacklist_device(conf->blist_device, hwe->vendor,
+					      hwe->bl_product))
+				continue;
+			if (alloc_ble_device(conf->blist_device))
+				return 1;
+			ble = VECTOR_SLOT(conf->blist_device,
+					  VECTOR_SIZE(conf->blist_device) -1);
+			if (set_ble_device(conf->blist_device,
+					   STRDUP(hwe->vendor),
+					   STRDUP(hwe->bl_product),
+					   ORIGIN_DEFAULT)) {
+				FREE(ble);
+				return 1;
+			}
+		}
+	}
+	return 0;
+}
 
 #define LOG_BLIST(M) \
 	if (vendor && product)						 \
Index: multipath-tools-120821/libmultipath/config.c
===================================================================
--- multipath-tools-120821.orig/libmultipath/config.c
+++ multipath-tools-120821/libmultipath/config.c
@@ -25,13 +25,16 @@
 static int
 hwe_strmatch (struct hwentry *hwe1, struct hwentry *hwe2)
 {
-	if (hwe1->vendor && hwe2->vendor && strcmp(hwe1->vendor, hwe2->vendor))
+	if ((!!(hwe1->vendor) != !!(hwe2->vendor)) ||
+	    (hwe1->vendor && strcmp(hwe1->vendor, hwe2->vendor)))
 		return 1;
 
-	if (hwe1->product && hwe2->product && strcmp(hwe1->product, hwe2->product))
+	if ((!!(hwe1->product) != !!(hwe2->product)) ||
+	    (hwe1->product && strcmp(hwe1->product, hwe2->product)))
 		return 1;
 
-	if (hwe1->revision && hwe2->revision && strcmp(hwe1->revision, hwe2->revision))
+	if ((!!(hwe1->revision) != !!(hwe2->revision)) ||
+	    (hwe1->revision && strcmp(hwe1->revision, hwe2->revision)))
 		return 1;
 
 	return 0;
@@ -416,6 +419,13 @@ factorize_hwtable (vector hw, int n)
 				continue;
 			/* dup */
 			merge_hwe(hwe2, hwe1);
+			if (hwe_strmatch(hwe2, hwe1) == 0) {
+				vector_del_slot(hw, i);
+				free_hwe(hwe1);
+				n -= 1;
+				i -= 1;
+				j -= 1;
+			}
 		}
 	}
 	return 0;
