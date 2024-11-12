Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169D019EED4
	for <dm-devel@lists.linux.dev>; Tue, 12 Nov 2024 06:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731392789; cv=none; b=WTpqTD8/1y5uUWFwrT9JXUOcIz6s6T4rkDWbFK2OwuMWUg6b9FiHIOAqHa+P1pFWvAwp0RWHi5Bmkc6mLmVfmQ9THfBrbxcFSpwgGmTPTTdVv1DD60uzJ1GuifWokaR6nGAD+TiUAHyX+uBuouiR+1fLOGFqpJmme/XpsH51+/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731392789; c=relaxed/simple;
	bh=+xp6Ysbev1xxWNaASCRv+vsbJZ3DK6FOLxbV+SySOgg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vu05cDeluNu0Cmliv7RJ++Nsb1adSgSFn0xkv/iWR42YGLq0QmGiXxPJRAk8nLoGdBri4gs/mLmd+Zjf0tHw6PxODVJZub/cZSdXWwXMf9vVE9MGFifn/76kmKICJYF5jQycuyWrCnlZ7qICChC+vBIpd4VVvcs9S6yDsSaoe24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=imKYi/fa; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="imKYi/fa"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-7ea7e250c54so3918015a12.0
        for <dm-devel@lists.linux.dev>; Mon, 11 Nov 2024 22:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731392785; x=1731997585; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qL714C4QRGaXbBNo0u/Y80dreysCW6PHaIJGpeIRw7s=;
        b=imKYi/fa5e1Gz9eaA2KmRQOomMClIB8rGEVO4MGUqUoIItprzIqLT2VjJVOF7eYhy0
         x9HcDj1MDhoqHp2CceSYgTgP44AKfaWYfhQ9iy6swpyDVKfKaAYZKCaQuxOHt/aq9YiD
         zXP6xcphxd8QwTie0rXGd4fCTjNt1DhHaGYR/HyX9PrULYW3EOJEb1N0zvcWs7o2WFon
         HSJqPyaIl0H2z+6WghY5v+lO1hoplE3020YvJmeFpurbHatPndheRL3zdpX4+sMz8PJ/
         uKaG8fRL3HSPFgfccgtHH5tPZB0Azn+h62W4Lz9iZ/rNHsV3IOZSl3Bqt+2FQldXdL2J
         ODpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731392785; x=1731997585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qL714C4QRGaXbBNo0u/Y80dreysCW6PHaIJGpeIRw7s=;
        b=B4BhONf3HWBIJ/F0nXGHtMBLozz5xOod1Qcbm16WJ+9az3UUebvkznRU7Nw3rPm0oR
         c7aj28I8LkdtRRj5V2NEEUPS7oOSx9IdbIwE7L2MenPR1wOQnO4gUnsbN8yxy7AoSFGO
         fd9F0lp4Fy4zj2DM5zCx2UQqXbva6bSnzFn//Mj7Gk+wR6vYbxFWaf38gBnJ8F4uSUH3
         jO1Y+wEwz2g3bJR4rbG04HrJKqn74ll2v22M+nlUhoDrSR43ujGv0BSLZp8MBJNpzlx9
         +oRCUCVI8HcVoqYN+VkdQHOtcvKc/pwVggJrVrJ5yltZRmyhJ7fiSH9e6p5vgAupMSye
         E8rA==
X-Forwarded-Encrypted: i=1; AJvYcCXpDfxYMkkGr1jBRoyi11JA/b33m8XMZaRMVT6kG2b6Jx6QWNdM/sABdJ70LJphynXNSwnSg/DTCw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyh/iKJVOcNV/qYvBDtL8ZqfTVJTAC3UaMlsc0Su6BsBbjkNKsx
	oClbjlh7fuLo/IKBda9Zm4NK65CeY2u6p6SedODuEP/vLB1hLaY9prS5arlWXdM72e4KUjhbMMe
	FBenBKwXRPUvCsfTvQ61UOY0sF8Dt6+8whMPS
X-Google-Smtp-Source: AGHT+IHgofvdXai9ql/R37GkMlid+gHRIe7gcEW+cHXON+jZ5QFG9HcaxTkykQ/TI8XzLnoVRa4qswVD5wWF9OJMP3o=
X-Received: by 2002:a17:90b:3884:b0:2e2:ba35:3574 with SMTP id
 98e67ed59e1d1-2e9b1713658mr20602851a91.11.1731392785064; Mon, 11 Nov 2024
 22:26:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAO-8PLb0azRAuu2yJ3=K1EwiSXASDJ8nVBttbuOUV77==Xd2ug@mail.gmail.com>
 <94c895e2-0a71-73b2-2692-af8bf62fb340@redhat.com> <CAO-8PLYMFd3YLvfue_an7mc-O19fixJY4ZKybvjehxcm2tRYvA@mail.gmail.com>
 <CAO-8PLa3Qxhy1M1C_ZDTpOyXrhQ=UQKeKoDOmy-bbShb4rV03A@mail.gmail.com> <dcaed20c-2132-d453-9c04-b22417ba4010@redhat.com>
In-Reply-To: <dcaed20c-2132-d453-9c04-b22417ba4010@redhat.com>
From: Jooyung Han <jooyung@google.com>
Date: Tue, 12 Nov 2024 15:26:13 +0900
Message-ID: <CAO-8PLbTAMO867ifaHOdSWQrErV+vfsg2udWF27PK_VKmrMFgw@mail.gmail.com>
Subject: Re: [PATCH] dm: make it possible to open underlying devices in
 shareable mode
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, zkabelac@redhat.com, 
	dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Mikulas for the patch!

This works like a charm. Here's how I tested: On Android, for an APEX
file in /system partition, I create a dm-linear device with "shared"
mode on top of the dm-verity device underlying the system partition.
Previously, this failed with EBUSY because the dm-verity device is
owned by the /system filesystem. But I was able to create it in a
shared mode with your patch applied. Thanks again!

Jooyung

On Tue, Nov 12, 2024 at 1:49=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.co=
m> wrote:
>
> Hi
>
> On Fri, 8 Nov 2024, Jooyung Han wrote:
>
> > Hi Mikulas,
> >
> > Would it be reasonable to allow this? Or, to reduce the risk or impact
> > on other users, how about introducing a flag for dm-linear constructor
> > to open a table device without setting the holder. I don't know how to
> > describe this, not-exclusive? The dm-linear constructor would look like
> > "<dev_path> <offset> [no_exclusive]", when "no_exclusive" is set, it
> > will open a table device without setting a holder.
> >
> > I'd like to get your opinion about this idea. Especially if there's any
> > risks about not setting the holder when opening a DM table device.
> >
> > Besides, there's one more question about dm-verity. Even though there's
> > a field named "data_start" (comment saying it's "data offset in 512-byt=
e
> > sectors"): https://elixir.bootlin.com/linux/v6.11.4/source/drivers/md/d=
m-verity.h#L49,
> > it's not set in its constructor and always zero after initialization. I
> > think it's reasonable for the constructor to set it with an argument
> > passed. What do you think?
>
> Yes, we could set it in the constructor.
>
> > Thanks.
>
> I've created this (totally untested) patch that makes it possible to add =
a
> flag DM_OPEN_SHARED to the flags in the create ioctl - when the flag is
> used, all devices open by the specified device are open in a shared mode.
> Does the patch work for you?
>
> Mikulas
>
>
>
> From: Mikulas Patocka <mpatocka@redhat.com>
>
> This commit adds a new flag DM_OPEN_SHARED. The flag may be used on the
> create ioctl. When it is used, the underlying devices that are opened
> will be open in a shareable mode, so that the user can mount filesystems
> on them or perform other activity.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>
> ---
>  drivers/md/dm-core.h          |    1 +
>  drivers/md/dm-ioctl.c         |    4 ++--
>  drivers/md/dm.c               |    9 +++++++--
>  include/linux/device-mapper.h |    2 +-
>  include/uapi/linux/dm-ioctl.h |    6 ++++++
>  5 files changed, 17 insertions(+), 5 deletions(-)
>
> Index: linux-2.6/drivers/md/dm-core.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/md/dm-core.h 2024-07-30 14:06:48.000000000 +02=
00
> +++ linux-2.6/drivers/md/dm-core.h      2024-11-11 17:34:13.000000000 +01=
00
> @@ -161,6 +161,7 @@ struct mapped_device {
>  #define DMF_SUSPENDED_INTERNALLY 7
>  #define DMF_POST_SUSPENDING 8
>  #define DMF_EMULATE_ZONE_APPEND 9
> +#define DMF_OPEN_SHARED 10
>
>  void disable_discard(struct mapped_device *md);
>  void disable_write_zeroes(struct mapped_device *md);
> Index: linux-2.6/drivers/md/dm-ioctl.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/md/dm-ioctl.c        2024-09-02 17:35:39.00000=
0000 +0200
> +++ linux-2.6/drivers/md/dm-ioctl.c     2024-11-11 17:35:51.000000000 +01=
00
> @@ -888,7 +888,7 @@ static int dev_create(struct file *filp,
>         if (param->flags & DM_PERSISTENT_DEV_FLAG)
>                 m =3D MINOR(huge_decode_dev(param->dev));
>
> -       r =3D dm_create(m, &md);
> +       r =3D dm_create(m, param->flags, &md);
>         if (r)
>                 return r;
>
> @@ -2283,7 +2283,7 @@ int __init dm_early_create(struct dm_ioc
>                 m =3D MINOR(huge_decode_dev(dmi->dev));
>
>         /* alloc dm device */
> -       r =3D dm_create(m, &md);
> +       r =3D dm_create(m, 0, &md);
>         if (r)
>                 return r;
>
> Index: linux-2.6/drivers/md/dm.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/md/dm.c      2024-11-07 12:49:13.000000000 +01=
00
> +++ linux-2.6/drivers/md/dm.c   2024-11-11 17:35:05.000000000 +0100
> @@ -737,7 +737,9 @@ static struct table_device *open_table_d
>                 return ERR_PTR(-ENOMEM);
>         refcount_set(&td->count, 1);
>
> -       bdev_file =3D bdev_file_open_by_dev(dev, mode, _dm_claim_ptr, NUL=
L);
> +       bdev_file =3D bdev_file_open_by_dev(dev, mode,
> +               test_bit(DMF_OPEN_SHARED, &md->flags) ? NULL :_dm_claim_p=
tr,
> +               NULL);
>         if (IS_ERR(bdev_file)) {
>                 r =3D PTR_ERR(bdev_file);
>                 goto out_free_td;
> @@ -2489,7 +2491,7 @@ static struct dm_table *__unbind(struct
>  /*
>   * Constructor for a new device.
>   */
> -int dm_create(int minor, struct mapped_device **result)
> +int dm_create(int minor, uint32_t flags, struct mapped_device **result)
>  {
>         struct mapped_device *md;
>
> @@ -2497,6 +2499,9 @@ int dm_create(int minor, struct mapped_d
>         if (!md)
>                 return -ENXIO;
>
> +       if (flags & DM_OPEN_SHARED)
> +               set_bit(DMF_OPEN_SHARED, &md->flags);
> +
>         dm_ima_reset_data(md);
>
>         *result =3D md;
> Index: linux-2.6/include/linux/device-mapper.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/include/linux/device-mapper.h        2024-10-16 16:41:=
33.000000000 +0200
> +++ linux-2.6/include/linux/device-mapper.h     2024-11-11 17:31:32.00000=
0000 +0100
> @@ -483,7 +483,7 @@ void dm_consume_args(struct dm_arg_set *
>   * DM_ANY_MINOR chooses the next available minor number.
>   */
>  #define DM_ANY_MINOR (-1)
> -int dm_create(int minor, struct mapped_device **md);
> +int dm_create(int minor, uint32_t flags, struct mapped_device **md);
>
>  /*
>   * Reference counting for md.
> Index: linux-2.6/include/uapi/linux/dm-ioctl.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/include/uapi/linux/dm-ioctl.h        2023-09-05 14:46:=
02.000000000 +0200
> +++ linux-2.6/include/uapi/linux/dm-ioctl.h     2024-11-11 17:33:33.00000=
0000 +0100
> @@ -382,4 +382,10 @@ enum {
>   */
>  #define DM_IMA_MEASUREMENT_FLAG        (1 << 19) /* In */
>
> +/*
> + * Open underlying devices in the shareable mode, so that the user can m=
ount
> + * filesystems on them.
> + */
> +#define DM_OPEN_SHARED         (1 << 20) /* In */
> +
>  #endif                         /* _LINUX_DM_IOCTL_H */
