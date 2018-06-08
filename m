From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 17/28] libmultipath: don't merge by regex in
	setup_default_blist()
Date: Fri,  8 Jun 2018 12:20:30 +0200
Message-ID: <20180608102041.22904-18-mwilck@suse.com>
References: <20180608102041.22904-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180608102041.22904-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The merging of blacklist entries by regular expression leads
to similar problems as the merging of hwentries. Only merge
blacklist entries if they're exactly equal.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/blacklist.c | 23 +++++++++++++++++++++--
 tests/hwtable.c          |  8 +-------
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index 34a7e717..91ed7ddf 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -163,6 +163,25 @@ _blacklist_device (const struct _vector *blist, const char * vendor,
 	return 0;
 }
 
+static int
+find_blacklist_device (const struct _vector *blist, const char * vendor,
+		       const char * product)
+{
+	int i;
+	struct blentry_device * ble;
+
+	vector_foreach_slot (blist, ble, i) {
+		if (((!vendor && !ble->vendor) ||
+		     (vendor && ble->vendor &&
+		      !strcmp(vendor, ble->vendor))) &&
+		    ((!product && !ble->product) ||
+		     (product && ble->product &&
+		      !strcmp(product, ble->product))))
+			return 1;
+	}
+	return 0;
+}
+
 int
 setup_default_blist (struct config * conf)
 {
@@ -191,8 +210,8 @@ setup_default_blist (struct config * conf)
 
 	vector_foreach_slot (conf->hwtable, hwe, i) {
 		if (hwe->bl_product) {
-			if (_blacklist_device(conf->blist_device, hwe->vendor,
-					      hwe->bl_product))
+			if (find_blacklist_device(conf->blist_device,
+						  hwe->vendor, hwe->bl_product))
 				continue;
 			if (alloc_ble_device(conf->blist_device))
 				return 1;
diff --git a/tests/hwtable.c b/tests/hwtable.c
index 15f364e4..85215946 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -1399,13 +1399,7 @@ static int setup_product_blacklist(void **state)
 static void test_product_blacklist_matching(const struct hwt_state *hwt)
 {
 	mock_path_flags(vnd_foo.value, prd_bar.value, BL_BY_DEVICE);
-#if BROKEN == 1
-	condlog(1, "%s: WARNING: broken blacklist test on line %d",
-		__func__, __LINE__ + 1);
-	mock_path(vnd_foo.value, prd_baz.value);
-#else
-	mock_path_blacklisted(vnd_foo.value, prd_baz.value);
-#endif
+	mock_path_flags(vnd_foo.value, prd_baz.value, BL_BY_DEVICE);
 	mock_path(vnd_foo.value, prd_bam.value);
 }
 
-- 
2.17.0
