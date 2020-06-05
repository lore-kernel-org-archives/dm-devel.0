From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [RFC PATCH 1/2] libmultipath: change filter_devnode
	arguments
Date: Thu,  4 Jun 2020 19:30:59 -0500
Message-ID: <1591317060-25484-2-git-send-email-bmarzins@redhat.com>
References: <1591317060-25484-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1591317060-25484-1-git-send-email-bmarzins@redhat.com>
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

Instead of taking the blist and elist devnode vectors, filter device
now takes a config struct. This change is necessary to enable future
commits. It makes no functional changes to the code.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/blacklist.c  |  8 ++++----
 libmultipath/blacklist.h  |  2 +-
 libmultipath/discovery.c  |  4 +---
 libmultipath/print.c      |  3 +--
 libmultipath/uevent.c     |  3 +--
 multipath/main.c          |  3 +--
 multipathd/cli_handlers.c |  3 +--
 tests/blacklist.c         | 18 +++++++++++-------
 8 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index 00e8dbdb..bc8e9e00 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -311,14 +311,14 @@ filter_device (vector blist, vector elist, char * vendor, char * product,
 }
 
 int
-filter_devnode (vector blist, vector elist, char * dev)
+filter_devnode (struct config *conf, char * dev)
 {
 	int r = MATCH_NOTHING;
 
 	if (dev) {
-		if (_blacklist_exceptions(elist, dev))
+		if (_blacklist_exceptions(conf->elist_devnode, dev))
 			r = MATCH_DEVNODE_BLIST_EXCEPT;
-		else if (_blacklist(blist, dev))
+		else if (_blacklist(conf->blist_devnode, dev))
 			r = MATCH_DEVNODE_BLIST;
 	}
 
@@ -369,7 +369,7 @@ filter_path (struct config * conf, struct path * pp)
 	r = filter_property(conf, pp->udev, 3, pp->uid_attribute);
 	if (r > 0)
 		return r;
-	r = filter_devnode(conf->blist_devnode, conf->elist_devnode, pp->dev);
+	r = filter_devnode(conf, pp->dev);
 	if (r > 0)
 		return r;
 	r = filter_device(conf->blist_device, conf->elist_device,
diff --git a/libmultipath/blacklist.h b/libmultipath/blacklist.h
index 2d721f60..938b9505 100644
--- a/libmultipath/blacklist.h
+++ b/libmultipath/blacklist.h
@@ -33,7 +33,7 @@ struct blentry_device {
 
 int setup_default_blist (struct config *);
 int alloc_ble_device (vector);
-int filter_devnode (vector, vector, char *);
+int filter_devnode (struct config *, char *);
 int filter_wwid (vector, vector, char *, char *);
 int filter_device (vector, vector, char *, char *, char *);
 int filter_path (struct config *, struct path *);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index ffec5162..2d003359 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2066,9 +2066,7 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 			return PATHINFO_SKIPPED;
 	}
 
-	if (filter_devnode(conf->blist_devnode,
-			   conf->elist_devnode,
-			   pp->dev) > 0)
+	if (filter_devnode(conf, pp->dev) > 0)
 		return PATHINFO_SKIPPED;
 
 	condlog(4, "%s: mask = 0x%x", pp->dev, mask);
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 298b3764..ee79a9d0 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -2071,8 +2071,7 @@ int snprint_devices(struct config *conf, char * buff, int len,
 				blkdev->d_name);
 		pp = find_path_by_dev(vecs->pathvec, blkdev->d_name);
 		if (!pp) {
-			r = filter_devnode(conf->blist_devnode,
-					   conf->elist_devnode, blkdev->d_name);
+			r = filter_devnode(conf, blkdev->d_name);
 			if (r > 0)
 				fwd += snprintf(buff + fwd, len - fwd,
 						" devnode blacklisted, unmonitored");
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index e0d13b11..05937306 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -202,8 +202,7 @@ uevent_can_discard(struct uevent *uev)
 	 */
 	conf = get_multipath_config();
 	pthread_cleanup_push(put_multipath_config, conf);
-	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
-			   uev->kernel) > 0)
+	if (filter_devnode(conf, uev->kernel) > 0)
 		invalid = 1;
 	pthread_cleanup_pop(1);
 
diff --git a/multipath/main.c b/multipath/main.c
index 953fab27..b235ad66 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -565,8 +565,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 	if (dev && (dev_type == DEV_DEVNODE ||
 		    dev_type == DEV_UEVENT) &&
 	    cmd != CMD_REMOVE_WWID &&
-	    (filter_devnode(conf->blist_devnode,
-			    conf->elist_devnode, dev) > 0)) {
+	    (filter_devnode(conf, dev) > 0)) {
 		goto out;
 	}
 
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 31c3d9fd..bda81184 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -705,8 +705,7 @@ cli_add_path (void * v, char ** reply, int * len, void * data)
 	condlog(2, "%s: add path (operator)", param);
 	conf = get_multipath_config();
 	pthread_cleanup_push(put_multipath_config, conf);
-	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
-			   param) > 0)
+	if (filter_devnode(conf, param) > 0)
 		invalid = 1;
 	pthread_cleanup_pop(1);
 	if (invalid)
diff --git a/tests/blacklist.c b/tests/blacklist.c
index 6e7c1864..0ae82592 100644
--- a/tests/blacklist.c
+++ b/tests/blacklist.c
@@ -138,24 +138,28 @@ static int reset_blists(void **state)
 
 static void test_devnode_blacklist(void **state)
 {
+	conf.blist_devnode = blist_devnode_sdb;
 	expect_condlog(3, "sdb: device node name blacklisted\n");
-	assert_int_equal(filter_devnode(blist_devnode_sdb, NULL, "sdb"),
+	assert_int_equal(filter_devnode(&conf, "sdb"),
 			 MATCH_DEVNODE_BLIST);
 }
 
 static void test_devnode_whitelist(void **state)
 {
+	conf.blist_devnode = blist_all;
+	conf.elist_devnode = blist_devnode_sdb;
 	expect_condlog(3, "sdb: device node name whitelisted\n");
-	assert_int_equal(filter_devnode(blist_all, blist_devnode_sdb, "sdb"),
+	assert_int_equal(filter_devnode(&conf, "sdb"),
 			 MATCH_DEVNODE_BLIST_EXCEPT);
 	expect_condlog(3, "sdc: device node name blacklisted\n");
-	assert_int_equal(filter_devnode(blist_all, blist_devnode_sdb, "sdc"),
+	assert_int_equal(filter_devnode(&conf, "sdc"),
 			 MATCH_DEVNODE_BLIST);
 }
 
 static void test_devnode_missing(void **state)
 {
-	assert_int_equal(filter_devnode(blist_devnode_sdb, NULL, "sdc"),
+	conf.blist_devnode = blist_devnode_sdb;
+	assert_int_equal(filter_devnode(&conf, "sdc"),
 			 MATCH_NOTHING);
 }
 
@@ -481,9 +485,9 @@ static void test_filter_path_whitelist_wwid(void **state)
 int test_blacklist(void)
 {
 	const struct CMUnitTest tests[] = {
-		cmocka_unit_test(test_devnode_blacklist),
-		cmocka_unit_test(test_devnode_whitelist),
-		cmocka_unit_test(test_devnode_missing),
+		test_and_reset(test_devnode_blacklist),
+		test_and_reset(test_devnode_whitelist),
+		test_and_reset(test_devnode_missing),
 		cmocka_unit_test(test_device_blacklist),
 		cmocka_unit_test(test_device_whitelist),
 		cmocka_unit_test(test_device_missing),
-- 
2.17.2
