Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70949289E24
	for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 07:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752133333; cv=none; b=ZR5iCqkLnMEYQu6wdZKRysLGqVvbIm3QabjzWNdwQ7i9+unp2Hnb/NWhPkBWBThIK2iT4P+2vEXbFEJgHvtk1YnOL+gVJAsYFOafh3mMpbQpLlzCsi5hFdSqw9IlNZsTuX7Xl5N5nhKnYQV6O+LAbLz57LQ4DBTpGAm+wcWMOOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752133333; c=relaxed/simple;
	bh=OsndL/l91yEYx2xFUgVdidwO0LjsZsF/bbZEk+wkBGI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=isVzPFyqD8w45rCFm8NCV92wBPCJXcgJBoVfoyEG3fm7eTbo4Uh+HrYiuwbJ9w3MSpfmXN71kDwJ4eMDEnabCLbA3AH34nSj02AeCaS4tudQUxlDtmWOBIl9T2Hmb0zx5Ibb76VFJsEaDc6fwJY8ATtguFkrtENa9/NJvbOCzkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QTx1/CMC; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QTx1/CMC"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-747e41d5469so791334b3a.3
        for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 00:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752133332; x=1752738132; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g1gHr7q+EFyW2xRmF+M4MwqkzxA1X9V4Qz37BGBEn0c=;
        b=QTx1/CMCu0umlGoFrmBfrNSPEfiaA+2aF6x7BEztvCuaX7sXQzqmGlIYO6yaqWX4s6
         YF7fMXbeercZdoZSKojgZPGCtsk9GmbbggIuHm8KnzDXHKDUzhFJv3sNZgVK2Bsp76eb
         Rr+KFPjCbtCxStFsafCIPeaFx5ItHhhpjydA7/O0RihiWafigxoA4f3BiPOmtpGRJ/XK
         iuTSAihH5fzCEHGYKE8PyVUjRfaiwyhmXFPc89k/hlRlYwmZ2AnotQrvbfTW3FE/9QuC
         tJKNjC1mo10b4U3PBWvNbnQnrB6qEgLhaBUfFL80KjG40y78pBz7HB7/WQ/+7rgQC5Ej
         1yPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752133332; x=1752738132;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g1gHr7q+EFyW2xRmF+M4MwqkzxA1X9V4Qz37BGBEn0c=;
        b=ZFcbLz1v5f9SttOyOioevMjtM8fsXjfmmV2Sp1KuEr9C0faO8YK9+hj5nVR/u7Vy+K
         xmxgz1aDA+e9z3SD9PhHT/3OIXhqLHuzci+hSK3GXa2p/TMB8KZigKB2FvVThq6b8Iov
         hQgNOHCWZDS06QPVqY+a+waA74xFtoeDPQm424a2tOvm7940cQpKIQ4NPq3316bYVXX+
         GRLOrlXKLieKFGNTBtFYZzdWCqgJK6k9luqes+aRvVcnLUB4vlGEp20LUjjnm+OLUmB0
         dbmN0ymlE8u0CUgi+a1TeniZimCmUj4BoZsqErjZpBsbNBfZP0BTeYrP4in7KyCJlywn
         uuug==
X-Gm-Message-State: AOJu0YyIksDfA+zWVs4UPKTp8CBPbCEQ6YTFrxJjxcXalpWeb+I3GOeN
	sFI4KO34W+zVkcdeWoEe9n8KmbnJ2KcMY9DE1neHA2PLl2+HulTZ/CwY
X-Gm-Gg: ASbGncsFXH0ugCOwd8XAPX4sahsKyI8tXIKI3/Js2H1XAeoSc9X7mZk5vXa7lCSai0R
	3ymmdVshYP3AtgmMofUSnceIXT+K8sqearLlkAF3ic/DVHd/UZEHK/WNRkgYn4S34eqNGmICATC
	R5jOyY3GBn4WWla1hnPpFXzfsLRaJZ4TuoHP3O7x6udpQ49uyPRjqKKzIXySGAKXG0D8P0YhV2B
	BFlerTUrrhDvvZrz8W/VGxsg4XDng+Hx+J3ZeY3ZaBCkzbby5/r9qbTucMGcUhWAdD4jJWJ+JKT
	ynp61Psbq1hUAbrkZsPWOJWpezQobfpEka4EPoK+idWAN0xvlnFCOIwjUI0l6XP5flxUvhqo0KQ
	e09BMdt0EiP2D/fkiaSwe
X-Google-Smtp-Source: AGHT+IHRmevB2sLmZNuf4rljnBX+VrlRwcmgSx+Zab7BbZUes+8/A18efetQ8HvRx3QeMISxk9f4zQ==
X-Received: by 2002:aa7:88c2:0:b0:74a:e29c:287d with SMTP id d2e1a72fcca58-74eb8fc372fmr2237901b3a.11.1752133331691;
        Thu, 10 Jul 2025 00:42:11 -0700 (PDT)
Received: from purva-IdeaPad-Gaming-3-15IHU6.. ([2409:4081:199:dcfb:ded1:3f8f:36be:5438])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74eb9e06883sm1479087b3a.63.2025.07.10.00.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jul 2025 00:42:11 -0700 (PDT)
From: Purva Yeshi <purvayeshi550@gmail.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Purva Yeshi <purvayeshi550@gmail.com>
Subject: [PATCH] md: dm-zoned-target: Initialize return variable r to avoid uninitialized use
Date: Thu, 10 Jul 2025 13:11:57 +0530
Message-Id: <20250710074157.24215-1-purvayeshi550@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix Smatch-detected error:
drivers/md/dm-zoned-target.c:1073 dmz_iterate_devices()
error: uninitialized symbol 'r'.

Smatch detects a possible use of the uninitialized variable 'r' in
dmz_iterate_devices() because if dmz->nr_ddevs is zero, the loop is
skipped and 'r' is returned without being set, leading to undefined
behavior.

Initialize 'r' to 0 before the loop. This ensures that if there are no
devices to iterate over, the function still returns a defined value.

Signed-off-by: Purva Yeshi <purvayeshi550@gmail.com>
---
 drivers/md/dm-zoned-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 5da3db06da10..9da329078ea4 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -1062,7 +1062,7 @@ static int dmz_iterate_devices(struct dm_target *ti,
 	struct dmz_target *dmz = ti->private;
 	unsigned int zone_nr_sectors = dmz_zone_nr_sectors(dmz->metadata);
 	sector_t capacity;
-	int i, r;
+	int i, r = 0;
 
 	for (i = 0; i < dmz->nr_ddevs; i++) {
 		capacity = dmz->dev[i].capacity & ~(zone_nr_sectors - 1);
-- 
2.34.1

