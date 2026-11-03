Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793743485;
	b=IRtAyH2wNLd7Vr3ChQDwArr5RPtqHkJKVKqH67/ZQ0Vg3gc2zqKlfiGNXTlr7en/tKJg
	 vKQVHZrth+oukh0uBfis+DcJ6S6QNr0xmsWZwqhCVBOwSiIwcMKrYk1xW6dGxmqULZxYF
	 auO8nJ7heVRQdZgW/XBsgmqKpc/aYxjnqSVDTS/4+KYbbjKvRmks9hnX9AXZNkT1eQuJl
	 MccPQY3tvPDNaQEYbmVe1Crk1Jc1Kn+KA5+3XR/4MPiHaVNK/p861aX61v6EtMjlE8y4O
	 1JJMGTzOdMPiaG332KN3+UEE/fhybkpkB0bXfjrrHBlc/oaygNUjZneNASgP3inJiXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793743485;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=DRh2w4Pangw3Iq0EA5ngtLB+LaquWxF2M7Uv4GbVl4o=;
	b=wR+RVqXVBJz6DLGJVBIaawoTD4QVCIRib3qpBAiU7A+CQG6lOExL9gpBrsCxE7VYcBMu
	 kBw7VN3dzRUTc3S+vD3B7WD4TXpxpMT+IyfUZEpyu3DVaurvdh5F0oT3D9rqe3eCU16+O
	 TaFl7p3C/RbfjOpEzlsqo5lmHOwp7RIG5Er1zDMjD4/7oyqrLMd31Er/txD8diLOK2r5q
	 F2pRbwscl+rQcj9ZNPkcPXGzBeZZarn8J+35m7ffZLmrllHSq76EFGTof0mE0URJyAWrP
	 f9Qphz2ysrdatWjjXBKg6qjq8H8HO8VxMAcOqS/sELKrnFDHw4LQO57Bivq2dO21lbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UTSeXpuF;
	arc=none smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1549606D81B
	for <dm-devel@lists.linux.dev>; Tue,  3 Nov 2026 22:04:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1549606D81B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UTSeXpuF
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c450ab1483cso10467366b.3
        for <dm-devel@lists.linux.dev>; Tue, 03 Nov 2026 14:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793743483; x=1794348283; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DRh2w4Pangw3Iq0EA5ngtLB+LaquWxF2M7Uv4GbVl4o=;
        b=UTSeXpuF/s0OlkqRRLxk9Xa9qqerEpaV0KxEDUl4PrFux/ECJMDpUldscweVnpfgmL
         5urrZGAoyj7LKHLhOKvoCutHO1P9go1BShtHJWJeJKrkHXIBpJaYv+dCdMsJTcrKJ8HL
         uo0QZWEfVvhRiR3TDjyqkjmjvIADagPevNo7wFKIjDQO+px2Ho5nRP+ksY3+AoO6BkA0
         DK9IUnWIllV3+0sOFNV3DWOV7YRn6LTgmG3r9k3jXJaTi4Fd9epEN7a/s/Kni0s2YdYW
         oFO/Scl4s1Oi7wrb1kwUUh5leQEh0OKjvtGk2HkSzYlAVqQXnStVZyFKhwTIgeCC21Oz
         VgXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793743483; x=1794348283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DRh2w4Pangw3Iq0EA5ngtLB+LaquWxF2M7Uv4GbVl4o=;
        b=y0w5rOLWVlOXvPajf8fCYrH7DeZr6ydSpm86csOSd0Nns2SSaIEtTvKAPvelbLXvLo
         /uSmq6Qij5Dx0YbxlZIKELP6yY4Yb0XB027qamB521P1J7/Ugxd0gYoZIg7M4+33mZuW
         JduNWhibkAciARaTqS/lV6SQP0lrmgSbmsI9eiX0Ozd7HvMK0TftttaXc6UAAPmptHY8
         x4xpoJ7PNFJ2g0Krh+81OEAUmbk3Jw/D6AyMT3JbXG486XQmTMQJT0L/a9dRzpQnkld3
         aL7bQ1Fe2jwuFxbRT9//vO8KqiWA5uQ9eMQ1yZkvl1pkD8IgubLg6PIl4EO4ydPI7n9N
         VUjQ==
X-Gm-Message-State: APuU4Z8SBClT+cQGuktfeBnXYe8buG/UhkLYDyNPLI2pVeJ3M9u65Fl/
	YBGmIcrXyBAdYGA/syMhQ919FUId5ySjWGJZTvSJ+Xp3KBhsjwpRGwTMQHaLjdcR/FY=
X-Gm-Gg: AYBFou0VWYzejv0NQddgacSyu9jklHXXRcqTDCbvonuP8Xb6emqBdyEPLWW12VJqK12
	4NEpo2zIILTIiouQemO+YuzHoVLpHnb6Vj5HjoedME1n8xpUaEFCY6JuAn3sPNBVYL66MpKzKmC
	26COwR4KRgdWLgGkQCXWp5QcEZgeJBl/y/n4z8jm0c/CikaPFExnBMJtwUDcTJl4YVl2K3BO35/
	gdDSrMMgiDy7cgF2+5eF/kM+dNpW2OVxI+G4mWSAkQMMROTPkSDCA1pk3/ZGMGnaOZaT3PKS6/I
	enSWieG8xTqJmR/k334+9dKaohmzdFBAYdqqJO6ByDGajjL/aKfEKZuA/sEdnWzJdTM9YrByBEZ
	U78Zib22W0fhZaeZJ73ToONcK24zwFh3CBmkYOKf1H1EmfraKFh2p7dcB7RfrwLKW1BTLh/nYzI
	z9cVCIKvESLjaoSgISaqmwsMV45c9dUYe9milCfGmrKjjnEDpkc6GexNvQf5l96g3vGMwjgiYAh
	eVipK9x6qV2vnmlyoz8Gc7ocAaIvoVk8jhPtX3iphu1FqgTGmsfdB3RLkfbh6fOTnHkvCKjOUCX
	MFMNEQZJIfNQjwFte770bDR6sqAY/MvNgZBWr8ylSS66MRELv+qd0bc0GWCZVAmLOCYDeuqcA5s
	NvO4N
X-Received: by 2002:a17:907:d26:b0:c2d:c800:d797 with SMTP id a640c23a62f3a-c4ca79478f8mr1169105066b.6.1793743482951;
        Tue, 03 Nov 2026 14:04:42 -0800 (PST)
Received: from localhost.localdomain (host-188-122-3-146.finemedia.com.pl. [188.122.3.146])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d0e424c34sm4574266b.13.2026.11.03.14.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 14:04:42 -0800 (PST)
From: Kyrylo Biryuk <illofspeed@gmail.com>
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	snitzer@kernel.org,
	agk@redhat.com,
	bmarzins@redhat.com,
	dlemoal@kernel.org,
	hare@kernel.org,
	hare@suse.de,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 2/2] dm zoned: do not reclaim a random zone into another random zone
Date: Tue,  3 Nov 2026 23:04:38 +0100
Message-ID: <20261103220438.510609-3-illofspeed@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103220438.510609-1-illofspeed@gmail.com>
References: <20261103220438.510609-1-illofspeed@gmail.com>
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
drive kept reading and writing while the free zone counters
in "dmsetup status" did not change.

Only switch to a random destination zone when the zone being reclaimed
is a cache zone: moving it to the zoned device still frees cache space.

This depends on "dm zoned: back off when reclaim cannot make progress":
without it, dmz_reclaim_work() would retry the resulting -ENOSPC at
once, and run dmz_check_dev(), for as long as the target stays idle.

Tested on 7.4-rc1 together with the previous patch, on a two-device
target (a 512 MiB RAM-backed regular cache device plus a 1 GiB
scsi_debug host-managed drive) filled until no sequential zone was
free, then idle for 60 seconds: the stock module made 877
random-to-random copies; with this series it made none, and each pass
failed with -ENOSPC once per DMZ_IDLE_PERIOD without a device check.

Fixes: c5c788595292 ("dm zoned: start reclaim with sequential zones")
Cc: stable@vger.kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Kyrylo Biryuk <illofspeed@gmail.com>
---
 drivers/md/dm-zoned-reclaim.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index 077a8a50197..152cb878811 100644
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

