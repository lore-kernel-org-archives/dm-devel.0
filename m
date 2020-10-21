Return-Path: <SRS0=YCRG=D4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D108C56201
	for <dm-devel@archiver.kernel.org>; Wed, 21 Oct 2020 21:42:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4E5CF24178
	for <dm-devel@archiver.kernel.org>; Wed, 21 Oct 2020 21:42:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NBiS1Vbu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E5CF24178
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1603316522;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pzE7Pbz9R0GieuLg8kIpL9qO8JpgfDMZYDvDfAIufnM=;
	b=NBiS1VbuF4CqPk7vQ6dmKlLX4dl+32W9dgrMb44IbWrZWzoWXlzG+RkqfHmhaLfECdW+Ba
	QBU1WGf2+cv4scTOgokx8Gv7hdbmH9mDzBdo/1fhfYIHdw+NWDw2j26qIBdgIf34eU5i1u
	rnSDLrAgdYFsubQPqSbP5pn4lFlI3jA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-DDW_n2MXO1uqcB6ocdLJsA-1; Wed, 21 Oct 2020 17:41:59 -0400
X-MC-Unique: DDW_n2MXO1uqcB6ocdLJsA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1B878030C8;
	Wed, 21 Oct 2020 21:41:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 822405C225;
	Wed, 21 Oct 2020 21:41:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 559CE922E9;
	Wed, 21 Oct 2020 21:41:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09LLdXq0008770 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 21 Oct 2020 17:39:33 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5525E5C225; Wed, 21 Oct 2020 21:39:33 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 47F415C1C7;
	Wed, 21 Oct 2020 21:39:30 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 09LLdTDw028783; 
	Wed, 21 Oct 2020 16:39:29 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 09LLdSpS028782;
	Wed, 21 Oct 2020 16:39:28 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 21 Oct 2020 16:39:24 -0500
Message-Id: <1603316366-28735-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1603316366-28735-1-git-send-email-bmarzins@redhat.com>
References: <1603316366-28735-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v3 2/4] multipath-tools tests: and unit tests for
	libmpathvalid
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile.inc       |   1 +
 tests/Makefile     |   5 +-
 tests/mpathvalid.c | 467 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 472 insertions(+), 1 deletion(-)
 create mode 100644 tests/mpathvalid.c

diff --git a/Makefile.inc b/Makefile.inc
index e05f3a91..13587a9f 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -66,6 +66,7 @@ libdir		= $(prefix)/$(LIB)/multipath
 unitdir		= $(prefix)/$(SYSTEMDPATH)/systemd/system
 mpathpersistdir	= $(TOPDIR)/libmpathpersist
 mpathcmddir	= $(TOPDIR)/libmpathcmd
+mpathvaliddir	= $(TOPDIR)/libmpathvalid
 thirdpartydir	= $(TOPDIR)/third-party
 libdmmpdir	= $(TOPDIR)/libdmmp
 nvmedir		= $(TOPDIR)/libmultipath/nvme
diff --git a/tests/Makefile b/tests/Makefile
index 73ff0f5c..73ec0702 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -13,7 +13,7 @@ CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathcmddir) \
 LIBDEPS += -L. -L$(mpathcmddir) -lmultipath -lmpathcmd -lcmocka
 
 TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy \
-	 alias directio valid devt
+	 alias directio valid devt mpathvalid
 
 .SILENT: $(TESTS:%=%.o)
 .PRECIOUS: $(TESTS:%=%-test)
@@ -30,6 +30,7 @@ endif
 ifneq ($(DIO_TEST_DEV),)
 directio-test_FLAGS := -DDIO_TEST_DEV=\"$(DIO_TEST_DEV)\"
 endif
+mpathvalid-test_FLAGS := -I$(mpathvaliddir)
 
 # test-specific linker flags
 # XYZ-test_TESTDEPS: test libraries containing __wrap_xyz functions
@@ -55,6 +56,8 @@ alias-test_LIBDEPS := -lpthread -ldl
 valid-test_OBJDEPS := ../libmultipath/valid.o
 valid-test_LIBDEPS := -ludev -lpthread -ldl
 devt-test_LIBDEPS := -ludev
+mpathvalid-test_LIBDEPS := -ludev -lpthread -ldl
+mpathvalid-test_OBJDEPS := ../libmpathvalid/mpath_valid.o
 ifneq ($(DIO_TEST_DEV),)
 directio-test_LIBDEPS := -laio
 endif
diff --git a/tests/mpathvalid.c b/tests/mpathvalid.c
new file mode 100644
index 00000000..5ffabb9d
--- /dev/null
+++ b/tests/mpathvalid.c
@@ -0,0 +1,467 @@
+/*
+ * Copyright (c) 2020 Benjamin Marzinski, Red Hat
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+#include <stdbool.h>
+#include <stdarg.h>
+#include <stddef.h>
+#include <setjmp.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <libudev.h>
+#include <cmocka.h>
+#include "structs.h"
+#include "config.h"
+#include "mpath_valid.h"
+#include "util.h"
+#include "debug.h"
+
+const char *test_dev = "test_name";
+#define TEST_WWID "WWID_123"
+#define CONF_TEMPLATE "mpathvalid-testconf-XXXXXXXX"
+char conf_name[] = CONF_TEMPLATE;
+bool initialized;
+
+#if 0
+static int mode_to_findmp(unsigned int mode)
+{
+	switch (mode) {
+	case MPATH_SMART:
+		return FIND_MULTIPATHS_SMART;
+	case MPATH_GREEDY:
+		return FIND_MULTIPATHS_GREEDY;
+	case MPATH_STRICT:
+		return FIND_MULTIPATHS_STRICT;
+	}
+	fail_msg("invalid mode: %u", mode);
+	return FIND_MULTIPATHS_UNDEF;
+}
+#endif
+
+static unsigned int findmp_to_mode(int findmp)
+{
+	switch (findmp) {
+	case FIND_MULTIPATHS_SMART:
+		return MPATH_SMART;
+	case FIND_MULTIPATHS_GREEDY:
+		return MPATH_GREEDY;
+	case FIND_MULTIPATHS_STRICT:
+	case FIND_MULTIPATHS_OFF:
+	case FIND_MULTIPATHS_ON:
+		return MPATH_STRICT;
+	}
+	fail_msg("invalid find_multipaths value: %d", findmp);
+	return MPATH_DEFAULT;
+}
+
+int __wrap_is_path_valid(const char *name, struct config *conf, struct path *pp,
+			 bool check_multipathd)
+{
+	int r = mock_type(int);
+	int findmp = mock_type(int);
+
+	assert_ptr_equal(name, test_dev);
+	assert_ptr_not_equal(conf, NULL);
+	assert_ptr_not_equal(pp, NULL);
+	assert_true(check_multipathd);
+
+	assert_int_equal(findmp, conf->find_multipaths);	
+	if (r == MPATH_IS_ERROR || r == MPATH_IS_NOT_VALID)
+		return r;
+	
+	strlcpy(pp->wwid, mock_ptr_type(char *), WWID_SIZE);
+	return r;
+}
+
+int __wrap_libmultipath_init(void)
+{
+	int r = mock_type(int);
+
+	assert_false(initialized);
+	if (r != 0)
+		return r;
+	initialized = true;
+	return 0;
+}
+
+void __wrap_libmultipath_exit(void)
+{
+	assert_true(initialized);
+	initialized = false;
+}
+
+int __wrap_dm_prereq(unsigned int *v)
+{
+	assert_ptr_not_equal(v, NULL);
+	return mock_type(int);
+}
+
+int __real_init_config(const char *file);
+
+int __wrap_init_config(const char *file)
+{
+	int r = mock_type(int);
+	struct config *conf;
+
+	assert_ptr_equal(file, DEFAULT_CONFIGFILE);
+	if (r != 0)
+		return r;
+
+	assert_string_not_equal(conf_name, CONF_TEMPLATE);
+	r = __real_init_config(conf_name);
+	conf = get_multipath_config();
+	assert_ptr_not_equal(conf, NULL);
+	assert_int_equal(conf->find_multipaths, mock_type(int));
+	return 0;
+}
+
+static const char * const find_multipaths_optvals[] = {
+        [FIND_MULTIPATHS_OFF] = "off",
+        [FIND_MULTIPATHS_ON] = "on",
+        [FIND_MULTIPATHS_STRICT] = "strict",
+        [FIND_MULTIPATHS_GREEDY] = "greedy",
+        [FIND_MULTIPATHS_SMART] = "smart",
+};
+
+void make_config_file(int findmp)
+{
+	int r, fd;
+	char buf[64];
+
+	assert_true(findmp > FIND_MULTIPATHS_UNDEF &&
+		    findmp < __FIND_MULTIPATHS_LAST);
+
+	r = snprintf(buf, sizeof(buf), "defaults {\nfind_multipaths %s\n}\n",
+		     find_multipaths_optvals[findmp]);
+	assert_true(r > 0 && (long unsigned int)r < sizeof(buf));
+
+	memcpy(conf_name, CONF_TEMPLATE, sizeof(conf_name));
+	fd = mkstemp(conf_name);
+	assert_true(fd >= 0);
+	assert_int_equal(safe_write(fd, buf, r), 0);
+	assert_int_equal(close(fd), 0);
+}
+
+int setup(void **state)
+{
+	initialized = false;
+	udev = udev_new();
+	if (udev == NULL)
+		return -1;
+	return 0;
+}
+
+int teardown(void **state)
+{
+	struct config *conf;
+	conf = get_multipath_config();
+	put_multipath_config(conf);
+	if (conf)
+		uninit_config();
+	if (strcmp(conf_name, CONF_TEMPLATE) != 0)
+		unlink(conf_name);
+	udev_unref(udev);
+	udev = NULL;
+	return 0;
+}
+
+static void check_config(bool valid_config)
+{
+	struct config *conf;
+
+	conf = get_multipath_config();
+	put_multipath_config(conf);
+	if (valid_config)
+		assert_ptr_not_equal(conf, NULL);
+}
+
+/* libmultipath_init fails */
+static void test_mpathvalid_init_bad1(void **state)
+{
+	will_return(__wrap_libmultipath_init, 1);
+	assert_int_equal(mpathvalid_init(MPATH_LOG_PRIO_DEBUG,
+					 MPATH_LOG_STDERR), -1);
+	assert_false(initialized);
+	check_config(false);
+}
+
+/* init_config fails */
+static void test_mpathvalid_init_bad2(void **state)
+{
+	will_return(__wrap_libmultipath_init, 0);
+	will_return(__wrap_init_config, 1);
+	assert_int_equal(mpathvalid_init(MPATH_LOG_PRIO_ERR,
+					 MPATH_LOG_STDERR_TIMESTAMP), -1);
+	assert_false(initialized);
+	check_config(false);
+}
+
+/* dm_prereq fails */
+static void test_mpathvalid_init_bad3(void **state)
+{
+	make_config_file(FIND_MULTIPATHS_STRICT);
+	will_return(__wrap_libmultipath_init, 0);
+	will_return(__wrap_init_config, 0);
+	will_return(__wrap_init_config, FIND_MULTIPATHS_STRICT);
+	will_return(__wrap_dm_prereq, 1);
+	assert_int_equal(mpathvalid_init(MPATH_LOG_STDERR, MPATH_LOG_PRIO_ERR),
+			 -1);
+	assert_false(initialized);
+	check_config(false);
+}
+
+static void check_mpathvalid_init(int findmp, int prio, int log_style)
+{
+	make_config_file(findmp);
+	will_return(__wrap_libmultipath_init, 0);
+	will_return(__wrap_init_config, 0);
+	will_return(__wrap_init_config, findmp);
+	will_return(__wrap_dm_prereq, 0);
+	assert_int_equal(mpathvalid_init(prio, log_style), 0);	
+	assert_true(initialized);
+	check_config(true);
+	assert_int_equal(logsink, log_style);
+	assert_int_equal(libmp_verbosity, prio);
+	assert_int_equal(findmp_to_mode(findmp), mpathvalid_get_mode());
+}
+
+static void check_mpathvalid_exit(void)
+{
+	assert_int_equal(mpathvalid_exit(), 0);
+	assert_false(initialized);
+	check_config(false);
+}
+
+static void test_mpathvalid_init_good1(void **state)
+{
+	check_mpathvalid_init(FIND_MULTIPATHS_OFF, MPATH_LOG_PRIO_ERR,
+			      MPATH_LOG_STDERR_TIMESTAMP);
+}
+
+static void test_mpathvalid_init_good2(void **state)
+{
+	check_mpathvalid_init(FIND_MULTIPATHS_STRICT, MPATH_LOG_PRIO_DEBUG,
+			      MPATH_LOG_STDERR);
+}
+
+static void test_mpathvalid_init_good3(void **state)
+{
+	check_mpathvalid_init(FIND_MULTIPATHS_ON, MPATH_LOG_PRIO_NOLOG,
+			      MPATH_LOG_SYSLOG);
+}
+
+static void test_mpathvalid_exit(void **state)
+{
+	check_mpathvalid_init(FIND_MULTIPATHS_ON, MPATH_LOG_PRIO_ERR,
+			      MPATH_LOG_STDERR);
+	check_mpathvalid_exit();
+}
+
+/* fails if config hasn't been set */
+static void test_mpathvalid_get_mode_bad(void **state)
+{
+#if 1
+	assert_int_equal(mpathvalid_get_mode(), MPATH_MODE_ERROR);
+#else
+	assert_int_equal(mpathvalid_get_mode(), 1);
+#endif
+}
+
+/*fails if config hasn't been set */
+static void test_mpathvalid_reload_config_bad1(void **state)
+{
+#if 1
+	will_return(__wrap_init_config, 1);
+#endif
+	assert_int_equal(mpathvalid_reload_config(), -1);
+	check_config(false);
+}
+
+/* init_config fails */
+static void test_mpathvalid_reload_config_bad2(void **state)
+{
+	check_mpathvalid_init(FIND_MULTIPATHS_ON, MPATH_LOG_PRIO_ERR,
+			      MPATH_LOG_STDERR);
+	will_return(__wrap_init_config, 1);
+	assert_int_equal(mpathvalid_reload_config(), -1);
+	check_config(false);
+	check_mpathvalid_exit();
+}
+
+static void check_mpathvalid_reload_config(int findmp)
+{
+	assert_string_not_equal(conf_name, CONF_TEMPLATE);
+	unlink(conf_name);
+	make_config_file(findmp);
+	will_return(__wrap_init_config, 0);
+	will_return(__wrap_init_config, findmp);
+	assert_int_equal(mpathvalid_reload_config(), 0);
+	check_config(true);
+	assert_int_equal(findmp_to_mode(findmp), mpathvalid_get_mode());
+}
+
+static void test_mpathvalid_reload_config_good(void **state)
+{
+	check_mpathvalid_init(FIND_MULTIPATHS_OFF, MPATH_LOG_PRIO_ERR,
+			      MPATH_LOG_STDERR);
+	check_mpathvalid_reload_config(FIND_MULTIPATHS_ON);
+	check_mpathvalid_reload_config(FIND_MULTIPATHS_GREEDY);
+	check_mpathvalid_reload_config(FIND_MULTIPATHS_SMART);
+	check_mpathvalid_reload_config(FIND_MULTIPATHS_STRICT);
+	check_mpathvalid_exit();
+}
+
+/* NULL name */
+static void test_mpathvalid_is_path_bad1(void **state)
+{
+	assert_int_equal(mpathvalid_is_path(NULL, MPATH_STRICT, NULL, NULL, 0),
+			 MPATH_IS_ERROR);
+}
+
+/* bad mode */
+static void test_mpathvalid_is_path_bad2(void **state)
+{
+	assert_int_equal(mpathvalid_is_path(test_dev, MPATH_MODE_ERROR, NULL,
+					    NULL, 0), MPATH_IS_ERROR);
+}
+
+/* NULL path_wwids and non-zero nr_paths */
+static void test_mpathvalid_is_path_bad3(void **state)
+{
+	assert_int_equal(mpathvalid_is_path(test_dev, MPATH_MODE_ERROR, NULL,
+			 		    NULL, 1), MPATH_IS_ERROR);
+}
+
+/*fails if config hasn't been set */
+static void test_mpathvalid_is_path_bad4(void **state)
+{
+#if 0
+	will_return(__wrap_is_path_valid, MPATH_IS_ERROR);
+	will_return(__wrap_is_path_valid, FIND_MULTIPATHS_STRICT);
+#endif
+	assert_int_equal(mpathvalid_is_path(test_dev, MPATH_STRICT, NULL,
+					    NULL, 0), MPATH_IS_ERROR);
+}
+
+/* is_path_valid fails */
+static void test_mpathvalid_is_path_bad5(void **state)
+{
+	check_mpathvalid_init(FIND_MULTIPATHS_OFF, MPATH_LOG_PRIO_ERR,
+			      MPATH_LOG_STDERR);
+	will_return(__wrap_is_path_valid, MPATH_IS_ERROR);
+	will_return(__wrap_is_path_valid, FIND_MULTIPATHS_GREEDY);
+	assert_int_equal(mpathvalid_is_path(test_dev, MPATH_GREEDY, NULL,
+					    NULL, 0), MPATH_IS_ERROR);
+	check_mpathvalid_exit();
+}
+
+static void test_mpathvalid_is_path_good1(void **state)
+{
+	char *wwid;
+	check_mpathvalid_init(FIND_MULTIPATHS_STRICT, MPATH_LOG_PRIO_ERR,
+			      MPATH_LOG_STDERR);
+	will_return(__wrap_is_path_valid, MPATH_IS_NOT_VALID);
+	will_return(__wrap_is_path_valid, FIND_MULTIPATHS_STRICT);
+	assert_int_equal(mpathvalid_is_path(test_dev, MPATH_DEFAULT, &wwid,
+			 		    NULL, 0), MPATH_IS_NOT_VALID);
+	assert_ptr_equal(wwid, NULL);
+	check_mpathvalid_exit();
+}
+
+static void test_mpathvalid_is_path_good2(void **state)
+{
+	const char *wwids[] = { "WWID_A", "WWID_B", "WWID_C", "WWID_D" };
+	char *wwid;
+	check_mpathvalid_init(FIND_MULTIPATHS_ON, MPATH_LOG_PRIO_ERR,
+			      MPATH_LOG_STDERR);
+	will_return(__wrap_is_path_valid, MPATH_IS_VALID);
+	will_return(__wrap_is_path_valid, FIND_MULTIPATHS_ON);
+	will_return(__wrap_is_path_valid, TEST_WWID);
+	assert_int_equal(mpathvalid_is_path(test_dev, MPATH_DEFAULT, &wwid,
+					    wwids, 4), MPATH_IS_VALID);
+	assert_string_equal(wwid, TEST_WWID);
+}
+
+static void test_mpathvalid_is_path_good3(void **state)
+{
+	const char *wwids[] = { "WWID_A", "WWID_B", "WWID_C", "WWID_D" };
+	char *wwid;
+	check_mpathvalid_init(FIND_MULTIPATHS_OFF, MPATH_LOG_PRIO_ERR,
+			      MPATH_LOG_STDERR);
+	will_return(__wrap_is_path_valid, MPATH_IS_VALID);
+	will_return(__wrap_is_path_valid, FIND_MULTIPATHS_SMART);
+	will_return(__wrap_is_path_valid, TEST_WWID);
+	assert_int_equal(mpathvalid_is_path(test_dev, MPATH_SMART, &wwid,
+					    wwids, 4), MPATH_IS_VALID);
+	assert_string_equal(wwid, TEST_WWID);
+}
+
+/* mabybe valid with no matching paths */
+static void test_mpathvalid_is_path_good4(void **state)
+{
+	const char *wwids[] = { "WWID_A", "WWID_B", "WWID_C", "WWID_D" };
+	char *wwid;
+	check_mpathvalid_init(FIND_MULTIPATHS_SMART, MPATH_LOG_PRIO_ERR,
+			      MPATH_LOG_STDERR);
+	will_return(__wrap_is_path_valid, MPATH_IS_MAYBE_VALID);
+	will_return(__wrap_is_path_valid, FIND_MULTIPATHS_SMART);
+	will_return(__wrap_is_path_valid, TEST_WWID);
+	assert_int_equal(mpathvalid_is_path(test_dev, MPATH_DEFAULT, &wwid,
+					    wwids, 4), MPATH_IS_MAYBE_VALID);
+	assert_string_equal(wwid, TEST_WWID);
+}
+
+/* maybe valid with matching paths */
+static void test_mpathvalid_is_path_good5(void **state)
+{
+	const char *wwids[] = { "WWID_A", "WWID_B", TEST_WWID, "WWID_D" };
+	char *wwid;
+	check_mpathvalid_init(FIND_MULTIPATHS_SMART, MPATH_LOG_PRIO_ERR,
+			      MPATH_LOG_STDERR);
+	will_return(__wrap_is_path_valid, MPATH_IS_MAYBE_VALID);
+	will_return(__wrap_is_path_valid, FIND_MULTIPATHS_SMART);
+	will_return(__wrap_is_path_valid, TEST_WWID);
+	assert_int_equal(mpathvalid_is_path(test_dev, MPATH_DEFAULT, &wwid,
+					    wwids, 4), MPATH_IS_VALID);
+	assert_string_equal(wwid, TEST_WWID);
+}
+
+#define setup_test(name) \
+	cmocka_unit_test_setup_teardown(name, setup, teardown)
+
+int test_mpathvalid(void)
+{
+	const struct CMUnitTest tests[] = {
+		setup_test(test_mpathvalid_init_bad1),
+		setup_test(test_mpathvalid_init_bad2),
+		setup_test(test_mpathvalid_init_bad3),
+		setup_test(test_mpathvalid_init_good1),
+		setup_test(test_mpathvalid_init_good2),
+		setup_test(test_mpathvalid_init_good3),
+		setup_test(test_mpathvalid_exit),
+		setup_test(test_mpathvalid_get_mode_bad),
+		setup_test(test_mpathvalid_reload_config_bad1),
+		setup_test(test_mpathvalid_reload_config_bad2),
+		setup_test(test_mpathvalid_reload_config_good),
+		setup_test(test_mpathvalid_is_path_bad1),
+		setup_test(test_mpathvalid_is_path_bad2),
+		setup_test(test_mpathvalid_is_path_bad3),
+		setup_test(test_mpathvalid_is_path_bad4),
+		setup_test(test_mpathvalid_is_path_bad5),
+		setup_test(test_mpathvalid_is_path_good1),
+		setup_test(test_mpathvalid_is_path_good2),
+		setup_test(test_mpathvalid_is_path_good3),
+		setup_test(test_mpathvalid_is_path_good4),
+		setup_test(test_mpathvalid_is_path_good5),
+	};
+	return cmocka_run_group_tests(tests, NULL, NULL);
+}
+
+int main(void)
+{
+	int r = 0;
+
+	r += test_mpathvalid();
+	return r;
+}
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

