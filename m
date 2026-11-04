Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793783765;
	b=ORTTLqT2pxj/IUHzIc1vcqMMOpSfzud/LX2w7YejGRPNgiXbTE3H0jiSjO230noMXjSo
	 KFGvHeJGzl9mnSmUTTdhmn6ztwlMNSjnKcgq+OIasR3fEiCpz9rOR3tb2PDKLv0qpu77T
	 TqMAE+qrYGYRxYVMzoQv6zkM8Go1OvQ/Mj8wa1CpD0yDDnU02P12UUDNI9j058Tzq3KUu
	 gwRfSDzFbK0CBQwb5BoyNm0UnG1Fcx7XdSAagYeHeMscEz0uTVwJQD/Bh8ghRSxrFe8Wb
	 rUm+AV/paHI5d+k2qTkZ6kg7oxiLl1uvBr1cPeqogNGDtVPEmBQdufRtbRpsAMinhLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793783765;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:Message-ID:To:Cc;
	bh=ufI9lQZjERuESeipE2ezcTBUQEHZtIN68AOZp2N7TDk=;
	b=fanCuGhMe1qnUCXSgzGN4/g6GiH8anGcglYx13sk7bZWvmw99JzNQDhdNwK8tGGL3wXQ
	 8Ns3fnMzt0I8qBkIbTkktUyPZBhyzntI+87pBLnaTewGVfd9g82CfrbYWdxCBf0t0mhvX
	 o60os/u4ImanQRxiXLUPyis7vZ7r9KkMGznZTl+5q+EIFTt9yS8kVrZ1JvCTJjtlKRTKg
	 Lxxo8UuscHu/Eb0APkb2GY4Aq2DxxHt+QXDwwGRsiwh9hwPJSzUZqs33dcmX0CqF8RHsN
	 pizk5B8/kINgS7DmAxlH1Ajiruo0wWXf9OAzD5A9XfT1A5dvp8DNUpYpu+rwwMBPOog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="k3/7b5IY";
	arc=none smtp.remote-ip=74.125.82.180
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0D3606A326
	for <dm-devel@lists.linux.dev>; Wed,  4 Nov 2026 09:16:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB0D3606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=k3/7b5IY
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-3282db206d3so947216eec.0
        for <dm-devel@lists.linux.dev>; Wed, 04 Nov 2026 01:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793783764; x=1794388564; darn=lists.linux.dev;
        h=cc:to:message-id:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ufI9lQZjERuESeipE2ezcTBUQEHZtIN68AOZp2N7TDk=;
        b=k3/7b5IYLSpOWm6D6V4aB9LcQ+7dcnQeMjAHNlSVYA8NE+cxWuaGVCLfBtLIaYRggw
         EnBUIIVopz+Vq4+/Qm740L27fXAW7CeEabP8RVOc+YogA4r6TBjejH/5g2JfMWgIJ5S9
         rh6zH0zM6SJUW3rDolBi1zxaJ0qAqzaA9SMxHOPByH+X+lXDr7/43eS41Eqck8HxMfEo
         khI7s2o+OGmw+lVQXPFlpi6BYZYYvZ3AoVbixlJJAn9xyMjmm8ZMrMlaRIIOmOfdNAkP
         iFF3RnDNjpdCvFMCVxDDSF/8yjUhIBAVWEBVT7Stzs6r1rKoGlpZgj1nUoMTnt6jOcXb
         3SvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793783764; x=1794388564;
        h=cc:to:message-id:subject:date:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ufI9lQZjERuESeipE2ezcTBUQEHZtIN68AOZp2N7TDk=;
        b=a8X3yLoci7Mk7bLqTEADkWju0s/RCbrEYvUcPuws9eXTQcgmPDA+oYvpCJ1kso35BH
         QMP2ceoS05HuzBEIqicPvpkxXUNypRtXuq3hAMCwSJcQk0GncPjCERwpx+C1X/ZCUPug
         UoQQRtMGX+G/8SUeRnoVBMncIpYLaaebrAu/6OUAyYEknZzHXd6EzoplQBMfOIJCoWFZ
         TMCY76q4F3PIlFoXtUveNyX1htrStCJv/YbXHmE7PlXLO6w1lSH4vGSnuHKxF8gFgm1W
         /eZCPrYGdeROPheFrAyjuMTT/cltWmBpfQTC4ti7lHqDlbohgkZN1ekR7gLeOansAmLZ
         UkIw==
X-Forwarded-Encrypted: i=1; AKwUvBy8CLqLiwBtB54xFoeufgZuWuWVGEQydJT6SmRAQpQ9KT6KyipCBtu6HzbwKXg9S6FJpcFHo8zWTA==@lists.linux.dev
X-Gm-Message-State: APuU4Z/85JSQbOCmvpTqZMfqoODC3Met+3Cc1aHZTlAw2Gw+zM+aS3Qo
	EoNM/xjJ+htcHEHxheCSB867WlyneaIddBQ8eunB1Cu9uRGSAgTLgem9
X-Gm-Gg: AYBFou2XbNfUt6eBlog61rHiE94IZ7lPB4s271+rsItxieDiLjnfv8qlmTK9DQ8MdOg
	WyLUyqrZUZ33P/O2eBGxPdSI0BwHbjT9R0KHzqQOBmxPd7XQqyklqoji1n5tkpjydsoPwCRgr5X
	B6Xhar4ABBG6M58ZniYAAg3Ue87JTaPge7xYdO11clkJEaVhv9QLoli9kRzvyVsh53TCPZ0JFXl
	RAl4RCdix6r48YOtFSNAnd5MZQyUlGzF4h8teUwPMwk/pB4k8c/aOSAQEGE4uoCBcukWqaudMvd
	rsiwDj3UNX+3w4eCbvZDe+Jpk9YG+spVxl0VC/hPkCnODKIqry0BOZ9iRZ2s3HM/qwzyEvVuaZx
	HIB9A1RBDcUbEQ25YSKWjqDEqKqdnU6WlnUYcky20/SSNPzlUnv+2Niw8JwNjdQzr/gHxotxOlu
	iTJW/W62RWp5SpmAVQO2a381Vjes46/UTE0yHUKpZCBwCJeAUonhSioiFysrZP/Bhg4Fx3PesLa
	+e1VneToZ3mjnfWvIahjEqp+FvY75M8L/ssTH8DgRilVnpmRQxaf/zCc7R51mWVE1jeDJ83i5+y
	71v37PLNks/PIsOh7b+fSTfhN/DJFCDC3kfBJjQCqi6pP/do46w04YgVWkuXMmNqaA==
X-Received: by 2002:a05:693c:88cf:10b0:368:2548:c08b with SMTP id 5a478bee46e88-36a4239bcd6mr26660209eec.21.1793783763666;
        Wed, 04 Nov 2026 01:16:03 -0800 (PST)
Received: from [127.0.1.1] ([23.247.137.67])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca394f297sm6731967eec.21.2026.11.04.01.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 01:16:03 -0800 (PST)
From: Yaohan Li <shunsheng1218@gmail.com>
Date: Wed, 04 Nov 2026 17:15:42 +0800
Subject: [PATCH] dm: avoid double-dropping the zone reset submission reference
Message-ID: <179378374219.68809.15920762511563622507@gmail.com>
To:
 agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com
Cc: johannes.thumshirn@wdc.com, mkp@kernel.org, dlemoal@kernel.org,
 axboe@kernel.dk, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list

On an error in __send_zone_reset_all(), the submission reference
held by the dm_io can be decremented there and again by the caller's
error path. If another clone is still outstanding, the second drop
can release the dm_io before that clone completes.

Only drop the submission reference in __send_zone_reset_all() on
success. On failure, leave the reference for the caller's existing
error handling to release once.

The error path was reproduced under KASAN with an injected GFP_NOIO
allocation failure while another zone-reset clone remained in
flight. With the change, the same failure was reported normally,
without the observed use-after-free, and ordinary zone resets
continued to work.

Fixes: 81e7706345f06 ("dm: handle REQ_OP_ZONE_RESET_ALL")
Assisted-by: ZCode:GLM-4
Signed-off-by: Yaohan Li <shunsheng1218@gmail.com>
---
 drivers/md/dm.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1881d86111fb2..c373cd3f635fc 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1929,8 +1929,13 @@ static blk_status_t __send_zone_reset_all(struct clone_info *ci)
 			break;
 	}
 
-	/* Release the reference that alloc_io() took for submission. */
-	atomic_sub(1, &ci->io->io_count);
+	/*
+	 * Release the reference that alloc_io() took for submission. On error,
+	 * that reference was not consumed: dm_split_and_process_bio() releases
+	 * it on the error path, so do not release it here a second time.
+	 */
+	if (sts == BLK_STS_OK)
+		atomic_sub(1, &ci->io->io_count);
 
 	return sts;
 }
-- 
2.34.1

