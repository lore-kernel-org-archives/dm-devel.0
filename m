From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 26/28] libmultipath: implement and use blacklist
	merging
Date: Fri,  8 Jun 2018 12:20:39 +0200
Message-ID: <20180608102041.22904-27-mwilck@suse.com>
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

Implement removal of invalid and duplicate entries in blacklists.

With this fix, we can fully enable the config dump/reload test,
which doesn't fail any more.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/blacklist.c | 96 +++++++++++++++++++++++++++++++++-------
 libmultipath/blacklist.h |  2 +
 libmultipath/config.c    |  9 ++++
 tests/hwtable.c          |  5 ---
 4 files changed, 91 insertions(+), 21 deletions(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index 91ed7ddf..361c6032 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -416,6 +416,15 @@ filter_property(struct config * conf, struct udev_device * udev)
 	return MATCH_PROPERTY_BLIST_MISSING;
 }
 
+static void free_ble(struct blentry *ble)
+{
+	if (!ble)
+		return;
+	regfree(&ble->regex);
+	FREE(ble->str);
+	FREE(ble);
+}
+
 void
 free_blacklist (vector blist)
 {
@@ -426,15 +435,45 @@ free_blacklist (vector blist)
 		return;
 
 	vector_foreach_slot (blist, ble, i) {
-		if (ble) {
-			regfree(&ble->regex);
-			FREE(ble->str);
-			FREE(ble);
-		}
+		free_ble(ble);
 	}
 	vector_free(blist);
 }
 
+void merge_blacklist(vector blist)
+{
+	struct blentry *bl1, *bl2;
+	int i, j;
+
+	vector_foreach_slot(blist, bl1, i) {
+		j = i + 1;
+		vector_foreach_slot_after(blist, bl2, j) {
+			if (!bl1->str || !bl2->str || strcmp(bl1->str, bl2->str))
+				continue;
+			condlog(3, "%s: duplicate blist entry section for %s",
+				__func__, bl1->str);
+			free_ble(bl2);
+			vector_del_slot(blist, j);
+			j--;
+		}
+	}
+}
+
+static void free_ble_device(struct blentry_device *ble)
+{
+	if (ble) {
+		if (ble->vendor) {
+			regfree(&ble->vendor_reg);
+			FREE(ble->vendor);
+		}
+		if (ble->product) {
+			regfree(&ble->product_reg);
+			FREE(ble->product);
+		}
+		FREE(ble);
+	}
+}
+
 void
 free_blacklist_device (vector blist)
 {
@@ -445,17 +484,42 @@ free_blacklist_device (vector blist)
 		return;
 
 	vector_foreach_slot (blist, ble, i) {
-		if (ble) {
-			if (ble->vendor) {
-				regfree(&ble->vendor_reg);
-				FREE(ble->vendor);
-			}
-			if (ble->product) {
-				regfree(&ble->product_reg);
-				FREE(ble->product);
-			}
-			FREE(ble);
-		}
+		free_ble_device(ble);
 	}
 	vector_free(blist);
 }
+
+void merge_blacklist_device(vector blist)
+{
+	struct blentry_device *bl1, *bl2;
+	int i, j;
+
+	vector_foreach_slot(blist, bl1, i) {
+		if (!bl1->vendor && !bl1->product) {
+			free_ble_device(bl1);
+			vector_del_slot(blist, i);
+			i--;
+		}
+	}
+
+	vector_foreach_slot(blist, bl1, i) {
+		j = i + 1;
+		vector_foreach_slot_after(blist, bl2, j) {
+			if ((!bl1->vendor && bl2->vendor) ||
+			    (bl1->vendor && !bl2->vendor) ||
+			    (bl1->vendor && bl2->vendor &&
+			     strcmp(bl1->vendor, bl2->vendor)))
+				continue;
+			if ((!bl1->product && bl2->product) ||
+			    (bl1->product && !bl2->product) ||
+			    (bl1->product && bl2->product &&
+			     strcmp(bl1->product, bl2->product)))
+				continue;
+			condlog(3, "%s: duplicate blist entry section for %s:%s",
+				__func__, bl1->vendor, bl1->product);
+			free_ble_device(bl2);
+			vector_del_slot(blist, j);
+			j--;
+		}
+	}
+}
diff --git a/libmultipath/blacklist.h b/libmultipath/blacklist.h
index 443025d2..0b028d46 100644
--- a/libmultipath/blacklist.h
+++ b/libmultipath/blacklist.h
@@ -40,5 +40,7 @@ int store_ble (vector, char *, int);
 int set_ble_device (vector, char *, char *, int);
 void free_blacklist (vector);
 void free_blacklist_device (vector);
+void merge_blacklist(vector);
+void merge_blacklist_device(vector);
 
 #endif /* _BLACKLIST_H */
diff --git a/libmultipath/config.c b/libmultipath/config.c
index c8378f87..28b76dd2 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -817,6 +817,15 @@ load_config (char * file)
 	}
 
 	merge_mptable(conf->mptable);
+	merge_blacklist(conf->blist_devnode);
+	merge_blacklist(conf->blist_property);
+	merge_blacklist(conf->blist_wwid);
+	merge_blacklist_device(conf->blist_device);
+	merge_blacklist(conf->elist_devnode);
+	merge_blacklist(conf->elist_property);
+	merge_blacklist(conf->elist_wwid);
+	merge_blacklist_device(conf->elist_device);
+
 	if (conf->bindings_file == NULL)
 		conf->bindings_file = set_default(DEFAULT_BINDINGS_FILE);
 
diff --git a/tests/hwtable.c b/tests/hwtable.c
index f6fba14d..7daf71eb 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -499,13 +499,8 @@ static void replicate_config(const struct hwt_state *hwt, bool local)
 	DUMP_CFG_STR(cfg2);
 #endif
 
-#if BROKEN
-	condlog(1, "%s: WARNING: skipping tests for same configuration after dump/reload on %d",
-		__func__, __LINE__);
-#else
 	assert_int_equal(strlen(cfg2), strlen(cfg1));
 	assert_string_equal(cfg2, cfg1);
-#endif
 	free(cfg1);
 	free(cfg2);
 }
-- 
2.17.0
