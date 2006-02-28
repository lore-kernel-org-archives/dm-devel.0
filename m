From: egoggin@emc.com
Subject: 2 minor updates to hwtable.c for EMC CLARiiON and
	default blackli sting enhancement
Date: Tue, 28 Feb 2006 17:44:06 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321B06E@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Christophe,

I've included a cg-diff patch for changing both the product and
no_path_retry defaults for the EMC CLARiiON.  Also, I've included a patch
for being able to associate a default blacklist product string with each
hwentry.  This is useful for the CLARiiON in order to blacklist LUNZ entries
by default.

Ed

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index 92ab876..7cf9280 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -95,28 +95,46 @@ set_ble_device (vector blist, char * ven
 }
 
 int
-setup_default_blist (vector blist)
+setup_default_blist (struct config * conf)
 {
+	struct blentry * ble;
+	struct hwentry *hwe;
 	char * str;
+	int i;
 
 	str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*");
 	if (!str)
 		return 1;
-	if (store_ble(blist, str))
+	if (store_ble(conf->blist_devnode, str))
 		return 1;
 
 	str = STRDUP("^hd[a-z]");
 	if (!str)
 		return 1;
-	if (store_ble(blist, str))
+	if (store_ble(conf->blist_devnode, str))
 		return 1;
 	
 	str = STRDUP("^cciss!c[0-9]d[0-9]*");
 	if (!str)
 		return 1;
-	if (store_ble(blist, str))
+	if (store_ble(conf->blist_devnode, str))
 		return 1;
 
+	vector_foreach_slot (conf->hwtable, hwe, i) {
+		if (hwe->bl_product) {
+			if (alloc_ble_device(conf->blist_device))
+				return 1;
+			ble = VECTOR_SLOT(conf->blist_device,
+					  VECTOR_SIZE(conf->blist_device) -
1);
+			if (set_ble_device(conf->blist_device,
+					   STRDUP(hwe->vendor),
+					   STRDUP(hwe->bl_product))) {
+				FREE(ble);
+				return 1;
+			}
+		}
+	}
+	
 	return 0;
 }
 
diff --git a/libmultipath/blacklist.h b/libmultipath/blacklist.h
index 16a1399..9e2b63c 100644
--- a/libmultipath/blacklist.h
+++ b/libmultipath/blacklist.h
@@ -15,7 +15,7 @@ struct blentry_device {
 	regex_t product_reg;
 };
 
-int setup_default_blist (vector);
+int setup_default_blist (struct config *);
 int alloc_ble_device (vector);
 int blacklist (vector, char *);
 int blacklist_device (vector, char *, char *);
diff --git a/libmultipath/config.c b/libmultipath/config.c
index e4a8131..1068755 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -106,6 +106,9 @@ free_hwe (struct hwentry * hwe)
 	if (hwe->hwhandler)
 		FREE(hwe->hwhandler);
 
+	if (hwe->bl_product)
+		FREE(hwe->bl_product);
+
 	FREE(hwe);
 }
 
@@ -251,6 +254,8 @@ store_hwe (vector hwtable, struct hwentr
 	hwe->minio = dhwe->minio;
 	hwe->checker = dhwe->checker;
 
+	if (dhwe->bl_product && !(hwe->bl_product =
set_param_str(dhwe->bl_product)))
+		goto out;
 
 	if (!vector_alloc_slot(hwtable))
 		goto out;
@@ -351,9 +356,6 @@ load_config (char * file)
 		
 		if (!conf->blist_devnode)
 			goto out;
-		
-		if (setup_default_blist(conf->blist_devnode))
-			goto out;
 	}
 	if (conf->blist_wwid == NULL) {
 		conf->blist_wwid = vector_alloc();
@@ -367,6 +369,9 @@ load_config (char * file)
 		if (!conf->blist_device)
 			goto out;
 	}
+	if (setup_default_blist(conf))
+		goto out;
+
 	if (conf->mptable == NULL) {
 		conf->mptable = vector_alloc();
 
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 94a0f61..6e5633a 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -24,6 +24,7 @@ struct hwentry {
 	int no_path_retry;
 	int minio;
 	struct checker * checker;
+	char * bl_product;
 };
 
 struct mpentry {
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 6dbae2c..d2add7b 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -361,6 +361,21 @@ product_handler(vector strvec)
 }
 
 static int
+bl_product_handler(vector strvec)
+{
+	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);
+
+	if (!hwe)
+		return 1;
+
+	hwe->bl_product = set_value(strvec);
+	if (!hwe->bl_product)
+		return 1;
+
+	return 0;
+}
+
+static int
 hw_pgpolicy_handler(vector strvec)
 {
 	char * buff;
@@ -903,6 +918,17 @@ snprint_hw_product (char * buff, int len
 }
 
 static int
+snprint_hw_bl_product (char * buff, int len, void * data)
+{
+	struct hwentry * hwe = (struct hwentry *)data;
+
+	if (!hwe->bl_product)
+		return 0;
+
+	return snprintf(buff, len, "%s", hwe->bl_product);
+}
+
+static int
 snprint_hw_getuid_callout (char * buff, int len, void * data)
 {
 	struct hwentry * hwe = (struct hwentry *)data;
@@ -1325,6 +1351,7 @@ init_keywords(void)
 	install_sublevel();
 	install_keyword("vendor", &vendor_handler, &snprint_hw_vendor);
 	install_keyword("product", &product_handler, &snprint_hw_product);
+	install_keyword("bl_product", &bl_product_handler,
&snprint_hw_bl_product);
 	install_keyword("path_grouping_policy", &hw_pgpolicy_handler,
&snprint_hw_path_grouping_policy);
 	install_keyword("getuid_callout", &hw_getuid_callout_handler,
&snprint_hw_getuid_callout);
 	install_keyword("path_selector", &hw_selector_handler,
&snprint_hw_selector);
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index abafc3e..5c7d625 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -142,7 +142,8 @@ static struct hwentry default_hw[] = {
 	},
 	{
 		.vendor        = "DGC",
-		.product       = "^[^LUN_Z]",
+		.product       = "*",
+		.bl_product    = "LUNZ",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = "/sbin/mpath_prio_emc /dev/%n",
 		.features      = "1 queue_if_no_path",
@@ -151,7 +152,7 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.no_path_retry = (300 / DEFAULT_CHECKINT),
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = EMC_CLARIION,
 	},
