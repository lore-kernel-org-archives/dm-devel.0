Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794448632;
	b=Brm/Ftr1jMiPx87cz55RacN7e5Vyke1W3iowMQkMa5R+7ij4DC4yMoiB3VcZ+VvIVVQj
	 T3vamA/9jEVdWVhZHhu8oSfBFiteJdD14UIP9w/Q1+56bG7dimXq82UIdTGy+4Z2ICoV7
	 OOsJlcGyt7H/l0yPnGjoDMLeT7SxwzqBVI1a8cuokJX6DgldfANtM06lMZT5s/ZFJqjtF
	 uDMUOPHvVEd0jhsO6UG3T/8n55jNS5DZQleGS0xzzkstZJbpBoVRYr0710/X1g+Cb7d5I
	 ca6PjJNizAMWNaJHrJQNaYhXWUI2PWgAowj6NBcpbUa6v3YDGRnNxHdKY6IdUi+oLLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794448632;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=OrtaQyuTJFFAhzdaHFSf3W8ZQbcXIMUnYPchIxz0jsw=;
	b=OKu+gSosLH2SRtR3rZB05KxZNph720YKmAdDYnT04Hf3XTpPETR/WpjqrWoXZW52ji+0
	 pFzz1AoeA1SyJ3PMrRCIP/0Bmy4sgboiQeX9yOphp4SI0f1+xKb3deJRCJxUPKa1PYxQ1
	 Tyx5YDgD1KFXlgY3gfauwfeTJ29FHhyQz0FnXiY7xIE6PepIdIyF3c1GQtFe5dtaV2Ggv
	 jN+FO4AeAGnfI7d576MfdMVAIkAvsuwCbyka9eIQlfRehmXnpd0Xrrsv1btT8lJW3PcCH
	 +pnoULkyIiRsFUnhXgTKSuXk5k//5zv+dzkZWullGXdbIqlHTiJgXKkx/LoPWu6uIWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=N4Bf360Y;
	arc=none smtp.remote-ip=74.125.82.47
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2733D606A321
	for <dm-devel@lists.linux.dev>; Thu, 12 Nov 2026 01:57:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2733D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=N4Bf360Y
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1b244fb7fffso4718335c88.1
        for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 17:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794448631; x=1795053431; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OrtaQyuTJFFAhzdaHFSf3W8ZQbcXIMUnYPchIxz0jsw=;
        b=N4Bf360Yp/SaQUft5tlW3ISUJkJSek0jECaUqabgctxGhYP1WwIjhevXLdo0UHuiet
         OmEHfhnaqXWhr9li3IOzxv6oQZMdE7PTO8jNQ2RLlQJ1a2b8O5x0P33fjfZwpZlAZ1zD
         eeWD+ohEfzMFjOq9ErEqKnzlTR6xSF9NJdY77rrQ2RdhyIP9RpnMncG60K7cw++JnNyM
         B8MWl9KxIFFCuia29zJHSu1NnuWvzqJcv1fNnJ9QLqAa9ZxHHYT+M8HtSiubPvKb4gQa
         y2Cz7MTZES4+6tcA/NxOv8Hjgk6pba5YHc4YnhJLi4uCvPzHIGE6Jdy5eqUYKXSOSEyB
         014w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794448631; x=1795053431;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OrtaQyuTJFFAhzdaHFSf3W8ZQbcXIMUnYPchIxz0jsw=;
        b=yITnLJGm3eJEFvYIfyjnPuFYsFvsluj6yAWEsjQtyDlpWsv4NR6yYdkjVo9AJqMt4H
         sa2mrttWjVQ1PTlbAaw76k2x/Lmv2rUGMqHkb4p4UjPFPvMll/k18ecA3r0v9MGerrzn
         QlcCi7JOWffZgNRu3R7UK1D88JsjApIMHXvx7KLgTZL0o8y5FyR7MSlWRjMOh3F/44h5
         kgzG3Qcy5/7MwYt9oqJ31Bh7QwW+WJNFh1p3a4JDv508pN0jP17mHqNPoqhDcN2qZxJN
         XZdpi4w8IcvBzt6CgGf+mpsOnVEH9S7lkG+ThlkqWaHZJybek0kOo2/RFBPG5WXVd+iz
         UhZQ==
X-Forwarded-Encrypted: i=1; AL+hErE7VlHH0idX1H7gHt50/4y0As7NkK4+joBPRSMTJaSPkuxWXbzklcly3XqAAXaN2ZyD8HQCB1ec/A==@lists.linux.dev
X-Gm-Message-State: APuU4Z9mjgPpM18DAKoewlBYzvHUZ5WnHXsjrzM85Ib7bIuBmh98MAdG
	0Qvbe/wc6halusVvV97s1v9J6pVEN01+H+/z9I2MgoUw/MMv6be+Btbp
X-Gm-Gg: AYBFou1R64zhhbf6N6FI3D56xWnFdTwQqEWDQe5Egd657hRqZIkfRhGsxmiR03tau5Z
	9EstJk2l04eeDfDcBKBVNNetSEiReYA+8gkEHxUAZ7FtYlihOAXHKdjfQ+Se92GXPKCRZZHw8Zd
	VZWPfofyEXpRxbEWrXTXMInJ7ytT19qgcVmYa/mOR7XWKKiHji2ixEJi3GzuzA9MvrxA3AgNCdL
	k/sZaCr+ElDPL4LO46mWIxtCpsMpiJaLZrjjeXsoPcyF2zr/wsJKGW8Y1ju1sp352CI0oERlRZu
	kqQgh5zscLN9z7cEcy7VN1gHn6SFE7CuVYwV3JG2PERejooilYFJXM+ldDVGMvQBSy9eWmitAlW
	BqRadTUMVaqnINgDAMNkkI2feYtSGTeScIdZkqZIBxTeQfjbPA9sCFTPYq88cjglGtx4qInMWU1
	5Q+89kDoZE0uyqGnee1hL1A5d68LlmQMgRVvvYcHFwaDHHilDQ8ELytf706BwcpEc5hwfcV2H78
	SMLsWpbh4sqPPERpRK8j0qUHk6AzSm+0ah4Ts6RugLKQm8k5o1U3Occ4rkrVi7N8jj8d3+tWGX9
	x+D5pvdx2QaDBBK1LmidWgzVPwxeLT8snUoM0Lf6I+YBV7IoqqQwS8Q842nyRFPZA55UfR+B12/
	HyBAwi2ipIhj4AL4C0nANDSghx1JUCvbQy95V8byXlaA=
X-Received: by 2002:a05:7022:c93:b0:176:a225:e364 with SMTP id a92af1059eb24-1b3c0342f80mr3366158c88.35.1794448630948;
        Wed, 11 Nov 2026 17:57:10 -0800 (PST)
Received: from lwq-System-Product-Name.. ([2602:feda:30:cafe:ec49:29ac:0:1866])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b20c55sm18841201c88.8.2026.11.11.17.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 17:57:10 -0800 (PST)
From: Yaohan Li <shunsheng1218@gmail.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com
Cc: mkp@kernel.org,
	dlemoal@kernel.org,
	axboe@kernel.dk,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] dm: avoid double-dropping the zone reset submission reference
Date: Thu, 12 Nov 2026 09:57:03 +0800
Message-Id: <20261112015703.2437757-1-shunsheng1218@gmail.com>
X-Mailer: git-send-email 2.34.1
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

On an error in __send_zone_reset_all(), the submission reference
held by the dm_io can be decremented there and again by the caller's
error path.  If another clone is still outstanding, the second drop
can release the dm_io before that clone completes.

Only drop the submission reference in __send_zone_reset_all() on
success.  On failure, leave the reference for the caller's existing
error handling to release once.

The error path was reproduced under KASAN with an injected GFP_NOIO
allocation failure while another zone-reset clone remained in
flight.  With the change, the same failure was reported normally,
without the observed use-after-free, and ordinary zone resets
continued to work.

Fixes: 81e7706345f06 ("dm: handle REQ_OP_ZONE_RESET_ALL")
Signed-off-by: Yaohan Li <shunsheng1218@gmail.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

---
Changes since v1:
- Dropped the nonstandard Assisted-by trailer.
- Added Damien Le Moal's Reviewed-by tag.
v1: https://lore.kernel.org/r/179378374219.68809.15920762511563622507@gmail.com/
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

