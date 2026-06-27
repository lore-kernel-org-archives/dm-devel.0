Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEC924BD03
	for <dm-devel@lists.linux.dev>; Sat, 27 Jun 2026 08:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782547401; cv=pass; b=U3dS9JNr7aNWBalkjZfyYx0kUHPiXYrZ+zf3LnM0VKL+Iax1J2d8StcblzeYsu6lwC8m3ZggRvSJuo0lkAVpDhfV9ttylxffSP90l5asf7y8QcpJBvrNIzA2vG5GtPkNcpQoWn+UDrkratX0H5e7WM4J5ROPXPO3GFojOKbycPE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782547401; c=relaxed/simple;
	bh=gp2T0qfNlzQYVnN2wDEwj9f/eW66Lkr/QJd322JAAX4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HpTfGUqz1A9XAtNaLodN3hEecXczzRVtdhPgeYsG3Ellk96SfM4/VkXUZyF9bcg32KEUzJyyH/T9IRRlugQlS/MOBT4erDLB4X2vHH3f4QVmAiSHzq1G9O6bjVEz0Y+AJiBE7Wf6X9GYAE12TeG7vgEyMabx77aio3lCvBoblX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xd/tj4yY; arc=pass smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xd/tj4yY"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-6a1133217easo733137eaf.2
        for <dm-devel@lists.linux.dev>; Sat, 27 Jun 2026 01:03:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782547399; cv=none;
        d=google.com; s=arc-20260327;
        b=B7Soww6zVIP2qUH8JW3++mWiv0UxfGBkVssUbtEQ1eh//5zKNkj8SzIsn6B4hujIBO
         fE8QjQBdQdn8Rm70wAndrk/i17S7DDfxvU6Ge9nwcUMnN8ZJi0hWLia1WKT/+ED0fE3F
         OMckI4d4SlVoFx4RPdEcWrh6fCpXicB289ZCaBPzyMqHyVegMEIZ2F2wsEPe7PfJXChz
         HC39ux71r/CMBzS/gq0y4N9xMn5lqL/l/WJ/6b8jfk9o+p5nIHPYQaSytq2lM6Xa/59x
         HEnDFKoTC94yRsdS49kE/l+Uy9vdkCIC3LrxKT4IKk2/dV0yaqqLsuIw6RTUW35c/Z7i
         06xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6LfeTEWU4w8J2gbM7i+Ay7t3Nq+OGlMaWoYKn5xBoNI=;
        fh=cfDC5rNbBF40m9oCSDPMUuGeSGV2CeS2rji77tul2GI=;
        b=siuFhhmHf41D+csl1I5nIjH4tn8TzUyQFWCCCxiPZVx1EeGMlBSeiYoeYanGw2caiW
         73viv4cr9PmRUk/cx037/xUxNZty0VBb3yM9q6NoPtuNk0OQiqU3yFuzW5iTQzKCTo8k
         vJA97TF2yJstfADQRcTOwDDs95sJuDhvUYBdA0wQQW+nHV011HTraXfQSpM9NmFoogG1
         YBt9Tc0qDyKqxzBq8/bGROPkKaPsTEiBdTQVL8NDW7LRwInLwKH+v2Ry2jAT/KoN/ipT
         ZztaM6ggYt9XDj5U9teo2ZlmI3ERDM1lv6GH72cpx812ibc6p8Ul3k47t+2j0cjCyBqN
         o3fQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782547399; x=1783152199; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6LfeTEWU4w8J2gbM7i+Ay7t3Nq+OGlMaWoYKn5xBoNI=;
        b=Xd/tj4yYX0LiVoguNQZANvxKSXYD+vcdBLxasS9Ztv3nsifUArwg7IOkuiqxxC1Lk+
         4REdNasIuLmTbRdpHp9oduRZaMGT5prcPvXP7o97J+KlfbZQ9rW+proXK3oLIXaEXQKO
         Lcc/LRBazGSAo+Cd1GWxt58pqkiZVTuqiQAfbfMSNytJdBH1bSJEOMMx22bAs0FQCcdC
         3zsmsXhDZLV9s5LP5A6g4feLKxX0bMs8G39zfmPJUveBIB/q0s3LAsupy7LiH/2EDB9Y
         0Smyq1nwUSE3VFnEHbyGkOjqFxyFWakF7fuhVBPYqSJ7ykhX6mhuCMSx3Xss62yrWSAm
         fXyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782547399; x=1783152199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6LfeTEWU4w8J2gbM7i+Ay7t3Nq+OGlMaWoYKn5xBoNI=;
        b=kfDBoLEoxXC3TvPNqRaBq+hzHn6PKwOro0m3zskkCb0T4vqtyK7zjBFKPMbk5QJU20
         XI4BLcYnChxRYubfMjqZfytpbzB8o9ssdPuzZrmUYmmKZNihBq3ooRIOAhFieR+Wu7tG
         Cp5ZQrvP2RU5qGs+p5qU8ZxCKDV1hK5/UkXP3yngjeTojrtTt566zksbcja061kF2ubb
         hz+FZZvY4JPBDgOY0meCQo44rr+8zmEN12D8p+QFsM5yrUKYocDAY+vXMzTqwNo8Gor2
         ac0FtFX1nHIykxIIW27BmAxbWRFjR+WtSYUXYak0BHiJzj+k5fR0mpxzohBpY07RcevG
         l2/A==
X-Forwarded-Encrypted: i=1; AFNElJ/KOnom0q5yHX5j6JE00I6402qTUx+ye8XtrinKScy3cCPGJxYeQvsba9iUEMe4i360eUCuYIrTYw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz5fQXDI2YQBtpaDX0NVJhnlle/ssj9XsT4ALJrNXl/+/M6+S00
	p9+dNcXolL+g3iaS9JoubcoCM/CexVWWuHiD/5mzb9ZCsuQvxVh8PteS/S8Al82ZWaW8p8rHSlb
	LC461FmqnHNtxWrwmUGc4gL3zQvYhbQCOiVLGzZ3TRdu1
X-Gm-Gg: AfdE7clIJZJZLHKvVCve1daDIaTanSLj6PW/0HpMJMhgdBUZNIgLVDbnsSD9vFAHA++
	LTV7eObB8W54l6TEURxW9eAJUE7iB2JOkYvQdxQHoxwfTIbN1WVIj5KYnAvCmuBRhYxzp9dDoAm
	4PK1TasdFYZlOiyYseJ5gkRGyKmOSLet9mk30Jf/nWQhAFelbn2TWw0uqYMpW6aHLdnjrnEuzeJ
	wJeQNM2WBOUJb2CLpvjNBigsntjF8kp0tjjinflDxN4rP4143acoETvz7uOkVn0vX/nQEdqxSyk
	usOuOsZTj42dFrkYKEeAtuc4aFMaWhttJRCHxrg=
X-Received: by 2002:a05:6820:709c:10b0:6a1:4040:97c1 with SMTP id
 006d021491bc7-6a140409862mr3218879eaf.56.1782547398700; Sat, 27 Jun 2026
 01:03:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260619-b4-disp-997773a1-v1-0-14df8aedb323@proton.me>
In-Reply-To: <20260619-b4-disp-997773a1-v1-0-14df8aedb323@proton.me>
From: Zheng Gu <cengku@gmail.com>
Date: Sat, 27 Jun 2026 16:03:07 +0800
X-Gm-Features: AVVi8CfnINRdnH-Ry8wAKm2edAOEm5VNSI8e1Z3iiNntYJ8-33NI597OB8lz7a4
Message-ID: <CADSj-VqmVQxrhDJH51inLTzUQK8K6mCC4Ce=dqscEO-iHUDA9A@mail.gmail.com>
Subject: Re: [PATCH 0/3] dm-pcache: validate on-disk fields before use
To: hexlabsecurity@proton.me
Cc: Dongsheng Yang <dongsheng.yang@linux.dev>, linux-kernel@vger.kernel.org, 
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Vargas,

Thanks for catching this issue.

Best regards,
Gu

On Fri, Jun 19, 2026 at 7:44=E2=80=AFPM Bryam Vargas via B4 Relay
<devnull+hexlabsecurity.proton.me@kernel.org> wrote:
>
> dm-pcache reads its layout from the cache device and mostly trusts it. Th=
e
> table load needs CAP_SYS_ADMIN, but the on-media metadata is only self-ch=
ecked
> with a CRC32C over a fixed, public seed, so anyone who can format or swap=
 the
> cache device forges the fields and recomputes the CRC. Several of them be=
come
> segment ids, array indices, loop counts and intra-segment extents with no=
 bound
> against the device geometry, which turns crafted metadata into kernel
> out-of-bounds accesses, both at table load and during normal cache I/O.
>
> Each patch adds the bound where the field is decoded:
>
>   1/3  segment ids that index cache->segments[] -- bound against cache->n=
_segs
>        (cache_pos_decode, cache_key_decode, and the last-kset paths in re=
play,
>        writeback and gc).
>   2/3  cache_info->n_segs and the segment-chain ids -- bound against the =
cache
>        device segment count.
>   3/3  the kset key_num, read by cache_kset_crc() and the replay loop bef=
ore the
>        CRC is even compared, and a key whose offset+length runs past its =
segment
>        -- the latter is an OOB read that otherwise reaches user space on =
a cache
>        read hit.
>
> I found these by walking the cache-device decode paths. Each class reprod=
uces in a
> faithful in-kernel model under KASAN: the bug arm faults (slab out-of-bou=
nds -- a
> read for the seg_id, geometry and key_num/extent cases, a write for the n=
_segs
> loop), the arm with the added bound is clean, and valid metadata is clean=
. The key
> offset/length case also reproduces under KMSAN, where the over-read retur=
ns
> uninitialized kernel memory. Reproducer available on request. Each check =
rejects
> bad metadata with -EIO and leaves valid metadata alone.
>
> checkpatch --strict is clean apart from "Alignment should match open
> parenthesis" on the multi-line pcache_dev_err() calls, which match the st=
yle
> already in the driver.
>
> ---
> Bryam Vargas (3):
>       dm-pcache: validate seg_id fields from persistent memory
>       dm-pcache: validate geometry fields from on-disk cache_info
>       dm-pcache: validate kset key_num and intra-segment bounds
>
>  drivers/md/dm-pcache/cache.c           | 17 +++++++++++++++++
>  drivers/md/dm-pcache/cache.h           | 35 ++++++++++++++++++++++++++++=
++++++
>  drivers/md/dm-pcache/cache_gc.c        | 24 +++++++++++++++++------
>  drivers/md/dm-pcache/cache_key.c       | 21 +++++++++++++++++++-
>  drivers/md/dm-pcache/cache_writeback.c | 22 ++++++++++++++-------
>  5 files changed, 105 insertions(+), 14 deletions(-)
> ---
> base-commit: 4549871118cf616eecdd2d939f78e3b9e1dddc48
> change-id: 20260619-b4-disp-997773a1-69ada10d3a3e
>
> Best regards,
> --
> bryamzxz <hexlabsecurity@proton.me>
>
>
