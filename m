Return-Path: <SRS0=YUkt=HE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC16C433DB
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 21:28:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1D2A564F7C
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 21:28:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D2A564F7C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-ll6gl7xePg2defcF-x7lQQ-1; Tue, 02 Feb 2021 16:27:58 -0500
X-MC-Unique: ll6gl7xePg2defcF-x7lQQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9F8F107ACE8;
	Tue,  2 Feb 2021 21:27:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 221DB5D722;
	Tue,  2 Feb 2021 21:27:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 26B3518095CB;
	Tue,  2 Feb 2021 21:27:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 112LRmsV015461 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Feb 2021 16:27:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4A8932026D47; Tue,  2 Feb 2021 21:27:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 44FCE2026D5D
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 21:27:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F79F82DFE0
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 21:27:47 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-13-srCYxlBkNX-UybsT8OQeHQ-1;
	Tue, 02 Feb 2021 16:27:42 -0500
X-MC-Unique: srCYxlBkNX-UybsT8OQeHQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 08A31ADDD;
	Tue,  2 Feb 2021 21:27:41 +0000 (UTC)
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>, lixiaokeng@huawei.com
Date: Tue,  2 Feb 2021 22:27:27 +0100
Message-Id: <20210202212729.18442-2-mwilck@suse.com>
In-Reply-To: <20210202212729.18442-1-mwilck@suse.com>
References: <20210202212729.18442-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 112LRmsV015461
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 1/3] pathinfo: call filter_property() after
	sysfs_pathinfo()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The of filter_property() depends on the value of pp->uid_attribute.
This may in turn depend on pp->hwe, which is initialized in
sysfs_pathinfo(). To obtain consistent results from pathinfo(),
make sure uid_attribute is correctly set before calling filter_property().

filter_property() is now called from pathinfo() with properly set
uid_attribute, thus we don't need to call it from is_path_valid() any more.

Thes changes require modifications to the unit tests. The is_path_valid()
test now wouldn't need to test filter_property() any more, because
is_path_valid() calls filter_property() no more. But that doesn't feel
right. Instead, test_filter_property() is modified to test the behavior
with the filter_property() test called indirectly from pathinfo().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 21 +++++++++-
 libmultipath/valid.c     |  4 --
 tests/Makefile           |  2 +-
 tests/test-lib.c         |  5 ++-
 tests/valid.c            | 91 ++++++++++++++++++++++++++++++++++++----
 5 files changed, 105 insertions(+), 18 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 15cf641..febcd0a 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2247,9 +2247,17 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 			condlog(4, "%s: hidden", pp->dev);
 			return PATHINFO_SKIPPED;
 		}
-		if (is_claimed_by_foreign(pp->udev) ||
-		    filter_property(conf, pp->udev, 4, pp->uid_attribute) > 0)
+
+		if (is_claimed_by_foreign(pp->udev))
 			return PATHINFO_SKIPPED;
+
+		/*
+		 * uid_attribute is required for filter_property below,
+		 * and needs access to pp->hwe.
+		 */
+		if (!(mask & DI_SYSFS) && !pp->uid_attribute &&
+		    VECTOR_SIZE(pp->hwe) == 0)
+			mask |= DI_SYSFS;
 	}
 
 	if (strlen(pp->dev) != 0 && filter_devnode(conf->blist_devnode,
@@ -2287,6 +2295,15 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 		}
 	}
 
+	if (pp->udev) {
+		/* uid_attribute is required for filter_property() */
+		if (!pp->uid_attribute)
+			select_getuid(conf, pp);
+
+		if (filter_property(conf, pp->udev, 4, pp->uid_attribute) > 0)
+			return PATHINFO_SKIPPED;
+	}
+
 	if (mask & DI_BLACKLIST && mask & DI_SYSFS) {
 		if (filter_device(conf->blist_device, conf->elist_device,
 				  pp->vendor_id, pp->product_id, pp->dev) > 0 ||
diff --git a/libmultipath/valid.c b/libmultipath/valid.c
index 456b1f6..a6aa921 100644
--- a/libmultipath/valid.c
+++ b/libmultipath/valid.c
@@ -89,10 +89,6 @@ is_path_valid(const char *name, struct config *conf, struct path *pp,
 	if (pp->wwid[0] == '\0')
 		return PATH_IS_NOT_VALID;
 
-	if (pp->udev && pp->uid_attribute &&
-	    filter_property(conf, pp->udev, 3, pp->uid_attribute) > 0)
-		return PATH_IS_NOT_VALID;
-
 	r = is_failed_wwid(pp->wwid);
 	if (r != WWID_IS_NOT_FAILED) {
 		if (r == WWID_IS_FAILED)
diff --git a/tests/Makefile b/tests/Makefile
index 50673fa..11ca1be 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -54,7 +54,7 @@ vpd-test_OBJDEPS :=  ../libmultipath/discovery.o
 vpd-test_LIBDEPS := -ludev -lpthread -ldl
 alias-test_TESTDEPS := test-log.o
 alias-test_LIBDEPS := -lpthread -ldl
-valid-test_OBJDEPS := ../libmultipath/valid.o
+valid-test_OBJDEPS := ../libmultipath/valid.o ../libmultipath/discovery.o
 valid-test_LIBDEPS := -ludev -lpthread -ldl
 devt-test_LIBDEPS := -ludev
 mpathvalid-test_LIBDEPS := -ludev -lpthread -ldl
diff --git a/tests/test-lib.c b/tests/test-lib.c
index e7663f9..960a766 100644
--- a/tests/test-lib.c
+++ b/tests/test-lib.c
@@ -257,6 +257,9 @@ void mock_pathinfo(int mask, const struct mocked_path *mp)
 	} else
 		will_return(__wrap_udev_device_get_sysattr_value, "0");
 
+	if (mask & DI_SYSFS)
+		mock_sysfs_pathinfo(mp);
+
 	/* filter_property */
 	will_return(__wrap_udev_device_get_sysname, mp->devnode);
 	if (mp->flags & BL_BY_PROPERTY) {
@@ -265,8 +268,6 @@ void mock_pathinfo(int mask, const struct mocked_path *mp)
 	} else
 		will_return(__wrap_udev_list_entry_get_name,
 			    "SCSI_IDENT_LUN_NAA_EXT");
-	if (mask & DI_SYSFS)
-		mock_sysfs_pathinfo(mp);
 
 	if (mp->flags & BL_BY_DEVICE &&
 	    (mask & DI_BLACKLIST && mask & DI_SYSFS))
diff --git a/tests/valid.c b/tests/valid.c
index 693c72c..8ec803e 100644
--- a/tests/valid.c
+++ b/tests/valid.c
@@ -25,13 +25,18 @@
 #include <stdlib.h>
 #include <errno.h>
 #include <cmocka.h>
+#include <sys/sysmacros.h>
+
 #include "globals.c"
 #include "util.h"
 #include "discovery.h"
 #include "wwids.h"
 #include "blacklist.h"
+#include "foreign.h"
 #include "valid.h"
 
+#define PATHINFO_REAL 9999
+
 int test_fd;
 struct udev_device {
 	int unused;
@@ -78,12 +83,66 @@ struct udev_device *__wrap_udev_device_new_from_subsystem_sysname(struct udev *u
 	return NULL;
 }
 
+/* For the "hidden" check in pathinfo() */
+const char *__wrap_udev_device_get_sysattr_value(struct udev_device *udev_device,
+					 const char *sysattr)
+{
+	check_expected(sysattr);
+	return mock_ptr_type(char *);
+}
+
+/* For pathinfo() -> is_claimed_by_foreign() */
+int __wrap_add_foreign(struct udev_device *udev_device)
+{
+	return mock_type(int);
+}
+
+/* called from pathinfo() */
+int __wrap_filter_devnode(struct config *conf, const struct _vector *elist,
+			  const char *vendor, const char * product, const char *dev)
+{
+	return mock_type(int);
+}
+
+/* called from pathinfo() */
+int __wrap_filter_device(const struct _vector *blist, const struct _vector *elist,
+	       const char *vendor, const char * product, const char *dev)
+{
+	return mock_type(int);
+}
+
+/* for common_sysfs_pathinfo() */
+dev_t __wrap_udev_device_get_devnum(struct udev_device *ud)
+{
+	return  mock_type(dev_t);
+}
+
+/* for common_sysfs_pathinfo() */
+int __wrap_sysfs_get_size(struct path *pp, unsigned long long * size)
+{
+	return mock_type(int);
+}
+
+/* called in pathinfo() before filter_property() */
+int __wrap_select_getuid(struct config *conf, struct path *pp)
+{
+	pp->uid_attribute = mock_ptr_type(char *);
+	return 0;
+}
+
+int __real_pathinfo(struct path *pp, struct config *conf, int mask);
+
 int __wrap_pathinfo(struct path *pp, struct config *conf, int mask)
 {
 	int ret = mock_type(int);
+
 	assert_string_equal(pp->dev, mock_ptr_type(char *));
 	assert_int_equal(mask, DI_SYSFS | DI_WWID | DI_BLACKLIST);
-	if (ret == PATHINFO_OK) {
+	if (ret == PATHINFO_REAL) {
+		/* for test_filter_property() */
+		ret =  __real_pathinfo(pp, conf, mask);
+		return ret;
+	} else if (ret == PATHINFO_OK) {
 		pp->uid_attribute = "ID_TEST";
 		strlcpy(pp->wwid, mock_ptr_type(char *), WWID_SIZE);
 	} else
@@ -128,6 +187,7 @@ enum {
 	STAGE_IS_MULTIPATHED,
 	STAGE_CHECK_MULTIPATHD,
 	STAGE_GET_UDEV_DEVICE,
+	STAGE_PATHINFO_REAL,
 	STAGE_PATHINFO,
 	STAGE_FILTER_PROPERTY,
 	STAGE_IS_FAILED,
@@ -167,12 +227,25 @@ static void setup_passing(char *name, char *wwid, unsigned int check_multipathd,
 		    name);
 	if (stage == STAGE_GET_UDEV_DEVICE)
 		return;
+	if  (stage == STAGE_PATHINFO_REAL) {
+		/* special case for test_filter_property() */
+		will_return(__wrap_pathinfo, PATHINFO_REAL);
+		will_return(__wrap_pathinfo, name);
+		expect_string(__wrap_udev_device_get_sysattr_value,
+			      sysattr, "hidden");
+		will_return(__wrap_udev_device_get_sysattr_value, NULL);
+		will_return(__wrap_add_foreign, FOREIGN_IGNORED);
+		will_return(__wrap_filter_devnode, MATCH_NOTHING);
+		will_return(__wrap_udev_device_get_devnum, makedev(259, 0));
+		will_return(__wrap_sysfs_get_size, 0);
+		will_return(__wrap_select_getuid, "ID_TEST");
+		return;
+	}
 	will_return(__wrap_pathinfo, PATHINFO_OK);
 	will_return(__wrap_pathinfo, name);
 	will_return(__wrap_pathinfo, wwid);
 	if (stage == STAGE_PATHINFO)
 		return;
-	will_return(__wrap_filter_property, MATCH_PROPERTY_BLIST_EXCEPT);
 	if (stage == STAGE_FILTER_PROPERTY)
 		return;
 	will_return(__wrap_is_failed_wwid, WWID_IS_NOT_FAILED);
@@ -317,24 +390,24 @@ static void test_filter_property(void **state)
 	/* test blacklist property */
 	memset(&pp, 0, sizeof(pp));
 	conf.find_multipaths = FIND_MULTIPATHS_STRICT;
-	setup_passing(name, wwid, CHECK_MPATHD_SKIP, STAGE_PATHINFO);
+	setup_passing(name, wwid, CHECK_MPATHD_SKIP, STAGE_PATHINFO_REAL);
 	will_return(__wrap_filter_property, MATCH_PROPERTY_BLIST);
 	assert_int_equal(is_path_valid(name, &conf, &pp, false),
 			 PATH_IS_NOT_VALID);
 	assert_ptr_equal(pp.udev, &test_udev);
-	assert_string_equal(pp.wwid, wwid);
+
 	/* test missing property */
 	memset(&pp, 0, sizeof(pp));
-	setup_passing(name, wwid, CHECK_MPATHD_SKIP, STAGE_PATHINFO);
+	setup_passing(name, wwid, CHECK_MPATHD_SKIP, STAGE_PATHINFO_REAL);
 	will_return(__wrap_filter_property, MATCH_PROPERTY_BLIST_MISSING);
 	assert_int_equal(is_path_valid(name, &conf, &pp, false),
 			 PATH_IS_NOT_VALID);
-	/* test MATCH_NOTHING fail on is_failed_wwid */
+
+	/* test MATCH_NOTHING fail on filter_device */
 	memset(&pp, 0, sizeof(pp));
-	setup_passing(name, wwid, CHECK_MPATHD_SKIP, STAGE_PATHINFO);
+	setup_passing(name, wwid, CHECK_MPATHD_SKIP, STAGE_PATHINFO_REAL);
 	will_return(__wrap_filter_property, MATCH_NOTHING);
-	will_return(__wrap_is_failed_wwid, WWID_IS_FAILED);
-	will_return(__wrap_is_failed_wwid, wwid);
+	will_return(__wrap_filter_device, MATCH_DEVICE_BLIST);
 	assert_int_equal(is_path_valid(name, &conf, &pp, false),
 			 PATH_IS_NOT_VALID);
 }
-- 
2.29.2


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

