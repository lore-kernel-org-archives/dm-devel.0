From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 1/3] libmultipath: remove
	_blacklist_exceptions functions
Date: Tue,  9 Jun 2020 16:35:27 -0500
Message-ID: <1591738529-26810-2-git-send-email-bmarzins@redhat.com>
References: <1591738529-26810-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1591738529-26810-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Nikhil Kshirsagar <nkshirsa@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

_blacklist_exceptions() and _blacklist_exceptions_device() are exactly
the same as _blacklist() and _blacklist_device(), so remove them, and
give the remaining functions to a more general name.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/blacklist.c | 62 ++++++++++------------------------------
 1 file changed, 15 insertions(+), 47 deletions(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index 00e8dbdb..c21a0e27 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -101,21 +101,8 @@ int set_ble_device(vector blist, char * vendor, char * product, int origin)
 	return 0;
 }
 
-int
-_blacklist_exceptions (vector elist, const char * str)
-{
-	int i;
-	struct blentry * ele;
-
-	vector_foreach_slot (elist, ele, i) {
-		if (!regexec(&ele->regex, str, 0, NULL, 0))
-			return 1;
-	}
-	return 0;
-}
-
-int
-_blacklist (vector blist, const char * str)
+static int
+match_reglist (vector blist, const char * str)
 {
 	int i;
 	struct blentry * ble;
@@ -127,28 +114,9 @@ _blacklist (vector blist, const char * str)
 	return 0;
 }
 
-int
-_blacklist_exceptions_device(const struct _vector *elist, const char * vendor,
-			     const char * product)
-{
-	int i;
-	struct blentry_device * ble;
-
-	vector_foreach_slot (elist, ble, i) {
-		if (!ble->vendor && !ble->product)
-			continue;
-		if ((!ble->vendor ||
-		     !regexec(&ble->vendor_reg, vendor, 0, NULL, 0)) &&
-		    (!ble->product ||
-		     !regexec(&ble->product_reg, product, 0, NULL, 0)))
-			return 1;
-	}
-	return 0;
-}
-
-int
-_blacklist_device (const struct _vector *blist, const char * vendor,
-		   const char * product)
+static int
+match_reglist_device (const struct _vector *blist, const char * vendor,
+		    const char * product)
 {
 	int i;
 	struct blentry_device * ble;
@@ -300,9 +268,9 @@ filter_device (vector blist, vector elist, char * vendor, char * product,
 	int r = MATCH_NOTHING;
 
 	if (vendor && product) {
-		if (_blacklist_exceptions_device(elist, vendor, product))
+		if (match_reglist_device(elist, vendor, product))
 			r = MATCH_DEVICE_BLIST_EXCEPT;
-		else if (_blacklist_device(blist, vendor, product))
+		else if (match_reglist_device(blist, vendor, product))
 			r = MATCH_DEVICE_BLIST;
 	}
 
@@ -316,9 +284,9 @@ filter_devnode (vector blist, vector elist, char * dev)
 	int r = MATCH_NOTHING;
 
 	if (dev) {
-		if (_blacklist_exceptions(elist, dev))
+		if (match_reglist(elist, dev))
 			r = MATCH_DEVNODE_BLIST_EXCEPT;
-		else if (_blacklist(blist, dev))
+		else if (match_reglist(blist, dev))
 			r = MATCH_DEVNODE_BLIST;
 	}
 
@@ -332,9 +300,9 @@ filter_wwid (vector blist, vector elist, char * wwid, char * dev)
 	int r = MATCH_NOTHING;
 
 	if (wwid) {
-		if (_blacklist_exceptions(elist, wwid))
+		if (match_reglist(elist, wwid))
 			r = MATCH_WWID_BLIST_EXCEPT;
-		else if (_blacklist(blist, wwid))
+		else if (match_reglist(blist, wwid))
 			r = MATCH_WWID_BLIST;
 	}
 
@@ -351,9 +319,9 @@ filter_protocol(vector blist, vector elist, struct path * pp)
 	if (pp) {
 		snprint_path_protocol(buf, sizeof(buf), pp);
 
-		if (_blacklist_exceptions(elist, buf))
+		if (match_reglist(elist, buf))
 			r = MATCH_PROTOCOL_BLIST_EXCEPT;
-		else if (_blacklist(blist, buf))
+		else if (match_reglist(blist, buf))
 			r = MATCH_PROTOCOL_BLIST;
 	}
 
@@ -422,11 +390,11 @@ filter_property(struct config *conf, struct udev_device *udev, int lvl,
 			if (check_missing_prop && !strcmp(env, uid_attribute))
 				uid_attr_seen = true;
 
-			if (_blacklist_exceptions(conf->elist_property, env)) {
+			if (match_reglist(conf->elist_property, env)) {
 				r = MATCH_PROPERTY_BLIST_EXCEPT;
 				break;
 			}
-			if (_blacklist(conf->blist_property, env)) {
+			if (match_reglist(conf->blist_property, env)) {
 				r = MATCH_PROPERTY_BLIST;
 				break;
 			}
-- 
2.17.2
