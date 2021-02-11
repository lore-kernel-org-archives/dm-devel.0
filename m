Return-Path: <SRS0=OsX1=HN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0546EC433E0
	for <dm-devel@archiver.kernel.org>; Thu, 11 Feb 2021 23:47:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8531364E45
	for <dm-devel@archiver.kernel.org>; Thu, 11 Feb 2021 23:47:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8531364E45
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-Cb6tCmCXMz21HwjzupEUtg-1; Thu, 11 Feb 2021 18:47:11 -0500
X-MC-Unique: Cb6tCmCXMz21HwjzupEUtg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B526E1005501;
	Thu, 11 Feb 2021 23:47:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E2A35D9C2;
	Thu, 11 Feb 2021 23:47:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B302E4E58E;
	Thu, 11 Feb 2021 23:47:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11BNl39c010505 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Feb 2021 18:47:04 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C60CB103424; Thu, 11 Feb 2021 23:47:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BF945103427
	for <dm-devel@redhat.com>; Thu, 11 Feb 2021 23:47:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 832F2185A793
	for <dm-devel@redhat.com>; Thu, 11 Feb 2021 23:47:01 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-393-leZVGmu0PFGksicyn3GTCQ-1;
	Thu, 11 Feb 2021 18:46:58 -0500
X-MC-Unique: leZVGmu0PFGksicyn3GTCQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 1B8E1AE85;
	Thu, 11 Feb 2021 23:46:57 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 12 Feb 2021 00:46:47 +0100
Message-Id: <20210211234650.21890-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 11BNl39c010505
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 1/4] multipath-tools tests: allow control of test
	verbosity
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Use common code to control verbosity during unit tests runs.
The environment variable MPATHTEST_VERBOSITY is honored by most
tests, except those that need to parse the log messages or have
other special needs.

Also, get rid of the now obsolete global variables logsink and
udev, as these are now defined in libmultipath.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/README.md   |  5 +++++
 tests/alias.c     |  2 +-
 tests/blacklist.c |  2 +-
 tests/devt.c      |  1 +
 tests/directio.c  |  2 +-
 tests/dmevents.c  |  1 +
 tests/globals.c   | 27 +++++++++++++++++++++------
 tests/hwtable.c   |  2 ++
 tests/parser.c    |  1 +
 tests/pgpolicy.c  |  1 +
 tests/uevent.c    |  1 +
 tests/unaligned.c |  1 +
 tests/util.c      |  1 +
 tests/valid.c     |  2 ++
 tests/vpd.c       |  1 +
 15 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/tests/README.md b/tests/README.md
index 6e7ad40..47c0f0b 100644
--- a/tests/README.md
+++ b/tests/README.md
@@ -13,6 +13,11 @@ If valgrind detects a bad memory access or leak, the test will fail. The
 output of the test run, including valgrind output, is stored as
 `<testname>.vgr`.
 
+## Controlling verbosity for unit tests
+
+Some test programs use the environment variable `MPATHTEST_VERBOSITY` to
+control the log level during test execution.
+
 ## Notes on individual tests
 
 ### Tests that require root permissions
diff --git a/tests/alias.c b/tests/alias.c
index 5e0bfea..b363718 100644
--- a/tests/alias.c
+++ b/tests/alias.c
@@ -736,7 +736,7 @@ static int test_allocate_binding(void)
 int main(void)
 {
 	int ret = 0;
-	libmp_verbosity = conf.verbosity;
+	init_test_verbosity(3);
 
 	ret += test_format_devname();
 	ret += test_scan_devname();
diff --git a/tests/blacklist.c b/tests/blacklist.c
index 0b42e25..882aa3a 100644
--- a/tests/blacklist.c
+++ b/tests/blacklist.c
@@ -153,7 +153,7 @@ static int setup(void **state)
 	    store_ble(blist_property_wwn_inv, "!ID_WWN", ORIGIN_CONFIG))
 		return -1;
 
-	libmp_verbosity = conf.verbosity = 4;
+	init_test_verbosity(4);
 	return 0;
 }
 
diff --git a/tests/devt.c b/tests/devt.c
index fd4d74a..2b72851 100644
--- a/tests/devt.c
+++ b/tests/devt.c
@@ -187,6 +187,7 @@ int main(void)
 {
 	int ret = 0;
 
+	init_test_verbosity(-1);
 	ret += devt2devname_tests();
 	return ret;
 }
diff --git a/tests/directio.c b/tests/directio.c
index 9895409..9f7d388 100644
--- a/tests/directio.c
+++ b/tests/directio.c
@@ -770,7 +770,7 @@ int main(void)
 {
 	int ret = 0;
 
-	conf.verbosity = 2;
+	init_test_verbosity(2);
 	ret += test_directio();
 	return ret;
 }
diff --git a/tests/dmevents.c b/tests/dmevents.c
index 29eaa6d..204cf1d 100644
--- a/tests/dmevents.c
+++ b/tests/dmevents.c
@@ -925,6 +925,7 @@ int main(void)
 {
 	int ret = 0;
 
+	init_test_verbosity(-1);
 	ret += test_dmevents();
 	return ret;
 }
diff --git a/tests/globals.c b/tests/globals.c
index fc0c07a..36319ed 100644
--- a/tests/globals.c
+++ b/tests/globals.c
@@ -1,13 +1,12 @@
+#include <stdlib.h>
+#include <string.h>
+
+#include "defaults.h"
 #include "structs.h"
 #include "config.h"
 #include "debug.h"
 
-/* Required globals */
-struct udev *udev;
-int logsink = LOGSINK_STDERR_WITHOUT_TIME;
-struct config conf = {
-	.verbosity = 4,
-};
+struct config conf;
 
 struct config *get_multipath_config(void)
 {
@@ -16,3 +15,19 @@ struct config *get_multipath_config(void)
 
 void put_multipath_config(void *arg)
 {}
+
+static __attribute__((unused)) void init_test_verbosity(int test_verbosity)
+{
+	char *verb = getenv("MPATHTEST_VERBOSITY");
+
+	libmp_verbosity = test_verbosity >= 0 ? test_verbosity :
+		DEFAULT_VERBOSITY;
+	if (verb && *verb) {
+		char *c;
+		int vb;
+
+		vb = strtoul(verb, &c, 10);
+		if (!*c && vb >= 0 && vb <= 5)
+			libmp_verbosity = vb;
+	}
+}
diff --git a/tests/hwtable.c b/tests/hwtable.c
index 4dd0873..6f5766f 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -1778,6 +1778,8 @@ int main(void)
 {
 	int ret = 0;
 
+	/* We can't use init_test_verbosity in this test */
+	libmp_verbosity = VERBOSITY;
 	ret += test_hwtable();
 	return ret;
 }
diff --git a/tests/parser.c b/tests/parser.c
index 5772391..cf96d81 100644
--- a/tests/parser.c
+++ b/tests/parser.c
@@ -511,6 +511,7 @@ int main(void)
 {
 	int ret = 0;
 
+	init_test_verbosity(-1);
 	ret += test_config_parser();
 	return ret;
 }
diff --git a/tests/pgpolicy.c b/tests/pgpolicy.c
index 3f61b12..57ad338 100644
--- a/tests/pgpolicy.c
+++ b/tests/pgpolicy.c
@@ -1031,6 +1031,7 @@ int main(void)
 {
 	int ret = 0;
 
+	init_test_verbosity(-1);
 	ret += test_pgpolicies();
 	return ret;
 }
diff --git a/tests/uevent.c b/tests/uevent.c
index 9ffcd2d..648ff26 100644
--- a/tests/uevent.c
+++ b/tests/uevent.c
@@ -322,6 +322,7 @@ int main(void)
 {
 	int ret = 0;
 
+	init_test_verbosity(-1);
 	ret += test_uevent_get_XXX();
 	return ret;
 }
diff --git a/tests/unaligned.c b/tests/unaligned.c
index 7ece1de..e43b64d 100644
--- a/tests/unaligned.c
+++ b/tests/unaligned.c
@@ -91,6 +91,7 @@ int main(void)
 {
 	int ret = 0;
 
+	init_test_verbosity(-1);
 	ret += test_unaligned();
 	return ret;
 }
diff --git a/tests/util.c b/tests/util.c
index c3c49b6..9affb0e 100644
--- a/tests/util.c
+++ b/tests/util.c
@@ -946,6 +946,7 @@ int main(void)
 {
 	int ret = 0;
 
+	init_test_verbosity(-1);
 	ret += test_basenamecpy();
 	ret += test_bitmasks();
 	ret += test_strlcpy();
diff --git a/tests/valid.c b/tests/valid.c
index 8ec803e..e7393a1 100644
--- a/tests/valid.c
+++ b/tests/valid.c
@@ -554,6 +554,8 @@ int test_valid(void)
 int main(void)
 {
 	int ret = 0;
+
+	init_test_verbosity(-1);
 	ret += test_valid();
 	return ret;
 }
diff --git a/tests/vpd.c b/tests/vpd.c
index e2ec65e..8e730d3 100644
--- a/tests/vpd.c
+++ b/tests/vpd.c
@@ -799,6 +799,7 @@ int main(void)
 {
 	int ret = 0;
 
+	init_test_verbosity(-1);
 	ret += test_vpd();
 	return ret;
 }
-- 
2.29.2


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

