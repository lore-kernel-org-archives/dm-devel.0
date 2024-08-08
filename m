Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F4B18EFF1
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130800; cv=none; b=lLv4UIt0+OFuc97u0qzu5xpTuhmCmGC9iOYNONdO/eKpKGUF6jDzpCroWCAu77G0oxi3eJvJdSnFmvSoaxEj/sLg4wScY64+d02XxXjGnPRgsuwio45rKTTGWKhCX+3h2k1xbfB1wu7GSSYJ1q3JsdjKMMang1+U33dc1LpTSwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130800; c=relaxed/simple;
	bh=4e7B3gw9NVEVg04YlIjII1PGEKp5UTsGx+J/EXdAoZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGnaHUmufOvTvABqOQDD9bo+V6taudblfwJ2hwJdqvIGO2rvge+t+DdVp0+ntkM4YVrd9OWNVL/noW7RCxdH8F7SovZUEGs2iB1vgDly/IBJiS1+tUpfTr8SLGSHO9SO1LrLbQLJjNo4X17kqZODeZlZ7RKFvlvupKUgYf/ttKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bB40/XJ4; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bB40/XJ4"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-52f04b4abdcso1476145e87.2
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130796; x=1723735596; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wnb23KUTGi2kskRm2CmXuMG7AFya/4/GbJu+Fi0g2zM=;
        b=bB40/XJ4zS8z7bwu04tUsq/WAF29BwtCU2KgeKW8JkAmXbG1J/a+ClelapWQUAQ/lm
         4UBJpIkMFE76rdBSNsm9to7y0g5dATob2TGm6QGDzboTElgFUliGNdk3WhmFa0I/Nbfz
         bYbjmplNaBITPhbKziUXO/U1XFnu6ml8geMLRFCIZhil6GCSm9388WFjKw5IVjG/0ljM
         NvDX104FLdF9M+X3Ptwi37M0/Y6w85viv8rpRSO2L1RAWyVd6scuaHM1z5ngQAm9DBaq
         qosHYRzJdbOZx/aOIBny0nNylM20THvSClGkroQqzF1b9eMdvZaRLIS3H48VfTtK7b/0
         UWVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130796; x=1723735596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wnb23KUTGi2kskRm2CmXuMG7AFya/4/GbJu+Fi0g2zM=;
        b=i1HH/15quWtonT4lueckrUUPeaDom4GbFaQgo0zGyXun/QaniECZFukd9cZTmXyrnm
         knrMZ9wlzwCO9HzXNX2s+yoPrxupAmRA5GSp7wzN4YquDHYdjfzVFqUqAlBVDuo4ShZp
         hteFBTrrt4q0e4pGgMqoga4bWY5Z+DtQiYMK+AuPVbL3ynP+NpKE30FfExYuBXN+eZ+p
         6h2vApur34j1dcyFvWIQoMMCqEECzbadbXEDi4s8w5jGF3ia2ZYDF1LejtLAdBhlZn6M
         jaPCcWwoRI1DPAUxiyxTeQZEd2/RsxCz56/Lc3nKaGFMm0BOowDnAhfK18XSbORRIRoV
         BTjg==
X-Gm-Message-State: AOJu0YwT9otz6XlKsZnpentIzksxiDi7QvB6Q+UD4pWbcY5hMs9GVe+r
	goSbVqIz4pJICQcZLUpPlbW/SW7kzaD+FLMcoBkQURGQSqDcxPAageEW5onOoAg=
X-Google-Smtp-Source: AGHT+IE9s99cRohOvpvWphP8HtrEez0i0zPI9NfaWMH3qW/6ZuVifjuQxWgf2EBupyIh+4VR75bsEw==
X-Received: by 2002:a05:6512:68b:b0:52c:d76a:867f with SMTP id 2adb3069b0e04-530e578fbc5mr1623749e87.0.1723130795546;
        Thu, 08 Aug 2024 08:26:35 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9d437easm753193166b.139.2024.08.08.08.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:35 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 02/41] libmpathutil: avoid extra memory allocation in print_strbuf()
Date: Thu,  8 Aug 2024 17:25:41 +0200
Message-ID: <20240808152620.93965-3-mwilck@suse.com>
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

Instead of allocating a temporary buffer with vasprintf() and copying its
contents to the strbuf, try to print directly into the strbuf and use the
return value to expand the buffer if necessary. This saves a memory
allocation on every invocation of print_strbuf(), and thus reduces the
likelihood of failure and at the same time increases efficiency. We need
an extra call to vsnprintf() if the buffer must be expanded, but vasprintf()
will need to re-process the input internally as well after determining the
required buffer size, therefore this probably won't hurt much.

Add some more tests for print_strbuf() to make sure this works as intended.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/strbuf.c | 23 +++++++++++----
 tests/strbuf.c        | 68 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+), 5 deletions(-)

diff --git a/libmpathutil/strbuf.c b/libmpathutil/strbuf.c
index e23b65e..6e53c3f 100644
--- a/libmpathutil/strbuf.c
+++ b/libmpathutil/strbuf.c
@@ -196,17 +196,30 @@ int print_strbuf(struct strbuf *buf, const char *fmt, ...)
 {
 	va_list ap;
 	int ret;
-	char *tail;
+	size_t space = buf->size - buf->offs;
 
 	va_start(ap, fmt);
-	ret = vasprintf(&tail, fmt, ap);
+	ret = vsnprintf(buf->buf + buf->offs, space, fmt, ap);
 	va_end(ap);
 
 	if (ret < 0)
-		return -ENOMEM;
+		return ret;
+	else if ((size_t)ret < space) {
+		buf->offs += ret;
+		return ret;
+	}
 
-	ret = __append_strbuf_str(buf, tail, ret);
+	ret = expand_strbuf(buf, ret);
+	if (ret < 0)
+		return ret;
+
+	space = buf->size - buf->offs;
+	va_start(ap, fmt);
+	ret = vsnprintf(buf->buf + buf->offs, space, fmt, ap);
+	va_end(ap);
+
+	if (ret >= 0)
+		buf->offs += ret;
 
-	free(tail);
 	return ret;
 }
diff --git a/tests/strbuf.c b/tests/strbuf.c
index f8554da..d7d4cd9 100644
--- a/tests/strbuf.c
+++ b/tests/strbuf.c
@@ -279,6 +279,71 @@ static void test_print_strbuf(void **state)
 	assert_int_equal(print_strbuf(&buf, "%d%% of %d is %0.2f",
 				      5, 100, 0.05), 17);
 	assert_string_equal(get_strbuf_str(&buf), "5% of 100 is 0.05");
+
+}
+
+/* length of string is not a divisor of chunk size */
+static void test_print_strbuf_2(void **state)
+{
+	STRBUF_ON_STACK(buf);
+	const char sentence[] = "This sentence has forty-seven (47) characters. ";
+	const char *s;
+	const int repeat = 100;
+	int i;
+
+	for (i = 0; i < repeat; i++)
+		assert_int_equal(print_strbuf(&buf, "%s", sentence),
+				 sizeof(sentence) - 1);
+
+	s = get_strbuf_str(&buf);
+	condlog(3, "%s", s);
+	assert_int_equal(strlen(s), repeat * (sizeof(sentence) - 1));
+	for (i = 0; i < repeat; i++)
+		assert_int_equal(strncmp(s + i * (sizeof(sentence) - 1),
+					 sentence, sizeof(sentence) - 1), 0);
+}
+
+/* length of string is divisor of chunk size */
+static void test_print_strbuf_3(void **state)
+{
+	STRBUF_ON_STACK(buf);
+	const char sentence[] = "This sentence has 32 characters.";
+	const char *s;
+	const int repeat = 100;
+	int i;
+
+	for (i = 0; i < repeat; i++)
+		assert_int_equal(print_strbuf(&buf, "%s", sentence),
+				 sizeof(sentence) - 1);
+
+	s = get_strbuf_str(&buf);
+	condlog(3, "%s", s);
+	assert_int_equal(strlen(s), repeat * (sizeof(sentence) - 1));
+	for (i = 0; i < repeat; i++)
+		assert_int_equal(strncmp(s + i * (sizeof(sentence) - 1),
+					 sentence, sizeof(sentence) - 1), 0);
+}
+
+static void test_print_strbuf_4(void **state)
+{
+	STRBUF_ON_STACK(buf);
+	const char sentence[] = "This sentence has a lot of characters, "
+		"which makes it hopefully longer than the chunk size given by "
+		"the constant \"BUF_CHUNK\" in libmpathutil/strbuf.c. ";
+	const char *s;
+	const int repeat = 100;
+	int i;
+
+	for (i = 0; i < repeat; i++)
+		assert_int_equal(print_strbuf(&buf, "%s", sentence),
+				 sizeof(sentence) - 1);
+
+	s = get_strbuf_str(&buf);
+	condlog(3, "%s", s);
+	assert_int_equal(strlen(s), repeat * (sizeof(sentence) - 1));
+	for (i = 0; i < repeat; i++)
+		assert_int_equal(strncmp(s + i * (sizeof(sentence) - 1),
+					 sentence, sizeof(sentence) - 1), 0);
 }
 
 static void test_truncate_strbuf(void **state)
@@ -394,6 +459,9 @@ static int test_strbuf(void)
 		cmocka_unit_test(test_strbuf_quoted),
 		cmocka_unit_test(test_strbuf_escaped),
 		cmocka_unit_test(test_print_strbuf),
+		cmocka_unit_test(test_print_strbuf_2),
+		cmocka_unit_test(test_print_strbuf_3),
+		cmocka_unit_test(test_print_strbuf_4),
 		cmocka_unit_test(test_truncate_strbuf),
 		cmocka_unit_test(test_fill_strbuf),
 	};
-- 
2.46.0

