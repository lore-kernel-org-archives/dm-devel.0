Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F213344B690
	for <dm-devel@lists.linux.dev>; Mon, 29 Jun 2026 15:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782748139; cv=none; b=i5idlicS3qgPLoZWumBxxY9N+w58f/Qn+jni5dfJ83Pe6fYnvfLqC2hHNT+A5EA3Wa3Q7qubaOJNRb6hmPzsW2QtfzIpnCTa1ZnTP0SETOCUwNMZWF9r+mErpEtbdd8PoOy6FztNAcqqVhXQv8YXTeOYeZCPhj0bfQZHZ7DmuM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782748139; c=relaxed/simple;
	bh=ZA+NSHuLcCfnVV8X5dlflD3TBkuW7gkiOxHA5k0aPII=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=swENwSfnsV8yx6fb3bRJ39uBNduDi8FqlE8tqlw4IIx1kHMa9OKn1HG0XW+9GMQE4th4SUCMt4shr6mPsLAmTmYMM3Zpmr2A+nMjPldh33KnidUvbcVnhAF/IhzFg1fylYSamg71M0rUZXp6E1wEMaBATGo7/QDvjYAAEphASfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=OKcAYwpZ; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="OKcAYwpZ"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-915ab38ac14so436430385a.0
        for <dm-devel@lists.linux.dev>; Mon, 29 Jun 2026 08:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1782748137; x=1783352937; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MykUwDfoN5ChmfDjdlQO00qBcy70IfdVFe3AWk6giuU=;
        b=OKcAYwpZrqg3zsmrUDVLCj+yU6q4+wDqPCsyg7IuYfEQFBXzClZHN1YhTznAGtp6lF
         qG5OjU5DvgUTO25VQrIkJrtsUj7QJj9BaN1trX6k0MwsGhhxhsEqWkWzQSy8AgwRL1eq
         x1Je9M9kDyLOHIqvUdcHzAeetChQ+L78dFi/PDTUnybUxKTdj45ncZqfW1w+X0BnPsnx
         xSvZ4pgwydpMHe2VA3Ark6J83Ev+zF3/DZHtAAHhKuK0uLhDWAY+0uR7uJpjqzRW7THC
         +otgpksAllNoEUZy30jtRxadl1MvNjnUDaVeIXOSKKIkDtLBEX/ZrPopKZZoS6kSZhYY
         P0hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782748137; x=1783352937;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MykUwDfoN5ChmfDjdlQO00qBcy70IfdVFe3AWk6giuU=;
        b=Q4z4fajYCzSETg/yS9ryqql8Y3WAm1lu12sYlLttqerF/MageaXEULbGxZ5XT3lMG8
         mEB87LtOZMNMdZ5yb+DnV376jz3YnbYUBlJntfp7dP6tOEQk8WsFQ0+env9aVdevKYBI
         ea0cKCIk/NGqMVU/Drr3MRK5bgMGtRKU4qrG2/Y2jCLVxFcWTFwccAajwWwJbkOTbVIH
         S9RR3x3cW5ltb/6IQ62eFjz6BcZAcaAD13Ahl7F32prvTlCBk2K2H2xKMpK+BRC+3bST
         MykjqJ31QSQauv+R2pOb1cpD04haZEuF8sgEpytGd0fnCKOcSRD3TDdrQvMd3ypCr+mn
         xK1Q==
X-Forwarded-Encrypted: i=1; AFNElJ8jbm1kdvdV48V1eVAzvl7q1VmJnlrv4FpM28z/feYdiDKHjX9XLUqz54mCkUQgRc+cJEGNISojGQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5PvAZ6ENJV2bWsW1aFkz9+ZyHERbdKu//57YxS1oSRYn1nHqH
	aoJujgo6EPGBE3MSogIlMemrfPeA3bRdN5cdKmyN/MllG65NxGEM2rKukji8czFoTNokgDMW3+7
	y4zd2cQU=
X-Gm-Gg: AfdE7cmPy3Fk6oN5yr46EYxUG6p3XOR8fANpq/slcY8g4cDDm8vXPejdBGZnUeFN9rb
	dU/bfJE2fMLs+Ow/LQ8t/uESZtj1zhe1t40L0yhmhuGSLTO2o3uQjQS32vinbOyyqC92Mgsy+xV
	eBETOtAVYsRoILpgrZE29Y3R9kUag/5IoV/7qCffoMXYgEMaMFWoDpgNZogedJkNT0OF+eRbJte
	f3mpRWG3gL2M/L45OBQZhVxI+Vcssngepboz2Sl5Rhv6OevqnAh+VUBR5ZOIjGGQVElk17xM9Qs
	GJ8t9ExbxR/p0/9iPw+vEBxZqwBf2yKhxayqTQKThy+9SOoaQrAM7nrnjLrZMspteulZGa+iz5G
	NDuQ7Dd87HbzkvPQEgFd9jKzaK2EEH5Yhcqsvc925Z+ljvT5zyT+cYny95hulkhgQPKv7svuJkg
	ODbTx80WXrwu72pM8N
X-Received: by 2002:a05:620a:4411:b0:915:c4de:7ab7 with SMTP id af79cd13be357-92e627b5366mr14002285a.35.1782748136941;
        Mon, 29 Jun 2026 08:48:56 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-92e623379easm9645885a.32.2026.06.29.08.48.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2026 08:48:56 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	Zheng Gu <cengku@gmail.com>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER PCACHE TARGET),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] dm-pcache: reject option groups without values
Date: Mon, 29 Jun 2026 15:47:40 +0000
Message-ID: <20260629154739.128526.10d4fd36508c.dm-pcache-missing-option-value-null-deref@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The pcache target parses optional arguments as name/value pairs.  A
table that advertises one optional argument and supplies only a
recognized option name, for example "cache_mode", reaches
parse_cache_opts() with argc == 1.  The parser consumes the name,
decrements argc to zero, then calls dm_shift_arg() again for the value.
dm_shift_arg() returns NULL when no arguments remain, and the following
strcmp() dereferences that NULL pointer.

Check that each recognized option has a value before consuming it.  This
keeps valid "cache_mode writeback" and "data_crc true/false" tables
unchanged while making malformed tables fail during target construction
with a precise missing-value error.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
Changes in v2:
  - Verify required arguments in a more flexible way

 drivers/md/dm-pcache/dm_pcache.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/dm-pcache/dm_pcache.c b/drivers/md/dm-pcache/dm_pcache.c
index 81c795c0400e..d5cfd162c063 100644
--- a/drivers/md/dm-pcache/dm_pcache.c
+++ b/drivers/md/dm-pcache/dm_pcache.c
@@ -168,6 +168,10 @@ static int parse_cache_opts(struct dm_pcache *pcache, struct dm_arg_set *as,
 		argc--;
 
 		if (!strcmp(arg, "cache_mode")) {
+			if (!argc) {
+				*error = "Missing value for cache_mode";
+				return -EINVAL;
+			}
 			arg = dm_shift_arg(as);
 			if (!strcmp(arg, "writeback")) {
 				opts->cache_mode = PCACHE_CACHE_MODE_WRITEBACK;
@@ -177,6 +181,10 @@ static int parse_cache_opts(struct dm_pcache *pcache, struct dm_arg_set *as,
 			}
 			argc--;
 		} else if (!strcmp(arg, "data_crc")) {
+			if (!argc) {
+				*error = "Missing value for data_crc";
+				return -EINVAL;
+			}
 			arg = dm_shift_arg(as);
 			if (!strcmp(arg, "true")) {
 				opts->data_crc = true;
-- 
2.43.0

