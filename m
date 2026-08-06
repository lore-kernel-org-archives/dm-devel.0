Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D8F472796
	for <dm-devel@lists.linux.dev>; Thu,  6 Aug 2026 14:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786027515; cv=none; b=YhvR9AYBSbZ6Pn9WwOSW5XDEuLXagGGgmpDdP5bs+qPtG5+HBE7laXugRhlHGN++EOp8bqeaIm4aWfY7HiU2OWQTk12ne49tBjVPOnaYdqxRvxclxnxyTj1hYLUgQemamMce/1YtQJrMk3jAFmahg9neWKm7a1aRthAwErV87LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786027515; c=relaxed/simple;
	bh=UTsXKbyYl7vB7xqyJxdwaXmvVfokG/4uN65KKuOb7uM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=lknOqiSgu/smlVYohHgIKXtlNTDNSd55nNRoWMTp2+E55xLbdhuS9RfLcV0RnMZef0uWZkCA5nZD4+kRs8PIH14OjtLHpQYsbpYyrOGfPn0uEVG1iv+fa4g7+ftjN3w5/iOenx4/ziF4ukGOyHVp7T+vGYMxC8EKb5pGT0jtMhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rMfqwPJG; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rMfqwPJG"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8f256eaedf8so22219296d6.2
        for <dm-devel@lists.linux.dev>; Thu, 06 Aug 2026 07:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786027512; x=1786632312; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UTsXKbyYl7vB7xqyJxdwaXmvVfokG/4uN65KKuOb7uM=;
        b=rMfqwPJGhPZrChmUsn5i5SzE8Urrcj1Usj4bW/VPQFPwGIpaolF2MuQem3M5vMXX46
         xGCXI0sszIHAjxEqHVhRXn257RZ2NFpjR38uQNTKKPkgBIDneuJ3XB107FEFmP8/94vi
         OZQn5VUfjmENpe3fDCjcI6nbmztX29XP/WLDCjceZ77uYp4QdlI9QtnlNIdLhXK+eQSb
         ImMga6Abm8cgviYjfDltM0aUdB+JZ+qiOshDCLL6Vz7fqj3bEEsWOyPPDVqvOUNAfws7
         rfLvY5M0Y1tHo1hsiPIvKOQZ6kDHIfI7k4Y+o9s+Pg+c0WuTP1WgSUtaYYxM74KF9ylS
         D1PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786027512; x=1786632312;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UTsXKbyYl7vB7xqyJxdwaXmvVfokG/4uN65KKuOb7uM=;
        b=fCf1kHPi6l8rCL8fnAsc/U/JJxUznrs3HSfTah8tpk4yaj2Z7yUdHq0EAmnZ/QbOKg
         wvHTZyI7/JZ4JKjrNTP8mILQks4XBWi/9i/jpswTT6xWxlJuZjGM3KwcveTN/Bjkofwy
         41qyQBDwV1cUdRAAQ/PK0auX9BaK4zrA4mBpcuCJqH5rUArsSdqWUev5/ltd6vFNyIFi
         kIIcFNatsRTzIaj6xVphWcQDQBfOu0+CwlmoqoqiOrE+Q6v2Tvl/pRomCe4mE1f1D0Fo
         8Kmj25NYP4VYRjwOwVTapN7BY3sjga1HjIIbvnqERufXhd6iyhP80C7ALekWBOVutCh4
         zvGg==
X-Forwarded-Encrypted: i=1; AHgh+Rq8yeTwqL3BQa7VHeBIslkpHObJ6AYJRt+FQfqch8bogH6gTQQn/wXJh++DhcV0drdjqHTr0MY59g==@lists.linux.dev
X-Gm-Message-State: AOJu0YyPOs1+mdmNxTDHjRhwjQm+xAYsW4QJDGqOcqLfzeVvquTjoZwD
	zRW2HBDQjlplfISwapMMP+eXAm5wCNt1FGjegaDCK3IneriH/rzIiQPu
X-Gm-Gg: AR+sD10Ro66w+tJRabQjZNjyIZB2g4JOoNDYa7WauiSxCg1ffYN7vNCW5O2h4P4O9Vl
	PXv4qSMOufGM71PkKjS6+9ofZU6NkD5BKCGGgujvOUOSE5RvcTQ4HHsw3SZXUWh7ImoT/roUbba
	4Dw2jeiNClxi1qitAkKe/War3152eywfmzpW7s5e8ageVgAWRjsJRI17HULIvy/rR/76cxH7wCx
	ZxVaz8Kg+O1FOW4nkPmZM2Xas7SSADQHhHHeBZJfqpKSNXyNiyWn7Vey+WjupCE+0vOL2tPPjKv
	9jALgoRdbc7cE6oXxAkIQiQd4BQOr8PyoWU94F3FaabmSs0zdH3JQFZVjaL2yYCYkMtrLg9YSYg
	yDbqr7wacZbgEu2Ks23oK2PNLfEWgZfnQU5Qk8lQkUVHSv4Xl5cGq/VfdM4wJPxhZLZ5Yt532IY
	KyzYe+jgSUmrz27IfNs2wfdPOJBO1Ctsuc0/1qWaHJFJWi8F6bS8Lrt2r9acqO+LYlwguHqQ2ib
	MyFJhhvrZ9RlQ+90nydjqhLvKLoVXCO
X-Received: by 2002:a05:6214:501d:b0:8f4:821d:95f7 with SMTP id 6a1803df08f44-9088124ccb0mr159085776d6.18.1786027512206;
        Thu, 06 Aug 2026 07:45:12 -0700 (PDT)
Received: from smtpclient.apple ([2600:1016:b105:b4ee:59bb:6356:a055:a7a4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908800cd7cdsm55156756d6.44.2026.08.06.07.45.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Aug 2026 07:45:11 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] dm-pcache: fix use-after-free during cache replay
From: Shuangpeng <shuangpeng.kernel@gmail.com>
In-Reply-To: <d96c9146-430f-c89e-949b-b8c4189b0b17@redhat.com>
Date: Thu, 6 Aug 2026 10:44:39 -0400
Cc: Dongsheng Yang <dongsheng.yang@linux.dev>,
 Jianyun Gao <jianyungao89@gmail.com>,
 Zheng Gu <cengku@gmail.com>,
 dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C0FD6B6C-8324-4465-98E4-36EC02299618@gmail.com>
References: <20260805171637.3557122-1-shuangpeng.kernel@gmail.com>
 <d96c9146-430f-c89e-949b-b8c4189b0b17@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)



> On Aug 6, 2026, at 07:48, Mikulas Patocka <mpatocka@redhat.com> wrote:
>=20
> Hi
>=20
> This patch doesn't apply to the current device mapper working tree =
because=20
> another patch was already committed there: c2e894eac398 ("dm-pcache: =
fix=20
> use-after-free and invalid seg operations in kset_replay()").
>=20
> Please, download the current device mapper repository from=20
> =
git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
>=20
> Checkout the branch for-next.
>=20
> Verify that the bug is still present there.

Thanks for pointing this out. Please ignore this patch.
Sorry for the noise.

Shuangpeng

>=20
> If yes, send the patch against the "for-next" branch.
>=20
> Mikulas
>=20
>=20
>=20
> On Wed, 5 Aug 2026, Shuangpeng Bai wrote:
>=20
>> kset_replay() drops the last reference to a stale cache key before
>> using key->cache_pos to acquire a reference to its cache segment. =
This
>> can dereference the freed key.
>>=20
>> Segment references account for key records that have not yet been
>> consumed by key-log garbage collection. A reference is acquired for
>> every successfully recorded key, and the GC path drops one for every
>> record, including records whose segment generation has become stale.
>> Replay therefore has to restore the segment reference before deciding
>> whether the decoded key should be inserted into the request-key tree.
>>=20
>> Move cache_seg_get() before the generation check. This preserves the
>> get/put accounting for stale records while ensuring that the key is =
not
>> accessed after cache_key_put().
>>=20
>> Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in =
device-mapper")
>>=20
>> Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
>> ---
>> drivers/md/dm-pcache/cache_key.c | 3 +--
>> 1 file changed, 1 insertion(+), 2 deletions(-)
>>=20
>> diff --git a/drivers/md/dm-pcache/cache_key.c =
b/drivers/md/dm-pcache/cache_key.c
>> index e068e878231b..b37d899f2d3c 100644
>> --- a/drivers/md/dm-pcache/cache_key.c
>> +++ b/drivers/md/dm-pcache/cache_key.c
>> @@ -729,6 +729,7 @@ static int kset_replay(struct pcache_cache =
*cache, struct pcache_cache_kset_onme
>> }
>>=20
>> __set_bit(key->cache_pos.cache_seg->cache_seg_id, cache->seg_map);
>> + cache_seg_get(key->cache_pos.cache_seg);
>>=20
>> /* Check if the segment generation is valid for insertion. */
>> if (key->seg_gen < key->cache_pos.cache_seg->gen) {
>> @@ -739,8 +740,6 @@ static int kset_replay(struct pcache_cache =
*cache, struct pcache_cache_kset_onme
>> cache_key_insert(&cache->req_key_tree, key, true);
>> spin_unlock(&cache_subtree->tree_lock);
>> }
>> -
>> - cache_seg_get(key->cache_pos.cache_seg);
>> }
>>=20
>> return 0;
>> --=20
>> 2.43.0
>>=20
>=20

