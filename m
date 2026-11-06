Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793988494;
	b=dHjP2stnYkPjlJj4w8YWGm9zF/ZoX2DuxrNjvYakeqJz5UaNYxV+BbKTuff5DoDGMJ8W
	 E5yuPMaqhEoFB8sBNX+SApPytvVUPIuSLjF4yGC1mWJboeCQHStXbW5Bg7lbsaHi9NWTh
	 OBg/k/+j2YGhFnB5fxEmE/u73QD0+A7znSIVerjT7a/2Uw9YGxio6IJC4zIJNd8Yi4LOZ
	 g3GbOBSnsfbdBe3/NY13PF6CCVkBq5vANFPLvbvmaI+iXp0SdvoU09X6plVS3pnRb7Mb4
	 4MbhuXyeGjfTgGAbPPnwwjgoKrETRmbuhdlyF/bWf9VO4Fm4+Gs6LR6ZfgGztP69rnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793988494;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4SY/KgBc5jPjR7kY6LZ58uTUj68rwgS+h0034ZsmJvw=;
	b=xao4rrPPkTUzl/t1ARiN3+S6lw9v9SNj2f0zKpqCnn1WJvdTs+TcacSzDGrzYRYlb4st
	 bIRqVN8FUohKZS5hmeuwd+WX70k9KlAcAMtX8Q5a9YFdjSVXQxdRyGuOTg2JGSxf4Cr4R
	 9QfDQImsRAyuW79YVZm6rpT6eVtvhry9CLZLTk6ZfnOzzs5+drhz7nT6nkigSKUDVuyjx
	 siPits+shKeOzTVQ2J1FlfSuedsmnIL0tDXkKJEXBYInTM78VL2br7tuItjMXKPR9JvYj
	 UXD+n50W9B8/gIZN0j72dZYNCtvxLlBJEjMZD9fzLC20xoPwFrOIf4BXn0WVT8LlMYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Nw38n10e;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60690606A330
	for <dm-devel@lists.linux.dev>; Fri,  6 Nov 2026 18:08:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60690606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Nw38n10e
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso851861f8f.2
        for <dm-devel@lists.linux.dev>; Fri, 06 Nov 2026 10:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793988492; x=1794593292; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4SY/KgBc5jPjR7kY6LZ58uTUj68rwgS+h0034ZsmJvw=;
        b=Nw38n10e8M+GWT40OR0P2z5uN07iI6YEsX9sAjAzbRYpPB9SyYOLBm4Eowi7aloXMP
         5OTmJFDyNwfwgEate+2GwBDEKqoaCjbwI3kA9thXnHD4IKVqxFTZtof1X7X0bPHR1o+x
         Zm7CEPkkMlf7KPjen2vEdqzELOoCtwUoPHJWoa2ftXDSjiipBJFHAGBYEMghUtCssH0P
         +Yzqb1M3lX7rKgBcxPbz8BplbGEgoHsO1TVrLlzUkIEY6IrBSSgl9qOcaKrMdvsbwPIg
         4K3rroMGlcKg7SINlp1nVjhBjXQI3Sw31WvlREYMEgMmyCwN/POIwLJi1HJ0MtC82dql
         aFDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793988492; x=1794593292;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4SY/KgBc5jPjR7kY6LZ58uTUj68rwgS+h0034ZsmJvw=;
        b=24wx28A8aIaP3fijAk/xV62M1OC08qYtCHSthrnefz0LfUiSp7ZEE5VKFQAUaw2aXK
         gJADHhb0+y/O626fjmofEZ0I/+SSoJlzS3upGLa7QWaEsmzxry2ckf+cvNLpEVVAesx7
         WnuvWl+ScdtAUfz15ZepDyj8FZUIbiWO5qLQjpMaL9tObIxhvEaO0N/2Ox0XhqN+t+9j
         mPZTqCdclbXS5XHtpkaosGij9NtxvlGWSK1tLyZO/XohmBO9+EmtpoymosQBAaegHqr8
         xIFKQ1VgwfwrW+X9iRo3n+kKMOiHwN3+dxfQN2Zl9GY8i2B70d1X79I+GuUIi8HRcMR7
         AeRA==
X-Forwarded-Encrypted: i=1; AL+hErGSYscxY2fga+XG4pAspsl+53Hc2pHAstt//aFlcY4Lp1sUY5v6jLVqI57STl7IzzEbyDsb2Et77w==@lists.linux.dev
X-Gm-Message-State: APuU4Z9a6THaQInRdl3ZjmbaaKgrYbxPMThVUqkW85ojyFm3BT65ryg8
	3ZZMyiCiUozbJDfC6Afj3zKcuVQhU4UlroRMb5hA9WuwHOYCUzUEhBqC
X-Gm-Gg: AYBFou3g7UEuMUiU9Tt1HM0ujweO0Q5vGewuSwO67FNR0niMdEOsZRZnpxYDK5nlnv/
	JecL7iaFRspQhYoiz93NxvzqrLD4b40M9/czNibVfvxPz4OT9GoojUYDrIZIiiJS/zCy0X+H+rE
	OglqojI6RniVv81TU1LvHeR9Bgrc1t7FByO+HwWi/x+iLE0MuxPqREqR3dxIjxtV8BryNs3Anjm
	VHWUHHTQ3wSETRlprnEZ3wXLReMAFOilV2AiNlu1mNgv4bv+yh7yEkLyooVrNtPVwpds3rZMFr4
	znOd6vUSJ4mrKdc5cKEri7azWZCS7dtybiif72Er/4Em/kPLTHe9jiWoZiHA4pnY5ARHupcPMde
	/OUaM4pTG+oguNFWyaBDwpk3wHgbY0E6crfqifamah9EOxYTy1Vvw6cmiYde9wGOoy6TgUao7+O
	Dy5uNkUXaRKBWE6ZYkP1/x7RtlPkeAXFZzgUTN6mrU2qK2eROv3whniPit7NbWRJuUvlTgcnA8t
	NBQ8sHFW87CjZ3GMZsbOLOP468WRxdhDVgVC94ZqDTjnb66FO1bPgm/brvUVcqcTrmJbA2z72kQ
	TjO86c+tzdBkKuWUOpBL/KigEgUiel5/FA6xgfvk+/j1Og5rqwqmp9FXz+9vYn8N+0buWh3l0Hx
	pfKA/fezEmshNGujMQbvMIYXcM0TLetI9SJq+swdVZ2JAqZH3n7+maE7LpUaB
X-Received: by 2002:a05:6000:4818:b0:492:820d:5e6 with SMTP id ffacd0b85a97d-492820d0d4amr5606669f8f.49.1793988491610;
        Fri, 06 Nov 2026 10:08:11 -0800 (PST)
Received: from DESKTOP-IR7J1S9.localdomain ([105.99.148.33])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-492d7232832sm4830636f8f.25.2026.11.06.10.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 10:08:11 -0800 (PST)
From: Drif Abdelmalek Mohamed Said <drifabdelmalekmohamedsaid@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	syzbot+3e16980543e238b95bd1@syzkaller.appspotmail.com,
	Drif Abdelmalek Mohamed Said <drifabdelmalekmohamedsaid@gmail.com>
Subject: [PATCH] dm cache: fix divide error in too_many_discard_blocks()
Date: Fri,  6 Nov 2026 19:08:08 +0100
Message-ID: <20261106180809.1419-1-drifabdelmalekmohamedsaid@gmail.com>
X-Mailer: git-send-email 2.43.0
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

too_many_discard_blocks() uses sector_div(), whose divisor is a u32.
discard_block_size is a 64-bit sector_t that calculate_discard_block_size()
keeps doubling, so once it reaches a multiple of 2^32 the divisor is
truncated to 0 and the division traps with a divide error. Smaller values
above 2^32 are also silently truncated, giving a wrong quotient.

This needs an origin of more than 2^45 sectors, which is unrealistic (this
is a thing still in 2026!!) for a real device but reachable with a fuzzer.

Use div64_u64 so the full 64-bit divisor is used.

Reported-by: syzbot+3e16980543e238b95bd1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3e16980543e238b95bd1
Fixes: 08b184514f65d ("dm cache: revert "prevent corruption caused by
				discard_block_size > cache_block_size"")
Cc: stable@vger.kernel.org
Signed-off-by: Drif Abdelmalek Mohamed Said <drifabdelmalekmohamedsaid@gmail.com>
---
 drivers/md/dm-cache-target.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 1a5072425c4a..2d40d6047ef1 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2383,9 +2383,7 @@ static int create_cache_policy(struct cache *cache, struct cache_args *ca,
 static bool too_many_discard_blocks(sector_t discard_block_size,
 				    sector_t origin_size)
 {
-	(void) sector_div(origin_size, discard_block_size);
-
-	return origin_size > MAX_DISCARD_BLOCKS;
+	return div64_u64(origin_size, discard_block_size) > MAX_DISCARD_BLOCKS;
 }
 
 static sector_t calculate_discard_block_size(sector_t cache_block_size,
-- 
2.43.0

