Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE5619046C
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130837; cv=none; b=F54AEEuM48MDSnKMw3LCEfa4jSghZrgZOW1J3afU9KQnC7huSutJYVSqGXA27GRr8f75QELcqwT0mLVTNwzDHW3WgHHTzB3HTVsRW5ea/CbVunDjMePUKxaF4rR+80asjT578UW4MIC1BWPb6DlljwG/OE93H9Xs33kefwt+AkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130837; c=relaxed/simple;
	bh=CYbxxxt4EPqdTrKfRONwjdlRu2xuvzA3sG7xSjQwvco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGqxBVfrGRwXLNcagBLO5vWuLUYYaH6wfMMIjiyXxhpllu9xiXXNuNsHhwP6+hf/qq2GXc+AlS3AjwvF3bxBAa1gfbRcothaWZxu/o0HrG/7s/sSRl6VQefG8aaS9YMEsZVIdb1MlBm6yiOtbjwCEZDMO3ab6r+V/2OHiHAGTJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bJtUmb1Q; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bJtUmb1Q"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a7a94478a4eso352066366b.1
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130833; x=1723735633; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y6iPYtrqlca+GAQmY0VXtcBcvQFpvgb9k62+cjGxXV0=;
        b=bJtUmb1QGIjlzZfRVM14m6YlYQQ+qEKMWih22W4NkHhEn9MeHbT+Hde3Vm86N73GEj
         aOIVI2Qnv6AALbFkTaUiaxhxcpSVjiokS2t5i0Nj8X/Et63IYiU9DfrwpesyZeWfQ7A6
         CfZP75OhEEsw37n3Py/V5RbFdhtgULDcT2C0PrbQ9H/j2ti6Bv2eHDJCXmXu7WjhwxWv
         U5p1Ex3UcwtakXagmRwsZ8eutQv5Y051SHTEXpBdfM+XqGzt/xAyYkAI3gGa5k2CzkUi
         S3Sc65pGmAsvD/Xgoa5TWHbX9ZAn/QhLtnxjrO8AxEWvgOjIgnDevLcK/hFJ7EWiSAWD
         GcWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130833; x=1723735633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y6iPYtrqlca+GAQmY0VXtcBcvQFpvgb9k62+cjGxXV0=;
        b=h+4FuL1os7/n1vA+kDyZi7oPp846Q5sgxWRffwLX93vt2Glng9zgm+OQFyMOPf3NfY
         tyuUWe8Z+iZC/imazfoKPjkDffjkHae+JMDLaf4iECPumu0cHJ8DXhg3Le4nK5W2ngh6
         v34ejnHTZXjtHcT1OwRp+f7OCVgHjjGWpTCj9Lg4jo3acs/+xuXfirtsoUPsHzuMXt+C
         ysMe475tI5nZVsRYgZe2D928NQEBcJUAhM2ooqk5DnjBHe2lYxcv1YDeA32uoyd/N0L/
         C99CjZa7KGfsAqlX+TPFFPghMCteVgeY9l0lMcmvoSm7jnAEWhyWiEBSGoQuB4t2CcOO
         CAnA==
X-Gm-Message-State: AOJu0YyW7bmJyBtMkeQ/8+OqHfgiyq1/OiVeQ5vYFgKP6P/HQI48B6kS
	hytJXvSyjfwAhnhmjvdTAPW+utdxgQzGIGgt5n/vLr/c+PDtaynmFYscPoiy4ww=
X-Google-Smtp-Source: AGHT+IHyulFNhyBSJ4tBi/DlYtpWFXsnCUYxPLm+qE2/Jz7VwLhqkXIQsKXUlr2k1w29vho0hRk70g==
X-Received: by 2002:a17:907:a0c:b0:a72:66d5:892c with SMTP id a640c23a62f3a-a8091f5aba8mr217492066b.18.1723130833143;
        Thu, 08 Aug 2024 08:27:13 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9c0cbe6sm751758766b.71.2024.08.08.08.27.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:27:12 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 38/41] multipath-tools tests: rename functions with double underscores
Date: Thu,  8 Aug 2024 17:26:17 +0200
Message-ID: <20240808152620.93965-39-mwilck@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240808152620.93965-1-mwilck@suse.com>
References: <20240808152620.93965-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/alias.c    | 42 +++++++++++++++++++++---------------------
 tests/test-lib.c |  4 ++--
 tests/test-lib.h | 16 ++++++++--------
 3 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/tests/alias.c b/tests/alias.c
index 4f23cf9..163d9a7 100644
--- a/tests/alias.c
+++ b/tests/alias.c
@@ -25,7 +25,7 @@
 #define MPATH_ID_INT_MAX_p1 "fxshrxx"
 #endif
 
-static int __set_errno(int err)
+static int set_errno__(int err)
 {
 	if (err >= 0) {
 		errno = 0;
@@ -63,12 +63,12 @@ ssize_t __wrap_write(int fd, const void *buf, size_t count)
 	start = strstr(start, binding);
 	check_expected(count);
 	assert_ptr_not_equal(start, NULL);
-	return __set_errno(mock_type(int));
+	return set_errno__(mock_type(int));
 }
 
 int __wrap_rename(const char *old, const char *new)
 {
-	return __set_errno(mock_type(int));
+	return set_errno__(mock_type(int));
 }
 
 int WRAP_FUNC(mkstemp)(char *template)
@@ -134,7 +134,7 @@ int __wrap_pthread_mutex_unlock(pthread_mutex_t *mutex)
 #define TEST_FPTR ((FILE *) 0xaffe)
 
 /* strbuf wrapper for the old format_devname() */
-static int __format_devname(char *name, int id, size_t len, const char *prefix)
+static int format_devname__(char *name, int id, size_t len, const char *prefix)
 {
 	STRBUF_ON_STACK(buf);
 
@@ -151,7 +151,7 @@ static void fd_mpatha(void **state)
 	char buf[32];
 	int rc;
 
-	rc = __format_devname(buf, 1, sizeof(buf), "FOO");
+	rc = format_devname__(buf, 1, sizeof(buf), "FOO");
 	assert_int_equal(rc, 4);
 	assert_string_equal(buf, "FOOa");
 }
@@ -162,7 +162,7 @@ static void fd_mpathz(void **state)
 	char buf[5];
 	int rc;
 
-	rc = __format_devname(buf, 26, sizeof(buf), "FOO");
+	rc = format_devname__(buf, 26, sizeof(buf), "FOO");
 	assert_int_equal(rc, 4);
 	assert_string_equal(buf, "FOOz");
 }
@@ -172,7 +172,7 @@ static void fd_mpathaa(void **state)
 	char buf[32];
 	int rc;
 
-	rc = __format_devname(buf, 26 + 1, sizeof(buf), "FOO");
+	rc = format_devname__(buf, 26 + 1, sizeof(buf), "FOO");
 	assert_int_equal(rc, 5);
 	assert_string_equal(buf, "FOOaa");
 }
@@ -182,7 +182,7 @@ static void fd_mpathzz(void **state)
 	char buf[32];
 	int rc;
 
-	rc = __format_devname(buf, 26*26 + 26, sizeof(buf), "FOO");
+	rc = format_devname__(buf, 26*26 + 26, sizeof(buf), "FOO");
 	assert_int_equal(rc, 5);
 	assert_string_equal(buf, "FOOzz");
 }
@@ -192,7 +192,7 @@ static void fd_mpathaaa(void **state)
 	char buf[32];
 	int rc;
 
-	rc = __format_devname(buf, 26*26 + 27, sizeof(buf), "FOO");
+	rc = format_devname__(buf, 26*26 + 27, sizeof(buf), "FOO");
 	assert_int_equal(rc, 6);
 	assert_string_equal(buf, "FOOaaa");
 }
@@ -202,7 +202,7 @@ static void fd_mpathzzz(void **state)
 	char buf[32];
 	int rc;
 
-	rc = __format_devname(buf, 26*26*26 + 26*26 + 26, sizeof(buf), "FOO");
+	rc = format_devname__(buf, 26*26*26 + 26*26 + 26, sizeof(buf), "FOO");
 	assert_int_equal(rc, 6);
 	assert_string_equal(buf, "FOOzzz");
 }
@@ -212,7 +212,7 @@ static void fd_mpathaaaa(void **state)
 	char buf[32];
 	int rc;
 
-	rc = __format_devname(buf, 26*26*26 + 26*26 + 27, sizeof(buf), "FOO");
+	rc = format_devname__(buf, 26*26*26 + 26*26 + 27, sizeof(buf), "FOO");
 	assert_int_equal(rc, 7);
 	assert_string_equal(buf, "FOOaaaa");
 }
@@ -222,7 +222,7 @@ static void fd_mpathzzzz(void **state)
 	char buf[32];
 	int rc;
 
-	rc = __format_devname(buf, 26*26*26*26 + 26*26*26 + 26*26 + 26,
+	rc = format_devname__(buf, 26*26*26*26 + 26*26*26 + 26*26 + 26,
 			    sizeof(buf), "FOO");
 	assert_int_equal(rc, 7);
 	assert_string_equal(buf, "FOOzzzz");
@@ -234,7 +234,7 @@ static void fd_mpath_max(void **state)
 	char buf[32];
 	int rc;
 
-	rc  = __format_devname(buf, INT_MAX, sizeof(buf), "");
+	rc  = format_devname__(buf, INT_MAX, sizeof(buf), "");
 	assert_int_equal(rc, strlen(MPATH_ID_INT_MAX));
 	assert_string_equal(buf, MPATH_ID_INT_MAX);
 }
@@ -245,7 +245,7 @@ static void fd_mpath_max1(void **state)
 	char buf[32];
 	int rc;
 
-	rc  = __format_devname(buf, INT_MIN, sizeof(buf), "");
+	rc  = format_devname__(buf, INT_MIN, sizeof(buf), "");
 	assert_int_equal(rc, -1);
 }
 
@@ -254,7 +254,7 @@ static void fd_mpath_short(void **state)
 	char buf[4];
 	int rc;
 
-	rc = __format_devname(buf, 1, sizeof(buf), "FOO");
+	rc = format_devname__(buf, 1, sizeof(buf), "FOO");
 	assert_int_equal(rc, -1);
 }
 
@@ -263,7 +263,7 @@ static void fd_mpath_short1(void **state)
 	char buf[5];
 	int rc;
 
-	rc = __format_devname(buf, 27, sizeof(buf), "FOO");
+	rc = format_devname__(buf, 27, sizeof(buf), "FOO");
 	assert_int_equal(rc, -1);
 }
 
@@ -388,7 +388,7 @@ static void sd_fd_many(void **state)
 	int rc, i;
 
 	for (i = 1; i < 5000; i++) {
-		rc = __format_devname(buf, i, sizeof(buf), "MPATH");
+		rc = format_devname__(buf, i, sizeof(buf), "MPATH");
 		assert_in_range(rc, 6, 8);
 		rc = scan_devname(buf, "MPATH");
 		assert_int_equal(rc, i);
@@ -403,7 +403,7 @@ static void sd_fd_random(void **state)
 	srandom(1);
 	for (i = 1; i < 1000; i++) {
 		n = random() & 0xffff;
-		rc = __format_devname(buf, n, sizeof(buf), "MPATH");
+		rc = format_devname__(buf, n, sizeof(buf), "MPATH");
 		assert_in_range(rc, 6, 9);
 		rc = scan_devname(buf, "MPATH");
 		assert_int_equal(rc, n);
@@ -483,7 +483,7 @@ static void mock_self_alias(const char *alias, const char *wwid)
 		expect_condlog(3, USED_STR(alias, wwid));		\
 	} while(0)
 
-static void __mock_bindings_file(const char *content, bool conflict_ok)
+static void mock_bindings_file__(const char *content, bool conflict_ok)
 {
 	char *cnt __attribute__((cleanup(cleanup_charp))) = NULL;
 	char *token, *savep = NULL;
@@ -509,7 +509,7 @@ static void __mock_bindings_file(const char *content, bool conflict_ok)
 }
 
 static void mock_bindings_file(const char *content) {
-	return __mock_bindings_file(content, false);
+	return mock_bindings_file__(content, false);
 }
 
 static int teardown_bindings(void **state)
@@ -1918,7 +1918,7 @@ static void order_test(int n, const struct random_aliases ra[], bool conflict_ok
 
 	for (j = 0; j < n; j++)
 		fill_bindings_random(&buf, ra[j].start, ra[j].end, ra[j].prefix);
-	__mock_bindings_file(get_strbuf_str(&buf), conflict_ok);
+	mock_bindings_file__(get_strbuf_str(&buf), conflict_ok);
 
 	for (j = 0; j < n; j++) {
 		bdg = VECTOR_SLOT(bindings, 0);
diff --git a/tests/test-lib.c b/tests/test-lib.c
index 88f35e9..99beccc 100644
--- a/tests/test-lib.c
+++ b/tests/test-lib.c
@@ -367,7 +367,7 @@ void mock_store_pathinfo(int mask,  const struct mocked_path *mp)
 	mock_pathinfo(mask, mp);
 }
 
-struct path *__mock_path(vector pathvec,
+struct path *mock_path__(vector pathvec,
 			 const char *vnd, const char *prd,
 			 const char *rev, const char *wwid,
 			 const char *dev,
@@ -395,7 +395,7 @@ struct path *__mock_path(vector pathvec,
 }
 
 
-struct multipath *__mock_multipath(struct vectors *vecs, struct path *pp)
+struct multipath *mock_multipath__(struct vectors *vecs, struct path *pp)
 {
 	struct multipath *mp;
 	struct config *conf;
diff --git a/tests/test-lib.h b/tests/test-lib.h
index 61e67b2..ff54834 100644
--- a/tests/test-lib.h
+++ b/tests/test-lib.h
@@ -40,29 +40,29 @@ struct mocked_path *mocked_path_from_path(struct mocked_path *mp,
 
 void mock_pathinfo(int mask, const struct mocked_path *mp);
 void mock_store_pathinfo(int mask, const struct mocked_path *mp);
-struct path *__mock_path(vector pathvec,
+struct path *mock_path__(vector pathvec,
 			 const char *vnd, const char *prd,
 			 const char *rev, const char *wwid,
 			 const char *dev,
 			 unsigned int flags, int mask);
 
 #define mock_path(v, p) \
-	__mock_path(hwt->vecs->pathvec,	(v), (p), "0", NULL, NULL,	\
+	mock_path__(hwt->vecs->pathvec,	(v), (p), "0", NULL, NULL,	\
 		    0, default_mask)
 #define mock_path_flags(v, p, f) \
-	__mock_path(hwt->vecs->pathvec,	(v), (p), "0", NULL, NULL, \
+	mock_path__(hwt->vecs->pathvec,	(v), (p), "0", NULL, NULL, \
 		    (f), default_mask)
 #define mock_path_blacklisted(v, p) \
-	__mock_path(hwt->vecs->pathvec,	(v), (p), "0", NULL, NULL, \
+	mock_path__(hwt->vecs->pathvec,	(v), (p), "0", NULL, NULL, \
 		    BL_BY_DEVICE, default_mask)
 #define mock_path_wwid(v, p, w) \
-	__mock_path(hwt->vecs->pathvec,	(v), (p), "0", (w), NULL,	\
+	mock_path__(hwt->vecs->pathvec,	(v), (p), "0", (w), NULL,	\
 		    0, default_mask)
 #define mock_path_wwid_flags(v, p, w, f) \
-	__mock_path(hwt->vecs->pathvec,	(v), (p), "0", (w),		\
+	mock_path__(hwt->vecs->pathvec,	(v), (p), "0", (w),		\
 		    NULL, (f), default_mask)
 
-struct multipath *__mock_multipath(struct vectors *vecs, struct path *pp);
-#define mock_multipath(pp) __mock_multipath(hwt->vecs, (pp))
+struct multipath *mock_multipath__(struct vectors *vecs, struct path *pp);
+#define mock_multipath(pp) mock_multipath__(hwt->vecs, (pp))
 
 #endif
-- 
2.46.0

