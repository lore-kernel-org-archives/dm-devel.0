From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 26/30] libmultipath: fix has_uid_fallback()
	logic
Date: Mon, 24 Jun 2019 11:27:52 +0200
Message-ID: <20190624092756.7769-28-mwilck@suse.com>
References: <20190624092756.7769-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190624092756.7769-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The idea of 061daf40 "Do not automatically fall back to vpd uid
generation" applies not only to SCSI. Use the same logic for NVMe.
Allow fallback in two cases:
 - uid_attribute has the default value for the bus in question
 - uid_attribute has been set to "" to disable udev-based WWID checking
As uid_fallback() has only one caller, no need to check the conditions
there again.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/defaults.h  |  1 +
 libmultipath/discovery.c | 20 +++++++++++++++-----
 libmultipath/hwtable.c   |  2 +-
 tests/hwtable.c          |  2 +-
 4 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 83f89f37..decc9335 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -5,6 +5,7 @@
  * and the TEMPLATE in libmultipath/hwtable.c
  */
 #define DEFAULT_UID_ATTRIBUTE	"ID_SERIAL"
+#define DEFAULT_NVME_UID_ATTRIBUTE	"ID_WWN"
 #define DEFAULT_UDEVDIR		"/dev"
 #define DEFAULT_MULTIPATHDIR	"/" LIB_STRING "/multipath"
 #define DEFAULT_SELECTOR	"service-time 0"
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index d7eaee68..15f5cd4b 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1802,8 +1802,7 @@ static ssize_t uid_fallback(struct path *pp, int path_state,
 {
 	ssize_t len = -1;
 
-	if (pp->bus == SYSFS_BUS_SCSI &&
-	    !strcmp(pp->uid_attribute, DEFAULT_UID_ATTRIBUTE)) {
+	if (pp->bus == SYSFS_BUS_SCSI) {
 		len = get_vpd_uid(pp);
 		*origin = "sysfs";
 		if (len < 0 && path_state == PATH_UP) {
@@ -1833,11 +1832,22 @@ static ssize_t uid_fallback(struct path *pp, int path_state,
 	return len;
 }
 
-static int has_uid_fallback(struct path *pp)
+static bool has_uid_fallback(struct path *pp)
 {
+	/*
+	 * Falling back to direct WWID determination is dangerous
+	 * if uid_attribute is set to something non-standard.
+	 * Allow it only if it's either the default, or if udev
+	 * has been disabled by setting 'uid_attribute ""'.
+	 */
+	if (!pp->uid_attribute)
+		return false;
 	return ((pp->bus == SYSFS_BUS_SCSI &&
-		 !strcmp(pp->uid_attribute, DEFAULT_UID_ATTRIBUTE)) ||
-		pp->bus == SYSFS_BUS_NVME);
+		 (!strcmp(pp->uid_attribute, DEFAULT_UID_ATTRIBUTE) ||
+		  !strcmp(pp->uid_attribute, ""))) ||
+		(pp->bus == SYSFS_BUS_NVME &&
+		 (!strcmp(pp->uid_attribute, DEFAULT_NVME_UID_ATTRIBUTE) ||
+		  !strcmp(pp->uid_attribute, ""))));
 }
 
 int
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 1d964333..46caaf91 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -88,7 +88,7 @@ static struct hwentry default_hw[] = {
 		/* Generic NVMe */
 		.vendor        = "NVME",
 		.product       = ".*",
-		.uid_attribute = "ID_WWN",
+		.uid_attribute = DEFAULT_NVME_UID_ATTRIBUTE,
 		.checker_name  = NONE,
 		.retain_hwhandler = RETAIN_HWHANDLER_OFF,
 	},
diff --git a/tests/hwtable.c b/tests/hwtable.c
index f436f52d..977a5663 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -571,7 +571,7 @@ static void test_internal_nvme(const struct hwt_state *hwt)
 	mp = mock_multipath(pp);
 	assert_ptr_not_equal(mp, NULL);
 	TEST_PROP(checker_name(&pp->checker), NONE);
-	TEST_PROP(pp->uid_attribute, "ID_WWN");
+	TEST_PROP(pp->uid_attribute, DEFAULT_NVME_UID_ATTRIBUTE);
 	assert_int_equal(mp->pgpolicy, DEFAULT_PGPOLICY);
 	assert_int_equal(mp->no_path_retry, DEFAULT_NO_PATH_RETRY);
 	assert_int_equal(mp->retain_hwhandler, RETAIN_HWHANDLER_OFF);
-- 
2.21.0
