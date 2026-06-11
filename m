Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7F73D16E7
	for <dm-devel@lists.linux.dev>; Thu, 11 Jun 2026 11:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781175885; cv=pass; b=npWeGh/foksTzZmYRzhh0nuLZDE96MRVOPnSA/h4UnPBOttn0kHPO7Lm9iCirWbOiy/+8uJwnO4XI/ErszyCYrLXXC1mySxjZwVHxWbz2LR4l4Oi3uqP/bfMDSJH0mxSG3k1pQ+n5z7nMqk409w5F9ZI4ETOIT9LWjrsRvdW+g4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781175885; c=relaxed/simple;
	bh=Vfj6dOfWetWTAOE0T6H351G+XMeVkjxSsSQIjffT+ig=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PFdflKrk76fpf2yNH4VV1UjEfaY0FR7vqEmHdpqSZAYJI1dzJQ27ENFvb2N1fsS6i1fmTkgy7vHdzzZ+RH8/vbxm7Unce+G75DXyAUnNkoMeK6visrf3lWt+0LaWXv8I1KQ0OTsNlJ+nz/dmcnWhjXnCUs0EwGjk0CCJyyro3MQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aeLD1DRK; arc=pass smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aeLD1DRK"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-48611ccd5aeso4670770b6e.2
        for <dm-devel@lists.linux.dev>; Thu, 11 Jun 2026 04:04:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781175883; cv=none;
        d=google.com; s=arc-20240605;
        b=MYGidvxbl3BvGoiacm2l0QYmIQSVU3Bi/5cr7yYukswVk8eMNTa+WKqC5lq1ll4M2G
         iRCYTqmVAn3G+OLTDbkyINugTdMQ2ZPZe45j/ABYZXrZDlFRWneToWgF1lT/yBqZZkbo
         rk6RkWwRKdF0Ph6SzYGe14hGFXhNi1hCo/z9sNuhWrUkreIQ88VTlSjDBzZSI3hNQqsa
         +4ew7J1+hG19g298tVr39WuzjycdCAghMTkUmwaoM9d3K9SCSrkFBKqirkHEEkM6bY3Y
         M4Fi2mh8b8laMxZQt5ekq0IRD3QOgCRG3J0ESXUVRICOd+tjwA+iJK8eBae37lXzX8eX
         ndqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n1fPvnFNO0SD10SCE/y2CHB0jbSw/vhCOI4QUC2/7EM=;
        fh=i+Eu62Y78VBId4dQ5a5WcVOLuXNRRjHqa56XFXDd9rk=;
        b=aE48t1jMYFYvf7YLs/Z2hG7ar2qFs9i28ugCq3tbcSXtU2ZZCk5DYMMMsK3hSCQrpo
         FbG6DFnJuSZfjyCVDnqoNJG36+BCq8LGa20HUOaAhI/Q9SExGt6jA8YleuGTvGOLHMnr
         E/pnPti4GH9PN94BVG0ztC+GzQHsf13SV6gtm3jIId5v4/CTZsumi2hxe2QL9cX939+o
         sPyMmU/Rf07CZbFwTgd+0Z8MilBawM9bvZ8uWvPv8hVqFt+LCxIkIIxiQ93XE57YilGq
         I7HfmgUa/tRimwkZxU7PGoVmJvabjYfj2i6QCTqkeWMKeklycc47qmOuZf3lKy1RH0bA
         cAYg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781175883; x=1781780683; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n1fPvnFNO0SD10SCE/y2CHB0jbSw/vhCOI4QUC2/7EM=;
        b=aeLD1DRKtKBEwwEmiVH+VdqLBV3jzDXNJmaNy6qDFADtPPor8VAQ7hrTg/oC3eqnRm
         8F0S7bgOv841x5Oph2HH85GyufhfwLJbNeX6arNvQh4DGsGotd1PhRqtDCOixyVUrhY8
         qsZfbtVNILyx3zgoMSKmwkg0NknHdxjMlz4gmI52qsLCMf1XZTVnLXn7R0x6JHahQVT1
         bOtz/ecHcXpPUsXWgRdgs0dbpVJoNz60WAfNpTzQgHTr4aEpI6u57Iyti9jHsHmZlpa8
         eTUxqPbWCnsBcvK6weyZrnXt5K9j7WlH51wArn6Fm+zm8W6jIuX2Z+FSI4/cPP7NtIv0
         XjxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781175883; x=1781780683;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n1fPvnFNO0SD10SCE/y2CHB0jbSw/vhCOI4QUC2/7EM=;
        b=bLlNKDZDf8lL8hHOAbSiKu+n827r6OV9FUxjNytC5Ulg/Fmh9M+bEOTQFabeHGKgrZ
         c/74OGat48JchZRMyGMSFPaomrgy8EIRq0LSc38ou3l8ugWmvGeROxz2nwCOr9B5wU7Z
         TxvS8NrmRNykeoSSB0dUEU1/eNmERugQKyWyrfixQVWLxHiRRLvNIspgNvTbPLzxfs7r
         fIj9K8dQtcEt3iqnvaAMilb7fqK2sBpoastLgWVu464odty1ci5dgy0WWi41WElFuMqf
         gkSiXwRwprMhFc+Y/9mjfKGxBfEvrTsc7BeNRs/f+kuzOAWVnOR2a+3oDV4m16D1+5pq
         5K+w==
X-Forwarded-Encrypted: i=1; AFNElJ+O8QHnveOi5Qlj0uoheRq58TJcc96cJlaF/G3sFW3WVJ4F/flY1z+rlSLPJt5d+LmGwhbnurp29w==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzz8rG6LeaGPdY7V6UrVwDsYpt/ITR+0akif36rtU+NSoPEFqtj
	WCU1Oq/fEBpm7bHiib8vnjxaaeJ1Sb/cmn0eMWcMl48/82EJJMcy+XpLhyQEneLdfrwjODSaae+
	TSnv9iH6ptPWuj8HZJqzOFlaZ0XCmRhk=
X-Gm-Gg: Acq92OHvT50xfu9LJzORLeYEpUcnnMWGCF1bmE+2QFe/ZBdtEuMoxF/Ep4O78kPXLK4
	KGvaJqGZjIYxDaHbQp29fTFgByhdV91KpdxicIyRfDKOk90HDlGZpKZxYEhu0ZjGNXN7dVvy0Vy
	hzRtIzjx0HL6rvwkk/mFhnfRZ+FPQuvdAPRUaGL9z4byP47xrMJMjXg1WidkEXnhJW4owETFEVm
	gA5+2aQxrtJVBo5I2r0vJr2brfWibPyiAKooUPILflvTATeUhNlZNnzvR41zgUqMYs8Q3eHSqZO
	L4HDMNh3k373E+EhvCjuERiAydH4gsFiDd4=
X-Received: by 2002:a05:6808:1797:b0:485:d347:f1d1 with SMTP id
 5614622812f47-48719f4e0e3mr1823653b6e.11.1781175882703; Thu, 11 Jun 2026
 04:04:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260609003039.1236796.0386591ecc03.dm-pcache-missing-option-value-null-deref@trailofbits.com>
In-Reply-To: <20260609003039.1236796.0386591ecc03.dm-pcache-missing-option-value-null-deref@trailofbits.com>
From: Zheng Gu <cengku@gmail.com>
Date: Thu, 11 Jun 2026 19:04:29 +0800
X-Gm-Features: AVVi8CfJuTTmcwdf6MUBA_EiUzaL3ExFMfwbUcqWfGm8aKsh9YPsigTvvmCCsj4
Message-ID: <CADSj-VqwUG2y-9ku28h+E6=rXyHCQsnU5gyvxbFeUSCQVF142g@mail.gmail.com>
Subject: Re: [PATCH] dm-pcache: reject option groups without values
To: Samuel Moelius <sam.moelius@trailofbits.com>
Cc: Dongsheng Yang <dongsheng.yang@linux.dev>, 
	"open list:DEVICE-MAPPER PCACHE TARGET" <dm-devel@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

Thanks for catching this issue.

On Tue, Jun 9, 2026 at 8:31=E2=80=AFAM Samuel Moelius
<sam.moelius@trailofbits.com> wrote:
>
> The pcache target parses optional arguments as name/value pairs.  A
> table that advertises one optional argument and supplies only a
> recognized option name, for example "cache_mode", reaches
> parse_cache_opts() with argc =3D=3D 1.  The parser consumes the name,
> decrements argc to zero, then calls dm_shift_arg() again for the value.
> dm_shift_arg() returns NULL when no arguments remain, and the following
> strcmp() dereferences that NULL pointer.
>
> Reject odd optional argument counts before parsing the name/value pairs.
> This keeps valid "cache_mode writeback" and "data_crc true/false" tables
> unchanged while making malformed tables fail during target construction.
>
> Assisted-by: Codex:gpt-5.5-cyber-preview
> Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
> ---
>  drivers/md/dm-pcache/dm_pcache.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/md/dm-pcache/dm_pcache.c b/drivers/md/dm-pcache/dm_p=
cache.c
> index 81c795c0400e..ba5471885b16 100644
> --- a/drivers/md/dm-pcache/dm_pcache.c
> +++ b/drivers/md/dm-pcache/dm_pcache.c
> @@ -163,6 +163,11 @@ static int parse_cache_opts(struct dm_pcache *pcache=
, struct dm_arg_set *as,
>         if (ret)
>                 return -EINVAL;
>
> +       if (argc & 1) {
> +               *error =3D "Invalid number of cache option arguments";
> +               return -EINVAL;
> +       }
> +
The vulnerability regarding missing values for cache options is indeed
real and poses
a kernel panic risk due to potential NULL pointer dereference or
underflowing the loop counter.
However, resolving this using a rigid parity check (argc & 1) might
not be the most robust approach.
Instead of an aggressive top-level parity filter, it would be much
cleaner and more idiomatic to enforce
strict bounds validation and exact argument pairing inside the evaluation l=
oop.
>         while (argc) {
>                 arg =3D dm_shift_arg(as);
>                 argc--;
+                       if (!argc) {
+                               *error =3D "Missing value for cache_mode";
+                               return -EINVAL;
+                       }
This way, we properly keep the argument parsing framework flexible for
future non-paired extensions.
What do you think?

Best regards,
Gu
> --
> 2.43.0
>
