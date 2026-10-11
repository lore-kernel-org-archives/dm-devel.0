Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7AC3DFC8F
	for <dm-devel@lists.linux.dev>; Sun, 11 Oct 2026 17:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791741297; cv=none; b=pw/7dvhdR8XWZEV9TMVbsKAy/MUZyaGGhrx4fJedGs6iCb7dlGxAu6M6V38T8oRfu8+BC9fVuCKCO6PICyfA97gOcn0PfcxWh2rABzJUT0hrgrpeLlZFmZjavrPGwezERCHdBTsU7AkebdIHxDm9d5pNq1T8Q4iJIiul4YaqSgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791741297; c=relaxed/simple;
	bh=K0CZG7xuPILHEy3PPebGGH33gpysZhnHLPL0yIEoyVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJ7r1MatJ58ehhp56/U10doxf8w0ppjDV9KXB/mY0MrPNTk/L5XZocyOogQ2oPDXmHy03QM0F1wqe7h2+gIzU0CY6NsHL8VcqkA+kPGicxse7l/U7LKOUb2LaOKqhfBSJ/QQUqarQTr+0sqmFQrvf+mYFGb5QDMn5BK4JDRtFDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QG39kGW9; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QG39kGW9"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c2e7496f947so194267366b.1
        for <dm-devel@lists.linux.dev>; Sun, 11 Oct 2026 10:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791741294; x=1792346094; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fSdAx+YZhxSx7N8hRcIJeT1HZY3ybyZ+3/WgKoWE36w=;
        b=QG39kGW9yMlqLxBSLT6nawE7RQDAmCor7fRABx4l8Hf/7StzUPd7Rf5vjVC5Q+h/sH
         4fO62PNdRFZhp2rldHMCPyfovGGB6xeZkeAS4D7rbmL4PL3ORHLR9lGO6noqmWhimoJ+
         WigGKREq/NhQrcy3ogQhKjO7Zc2SPXQegGvniHsBwlgC3QZOvMAouxLUwhus/MKRQBzd
         s0b42KOarluC2RsSb6R/MoUtB1mjHafE4KKR5w19i7GHezaMLkVLrjzzzS3JmYjNwy/V
         3wX2wJQzalXIvMyDoTeopuUHDvQFbg0lp4TmteQiJUoY8Yje/3/lvHHz8v+SFLqiZiCN
         KCeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791741294; x=1792346094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fSdAx+YZhxSx7N8hRcIJeT1HZY3ybyZ+3/WgKoWE36w=;
        b=QR2henXpec05pt1DMqNJuzdNEcCcc6bM2cNV8/4pu9jvcR8a9BWjQKqQq+s4VXzzYs
         Rq98bq3FLNzDLPIiiY3G6oaFqFq42WEJ7jBK5twUzQcVS6H5bEbvnu7L9Er1J6KNldOM
         vz7R1Dj+zejBfseN5H+J+QC8AYEI+22p4THBMoFO5tcAhdLkY0FoDXWwE34ixfDCY5PG
         Rj6yIFZDxKsfD3FX0gf79pCl/K/TtKlYcm74Neb1T4WJIoA7w5DrV+2jFmxvgYLBmknI
         0WTLdXmRQJ5D5Zgz7rcnpCWFLgzJ5oCrwW1awtFvtRzA/OKw5AWwX6/hFkL+kSQkXr9B
         TvlQ==
X-Gm-Message-State: AFq9FYJLk4x28PbWK/Y3VNhSocuejLM8cgStyqc1zhCKZ9htAn/LUn5d
	tnpEBzfHVPMQstMS3Tv+w4sri9/tqTu6fSwSL95WrF42GPqUC84mf5rwnht888tmxmw=
X-Gm-Gg: AYBFou0ArF0eTr6sDP19wf81azCiMKopRHRDZvJZBkt28nM0m1xAw22R/jzb/Ts5btV
	E4O4rEnDZnvM9JOeXpugfHO5uYQvLu3iDH783ekT8wzuOozu9vulLj652pyenVVtekINtrXl3po
	aGLqLOY7BYFFF9CYYSL9yi51e+b/XATaWP5eLRUlohIgJiaV6vrvv4aWVYTNYuQ3Du0eH1sORUJ
	59JRDhXwetatCT7/djmcfCE0kUQEVI4MGmiBKWzwKbqHXfZX64jjPiWj0nMyROOLsA5EQmaD8Gz
	O8Xt+Nwxno91jOB1hKO8o7dDFt6zBadvF1F/gt6a7bYJ7SQma+vzBC3ZdqXhF7vJedfvsljGtJR
	y4zYJ3OJ/vD+ez7oPHEUEfBq/crgvucYAAv/Yh6mFJ/BUPzCnCBFsf01t3QibST6x8SMTtuCH0a
	HqXzrXPmEjFJ00KTSTo7VJu7Z2RXwcKEuPLFpwpiuYddj+YE6rzPCBfIusKtxyxeyAAWpqZZ0r5
	H310duDXtvmnnMYnTj8HQYbDnP/OiSQhq5CoCsg+4h3BwQ=
X-Received: by 2002:a17:906:d54f:b0:c2e:7fe7:289f with SMTP id a640c23a62f3a-c31a9d31c9dmr763732566b.25.1791741294120;
        Sun, 11 Oct 2026 10:54:54 -0700 (PDT)
Received: from localhost.localdomain (87-205-122-125.dynamic.inetia.pl. [87.205.122.125])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9a9f776sm376806366b.48.2026.10.11.10.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 10:54:53 -0700 (PDT)
From: Kyrylo Biryuk <illofspeed@gmail.com>
To: dm-devel@lists.linux.dev
Cc: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	hare@suse.de,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/3] dm zoned: do not reclaim a random zone into another random zone
Date: Sun, 11 Oct 2026 19:54:49 +0200
Message-ID: <20261011175450.952-3-illofspeed@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261011175450.952-1-illofspeed@gmail.com>
References: <20261011175450.952-1-illofspeed@gmail.com>
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

