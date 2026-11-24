Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795523167;
	b=KWv/uFHFo8verhpOeLEHtXFp+R1WWB9589DXg3ekW7yvytcwrJW0V7WbrsSdYCqBUvZ/
	 QbtaLu76EVHHyetG81oIO66UHJ7JliUVhZke1xkvBQJ3m1i4SBIwi81G2Pk9+G/7dIvPN
	 GqcxBp0bK1HTJwa+R3MWbeTY2q2SdYAIW3MgRFgMj36R8wCl3Z03oo7TNs2+ftigpPqwd
	 nSLRjWO1tdqLrg/gej/tngezIz01Kcge3aeVMmZtRaBp1yltZQAkt3AXKoVHUmySkFLAt
	 SItRwUXTumTpgNmHeqQWmG/QefQe9DTaeMbvJeEoAcfiTDgfFosAkp77WoxfI7UA9bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795523167;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gt2Xoct00o0UZmPrmLiXkNLZXaxGE333WSwLDI5A/G4=;
	b=Yzj+5Gx65A8wjMI1dQBdSiWVjvzzh/ze47iTi7LZLxExWezB/kD76+BP+znIub8WSfKB
	 2BTw7I5txc/pJNWPYvCbpscz9lRl5NZmB8wJau/YETUzhjGUPqZ8btYlnoqAi6xBE3tVH
	 1VNVPVNdf9bAzQn8w+UAer7uLcwugs6lnKRpfeSebQAFw+WlAa5c6+IOW7U/ylR2fogUY
	 q6rC7UUsFJAKH+P3XrR2/IafATjb0hOZVS1qW8j7wt30arzE36/95BINNQkql4X+5+tEH
	 uZxdG7dWPmkaRgV2341o+IUNNvg9h05WTYvQRZUS3faGHNSCRrFJZyBDHCroiDBYJLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openvz.org;
	spf=pass smtp.mailfrom=openvz.org;
	dkim=pass header.d=openvz.org header.i=@openvz.org header.a=rsa-sha256 header.s=google header.b="iWeadg/K";
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3648606A332
	for <dm-devel@lists.linux.dev>; Tue, 24 Nov 2026 12:26:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3648606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=openvz.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openvz.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=openvz.org header.i=@openvz.org header.a=rsa-sha256 header.s=google header.b=iWeadg/K
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4bb64c99d2fso43014365e9.3
        for <dm-devel@lists.linux.dev>; Tue, 24 Nov 2026 04:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz.org; s=google; t=1795523165; x=1796127965; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gt2Xoct00o0UZmPrmLiXkNLZXaxGE333WSwLDI5A/G4=;
        b=iWeadg/Kh8seham6HZzvmRx/jM2jMjJhr6LMy7aD80GV+wAPQarBqe/xd2Rn78H4kO
         kzrSi9N6+JJDuNetSmp8iMHGvSKfELzPaLc3EirxPJjNDQTKuXKFXzF4gCbdHaj7j56z
         ap7vzTANo7odJRuO14JBRbc1iL+bKCRlWYQYXyYjVy4Urxv25j0qAEKyY/AEtkS67rXt
         i4oBP1Z7TYTXSL/sT6incB5YM9kmbNF7oeZvO7APWf47aJwtjZE8dEA2blXKqMFHZSIk
         sIYfQtkSvkF7ZmVERyTbOYUDP2nCsBSjpq6iVSiePGegGvP99iccbdWapfYmLuJU2+qV
         2OGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795523165; x=1796127965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gt2Xoct00o0UZmPrmLiXkNLZXaxGE333WSwLDI5A/G4=;
        b=LIZZ7WOY2q5EYQYhuoCFLKNKzfHAG9pIaQdqvgDGYPGzkQNCXuNN3hixI4pgtbKg2O
         VnwBeOM6G63XuMUqa9/fsrZ+50b+F3aSVcxSj5owkYrmJ8GUeCQBiozJ/0pQi+NAiNKD
         o4h05JdiQztrBvDuH90A8b7td1mnaRKp2r8Xa70JlHzzIfL8aDCU4+z0quLCPN2DbvVR
         PyotLUOtPGqiLkeXcSNHKsfa+QZrrJthSQNQXK5UJC3c4cVhCBvryr+FLKTrnzWK0V6T
         NSdZ3WNKtjDQ9WdfaepUffuNtnxSo+eROVsEeZhurJuWwxXl522C9x1D0Tuy9OcZmjI+
         NO4w==
X-Forwarded-Encrypted: i=1; AL+hErHgrJYOjLNq9LVMK7nipBiHOcACInihkXPIJbUmmeDm7PvjPAfhIbCkhzK3s7RJsryYcBbHMzLGeQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z+CF2lLr2UH08X64buTVR+TIxgI1c8CluvorePfnRvYchRt5Y5R
	V8y/NPS4cktXomccTtD/8ABERNLfsxPjreOtP5czlApyVLwqFU+mlboMr3z2lltCa4k=
X-Gm-Gg: AZFdTZe3TyBHNhRfwaUqCYmJLwVkDukqWkjkc+w7AcEi0wxwMN9bvxEC2kuP0/ux6M/
	j/ghLQHJQ9/iobrP40s4F5KpwyLjWe/eDvYP9v/Ii8GIJ1NBX4C7v2nVIDtrH0JVjFoa6GYmh4m
	5y7c9kJ2Ux1TB7kej5jltSvUM4LnXYlFWMa1czgtYqMGd1+WCc4ZYbpldUlA9hx1ERuublhfUu+
	pHTShbhfRqyZweGCL41RYib1ci9+PZFZkbBSfrtbi9UxhWM5Y8oiQhIv30oM47ZS4Oo9mFH6Z81
	Hh271Mzn+JNZBGJxT1BiDiQUWrqm1SiCCY8IxvtMT4CdV2mI2J4Xx94oRoiY+SQPf4Tw0WE2ojN
	7k2IuDdeJPVU/esJUgvTvGkAVnUUUT8sG2VQtDNgRCo/9TPweNh8YWbVesI47jI7HRkNuME6GN0
	EPjGW4/mJpNrvw4Mphqdv8oHc/KFUijJs39M+2+mfSfQdnFWOaRAq8lVErc9eLxCWXHkS9/rptM
	l/i1u4lOWoVGT7X9JXpD7p0RMRmEkOCafWFN4B8uQw1gvSRIWtfvXkfhnXu7lNOlWmencTL0Eh9
	Z7SWbYFzd65lBOPkcjyKt2zeQhg=
X-Received: by 2002:a05:600c:1c08:b0:4bb:7757:fe6d with SMTP id 5b1f17b1804b1-4bb88804c5fmr364836555e9.11.1795523165066;
        Tue, 24 Nov 2026 04:26:05 -0800 (PST)
Received: from artemis.sw.ru ([2a06:5b06:b600:300:8dcd:31dc:bf64:9564])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853ca452sm423615975e9.15.2026.11.24.04.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 04:26:04 -0800 (PST)
From: "Denis V. Lunev" <den@openvz.org>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com,
	thornber@redhat.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	den@openvz.org
Subject: [PATCH v2 1/3] dm persistent data: put back the reference a failed shadow dropped
Date: Tue, 24 Nov 2026 13:25:59 +0100
Message-ID: <20261124122601.436965-2-den@openvz.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261124122601.436965-1-den@openvz.org>
References: <20261124122601.436965-1-den@openvz.org>
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

From: Denis V. Lunev <den@openvz.org>

__shadow_block() drops the original block's reference before it reads
the block, and every error return after that leaves the caller pointing
at a block the space map has given away.

metadata_ll_commit() shows what that costs. It stores the new block in
ll->bitmap_root only when the shadow succeeds, so a failed read leaves
the space map's index root at a block whose count has already reached
zero. Every commit after that shadows the same block, fails to
decrement it, and fails:

  device-mapper: space map common: unable to decrement block
  device-mapper: era: metadata_commit: pre commit failed

The metadata never recovers. dm-era reports "era Error" and fails the
writes it was tracking, which takes the workload's filesystem
read-only. A read of a metadata block can fail for a transient reason,
and one failure is enough to get here.

Take the reference back where the shadow fails, rather than moving the
decrement past the copy. Dropping it later would hold the copy's write
lock across dm_sm_dec_block(), which starts by shadowing a bitmap block
of its own and so takes two more locks, and the targets size their
dm-bufio reserve for the peak without them. commit 490ae017f54e ("dm
thin metadata: THIN_MAX_CONCURRENT_LOCKS should be 6") set thin's
budget to exactly what rebalance3() reaches today.

Fixes: 3241b1d3e0aa ("dm: add persistent data library")
Cc: stable@vger.kernel.org
Signed-off-by: Denis V. Lunev <den@openvz.org>
---
 drivers/md/persistent-data/dm-transaction-manager.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/persistent-data/dm-transaction-manager.c b/drivers/md/persistent-data/dm-transaction-manager.c
index 7401add01d12..cf203ebb5110 100644
--- a/drivers/md/persistent-data/dm-transaction-manager.c
+++ b/drivers/md/persistent-data/dm-transaction-manager.c
@@ -303,7 +303,7 @@ static int __shadow_block(struct dm_transaction_manager *tm, dm_block_t orig,
 
 	r = dm_bm_read_lock(tm->bm, orig, v, &orig_block);
 	if (r < 0)
-		return r;
+		goto out_put_orig;
 
 	/*
 	 * It would be tempting to use dm_bm_unlock_move here, but some
@@ -315,13 +315,18 @@ static int __shadow_block(struct dm_transaction_manager *tm, dm_block_t orig,
 	r = dm_bm_write_lock_zero(tm->bm, new, v, result);
 	if (r) {
 		dm_bm_unlock(orig_block);
-		return r;
+		goto out_put_orig;
 	}
 
 	memcpy(dm_block_data(*result), dm_block_data(orig_block),
 	       dm_bm_block_size(tm->bm));
 
 	dm_bm_unlock(orig_block);
+	return 0;
+
+out_put_orig:
+	/* The caller goes on using orig when the shadow fails. */
+	dm_sm_inc_block(tm->sm, orig);
 	return r;
 }
 
-- 
2.55.0

