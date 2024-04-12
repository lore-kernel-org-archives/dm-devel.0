Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A0A524B8
	for <dm-devel@lists.linux.dev>; Fri, 12 Apr 2024 09:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712913384; cv=none; b=nEzBkdzLtAM/Zz2G+jXl6JLfi5Pg0lXBfkMlTFhAVuovKWNHwb+mY2+INUNLM9rBe7ozE87LiSKXIxvHj9E8TNjDQ3mz4Y7fdyJ1QnMyr4QKIXos7cVub3JlTPo4M+1u/KA5Q9z/QDtG8ewjwbgt/QJXxXBvX5+hrEE0hiyrsRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712913384; c=relaxed/simple;
	bh=o8ku04rFcKTjOTlPVpbg0SvBwZtp3uAnWqu7MI2feCM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=alTukz7+rFjSUDfo8eQP3bEDMOIgGSuI5EcAAnV4oeixuhXt++TWmz+wWz7ImG7riPTBMAuKcpuzp34VCT5KDSKGcNmNAdY035UOEBd6PtYr4mZlebyrosUrr5xtbXtjRb03uaWdgDLMZYCv9XbcSzhBNVqpZKbddSKKTKP8iUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=P5/LGuA6; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="P5/LGuA6"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2d6ff0422a2so7344901fa.2
        for <dm-devel@lists.linux.dev>; Fri, 12 Apr 2024 02:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712913380; x=1713518180; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oEjgsVjFzVRvKGchOPkp1Jdq2zRSfAD1FSL0Fzp4b/o=;
        b=P5/LGuA6cBnWR8Dp5L1U/+gS48N9Lesloe2QCMbwg+D+3NxYqdy/umxDoDJD5pycKc
         fvFvBGyaP9LnfouMkvpr5yXsKUApwpdeHgKuv8vlahZH64JMrxk8vxYzsUirQsdU7Fes
         +1TD350QvtQdnscafHVlhHhfndGQ9o/mz6oTu5IulBAcha1QXvRajtoNb+4tVKbQ9Abb
         Myj8NmLLhoU9PW5Y4UJukbU8lY+YBWAjccLz83olb/AdOENtMZA30Vl97S8nq6L8/yrw
         xh9O5wRJ0s332xoo3IktC0lr/bTQPLBVUfR2LtgJ4GUAVyh0iNCZbfvh5TtoT3VrQfC1
         meIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712913380; x=1713518180;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oEjgsVjFzVRvKGchOPkp1Jdq2zRSfAD1FSL0Fzp4b/o=;
        b=sM42orssdSypQSUjstKgBH96NMGAgcN9Rwxz1NgMTzjqDlJkrQWHQE8z2AU0cR4uRh
         jke+BwY40549jJ6q8+HiwFBnJBddxmjUg0cQhdT/f9o3Zb7/3ghtuKQTogvpzfotkFid
         EfMzIIFnbTG3LfNR6TzJSO5zAepKbcqifXikY/gSKQZAP8EkOMPfVpVdIrJR06qC6huf
         xJGj0+UQjZO8FbIdgAecppXFzchww8F4iBRHA/X+GmBFY1IC1n+EMUWb/KggjFaVj8Zk
         uTAnIggJRWGP42BM+3cFbRJduo8e86eN3FlpEt2qTEZuqaIdNfeOHiV/SSRgzLy3ABM7
         cSyw==
X-Gm-Message-State: AOJu0YzWCJBubYwalyNZsUCTGBVrATSz/YOGgmVtgzX+24oNfqqAfeci
	bF2reGfzY+Zz4OWEJwAdWfiBAT6ob2fwR4i0O8y/878l8vFHjoUZZm2nBqeuxzQ=
X-Google-Smtp-Source: AGHT+IEWeZ81reFNsp6zOQxRIdHC5IywjyV430fKLD0QtFYYzUfQXsYRTnAYfcyRrE7ZFxjQt+6TMQ==
X-Received: by 2002:a2e:81da:0:b0:2d8:d0c9:1ffc with SMTP id s26-20020a2e81da000000b002d8d0c91ffcmr1384893ljg.1.1712913379981;
        Fri, 12 Apr 2024 02:16:19 -0700 (PDT)
Received: from localhost (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with UTF8SMTPSA id l35-20020a05600c1d2300b004161af729f4sm5104056wms.31.2024.04.12.02.16.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Apr 2024 02:16:19 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@lists.linux.dev,
	Khem Raj <raj.khem@gmail.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] libmpathutil: really always use glibc basename()
Date: Fri, 12 Apr 2024 11:16:17 +0200
Message-ID: <20240412091617.18560-1-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Despite 03a5456 ("libmultipath: always use glibc basename()"), we
still call the system library's basename() from libmultipath.
musl libc until 1.24 provided a prototype for basename() in string.h,
which was not correct and was resolved to the destructive POSIX
basename(). musl libc 1.25 removed this prototype.

While the remaining code path doesn't strictly depend on the non-destructive
behavior of glibc's basename(), it's cleaner and safer to use the same
implementation everywhere.

Fixes: 03a5456 ("libmultipath: always use glibc basename()")
Fixes: https://github.com/opensvc/multipath-tools/pull/84

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Khem Raj <raj.khem@gmail.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---

mwilck: Already reviewed and queued, posting to dm-devel for information.

---
 libmpathutil/libmpathutil.version |  4 ++++
 libmpathutil/util.c               |  5 +----
 libmpathutil/util.h               |  5 +++++
 tests/util.c                      | 31 +++++++++++++++++++++++++++++++
 4 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/libmpathutil/libmpathutil.version b/libmpathutil/libmpathutil.version
index 80d64a3..fee74a3 100644
--- a/libmpathutil/libmpathutil.version
+++ b/libmpathutil/libmpathutil.version
@@ -129,3 +129,7 @@ LIBMPATHUTIL_2.0 {
 	vector_move_up;
 	vector_sort;
 };
+
+LIBMPATHUTIL_2.1 {
+	libmp_basename;
+};
diff --git a/libmpathutil/util.c b/libmpathutil/util.c
index 9d147fc..23d303f 100644
--- a/libmpathutil/util.c
+++ b/libmpathutil/util.c
@@ -32,18 +32,15 @@ strchop(char *str)
 	return i;
 }
 
-#ifndef __GLIBC__
 /*
  * glibc's non-destructive version of basename()
  * License: LGPL-2.1-or-later
  */
-static const char *__basename(const char *filename)
+const char *libmp_basename(const char *filename)
 {
 	char *p = strrchr(filename, '/');
 	return p ? p + 1 : filename;
 }
-#define basename(x) __basename(x)
-#endif
 
 int
 basenamecpy (const char *src, char *dst, size_t size)
diff --git a/libmpathutil/util.h b/libmpathutil/util.h
index de9fcfd..4997fed 100644
--- a/libmpathutil/util.h
+++ b/libmpathutil/util.h
@@ -12,6 +12,11 @@
 #include <stdio.h>
 
 size_t strchop(char *);
+
+const char *libmp_basename(const char *filename);
+#ifndef __GLIBC__
+#define basename(x) libmp_basename(x)
+#endif
 int basenamecpy (const char *src, char *dst, size_t size);
 int filepresent (const char *run);
 char *get_next_string(char **temp, const char *split_char);
diff --git a/tests/util.c b/tests/util.c
index d6083dc..4850ddc 100644
--- a/tests/util.c
+++ b/tests/util.c
@@ -16,6 +16,7 @@
  *
  */
 
+#define _GNU_SOURCE
 #include <stdbool.h>
 #include <stdarg.h>
 #include <stddef.h>
@@ -23,6 +24,7 @@
 #include <stdlib.h>
 #include <cmocka.h>
 #include <endian.h>
+#include <string.h>
 #include "util.h"
 
 #include "globals.c"
@@ -163,6 +165,34 @@ static int test_basenamecpy(void)
 	return cmocka_run_group_tests(tests, NULL, NULL);
 }
 
+static void test_basename_01(void **state)
+{
+	const char *path = "/foo/bar";
+	const char *base;
+
+	base = basename(path);
+	assert_string_equal(base, "bar");
+	assert_string_equal(path, "/foo/bar");
+}
+
+static void test_basename_02(void **state)
+{
+	const char *path = "/foo/bar/";
+	const char *base;
+
+	base = basename(path);
+	assert_string_equal(base, "");
+	assert_string_equal(path, "/foo/bar/");
+}
+
+static int test_basename(void) {
+	const struct CMUnitTest tests[] = {
+		cmocka_unit_test(test_basename_01),
+		cmocka_unit_test(test_basename_02),
+	};
+	return cmocka_run_group_tests(tests, NULL, NULL);
+}
+
 /*
  * On big endian systems, if bitfield_t is 32bit, we need
  * to swap the two 32 bit parts of a 64bit value to make
@@ -946,6 +976,7 @@ int main(void)
 
 	init_test_verbosity(-1);
 	ret += test_basenamecpy();
+	ret += test_basename();
 	ret += test_bitmasks();
 	ret += test_strlcpy();
 	ret += test_strlcat();
-- 
2.44.0

