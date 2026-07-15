Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390592C9D
	for <dm-devel@lists.linux.dev>; Wed, 15 Jul 2026 00:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784074913; cv=none; b=LgfTY4gqO7XdjnDuhuresvgVnLPGuMAD59X4TdRWu6pOcwS9aMfBQZaWwFpSi/Gp907OAzYDDxvBas75KBy7MW5DjahZmBrvuA5aEoY15SEtH+1xkJHPtP9VqE4/EIiVfDP8ecQ4P0zK8YWgmOadA4fug5+wjWCQvKsPX0dG5bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784074913; c=relaxed/simple;
	bh=+Ej0yWAkIzxg6jR263cUw7NoNpTqTV4Jf2uhAV0+bSo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MFOx1/SUrM6uHvtk6zAyUsIB3LKwm+5oKrF3peyLiwu9taaSUuMEY54CcX/A9eeSXwXMEKh9gI3GgyuzL6BL53EY0Iz5oPrRmVULtHa5moQGVkco33So4AZuU3HB28X8MMI6cBXbza9kOHZJ0fZmX7ZcOWQ3+Un6FqGeM9Z5s0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=efRSEVJQ; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="efRSEVJQ"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e5cb052edso124707985a.2
        for <dm-devel@lists.linux.dev>; Tue, 14 Jul 2026 17:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1784074911; x=1784679711; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RCq2iFN/h3l5vh2Le11+ucgCQwP94+t4rJW/GMr3YAs=;
        b=efRSEVJQ/LjUJwIEUmZZ+T/90KNTicf2lJW3ix5/xXSi5vF/9efDjcCUXfr/75llal
         tuaY/bFGtLNQqhuSdrx/1YvR/q37i+1Err5jXQNGP7ARE5PIT3W9LME5fhljc5MRM9e7
         5AYHJ+W6j50eK3r/qHpH1xhp8s2EJBEagqzqSi+3hR6ljdU/fEAzr96sLUqVmpzJx02W
         TG7qy2hyM8OvXvg7Y+THGI/lwodzL30+k8xwsQioGg+qOERMolo/XsVwFaeSf36n2LAc
         EzRiSgxYb8/pKGwHfUAuhvgLJr/XVzsUhgk536rfJutOOoB6t+5mZFAQPU7TN6I6Vg9x
         wQqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784074911; x=1784679711;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RCq2iFN/h3l5vh2Le11+ucgCQwP94+t4rJW/GMr3YAs=;
        b=OCki7ZCcfvkBOFe/3SYqNDzUIPUkW5G/+RW0eLZmmqB60Ki2vUt9zR0qaNDe3CIFZW
         QfVDBzoSrPTohsuGJATaGrWAuoaSGBGC482URcpOpPVrQ2SL/Y6YHWoUgihimK+2ayUf
         bwKloPfx26bcRLCqrAm3PIKy48fOT5KZgqdRCFHsITI7LeDb533L2FLhz6ztylJb2bow
         GSbc4GB/WQPiV+7Q9McZ1eZrFIBvuFm2SuxXwMcz2sUAfZDMx5+gzpgvx01DQuf++jnb
         IshnCsTofdIaN7/cWWJ4+nHpZtf6XTTdpBfwn9P07+SgrrbU6tOhNuuiIctKOq3Xbl/y
         pctA==
X-Forwarded-Encrypted: i=1; AHgh+RoABt/EpDkhTXvb5uUWww3DlznlmHoAOUpkMzRvJGX3/LAt26kZ7K7qalpT72ElAKshwbUq0/wHvA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyk+XQ2mfPtT5a5T10Nel6eHhPfDvNp1461+Gd77cSqkZIbehto
	X+xt/2o+vX2oXvMioNayZoXaT2V3RybdCg1ny9ocnpVTuq49kdSHseIUvbPoTLyK/Ws=
X-Gm-Gg: AfdE7clvrY2Hgx3VXgw89KzLvItMHFOXjQ4cW5N796kxtH3GzQeh/bl4MbbP6nRrUGq
	PDcsHDAurOrxBLS3Jj+t0gKn/jY+CtBhlAYOQ94Vtl0tSY+v5PStcc6/pHrErqRkWNZJP0LvRDx
	MnKn1gWIH7PgQU1MyuI0xNx5t23qjXOpf4mqrQ/wHnudDmUpNGRREGx3PkxUYCYNkYUTtDLU3OE
	kJAW4F/WkrF0BTO7BBmCbtdHaApD1noujIwtkg5iITsNgt6sWVWVSiiro8QnOQ29XJqCsS/0ZCP
	G3KHR3IWIswqE5UFfLN+IDV5MBNoXwGiQa4aKufZiVlS81nyuxZPeu55FrXGtlmmtCcXcwc65on
	HM0Q+3XurRkOwEiTdJRuDeNrSjy6L9Vk9d/RyxaZLTqhPOGBmo7vTSYrqMUk0p+Tueyc/0j2qyD
	vlp6fnTASsvGnEgoCO
X-Received: by 2002:a05:620a:4505:b0:91c:ac0a:690b with SMTP id af79cd13be357-92ef2aec978mr1500667885a.17.1784074910958;
        Tue, 14 Jul 2026 17:21:50 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-92ee5b4a0c0sm1704368685a.6.2026.07.14.17.21.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2026 17:21:50 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: Alasdair Kergon <agk@redhat.com>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4] dm cache: parse invalidate_cblocks with kstrtouint()
Date: Wed, 15 Jul 2026 00:18:00 +0000
Message-ID: <20260715001755.123939.f196d094e808.dm-cache-invalidate-cblock-truncation@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

invalidate_cblocks parses cache block numbers with sscanf() and then
stores them in the narrower dm_cblock_t type.  Values larger than the
cblock representation are truncated before invalidation, so a request
for one cache block can invalidate a different block.

Checking the parsed value after sscanf() is not sufficient because
sscanf() does not reliably reject values beyond U64_MAX before storing
into the destination.  Such inputs can still be converted to a wrapped
u64 value and then pass a later range check.

Split ranges in place and parse each single value or range endpoint
directly with kstrtouint() instead.  This rejects malformed values and
values that do not fit in dm_cblock_t before they can be converted to
cblock values.  The existing range validation continues to reject empty
or out-of-cache ranges, including the single-value U32_MAX case whose
exclusive end wraps to zero.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
Changes in v4:
  - Make range vs. single-value case differ only in how result->end is
    computed
Changes in v3:
  - Parse begin once
  - Keep happy path unindented
  - Print rejected token when parsing fails
Changes in v2:
  - Now splits in place and parses directly as u32

 drivers/md/dm-cache-target.c | 56 ++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 097315a9bf0f..33dbc71b730f 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -16,6 +16,7 @@
 #include <linux/dm-kcopyd.h>
 #include <linux/jiffies.h>
 #include <linux/init.h>
+#include <linux/kstrtox.h>
 #include <linux/mempool.h>
 #include <linux/module.h>
 #include <linux/rwsem.h>
@@ -3311,42 +3312,46 @@ struct cblock_range {
 	dm_cblock_t end;
 };
 
+static inline dm_cblock_t cblock_succ(dm_cblock_t b)
+{
+	return to_cblock(from_cblock(b) + 1);
+}
+
 /*
  * A cache block range can take two forms:
  *
  * i) A single cblock, eg. '3456'
  * ii) A begin and end cblock with a dash between, eg. 123-234
  */
-static int parse_cblock_range(struct cache *cache, const char *str,
+static int parse_cblock_range(struct cache *cache, char *str,
 			      struct cblock_range *result)
 {
-	char dummy;
-	uint64_t b, e;
+	char *blocknr = strsep(&str, "-");
+	unsigned int b, e;
 	int r;
 
-	/*
-	 * Try and parse form (ii) first.
-	 */
-	r = sscanf(str, "%llu-%llu%c", &b, &e, &dummy);
+	r = kstrtouint(blocknr, 10, &b);
+	if (r)
+		goto bad;
 
-	if (r == 2) {
-		result->begin = to_cblock(b);
-		result->end = to_cblock(e);
-		return 0;
-	}
+	result->begin = to_cblock(b);
 
-	/*
-	 * That didn't work, try form (i).
-	 */
-	r = sscanf(str, "%llu%c", &b, &dummy);
+	if (str) {
+		blocknr = str;
 
-	if (r == 1) {
-		result->begin = to_cblock(b);
-		result->end = to_cblock(from_cblock(result->begin) + 1u);
-		return 0;
+		r = kstrtouint(blocknr, 10, &e);
+		if (r)
+			goto bad;
+
+		result->end = to_cblock(e);
+	} else {
+		result->end = cblock_succ(result->begin);
 	}
 
-	DMERR("%s: invalid cblock range '%s'", cache_device_name(cache), str);
+	return 0;
+
+bad:
+	DMERR("%s: invalid cblock range '%s'", cache_device_name(cache), blocknr);
 	return -EINVAL;
 }
 
@@ -3377,11 +3382,6 @@ static int validate_cblock_range(struct cache *cache, struct cblock_range *range
 	return 0;
 }
 
-static inline dm_cblock_t cblock_succ(dm_cblock_t b)
-{
-	return to_cblock(from_cblock(b) + 1);
-}
-
 static int request_invalidation(struct cache *cache, struct cblock_range *range)
 {
 	int r = 0;
@@ -3405,7 +3405,7 @@ static int request_invalidation(struct cache *cache, struct cblock_range *range)
 }
 
 static int process_invalidate_cblocks_message(struct cache *cache, unsigned int count,
-					      const char **cblock_ranges)
+					      char **cblock_ranges)
 {
 	int r = 0;
 	unsigned int i;
@@ -3460,7 +3460,7 @@ static int cache_message(struct dm_target *ti, unsigned int argc, char **argv,
 	}
 
 	if (!strcasecmp(argv[0], "invalidate_cblocks"))
-		return process_invalidate_cblocks_message(cache, argc - 1, (const char **) argv + 1);
+		return process_invalidate_cblocks_message(cache, argc - 1, argv + 1);
 
 	if (argc != 2)
 		return -EINVAL;
-- 
2.43.0

