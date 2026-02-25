Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7B831690E
	for <dm-devel@lists.linux.dev>; Wed, 25 Feb 2026 21:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772055827; cv=pass; b=lD3+uwpmvcBvw1Gu7zdLdilSApihnVtCD3aBrx98XGZaREniZS3B9hIKRUMjMxYtEJTcHDNjoHcdXaFZOI97cIJe9rcNmaGFjVyIeWW+IXoaRmvly65cJSpH9hRIu3cPWoFAV5tEoJ1skbbP+wpwl5sWBU9TAZ3tdzPIYXAUNi0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772055827; c=relaxed/simple;
	bh=hoZBQczrzcuyVPOXD+tTAmFlTYabJ94zI9Irylb/EVw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RzYEoO44ES5QHptp3n1+RiPkPS7wibScBeo6QHC6iZkKMDbiW9+UADHQFCq7wuuBjtWMMMmaxuY9Aqi6H0y0aHN3HsbXVi3owCA2ulZSPncdyR5xA4Jia/PdMA7TK9pErWNwJ6anCUG/Tri49n12ehW6ZNeQRDEw0ApTlUDJWCY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AtKzt/Y7; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AtKzt/Y7"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-65f3a35ff13so3609a12.0
        for <dm-devel@lists.linux.dev>; Wed, 25 Feb 2026 13:43:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772055824; cv=none;
        d=google.com; s=arc-20240605;
        b=htXmM7U9S6jJ06ff/HcmWms1hizSJF+V4hmHZ/gI0uzE8x0V04ycuCa17C71OB68+S
         QZZYktN77FLG+dvaW9EkY/0vmbwlj1A9nisInpa7aF436zqQ8M3mRgZgxCsCbNCsOHCs
         B2dc3sbnDoWQN+C4CAK34mN+hsprH0RLcTeYQIA1prKhk/ata5MgEf8PBDQlQlOrs5ZS
         V78rspUtGCfzyVBE/uk5jo5/AgeGsURZiF+hfncfaDxZNeJSmasVbA8NgOq7RbCsbVg3
         HQgrBr57D9Aqh31VEmnypZ+i2Ihm7vRjzJjYBpkqPFeiIVe2Jg7iS0x2V3nfD22RbyxL
         0+Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vB9FeLIHdzkOeJQl8sZ1jnIIU5NTPuPRUQDCv7qOk1c=;
        fh=QO7vjZoPh5R6lKm1oKVaqKPvNFvW4LIfaMuTvWBJJOQ=;
        b=Bed2jZWDS1BurefnubImFYRHoMRzf681uIXtfoeZdDcFBZx2aPorcsmA1G4nLx9Y5v
         a3LkoLG2pFKH6YHxE23DNLY/TK+dT3l+rCDitv7GcGvjBhHqUJZezCb7/XOj1uCrbhe5
         wyIiwIM73Z62taFL0gIoPT/L1qYLZjlj0FfzIpeaBmli/zOt5TBzNYMY8ewTJ8UKYeYD
         224s/VXPagqVqs6ZpHnugGeSyqPH7LFqtketzBJ4DQ2CR+JP8Pf9M+8qa9jgCyFUUOLo
         Sa0aWUOP5ToEhQn7Oic5tSTE21LjdkwMzR3SNlo99DrGCAW7jVoUoegzPpC0Z6/j41pA
         yC6g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772055824; x=1772660624; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vB9FeLIHdzkOeJQl8sZ1jnIIU5NTPuPRUQDCv7qOk1c=;
        b=AtKzt/Y7nU4HsGWVP6OJJAgBGYELCOEDjsXTgVI/lm1NBj8lFvyv3pE8CA+s5Vs2ax
         lGCLSwSuvnhtJYaP8IzizoVLEfOnBgxAwg6x2z4d5H0jngP5M5anIgirm3WxKof1aDGw
         mocxTtzfV+uXhNvQ3D4P7nDEsj2tc2ruc1Oywa2OguqhS1IM2wUr4GyUtcUg4PD3Rf6l
         pftyw2ufF5nF6MnSWxtbkm2WezjbtB0C+WN8P/u3DqlBuJEnVuUBvgbIIJ1uAX1MFQkc
         zLweANxBGv+BwX8ta1l8W1BvAxShpxHFcT42YRmtHA9S77NimFXtRCwY3OhdFWF689M4
         sZ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772055824; x=1772660624;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vB9FeLIHdzkOeJQl8sZ1jnIIU5NTPuPRUQDCv7qOk1c=;
        b=jabOBDf6d0IJRSRX9UAzQoX/G+cSztOTcS5tFzALcWeOcnGIfMA9HelJ/UXez/Ij8k
         wNMiz/V0UH6u1VpAhJrJXsn61w35ZAMM4GP4NfxkOyVFXalgxcRWLfllTaMvoZ92kI1X
         Euc8EMljOOmm6lTIB4/956/gDPSQMg65G7P6Wrh6QlCggegNY1h0QMWVdgaLjg2HgnMA
         eI5KiwTfrFCt72qiEAFXv6+uKGSJsT4WwBOYGnw6nhgpaYc192bRs6GfN41jSyFNMLtc
         XNNIkoClbJyP9a2vYBLHjrb/YcXfSEf7E0rFqx28ZGvI3RaJI66ndPyzguTZaSy/+Yc4
         wQqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJynseaT8QwviF8WUQajn6zHZq+GuLd00qLOrtZ/OFCWh3anoHh6hrAy8qSa4ILmrbzd9XgfWdzA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzLGHQu7l/C757TAsHovuJkF3w2tjfhe37IJatFCqbxYwcfgriV
	Vf46LxSEtoqjQRdI/T7B1k3lFLEQaeaw/Tp+pZ8kQ1InSt79ueHZpN6i0kqUBwWWaSRB9s7Q/hN
	x73ucryenXrWu57ChWXTHwE6eC0Nt2yci4HvPKH4m
X-Gm-Gg: ATEYQzzKw7XjGnSbzoqwVJJiCgQqmtUO03xsdDeoKPYqPYCdG+I5Qw4MpLVKFiAet8a
	xRc3qGTpAovQ7CerQr1WLr4YVT2bc93o3/aVBKBEgS8UpyxHWKknaLv9E2/dv9oLfaqNnhS6UyN
	zo1en3Iif3lUtbXY+JSwI21i4v3QVV+NxQemiI3axisJUaF6PcRoBZ0ty2RJ+D2JWpN6Ed8SmHH
	2lgdjsM6y6pNWe3TWEBkMxfchyzEttXBnG2RswU4a6VWLk0TUgajQt1tSlySb/oIWsNv/NMhhM+
	6O/3h8rUk3j83n9NeaEI9NO44S5tjIKbTcppAw==
X-Received: by 2002:aa7:c7cf:0:b0:658:e7a:6fa7 with SMTP id
 4fb4d7f45d1cf-65fab61a7b0mr11377a12.4.1772055823405; Wed, 25 Feb 2026
 13:43:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250619111806.3546162-3-yi.zhang@huaweicloud.com>
 <20260225000531.3658802-1-robertpang@google.com> <7d2a3f65-4272-46c1-991a-356f0d2323cb@huaweicloud.com>
In-Reply-To: <7d2a3f65-4272-46c1-991a-356f0d2323cb@huaweicloud.com>
From: Robert Pang <robertpang@google.com>
Date: Wed, 25 Feb 2026 13:43:31 -0800
X-Gm-Features: AaiRm53fO14_kYBnlB-QimzynwfGzteAR7wRZiT1Sf0awQgFveGcUyR_Z7IWsCY
Message-ID: <CAJhEC05L7QEc9iY7gFZVK3SPYvFhtFyURss6xQgZ-qWwZZkFjA@mail.gmail.com>
Subject: Re: [PATCH v2 2/9] nvme: set max_hw_wzeroes_unmap_sectors if device
 supports DEAC bit
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Zhang Yi <yi.zhang@huawei.com>, bmarzins@redhat.com, brauner@kernel.org, 
	chaitanyak@nvidia.com, chengzhihao1@huawei.com, djwong@kernel.org, 
	dm-devel@lists.linux.dev, hch@lst.de, john.g.garry@oracle.com, 
	linux-block@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	linux-xfs@vger.kernel.org, martin.petersen@oracle.com, 
	shinichiro.kawasaki@wdc.com, tytso@mit.edu, yangerkun@huawei.com, 
	yukuai3@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Zhang Yi

Thank you for your quick response. Please see my comments below:

On Tue, Feb 24, 2026 at 6:32=E2=80=AFPM Zhang Yi <yi.zhang@huaweicloud.com>=
 wrote:
>
> Hi Robert!
>
> On 2/25/2026 8:05 AM, Robert Pang wrote:
> > Dear Zhang Yi,
> >
> > In reviewing your patch series implementing support for the
> > FALLOC_FL_WRITE_ZEROES flag, I noted the logic propagating
> > max_write_zeroes_sectors to max_hw_wzeroes_unmap_sectors in commit 545f=
b46e5bc6
> > "nvme: set max_hw_wzeroes_unmap_sectors if device supports DEAC bit" [1=
]. This
> > appears to be intended for devices that support the Write Zeroes comman=
d
> > alongside the DEAC bit to indicate unmap capability.
> >
> > Furthermore, within core.c, the NVME_QUIRK_DEALLOCATE_ZEROES quirk alre=
ady
> > identifies devices that deterministically return zeroes after a dealloc=
ate
> > command [2]. This quirk currently enables Write Zeroes support via disc=
ard in
> > existing implementations [3, 4].
> >
> > Given this, would it be appropriate to respect NVME_QUIRK_DEALLOCATE_ZE=
ROES also
> > to enable unmap Write Zeroes for these devices, following the prior com=
mit
> > 6e02318eaea5 "nvme: add support for the Write Zeroes command" [5]? I ha=
ve
> > included a proposed change to nvme_update_ns_info_block() below for you=
r
> > consideration.
> >
>
> Thank you for your point. Overall, this makes sense to me, but I have one
> question below.
>
> > Best regards
> > Robert Pang
> >
> > diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> > index f5ebcaa2f859..9c7e2cabfab3 100644
> > --- a/drivers/nvme/host/core.c
> > +++ b/drivers/nvme/host/core.c
> > @@ -2422,7 +2422,9 @@ static int nvme_update_ns_info_block(struct nvme_=
ns *ns,
> >          * require that, it must be a no-op if reads from deallocated d=
ata
> >          * do not return zeroes.
> >          */
> > -       if ((id->dlfeat & 0x7) =3D=3D 0x1 && (id->dlfeat & (1 << 3))) {
> > +       if ((id->dlfeat & 0x7) =3D=3D 0x1 && (id->dlfeat & (1 << 3)) ||
> > +           (ns->ctrl->quirks & NVME_QUIRK_DEALLOCATE_ZEROES) &&
> > +           (ns->ctrl->oncs & NVME_CTRL_ONCS_DSM)) {
>                                 ^^^^^^^^^^^^^^^^^^
> Why do you want to add a check for NVME_CTRL_ONCS_DSM? In nvme_config_dis=
card(),
> it appears that we prioritize ctrl->dmrsl, allowing discard to still be
> supported even on some non-standard devices where NVME_CTRL_ONCS_DSM is n=
ot set.
> In nvme_update_disk_info(), if the device only has NVME_QUIRK_DEALLOCATE_=
ZEROES,
> we still populate lim->max_write_zeroes_sectors (which might be non-zero =
on
> devices that support NVME_CTRL_ONCS_WRITE_ZEROES). Right? So I'm not sure=
 if we
> only need to check for NVME_QUIRK_DEALLOCATE_ZEROES here.
>
The check for NVME_CTRL_ONCS_DSM is to follow the same check in [3]. There,=
 the
check was added by 58a0c875ce02 "nvme: don't apply NVME_QUIRK_DEALLOCATE_ZE=
ROES
when DSM is not supported" [6]. The idea is to limit
NVME_QUIRK_DEALLOCATE_ZEROES
to those devices that support DSM.

> >                 ns->head->features |=3D NVME_NS_DEAC;
>
> I think we should not set NVME_NS_DEAC for the quirks case.
>
Make sense. In that case, will it be more appropriate to set
max_hw_wzeroes_unmap_sectors in nvme_update_disk_info() where
NVME_QUIRK_DEALLOCATE_ZEROES is checked? I.e.

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f5ebcaa2f859..3f5dd3f867e9 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2120,9 +2120,10 @@ static bool nvme_update_disk_info(struct
nvme_ns *ns, struct nvme_id_ns *id,
        lim->io_min =3D phys_bs;
        lim->io_opt =3D io_opt;
        if ((ns->ctrl->quirks & NVME_QUIRK_DEALLOCATE_ZEROES) &&
-           (ns->ctrl->oncs & NVME_CTRL_ONCS_DSM))
+           (ns->ctrl->oncs & NVME_CTRL_ONCS_DSM)) {
                lim->max_write_zeroes_sectors =3D UINT_MAX;
-       else
+               lim->max_hw_wzeroes_unmap_sectors =3D UINT_MAX;
+       } else
                lim->max_write_zeroes_sectors =3D ns->ctrl->max_zeroes_sect=
ors;
        return valid;
 }

Best regards
Robert

> Cheers,
> Yi.
>
> >                 lim.max_hw_wzeroes_unmap_sectors =3D lim.max_write_zero=
es_sectors;
> >         }
> >
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3D545fb46e5bc6
> > [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
tree/drivers/nvme/host/nvme.h#n72
> > [3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
tree/drivers/nvme/host/core.c#n938
> > [4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
tree/drivers/nvme/host/core.c#n2122
> > [5] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3D6e02318eaea5
[6] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D58a0c875ce02
