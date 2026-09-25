Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926E63E00B4
	for <dm-devel@lists.linux.dev>; Fri, 25 Sep 2026 21:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790372450; cv=none; b=Yo8Qj7hY9yNe78LvVEG6mXQEcaIFt6FB51v9FekeFffPOJQS6W7Z4eOqRDMpgKy7Db9yN15nswLtPAHHu2icTywQAJWPB/bAw+y9e2agMn8eA6qQFXOzypMVNCGEfFKAL7Vwz9b5LvjF56I0erncTemY36sH5GRwsszAqEQdi9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790372450; c=relaxed/simple;
	bh=6jzWJQ5/1WDNLHptnWvyNE9uhx03uYjhCuwM8NXNjnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AWeU6BPHJpn9B4139K652Ie39fx85ByW+IFbwA0iTpuUf+A53B7Ke5QOtOlzza3rSaTDbfz8amFzOV8HavJv5WaU7729sQqite2PU/RU+1QKsDQ4lLTQrahg25fHAnfHILQC5zYdfo+ZR/ooliDV6F0TR6Sm+0ln+dAoJzKjllA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WodiuBtt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gtnjldBb; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oZG0ocTj; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RV16zAJM; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WodiuBtt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gtnjldBb";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oZG0ocTj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RV16zAJM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5B05E1F457;
	Fri, 25 Sep 2026 21:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790372442; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UhnyZ/vn5iOKwoErVOmGZKjR0vux8DW978TAJmtG5pc=;
	b=WodiuBttbygvWgNeY0+Em7fbFgrMBOpD5RaiIH3GpPDiowV0F9KXQWK0EzsAbfMBuHU7Kd
	icKaJDYhsuuaOrRF9VPy9EO11D+OKJcApTY7GGsz4meWt4K7N/RzDZ1apqOyPYboduCj1c
	rUaBVXIcUt/sSkaWSoAaMorXlZX7DCQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790372442;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UhnyZ/vn5iOKwoErVOmGZKjR0vux8DW978TAJmtG5pc=;
	b=gtnjldBbPQ7etbSuQdDLZiWEvb4mxLFqlCPcgadnMdKdACxyq+cWHWMbiQWhwcbS0TdvRG
	5QzFo8rbOqCWOBCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790372438; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UhnyZ/vn5iOKwoErVOmGZKjR0vux8DW978TAJmtG5pc=;
	b=oZG0ocTj2yMsRM4PCIF+4BRmyqr/EAg/KLlU7fhy/H/+LpS6NNw8ebIBy7fMIK98FMgZUh
	rtHucaiCtRYwIB/MXpn/4CWZmPgy6vAyXE0e6p4i67QWeMhXc071084tgx2mrOSHI1y5j8
	tG9TySiUCAm5iAZjGsqlyxyo3CVgYfU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790372438;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UhnyZ/vn5iOKwoErVOmGZKjR0vux8DW978TAJmtG5pc=;
	b=RV16zAJMiNTHObqtHs5rWZXiM0unwW5QZ8WtJRz7ad446Y9yXTInmsM3Q2uddZcnlrZ3Xh
	zeyxCvbBmkVzeLDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BF469132DD;
	Fri, 25 Sep 2026 21:40:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7imQB1XqtmoZLwAAD6G6ig:T4
	(envelope-from <mwilck@suse.de>); Fri, 25 Sep 2026 21:40:37 +0000
From: mwilck@suse.de
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 3/4] multipath-tools tests: add test for WWID unmangling
Date: Fri, 25 Sep 2026 23:40:08 +0200
Message-ID: <20260925214014.2464499-4-mwilck@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260925214014.2464499-1-mwilck@suse.de>
References: <20260925214014.2464499-1-mwilck@suse.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FROM_NO_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.com:email]
X-Spam-Flag: NO

From: Martin Wilck <mwilck@suse.com>

Add tests for the logic of the code added in the previous commit.

Signed-off-by: Martin Wilck <mwilck@suse.com>
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

