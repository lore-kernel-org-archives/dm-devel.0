From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH V3 06/18] multipath: remove duplicates from
	multipath
Date: Sat, 12 Jan 2013 00:04:43 -0600
Message-ID: <1357970695-3396-6-git-send-email-bmarzins@redhat.com>
References: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
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
 libmultipath/blacklist.c | 91 +++++++++++++++++++++++++-----------------------
 libmultipath/config.c    | 19 ++++++++--
 2 files changed, 63 insertions(+), 47 deletions(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index f369517..49a40f9 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -96,50 +96,6 @@ set_ble_device (vector blist, char * vendor, char * product, int origin)
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
@@ -193,6 +149,53 @@ _blacklist_device (vector blist, char * vendor, char * product)
 	return 0;
 }
 
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
+
 #define LOG_BLIST(M) \
 	if (vendor && product)						 \
 		condlog(3, "%s: (%s:%s) %s", dev, vendor, product, (M)); \
diff --git a/libmultipath/config.c b/libmultipath/config.c
index 5b26298..50863b2 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -25,13 +25,19 @@
 static int
 hwe_strmatch (struct hwentry *hwe1, struct hwentry *hwe2)
 {
-	if (hwe1->vendor && hwe2->vendor && strcmp(hwe1->vendor, hwe2->vendor))
+	if ((hwe2->vendor && !hwe1->vendor) ||
+	    (hwe1->vendor && (!hwe2->vendor ||
+			      strcmp(hwe1->vendor, hwe2->vendor))))
 		return 1;
 
-	if (hwe1->product && hwe2->product && strcmp(hwe1->product, hwe2->product))
+	if ((hwe2->product && !hwe1->product) ||
+	    (hwe1->product && (!hwe2->product ||
+			      strcmp(hwe1->product, hwe2->product))))
 		return 1;
 
-	if (hwe1->revision && hwe2->revision && strcmp(hwe1->revision, hwe2->revision))
+	if ((hwe2->revision && !hwe1->revision) ||
+	    (hwe1->revision && (!hwe2->revision ||
+			      strcmp(hwe1->revision, hwe2->revision))))
 		return 1;
 
 	return 0;
@@ -416,6 +422,13 @@ factorize_hwtable (vector hw, int n)
 				continue;
 			/* dup */
 			merge_hwe(hwe2, hwe1);
+			if (hwe_strmatch(hwe2, hwe1) == 0) {
+				vector_del_slot(hw, i);
+				free_hwe(hwe1);
+				n -= 1;
+				i -= 1;
+				break;
+			}
 		}
 	}
 	return 0;
-- 
1.8.0
