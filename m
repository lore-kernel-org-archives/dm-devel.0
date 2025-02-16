Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3565E17E473
	for <dm-devel@lists.linux.dev>; Sun, 16 Feb 2025 10:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739702549; cv=none; b=IouLW5apAvQMAerhGVCszBtCXeyGl3iJOXs2bzc6UffHGuSQsmAgYyC0csRGnBzUexwIZWL0SeFTSUFG325spxz48Uo8NKG3aV+Kqybpl9GOXd7Ktsp3X3Sze01EagEbecXTTlmmaCHo0vTlnu7ZYQcbYBdW+5rPcVVFKeL0l20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739702549; c=relaxed/simple;
	bh=iM7tEPV48U8WJ+hezDZwfYvVDUsqDAGnZaQFMo/SmcA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TVAdMuVacbC8271kn33z6ulV/wXj0L26w4rTBOMRBLPlHg35PlOedozyNgSPJCpD2Y5BoP9wEF5Qtg+PoS02aHHzl/aDq/UnIjIB/kOI6Glcm3znZkPQfFoz5QiMcuPVjfPs7p1hPIdekR2LefH20s6r5TwHvNlj2YNr/1MjcpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SwA0bRIj; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SwA0bRIj"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ab771575040so890103966b.1
        for <dm-devel@lists.linux.dev>; Sun, 16 Feb 2025 02:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739702546; x=1740307346; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LazUEOej5l43+bfR9AUy50EmWM7TfpervdeFxQxk4LA=;
        b=SwA0bRIjDkjdNMGPf/qNyiZTtuUa0t0nvf9W1rz8QuQlI5Bb35qdOvvBlbKPPN7EdH
         KkA3uDpkB0Yps8fHqbMmV1jTEmVkIt8Mukj38G8QU5Yf/iDTulFj7zN+MKndeWvqi8rc
         YkdqEvmsFXXRD0hEHtOc7yz7BY6nhqAWPE0piep+KNjt25W4fJ26otnzpoMhVbpJIShY
         eVP4spsaNa9M0Kc00YZ1LIWWQ/nFq1LHoNhZ13gmon9M6ObOuFv6AJVtlM5giP36regN
         WdxeN7R+OFjq8DEqRNDNvnbkMe1xHrifPLT0xHQevAg5v0hkAQEOYHHZcKTbMpuWX+C6
         d4ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739702546; x=1740307346;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LazUEOej5l43+bfR9AUy50EmWM7TfpervdeFxQxk4LA=;
        b=aQzt+yPJsgKcp2auWMjpLQO3VreyZZlYoPTpGQ22+IwZhxH35YErkyzT5++WZgATv0
         LCbHmsBs/q08nhq3NU8cLWBxwI6UNv6v1C5IIFZd/NsLxyqITt8adzgacWvjHGlowpnV
         vePQGQpLD4kaZ8fIWEiuLfpP/XHPlsC60vuRxb7wIO1OWpNsx6OTRMDcM/do7iOnhhne
         9nS969c77ik6p1W+Yom1e7dQ1CZCso4tgiB7PHmdtnRchftWSQ6KJAFQQVKbGIzcdd0p
         wj2DeFJ4SokbnSvP5lPV+2QNkqmk2xkkbpnBIf2bHXAgY8dh12/XeghD5JXAtNd6i3lV
         Pg2A==
X-Gm-Message-State: AOJu0YwKKGI/7cwMoPtv/AelJv8VN2KO5KP7OSmwQnKofiw5EI/5kKbq
	g0TL6xUzLVjv7izFPvRVhRYJfnK+cL4R9dVFotK/PwaL6shOFH8YQliFc22h
X-Gm-Gg: ASbGncvPUV0OgfGRLQTuGo9MDTFA6oA92XBZIxMJcVMWr2dHgoRuPMpvgmAaXKeo9+y
	rRW9/R2cCETEXux4y0mwrPJNHGfN2vZQwoj2HtGa0gmDmt1YVDLFWuu2tqLoyM8eOM8JB7RiNRb
	RxV2bVz+hTZeRJ/5ApCcnF09zNu7TbEmZqDYC/u2xIE4tkMzcua8T1STG3dEVEnx/DJm91YqS6t
	qvnwSVNdWXyKgNojLwqFZJQjQ9k8udopC4m5xcOdscbCEI8mRG6RbCYAnmwTrN8oHpxKF1DifMz
	w8vxHP4Tb+I/tLj2L9LloPCgrh4pdo33NBOXhs/tTQ+Bu7vtAVT1r8v4co8QDCrZYCS/4dFAtsP
	MaoBdv2G/y+iNLB5XtBk=
X-Google-Smtp-Source: AGHT+IFGsa6CU1hUaEyWwVxvCEXG7v9unr8N3BR0cdRTJKOLWeylkLU0jSqXZL/xTVSVEDqTPm07DQ==
X-Received: by 2002:a17:906:3ca9:b0:ab2:f6e5:3f1 with SMTP id a640c23a62f3a-abb70848a57mr463921566b.8.1739702546150;
        Sun, 16 Feb 2025 02:42:26 -0800 (PST)
Received: from syrah.mazyland.net (dynamic-2a00-1028-8d1a-5dc6-7184-2e63-0011-e253.ipv6.o2.cz. [2a00:1028:8d1a:5dc6:7184:2e63:11:e253])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aba78ef6ed8sm422755166b.73.2025.02.16.02.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Feb 2025 02:42:25 -0800 (PST)
From: Milan Broz <gmazyland@gmail.com>
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	snitzer@kernel.org,
	Milan Broz <gmazyland@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] dm-integrity: Avoid divide by zero in table status in Inline mode
Date: Sun, 16 Feb 2025 11:42:09 +0100
Message-ID: <20250216104210.572120-1-gmazyland@gmail.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In Inline mode, the journal is unused, and journal_sectors is zero.

Calculating the journal watermark requires dividing by journal_sectors,
which should be done only if the journal is configured.

Otherwise, a simple table query (dmsetup table) can cause OOPS.

This bug did not show on some systems, perhaps only due to
compiler optimization.

On my 32-bit testing machine, this reliably crashes with the following:

 : Oops: divide error: 0000 [#1] PREEMPT SMP
 : CPU: 0 UID: 0 PID: 2450 Comm: dmsetup Not tainted 6.14.0-rc2+ #959
 : EIP: dm_integrity_status+0x2f8/0xab0 [dm_integrity]
 ...

Signed-off-by: Milan Broz <gmazyland@gmail.com>
Fixes: fb0987682c62 ("dm-integrity: introduce the Inline mode")
Cc: stable@vger.kernel.org # 6.11+
---
 drivers/md/dm-integrity.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index ee9f7cecd78e..555dc06b9422 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3790,10 +3790,6 @@ static void dm_integrity_status(struct dm_target *ti, status_type_t type,
 		break;
 
 	case STATUSTYPE_TABLE: {
-		__u64 watermark_percentage = (__u64)(ic->journal_entries - ic->free_sectors_threshold) * 100;
-
-		watermark_percentage += ic->journal_entries / 2;
-		do_div(watermark_percentage, ic->journal_entries);
 		arg_count = 3;
 		arg_count += !!ic->meta_dev;
 		arg_count += ic->sectors_per_block != 1;
@@ -3826,6 +3822,10 @@ static void dm_integrity_status(struct dm_target *ti, status_type_t type,
 		DMEMIT(" interleave_sectors:%u", 1U << ic->sb->log2_interleave_sectors);
 		DMEMIT(" buffer_sectors:%u", 1U << ic->log2_buffer_sectors);
 		if (ic->mode == 'J') {
+			__u64 watermark_percentage = (__u64)(ic->journal_entries - ic->free_sectors_threshold) * 100;
+
+			watermark_percentage += ic->journal_entries / 2;
+			do_div(watermark_percentage, ic->journal_entries);
 			DMEMIT(" journal_watermark:%u", (unsigned int)watermark_percentage);
 			DMEMIT(" commit_time:%u", ic->autocommit_msec);
 		}
-- 
2.47.2

