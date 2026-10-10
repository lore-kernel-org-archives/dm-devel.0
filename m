Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739363EE1C3
	for <dm-devel@lists.linux.dev>; Sat, 10 Oct 2026 10:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791629495; cv=none; b=NH4VOXjbgRjj98s441Ct+sCBxugTp5C9TQFydJoTWuC0FJUlK+3GCBBp4UYDLxy0n7c1D0OGVI9LxLDksWcqABXQgShXHUxV/iXNvtoO80PGQwxx5rD2IDVmq9g86BQ/k/w07bDzCl09lhARMdMrtlpvsXXLYw6N+d/oBf1uQ/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791629495; c=relaxed/simple;
	bh=tNQJmCZgUYS47R5I0jToyFsSmjL5btpsCS3GXclEphQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3yRAtsUAsLwwL7I4KNeNteNO0az2yQKQTbY3c0NQ000jig95/BBGW3RhOW3uRpQoIOu6ddfsrJFs3gkGrrOdw6zxxUbvWFE8cuRLe2P8uXl8LMtGMBZyu4E0G+Dx6MioDRM25+4gXrTeK8u+XW1ciM44b7hT5MRybCEMxU0jwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pQ1WCUcc; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pQ1WCUcc"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c263415982eso74583566b.0
        for <dm-devel@lists.linux.dev>; Sat, 10 Oct 2026 03:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791629487; x=1792234287; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o8/qCglHjBKXzAovzJz2hn5sGjkgblIvlrF6aEQJipk=;
        b=pQ1WCUccLGYB0ewUgr/Z6R59eIF+djm9DHiwPQFGVzL4f65qIES4FcBXidCw4cHZ7G
         mD+vCDpS/FqwSbT3tdjUpTh8FLRoRqT7oOgdQgt5Vnp3piOhlwGnNw47Mk+TNbEzqDAz
         mN8M9Q33XUsLWTuEKOkB2H0mxf4G2gfmwCXQIQKiQqUXU42NVSj+ggJM2ACpU+/AKBFT
         KaHiOJmXU1euItbcI0H5zhJoNK7KKWT0jHd4GYPI6S0Y/KW30FlIoTxfFgm40Prx3/yz
         u/vAQA8uQlyBfh1Eyv5Pqyb85hwYbOcveTsTGBNYTu82R3jPISikRIPIFnvoM2tq7yoV
         3YXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791629487; x=1792234287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=o8/qCglHjBKXzAovzJz2hn5sGjkgblIvlrF6aEQJipk=;
        b=z8BA4DSA5J2jWOsayO9enToo7/zn6wPG4V6/j5Racu5ilEPBdvpYDL0lk7e2I8O4h4
         hjwUKTn/OB91qfn5yPYIc1Xu1gV008sagYYf2QB5yW37gC7k1SPQsKlJGo4Ct+bXMViy
         xulaBvI1F1vu/1IeGtVqF/L4sy52mdqve37/U7c9A0DH0cWAFEM2NPh6DmZY78Hv8VXl
         fLUcTaiulqWkCd0cYJQlT3/xBl4PLzc0CE4rvn+NQB7tnpKDWHfo0NnKY/uCeJw8+CEJ
         IopIWkzl8kHwwu7mS4wGkYQkoOns6aNhNuJy9eamzUCLa+dT2Ot7jKirCx6yl+tgigsP
         dokQ==
X-Gm-Message-State: AFq9FYJpk7LODiiWkBZa0xqCMq5wsNvOJZiYYis6Y0x/uHBd3rtgdmO8
	uHmN9SjCAXn7AyWyMOeeZPbJyx/5cThRwiXm9mwS2gkOrtx3pnOwkptq3Ag5DSOIGyZgq6Dsshc
	=
X-Gm-Gg: AYBFou1IH3k+2px2jZzIxQud6JHcp11gCNX75pRcRIcfdxRJcZHsrD8PGUoj7nAhb5h
	19mukGuGlBIxgmUCIJKthpSM0GzhK+O9OIQk6lIMLJZscPX/ck8k+K/5kQFv0G0fnfhc9waX3Gz
	BOAn7xHfx2l/WEH47w639x/hKiL3v0qiJ5mEKB5o6/kyb9JVu/ijzf51VBG597UIM2gSgcfnvBS
	EveAHKfAJkTYMiFC4HUJNLm38TQyHfW3KoD2yNYFO5+OlOcIF5JZpkQzIMi/zilO2Y8LUy2ozl8
	/3kQxBk0Zbx3qzirUN6SvhKIImcTv+cpfI8s20oIT8PC/6V8EoY/7VXLqE61dv5jpoV3ziCQKtT
	gT8EgZB6zVpEM7fWFDrCyPO1hhFviXSjHOD+9KnLGCbf0ktyxHUlnjHcRBGtU066DuU+rpCJaN6
	TgbkeJPGZPFYAsxMkC2Choewk5OJCvybqYmGVk1gNEOElhS+kCDyHHHd1byjT3qJpQtjGhb11S7
	yxZfO2zvUtXMTNiULpdwkn4M1TarJLwelz0RPwwU8ByE70rNTglhTxPH66ZJtw4Nv7g0vUoQ9Iy
	+3KUw5a72oUNxw==
X-Received: by 2002:a17:907:9694:b0:c20:9447:bd5e with SMTP id a640c23a62f3a-c31a9fa1d3amr497659666b.9.1791629487376;
        Sat, 10 Oct 2026 03:51:27 -0700 (PDT)
Received: from localhost.localdomain (87-205-122-125.dynamic.inetia.pl. [87.205.122.125])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9766743sm229984566b.4.2026.10.10.03.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 03:51:26 -0700 (PDT)
From: illofspeed <volvo.mail@gmail.com>
To: dm-devel@lists.linux.dev
Cc: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	hare@suse.de,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] dm zoned: do not reclaim a random zone into another random zone
Date: Sat, 10 Oct 2026 12:51:21 +0200
Message-ID: <20261010105122.398-3-volvo.mail@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261010105122.398-1-volvo.mail@gmail.com>
References: <20261010105122.398-1-volvo.mail@gmail.com>
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
Signed-off-by: illofspeed <volvo.mail@gmail.com>
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

