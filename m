Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED47522F767
	for <dm-devel@lists.linux.dev>; Tue,  9 Jun 2026 00:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780964996; cv=none; b=ERaIG7s+Y+NEQKoCXIWYs9quEpXuUdTQekotLnrsXB2mvtSI5+LMFhXZn362jC6HP8UOVTH18ziLjkfAuGId1g12M1DzGyELZF3srXrQN8VwVXPYs+ldnsLHvRG8AY8Auu3UQKA6wFaGWaZBUWNK0bdPChX8J8/VaFfavLGtn3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780964996; c=relaxed/simple;
	bh=oOw2Fc+nXrLs7KFdaitbUQbfzTiD8/+SQvKw6ZqnmCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Lk6ByBhiGkimuwxOBf/jLnKgfhlYpwqts3Exho1YMSPEpxwi1DnTbskRg770eU6nAj7p50V3T0OD3qUrcjqL9eCML1Re5r2UZ73sZ9L04wDLTuPA9b9olmhpsCmqGf+aOWz9cp1DotXz9tCQkcN2e4GUJzkD6BysNYBk6U7Vw70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=NMwK1ONb; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="NMwK1ONb"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-9158629a220so549174185a.1
        for <dm-devel@lists.linux.dev>; Mon, 08 Jun 2026 17:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780964994; x=1781569794; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Braz4R2VKeIWb0oU9AFEOw8JBRP0A4HsNkAy6sZlqL8=;
        b=NMwK1ONb3MmBts9NTCMjVrlKmya6Q2pafv1Zd+ITlfq4yef5NkI2tG7GIIwlXANrCv
         YW6ejaWcZ9Gm9ZCH6t+bvi0EyzWyV8Y9oRHlpj/E9bJHNmSjCBYXbKH0bsGAKb6rZ4CR
         0VkHtLXDq2iwrPjUqDKeHcynRXfFZjvWMv/cXvidtUENZ+rzOJErs54CnBXrUCpHyc4T
         P5H9EOBbCm+hwS8xr2mwgwN19zfW68F9/rOAWrGgjwOgOAlB5mkUxfRLp37DorNGg/Gq
         ZHV4GRNhSta6/EW9gaCqk8G4Ro8VTSwh840m53Oelv6skq2c5Lf8lNFQ9brtTGgDT39H
         HjxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780964994; x=1781569794;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Braz4R2VKeIWb0oU9AFEOw8JBRP0A4HsNkAy6sZlqL8=;
        b=S4krSdsJ/kJ4q1UDwsmtJWroIbAOU3CSCeNK04Zj2Dg/UznCw2xqPjcA/nJi8XHwnU
         p6v7ZmGUtDxYT3iky2JS2W6WCQ646bc+dbDQVBb6ECLEJAVg45INuitL20pGLnWfuBqN
         l+TR+PP2O73axIZA4wCBwuk/huf3lznEWTHf8xO18oTZOVPDvnI+FW4rQ2I1ZB22eVgQ
         iEyYkpaXX6aMkd1UmKtrhJCI11LYtljEhCWwRaJBlXebbO24LVZHBXQRkM6RVR0wyhPS
         2d3CsLfc5oWOr89XqRPyMwFbv4XeZhG0zEINDeL/Mg7Y2wM2CD56QEFzWk15boWGnWDp
         Gw+A==
X-Forwarded-Encrypted: i=1; AFNElJ/JpyENmIpN4vnQmOE78Td/BFkRVVwT6y8NZALocXXCO9t3o8HJRo+C7iTV9HfStha/ExmcMHzA+Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YxZFUDvokMcvEzgIdJqG4DhmU0cd81QVCJpQqfJHo8DIr4EoTAp
	MQss5CUArG+qRgtw5i9IHvFgBa01GgbK7f371ekJKMTY5OMbIiIWivpvUAuwR30vLXGSDQPL2LT
	RVyBHx/E=
X-Gm-Gg: Acq92OG7J0cvH6V9UVSX4aSdif6KWp9mOCOEkIrGLA0y0R0HCpxuyxDkSrTlqwXrawx
	wNQRL33CGoEIKvHJoELlTMZrGiAx6aNEumOY2yC6m0N/BnIk1ANi9VLYvkdWDonI2qCZxvltZaH
	XtcwOGU6zimStRZVqOyZKcS+s0cxF78QjHXVRyz54mUX1cNCQBVV7yOJ6HYmhbtrOlCAy2HDKmO
	zUE4pBIsWsjD+HPylc+p1MWPy6F42W/svVLTjdqGwUd/215xuY2oZlffvR0FuK2U8PPGS5u3Djm
	TEP6lL49BwN7XZmJHaJMFg5d6ikt0X1MqqodGgoB4fjzcIGWuQmqGfOlwczF7NsdLe0lxY0AUxq
	OtEUIWNBHzgg1OtNMUQIXgu3wgaaUqcwoAkLHQ52izTWcHYPAIXQtFU2CiMQwEo4kWr//27/r/B
	hbr5qyo2CKCKZOCwftwIzAaLtZEDedhvHQLjgRkA==
X-Received: by 2002:a05:620a:1710:b0:915:d443:e701 with SMTP id af79cd13be357-915e82814d0mr48932185a.25.1780964993958;
        Mon, 08 Jun 2026 17:29:53 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-91589ea0bcfsm1922043385a.0.2026.06.08.17.29.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 17:29:52 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: Alasdair Kergon <agk@redhat.com>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] dm era: include the target offset when mapping writes
Date: Tue,  9 Jun 2026 00:23:55 +0000
Message-ID: <20260609002354.1236297.0535ba20b556.dm-era-target-offset-mapping@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm-era tracks writes in target-relative blocks, but the mapping path can
ignore the target offset when translating bios.  Tables with a non-zero
start sector can therefore map and account I/O against the wrong origin
sectors.

The result is inconsistent metadata for devices that are not mapped at
sector zero.

Apply the target offset consistently when mapping and tracking writes.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
 drivers/md/dm-era-target.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index 05285c04ff2c..18aed0e2a508 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1229,6 +1229,7 @@ static dm_block_t get_block(struct era *era, struct bio *bio)
 static void remap_to_origin(struct era *era, struct bio *bio)
 {
 	bio_set_dev(bio, era->origin_dev->bdev);
+	bio->bi_iter.bi_sector = dm_target_offset(era->ti, bio->bi_iter.bi_sector);
 }
 
 /*
@@ -1560,7 +1561,7 @@ static void era_dtr(struct dm_target *ti)
 static int era_map(struct dm_target *ti, struct bio *bio)
 {
 	struct era *era = ti->private;
-	dm_block_t block = get_block(era, bio);
+	dm_block_t block;
 
 	/*
 	 * All bios get remapped to the origin device.  We do this now, but
@@ -1568,6 +1569,7 @@ static int era_map(struct dm_target *ti, struct bio *bio)
 	 * block is marked in this era.
 	 */
 	remap_to_origin(era, bio);
+	block = get_block(era, bio);
 
 	/*
 	 * REQ_PREFLUSH bios carry no data, so we're not interested in them.
-- 
2.43.0

