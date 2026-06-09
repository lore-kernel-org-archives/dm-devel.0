Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CA725B0A6
	for <dm-devel@lists.linux.dev>; Tue,  9 Jun 2026 00:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780965172; cv=none; b=TcYZknJ5aFCSx10K/vE7tIp0bvULtTl7CofY8gr3C7H+l0IjelHKh40ySEgpGelQ+kxXtnot9z/tLtcp/PZm8ePi4IO68Y1KbpH7xADvvHEauz/OoBH9wdFoVWeRzrd6zpgZty8QOgx1S/cf37eqxdQbxC5WdlLfkwtC49c8nEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780965172; c=relaxed/simple;
	bh=12qo26QLwXtAF3snKG2s6/0k+PDrlOn8y3/il8gtTjk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IBd/56wmK0rspQRiwOnokwazFWJGF0Xq4R/fJwZ1S/mKivpIzd5DPTFYw4sjAzQl/3cFWppB07Ft4LGbEFPAfcgldTMKxBod65uXu4QSgpn91AXeFOjPM7Bma68OB27yhcmCDF0+Qi7yxidzvhio+681l0txGtG82QqN7CZmdwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=Ij5WYpbf; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="Ij5WYpbf"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-9157d3f2098so597160985a.3
        for <dm-devel@lists.linux.dev>; Mon, 08 Jun 2026 17:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780965168; x=1781569968; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AFwf3uyc/ZuUNXG/DfTkDqfrRlS3am+QnStLEJYMs00=;
        b=Ij5WYpbfLmjwPfzObKpP987lKSmZh7nfK1dEEFX7oU08+NLop4WEee1qz8TLF0OK4J
         sX5x6/Z07VJjMouFIzKB3yviZkD4LxD26Zf0q0ZdoVREfq3EzNmJaUY+Ow0ugc/39w1V
         EBCh4fxESkN/BJEbyHduJvlrDi0FMBmsD9nR4PFrYLS7JnYGz/o9mNdEge8kACj2Otdb
         MMH1Zf3T+nSxJZdpfeJzOFF4wPaOU6IPtE5A8vkzH9G4ZkX4nP6+RChLMSGyfJJ2ApaR
         xTYZ6X1hZS/NHA1fOBGR/Ooge0ChdS3YQaTK9KwwQyH1MM6nLCTxNsTgtev5G0eCNlM2
         bpNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780965168; x=1781569968;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AFwf3uyc/ZuUNXG/DfTkDqfrRlS3am+QnStLEJYMs00=;
        b=Rr8vTxuF3PS3yXPb3yiIE0AEcmfZYeeXvexMFuBRviQiw9A9nfmeav+p6qKm9/YPIW
         79pq8NGjVJlj5djfa+S3Q/gj53xxIX84TdIhWUPA1KVmNqFPQgvopTtflJwLjSuUaLDm
         EHf7gV0GUj8JBKbDLmGX/6L7SuvVWMDgrODawwy96AQpZIw2Bzl5RhCxeQEnjjts/OSH
         vNO3f25e7jGJxEdDvzN/5KXpxc3i6l2VQnEJhaxAr+o+XVffFAOv6Ysp51lkaGYwfJu2
         N31q7pHWhwlxFWKsq9gsi7OD1twS90s32LaZrzR8PYDgGqGfY45OP+d6/W2T7ZhqQ4QR
         4I2Q==
X-Forwarded-Encrypted: i=1; AFNElJ9Yq3kjK0qBCFku3Aiw8frR434dw/1n1YRIdTVdzAijd/sMKfsPEh2SCC3mFsNwR+EuhLQJyjYXsw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxN4NER17RNGFBp6SiVDP3NfnVMfQXp/Z9I3I50Tq5s7vamXpYG
	YqofEVHg7qFEnY8JpW8f1S3XN6m6zHgM/VsvscRKVWXqLZY3Uqdbz9W/OA/778qgSUA=
X-Gm-Gg: Acq92OEGJqwevP+LZFcMM+49jjkxJ+mjSA87XLb1jdOhdL17vpq/TgUYR4V2P8cShv3
	C/7wSCt600y3dheLOQAZadZLpPGySKnYCB/x1jkr4j37pfDD2sAHLyYlPzc6lcJ4UYJL8OUq1S9
	Ge3PCkoKwNHOBM0M1FTEUNI/R2mB7peV5pbbaisLd0DnL1Lx45u30/hV54lD7qE1KQsx5hb62ZS
	qUpAkhbL6Qm/1O+4hDw35ORpwfexLjfj4VzLoJaU+vX052S10YgAOdIR0JuQBN43zYEMfb4F9yx
	RPYuIfypMnovJKn0b5AasDBBfaujDuBhfqLutjZxY6uxc4D2p1kr2AQcBrcR+8XwsUf9lRppuYi
	Qb5EwrCM2YQ+wMGua17JLr/2YefBsjIFy8oz0KEaorDIY4+hCDzfLpd/mTCXp81EQz2OEaNzL8a
	xS5do9l+KwFHGdIM7Rx/TVsNIjYQjrM/JUP7UKUQ==
X-Received: by 2002:a05:620a:17a7:b0:915:df81:ef8c with SMTP id af79cd13be357-915df81f1cfmr536041785a.33.1780965167878;
        Mon, 08 Jun 2026 17:32:47 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-9158a37c50bsm1944306185a.24.2026.06.08.17.32.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 17:32:46 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: Alasdair Kergon <agk@redhat.com>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] dm switch: reject overflowing set_region_mappings fields
Date: Tue,  9 Jun 2026 00:32:43 +0000
Message-ID: <20260609003147.1237154.c298846454f9.dm-switch-set-region-hex-overflow@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

set_region_mappings parses hexadecimal fields from userspace and then
stores them in narrower internal types.  Oversized values can wrap
during conversion and update a different region or device number than
the one requested.

Accepting wrapped control input makes the mapping table state depend on
truncation rather than on the value userspace supplied.

Validate parsed fields against the destination type before applying a
region mapping update.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
 drivers/md/dm-switch.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-switch.c b/drivers/md/dm-switch.c
index 5952f02de1e6..c6534686807e 100644
--- a/drivers/md/dm-switch.c
+++ b/drivers/md/dm-switch.c
@@ -358,17 +358,23 @@ static const unsigned char hex_table[256] = {
 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255
 };
 
-static __always_inline unsigned long parse_hex(const char **string)
+static __always_inline bool parse_hex(const char **string, unsigned long *out)
 {
 	unsigned char d;
 	unsigned long r = 0;
 
 	while ((d = hex_table[(unsigned char)**string]) < 16) {
-		r = (r << 4) | d;
+		if (r > (ULONG_MAX >> 4))
+			return false;
+		r <<= 4;
+		if (r > ULONG_MAX - d)
+			return false;
+		r |= d;
 		(*string)++;
 	}
 
-	return r;
+	*out = r;
+	return true;
 }
 
 static int process_set_region_mappings(struct switch_ctx *sctx,
@@ -389,7 +395,8 @@ static int process_set_region_mappings(struct switch_ctx *sctx,
 				DMWARN("invalid set_region_mappings argument: '%s'", argv[i]);
 				return -EINVAL;
 			}
-			cycle_length = parse_hex(&string);
+			if (!parse_hex(&string, &cycle_length))
+				return -EINVAL;
 			if (unlikely(*string != ',')) {
 				DMWARN("invalid set_region_mappings argument: '%s'", argv[i]);
 				return -EINVAL;
@@ -399,7 +406,8 @@ static int process_set_region_mappings(struct switch_ctx *sctx,
 				DMWARN("invalid set_region_mappings argument: '%s'", argv[i]);
 				return -EINVAL;
 			}
-			num_write = parse_hex(&string);
+			if (!parse_hex(&string, &num_write))
+				return -EINVAL;
 			if (unlikely(*string)) {
 				DMWARN("invalid set_region_mappings argument: '%s'", argv[i]);
 				return -EINVAL;
@@ -429,7 +437,8 @@ static int process_set_region_mappings(struct switch_ctx *sctx,
 		if (*string == ':')
 			region_index++;
 		else {
-			region_index = parse_hex(&string);
+			if (!parse_hex(&string, &region_index))
+				return -EINVAL;
 			if (unlikely(*string != ':')) {
 				DMWARN("invalid set_region_mappings argument: '%s'", argv[i]);
 				return -EINVAL;
@@ -442,7 +451,8 @@ static int process_set_region_mappings(struct switch_ctx *sctx,
 			return -EINVAL;
 		}
 
-		path_nr = parse_hex(&string);
+		if (!parse_hex(&string, &path_nr))
+			return -EINVAL;
 		if (unlikely(*string)) {
 			DMWARN("invalid set_region_mappings argument: '%s'", argv[i]);
 			return -EINVAL;
-- 
2.43.0

