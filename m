Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793951854;
	b=a2TxTLpPYvHKLfX/0ppCKx4ghgr5QO5Wc2eMJ8bXkQG/YhI0z1PGcUwsoOI60Ru6fz7X
	 qASd/xDp+DxF863eXugdCrBcXk3UT+zrRHqpBNKc2dYbPIfx3moMlhQAy1y81QJSwuCbV
	 tmwcfet2eRxPI9pgLlzex/zxeYjJl03FavYyw4bseVo4+1coYUKJkLzx5Bi2DUud9nt9S
	 jFoB03oMVXADG7ss4Siq1QkDBND09RDSk4Td4YpssfupjejakEE54r5syinmMjDVge/QB
	 EGE9mnnqhP3yJeVDMXELDaMpNg/Y340ZC0+4egv01JdETIOxvBldIMQOQiZc6O5q/dA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793951854;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=DYpY5tnHLdMu8mF3D5OCo2Uuu5ItSVDB1Brn5+n2fPg=;
	b=1+K/9/bFX7PU65Ri5/ukcxFiABgDYJ56T8gZsMmtnS1omDPVSS49l0Q3TF5QK4TiU3MH
	 58tgZ1gM0BgXCp2pkWSwNqw01nCzgvjh2lqdqI91Iq8XD3w1zzsH/jnqSHJdb3te0LClF
	 +VyUY49BcOITojhOG2x9niAUpnbxCy3ozVkhxcm4+q75nAclEqcD3xMHyucF6Mh2K3xo8
	 dXe2oKRIelodpnTt2Cgy/xToSsjCpc5pIMSXK+biLUD8RMZQA+qVHnfCopgQzzvengW3X
	 8+pXk5dBluReYPVB6GY6JZyyHwFF+vePG6DFm8tVgiS0y+3CW97FDwMfxDct6ulJvmw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vSz843kZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.49
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9C8606A329
	for <dm-devel@lists.linux.dev>; Fri,  6 Nov 2026 07:57:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E9C8606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vSz843kZ
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-451a49abd8aso197018fac.3
        for <dm-devel@lists.linux.dev>; Thu, 05 Nov 2026 23:57:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793951852; cv=none;
        d=google.com; s=arc-20260327;
        b=oLjRLFF/ZggsKNdMMC83CMcx62g4gpsgBF/yhDUuvO7rDD7rRrUS8pZr0rNfj6RiwP
         tQwbiHSfVPrRQEJWwpkRikklInQ/2DUFphqdeABJazISHNGt80ehaj4rQkMq6Jvlizeb
         VuoU2itJN008YYNl2Gh42IVzcmFD4emYf8f16k5rehJcNK3zZ3cNGxihZ8ezd4lC1o5x
         XpLmHNTkJkTC9u1rGnfe6KJYHDhvHxDEavk8TlNXtKtOLfNxcO1W2tdBK4ar/C14H7cs
         Mu1vFn2iF40drDyVcVPvBSOz04uz068Htk/hlMhlAnQHWukw7o6NIO+5eDht2QymAxQR
         xJ5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=DYpY5tnHLdMu8mF3D5OCo2Uuu5ItSVDB1Brn5+n2fPg=;
        fh=QYTz+3h3yOuX8c4Vv41NdEi01bzgxAl18wmVjyCoP0U=;
        b=MgTJhTLv22ZB9l2vueBSsYH8JfnQ4zSHswi+QWi3TBVl9cc9yNMb8CYCSH9HA+9yrh
         FoJ0p2t426bceroPdd5LYT8P/0qyQC780c9YJgaSIcMbMt5V/JJv1uiQMoMJUX4gtGTf
         aqGrJofKZHn8ubxby8PCEuX7H6KXfRtoiTwrOtz2nocCT/ITtJYuDpk4WsOzSP40SuCg
         4Iv4+Xu+SNJBKIwvtbrbgYcyTL8uFg66xaPNPwYbht4OWmlM0JJ4AcVIXuKcUsqBBsye
         C7RsnlJQDq6DVwR6UhlStlbPlupS3pwaAbIt21rbKD4jz8ULHOBkvfE/mBh1Edd9qrvy
         /KQQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793951852; x=1794556652; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DYpY5tnHLdMu8mF3D5OCo2Uuu5ItSVDB1Brn5+n2fPg=;
        b=vSz843kZEVIxPBqKPhbd6M51T3YdENUKdLhh130C4enNEGuSWdIUGvUPNNcOOJYc8i
         4JTVEbNxdRzvmfNCBmDQUx3kr+swLSFx5WDSCRbvETBg4/3XHuWAeXgYi2Mypod6kIww
         /vwgdyzVUHSMDfASbQeELZr8RpZrp4OfW5ZO6iv4AwF2sLxXLvkE7/XuEAHi5ZFfIb/o
         9novfHSNOZxNCHXTotFc9P51RRom2vC3Q7sBtWkX7LlKMuMWhP/H4cbvZCOcGqYK1/Bi
         /GLrLmEkby/JbHt0+0QPdyRwTIQ7DfnhS0BVkGVEKpU3PQ3XdXBDn4107bViXpzvcPCI
         IkuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793951852; x=1794556652;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=DYpY5tnHLdMu8mF3D5OCo2Uuu5ItSVDB1Brn5+n2fPg=;
        b=F3pSyBvIpQtn0sq7W8Zxi0J81+/HsI/Q/I4ztzgKLP/LDsJ6MMJRrBYs86i187iei3
         9Q2oYN6UstWcO0KXkWpoPXLBX7sy6b3b1Y7l22cpB9BJJ9UDqkJYpbmYh9Yq+af1y9Yn
         mOtiS9XDb//VnWLfYhqB/l478FJY1oukxG/hE5sfkQIEScAri7wsgYGN680NPh1UXbeK
         4CKdj3dKmN4ceFJ27RsZRLv1m5DgxISmOW07xQZBdyscWYDPUx8nac/kuZsyFOrKynEn
         bx/U3BQiJkrtxipyiW+H9pWy3mxOv4KuMwmXoWuaemEGC1FWtpZJ+UHXptEZyitjsV7k
         8MRQ==
X-Gm-Message-State: APuU4Z/TVWNnyBhU0hBoW4Cgn4a879nnZSjRUni4d4tlYnW188pq8jbu
	zkWWCSV8Gcs8lA58tKAnW3nt3m5NYjuwcu5yBGl7icpz4Xs3vGQgaIycVbyMfhgogqhBhiu9gkc
	nkIDzBKlRdaM1yIu43PXnNV95NOTGa83675Gd42g=
X-Gm-Gg: AYBFou3QSfAz23YpW7k//ol0Gm/HnzMn1sn8qK2iYgRWkl4inddgz3vrOuVs4fzJQi2
	4uuwbI/5wrSVtD01cDO94077Id8f+ctnb1mES0D+eGqdwP+5A+gOkV7ZW03+TKreLdtC2UF6HlV
	HDrzjopduXWGrXUO8HuSLV5njrccZPlW7XDMxhHrzD/fx1rZUIBn/3a03VRUylEZ9DZ28/UXsh5
	BdVFWNUMTbpAbjnXAEF7o3KruwsZ8lD3f12LwJrQuwtNbI2XHAdHw+G64+wT4PHGwz4UHoVUXns
	6VKZM5WaaBL45Bg/xu+4EXRlPZ7p1d8j503fIBfBzrp2C0wJUiW/MkVR67QDdO1oWZIVlLy/Ray
	DRR4gg3T3OIooUjMipSxuKhIy4TuylpDz6ZbGnNqWQ4EWFZf0e/ZOV2+LKqxRTa9Hke972LaBuG
	MA1wPL+YmSJj2UbembVw==
X-Received: by 2002:a05:6870:65a7:b0:494:c04a:1a6a with SMTP id
 586e51a60fabf-4ad98dd0677mr1074288fac.55.1793951852375; Thu, 05 Nov 2026
 23:57:32 -0800 (PST)
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
From: Donut Oreo Computer I <donut.oreo.computer@gmail.com>
Date: Fri, 6 Nov 2026 09:57:35 +0200
X-Gm-Features: AclHuK_ZbI3jZ0vN-VbRk7HqBIHFw9XWUh-3AyP4y2zVhD1hRbXzpDrRyJS7WPw
Message-ID: <CALKjhPewyFB0=2tfyNVuDPosTAisDD2YcejTpX+0iiKRXdsGaw@mail.gmail.com>
Subject: [PATCH] dm btree: Remove redundant index condition
To: dm-devel@lists.linux.dev
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The index is unsigned, so checking whether i is non-negative is
unnecessary.

Signed-off-by: Donut Oreo Computer <donut.oreo.computer@gmail.com>
---
 drivers/md/persistent-data/dm-btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/persistent-data/dm-btree.c
b/drivers/md/persistent-data/dm-btree.c
index dd02eee4a23c..b7ac2f6d1d71 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -1108,7 +1108,7 @@ static int btree_insert_raw(struct shadow_spine
*s, dm_block_t root,
                 * see a way to do this automatically as part of the spine
                 * op.
                 */
-               if (shadow_has_parent(s) && i >= 0) { /* FIXME: second
clause unness. */
+               if (shadow_has_parent(s)) {
                        __le64 location =
cpu_to_le64(dm_block_location(shadow_current(s)));

                        __dm_bless_for_disk(&location);
--
2.56.0
