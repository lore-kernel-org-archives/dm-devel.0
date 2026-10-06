Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C9737F739
	for <dm-devel@lists.linux.dev>; Tue,  6 Oct 2026 20:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791319554; cv=none; b=G3/aO9Kxp3tkJx9O/7ZV3j36fzS1G0+WKm0uj7DYRSxWnTSB2srXS4leeS+oc6qeaVIAibPmSvNY3EWsMXQf85UENq1Gbji7KJjqDE9ev5sQTmjSK8A0paLQ/KH/sUpRftvEnv9+wGQhn9Iaiu9t7hLEOBgLb4o0Z7f3WylQpBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791319554; c=relaxed/simple;
	bh=nE+91tv1U8ylNmUZDWyjgL1CeLXf76OZonqCdDwECIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j/YAVAuCNCYaPTqZTshvjuB1vAgoxKUjSjNqdRFSGm9OYtPsugQjcBFrlutyba92O5KA4Im8cAxwAWuh3U+/OxtKmdH9jDu/P3s8U/gzb8wERdoGu6tl0pTvlQA1iw/YbGW3or+bBoOA7RPw+U6O8ZcFoGPDp/a/wC1iT/BCm8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1p/oKRpN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xcrWLbF0; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zDZESwqZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bnWzy20f; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1p/oKRpN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xcrWLbF0";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zDZESwqZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bnWzy20f"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A0A651F7BC;
	Tue,  6 Oct 2026 20:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791319545; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9+9/3kP4TaYa1+ApscslK70DVnvtObUssgGBXmP+6f4=;
	b=1p/oKRpNRsvCaz1MSFCwtRKS/YUgmTEAHdrU2wOXTpsTsufg++ov18VjV0s9teuVKEzqlG
	NLcx4qFOQwRh3a+x59m7gzcS5vtDm7IkAcyx+kt4hsrPt14YU8j8OHKhale2+TOibTct1K
	YPrtTHzX9uH/b7mS60eejxa9ov/DqxM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791319545;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9+9/3kP4TaYa1+ApscslK70DVnvtObUssgGBXmP+6f4=;
	b=xcrWLbF0qBACuarSd0SKOH6xnhVuIAhbdj8ynPE4wrjqHv65sHKrXHlTOpAOnj0XbXz44C
	IK8uoGmqnlnlcoCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zDZESwqZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bnWzy20f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791319541; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9+9/3kP4TaYa1+ApscslK70DVnvtObUssgGBXmP+6f4=;
	b=zDZESwqZYJFLww945ZQFhqZm8TRw7eZ4rwYzJVQnqXiF8NXfrXYnAvkbfNV36epZgHnMwU
	0sfyzQh4mOo9Cw2/SG6MWAIN+evmTm2v+hhjk9SL+dDxVBZd+nSAt++8ogAQZpvEK90KOH
	kxw/tZnwjFFteeXN/ONDURZQqF6kRLM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791319541;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9+9/3kP4TaYa1+ApscslK70DVnvtObUssgGBXmP+6f4=;
	b=bnWzy20f40rQjsbzt1hQlU94JkSPbB98rxdnTnpMTIe1PZ/9e0Z7sVhFKbUuVSKJNE6Bgw
	vRNvamRnyrYbryAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2DF2B13B8A;
	Tue,  6 Oct 2026 20:45:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id h2fNHvRdxWqCPAAAD6G6ig:T4
	(envelope-from <mwilck@suse.de>); Tue, 06 Oct 2026 20:45:41 +0000
From: mwilck@suse.de
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 3/3] multipath-tools tests: add test for WWID unmangling
Date: Tue,  6 Oct 2026 22:45:23 +0200
Message-ID: <20261006204530.993731-4-mwilck@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006204530.993731-1-mwilck@suse.de>
References: <20261006204530.993731-1-mwilck@suse.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: A0A651F7BC
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_NO_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -3.51
X-Spam-Level: 

From: Martin Wilck <mwilck@suse.com>

Add tests for the logic of the code added in the previous commit.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 tests/Makefile        |   5 +-
 tests/cmocka-compat.h |   1 +
 tests/wwid-unmangle.c | 375 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 379 insertions(+), 2 deletions(-)
 create mode 100644 tests/wwid-unmangle.c

diff --git a/tests/Makefile b/tests/Makefile
index 23f7d2b..5c7b276 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -10,7 +10,7 @@ LIBDEPS += -L. -L $(mpathutildir) -L$(mpathcmddir) -lmultipath -lmpathutil -lmpa
 
 TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy \
 	 alias directio valid devt mpathvalid strbuf sysfs features cli mapinfo runner \
-	 shared_ptr $(if $(MEMFD_SUPPORT),gpt)
+	 shared_ptr $(if $(MEMFD_SUPPORT),gpt) wwid-unmangle
 HELPERS := test-lib.o test-log.o
 
 .PRECIOUS: $(TESTS:%=%-test)
@@ -71,7 +71,8 @@ mapinfo-test_LIBDEPS = -lpthread -ldevmapper
 runner-test_LIBDEPS = -lpthread
 shared_ptr-test_LIBDEPS = -lpthread
 gpt-test_OBJDEPS := $(kpartxdir)/gpt.o $(kpartxdir)/crc32.o
-
+wwid-unmangle-test_OBJDEPS := $(multipathdir)/discovery.o
+wwid-unmangle-test_LIBDEPS := -lpthread
 
 %.o: %.c
 	@echo building $@ because of $?
diff --git a/tests/cmocka-compat.h b/tests/cmocka-compat.h
index 8ec6ed2..58d73ce 100644
--- a/tests/cmocka-compat.h
+++ b/tests/cmocka-compat.h
@@ -13,4 +13,5 @@
 #define expect_int_value(f, x, y) expect_value(f, x, y)
 #define expect_uint_value(f, x, y) expect_value(f, x, y)
 #define assert_int_in_set(x, vals, count) assert_in_set(x, vals, count)
+#define will_return_int(f, x) will_return(f, x)
 #endif
diff --git a/tests/wwid-unmangle.c b/tests/wwid-unmangle.c
new file mode 100644
index 0000000..5188706
--- /dev/null
+++ b/tests/wwid-unmangle.c
@@ -0,0 +1,375 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2018 SUSE Linux GmbH
+ */
+
+#include <stdbool.h>
+#include <stdarg.h>
+#include <stddef.h>
+#include <setjmp.h>
+#include <stdlib.h>
+#include "cmocka-compat.h"
+#include "structs.h"
+#include "discovery.h"
+#include "util.h"
+
+#include "globals.c"
+
+// #include "globals.c"
+static char wwid_buf[WWID_SIZE];
+
+int __wrap_check_wwids_file(const char *wwid, int write)
+{
+	return mock_type(int);
+}
+
+static void test_wwid_null(void **state)
+{
+	size_t res = maybe_unmangle_wwid(wwid_buf, NULL);
+
+	assert_int_equal(res, 0);
+	assert_string_equal(wwid_buf, "");
+}
+
+static void test_wwid_zero(void **state)
+{
+	size_t res = maybe_unmangle_wwid(wwid_buf, "");
+
+	assert_int_equal(res, 0);
+	assert_string_equal(wwid_buf, "");
+}
+
+/* contains no mangled chars */
+static void test_wwid_no_unmangle_01(void **state)
+{
+	const char *const wwid = "simple";
+	size_t res = maybe_unmangle_wwid(wwid_buf, wwid);
+
+	assert_int_equal(res, strlen(wwid));
+	assert_string_equal(wwid_buf, wwid);
+}
+
+/* contains invalid character, not unmangled */
+static void test_wwid_no_unmangle_02(void **state)
+{
+	const char *const wwid = "simple wwid";
+	size_t res = maybe_unmangle_wwid(wwid_buf, wwid);
+
+	assert_int_equal(res, strlen(wwid));
+	assert_string_equal(wwid_buf, wwid);
+}
+
+/* contains unicode character, not unmangled */
+static void test_wwid_no_unmangle_03(void **state)
+{
+	const char *const wwid = "utf8→wwid";
+	size_t res = maybe_unmangle_wwid(wwid_buf, wwid);
+
+	assert_int_equal(res, strlen(wwid));
+	assert_string_equal(wwid_buf, wwid);
+}
+
+/* contains invalid character, not unmangled */
+static void test_wwid_no_unmangle_04(void **state)
+{
+	const char *const wwid = "simple;wwid";
+	size_t res = maybe_unmangle_wwid(wwid_buf, wwid);
+
+	assert_int_equal(res, strlen(wwid));
+	assert_string_equal(wwid_buf, wwid);
+}
+
+/* contains invalid character, not unmangled */
+static void test_wwid_no_unmangle_05(void **state)
+{
+	const char *const wwid = "simple\\wwid";
+	size_t res = maybe_unmangle_wwid(wwid_buf, wwid);
+
+	assert_int_equal(res, strlen(wwid));
+	assert_string_equal(wwid_buf, wwid);
+}
+
+/* contains unicode character, not unmangled */
+static void test_wwid_no_unmangle_06(void **state)
+{
+	const char *const wwid = "utf8→wwid\x20space";
+	size_t res = maybe_unmangle_wwid(wwid_buf, wwid);
+
+	assert_int_equal(res, strlen(wwid));
+	assert_string_equal(wwid_buf, wwid);
+}
+
+/* contains invalid character, not unmangled */
+static void test_wwid_no_unmangle_07(void **state)
+{
+	const char *const wwid = "invalid\\x20;wwid";
+	size_t res = maybe_unmangle_wwid(wwid_buf, wwid);
+
+	assert_int_equal(res, strlen(wwid));
+	assert_string_equal(wwid_buf, wwid);
+}
+
+/* contains invalid character, not unmangled */
+static void test_wwid_no_unmangle_08(void **state)
+{
+	const char *const wwid = "invalid,wwid\x20space";
+	size_t res = maybe_unmangle_wwid(wwid_buf, wwid);
+
+	assert_int_equal(res, strlen(wwid));
+	assert_string_equal(wwid_buf, wwid);
+}
+
+/* contains unicode character, not unmangled */
+static void test_wwid_no_unmangle_09(void **state)
+{
+	const char *const wwid = "utf8\\x20→wwid";
+	size_t res = maybe_unmangle_wwid(wwid_buf, wwid);
+
+	assert_int_equal(res, strlen(wwid));
+	assert_string_equal(wwid_buf, wwid);
+}
+
+/* contains invalid mangled char */
+static void test_wwid_no_unmangle_10(void **state)
+{
+	const char *const wwid = "invalid\\x1wwid";
+	size_t res = maybe_unmangle_wwid(wwid_buf, wwid);
+
+	assert_int_equal(res, strlen(wwid));
+	assert_string_equal(wwid_buf, wwid);
+}
+
+/* test that WWID_SIZE doesn't overflow */
+static void test_wwid_overlong_01(void **state)
+{
+	char wwid[WWID_SIZE + 2];
+	size_t res;
+	memset(wwid, 'A', sizeof(wwid) - 1);
+
+	wwid[sizeof(wwid) - 1] = '\0';
+	res = maybe_unmangle_wwid(wwid_buf, wwid);
+	assert_int_equal(res, strlen(wwid));
+	wwid[WWID_SIZE - 1] = '\0';
+	assert_string_equal(wwid_buf, wwid);
+}
+
+/* mangle sequence at the end, fits after mangling */
+static void test_wwid_overlong_02(void **state)
+{
+	char wwid[WWID_SIZE];
+	size_t res;
+	memset(wwid, 'A', sizeof(wwid) - 1);
+
+	wwid[sizeof(wwid) - 1] = '\0';
+	strlcpy(wwid + sizeof(wwid) - 5, "\\x20", 5);
+	memcpy(wwid, "\\x20", 4);
+
+	will_return_int(__wrap_check_wwids_file, 0);
+	res = maybe_unmangle_wwid(wwid_buf, wwid);
+
+	wwid[3] = ' ';
+	strlcpy(wwid + sizeof(wwid) - 5, " ", 5);
+	assert_int_equal(res, strlen(wwid + 3));
+	assert_string_equal(wwid_buf, wwid + 3);
+}
+
+/* truncated mangle sequence at the end, will no be unmangled */
+static void test_wwid_overlong_03(void **state)
+{
+	char wwid[WWID_SIZE + 5];
+	size_t res;
+	memset(wwid, 'A', sizeof(wwid) - 1);
+
+	wwid[sizeof(wwid) - 1] = '\0';
+	strlcpy(wwid + sizeof(wwid) - 4, "\\x20", 4);
+	memcpy(wwid, "\\x20", 4);
+
+	res = maybe_unmangle_wwid(wwid_buf, wwid);
+	assert_int_equal(res, strlen(wwid));
+	wwid[WWID_SIZE - 1] = '\0';
+	assert_string_equal(wwid_buf, wwid);
+}
+
+/* overlong string fits after unmangling */
+static void test_wwid_overlong_04(void **state)
+{
+	char wwid[WWID_SIZE + 3];
+	size_t res;
+	memset(wwid, 'A', sizeof(wwid) - 1);
+
+	wwid[sizeof(wwid) - 1] = '\0';
+	strlcpy(wwid, "\\x20", sizeof(wwid));
+
+	will_return_int(__wrap_check_wwids_file, 1);
+	will_return_int(__wrap_check_wwids_file, 1);
+	res = maybe_unmangle_wwid(wwid_buf, wwid);
+
+	wwid[3] = ' ';
+	assert_int_equal(res, strlen(wwid + 3));
+	assert_string_equal(wwid_buf, wwid + 3);
+}
+
+static void test_wwid_unmangle_01(void **state)
+{
+	const char *const wwid = "wwid\\x20with\\x20spaces";
+	const char *const expected = "wwid with spaces";
+	size_t res;
+
+	will_return_int(__wrap_check_wwids_file, 1);
+	will_return_int(__wrap_check_wwids_file, 1);
+	res = maybe_unmangle_wwid(wwid_buf, wwid);
+
+	assert_int_equal(res, strlen(expected));
+	assert_string_equal(wwid_buf, expected);
+}
+
+static void test_wwid_unmangle_02(void **state)
+{
+	const char *const wwid = "wwid\\x2cwith\\x2ccommas";
+	const char *const expected = "wwid,with,commas";
+	size_t res;
+
+	will_return_int(__wrap_check_wwids_file, 1);
+	will_return_int(__wrap_check_wwids_file, 1);
+	res = maybe_unmangle_wwid(wwid_buf, wwid);
+
+	assert_int_equal(res, strlen(expected));
+	assert_string_equal(wwid_buf, expected);
+}
+
+static void test_wwid_unmangle_03(void **state)
+{
+	const char *const wwid = "\\x20\\x20wwid\\x20\\x20\\x20with\\x20spaces\\x20";
+	const char *const expected = "  wwid   with spaces ";
+	size_t res;
+
+	will_return_int(__wrap_check_wwids_file, 1);
+	will_return_int(__wrap_check_wwids_file, 1);
+	res = maybe_unmangle_wwid(wwid_buf, wwid);
+
+	assert_int_equal(res, strlen(expected));
+	assert_string_equal(wwid_buf, expected);
+}
+
+static void test_wwid_unmangle_04(void **state)
+{
+	const char *const wwid = "wwid\\x20with\\x5cbackslash";
+	const char *const expected = "wwid with\\backslash";
+	size_t res;
+
+	will_return_int(__wrap_check_wwids_file, 1);
+	will_return_int(__wrap_check_wwids_file, 1);
+	res = maybe_unmangle_wwid(wwid_buf, wwid);
+
+	assert_int_equal(res, strlen(expected));
+	assert_string_equal(wwid_buf, expected);
+}
+
+static void test_wwid_unmangle_05(void **state)
+{
+	const char *const wwid = "wwid\\x20with\\x5cx20mangled\\x20space";
+	const char *const expected = "wwid with\\x20mangled space";
+	size_t res;
+
+	will_return_int(__wrap_check_wwids_file, 1);
+	will_return_int(__wrap_check_wwids_file, 1);
+	res = maybe_unmangle_wwid(wwid_buf, wwid);
+
+	assert_int_equal(res, strlen(expected));
+	assert_string_equal(wwid_buf, expected);
+}
+
+static void test_wwid_unmangle_06(void **state)
+{
+	const char *const wwid = "wwid\\x20with\\x5cx5cmangled\\x20backslash";
+	const char *const expected = "wwid with\\x5cmangled backslash";
+	size_t res;
+
+	will_return_int(__wrap_check_wwids_file, 1);
+	will_return_int(__wrap_check_wwids_file, 1);
+	res = maybe_unmangle_wwid(wwid_buf, wwid);
+
+	assert_int_equal(res, strlen(expected));
+	assert_string_equal(wwid_buf, expected);
+}
+
+static void test_wwid_unmangle_07(void **state)
+{
+	const char *const wwid = "wwid\\x20with\\x09unprintable";
+	const char *const expected = "wwid with_unprintable";
+	size_t res;
+
+	will_return_int(__wrap_check_wwids_file, 1);
+	will_return_int(__wrap_check_wwids_file, 1);
+	res = maybe_unmangle_wwid(wwid_buf, wwid);
+
+	assert_int_equal(res, strlen(expected));
+	assert_string_equal(wwid_buf, expected);
+}
+
+static void test_wwid_unmangled_exists(void **state)
+{
+	const char *const wwid = "wwid\\x20with\\x20spaces";
+	const char *const expected = "wwid with spaces";
+	size_t res;
+
+	will_return_int(__wrap_check_wwids_file, 0);
+	res = maybe_unmangle_wwid(wwid_buf, wwid);
+
+	assert_int_equal(res, strlen(expected));
+	assert_string_equal(wwid_buf, expected);
+}
+
+static void test_wwid_orig_exists(void **state)
+{
+	const char *const wwid = "wwid\\x20with\\x20spaces";
+	size_t res;
+
+	will_return_int(__wrap_check_wwids_file, 1);
+	will_return_int(__wrap_check_wwids_file, 0);
+	res = maybe_unmangle_wwid(wwid_buf, wwid);
+
+	assert_int_equal(res, strlen(wwid));
+	assert_string_equal(wwid_buf, wwid);
+}
+
+static int test_uevent_wwid_mangle(void)
+{
+	const struct CMUnitTest tests[] = {
+		cmocka_unit_test(test_wwid_null),
+		cmocka_unit_test(test_wwid_zero),
+		cmocka_unit_test(test_wwid_no_unmangle_01),
+		cmocka_unit_test(test_wwid_no_unmangle_02),
+		cmocka_unit_test(test_wwid_no_unmangle_03),
+		cmocka_unit_test(test_wwid_no_unmangle_04),
+		cmocka_unit_test(test_wwid_no_unmangle_05),
+		cmocka_unit_test(test_wwid_no_unmangle_06),
+		cmocka_unit_test(test_wwid_no_unmangle_07),
+		cmocka_unit_test(test_wwid_no_unmangle_08),
+		cmocka_unit_test(test_wwid_no_unmangle_09),
+		cmocka_unit_test(test_wwid_no_unmangle_10),
+		cmocka_unit_test(test_wwid_overlong_01),
+		cmocka_unit_test(test_wwid_overlong_02),
+		cmocka_unit_test(test_wwid_overlong_03),
+		cmocka_unit_test(test_wwid_overlong_04),
+		cmocka_unit_test(test_wwid_unmangle_01),
+		cmocka_unit_test(test_wwid_unmangle_02),
+		cmocka_unit_test(test_wwid_unmangle_03),
+		cmocka_unit_test(test_wwid_unmangle_04),
+		cmocka_unit_test(test_wwid_unmangle_05),
+		cmocka_unit_test(test_wwid_unmangle_06),
+		cmocka_unit_test(test_wwid_unmangle_07),
+		cmocka_unit_test(test_wwid_unmangled_exists),
+		cmocka_unit_test(test_wwid_orig_exists),
+	};
+	return cmocka_run_group_tests(tests, NULL, NULL);
+}
+
+int main(void)
+{
+	int ret = 0;
+
+	init_test_verbosity(-1);
+	ret += test_uevent_wwid_mangle();
+	return ret;
+}
-- 
2.55.0

