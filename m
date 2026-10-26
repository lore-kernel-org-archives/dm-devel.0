Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792973129;
	b=IAY/vf0D0M+el1MwMkMTn6GxlrF09ELG16nSDiYr7IOutlvvQ25a2wInOg28gDRPHSMW
	 Oj72GnPR6k0jjclr+IvkeuKjZxlSwg17lunTOFKKT3K9IPxu1vjkJWo9f6vHoeOLRV9je
	 fz4Vxp7f7gD48s0NN0/CJioCZfyFeU0dFcG4P35gj3Q2+FwPP9MzQf0DGjb1c+wEGimOT
	 52fSzBgeRiEeb1qz/g+9gtvKnFrkMedAdutj0UnTofFth6TTybDQs9qBxUDgDVzQvl1g8
	 mSCC6otUarWOqtzHfF6ILsCkYkH/hdRHNb1kj0f9G3DUgj6MC/ZeWpWiIanvYTcz9TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792973129;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=T1XZ1WfHH7XnOv0sWlDb4paoPJtD91jpUpFHrBDh51s=;
	b=vbgPoY/6oejnIe0ARgOj9fMkQk7OQEfmK+6UNxn0KYT4EFELgMmbt/ttK1lWkKQ5Q8DW
	 p/cgcrs/va9CGRdPMyyskoLdPi5jXADf4pHIRDpBwDI3tPNR5kU4kBe9muK/LX8YeSzGH
	 UHmEJUallEG5In/UNkh5CO6WmSCcRiV7uQsEgALcMRhAnPmmwrA7MS92em5vSmXzIkuL4
	 B88ilqSDLeesEFZsO82+/fbhDGZho28aBddMG8TwzGWSDwGy9GoP0v2t+rThTZMsfmlCp
	 DTDSlAZQ6+fWczJb6PmVE/JHx/bRINSfHzw5dEEhfwSFL/2/hF8FvCtIfy1Il5pDDIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=dMY3lPHk;
	arc=none smtp.remote-ip=74.125.229.7
Received: from mail-dy2-f7.google.com (mail-dy2-f7.google.com [74.125.229.7])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CBB606A31D
	for <dm-devel@lists.linux.dev>; Mon, 26 Oct 2026 00:05:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8CBB606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=dMY3lPHk
Received: by mail-dy2-f7.google.com with SMTP id 5a478bee46e88-369f30a96acso720655eec.0
        for <dm-devel@lists.linux.dev>; Sun, 25 Oct 2026 17:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792973128; x=1793577928; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=T1XZ1WfHH7XnOv0sWlDb4paoPJtD91jpUpFHrBDh51s=;
        b=dMY3lPHk9Qpiw49NDulT2Jml5CtiRDGXgVeRYUMzxLSLYV+xN5HyS9F8mq2rLygruM
         cLkzLLS4lzj9iR85trDsNF2gqaEwiayDeXr6FQ6n/Fv93+ablrGBRSUzoUzNngl33faq
         z1Cgbu6Q2MqF6kl/d19hOjjbylMl1selBjM2tRKbg+rQd5DhEvWx8o0/XxwFYTSiQvwL
         oux7BAjk8U+speJ5hUZiva9tZLbtTSIwNMwUKuhcLPSb/0E9A3p8l0PA58a7n42DXkLV
         9lVWd3e+vqIa9034E1nlMIfs+X048Mpqu8ocI3XN+B/+5FlPJ+umQtpZL5oiwzqkW4lD
         +71g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792973128; x=1793577928;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T1XZ1WfHH7XnOv0sWlDb4paoPJtD91jpUpFHrBDh51s=;
        b=CvrrSGpKqcd0mYuh+DyfGh9tPWVEQjGPT+mu9RkMVp0HyGZ+mLEdkecwLsJRCCOL0/
         NT8v/5/rwM9dj0fumTDnVo3s7GJsu8LawcC/m+SDxIsUUu+s1t/Y0HOqREU7QyF6yKH3
         TjqiCDIPPjkReIpuADUMkFAxwEzUSX11zevOnGNMr+yYMRPI6B989lmp0bVXNkKkARuQ
         07QkYkOVuzYZeuNob4mTK7X0YYoapOsuNxcQhnN89np8lafDEg0bvWh0ez94BYN6Krne
         S9ItP5OZ8n02x0f8dGVQ7ql86FcZ+rzVwvXXRubappugj8wgrov+FTiCYCeeaMbMnYYy
         ftuw==
X-Forwarded-Encrypted: i=1; AKwUvBy6MFiidukz16P56M6uuJw0LFjV3uE9lM89NZC6yXDBowgU+Ijyf7oZq9++MQF0BGajtcGfxLBqGg==@lists.linux.dev
X-Gm-Message-State: AFq9FYKJU4ERVAWYvWAOhJ5XQQU/JamnKoIuumjFwkuuIHS9ochPNzbQ
	gm+xlZuizWij1dXQb2obl062zy0slyF3orothHV7BQrrrU0wO1Ru9zDN
X-Gm-Gg: AYBFou1ZpHxzBTFHnJtUU6gpZoo9CRHEYBhPn7RoMWkXTdx4zFkJ6QfTAecv0C9Bff9
	r/57nRqMJW3R1t0sqskr6rwdgImnBHRVo2RTd5ArZ5mcNVVCFetRgrufxZ7p06FRNmSYhEXch3H
	MdGW51s9Gz1umwP0khsSf4xQKlGQknkrlgEqz/JB1ChETiHFDib0KzV0uG9iBXc3K+7fZcd85D1
	7F/JPDQYP90/LW5tWNSTmGb17AtxO9fpTgqr1ae40HMhQI51jZA2DyYpv03ew7T0QZp7XkvF6LO
	45fFetMITrmTnGBnJRehtlTK6q8gU4XojIJR601dfp/k6qsJ608uGU5o5h6TAX5f63lTJk/OI36
	wXGB0Z3jWbPICp10XCyc8pHW/Su8t2Xhh/AU7wvOOckCgzGj7CIBgEerlibLZYf6fy6rwq0w99f
	hSAbgOSdmy1vxfj6gbJkgUfShgOlZel1NEwZFDoUYiBA88O9SftEDNpQx6g1rXkJsJIHtHsz6gu
	/CNseTPyLZA6ri4WHLy4e8VgXs/jd+V67z9S6p2UbjixrDD3hsSrNVrWKfMA3p4mYWYVgGpz3bb
	JONO5tM=
X-Received: by 2002:a05:7022:3f07:b0:144:fa57:c617 with SMTP id a92af1059eb24-19935dd7f53mr9109408c88.34.1792973127715;
        Sun, 25 Oct 2026 17:05:27 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1989ff2ee69sm26698531c88.4.2026.10.25.17.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 17:05:27 -0700 (PDT)
From: Hungyu Lin <dennylin0707@gmail.com>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	mtsai@redhat.com,
	colyli@suse.de,
	stable@vger.kernel.org,
	dennylin0707@gmail.com
Subject: [PATCH] block: fix discard alignment for non-power-of-two granularities
Date: Mon, 26 Oct 2026 00:05:11 +0000
Message-ID: <20261026000511.73371-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bio_discard_limit() uses round_up() and round_down(), which require a
power-of-two alignment. However, discard_granularity need not be a power
of two. For example, dm-thin supports data block sizes that are arbitrary
multiples of 64 KiB and advertises the block size as its granularity.

With a 192 KiB granularity, discarding one complete block at offset
384 KiB is split into 128 KiB and 64 KiB bios. Neither covers a complete
thin block, so dm-thin ignores both and the mapping remains allocated.

Use sector_div() to find the distance to the next granularity boundary,
and rounddown() to align the maximum bio size. This handles non-power-of-
two granularities while preserving the alignment for power-of-two ones.

Fixes: 9b15d109a6b2 ("block: improve discard bio alignment in __blkdev_issue_discard()")
Reported-by: Ming-Hung Tsai <mtsai@redhat.com>
Link: https://lore.kernel.org/r/CALjSBEvjbiGDVewuapWKhGDtaxZwcn4=22raUiBEOyj22rY7-g@mail.gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 block/blk-lib.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 688bc67cbf73..e0de5bb4d969 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -13,26 +13,25 @@
 static sector_t bio_discard_limit(struct block_device *bdev, sector_t sector)
 {
 	unsigned int discard_granularity = bdev_discard_granularity(bdev);
-	sector_t granularity_aligned_sector;
+	unsigned int remainder;
 
 	if (bdev_is_partition(bdev))
 		sector += bdev->bd_start_sect;
 
-	granularity_aligned_sector =
-		round_up(sector, discard_granularity >> SECTOR_SHIFT);
+	remainder = sector_div(sector, discard_granularity >> SECTOR_SHIFT);
 
 	/*
 	 * Make sure subsequent bios start aligned to the discard granularity if
 	 * it needs to be split.
 	 */
-	if (granularity_aligned_sector != sector)
-		return granularity_aligned_sector - sector;
+	if (remainder)
+		return (discard_granularity >> SECTOR_SHIFT) - remainder;
 
 	/*
 	 * Align the bio size to the discard granularity to make splitting the bio
 	 * at discard granularity boundaries easier in the driver if needed.
 	 */
-	return round_down(BIO_MAX_SIZE, discard_granularity) >> SECTOR_SHIFT;
+	return rounddown(BIO_MAX_SIZE, discard_granularity) >> SECTOR_SHIFT;
 }
 
 struct bio *blk_alloc_discard_bio(struct block_device *bdev,
-- 
2.43.0

