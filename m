Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.135
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793732363;
	b=T3rAW5PwkTiKmn85xYlBVg+eQYYMGxlHm0+QqvzsLX2tDE5UE8lkvftr21aDafyKCBOW
	 L5WlrUdRCCfYAFy41KhiRttwn5yjxYdZTJWF+aduLGjyHxaQabVB49T6dJBC87GQZwr4U
	 qKQVUIs1pn92Fepv7joC7H0mHrvm01yCmRJ12v6j/1IqgADT4ikBYEKexwV7OUEapAkcW
	 0cqpPvYuytd9kvM3VkylhEq82tXk8icmoG9nIdHrmJfhBPgbvIMHl2S0Hi11MqoilK+Ie
	 hgeBR5pi/NAaqujBfmdtwYXLWPiIaVmy4A6GwOGYLX54DOrNEpOKT2ggr4qpgHZYhLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793732363;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=31+P6AMFeIVlhmQscpLB4qy/vx9LUkvE2yKWF6dd1So=;
	b=16YGVgtItqW/PAREcbr3OWcBIpey5JRmQ7KXj6aiinHat/HbT1v5HDoJxa7+JukVCLRS
	 fZfNldxhjiuoc4EqyJPtYUZ7dX7RxMQenuMlwgzjB0F8DqNP4JdloDER2+sVVNsYvKKuT
	 uheemmxOpC6Y+5qYjWQBhCHxRAXn01upOB9gpOiHfl/dA9wcxtddWqMWAXVEMiQP2P87b
	 vHGE27pDdg9TaCG5UDC/oMoiF/i9U/oJNf6JpQGuew3o5Qr1Oz5+P5QkdlN+mSgc/TTHj
	 fFTXTZrhYPEtn2XUmlUMPUK4FPnwjbsq/1hPVZUmddRMis0+/aZL18fisPA9mi3qH+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IHc+we3+;
	arc=none smtp.remote-ip=74.125.229.135
Received: from mail-dl2-f7.google.com (mail-dl2-f7.google.com [74.125.229.135])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1BE606A328
	for <dm-devel@lists.linux.dev>; Tue,  3 Nov 2026 18:59:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D1BE606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IHc+we3+
Received: by mail-dl2-f7.google.com with SMTP id a92af1059eb24-14345ae29c5so1800740c88.1
        for <dm-devel@lists.linux.dev>; Tue, 03 Nov 2026 10:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793732362; x=1794337162; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=31+P6AMFeIVlhmQscpLB4qy/vx9LUkvE2yKWF6dd1So=;
        b=IHc+we3+aBaUoTdl/UAR11MNHW7XbrsNIv/k5BsZnDlzT3lQfF4cOnGez92NY4HWVr
         IsW9cGrBeYpFNnGFBlvkwHX7ISG7Tj5vhs/rL2OxP3GqI027a+XOQUAfHcEgscbmoYDA
         QeVUqx9nFEgALrsFC2vpFvXwvAtjeSXpHzzE0ZhtM2kbqMEs0hpHq/3PDNzj5EZUDWBe
         WNn+aNB/Qv9GCLb14i3VbCn8V0q0OVLq4JfhoK854Fm3QdZBFggysthZTym8o9FZqkFm
         yyESH153XJas7OBaHDKNW0ZfB7BJMea1jr+ffmuXypFWvEpdofzS+2tpbEHzAJI+ftMh
         bUEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793732362; x=1794337162;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=31+P6AMFeIVlhmQscpLB4qy/vx9LUkvE2yKWF6dd1So=;
        b=C5E9bt3Os4eTLYb0hQi05WHWRaGj3gTF3A4t7hS10q39Qyzws0N3J88ncl2KjzGnsq
         pLN7Urg46816KbP+3lAiZFaUMl5j//AELLJYiXAAsMrDQAEQf5enklHTH1ehBBOQU/1Q
         3RuFumF+Y7Mhy6I4WQIq65gsUWozfMJL1ZUe2QuOEGtV0QtHIw6ST+gGC1eHxi/jrNFX
         iOcKUS+PUBihyc+eMqGGumg86DZpxda4Q0otC+EbMpcsf1yWXpfrypGjHsEp8P0dS2Co
         /DVA77bFWhCQXcx2vHSs1XeWtNY0V9x6A708BTtGgqrdztfmS2Zwev7B6+DWZl/2IdoU
         QLZw==
X-Forwarded-Encrypted: i=1; AKwUvByGNJJ/SdlByJ9AUdpKsHZKVFafrRjgyMREcnRO76mcGqIEcm8JRDHqQjKdcEJ2ofTW+wvrlNgDDA==@lists.linux.dev
X-Gm-Message-State: APuU4Z94IaKAuJ58TwVlEhaJJvrVQL3xrGqYP3IfnhBPyvNanrnlVWjQ
	/aSVv/kp1QD0C4mF1yInpChR5uv7fRYKdgOe3qxSk9yaaYZHBzTKEvqc
X-Gm-Gg: AYBFou3JA1YMP/ahMWpkUcNVwERSbR6GYpmuw04RYfabiNOePEJ9SgPCoGOCrACYTjW
	jzqQ7yoP+rieWrlepbsIQW7ZNXEy7KZD9KAeS+qs0zY2UhKkDEw3KlJz4bs2dHofI2OzAHJLOLU
	45LXt/MUJnDFJPTxbgC72Cw3lKJyewJG9YOavsskcBR9izQCW1q0457uUZX+DdH6YCmYzqo4mO5
	rpHsAA0706V4PQo0IBmwPE8e86Ka6TPgfSb2SI/rhH3ytvLq5ksTMeAiViKJHhFd8D1UUJ5OYBe
	9+Q01qEM1kdZ7OkpqX991/jit7JKRlT5hY9C/xqwcLn0gGfXN47cqsKrRroad5uzCBBDDNr0TGA
	5AQXvC4xQLPXe8hfp9zLGk5sMh3br2/0X5dYZB7es6Rl+ct3BOWWFcvS2qTPTudHhz2MrCcUDwQ
	1Y4VYwupLbji0xx03Gt/MLtLYerdkodDWIaTzGIxlL2VJp0xrPcUtn3pa1521Wlx01UACHq2PA7
	9nX3Z6wblJoOHmrQ6sD/WPYNoOqJ6YwccaABJpOdn3ZY2dPk3avZM1wEbStAs8YYn+blSo5QrrN
	VodwDfbhFG4sW8YOyT+ZFmaQiUkoWhtS0z04g6A2ZDaglmn5ZWJmPdOE
X-Received: by 2002:a05:7022:f50a:b0:149:50cb:2175 with SMTP id a92af1059eb24-1ac5cb1881bmr18974882c88.33.1793732362218;
        Tue, 03 Nov 2026 10:59:22 -0800 (PST)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c1c290sm747339c88.5.2026.11.03.10.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 10:59:21 -0800 (PST)
From: Hungyu Lin <dennylin0707@gmail.com>
To: axboe@kernel.dk
Cc: hch@infradead.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	mtsai@redhat.com,
	sashiko-bot@kernel.org,
	stable@vger.kernel.org,
	dennylin0707@gmail.com
Subject: [PATCH v3] block: fix discard alignment for non-power-of-two granularities
Date: Tue,  3 Nov 2026 18:59:09 +0000
Message-ID: <20261103185909.71843-1-dennylin0707@gmail.com>
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

Use div_u64_rem() to find the starting sector's remainder without
modifying the sector. Round the maximum bio size down with rounddown()
and subtract the remainder so that the next bio starts on a granularity
boundary. This handles non-power-of-two granularities and avoids a small
initial bio when a large discard starts at an unaligned sector.

When discard is unsupported or disabled, discard_granularity can be zero.
Return BIO_MAX_SECTORS in that case so the existing bio submission checks
can handle unsupported discard requests without dividing by zero.

Fixes: 9b15d109a6b2 ("block: improve discard bio alignment in __blkdev_issue_discard()")
Reported-by: Ming-Hung Tsai <mtsai@redhat.com>
Link: https://lore.kernel.org/r/CALjSBEvjbiGDVewuapWKhGDtaxZwcn4=22raUiBEOyj22rY7-g@mail.gmail.com
Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
Changes in v3:
- Use div_u64_rem() instead of sector_div(), as suggested by Christoph
  Hellwig, so the input sector is not modified.
- Subtract the starting-sector remainder from the rounded maximum size
  instead of emitting a short initial bio, following Christoph's proposal.
- Include <linux/math64.h> explicitly and retain v2's zero-granularity guard.

Changes in v2:
- Handle zero discard_granularity before dividing, as pointed out by
  Sashiko. Leave unsupported discard handling to the bio submission path.

v2: https://lore.kernel.org/r/20261026195131.46699-1-dennylin0707@gmail.com

 block/blk-lib.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 688bc67cbf7..e98aa483707 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -3,6 +3,7 @@
  * Functions related to generic helpers functions
  */
 #include <linux/kernel.h>
+#include <linux/math64.h>
 #include <linux/module.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
@@ -13,26 +14,25 @@
 static sector_t bio_discard_limit(struct block_device *bdev, sector_t sector)
 {
 	unsigned int discard_granularity = bdev_discard_granularity(bdev);
-	sector_t granularity_aligned_sector;
+	u32 unaligned_sectors;
+
+	if (!discard_granularity)
+		return BIO_MAX_SECTORS;
 
 	if (bdev_is_partition(bdev))
 		sector += bdev->bd_start_sect;
 
-	granularity_aligned_sector =
-		round_up(sector, discard_granularity >> SECTOR_SHIFT);
-
-	/*
-	 * Make sure subsequent bios start aligned to the discard granularity if
-	 * it needs to be split.
-	 */
-	if (granularity_aligned_sector != sector)
-		return granularity_aligned_sector - sector;
-
 	/*
-	 * Align the bio size to the discard granularity to make splitting the bio
-	 * at discard granularity boundaries easier in the driver if needed.
+	 * Align the bio size to the discard granularity to make splitting the
+	 * bio at discard granularity boundaries easier in the driver if needed.
+	 *
+	 * If the current sector is not aligned, shorten the range so that the
+	 * next one is aligned.
 	 */
-	return round_down(BIO_MAX_SIZE, discard_granularity) >> SECTOR_SHIFT;
+	div_u64_rem(sector, discard_granularity >> SECTOR_SHIFT,
+		    &unaligned_sectors);
+	return (rounddown(BIO_MAX_SIZE, discard_granularity) >> SECTOR_SHIFT) -
+		unaligned_sectors;
 }
 
 struct bio *blk_alloc_discard_bio(struct block_device *bdev,

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.50.1 (Apple Git-155)

