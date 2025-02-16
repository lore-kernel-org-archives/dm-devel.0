Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA2818DB08
	for <dm-devel@lists.linux.dev>; Sun, 16 Feb 2025 10:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739702551; cv=none; b=AM1fYMn5gziZA0PeBSxO0P8SQf+JaI/tz8BfUHOIRDVILLvQxM6DZFT6TOw24q8/ZQYrN35SWCVC5hhQEt4OEyVuyJPKNyoDgR3HZtVH0hnW0LdXP+OJJF/UiqaD3rADyiWB0MiIKfs1TXoaU5Dc4UcCmYItIPRvwGsXq1ntDWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739702551; c=relaxed/simple;
	bh=1u8/QRvZIAfdaS2QYst0uvhwDu/wf0BSfX6i/cR7NA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuSG96eRs9DOwcCwbb1HA/IWEmN3gqCdr8L611RvkTNHznoiXplVUetCiuZp9bwosPrDLsvDcMQyr8aEWtDrnFlc8VYWkE0aw/LPpUHEAn/Mhkj9U54s5PbGrWG3SZ6RU9OZZd8tyOcjglqD+AxRkTCCxldyHGlOu8Vz8We8M3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ld9tY9M+; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ld9tY9M+"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ab7e80c4b55so639747666b.0
        for <dm-devel@lists.linux.dev>; Sun, 16 Feb 2025 02:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739702548; x=1740307348; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tKKKFX5+mxjRmMV997r53l3FrILYg6kyCOTBHDZ2vaA=;
        b=ld9tY9M+7QYNwidFl2qXAZVxO77/Xw9Xdv9+0jbdDMQN7Qwi7vUZvzwhceANVTtbws
         vHYN2aLO67MV2xwQKyPukxvmlYrnqe+qPZy1R6P4x0cVInF8qYEZ+Bo0K+YqvOurRuep
         Ys8YwaYScMghQKrVE12jZgY+NQWRgq3p41M5wwG13n0ZoeXUXagCUzl59qWR4psw89OF
         T9e5BiyctHzkLywA+P+vpCLnsdF5cUwNiPPiEA7nG4ctWdCA6FB5V6AR8Y0EGieUDXG7
         OpH8fgq/q7TNwLmk5uWjqskRfvlE6L5w+M7KsRcb7+dnDSfxD0wY4J8hXNypediVgvS1
         Ftkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739702548; x=1740307348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tKKKFX5+mxjRmMV997r53l3FrILYg6kyCOTBHDZ2vaA=;
        b=H+y+4Bs2BIPe4BgtYtYpmVw3k6LOwX4irbRtkflnwZPzxA3X9a/dhzepJuN/iSXMCf
         VdFNO+QY6/Ai79K2Iq1mMmrKicExYWOGFVKel4lov0v0hVkel9INVummFcOvy3qRKrla
         hZuPmGYgVaduWGivG775uN6gI5rtqo4WtMqZskZRvS8GgqVbRILJ2eNyiAzyCxN7qP0v
         ZoNwQkXopHxE6kdtXtCGZo5QCfvJCWT3/Txbsz1a2S+3VElwO+PSLRWw9Kyipul5PrSp
         rnBKS19mMpfi6Zu/J39BoSYOjHXOlG769ds6Io5ogt/qWXvIZp/Q0KkxiTw9mcZAGQCU
         nT9g==
X-Gm-Message-State: AOJu0YzYJCkmJQRIhrPSz629jjbKcPIEho3AGkhBkDNVSOxYt4Ud6YR6
	dIQQWZpZlENe03CCBIUFpgIvTutup6rCopP9pc3pB18SZFxbyesh54+KjYFm
X-Gm-Gg: ASbGncuzzf4mIOZSNScPbaDUpcPGOe8pg5XHHoDtnOP8bqTwbgEnaoT1TSGk8+/bIcY
	w4xcg/Wa+xlYWFPzoHIHytZUx6QzDeknip5b6xaKEF+cE0vslKmB5EFRXb+c5RTmg0LqX9Xc+7X
	Q6SDs6qalU5onA7WtP8wC+xo7jaUj0OSsKWo4DLENPkBFa8zXgbPS458hYt7TXZfamhCTEoFyCf
	m+eSh8MjQHXi5W20eKBTMtLDFUqzy8Hk2DIGMq6Ni8G+2AjiW9LBvbmYM2sefjBiJoPph56MLDr
	xPbyj9r+6B9HnAB4Rv5vSjv+Yqpi3/HFMg/pnFABGB50O3ylqBPpi8iQOS0mT4uLSy043cFEsfA
	1QDqcAaZPcZEMh/CNzDs=
X-Google-Smtp-Source: AGHT+IHTm9RXoJVzvCSsKPfEkd7hDRszmzDsgvTx36XEqM9IjwbpdF7uRknqphU/26XUqUfl0t9g5A==
X-Received: by 2002:a17:906:4794:b0:ab7:e52a:1467 with SMTP id a640c23a62f3a-abb70dad218mr574718166b.30.1739702547437;
        Sun, 16 Feb 2025 02:42:27 -0800 (PST)
Received: from syrah.mazyland.net (dynamic-2a00-1028-8d1a-5dc6-7184-2e63-0011-e253.ipv6.o2.cz. [2a00:1028:8d1a:5dc6:7184:2e63:11:e253])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aba78ef6ed8sm422755166b.73.2025.02.16.02.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Feb 2025 02:42:27 -0800 (PST)
From: Milan Broz <gmazyland@gmail.com>
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	snitzer@kernel.org,
	Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 2/2] dm-integrity: Do not emit journal configuration in DM table for Inline mode
Date: Sun, 16 Feb 2025 11:42:10 +0100
Message-ID: <20250216104210.572120-2-gmazyland@gmail.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250216104210.572120-1-gmazyland@gmail.com>
References: <20250216104210.572120-1-gmazyland@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Inline mode does not use a journal; it makes no sense to print
journal information in DM table. Print it only if the journal is used.

The same applies to interleave_sectors (unused for Inline mode).

Also, add comments for arg_count, as the current calculation
is quite obscure.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-integrity.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 555dc06b9422..c45464b6576a 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3790,16 +3790,18 @@ static void dm_integrity_status(struct dm_target *ti, status_type_t type,
 		break;
 
 	case STATUSTYPE_TABLE: {
-		arg_count = 3;
+		arg_count = 1; /* buffer_sectors */
 		arg_count += !!ic->meta_dev;
 		arg_count += ic->sectors_per_block != 1;
 		arg_count += !!(ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING));
 		arg_count += ic->reset_recalculate_flag;
 		arg_count += ic->discard;
-		arg_count += ic->mode == 'J';
-		arg_count += ic->mode == 'J';
-		arg_count += ic->mode == 'B';
-		arg_count += ic->mode == 'B';
+		arg_count += ic->mode != 'I'; /* interleave_sectors */
+		arg_count += ic->mode == 'J'; /* journal_sectors */
+		arg_count += ic->mode == 'J'; /* journal_watermark */
+		arg_count += ic->mode == 'J'; /* commit_time */
+		arg_count += ic->mode == 'B'; /* sectors_per_bit */
+		arg_count += ic->mode == 'B'; /* bitmap_flush_interval */
 		arg_count += !!ic->internal_hash_alg.alg_string;
 		arg_count += !!ic->journal_crypt_alg.alg_string;
 		arg_count += !!ic->journal_mac_alg.alg_string;
@@ -3818,14 +3820,15 @@ static void dm_integrity_status(struct dm_target *ti, status_type_t type,
 			DMEMIT(" reset_recalculate");
 		if (ic->discard)
 			DMEMIT(" allow_discards");
-		DMEMIT(" journal_sectors:%u", ic->initial_sectors - SB_SECTORS);
-		DMEMIT(" interleave_sectors:%u", 1U << ic->sb->log2_interleave_sectors);
+		if (ic->mode != 'I')
+			DMEMIT(" interleave_sectors:%u", 1U << ic->sb->log2_interleave_sectors);
 		DMEMIT(" buffer_sectors:%u", 1U << ic->log2_buffer_sectors);
 		if (ic->mode == 'J') {
 			__u64 watermark_percentage = (__u64)(ic->journal_entries - ic->free_sectors_threshold) * 100;
 
 			watermark_percentage += ic->journal_entries / 2;
 			do_div(watermark_percentage, ic->journal_entries);
+			DMEMIT(" journal_sectors:%u", ic->initial_sectors - SB_SECTORS);
 			DMEMIT(" journal_watermark:%u", (unsigned int)watermark_percentage);
 			DMEMIT(" commit_time:%u", ic->autocommit_msec);
 		}
-- 
2.47.2

