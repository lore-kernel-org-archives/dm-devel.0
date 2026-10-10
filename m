Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063B633BBCD
	for <dm-devel@lists.linux.dev>; Sat, 10 Oct 2026 16:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791648980; cv=none; b=exUM8ip183idf9w/gHVEFMz5GTqwF1J+R/XF/iJ3Spv6b26fPxjwyVc0GiXMMVeLTijdZYdoMij6vpsHF/iIlHmF/FqQi1J1MGFNbkN0eMoH/h7/Aqq0GuU1MbpSEfZB/LHtOtCO/fgl9BYDsa+3U3VzgBV1CdXPe8XE17TlZfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791648980; c=relaxed/simple;
	bh=03OF+1Ek6lttvtzebwu1i3h0wWO50Z4SqmRyzg8h1DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JdEpSSWsdFj8zXE6PYHJfRulUaAPZu+13v2i7FmMBBJpeBLU1GrdKvyVwY1QF5riyNqlrXwMzLJofTtBzr2lTwbeaXgD9sO5aWaw9mTtS8d7E1W2uZt/sG3djrjGJwir2bXy5EBaGAr174GgNKp/jy7X+fyWnzTDSAGCkfEreec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T9gGaT2F; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T9gGaT2F"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c262f1186f0so101175466b.1
        for <dm-devel@lists.linux.dev>; Sat, 10 Oct 2026 09:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791648977; x=1792253777; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DFZZRv/P/W173y8m2SUZ2LX6mxqwcOiMdvmZTNTtqnY=;
        b=T9gGaT2FwGiI4zrcM136IrnbWiBcyjgx5nEV3DkfZYbsjO+qRe/SMuzUEjSTcnEsQk
         NFUH21E0Xy4YyyYmEj7xYje61X7LCzA0clRhmZn4RvV679RVy5ENpVBCXCPRIjb/f8w+
         mBN779rvey4g0cEyJ1rIrRNekYfoq/ZwTHfFzDq6BqYGrGOLUqiZ1EcLTbZVGr+zAlfD
         /lmi1Ro/6jZao7Xfi36/QFOSWRyd/GxYGxs2GR9McsbpSL6Ez66ee87tZ+GxSDdDiRN0
         3Wcj7q2SedZufPCKtQ0pcuv+mBL+ReD+xVzz2gOvIT46vT22Sw8CQJA1SpZibFPToZwv
         4kyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791648977; x=1792253777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DFZZRv/P/W173y8m2SUZ2LX6mxqwcOiMdvmZTNTtqnY=;
        b=xOQIX3QTWCjHwi9+ofzqQkBh17GKSlTm/VMK1oD1YrHIuqTgzgeP2EEqhN3h9iUSs6
         YFyOHyvR9xm52LPSn4th/OV9N7vMXDqmDpHI8JDlngxXh7zDOwMVI4PsCCyTETJcfyLV
         FpUay4BYXkqT54yba9vmSLQ1zgmw1SuVVQsbmGSl9ASiEgo5cYoa9fUlt9/0bV0eBPTY
         xAp165pn+wvXuuhai+6SGsfRHWugX0D4CZHQdT/6InByqPKeAPXPZSe1UvAoP6SvDYIY
         m0FyTtUlvprJ2u8Q2b6C9D1WuLShMlxJrRUjs/dw+/aP3kIg0VuokSj1Accg2GD/zUMS
         Sqvg==
X-Gm-Message-State: AFq9FYIxLOgX9rPF9XyEp4yJRQBmKdd8xvS+tN++Mta3H07F0VIqPBhT
	78SjYUVPPBtb5i3YIuqscuVmq/RGhcMtrkmcX/hmvZrA3s9KUwzdQ79pBqXo1cafYwg=
X-Gm-Gg: AYBFou1RDACZkNyH03YLdlwlOqflxqtDtKgrXzTx9kBMQwP7igcp4eTIDgCz806BfT2
	t69g0CrZpqE2f+kARNmGMFcO5bfLyKaSC6xdHA4Wm6p+l3UAuiR/D0V6awboYClrqPa5l4hI5oO
	EOtTjQnSFaZwjYIjPb4QVKIG6sxb7iFYfE194M31ml+G473weysYsGHXkkDTz50254bqkqBCgrL
	ik4Vu2t3LqRAnakQrUXph6pRuAUpvq9Sg3brOmYL/ubw4DjZAp37cr8h4icuusNOGuDp1tU2jws
	RoUbSZeOingHOKR3bsvWXgQvww2jBUiSbVmVcPZYtc0OHDiagJy7GN9G+rbaurpfDoWHeUk3Eft
	fStkVg72nnFVT8XFVAEJWtV7uj1OYJ/aIdzm8v34KtidrztXsyR9y8NV+JDua6aNxr9ZX237RT9
	NQgSXv4RKFm9ikIsmZDt94f0K0PGkDUX/frPweu3p7rBXbsZRX2G4E7dw+GfByzKbkoA4nlBK/C
	Fm1lzZ1bXpPihyA5roOCoyP3ngBTFwuS0gBH53yUfRTlYE=
X-Received: by 2002:a17:907:dab:b0:c2d:fade:e089 with SMTP id a640c23a62f3a-c31a96de49dmr544110966b.0.1791648977074;
        Sat, 10 Oct 2026 09:16:17 -0700 (PDT)
Received: from localhost.localdomain (87-205-122-125.dynamic.inetia.pl. [87.205.122.125])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9a74bd7sm261422066b.37.2026.10.10.09.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 09:16:16 -0700 (PDT)
From: illofspeed <illofspeed@gmail.com>
To: dm-devel@lists.linux.dev
Cc: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	hare@suse.de,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] dm zoned: do not reclaim a random zone into another random zone
Date: Sat, 10 Oct 2026 18:16:12 +0200
Message-ID: <20261010161613.396-3-illofspeed@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261010161613.396-1-illofspeed@gmail.com>
References: <20261010161613.396-1-illofspeed@gmail.com>
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

Only allow the random-zone fallback when the zone being reclaimed is a
cache zone: moving it to the zoned device still frees cache space.

Fixes: c5c788595292 ("dm zoned: start reclaim with sequential zones")
Assisted-by: LLM
Signed-off-by: illofspeed <illofspeed@gmail.com>
---
 drivers/md/dm-zoned-reclaim.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index 315f0da99f3..2bcc163d209 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -288,7 +288,14 @@ static int dmz_reclaim_rnd_data(struct dmz_reclaim *zrc, struct dm_zone *dzone)
 again:
 	szone = dmz_alloc_zone(zmd, zrc->dev_idx,
 			       alloc_flags | DMZ_ALLOC_RECLAIM);
-	if (!szone && alloc_flags == DMZ_ALLOC_SEQ && dmz_nr_cache_zones(zmd)) {
+	/*
+	 * Without a free sequential zone, moving a cache zone into a random
+	 * zone of the zoned device still frees cache space. Moving a random
+	 * zone into another random zone gains nothing, and when the target
+	 * is idle it repeats forever. Only fall back for cache zones.
+	 */
+	if (!szone && alloc_flags == DMZ_ALLOC_SEQ && dmz_nr_cache_zones(zmd) &&
+	    dmz_is_cache(dzone)) {
 		alloc_flags = DMZ_ALLOC_RND;
 		goto again;
 	}
-- 
2.43.0

