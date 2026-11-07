Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794036420;
	b=fxRAhNEr+yggfMaMc+kD9i3MZ7bgDsxYL03eVk07e3cIb+0ia3+5reoKqUqIsqCkm/mB
	 mEF4nmlW727z6SDG3UHsIcn9Kqc5YDoG6bG6ItGwdfnR8E49JgP+vBEN7Lb962fG2NFci
	 sph0c5rpJN6lU4Siy0xUXe0fPubwIyNISdfhQqoQrjUZW+3ABOlwy8kmclalnGWH+lKHP
	 a60hLsU7Gcm7faQQYjrEwqPQfrwMIXG6QCQo446v102Dt4Fp2XKINO7xJlpJVX42VUtyB
	 yL4EixV9URQvib3m6OrROytCdwUKXMZooeCtguCo00k+ioQVokL06TSwhfxPVzPu+4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794036420;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=PSwvgBY5tKnxuW7xy2pwUvdfMnozikmSscxGDiw6G2I=;
	b=dEIFi3VMigO2VvB9Ba47Qd5sqKm8/fOYQdKVra0SuQMzXPVMv2Z2n5vW4gPQlVaxyUhw
	 Htq2lXrnm5691/GkkE4HV26qvcOfM+IjtNHxx8EpmsNzjN23Nkn5hAb9Ex6yzv2SmOHNQ
	 RxBHnr8uDugWocg5v4sDfvGoETnOBwpuTPLvSkRQjr3JQgGIkZ4Z4NndlIH3TrlAlwioQ
	 RMiXpS0ELcayoMSFniqQ7Hmu1Bga7ul9J+VCvhVWGMlG2k98r4mBorpw6rTSqqZxzbm3z
	 o83K4+PvTMz8EEl0aG52A5s325GQT/VOT9+Qaq59zY3MreemHf+TAmDBiQ7Nw5Nq6EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RYh5MZas;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE1C606A32C
	for <dm-devel@lists.linux.dev>; Sat,  7 Nov 2026 07:26:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2CE1C606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RYh5MZas
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so14077225e9.2
        for <dm-devel@lists.linux.dev>; Fri, 06 Nov 2026 23:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794036417; x=1794641217; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PSwvgBY5tKnxuW7xy2pwUvdfMnozikmSscxGDiw6G2I=;
        b=RYh5MZasiOLTEmJXF8VYlAqqkaRH8pm033qaXkEvZ0sFHQVkNqZ7dEOrvnGsDCW+zC
         OzVyZ77KB7CXRj9X8Cv1DDuW9CcY+MHuIzMGmoxOr9I3laB3UH99tRWvmmm28X18wOGp
         sjzauqxaeiioRMHOSrGPIU8p4y40LsbRRlGaB3zk6lkiSGJWdqcec4YjBUQQPfY4fZ/K
         6bzy2DTyDIh4BTq2qbVX8FZ9cKRPOjPQZbthReQzIcKfEQLQ3xdOEsH7mq6BmkujtapU
         vohXNbUCOAjbs8bkau5UiW9wGV/nvEgnOesQytHUnrjYa6Czfshym0d/4JxxAb5p4Irq
         3xjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794036417; x=1794641217;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PSwvgBY5tKnxuW7xy2pwUvdfMnozikmSscxGDiw6G2I=;
        b=zDTKkbBUTnn0kOHcnPX7elj8LKIH7O/EFueZ1Whc5bvkQn5VrJj6L7zJ5L1DD4kxj/
         Af4DVP9kot2aIV9ko4ACuYT4aavyxX7qWtrKdweHf3Ho5ulfgkyC90Oxsy7RXUWOF6me
         KgCYPbwqwV7Qs9aoHKMuraDSaoH1hq/CfUW3jZugKkWydScJ5TJ/n1KbDPXl/ZKCb9q2
         Ah8vE/S4HsZCTxiYECB0LAG6jmzR0/zOaXtflfk5f7vPbyyHkiXdEQcrLYzdepWbPIkQ
         EhIpJjuCABqahJoB6p/nZSpCiiGf+q6NRtTDgmmq0OTAj3yDzg5BjopvFIfQvZqWsqsV
         Gs3g==
X-Forwarded-Encrypted: i=1; AKwUvByEldlo+mjVz4NhwLMi2aaL0HHWoWWBVQGAUOBtwgOecEbO3Mctng/Vbgz5Z9vddBcw88++45cutA==@lists.linux.dev
X-Gm-Message-State: APuU4Z8tvwgHrIX44Ev/9CHzyVlvZARgCYSzzwrgD7uLKKlmmiTWFO8O
	hx72wS82Llae6+ptM1OZmI27i1CRvU/7K4CbwAmVCRC1Ute5lnDwB1U4
X-Gm-Gg: AYBFou2CLrn+JWAAcQhMRqUXhwVRT0i3iN8CZCY2GzOH/zVq1fgaHTwcq0WHy9Dshc6
	590fSDOd6hZDSbofOvUK1B0LZAHT7KAlOytG+GWfYPtliUmBv6tpfMIxH10N5tTSfEHrA8YY61t
	SHd66IkpPkpzLNkVVU937dBcBBoMLSuVC1lkqIn0sMlFToGvYxRNxTmqxkUA2q8gp5BLAK3zd09
	nK4/pnPKDREolOtVESfpF8HcsswDFpRBz52kbE0CY645sMa4M6WK33gaDe9TJHHquNJCKpbz0FA
	UphifgIrHdPIIpfTo2Mu71/yP1vFnlgyDivqRXzy1gYPpfmD88kHp2CLRXvs+AU08cnSa1yJemy
	JW8prfuqsGQRZmFGZ/VkdoToM2Pq8eg5nOjZlpVpW3gBnI18kmIkSg8/NHn0U8tlrULEOgdq9AD
	4mFOtfyzBVEcJUFPRu4IVEICRb2/pD+AmxRpD3YDWiWtc9oQncTWpr0GXFV0YB6aVtcmCVlS48E
	T7W2JiQ0N/SpgTaVK0kWjwv2hUKckzyUHmXUUYZpESr0nvjWkYsBfww9wgQGAFc1olOGXrUpDtT
	adfE1md2v5JUWuuU9WEt0sTtwExBrEC18jbnxqfJjlghMyK7R/gRPNXg1L11DI4pb0ciZ1uq8q5
	MDQ3Vp8yYLJ114KNNWzrn+QnE+66/bmzmbJHG4r8sdezPHWpueas=
X-Received: by 2002:a05:600c:34ca:b0:4a1:7c56:d4e2 with SMTP id 5b1f17b1804b1-4b6df212530mr76856485e9.16.1794036417341;
        Fri, 06 Nov 2026 23:26:57 -0800 (PST)
Received: from DESKTOP-IR7J1S9.localdomain ([129.45.78.107])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b7e3283b50sm41843175e9.10.2026.11.06.23.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 23:26:56 -0800 (PST)
From: Drif Abdelmalek Mohamed Said <drifabdelmalekmohamedsaid@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: syzbot+3e16980543e238b95bd1@syzkaller.appspotmail.com,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Drif Abdelmalek Mohamed Said <drifabdelmalekmohamedsaid@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] dm cache: fix divide error in too_many_discard_blocks
Date: Sat,  7 Nov 2026 08:26:48 +0100
Message-ID: <20261107072648.554-1-drifabdelmalekmohamedsaid@gmail.com>
X-Mailer: git-send-email 2.47.3
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

Switching the div operation to one that uses 64 bits divisor would cause regression,
so we just limit the value of cache->discard_block_size to U32_MAX.

Reported-by: syzbot+3e16980543e238b95bd1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3e16980543e238b95bd1
Fixes: 08b184514f65 (" dm cache: revert "prevent corruption caused by discard_block_size > cache_block_size" ")
Tested-by: syzbot+3e16980543e238b95bd1@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Drif Abdelmalek Mohamed Said <drifabdelmalekmohamedsaid@gmail.com>
---
 drivers/md/dm-cache-target.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 1a5072425c4a..b51ceca60afc 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2383,6 +2383,8 @@ static int create_cache_policy(struct cache *cache, struct cache_args *ca,
 static bool too_many_discard_blocks(sector_t discard_block_size,
 				    sector_t origin_size)
 {
+	if (discard_block_size > U32_MAX / 2)
+		return false;
 	(void) sector_div(origin_size, discard_block_size);
 
 	return origin_size > MAX_DISCARD_BLOCKS;
-- 
2.47.3

