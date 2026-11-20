Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795169896;
	b=yBcU+G++eFb8ml9dzueo1p0alZt+AGOiGGWGvaXZgMmxk7BgCvDXTBeRzaDAf0lEajg+
	 70VO4hUWKsA7DOqJ3dFqL18Fv24bWL01Qtfvjbskef2mBeh3I9WmbMNumhhJNoIQGsKrR
	 OkJM+EPOssb6DuRyujzR3Qd32A+xQWosiD5CK9OiCqSj68MKj15+ryAldnyS946Onvevm
	 d2AWL73Vv6qQmzDFbxz8dTImsnCXbNXrS1z/42YvfF9iab79G1s9oN4u+c/6yS48ZXN6j
	 oqLUoCFyd/EOJsKFlAYHHi8z7PnE6SxsCBBzUYA8+D/EZ6g3qdUuN9qXpTC29J4zc3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795169896;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=0840EDq5sPqsJHKgUXXcqS6nB05CdxuLpexyxuNzBmU=;
	b=KoxnFcBLqJ0VmpR+AGH9D4VicxGA872S1RV9QAffv2eDxnzRAEveUCnmwvAAPovL8TRy
	 OV0fHreqXOohyJx8DSHpZVtV0wgXTiY7xha8Oft7J8pDdkQDD0rnILDGvKWHQS9FWXrZQ
	 MWvno4rqlmf0bkaeJoC93NYlm6mNq3sHeXA4SDemuyiOnP1ktMaEFzv8OB/xOhBYYqRN6
	 Y8dSxoO9f7GAx+4odBMYCvjhjT+++o8I6fWhHBW5L/4dcc7kbBaPphDs02gaLxXwExZq0
	 xuhrr/GMc7pgnBFiHI0G7hYQ/JTtafcTpSO0XAeCkKWLhqaAo4DUpgUUWX1jCsGtKSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sXV4s5jg;
	arc=none smtp.remote-ip=74.125.229.7
Received: from mail-dy2-f7.google.com (mail-dy2-f7.google.com [74.125.229.7])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BDB606A333
	for <dm-devel@lists.linux.dev>; Fri, 20 Nov 2026 10:18:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2BDB606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sXV4s5jg
Received: by mail-dy2-f7.google.com with SMTP id 5a478bee46e88-33e5ae86ff2so198470eec.0
        for <dm-devel@lists.linux.dev>; Fri, 20 Nov 2026 02:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795169895; x=1795774695; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0840EDq5sPqsJHKgUXXcqS6nB05CdxuLpexyxuNzBmU=;
        b=sXV4s5jgvq8a89GdJUW8XkccXJYEopMFU2e0q2E0zQuJTPuQQncQoc5R5CNVPqvtPF
         EVi+bOi0ZOeVrETasI+DBYvDx5lnDRPUx0UE/8QDEmvFmfrb1VoBocizIIQsWAQcLkG0
         XjOkEjrAyYUEhdzZ88/yq+6Zl6bEVexqseOgd5gax474pzPUbhmVby/EtgzPgmuLy6Vs
         5zgEC3g4LaxzFM9Ny1oR9SFoPS3EKD846x4okCTmSZ7frwXuV8dr7EfghF5HUmXsIh/h
         +V4fXOeSxhERWMqmB9f5COmZXJDwFN8huoQqyS2YpYtBKSGm/zBErH1A6UqbpLb9gW2U
         wZoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795169895; x=1795774695;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0840EDq5sPqsJHKgUXXcqS6nB05CdxuLpexyxuNzBmU=;
        b=uXQ9wjzqtto/9zZ8gUEVD0PUnUt/98uOVBRSAlHJferasOPYayiSHpAAN3viiwwzVG
         rclRLxaA6b/WXb6b2KLBWuN1SJ6kXETxC7IpRyfvquHfI/rreb0cerPSs/LBzl4T5YQ4
         O+7p99u70Y0TiVUfoBEclAHVWjg2vGjdCHarbYFB/WkhhRc/Mmz3tEZ/ZsRTzdElQ5bg
         3C40sy9OPQ+Nfgs5OZ8+hgtFBERSXBb0uY80TN6phO7MWQEpxVgUbabjU3h/6x2QsD+i
         86JPiuebe624bJLQQNKEDUFP78QGlWfQnTmf9SXEagga/GhWE31QsTdW9Qj0R7k8zQNR
         AjNg==
X-Forwarded-Encrypted: i=1; AL+hErFKOLLO6SWGCGXf6lQKlKrYuhI7pTamEyeYdd22T6lNRYjK10SK3fH6Y4yy8aD9IWgqg66mBCKhzw==@lists.linux.dev
X-Gm-Message-State: APuU4Z/8kuqy+td8AENct57Y7oZX/e5ZMAeiaRdcHQoM9gEYeHgW8VoP
	HJeQHul1hjxGhlUpuUBJN79tklRIYFTlJiybkWkcvEHetZM/g8p2TGy0TMc27L3TmSNQoA==
X-Gm-Gg: AYBFou3C/8G+Zk2/E2WCew87+SgI9gEM41P/8UNfFPis1dO56fIenWaxCzf7tZ7wRRa
	FQfx1q5+2/E/UGBX35PhTnM4S9WhIJzOVz4lAtUGTOMQYTFF17xt2tJuVw7yaQ+wxljRUVl4VZH
	cuM9eDLA1UvqbN4p8vGzeuC1Rz0mF2G9GKKvVT3ubVfl+I+J6ae2KZyKwQcbSmYKIk1/XKIwhB3
	8Fl3cx0z09u0CHvuHeQKjGpSyAuhNxoz7L0Q9Tb0oHCX0lqqhZg/gq6X8v8vgWYWFHDoO1VY+BX
	80j7qztzhecq9vUHPn2LSn9ujUIq3VQOVDPLoH47WgdR+zPoMVqm4B6TCUTPy7CJ8RpLe1hkpGJ
	WG+fUwgmTYn/JoLLayqC/uvg9KNSQVOdlOlU7H1Kk3tbtuW4Pg1b8iZ+qYuUcT1Jm/PK7Yg8yGW
	ZSO+nDgKI5J1i5mp2ZsXP7qXTVyYlTl/pV3fiWiUdBXkwAuUNmuFrxSri5fOfkzAaRPJMnuncJP
	vngK6KE6Yk9XTokjDXJoblXG9C9dNyFxvrbh7EoEJMU+Oo1yDfk8vbxOfXcDFBO0wfN6GCj7xFp
	gCe//gO5sZpKGRmsgXaxuarW1KsmrnlN4Z2I+tfIxmHK9yvT8WI2NAMJEsP0z/s37TwYagQpG29
	UpH9L+KP2mE0+uHI4dnftOagdbKDE4P8mSRss5w==
X-Received: by 2002:a05:701b:2901:b0:143:3c9f:10a6 with SMTP id a92af1059eb24-1b5567b315cmr2415345c88.4.1795169894971;
        Fri, 20 Nov 2026 02:18:14 -0800 (PST)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5568592adsm5905170c88.15.2026.11.20.02.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 02:18:14 -0800 (PST)
From: Hungyu Lin <dennylin0707@gmail.com>
To: axboe@kernel.dk
Cc: hch@infradead.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	mtsai@redhat.com,
	stable@vger.kernel.org,
	dennylin0707@gmail.com,
	hch@lst.de
Subject: [PATCH v4] block: fix discard alignment for non-power-of-two granularities
Date: Fri, 20 Nov 2026 10:17:58 +0000
Message-ID: <20261120101758.45513-1-dennylin0707@gmail.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
Changes in v4:
- Add Christoph Hellwig's Reviewed-by.

v3: https://lore.kernel.org/r/20261103185909.71843-1-dennylin0707@gmail.com

Changes in v3:
- Use div_u64_rem() instead of sector_div(), as suggested by Christoph
  Hellwig, so the input sector is not modified.
- Subtract the starting-sector remainder from the rounded maximum size
  instead of emitting a short initial bio, following Christoph's proposal.
- Include <linux/math64.h> explicitly and retain v2's zero-granularity guard.

Changes in v2:
- Handle zero discard_granularity before dividing. Leave unsupported
  discard handling to the bio submission path.

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

