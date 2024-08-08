Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5699718FDB0
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130809; cv=none; b=IvDi45a12OpVZfqA7UWRMMJoaEvB30k7cox1jH62BDDuFn0tSz2ipuwE5uwpf9ZIcqDDeQfWTQngzWuyGiREquGMWRva9iRyoNArK5h19yUUX4/SwfLfcUrH+VtWhpBONp7nMWmPh7sIjQhdKe50O1wUQK05MDHk4WrczwgF0T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130809; c=relaxed/simple;
	bh=NEJWv1pFsKcFE53Ydr8hrgTvgVA7rjYwF8Z6wEEuJ3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWwW/2U5FBI/hc1ZR/qhh6GE5FuAt4NNnn54FMMqiTstEM3W1lLw1lrBAWWISnDCb1qQUKV1gbl9RJ5YkT8DpXFWFA7dtltFJ7mYBzmxXsW6Qp6LRzZURbk1/nqAUnnmAJ/MmW8MixSOsRG2jVAsk6HDj03i7acU/seDxGent48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=g7R4fkzr; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="g7R4fkzr"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5bb8e62570fso1333292a12.1
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130806; x=1723735606; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9PcjxzbInZeqEADv0Gt24M9Oy6TIVnsEVIUktXEE4wE=;
        b=g7R4fkzrAeWDTrScTwqL3zogsVAwm3Js9FwPZYg6/jKxG7VHMkC92NAYXdrhlQQbVu
         cnURZ7P2L0BOKiC2bgf1vEeI7m2T6VhAijz0blnu1f4+UotlwfyBEJiEJv2Zk6x+oQy6
         q/XRyO/KrddXVPsq9/retbMJkPQJX5cB+DhiiJLyvSAcHJBsjewpOWo4T0lPQtNDLaPG
         VRCsvDrQf5bt4e+UmoDKIyhnrTvDLQNHcnw/zU3CHiyk6PUirK0jurDYfr9RebiQ35up
         qr3gfDafLLoj5SW6bXE7NAx0iTjIgc+03/+BiBosjzwF8srJKpntFCRf4Uo08+qMG1kA
         8++Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130806; x=1723735606;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9PcjxzbInZeqEADv0Gt24M9Oy6TIVnsEVIUktXEE4wE=;
        b=w5fQ/krDDAw9C+2r5Sw7HuwtJ8P8MUUejRHzQz1nRET6aa65YUh+h9alTyPwi4ajij
         +M4gJvJyD8QlY04mYhb8hN0vftNUELXN4U1WS9lI6yUbCsIHE4q2N65xv2ilYPbqSCB4
         aV/t2Vwh82mdwxbvDgu1iwUlipc0YAMWOtFU4u63ES+rsatbqfCFZPDyrh+wLrDaR7bn
         vliz3qCDYLI6jalggXdqvmB29oanNICVqYlBtsLIaIGtx66mn1wlQS0ABYirCn2orc1f
         u31pzrSVpD1PS+IAunpGIrclRvswOXEYtX0MTo5IjAy6GDnRx/TbJML41YRuktI3EAl8
         hy4g==
X-Gm-Message-State: AOJu0Yx1rJVFM8J4xwJHF6Y2geVEzUu7LboBKhZ7s0TKdPB+FeIaNdKv
	ujbf9j4MJNssBmXELw2KtZDAfgkRktLTifnvn+ZHkvWOpRtOqSEeDHC/saQaDxQ=
X-Google-Smtp-Source: AGHT+IEhWEp8H92ZDiIsoeYBUqJpRRvATt9gfkYK3gIXyxOk7xJ9xUD6sc9M+/M8LSBF0grf5eZUFA==
X-Received: by 2002:a17:907:d84b:b0:a77:dd1c:627a with SMTP id a640c23a62f3a-a8090beb84bmr158634066b.8.1723130805239;
        Thu, 08 Aug 2024 08:26:45 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9bc3cf3sm768781666b.13.2024.08.08.08.26.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:45 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 11/41] libmpathutil: rename __append_strbuf_str() and __get_strbuf_buf()
Date: Thu,  8 Aug 2024 17:25:50 +0200
Message-ID: <20240808152620.93965-12-mwilck@suse.com>
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
 libmpathutil/libmpathutil.version |  4 ++--
 libmpathutil/parser.c             |  4 ++--
 libmpathutil/strbuf.c             |  6 +++---
 libmpathutil/strbuf.h             |  6 +++---
 libmultipath/alias.c              |  2 +-
 libmultipath/discovery.c          |  8 ++++----
 libmultipath/print.c              | 10 +++++-----
 tests/strbuf.c                    | 12 ++++++------
 8 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/libmpathutil/libmpathutil.version b/libmpathutil/libmpathutil.version
index 8393b91..270dcd8 100644
--- a/libmpathutil/libmpathutil.version
+++ b/libmpathutil/libmpathutil.version
@@ -47,8 +47,8 @@ LIBMPATHUTIL_4.0 {
 global:
 	alloc_bitfield;
 	alloc_strvec;
-	__append_strbuf_str;
 	append_strbuf_str;
+	append_strbuf_str__;
 	append_strbuf_quoted;
 	basenamecpy;
 	cleanup_charp;
@@ -71,7 +71,7 @@ global:
 	free_strvec;
 	get_linux_version_code;
 	get_monotonic_time;
-	__get_strbuf_buf;
+	get_strbuf_buf__;
 	get_next_string;
 	get_strbuf_len;
 	get_strbuf_str;
diff --git a/libmpathutil/parser.c b/libmpathutil/parser.c
index 29b212c..ab7d1aa 100644
--- a/libmpathutil/parser.c
+++ b/libmpathutil/parser.c
@@ -167,7 +167,7 @@ snprint_keyword(struct strbuf *buff, const char *fmt, struct keyword *kw,
 			goto out;
 		}
 		if (f != fmt &&
-		    (r = __append_strbuf_str(&sbuf, fmt, f - fmt)) < 0)
+		    (r = append_strbuf_str__(&sbuf, fmt, f - fmt)) < 0)
 			goto out;
 		fmt = f + 1;
 		switch(*fmt) {
@@ -191,7 +191,7 @@ snprint_keyword(struct strbuf *buff, const char *fmt, struct keyword *kw,
 	} while (*fmt++);
 out:
 	if (r >= 0)
-		r = __append_strbuf_str(buff, get_strbuf_str(&sbuf),
+		r = append_strbuf_str__(buff, get_strbuf_str(&sbuf),
 					get_strbuf_len(&sbuf));
 	return r;
 }
diff --git a/libmpathutil/strbuf.c b/libmpathutil/strbuf.c
index 6e53c3f..491a343 100644
--- a/libmpathutil/strbuf.c
+++ b/libmpathutil/strbuf.c
@@ -15,7 +15,7 @@
 
 static const char empty_str[] = "";
 
-char *__get_strbuf_buf(struct strbuf *buf)
+char *get_strbuf_buf__(struct strbuf *buf)
 {
 	return buf->buf;
 }
@@ -110,7 +110,7 @@ static int expand_strbuf(struct strbuf *buf, int addsz)
 	return 0;
 }
 
-int __append_strbuf_str(struct strbuf *buf, const char *str, int slen)
+int append_strbuf_str__(struct strbuf *buf, const char *str, int slen)
 {
 	int ret;
 
@@ -135,7 +135,7 @@ int append_strbuf_str(struct strbuf *buf, const char *str)
 	if (slen > INT_MAX)
 		return -ERANGE;
 
-	return __append_strbuf_str(buf, str, slen);
+	return append_strbuf_str__(buf, str, slen);
 }
 
 int fill_strbuf(struct strbuf *buf, char c, int slen)
diff --git a/libmpathutil/strbuf.h b/libmpathutil/strbuf.h
index 68f21de..790dc23 100644
--- a/libmpathutil/strbuf.h
+++ b/libmpathutil/strbuf.h
@@ -66,7 +66,7 @@ struct strbuf *new_strbuf(void);
  * If @strbuf was never written to, the function returns NULL.
  * The return value of this function must not be free()d.
  */
-char *__get_strbuf_buf(struct strbuf *buf);
+char *get_strbuf_buf__(struct strbuf *buf);
 
 /**
  * get_strbuf_str(): retrieve string from strbuf
@@ -112,7 +112,7 @@ size_t get_strbuf_len(const struct strbuf *buf);
 int truncate_strbuf(struct strbuf *buf, size_t offs);
 
 /**
- * __append_strbuf_str(): append string of known length
+ * append_strbuf_str__(): append string of known length
  * @param buf: the struct strbuf to write to
  * @param str: the string to append, not necessarily 0-terminated
  * @param slen: max number of characters to append, must be non-negative
@@ -123,7 +123,7 @@ int truncate_strbuf(struct strbuf *buf, size_t offs);
  * 0-bytes possibly contained in the first @slen characters are copied into
  * the output. If the function returns an error, @strbuf is unchanged.
  */
-int __append_strbuf_str(struct strbuf *buf, const char *str, int slen);
+int append_strbuf_str__(struct strbuf *buf, const char *str, int slen);
 
 /**
  * append_strbuf_str(): append string
diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index c4eb5d8..5c8ac93 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -242,7 +242,7 @@ static int write_bindings_file(const Bindings *bindings, int fd,
 	int i;
 	size_t len;
 
-	if (__append_strbuf_str(&content, BINDINGS_FILE_HEADER,
+	if (append_strbuf_str__(&content, BINDINGS_FILE_HEADER,
 				sizeof(BINDINGS_FILE_HEADER) - 1) == -1)
 		return -1;
 
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 380e0e9..f130a5c 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1336,14 +1336,14 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 
 		vpd += 4;
 		len = vpd_len - 4;
-		if ((err = __append_strbuf_str(&buf, (const char *)vpd, len)) < 0)
+		if ((err = append_strbuf_str__(&buf, (const char *)vpd, len)) < 0)
 			return err;
 
 		/* The input is 0-padded, make sure the length is correct */
 		truncate_strbuf(&buf, strlen(get_strbuf_str(&buf)));
 		len = get_strbuf_len(&buf);
 		if (type != '8') {
-			char *buffer = __get_strbuf_buf(&buf);
+			char *buffer = get_strbuf_buf__(&buf);
 
 			for (i = 0; i < len; ++i)
 				buffer[i] = tolower(buffer[i]);
@@ -1357,7 +1357,7 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 			return err;
 		while (vpd && (p = memchr(vpd, ' ', vpd_len))) {
 			p_len = p - vpd;
-			if ((err = __append_strbuf_str(&buf, (const char *)vpd,
+			if ((err = append_strbuf_str__(&buf, (const char *)vpd,
 						       p_len)) < 0)
 				return err;
 			vpd = p;
@@ -1370,7 +1370,7 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 				return err;
 		}
 		if (vpd_len > 0) {
-			if ((err = __append_strbuf_str(&buf, (const char *)vpd,
+			if ((err = append_strbuf_str__(&buf, (const char *)vpd,
 						       vpd_len)) < 0)
 				return err;
 		}
diff --git a/libmultipath/print.c b/libmultipath/print.c
index b7af913..db0aa35 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -1090,7 +1090,7 @@ int snprint_multipath_header(struct strbuf *line, const char *format,
 	for (f = strchr(format, '%'); f; f = strchr(++format, '%')) {
 		int iwc;
 
-		if ((rc = __append_strbuf_str(line, format, f - format)) < 0)
+		if ((rc = append_strbuf_str__(line, format, f - format)) < 0)
 			return rc;
 
 		format = f + 1;
@@ -1121,7 +1121,7 @@ int _snprint_multipath(const struct gen_multipath *gmp,
 	for (f = strchr(format, '%'); f; f = strchr(++format, '%')) {
 		int iwc;
 
-		if ((rc = __append_strbuf_str(line, format, f - format)) < 0)
+		if ((rc = append_strbuf_str__(line, format, f - format)) < 0)
 			return rc;
 
 		format = f + 1;
@@ -1151,7 +1151,7 @@ int snprint_path_header(struct strbuf *line, const char *format,
 	for (f = strchr(format, '%'); f; f = strchr(++format, '%')) {
 		int iwc;
 
-		if ((rc = __append_strbuf_str(line, format, f - format)) < 0)
+		if ((rc = append_strbuf_str__(line, format, f - format)) < 0)
 			return rc;
 
 		format = f + 1;
@@ -1181,7 +1181,7 @@ int _snprint_path(const struct gen_path *gp, struct strbuf *line,
 	for (f = strchr(format, '%'); f; f = strchr(++format, '%')) {
 		int iwc;
 
-		if ((rc = __append_strbuf_str(line, format, f - format)) < 0)
+		if ((rc = append_strbuf_str__(line, format, f - format)) < 0)
 			return rc;
 
 		format = f + 1;
@@ -1208,7 +1208,7 @@ int _snprint_pathgroup(const struct gen_pathgroup *ggp, struct strbuf *line,
 	int rc;
 
 	for (f = strchr(format, '%'); f; f = strchr(++format, '%')) {
-		if ((rc = __append_strbuf_str(line, format, f - format)) < 0)
+		if ((rc = append_strbuf_str__(line, format, f - format)) < 0)
 			return rc;
 
 		format = f + 1;
diff --git a/tests/strbuf.c b/tests/strbuf.c
index d7d4cd9..1cc1618 100644
--- a/tests/strbuf.c
+++ b/tests/strbuf.c
@@ -78,7 +78,7 @@ static void test_strbuf_00(void **state)
 	assert_string_equal(p, "");
 	free(p);
 
-	assert_int_equal(__append_strbuf_str(&buf, "x", 0), 0);
+	assert_int_equal(append_strbuf_str__(&buf, "x", 0), 0);
 	/* appending a 0-length string allocates memory */
 	assert_in_range(buf.size, 1, SIZE_MAX);
 	assert_int_equal(buf.offs, 0);
@@ -181,9 +181,9 @@ static void test_strbuf_nul(void **state)
 	STRBUF_ON_STACK(buf);
 	char greet[] = "hello, sir!";
 
-	assert_int_equal(__append_strbuf_str(&buf, greet, 6), 6);
+	assert_int_equal(append_strbuf_str__(&buf, greet, 6), 6);
 	assert_string_equal(get_strbuf_str(&buf), "hello,");
-	assert_int_equal(__append_strbuf_str(&buf, greet, 6), 6);
+	assert_int_equal(append_strbuf_str__(&buf, greet, 6), 6);
 	assert_string_equal(get_strbuf_str(&buf), "hello,hello,");
 
 	/* overwrite comma with NUL; append_strbuf_str() stops at NUL byte */
@@ -196,14 +196,14 @@ static void test_strbuf_nul(void **state)
 	assert_int_equal(get_strbuf_len(&buf), 10);
 	assert_string_equal(get_strbuf_str(&buf), "hellohello");
 
-	/* __append_strbuf_str() appends full memory, including NUL bytes */
+	/* append_strbuf_str__() appends full memory, including NUL bytes */
 	reset_strbuf(&buf);
-	assert_int_equal(__append_strbuf_str(&buf, greet, sizeof(greet) - 1),
+	assert_int_equal(append_strbuf_str__(&buf, greet, sizeof(greet) - 1),
 			 sizeof(greet) - 1);
 	assert_int_equal(get_strbuf_len(&buf), sizeof(greet) - 1);
 	assert_string_equal(get_strbuf_str(&buf), "hello");
 	assert_string_equal(get_strbuf_str(&buf) + get_strbuf_len(&buf) - 5, " sir!");
-	assert_int_equal(__append_strbuf_str(&buf, greet, sizeof(greet) - 1),
+	assert_int_equal(append_strbuf_str__(&buf, greet, sizeof(greet) - 1),
 			 sizeof(greet) - 1);
 	assert_string_equal(get_strbuf_str(&buf), "hello");
 	assert_int_equal(get_strbuf_len(&buf), 2 * (sizeof(greet) - 1));
-- 
2.46.0

