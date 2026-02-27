Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E709257821
	for <dm-devel@lists.linux.dev>; Fri, 27 Feb 2026 01:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772156094; cv=pass; b=Cd0o1tNXXwldB2vWOFo3Q2UxJ/ITUjEa106UQp+RfGpTyFOumirOM+VuZ1WCxh0RoUZeBy1yFLCBRfZGLLWJtJ49uhHsLE3hlKfx68vVVw/jwGpqPNB2G4/90OcZxV1dpf4t1Vo9DQkokjhG2OGAFDwgsb4UhdZtSvLV/rzStSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772156094; c=relaxed/simple;
	bh=z+/M+lo5ksz1TRd449byu/D3ls0drNyd6IdGp40lVms=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pnNMV0Cjf9+qg5Auzaz6zx9ja7xGWFDKRhneV0y25E3vlfIionNcXONmQF+ylQJKjVqnO0IN3XN+a5YmuxPrqH7k1YKGhIdTi3zeY8d+AH0/Jp7tIL2AddipN2iIyclulBdkKdbI2CtYAoA/cxWtdCDu0zXM9SOxMqwYkgIFZik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0D+yuUvc; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0D+yuUvc"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-65fe2d2b744so4658a12.1
        for <dm-devel@lists.linux.dev>; Thu, 26 Feb 2026 17:34:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772156091; cv=none;
        d=google.com; s=arc-20240605;
        b=Bm2fNMZw8ISJqOOTh7GZeUo724ZwMMyJPpl1Pi8eFyypkvRVzQqxazN5sVsWt7VuAN
         jfXbyaAZ34H+WwC+dKSzBLTa2C0psQy8RqrfkyI3CmqMA1bnNNMntzBRtj7DV6GRdIZk
         dyBEnmytuSBQ1Ah5wlZktWNsUkN50S24n7JI3qMoAUAfeIGvDIPp6fgrLlT4ixjvzaDJ
         x+ii0KTYl+sk0vQfKq6L4hvx0yTKzW7Wq/FpT6mBWzm7nOSQuLp3cDg0sCrpxnWfSfe9
         WepEfwpJecfFBuC+88YNN/vALNRY4tddzMuejOJmMjyhFjzcAY0rQTjLkaBAy4kt5b2D
         3I5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1Xe9R0FTdq/8KgfEwhSHbjVGMoqD5nAmJr57+aBN6PM=;
        fh=bNqvP7mUYUsAONgCmowgJ1dOltYPn06YOXk0/lq0WtU=;
        b=c8cy1+KKe2yhaY8wtglNxnyJayNySiYLpkY4HR0f/UkULR9+aRoiwnQDgN27duXbvR
         Uowcp6aq5ShBDSqxgIojY16aTH7xonCdMXt27dxRT7YvtBlx3ExuiMxxhyf9jYHjpHFv
         2GWAcz2hgU7NnLdopW8dJxY/QFkonbNydmgYNzTSSavnU9QaXjJ3ZY+df/hbwPWVWR59
         SHWYBJALFzcLOBfJ5PsDcoys2YM9gsV8ceq7MIPUqS5HpB2+k2eY9K73Y59XlxPWtQLD
         jZsmlLW6GJxtt6qNJCJzW0/zpihS22Mab9z25SFn0fl38HPbVoTjsRGWzCE9yujcuh4a
         YeBg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772156091; x=1772760891; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Xe9R0FTdq/8KgfEwhSHbjVGMoqD5nAmJr57+aBN6PM=;
        b=0D+yuUvcP7jadSViVjrShP/nWoagJB195b+ghE+vxBh1p86jc6wAewlfgNLou09QG9
         S7DttOXXERaj0QGc3sTVjSQHvJpTwnHxrdooZrUT2XJEd/1vwFHZYIU1FhKlADskMnIw
         KgEPmIViQ7Js4DcS47A/nJlC2S/NXd1ulSplclJpG/WHOUK11RyrsK4WR7lIQbr37sXn
         VneM9Ti7i2h6S0Eg0SsF/X9M9WpvYaVnrDcB9DEH80xNu4cyZS+DfKWEcu/iLgDn94zB
         w4DY2VHmml4t8cw+Mc7sUGvDr2NvB+hgTy9jQ8Ok3JTpF13QKYqxkGvWXB1Yz6R0PprN
         1qgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772156091; x=1772760891;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1Xe9R0FTdq/8KgfEwhSHbjVGMoqD5nAmJr57+aBN6PM=;
        b=F/iYmBUh4yw/z6U63qX81W1C6zOP7m1SpwRx/tN9WfLgfblmnSxt08jUBFGTEzmmIp
         qbPpQKw+IV/2Tj3nC26RELsO55Kxb59WBpsvljxmSdyvgdZFg5MgBmKq9Wm0r1GiRRz9
         u4KjMsFDwdg3Xx2Oz+oj80fnQH4NPM/JcH1+ID+rUL+jfx5oJo8DhO01AvlVOCehZkfp
         rWI8+4fDCv+JuxOusiQbDu8Ri7ODaLKBD+2GsTfRuO8eqxdTJbBRPZvOejfB8+K/wDPE
         z5UxdmzATUtNg0cKdO2UMgWBFYh3AhOY9xlalbLi5pJadAoxEqKBUuswnzIHf0e1QHJx
         w0Vw==
X-Forwarded-Encrypted: i=1; AJvYcCWjFtQUvoKoZs68SugK6cVYY0i+QUnrDRpBTwL615U0Lw/kcZyrp0fgx1AHdm7VmPNRsRZvfLGJdQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8finZwkE2Oi5Zqees/1IN22DORCTj3+cpJzSRUhxVbI6nW2OS
	CPX8Yd1Y81nbgXm5vDsdcXnQMwgD58l9VQdZnZ53El4t8dzMpu1l4/ghOLRUg1GE4uemBe5YGC2
	80tDhIzrkcr2u28q4bQztT7USZYHOXu0HB5RCMKGT
X-Gm-Gg: ATEYQzzYooPJTsdwDrguBUZbP4SAreiW9SWPb1Eq57IhnA5bz99vTtYhzN8lCRSSp80
	hrWN3z+PPIpVj0aZDgyuTbP/hlmahK42WLn1OaeUv8BK9plR1HGaMGzIA7BbmIk6lQlLsGjMHVe
	bdw1ws51/78JYmTFiYf4/kbtyjii7QcMpmKLkFukdefae3gHsmDkn3u9/C9HE+VTEUbl64m3IVf
	s1bJ+mUL6VhKzr2VkfZwDh6gIumTYoijZTlMVJA/wySPHKjgtSLAiYURjUz0RtaRWNJNKCr5h7c
	11B/eC5/1nDqJNL1d1zlPt71WU899Cozw+kH0w==
X-Received: by 2002:a05:6402:4619:10b0:65f:76c8:b92f with SMTP id
 4fb4d7f45d1cf-65fab2c4155mr103050a12.0.1772156090158; Thu, 26 Feb 2026
 17:34:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250619111806.3546162-3-yi.zhang@huaweicloud.com>
 <20260225000531.3658802-1-robertpang@google.com> <7d2a3f65-4272-46c1-991a-356f0d2323cb@huaweicloud.com>
 <CAJhEC05L7QEc9iY7gFZVK3SPYvFhtFyURss6xQgZ-qWwZZkFjA@mail.gmail.com> <8a45c55f-8abe-4cdf-be70-208550edf320@huaweicloud.com>
In-Reply-To: <8a45c55f-8abe-4cdf-be70-208550edf320@huaweicloud.com>
From: Robert Pang <robertpang@google.com>
Date: Thu, 26 Feb 2026 17:34:38 -0800
X-Gm-Features: AaiRm52oy9vcXDycCt3HX0a8oowZo0wXmgzHk3BLllBwVjMbefXMCEMxh3i5upc
Message-ID: <CAJhEC04Vpo96SKN7iRjV0fUKXEj3oQ698RdoVAdWjRjVLpgvGw@mail.gmail.com>
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

On Thu, Feb 26, 2026 at 3:09=E2=80=AFAM Zhang Yi <yi.zhang@huaweicloud.com>=
 wrote:
>
> On 2/26/2026 5:43 AM, Robert Pang wrote:
> > Dear Zhang Yi
> >
> > Thank you for your quick response. Please see my comments below:
> >
> > On Tue, Feb 24, 2026 at 6:32=E2=80=AFPM Zhang Yi <yi.zhang@huaweicloud.=
com> wrote:
> >>
> >> Hi Robert!
> >>
> >> On 2/25/2026 8:05 AM, Robert Pang wrote:
> >>> Dear Zhang Yi,
> >>>
> >>> In reviewing your patch series implementing support for the
> >>> FALLOC_FL_WRITE_ZEROES flag, I noted the logic propagating
> >>> max_write_zeroes_sectors to max_hw_wzeroes_unmap_sectors in commit 54=
5fb46e5bc6
> >>> "nvme: set max_hw_wzeroes_unmap_sectors if device supports DEAC bit" =
[1]. This
> >>> appears to be intended for devices that support the Write Zeroes comm=
and
> >>> alongside the DEAC bit to indicate unmap capability.
> >>>
> >>> Furthermore, within core.c, the NVME_QUIRK_DEALLOCATE_ZEROES quirk al=
ready
> >>> identifies devices that deterministically return zeroes after a deall=
ocate
> >>> command [2]. This quirk currently enables Write Zeroes support via di=
scard in
> >>> existing implementations [3, 4].
> >>>
> >>> Given this, would it be appropriate to respect NVME_QUIRK_DEALLOCATE_=
ZEROES also
> >>> to enable unmap Write Zeroes for these devices, following the prior c=
ommit
> >>> 6e02318eaea5 "nvme: add support for the Write Zeroes command" [5]? I =
have
> >>> included a proposed change to nvme_update_ns_info_block() below for y=
our
> >>> consideration.
> >>>
> >>
> >> Thank you for your point. Overall, this makes sense to me, but I have =
one
> >> question below.
> >>
> >>> Best regards
> >>> Robert Pang
> >>>
> >>> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> >>> index f5ebcaa2f859..9c7e2cabfab3 100644
> >>> --- a/drivers/nvme/host/core.c
> >>> +++ b/drivers/nvme/host/core.c
> >>> @@ -2422,7 +2422,9 @@ static int nvme_update_ns_info_block(struct nvm=
e_ns *ns,
> >>>          * require that, it must be a no-op if reads from deallocated=
 data
> >>>          * do not return zeroes.
> >>>          */
> >>> -       if ((id->dlfeat & 0x7) =3D=3D 0x1 && (id->dlfeat & (1 << 3)))=
 {
> >>> +       if ((id->dlfeat & 0x7) =3D=3D 0x1 && (id->dlfeat & (1 << 3)) =
||
> >>> +           (ns->ctrl->quirks & NVME_QUIRK_DEALLOCATE_ZEROES) &&
> >>> +           (ns->ctrl->oncs & NVME_CTRL_ONCS_DSM)) {
> >>                                 ^^^^^^^^^^^^^^^^^^
> >> Why do you want to add a check for NVME_CTRL_ONCS_DSM? In nvme_config_=
discard(),
> >> it appears that we prioritize ctrl->dmrsl, allowing discard to still b=
e
> >> supported even on some non-standard devices where NVME_CTRL_ONCS_DSM i=
s not set.
> >> In nvme_update_disk_info(), if the device only has NVME_QUIRK_DEALLOCA=
TE_ZEROES,
> >> we still populate lim->max_write_zeroes_sectors (which might be non-ze=
ro on
> >> devices that support NVME_CTRL_ONCS_WRITE_ZEROES). Right? So I'm not s=
ure if we
> >> only need to check for NVME_QUIRK_DEALLOCATE_ZEROES here.
> >>
> > The check for NVME_CTRL_ONCS_DSM is to follow the same check in [3]. Th=
ere, the
> > check was added by 58a0c875ce02 "nvme: don't apply NVME_QUIRK_DEALLOCAT=
E_ZEROES
> > when DSM is not supported" [6]. The idea is to limit
> > NVME_QUIRK_DEALLOCATE_ZEROES
> > to those devices that support DSM.
> >
>
> OK.
>
> >>>                 ns->head->features |=3D NVME_NS_DEAC;
> >>
> >> I think we should not set NVME_NS_DEAC for the quirks case.
> >>
> > Make sense. In that case, will it be more appropriate to set
> > max_hw_wzeroes_unmap_sectors in nvme_update_disk_info() where
> > NVME_QUIRK_DEALLOCATE_ZEROES is checked? I.e.
> >
> > diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> > index f5ebcaa2f859..3f5dd3f867e9 100644
> > --- a/drivers/nvme/host/core.c
> > +++ b/drivers/nvme/host/core.c
> > @@ -2120,9 +2120,10 @@ static bool nvme_update_disk_info(struct
> > nvme_ns *ns, struct nvme_id_ns *id,
> >         lim->io_min =3D phys_bs;
> >         lim->io_opt =3D io_opt;
> >         if ((ns->ctrl->quirks & NVME_QUIRK_DEALLOCATE_ZEROES) &&
> > -           (ns->ctrl->oncs & NVME_CTRL_ONCS_DSM))
> > +           (ns->ctrl->oncs & NVME_CTRL_ONCS_DSM)) {
> >                 lim->max_write_zeroes_sectors =3D UINT_MAX;
> > -       else
> > +               lim->max_hw_wzeroes_unmap_sectors =3D UINT_MAX;
> > +       } else
> >                 lim->max_write_zeroes_sectors =3D ns->ctrl->max_zeroes_=
sectors;
> >         return valid;
> >  }
> >
>
> Yeah, it looks good to me.

Thank you for your confirmation. I will follow up and submit the patch
to other maintainers for their review.

Best regards,
Robert

> Best regards,
> Yi.
>
> > Best regards
> > Robert
> >
> >> Cheers,
> >> Yi.
> >>
> >>>                 lim.max_hw_wzeroes_unmap_sectors =3D lim.max_write_ze=
roes_sectors;
> >>>         }
> >>>
> >>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/commit/?id=3D545fb46e5bc6
> >>> [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/tree/drivers/nvme/host/nvme.h#n72
> >>> [3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/tree/drivers/nvme/host/core.c#n938
> >>> [4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/tree/drivers/nvme/host/core.c#n2122
> >>> [5] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/commit/?id=3D6e02318eaea5
> > [6] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3D58a0c875ce02
>
