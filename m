Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.136
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793044309;
	b=nczOgNnreDzOedAmp6vpQhE+uzdd+ByjhFKPPyPjmkgdzhreL8t6FIK7aZC2J3D/wU62
	 IPuQKg9EV36+bi4I5wc8yL65W4B/w+/tJg+Pu3aku6QZv2aiJ+MbORyLvbMlTGHzxVQDS
	 CAiKGjTr6ySnc2hDMdY7JY0J4IMTL/3A473X1ySZNu3NEYDqSrwnfwBBostUMPBI5FRnX
	 i6E2abAj/6VrZWyIxLsKtO773M/ZrhBP7/JzRkwu56rIjMF2qjkUIn0GTjtua0vVJk+tN
	 DkSlqRlkmA+0QdcUqTDOf+q2ZoJF6XcG1b4gftdMIHDr37O2zitfDGOzUbWq6vMIM4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793044309;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=lt5+IIOEQntNwj4k8ixyv60ZFra3k7uwj0Sn4JHHT+4=;
	b=LxD8hSbSUIKYtn3ckzroluXPxIpnwS77UI/dniHGa5B0Xpe0cVEiiE4okPGClMTAP1BY
	 FhFg/ZwD/Zkx0OLJiyDhO/Pc80M2H0K2L95KQqfdOVwf2SomMg0cdo/9Rqqjx1D5TKZYo
	 tLGarqVf17AZIhG/zL/na3QSiha1ucP6o6CMmiZQVgvvy492OCzLCf+EQetqkLe8tuajh
	 fKlQB69QGOHqGRwqUmUbxVI2CfnhB/uLpGHttj0y7uBs/HCrBzLfcXxbPn5z410FX4NKK
	 PUQ3+bQiPqfOhImBLIwws+0301aLa2CzgkU/kHf+NzUCaDpddhRWry7eUylFkB7ey5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=EQ7AAb6T;
	arc=none smtp.remote-ip=74.125.229.136
Received: from mail-dl2-f8.google.com (mail-dl2-f8.google.com [74.125.229.136])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77206606A31F
	for <dm-devel@lists.linux.dev>; Mon, 26 Oct 2026 19:51:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77206606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=EQ7AAb6T
Received: by mail-dl2-f8.google.com with SMTP id a92af1059eb24-15901d262aeso44581c88.1
        for <dm-devel@lists.linux.dev>; Mon, 26 Oct 2026 12:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793044307; x=1793649107; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lt5+IIOEQntNwj4k8ixyv60ZFra3k7uwj0Sn4JHHT+4=;
        b=EQ7AAb6TbbzBE7pdbNAy68mPfvkck6XFU+0lA5LUpNwzspeeh14xnShh8X0+FUamaZ
         1jyICGsZ8J/6uycdFI0VlLhV/1xh5LQfBbi7NnIvLxwE1z6wdsw+M1p+pTW7rROJuyZw
         +EMPn7nXNP9yMzGF1MfSftImv1lmMZWe45lNvODRx/+Zmz5BE5igvDeIuxgh3+X06t3a
         rLcqKLFFAkU5eZ8dGJLWslYnqQXl2ksJg83BAGsEpveAUzRHdUOBKhjbWYyBpMPnIp39
         pKTUufgzAtCDBqxb+ej3bujhiADXNvzY/go+eZq5FUyWlFz8olx+Wv0qD8l823HwZBWP
         YbSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793044307; x=1793649107;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lt5+IIOEQntNwj4k8ixyv60ZFra3k7uwj0Sn4JHHT+4=;
        b=WCNROLUPxAgT6CUnOV9j+h7nZQJIBmDZgAT8+vYdzTugSUPvjK6QeQXMCXRfn2EwtX
         /OUi8rili0uoXm5+7EWTxlHMAvyGft7NP8E+s4XCNuJ6Qsf7uOBW+7UDrIINEfVpSmBH
         4Prue76kxy+NhVk86Tze8uLtyfeUhKk6l2lw/zd2iRcgsMEfQsovFrBahBOYGxGJcpzc
         r94FpllK4YR/3qU/7Ff9nZY6maavCe+viLnTaFOUTG6SGNw+BpLyUs945BBcoLpXq7dD
         1HtXqoGU1De1lv30pwdEcuiNav5zfnjhqhOZhWFZPBN97PexCJWaeSsUCICXPKZFi6Ms
         ugIg==
X-Forwarded-Encrypted: i=1; AKwUvBwwCAJ5VxsXGIamIZQxqOO2JM8J9s5/y3Sllnsqv54TWDqTwbyAmDZAHpk20odMIFTA3vS38jUEOA==@lists.linux.dev
X-Gm-Message-State: AFq9FYJWFAkeS0raFfcGFnSF6BmZxzkSXf48fUaHy0sJlQHYuSs6HqdP
	coSuwnXGpF0uqWEPOOislEGrW0UT3KwXlSpydCtQnN7N4XGODGHFKG7v
X-Gm-Gg: AYBFou3ei74NfVEKTJ2SS5TAQxdHrjBx/B26HDZT8g3ZteZMWUzGPwckhvl0JjXt6+U
	Xu++Il0w4uMs89C1/yjIFTy6yF54Trgd98bVcuS7lrtZMORp+Jp1CtZyOxXOa/tYaBVTIozjAAb
	lr9exMIT+Kpx9R5Yn9e5aeeDtk+h9oxVG4zB6VKjOWl9mc5Oi8cU3cpDIrxh1/iAYbl9h/StZEK
	F1UzJwKCRb/XpzklD1iY3g6bwyIYDb0H874HoKUJiRdA9XbaN+utA+2zgTv35HICUGZ9ujMVInl
	wVI0htlvQRz4lqqTVFiAW5bdcdJ8+YASHpRcV+o7wm8HciaYH7mZkGU0qXO5DtbuYaqBKJcZAPS
	ht6oUikEMZFZwSeliX0iC5bwGShqbJhjXZPFr9arL3sPvZGsyDr6Jzn4ZObI0qyNLYzIBvnj1Uu
	rWr4DhpKVPepcPUbRBf1wadf2WL/jIDGmlSXH6DAk+ui5sWvXinr2kH0Thi6FAP0dODzIZhRb7J
	f/bqrHZg2rIkuYyp0Kw0cl1uDa6YASMouNM0eox+WwDyvGdXvPJ62H9ZzdZLd5Y9D7VpvrwYoBD
	UBQeYtQ=
X-Received: by 2002:a05:7022:102:b0:196:7590:8bed with SMTP id a92af1059eb24-1a3c3240338mr1258384c88.2.1793044307251;
        Mon, 26 Oct 2026 12:51:47 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1989ff2ee69sm36573707c88.4.2026.10.26.12.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 12:51:46 -0700 (PDT)
From: Hungyu Lin <dennylin0707@gmail.com>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	mtsai@redhat.com,
	sashiko-bot@kernel.org,
	stable@vger.kernel.org,
	dennylin0707@gmail.com
Subject: [PATCH v2] block: fix discard alignment for non-power-of-two granularities
Date: Mon, 26 Oct 2026 19:51:31 +0000
Message-ID: <20261026195131.46699-1-dennylin0707@gmail.com>
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

When discard is unsupported or disabled, discard_granularity can be zero.
Return BIO_MAX_SECTORS in that case so the existing bio submission checks
can handle unsupported discard requests without dividing by zero.

Fixes: 9b15d109a6b2 ("block: improve discard bio alignment in __blkdev_issue_discard()")
Reported-by: Ming-Hung Tsai <mtsai@redhat.com>
Link: https://lore.kernel.org/r/CALjSBEvjbiGDVewuapWKhGDtaxZwcn4=22raUiBEOyj22rY7-g@mail.gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
Changes in v2:
- Handle zero discard_granularity before dividing, as pointed out by
  Sashiko. Leave unsupported discard handling to the bio submission path.
 block/blk-lib.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 688bc67cbf73..5649e4d3b5bf 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -13,26 +13,28 @@
 static sector_t bio_discard_limit(struct block_device *bdev, sector_t sector)
 {
 	unsigned int discard_granularity = bdev_discard_granularity(bdev);
-	sector_t granularity_aligned_sector;
+	unsigned int remainder;
+
+	if (!discard_granularity)
+		return BIO_MAX_SECTORS;
 
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

