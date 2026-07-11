Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437F8625
	for <dm-devel@lists.linux.dev>; Sat, 11 Jul 2026 21:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783805557; cv=none; b=n2Xq1CZ7glEYe0JZ32KYTxHE8TbGYzAEjs1xbp4df54SsL1DP6GHBMDS9TWDkIH4AMbvJDbAdVmbEO/jHdR3lUsqzulas4NeL+9z0nAXy3FoA7YQUBF1SP/hUFY2PYtcWcegn9CWummUYD/lOb2Jm0yvl+OPr6tg66eryLgGhO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783805557; c=relaxed/simple;
	bh=whHC7evA/Rki95/reKmWsGL3Q0GMWVKXtGV9avTnHqM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=owjZRn39H2UfO9liHHrz7R42skv/ycpNzB0yHMXn+vJnY0v+Hqz1njp6ZxWSzKXp+zTGMse1vR2ye64agNJabgdyvM92zGazqDWHNah2tdtO9GEjLaeO5TsWJEWWUzIvwgCCuCyN9WtVWq7H5EI9l+Vmx2rNnQIeoYtlptyDr8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=joQcgwJS; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="joQcgwJS"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-92efc443c61so36567185a.2
        for <dm-devel@lists.linux.dev>; Sat, 11 Jul 2026 14:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1783805554; x=1784410354; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8UqbOjw1q3tH4t8WYE4rrBWgeX7dwDK+/vr1kT1JA74=;
        b=joQcgwJSIaVL6jn4kqALWDJNKTyQTZulXG3Epc3nLKd3QZQaAZ4e5YpAitpKn8bOa5
         ocQ4JmbG81ystlws5mb+PoFjaWJpzI02PnHH4gbJOUebl7GMmae++wHqAAbEDee9Mw1G
         8XriUwl6GBoNsMBLYzlAOBpI8jACwRiTwk/RPMFAXsvexQJuNNcX37cJ0TBotX06NiBh
         kcJvq9OvIBVZjcgF1G6uwe7GHSpMwmrrugdh6xdTrcvfhjG44XDVxV4WJVhWWv3wCWY0
         o2DzAnKCxtHX/f7UXoAaGMZOs+q3uqiPrnQosq0uXjXnm68BngFvlv0ZQTV4aCa9/jI9
         wp+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783805554; x=1784410354;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8UqbOjw1q3tH4t8WYE4rrBWgeX7dwDK+/vr1kT1JA74=;
        b=Kd5VOJI/FnytTyEOtIX+/akCFF4vBXBhRNQ2Nokefnx4RFCG4Vy2/S4t6J3UpUEWwc
         s17GF/CkhPu4+K2wHgSxhWU0MIn0atTaTHcXLwGz3bfgxhwj3IGGz2j7qSRUJSDATfsU
         TwLxohThnzOWVM3JxSneAeyXop8jy8JMoBG/NThDaAFYfPE/w5n23ptPr6jo+M3fRiW8
         wsRNnGI+OszgLW2xAEqNmhmqTVNEk0lL1SuNd/X5H4tzMBTdDmiFk9xla3HucM4nDkBb
         s0nfClTCGkHhNsCfLOVXHZixt6vIZdIqlyFyK5dXL1BIiJrPMWdEyk1RPd4f3xfpzOHp
         za8g==
X-Forwarded-Encrypted: i=1; AHgh+Rr6GKUP12IeOG6fyzUyM6Wx+2T5FYh764jgPqQpN9xqeB7qibsguZeEke/OZIWOt/bRzTO0xPQqzg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzo6ZmdZe0xAtlCzAQ8RT4YKPqokD7y2Jt9TvuW5XyDBeD8k1BN
	xwxssITTeixcv55RaUanVXCuUrsXvcldK1IzPYTJsnqb2wkRVq9lLCjFxw0UawBrI6A=
X-Gm-Gg: AfdE7clvoz+LrgOLBSOcLRVJDTyeHfPnlcaI3fBSXUmo1B4CP9r0kjH3HINgv3StIIL
	kP8MJO0Z3xSsv9uEW7GdYQSj5eKLgKc6MtiPz8FJvKRvqtjSdQ77AWzxznhxCukIQAlojCu9Qk3
	0J1Bg8Q6FgmOEF99nCHkSf82hpOINHqyrNVLxlh+ld3O/tsUOpBOivehwJIJcUBLqZKvvreiUih
	6Mf5Hcixq60N0sN/iAaiV7MHr7i6G0MbjKKOfye/cJHu3wXVlEI0XuhvMjxHOyD9U8j3k6lwNXV
	NkOORekUYt8UnfX3HcGMGpDe9syC+I1JdSIRtGe89NQOHlJPdInI33OiYXkJlHcoS3o9Qtm0MB2
	ZKDdE+bpa+gq8GDKqeTjrq2C9KcPq5qQKYM3mgfqcvInU7gQhtNjN4mZiTuiW4RFbBKjItdYLdo
	O+3Fw5kxUCzx8ePF2b
X-Received: by 2002:a05:620a:29d3:b0:92e:c118:18b0 with SMTP id af79cd13be357-92ef2cd2b9cmr419919185a.79.1783805554202;
        Sat, 11 Jul 2026 14:32:34 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-92ee5b492ebsm554484185a.9.2026.07.11.14.32.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jul 2026 14:32:33 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: Alasdair Kergon <agk@redhat.com>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3] dm cache: parse invalidate_cblocks with kstrtouint()
Date: Sat, 11 Jul 2026 21:28:54 +0000
Message-ID: <20260711212849.92086.ae319593b1e2.dm-cache-invalidate-cblock-truncation@trailofbits.com>
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
Changes in v3:
  - Parse begin once
  - Keep happy path unindented
  - Print rejected token when parsing fails
Changes in v2:
  - Now splits in place and parses directly as u32

 drivers/md/dm-cache-target.c | 54 ++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 097315a9bf0f..3c08c12dee21 100644
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
+
+		r = kstrtouint(blocknr, 10, &e);
+		if (r)
+			goto bad;
 
-	if (r == 1) {
-		result->begin = to_cblock(b);
-		result->end = to_cblock(from_cblock(result->begin) + 1u);
+		result->end = to_cblock(e);
 		return 0;
 	}
 
-	DMERR("%s: invalid cblock range '%s'", cache_device_name(cache), str);
+	result->end = cblock_succ(result->begin);
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

