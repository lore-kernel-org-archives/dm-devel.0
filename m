Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793832125;
	b=1ihZp/YJBOUehOCF7d3X6Grw8JjmF7dApjsVSUHd1zm+bjxbZrmka6DgglSb/rIoe1WJ
	 /94gxHhCGllGKEDxDaXCNU3N68Di/uC+UVf5o+taoWxDK53wZ8IoOrjlusbDZsjoC00J6
	 jls+rQD6ey1pHzfBL7KgtyWln9S1Y9f8DDn3DGaFKPJz3AS3zn+Ufo6dGuMEQACX7Mfg6
	 GoaR3iOx4nFAJ8qBQH8EQigPAq2spvczTvX/neb2w3a3noTHuygPu3qq3xHJQLoFFmDMc
	 9tGWSZ6BpXwG1IxpiSsSP9c+3/LuGr3y5PBwOw4eY6CuUY0tho2ghsQG7vQAabn2k+w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793832125;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:From:X-Mailer:
	 In-Reply-To:References:MIME-Version:Date:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=KM2UfG1CDbTrad6C0v+30S5aRLCtGDlg6Z1BK4++Wa0=;
	b=b63teQJX8Su5UQ4fo83K94XTo25UMEh+K3my9zGleUUYxRhML6yK4xszc78qR9TWUId9
	 QTWPjetNusQpc8BWOBR0d8xYTczTpwQLQTkSsqhU8/NdejMMypONnMOn8UpF6nO6IbumI
	 BznhasEvQ5o2VqHI1TPk/bfRb4BXMjUtYfc19cWKCSQsvz9VH7vIEa6M5U9AnW8u5UBf+
	 ZJJSknyxX66XqNTTgG8JUjgr0AqeWED1XKCtBPZx7vtsxIXD+R6uq/PSviK/DMdCmFi0T
	 7XSb0Ua9zXRxwkJsEgXa3L4flNnMQYZUejg6Lw4VKcRaS36XN1N+GPCb7xGG0Td6oqw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Jqhybwgb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.51
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E911606D804
	for <dm-devel@lists.linux.dev>; Wed,  4 Nov 2026 22:42:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E911606D804
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Jqhybwgb
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-843a4ca671eso615579a34.2
        for <dm-devel@lists.linux.dev>; Wed, 04 Nov 2026 14:42:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793832124; cv=none;
        d=google.com; s=arc-20260327;
        b=qttFh1w1/b8S1WMq86R/Rm59/P0ojqmKan40AVm0rUaBlpSSXdLspahsYHZjroqraF
         ePDuezh0LwoSHlxftKKbjIrXYO065nMfbQum2fK8RR+PlpeJ5X+XT9cm/+uj0bGPAyrz
         l29MAS+zIkJ1RiMNtYs3mBCCSUPOKeFjLSpWVac9zPqycMHxXK0jdy/lZf5zrk6VS5uw
         bYH0Aq5kKm8CsyY57oLLpFV6Ot2Dm120/HbIbon5/jR0fjOaT1MP3JMz3pin9I6Ys7lf
         Z4+X4fKRQgx21h29apOBb5Q+93kFghZlDn+HV4swHf+02pvFYd0MLs4e1+F1ahM/dOX/
         Ih2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=KM2UfG1CDbTrad6C0v+30S5aRLCtGDlg6Z1BK4++Wa0=;
        fh=fwPv+l2e/pcKSoHN9gnoGDCWU0tzrJlQWN6TIzcHGjU=;
        b=LbUftyHmrDVPtp9hzoFsSEeDX6oCmmQWe0yvQiNZc8+n1lJdsiK/rd1ZONuBwzh4vl
         zpMhluZ8r3ScG0oJgE5wSH9nEVsaKLNgeuRZBcerusYDcN6OY1vpM0I/ss/18fCuTt7A
         f4dUSlR4iMw+rqvE4KrFt64XWRoiATZldXTG/McacgoR7JJm8eN+z58hxFNhb44jjGXh
         hqPshv/z75jvGwpvUBbBrGip2FEzC2fAy4ihyW0MyVD/dWrHGOgiYaLSuQ5uN/gBf7Yi
         95KWWSOdiNzpXVy+aDgQyAYi0G0i4mSUfI5L+GVmsHY1mbsP+NOVHwlmc9PE/DLw8SxU
         +RYg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793832124; x=1794436924; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KM2UfG1CDbTrad6C0v+30S5aRLCtGDlg6Z1BK4++Wa0=;
        b=JqhybwgbZomQhEmasDLsdyA3UtGNTvyAiHo5QJPe+E9sAVV9IABqUtKbpAKlDKUtnj
         FjDGusSe0VDKgipV1uB5Zuri07eRQDcaI3RpEyM5JjZ1XWtt2kxVqmpXki99zuI2x5oJ
         Up9eb8Zf84Krhz7MHQoZABVk+LmpQgManHyViahVS6yNn1PQO3qmm8nZj/pcDjrgg/I3
         09NUVNMps46wKd2ie+b1wzVXIFUlQqFP/psPsdmQQB8cLWZcEg/0FrBkzT4IDX3+cuFZ
         YFYe38Ht+MnFdUWGy71QYGDR/ghB7rawbzleJFl7C/0p5xQR6KlaTiKTp3f0mDuYtSME
         AvqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793832124; x=1794436924;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KM2UfG1CDbTrad6C0v+30S5aRLCtGDlg6Z1BK4++Wa0=;
        b=fOeylMhY7Vk1/sK24edwddoeHEBWIAJBPmfduxBbZhtg20Rgk2X+60G4yP3PIvnfC0
         3ElDcTU5lPw5E4ealb8N3dbBz52ZwWWgPBxhkHzN45lqurjk4pMDJC8ksV8Qq9yZoxZ9
         O6C4GdvDiyUSHzWsytcFj9kn0SBeQpdyt8rVEj4sU8DrBeZAkuAry4wGg51UYMqBQh2m
         PFqwocRuwtt22VMlOQ3c/DoXLRHF7MbxvK8ZdldEyFt1XOPhrrCyOqv0P870uOyZ1rk7
         hD2sjObyWAv/v27jZXZs5c6IS4zVps2FCC8BdMJo3CTclt1RwUkYRv7awVrV++V4785O
         RFVg==
X-Gm-Message-State: APuU4Z876gBtBt9Z5j8WfwDZif6/mqNT+goaz7WjdCAntBYyeRHwL1W3
	DestkK50nW9HIjxeoWzes0n5XPblrNmD0RPfdEzfeuiyyp5qyrPLq3SIpH15IPW/hDPUZBRJ2BT
	VB3LjtJ81FKYhXOzJJZLWeCM8SN1jctwbhP93Lu4=
X-Gm-Gg: AYBFou1SYH1p1dQmR8FR32eAwyUrcl4PnvtDlCQ/vacRF7itSJ04cQhOEX8xL9L7RVT
	knrOZc7r5gGaMbw1BCxDKrzFI7B2TzU5jn5dsfyIn5PycZhRZv+f0AUp8a9RvOXAquSRMo4OiCL
	jrOMbHCaRS8afVQ5W8aqo+V/Qn5dUDetzEoCw9G8T+EHdFrHqZX2s8xejp+R8B2LjhUczCWDRy9
	QvkKQa+9EauKZKkfv4kLi1JDC0Fj8D7hsyqFzVK5CJNnJxAcAXhqejiQJp/00xqUOgeJ4dl0Gau
	alV16rG87E7jicySNfS4MbmWICjAkXy5L8c3RMVykgxIi1lmS8J4kPpyzKAsW/wv9MnNMzNKfeK
	ALC5tEes9XdoqiBpJ1pYkc1dnnna+Pphidl8dXkKim8Z4Op/E3zZhSQsszdfZltNGixt2nDg=
X-Received: by 2002:a05:6808:1524:b0:4f5:4ce8:7e92 with SMTP id
 5614622812f47-5640ddc0cdcmr13133649b6e.48.1793832124318; Wed, 04 Nov 2026
 14:42:04 -0800 (PST)
Received: from 41474967715 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 4 Nov 2026 17:42:03 -0500
Received: from 41474967715 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 4 Nov 2026 17:42:03 -0500
From: Kirtikumar Anandrao Ramchandani <kirtiar15502@gmail.com>
X-Mailer: git-send-email 2.54.0.windows.1
In-Reply-To: <CADZg-m0e9UcuqQ7gNKn3jdyz3egU64uX15SMDbdrHXXqm2vvhA@mail.gmail.com>
References: <CADZg-m0e9UcuqQ7gNKn3jdyz3egU64uX15SMDbdrHXXqm2vvhA@mail.gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Date: Wed, 4 Nov 2026 17:42:03 -0500
X-Gm-Features: AclHuK8c3FllifJchvsAJtZHSyoSQbjaJVAnkMCzwFSk6lXoBgXJQiVA5jTzstA
Message-ID: <CADZg-m2gT0d7AHogkGwratOkMESe2qbLVnLgwn81rPpTnih=WA@mail.gmail.com>
Subject: [PATCH v2] dm cache: Validate the discard block size before narrowing it
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
	bmarzins@redhat.com
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, 
	syzbot+c8564fc0a96e3ecbe4d4@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

The discard block size doubles until the origin fits within the discard
bitset limit. too_many_discard_blocks() passes this sector_t size to
sector_div(), whose divisor is only 32 bits. Once the size exceeds that
range, the division uses a truncated divisor, which can become zero.

Use a 64-bit divisor when checking the block count. The selected size is
stored in a u32, so reject sizes that cannot be represented before the
assignment and before calculating the bitset size. This prevents a
truncated zero size from reaching dm_sector_div_up().

An earlier proposal checks whether the mapped length exceeds the origin
device. This fix also covers an origin device whose valid size requires a
discard block size beyond the field's range.

Reported-by: syzbot+c8564fc0a96e3ecbe4d4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c8564fc0a96e3ecbe4d4
Signed-off-by: Kirtikumar Anandrao Ramchandani <kirtiar15502@gmail.com>
---
Changes in v2:
- Resend as plain text after the previous mail client reformatted the diff.

 drivers/md/dm-cache-target.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 1a50724..7bacd88 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -17,6 +17,7 @@
 #include <linux/jiffies.h>
 #include <linux/init.h>
 #include <linux/kstrtox.h>
+#include <linux/math64.h>
 #include <linux/mempool.h>
 #include <linux/module.h>
 #include <linux/rwsem.h>
@@ -2383,9 +2384,7 @@ static int create_cache_policy(struct cache
*cache, struct cache_args *ca,
 static bool too_many_discard_blocks(sector_t discard_block_size,
 				    sector_t origin_size)
 {
-	(void) sector_div(origin_size, discard_block_size);
-
-	return origin_size > MAX_DISCARD_BLOCKS;
+	return div64_u64(origin_size, discard_block_size) > MAX_DISCARD_BLOCKS;
 }

 static sector_t calculate_discard_block_size(sector_t cache_block_size,
@@ -2422,6 +2421,7 @@ static int cache_create(struct cache_args *ca,
struct cache **result)
 	struct cache *cache;
 	struct dm_target *ti = ca->ti;
 	dm_block_t origin_blocks;
+	sector_t discard_block_size;
 	struct dm_cache_metadata *cmd;
 	bool may_format = ca->features.mode == CM_WRITE;

@@ -2521,9 +2521,15 @@ static int cache_create(struct cache_args *ca,
struct cache **result)
 	}
 	clear_bitset(cache->dirty_bitset, from_cblock(cache->cache_size));

-	cache->discard_block_size =
+	discard_block_size =
 		calculate_discard_block_size(cache->sectors_per_block,
 					     cache->origin_sectors);
+	if (discard_block_size > U32_MAX) {
+		*error = "Discard block size exceeds 32 bits";
+		r = -EOVERFLOW;
+		goto bad;
+	}
+	cache->discard_block_size = discard_block_size;
 	cache->discard_nr_blocks = to_dblock(dm_sector_div_up(cache->origin_sectors,
 							      cache->discard_block_size));
 	cache->discard_bitset = alloc_bitset(from_dblock(cache->discard_nr_blocks));

base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
