Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC8827A462
	for <dm-devel@lists.linux.dev>; Sat, 27 Jun 2026 08:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782547521; cv=pass; b=fUzmjGnPEP/dgubLtH6JNpDhZ+PKEWTwp15aodnj3ME8cSocEQlgVsryH9MhAwITocsdU9kV1nCS3PvU8itQPZbmPUN3dRsrL+IOoqm30N90iycrK7uT4e94/KgcFgP7YPjkhkF1OxSQuWTolgqncYuLEeYoyP2tIVDexlDbcaY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782547521; c=relaxed/simple;
	bh=C3QHEcEXcV7cz64QdbFtuYWbfyvcCZc5FMBv+Gbc/L4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DtcvFYQeIbGszxs1NcenDyjsiYhFgT4Gqn1yBudDY9nXVypvZTz9YPD/6LN8x1lxT6yuxPEiJI8iU+NAxobOjnDJrobOseSw257PTyu0/2igCoiVklsQWsXTZUTky7il7bDJ/OkwApkWlbexDnSU/L/sZYWmKfum+J0OY+OOaWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VIzXWYbo; arc=pass smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VIzXWYbo"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7e9784666b3so1327858a34.1
        for <dm-devel@lists.linux.dev>; Sat, 27 Jun 2026 01:05:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782547519; cv=none;
        d=google.com; s=arc-20260327;
        b=TFO8MKJ/KFeOhyu3BZce3KnvPBWL1fCom71c5eZ2G4mWe8OHM6V+BP1Nl5ZBfLkW+c
         QNcxrD6ezlCa77pRIQQahBaoDQo6rNRVO8pEq4fe4+FcaxN+tCgOZbU+lngUAtM2gB5e
         MQvLSGHnpHB7/cV7ZavUJP+t8/Wyqk6iQ26oWOD10QEem6bxzu/tkGDjsuJrPCK4gykQ
         932AAJTS7brBUpKyBpk3u/sTUvyLCJb7k72im1xdEWUmCCE5puq9eOTFUNnLIjqLXGYR
         xvSa2rhyt+PAi2tpgJ7IxGQxdOz4mUCdv/Idqd0crMHoFro4bDzX7Y1m5ejkfj4aABfp
         eJmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rrBrQ9MxeCmgv9nkDIXP6j5n4tKZc080mOEMJAUM9f0=;
        fh=qa0fLCvmTCmcOubF/mC9NLc2+ACFZNvAUlZVRo5YxSM=;
        b=meQA2aRVrEWEmVuP8dW6xu+pavIlFOg2q9cI1Q7rOCTBVvZ8sIRBjHCpobS/HWFbN4
         vfn1aEoyvBLdBngcl+14X1GBzYAII+bqPRydDNcXVg6VWe/R5OC2LpYm/UZj2m8KLpWg
         afdmz78NWgt8lL/AGcrw8/2CeOMcr3mvPFJPE1NdJYJKGRFxCSPfAXpHmWaX42yy+y27
         iqn0cWuilDHMSl7BrlrD4YolBfmb95Pd6Wt9UT930jIW/R1bGD2SwWd3GfGhKTSBkvnQ
         cWkxwGabIMjzt3VUSD5lA+IXB3s0eMyc/erdOcOP8TxS6llMmGz5atWJ3hhR/ieGDfSC
         DPKw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782547519; x=1783152319; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rrBrQ9MxeCmgv9nkDIXP6j5n4tKZc080mOEMJAUM9f0=;
        b=VIzXWYbo4ePhZXk0N7n4XSKabxF8DrdhPN5cH9mSM+JCcNS3SFt+cOrOWAb/kR/KWC
         8Ck2858n7UcExLCzh/oyR9ul4g61Vuhv2X7oaw9bq7xa+VIrEWG667HGo0iMrbym0EG5
         LO2lzxpUg4Ka7JgJeICKwKabgCcVzlsnw9mIisndCWKmKg7A2eotvcElN/qb+PDA4ziT
         J2sZkPEaM2JvNhz86wHJ9NWwjdyqEjt3qSJS1t/wdtuwpW9ZnpnstcQiv8vm+YjO03/L
         YZX3OnUyPKTprbevWhU3ETacEsuDXGFzrVEohL+ZsyJ3hTD8oDSwQ9bN1hQNmoSMjF3v
         rIrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782547519; x=1783152319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rrBrQ9MxeCmgv9nkDIXP6j5n4tKZc080mOEMJAUM9f0=;
        b=O06OpLxaL97/Pf1PPDRpr0Sy5sU27hFxln5GKdsxMf/ZgTKDx1m9oLeNm1CtOEyUoG
         jg8JrRcUHBJfNZWli+hc3vFBOJ7IgCyyc96JUSBXWNEYnVWlKgUlA7iMSUzZCLo4oiMo
         d/xR3h9XAMKqQN2kPs9IxgAaSh+qq57ieV4qxycu4w5xhXNmdc4Gwq06t9cB5UPjvgIT
         9dfbUUPJbfTmbKyXTEkh/fl5lLkjjBFyflyjlEjhUS80weZDJJFcLe6Oicu1vEsv6OQZ
         z6RXw4L7zhMxiBHDYk9RccXUR/oT+arL5PZoNfOaRInqr9TSTMx2UYCatLwb3WNkUoS3
         T4cg==
X-Forwarded-Encrypted: i=1; AFNElJ9NRQNLachAhzWAM+9spDoK0zSQJ/jtg1rYw6eLR4CnEKSgdc9t2Ao74T1DJ8P7dj4i7MCRD8ELAQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw2JS/csk/E1uexhB4ZLIeiiAYyoF4ns5NILjW37/uOZCFHss7w
	ym6zcL7PFDYxEy3S0N0fcyMLN+6pgDyCZ2Ww9g3g1D3pzp3ubQkltlJ1Tm5RgYkSaSrO4oE0c3z
	tg9SEQptrMDakxMTvgfVRqYLVKsyTH84=
X-Gm-Gg: AfdE7cmequYZKKel+GGD+gcQx1Nz/nooMoLqhdCCJnfk9K2IqghhiTBM8Q1RQNR2LVg
	RsTUp9au867EU8sPJ4IlbhadTEckG7Ow7EQB9B9iKmfNInvNl30RkmvMRPEu7dM/xRu5kVrZJsh
	wGN3ve9pZBNZ2imKyFhJPwDTaeI4mzfq867CqKUFRoBpGXWzdTfLo/45CcfrBpf6WhTJ0R0/2yT
	H4px5UPAICXFwzJT2NbR6G2atzkx1nu7Yd01/h6lRWk+womcbCNSV2xJAispnmk9iB6Yk5A5wpP
	gpqgmMJDKEyw5u98tzgx+dFs7ZIV
X-Received: by 2002:a05:6808:2205:b0:48a:3f80:ee55 with SMTP id
 5614622812f47-4943dab6f63mr2842499b6e.26.1782547518899; Sat, 27 Jun 2026
 01:05:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260619-b4-disp-997773a1-v1-0-14df8aedb323@proton.me> <20260619-b4-disp-997773a1-v1-2-14df8aedb323@proton.me>
In-Reply-To: <20260619-b4-disp-997773a1-v1-2-14df8aedb323@proton.me>
From: Zheng Gu <cengku@gmail.com>
Date: Sat, 27 Jun 2026 16:05:08 +0800
X-Gm-Features: AVVi8CeHr8KtZefSjsP0m16zl9C8dNZS3Tu-L0OgZ838t_T4CDH0Jj7MsLhHbjA
Message-ID: <CADSj-Vo3oHat5JxDLZjeQv7xCroSGC06gkcKxQyH6Lq3EuaKnw@mail.gmail.com>
Subject: Re: [PATCH 2/3] dm-pcache: validate geometry fields from on-disk cache_info
To: hexlabsecurity@proton.me
Cc: Dongsheng Yang <dongsheng.yang@linux.dev>, linux-kernel@vger.kernel.org, 
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 19, 2026 at 7:44=E2=80=AFPM Bryam Vargas via B4 Relay
<devnull+hexlabsecurity.proton.me@kernel.org> wrote:
>
> From: Bryam Vargas <hexlabsecurity@proton.me>
>
> cache_segs_init() iterates cache_info->n_segs times indexing
> cache->segments[], which is sized to the cache device geometry, and
> get_seg_id() takes each segment id from the on-media cache_info and the
> per-segment next_seg link. Both come from cache device metadata that is
> only CRC-protected with a fixed public seed, so whoever supplies the
> cache device on a table load (CAP_SYS_ADMIN) controls them: an oversized
> n_segs or an out-of-range id drives an out-of-bounds access of
> cache->segments[] and a wild CACHE_DEV_SEGMENT() pointer into the device
> mapping -- an out-of-bounds read and write from on-disk data.
>
> Reject an n_segs that exceeds the device segment count and a segment id
> that is out of range before either is used. Valid metadata is unaffected.
>
> Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-ma=
pper")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
> ---
>  drivers/md/dm-pcache/cache.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
> index e6a2f4460f6e..08decbebd238 100644
> --- a/drivers/md/dm-pcache/cache.c
> +++ b/drivers/md/dm-pcache/cache.c
> @@ -250,6 +250,13 @@ static int get_seg_id(struct pcache_cache *cache,
>                 } else {
>                         *seg_id =3D cache->cache_info.seg_id;
>                 }
> +
> +               if (*seg_id >=3D cache_dev->seg_num) {
> +                       pcache_dev_err(pcache, "invalid segment id %u fro=
m cache device (seg_num %u)\n",
> +                                      *seg_id, cache_dev->seg_num);
> +                       ret =3D -EIO;
> +                       goto err;
> +               }
>         }
>         return 0;
>  err:
> @@ -265,6 +272,13 @@ static int cache_segs_init(struct pcache_cache *cach=
e)
>         int ret;
>         u32 i;
>
> +       if (cache_info->n_segs > cache->cache_dev->seg_num) {
> +               pcache_dev_err(CACHE_TO_PCACHE(cache),
> +                              "cache_info n_segs %u exceeds cache device=
 segments %u\n",
> +                              cache_info->n_segs, cache->cache_dev->seg_=
num);
> +               return -EIO;
> +       }
> +
>         for (i =3D 0; i < cache_info->n_segs; i++) {
>                 ret =3D get_seg_id(cache, prev_cache_seg, new_cache, &seg=
_id);
>                 if (ret)
>
> --
> 2.43.0
>
>

Reviewed-by:  Zheng Gu <cengku@gmail.com>
