Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435453A8750
	for <dm-devel@lists.linux.dev>; Wed,  8 Jul 2026 00:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783471751; cv=none; b=CXoZY1q/31lrlyxlR+EYwGKUr8dxncgHS5Dccmb8EXrCbcldsbdjnrWsbwczfy5Jt3sLJ5pAUSfiG4kRXLXUu+IEaL3sXub2p12oc9XE8ekD+I8LFN6du/zFEijnPvDbVBRvd3e99O4oMTeEXSBiuyOG/ITLJcw8fW5BfjhwEp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783471751; c=relaxed/simple;
	bh=ulbOD7yylVco/Hx4bRVIvt4k09QRO2GvPMtYRW9x4qk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kAR9YV9EWqmJnW/BEs+Ac2fPLxOO0G9sJSzfVVXqsFv/iErmRCCjTqSlTGMnbo4hv7I9kdNVjylsuJQBoSoCp0/2zW0SNdy0OKV2YbHozZQeszDoL6ogeMWdgisdKs61vIhBC7HNzlZlfGgUkr/2H/H+EGPM/f/OpxH9S4efgO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=dSARQJpw; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="dSARQJpw"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92e6a434cabso2785585a.1
        for <dm-devel@lists.linux.dev>; Tue, 07 Jul 2026 17:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1783471749; x=1784076549; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kKbQeoRiUpzNN5I9X3E/rXBPWFTpJKoJEZNhFMPNgYo=;
        b=dSARQJpwLReSOBkgLKk/mxSWfG2SFghgSEZxL5CSJf1IyjJG7dPZXE69BaSy599mF3
         3d+FTyGlgkR7767tVVFir6gkQXj63mKcH1j1ZFwN43205dTtF/+qmn1muLjvUmlw3b/6
         oy61WTk+1pXSyupOYxaqVc/hUncnWMTsh/E0OCv3mia9zXuisCnWM/SDZnPg0QzPckN/
         dRbbQzEdurA4pBgqTb3KAiPGQGrJLQzFslSjJH0+N4lCZakePCcNbxkiwGbWukl0m0zM
         /FLC3a0ESdPHVhlXL10Gri9jJ9pZBviXWt84wwmNXrIDyYSY5/uoj5R7sQVYnbH5P7C6
         q66w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783471749; x=1784076549;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kKbQeoRiUpzNN5I9X3E/rXBPWFTpJKoJEZNhFMPNgYo=;
        b=rtX8MLFmKlbpsu509KXSrfxNlPPxw7F2MDV73U6OGsN/D+o6NoCSzGWiBX3PXeH7M+
         nEQKOgc9gMk98uFH+Li1NjVVm/Zepjxl18khFWb4aKoPf83zxcg9fzkqzwB13wDg8eCX
         ytCb2Vc40y6u0fGoYgDbr75IddzX79UJrD25zWnk5ZKLDz9NbL4nCtmpblxfjLL3TAcS
         KKuTQVJi95D19Qws86TWQ/1vT0T5z+IxDhA4XqgqCz8d3r4aZGLkYLv9WQ3jfJt8Pid5
         LzkLEo7JtfkKcGkaaFPz87VwIeAl2qlyhTI2u6fY2d8mVdaS3PK5ZBbxZyG5ntdE1bf8
         C5+A==
X-Forwarded-Encrypted: i=1; AHgh+Rp3BPjeVN/Vfk6WZ2IDOR0sWZGUKasJ2sJkXeFJWtk4R4pe0u/gvcNk7gSjuBc0W8g+FzOd4ps+kQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxgegIT3s1NLi/Dkm39xfI3J/dq0DI3iCdFmksYNj/qYhoRFmY4
	H4mT+KANyb/LCW2ofF43efP1xAHACgzLNqCavssLG8BsXluyJYUUREQkx96fBETKWvZhHmUpU3q
	vlsFF
X-Gm-Gg: AfdE7cnUWQSeOj1HFezbqFIm5SGhE5DoxT8grA54v1gkauxmRkW+OVJljuNX/YQwriH
	U86wvTMXMZIv6zsUjlmtldsPAH2CZ/zrUqhoneMKjcDxr6mqtwRK8DoKNn4EebOYzMsBW8/jqPf
	NzjGvb6BzznyOUQTSUqqo/VEbLqq5Uh7vvf9UW+ciCf4j/ed4/EiFm+eym6WcfSTujmZobnixEG
	2dSJ74iMcb40tOUdax/KzNdk39wBBxmCx/TNhINvmIFLORO87vqmLd7KnTKAZVDo5JPTj/dPrpy
	EbMULdZroZVKZy+4EePzRg7DfhXTasI+jjTzmvQgTcU22W0dnNhpAB2Whehu7brT8LHxnV5lcUW
	QkOHN00qvN6thysL5CTN/IyG+GAxHTTSf1OQHj08u9huNEnRyTTIIeXgdEhulVqlLGUBWcEnC49
	iKAddUGaF1mDIRDnwN
X-Received: by 2002:a05:620a:1a22:b0:92e:5fe2:fd35 with SMTP id af79cd13be357-92ecf5fa0f2mr19040785a.32.1783471749170;
        Tue, 07 Jul 2026 17:49:09 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-92e90c92662sm1249123185a.30.2026.07.07.17.49.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2026 17:49:08 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: Alasdair Kergon <agk@redhat.com>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] dm cache: parse invalidate_cblocks with kstrtouint()
Date: Wed,  8 Jul 2026 00:46:43 +0000
Message-ID: <20260708004624.42174.39f86a755909.dm-cache-invalidate-cblock-truncation@trailofbits.com>
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
Changes in v2:
  - Now splits in place and parses directly as u32

 drivers/md/dm-cache-target.c | 48 +++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 097315a9bf0f..5fb8b10c9b9e 100644
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
@@ -3311,42 +3312,48 @@ struct cblock_range {
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
+	char *begin = strsep(&str, "-");
+	unsigned int b, e;
 	int r;
 
-	/*
-	 * Try and parse form (ii) first.
-	 */
-	r = sscanf(str, "%llu-%llu%c", &b, &e, &dummy);
+	if (str) {
+		r = kstrtouint(begin, 10, &b);
+		if (r)
+			goto bad;
+
+		r = kstrtouint(str, 10, &e);
+		if (r)
+			goto bad;
 
-	if (r == 2) {
 		result->begin = to_cblock(b);
 		result->end = to_cblock(e);
 		return 0;
 	}
 
-	/*
-	 * That didn't work, try form (i).
-	 */
-	r = sscanf(str, "%llu%c", &b, &dummy);
-
-	if (r == 1) {
+	r = kstrtouint(begin, 10, &b);
+	if (!r) {
 		result->begin = to_cblock(b);
-		result->end = to_cblock(from_cblock(result->begin) + 1u);
+		result->end = cblock_succ(result->begin);
 		return 0;
 	}
 
-	DMERR("%s: invalid cblock range '%s'", cache_device_name(cache), str);
+bad:
+	DMERR("%s: invalid cblock range '%s%s%s'", cache_device_name(cache),
+	      begin, str ? "-" : "", str ?: "");
 	return -EINVAL;
 }
 
@@ -3377,11 +3384,6 @@ static int validate_cblock_range(struct cache *cache, struct cblock_range *range
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
@@ -3405,7 +3407,7 @@ static int request_invalidation(struct cache *cache, struct cblock_range *range)
 }
 
 static int process_invalidate_cblocks_message(struct cache *cache, unsigned int count,
-					      const char **cblock_ranges)
+					      char **cblock_ranges)
 {
 	int r = 0;
 	unsigned int i;
@@ -3460,7 +3462,7 @@ static int cache_message(struct dm_target *ti, unsigned int argc, char **argv,
 	}
 
 	if (!strcasecmp(argv[0], "invalidate_cblocks"))
-		return process_invalidate_cblocks_message(cache, argc - 1, (const char **) argv + 1);
+		return process_invalidate_cblocks_message(cache, argc - 1, argv + 1);
 
 	if (argc != 2)
 		return -EINVAL;
-- 
2.43.0

