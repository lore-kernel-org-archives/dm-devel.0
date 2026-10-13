Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF754F68DF
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 12:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895189; cv=none; b=OwWsOlHk+8AHqucYw2zcWborC+z/yI/QOhh/RSZE52vuPpjvH+3vrIVPselObD1wge+k0FAyYexhebmpZO/Q1FHmSWrTvCIX/0XQxkjqXQMoGEjM0vkKyibKWw89+/uZuP2KHdhr8/pTUmfgnhuB7AXVT4+tBk+6odlvtZPB40Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895189; c=relaxed/simple;
	bh=o+oFNcLpuYqRZRBrDMdI0bemVABEvrdGdfb8nMKpYCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4gERWjxvBb5HMvvRY7CIv6RPqHhQfq2/Yoell+LBdMso3i5qqfTjT06As3FRCoSC9f9EGqXw5xqDSvCRmPI2K7CISULOrr7R24wN7EKC1VoQdOLDxmEU2VqcsdsKNw4HxC/oqqTvPMWZ3phYQ+gD2R9Rk6A+g+BsH8emubq2Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FsB11caq; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FsB11caq"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49e73611928so31062765e9.1
        for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 05:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791895186; x=1792499986; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tAWkYGdqvifr12JtKIaB4bUGFJ5gXXZ5L73FeOEQvOQ=;
        b=FsB11caqeLnASWYzvu3Kk4ORiEFOi/ok3lrpqWgTFmiF73spGJCopL8/GbkEXpYiAi
         H2dCa6GuYJscp4QN17KXD5oQ5urID0eXZwzopDV3pvk6c3Fw/4CdGMoznSjeZ+kf6M5I
         vgQva8ibx8CbjIdL5Me8k2hE97A98X4gqJjDEpRda3lj/S3mDlOU0eKiaAcRs9k80MpH
         +BfYAgaOvBt65jkGhUakqcYnqAFd72sNofyPIOV5pza7U+od+hdbHIcikIpMMw+WprMc
         gTB3kYgYZamdes725GMIIYvDwOILI2nM4J3T58RSsSM40sRcHThVYekALxXU9A0RraPK
         p4Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791895186; x=1792499986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tAWkYGdqvifr12JtKIaB4bUGFJ5gXXZ5L73FeOEQvOQ=;
        b=qObmYa7FqboWeRagTzPkJVlS8rdxRPvZA4mNY7Gm1WhZTf89MG5LGhMEWahT8+j9wY
         D8Yfw2OrpBPSskfhRYJR8TSay1LpqZc5pCOJAbYJVg2jnde6xPMOFClI5vvwLL0+fPdR
         qraJc/yKojqMNzQ2UqA0FQDS2Ng4am6GfpOs1+W1Ljjejf+ZX6aVMIH7NQExir/XPsyJ
         Z/9q4JfOW+KeKjB8kNm5WDDXQBpksZxldinV+7yQAtErNXYVx0DXCB6FQXs4JSG7h/C9
         yTWO6rPXQ7a2nhGKzEbfcnYYharI871xr8S5Ae3I9LHDfpf8NpieWyMALiPuaPpLzwE7
         FYhg==
X-Gm-Message-State: AFq9FYJZ3/oDMV/Iqbp0o18JA19kFgTpQbY18BuJO9B8mPAFkM6DLSHj
	XKMg68a5i8PKuPGHfQSI42GSn4ZzOPuFL72P1sltbL6h21YERNz59aBmsbpaI4aN
X-Gm-Gg: AYBFou1qC8m71WZj8qmB/grIVdObPGqKFX8Nh683kBcc6w6+dHJ6Tn0aftAMq5rGWeU
	qCnMOstFx8uAmj7NFtdLqmuWMmLn51QIHNz/J+JqDDafcT/eAJKFo8W4t6OkbCy6RNjGlePUwoF
	VY+44erVhqPXzyUlD73tLwLcQ+N1VSe4UZCpv4ik5dZ4+MllQXnplkDrZuO33aTxzBgvOrBhtqQ
	enxDnkvk4U6PlmK7H9wPX2x/T3HYRrxyJu7sHAxl9M+pwRsR4OZpxrNpgD9X2yei6RKAX7HF0ft
	YFVl4uQ2pQr11JfQLw7Xwz3wSaUFG2HUC2XEGOwCsQPP4E5aiO5s+Ae7oAgoVsHIstkGeervnaT
	4Bu673tnQizQGvj3b+TwcCunEGL1OP/qnF1h++03HOkq2OHS/AKz7v/zFL33QGAP73pb+4Eys5J
	m/7+SNFAxKauh3mgopYgLtNsM2Nwn6peY8Bq+hufeJXO4pJODLTdQ0pCOpewizTbdrZfRHF5EgR
	0Y2tdN83jQ5bWyNPBDHcTqROU6PXUvFmI43gp/BS7mwUE6tGh2O9Pt1Ag==
X-Received: by 2002:a05:600d:864c:10b0:4a1:8bff:9284 with SMTP id 5b1f17b1804b1-4a18dcd532cmr193416285e9.15.1791895186426;
        Tue, 13 Oct 2026 05:39:46 -0700 (PDT)
Received: from localhost.localdomain (87-205-122-125.dynamic.inetia.pl. [87.205.122.125])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0bc7299sm4179440f8f.53.2026.10.13.05.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 05:39:46 -0700 (PDT)
From: Kyrylo Biryuk <illofspeed@gmail.com>
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	snitzer@kernel.org,
	agk@redhat.com,
	bmarzins@redhat.com,
	dlemoal@kernel.org,
	hare@suse.de,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/3] dm zoned: do not reclaim a random zone into another random zone
Date: Tue, 13 Oct 2026 14:39:39 +0200
Message-ID: <20261013123940.952-3-illofspeed@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013123940.952-1-illofspeed@gmail.com>
References: <20261013123940.952-1-illofspeed@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dmz_reclaim_rnd_data() falls back to a random destination zone when no
free sequential zone is available and the target has cache zones. When
the target is idle and the cache zone list is empty,
dmz_get_rnd_zone_for_reclaim() selects random zones of the zoned device
as well, so a random zone is then copied into another random zone. That
frees nothing: the next pass picks the next random zone and copies it
again, for as long as the target stays idle.

Seen on a two-device target (256 GiB regular cache device plus a 27 TB
host-managed drive) used as an md RAID5 member: after a full rebuild
every chunk was mapped and no sequential zone was free, and the idle
drive read and wrote about 72 MB/s each without pause for hours while
the free zone counters in "dmsetup status" did not change. Reproduced on
emulated host-managed drives (tcmu-runner ZBC handler): 340 MB/s of
copying on an idle target, 0 MB/s with this patch.

Only switch to a random destination zone when the zone being reclaimed
is a cache zone: moving it to the zoned device still frees cache space.

Fixes: c5c788595292 ("dm zoned: start reclaim with sequential zones")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Assisted-by: LLM
Signed-off-by: Kyrylo Biryuk <illofspeed@gmail.com>
---
 drivers/md/dm-zoned-reclaim.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index 315f0da99f3..88d56d3c86d 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -288,7 +288,13 @@ static int dmz_reclaim_rnd_data(struct dmz_reclaim *zrc, struct dm_zone *dzone)
 again:
 	szone = dmz_alloc_zone(zmd, zrc->dev_idx,
 			       alloc_flags | DMZ_ALLOC_RECLAIM);
-	if (!szone && alloc_flags == DMZ_ALLOC_SEQ && dmz_nr_cache_zones(zmd)) {
+	/*
+	 * If no free sequential zone is available, a cache zone can still be
+	 * moved into a free random zone of the zoned device, which frees cache
+	 * space. Do not do this for a random zone: moving it into another
+	 * random zone frees nothing and, on an idle target, repeats forever.
+	 */
+	if (!szone && alloc_flags == DMZ_ALLOC_SEQ && dmz_is_cache(dzone)) {
 		alloc_flags = DMZ_ALLOC_RND;
 		goto again;
 	}
-- 
2.43.0

