Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B53833BBCD
	for <dm-devel@lists.linux.dev>; Sat, 10 Oct 2026 16:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791648990; cv=none; b=pR24bU4niYNXJoedTPuSEWw7VhZUc52Qqv6ocDkm3qbFgSXYfMs2jM7iriyfLyZ0W7YFnusNQOcC7sAI2I9Zz0Yb1/6twYpb/zIjGXLtFlIRlhJmvxTSzQLLtHo7RiVE+NxeSkhwY0ZI2z1iEMPCUf3dey/sPkfH1ExKFXp2hdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791648990; c=relaxed/simple;
	bh=fxT+Zz8dQU7wmM6ixSzTBGK00mqTbd+cbcJ77UfUg8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ii9GTPLcvIx2I4aWQqvCcbbygdYyWxwCDGLZQZLeeeORJLp9wq1/E3UlbQMmXYtK+8cox/WfRzKkZn5nOhcfsyJt+J6jrXpcf0/WHL9icK/fda7GlfmoVtEJAkwHkt0ZtlzLwcqPz2V/+u0Cf1SYpuUifdzCTBh+GsKiaRdJ+iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VzR0iIPE; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VzR0iIPE"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c33bb2f3e6cso9584466b.0
        for <dm-devel@lists.linux.dev>; Sat, 10 Oct 2026 09:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791648987; x=1792253787; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SY74yF5HVb9LB61pXwGFP4WQfiAcmr9QKqubCWdlygM=;
        b=VzR0iIPEYwmZSVxFxJQLCs+UmwcUpYgzyWWOucm9PRxugVUWC7eBy9Pj9aaB9ZHqsA
         LbDNZA0cLOp03J7tI3PgLEI0tnivYqEIyJ7h3PPm6mwUPu9ySTOntnQOCduwOARQbWHn
         5PrrtehZ66ub6liCzgeJLJWnq8ASAjVKZaRLaeFbBgtrpIAEUW/rPn2TGnEbsVSQsrnz
         I3ohYb6nUtMAr9Dv52I/z9QK2j6zYUxxgcwM79rgDSdJ4Lq5j4qf8jqJwk5PpfV2d8J9
         4189JRnZdOZAkhVmRBsY5f209bycmBkKGchMohZVMaJUHc6dxu7NILDGrxzS/skl9NmQ
         67VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791648987; x=1792253787;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SY74yF5HVb9LB61pXwGFP4WQfiAcmr9QKqubCWdlygM=;
        b=vYyDV4/jJ6qBnfqfj9FW+kK8LjVm3ys//hIcGJISfnLhfboDn+RXfOazHkO5lXXBNU
         1/zQUBYNH9rszdiL4j8xj5ZqlD6TAPT+7+7fm+0a0u2W/KvrwSMrYVhy62y92MGEWvE8
         +uyT7txm+ANJu4i+IfttLSmSrbJpmFqvcXIyoZX7Tboh3jVOAFb3EWIrkMDRS3N/hcOG
         zbfgh5Hg7IOkZHl+iJzzs9GygvULmWXJ5miSlmfWPEID9dp6UMiSJIKeaOgi9r+HNi3p
         R1xwC9nLyq/CatRSYGE3VlnMNXdxAnjpLeNrzEih1rSbHDxeKkvOXrVag04yeQ2CpFcd
         GDKA==
X-Gm-Message-State: AFq9FYKlse2GyVyBiwEHdErPHST/NYGr9tbY1qzh563u/8/fC0xDeaMc
	Sqw8QQ7NVmVK1OQ0pmshW4oSgXmu97jjP0Y7feCYuaEwtzfmMAnQr/cr
X-Gm-Gg: AYBFou2iGFRRgqKIZtsUmzbj8xle4LvakVI/xyVP7wIkP+YPyqQpunCODJZwu2SJl7E
	wow5Ci66AK8pySCKCZKvXDskVSePf8hFD/l+IMLidQ4cKK6+pgR01qStbDG11Q5jsFAQ2RiQKBc
	wGnbX6E9Up3Goav10RW9qIDHew+RquM9aHhMQQ9GnKlrneQdbCGK3cQSONvv079vFfkoN/n1U55
	v13xhBRyT4oLNeq/kUEa84vrEX2v0JMgEWhQkL58QxTag99W4zORnEYu05sPOXRqXQFSMQ9y6vO
	TyFxRlV/6x4WI5J3LyVj4HhVwXwGoZNjruenK27MFxCTOtEnP1JSutFfF/8PEUlB+swW6Ln0oUJ
	ynIBIikbNfJQy3eJnkzLE2YBVwdYPxKS43YDEJCRX1KCfiwQfnFMNzul+v1z1O65Vw+DlpyGj+Y
	rBRpB8qYNF6j8Ar64tzq9a7reKQobHfV1QRJ2iR0vL2pyUOSBf+cxS8fele6wNS9HdrBRuygCv7
	vCEQ7KwKXd1jH0RhxMU9MVzmsbsQjR7tDZVP4W9+U+1AyQ=
X-Received: by 2002:a17:907:c07:b0:c2e:3d17:5259 with SMTP id a640c23a62f3a-c31aa0bf51amr521511666b.41.1791648987158;
        Sat, 10 Oct 2026 09:16:27 -0700 (PDT)
Received: from localhost.localdomain (87-205-122-125.dynamic.inetia.pl. [87.205.122.125])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9a3bc20sm262613566b.22.2026.10.10.09.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 09:16:26 -0700 (PDT)
From: illofspeed <illofspeed@gmail.com>
To: dlemoal@kernel.org
Cc: dm-devel@lists.linux.dev,
	hare@suse.de
Subject: [PATCH dm-zoned-tools v2] dmz: check: do not use the write pointer of conventional zones
Date: Sat, 10 Oct 2026 18:16:24 +0200
Message-ID: <20261010161624.416-1-illofspeed@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With more than one device, dmz_zone_is_cache() only matches the zones of
the regular (cache) device. A chunk mapped to a conventional zone of the
zoned device therefore reaches the write pointer test in
dmz_check_mapped_zone_bitmap(). The kernel reports the write pointer of a
conventional zone as -1, so wp_block becomes garbage and the bitmap loop
reads far past its two-block buffer: dmzadm --check segfaults
("Checking zone bitmaps..." is the last line), and --repair could clear
bits based on that memory before crashing.

Treat conventional and emulated (regular-device) zones as having no write
pointer: every block may be valid.

Found on a cache-device + 27 TB host-managed drive set after reclaim had
moved chunks into conventional zones (stock 2.2.2: exit 139; with the
patch: "No error detected", also on an emulated ZBC drive with the same
layout).

Reproducer (scsi_debug zbc=managed, no special hardware):
https://github.com/illofspeed/synology-host-managed-smr/blob/main/repro/1-dmzadm-check-two-devices.sh

Assisted-by: LLM
Signed-off-by: illofspeed <illofspeed@gmail.com>
---

Notes:
    v2: no code changes. The only change is my author address: v1 went out on
    2026-10-10 from my previous address. Please apply this version instead of v1.
    
    The addresses in README.md are out of date (wdc.com, dm-devel@redhat.com),
    hence this goes to dlemoal@kernel.org and dm-devel@lists.linux.dev.

 src/dmz_check.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/src/dmz_check.c b/src/dmz_check.c
index b13d025..943308b 100644
--- a/src/dmz_check.c
+++ b/src/dmz_check.c
@@ -509,9 +509,18 @@ static int dmz_check_mapped_zone_bitmap(struct dmz_dev *dev,
 	if (ret != 0)
 		return -1;
 
-	/* No valid block should be present after the write pointer */
+	/*
+	 * No valid block should be present after the write pointer.
+	 * Conventional zones have no write pointer (the kernel reports -1):
+	 * every block may be valid. With more than one device,
+	 * dmz_zone_is_cache() only matches the cache device's zones, so the
+	 * zoned device's conventional zones reach this point.
+	 */
 	bad_bits = 0;
-	wp_block = dmz_sect2blk(zone->wp - zone->start);
+	if (dmz_zone_conv(zone) || dmz_zone_unknown(zone))
+		wp_block = dev->zone_nr_blocks;
+	else
+		wp_block = dmz_sect2blk(zone->wp - zone->start);
 	for (b = 0; b < wp_block; b++) {
 		if (dmz_test_bit(dbuf, b))
 			dzone_weight++;
-- 
2.43.0

