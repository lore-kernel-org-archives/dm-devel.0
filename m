Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EE347DD64
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 14:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791903330; cv=none; b=fBxuCHlNjMrJJw2rE1Y3S5U0YFI5bvPa3tCDkKcu+t5TDnSGryro1SDKa0ADLDXXrAHJBQayme3vlLr1dm4zOB+YkCrCQAZ6IihmC0iKaVEn75QkZqQDB1gmhAWH8kntcI5cPUqpautWgeMxEfE+KfFF4yrPlCDQdJBhDsVBKYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791903330; c=relaxed/simple;
	bh=o+oFNcLpuYqRZRBrDMdI0bemVABEvrdGdfb8nMKpYCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m29DPWC9S2ZOZcpy9YV31qMuZlZWbrrcPnMhwRAdjumpVJ+vIPXE0GXOGR8JN5HujMrA1SviM5Z65sF3q+Zg6WKwD/9MrBn+kOtaWha4oa8KrAUCZllFXmIr/YxKZpSaUJk28kGRMY+pbU18/sCOlHKspia+5gKA8VAHVl+uFI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f1uJjNre; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f1uJjNre"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b1afcd2d23so2947698a12.1
        for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 07:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791903327; x=1792508127; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tAWkYGdqvifr12JtKIaB4bUGFJ5gXXZ5L73FeOEQvOQ=;
        b=f1uJjNrewjXfTEzNd+5HGO+9SDC9r4YHbXehZjR+Me36mbBIUA/rP7q/Azz7W8/tIY
         cGspLbOpFtHjRb8kHs1WhZn98jiZaoPIFG1CSigkrzqkEth2lnV93RDvefB0oWbjog3b
         bSvj/aMsfmVcqsgJcfgkUONR6sqNHXV6vJcpJhPh8meHKBwcC9IqSEvE3Z6bwcOxhCXY
         LUV8qUJCprsekHO5noOOnhuFkXIbNLP/qyC9ngGHFTmQrB/bQSTWX2MSLaUREs1xu3XU
         om05+TSR4umFpYAJfbEWOahRyVmz87vEmHVgH5XjxcZpmlBzy+CxlX+a2gUDtq8MQh+v
         3EvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791903327; x=1792508127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tAWkYGdqvifr12JtKIaB4bUGFJ5gXXZ5L73FeOEQvOQ=;
        b=CLdiAqpfzgpOim9z9O2xe00sv7Em1MAuDQswPOMXcUAeDtGJFzYyKMWZz+TirssJ8z
         qUKMmPLmNgjxDwiGJnb8Xb50uebNwZKuPFjryNC/BL+4qHyT1drLG5IsMXOB74FIu+un
         BGZoQzerBGgNVe2i3Py76eq3s304fDWCGHHwhhcfsqwYf8lcglpPyycwu2cBgehht8++
         VfAll7QKfSwm/wCYx/ju0qmKJoqkHKpynb38bald1S7TRV5liFpJWbVsXkMk6MhG6qdZ
         JSSC3TFCaCcJ3YLp2AVQ5pOAk3i9ykbdoiVH7Sfl/fiyX/3hpjNt2OlH1lckaR7hFOib
         Dvmg==
X-Gm-Message-State: AFq9FYJVE+eAcxi88gNXEvnFAZ6Aox7mqio3eUmrLePZaX3SEWjplwgj
	goEHe7TtJk/8wKsN+wW6SYqz1cPwl5mhQO7lBK5akLBuJLS4X7EluG1jwVx69eUV
X-Gm-Gg: AYBFou1pO/mtUdASFIa3x+4tknEij6VPARYv2e0YOsMZIHl9Qcg9KXXWubwr/vOwQom
	XsHlX1DAfdBqYaGGLnyvdBss+n8lAOlDc0uyGmCpQ2OkkCNYdsPb8a2iUCWiFmUqbxDmbeLbV6w
	tPBW52volQsfFwatiUh70vVFNgu+aDDv1lyYuKPaG/anodXh8GmpsVMqTURBGxO0qRLfCswn8jJ
	oGQ48BesTlbEJC/+TxKrO9AshgsGu7J38qveb3LVMCkVI1JVgbzM31ZAMbNsTHlxOFk7GQ+2BJy
	FZ5bUqb+HUQxxF1ncUhg1O2HavMnsiVp2RmwhdgJMdGoSDd8XAj+TmaaLeYVLzGPXkxxtjg+qWF
	1W7C0Ul+vPrX0mNUnVG9kA0WqI8i8c9RUoyt5qFYZ1GM7S/ugWbk+5fPtAn+BtDf/SvqlbFlblF
	FcLGLYGQcRGjGhk+7RKpuUPgmSvwOLwtI4JiuUMK7lXmIV5+5ELwOjJRM4nvMIwQQ5/04wFiOvA
	XoqVA5NJ5JuD7dYy8d2D+hJrSJQAkDLe5qVfRm+0idt242+6k/jw5xm2w==
X-Received: by 2002:a05:6402:2351:b0:6b1:b626:5bd8 with SMTP id 4fb4d7f45d1cf-6b1b6265e1cmr5604234a12.0.1791903326983;
        Tue, 13 Oct 2026 07:55:26 -0700 (PDT)
Received: from localhost.localdomain (87-205-122-125.dynamic.inetia.pl. [87.205.122.125])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b179e03428sm6169161a12.37.2026.10.13.07.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 07:55:26 -0700 (PDT)
From: Kyrylo Biryuk <illofspeed@gmail.com>
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	snitzer@kernel.org,
	agk@redhat.com,
	bmarzins@redhat.com,
	dlemoal@kernel.org,
	hare@suse.de,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/4] dm zoned: do not reclaim a random zone into another random zone
Date: Tue, 13 Oct 2026 16:55:20 +0200
Message-ID: <20261013145522.17499-3-illofspeed@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261013145522.17499-1-illofspeed@gmail.com>
References: <20261013145522.17499-1-illofspeed@gmail.com>
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

