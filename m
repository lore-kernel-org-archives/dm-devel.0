From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 8/8] libmutipath: allow blanks in device blacklist
Date: Fri, 16 Jan 2015 14:23:32 -0600
Message-ID: <1421439812-11826-9-git-send-email-bmarzins@redhat.com>
References: <1421439812-11826-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1421439812-11826-1-git-send-email-bmarzins@redhat.com>
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
Cc: Brian De Wolf <bldewolf@cpp.edu>
List-Id: dm-devel.ids

As Brian De Wolf noticed, multipath crashes if you don't have both
vendor and product specified in a device blacklist entry. This patch
makes device blacklists work when either the vendor or the product is
blank. If both are missing, the entry is ignored.

Cc: Brian De Wolf <bldewolf@cpp.edu>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/blacklist.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index 3f9e80b..05f1697 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -135,8 +135,12 @@ _blacklist_exceptions_device(vector elist, char * vendor, char * product)
 	struct blentry_device * ble;
 
 	vector_foreach_slot (elist, ble, i) {
-		if (!regexec(&ble->vendor_reg, vendor, 0, NULL, 0) &&
-		    !regexec(&ble->product_reg, product, 0, NULL, 0))
+		if (!ble->vendor && !ble->product)
+			continue;
+		if ((!ble->vendor ||
+		     !regexec(&ble->vendor_reg, vendor, 0, NULL, 0)) &&
+		    (!ble->product ||
+		     !regexec(&ble->product_reg, product, 0, NULL, 0)))
 			return 1;
 	}
 	return 0;
@@ -149,8 +153,12 @@ _blacklist_device (vector blist, char * vendor, char * product)
 	struct blentry_device * ble;
 
 	vector_foreach_slot (blist, ble, i) {
-		if (!regexec(&ble->vendor_reg, vendor, 0, NULL, 0) &&
-		    !regexec(&ble->product_reg, product, 0, NULL, 0))
+		if (!ble->vendor && !ble->product)
+			continue;
+		if ((!ble->vendor ||
+		     !regexec(&ble->vendor_reg, vendor, 0, NULL, 0)) &&
+		    (!ble->product ||
+		     !regexec(&ble->product_reg, product, 0, NULL, 0)))
 			return 1;
 	}
 	return 0;
-- 
1.8.3.1
