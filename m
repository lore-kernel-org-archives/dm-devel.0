Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E94A4C6FD1C
	for <dm-devel@archiver.kernel.org>; Thu, 23 Mar 2023 08:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679558473;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=aZrxrNvdOxt+B8Jrpk6IXdCgLAHLajtSRZV2NmvauKU=;
	b=N6tPOEJCl6HevNCFXz63NfgiGVZdNppSVxwMVVuI9qUiJx2XLwRVFFKbbWNa2NyFUbmHQP
	z6tndIMFnRFfTosZJawvB346R54mFI4/3YPpW8fRcnI9DZgooTaRceET50AnaRCFxXcjHC
	yZdJCOMUZUIpc8Hf8nWLmjBzgH47Gig=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-81-ypvGyQzgPZGFmHNVxgFWQQ-1; Thu, 23 Mar 2023 04:01:10 -0400
X-MC-Unique: ypvGyQzgPZGFmHNVxgFWQQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9AAC280D584;
	Thu, 23 Mar 2023 08:01:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4391C40C6E67;
	Thu, 23 Mar 2023 08:01:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1B19B1946A4F;
	Thu, 23 Mar 2023 08:01:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F06A31946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 23 Mar 2023 08:00:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E15F040C6E67; Thu, 23 Mar 2023 08:00:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D92B240C6E68
 for <dm-devel@redhat.com>; Thu, 23 Mar 2023 08:00:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9C323C1023C
 for <dm-devel@redhat.com>; Thu, 23 Mar 2023 08:00:34 +0000 (UTC)
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-aaRQKy5xNw6_94oRFX10NA-1; Thu, 23 Mar 2023 04:00:30 -0400
X-MC-Unique: aaRQKy5xNw6_94oRFX10NA-1
Received: by mail-yw1-f199.google.com with SMTP id
 00721157ae682-54161af1984so211386247b3.3
 for <dm-devel@redhat.com>; Thu, 23 Mar 2023 01:00:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679558429;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=XKRm+XnCwpaCf6gF+wKj2Spg4bbLbElRCGIc8TZxCPI=;
 b=VXqlc1S/+urJt6btHDb4xwjS00q2QJ5j2XlgS1OngPi0YP4fw3IwFG1YiS7TJn+VfB
 EYd14CCpsaSjjR7aMf6eTR6t0zJrYJv73hCM2ZiW6NABODph8rPUr6FrhUMeIaCJR4Fq
 /hC45vjJqaawoWdQ86Ik6MJscdZehY8ZdXqRmQ9biVqmhdZpwLeZrkhPj8bzdc10KPb9
 DTIAmwlnbpSdgadH6o/uaxDKiYzw4XPwCqC1usDPeP4M5Da4bP8BA/W8+vtizQ6nbPbY
 H+TjmCY+65YIblZBufzjDlWRfKwe+RQMkQYSiIbNIGIjDw9Z5lo+pFeJohi2GlcuNKuN
 GQgQ==
X-Gm-Message-State: AAQBX9dNEJxTgNpys5kw1pCC8omjBg2dxcSWybxPQpTBOyzdAWSVdo4s
 yCUwIRHFwJDZcO39U6lIQfjuH4EQfVaow/vqylkiS9HmWl9cP6tQ8meGFu2tpB7tSEOchN5E3IQ
 0oMW2JW8ErvyjIucsrlwOrZ1RiWKGUmo=
X-Received: by 2002:a81:ad5c:0:b0:545:1d7f:acbf with SMTP id
 l28-20020a81ad5c000000b005451d7facbfmr1294350ywk.10.1679558429380; 
 Thu, 23 Mar 2023 01:00:29 -0700 (PDT)
X-Google-Smtp-Source: AKy350b6COXNn3AiEDDbHM+BSgrtCyGai7tza2Bare3SXqL1Aw2NUif0ZKorAQ4BmQefYG2fsLgIFP0oH9ubi1CzRI0=
X-Received: by 2002:a81:ad5c:0:b0:545:1d7f:acbf with SMTP id
 l28-20020a81ad5c000000b005451d7facbfmr1294338ywk.10.1679558429134; Thu, 23
 Mar 2023 01:00:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230322181845.29848-1-snitzer@kernel.org>
 <20230322181845.29848-2-snitzer@kernel.org>
In-Reply-To: <20230322181845.29848-2-snitzer@kernel.org>
From: Joe Thornber <thornber@redhat.com>
Date: Thu, 23 Mar 2023 08:00:17 +0000
Message-ID: <CAJ0trDaZtr4Wa7KXUMCimgMO=UmfTa3nBLTC=rZB9Kf_pvhHKQ@mail.gmail.com>
To: Mike Snitzer <snitzer@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [dm-6.4 PATCH 1/8] dm: split discards further if
 target sets max_discard_granularity
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: keescook@chromium.org, heinzm@redhat.com, ejt@redhat.com, nhuck@google.com,
 ebiggers@kernel.org, dm-devel@redhat.com, mpatocka@redhat.com,
 luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============6699112401431536753=="

--===============6699112401431536753==
Content-Type: multipart/alternative; boundary="0000000000008c639405f78cab6f"

--0000000000008c639405f78cab6f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Also nacking this patch since you refused to test it.  I said I'd test
since you haven't, but you couldn't wait.

- Joe

On Wed, Mar 22, 2023 at 6:19=E2=80=AFPM Mike Snitzer <snitzer@kernel.org> w=
rote:

> The block core (bio_split_discard) will already split discards based
> on the 'discard_granularity' and 'max_discard_sectors' queue_limits.
> But the DM thin target also needs to ensure that it doesn't receive a
> discard that spans a 'max_discard_sectors' boundary.
>
> Introduce a dm_target 'max_discard_granularity' flag that if set will
> cause DM core to split discard bios relative to 'max_discard_sectors'.
> This treats 'discard_granularity' as a "min_discard_granularity" and
> 'max_discard_sectors' as a "max_discard_granularity".
>
> Requested-by: Joe Thornber <ejt@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> ---
>  drivers/md/dm.c               | 54 +++++++++++++++++++----------------
>  include/linux/device-mapper.h |  6 ++++
>  include/uapi/linux/dm-ioctl.h |  4 +--
>  3 files changed, 37 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index b6ace995b9ca..eeb58f89369e 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1162,7 +1162,8 @@ static inline sector_t
> max_io_len_target_boundary(struct dm_target *ti,
>         return ti->len - target_offset;
>  }
>
> -static sector_t max_io_len(struct dm_target *ti, sector_t sector)
> +static sector_t __max_io_len(struct dm_target *ti, sector_t sector,
> +                            unsigned int max_granularity)
>  {
>         sector_t target_offset =3D dm_target_offset(ti, sector);
>         sector_t len =3D max_io_len_target_boundary(ti, target_offset);
> @@ -1173,11 +1174,16 @@ static sector_t max_io_len(struct dm_target *ti,
> sector_t sector)
>          *   explains why stacked chunk_sectors based splitting via
>          *   bio_split_to_limits() isn't possible here.
>          */
> -       if (!ti->max_io_len)
> +       if (!max_granularity)
>                 return len;
>         return min_t(sector_t, len,
>                 min(queue_max_sectors(ti->table->md->queue),
> -                   blk_chunk_sectors_left(target_offset,
> ti->max_io_len)));
> +                   blk_chunk_sectors_left(target_offset,
> max_granularity)));
> +}
> +
> +static inline sector_t max_io_len(struct dm_target *ti, sector_t sector)
> +{
> +       return __max_io_len(ti, sector, ti->max_io_len);
>  }
>
>  int dm_set_target_max_io_len(struct dm_target *ti, sector_t len)
> @@ -1561,26 +1567,6 @@ static void __send_empty_flush(struct clone_info
> *ci)
>         bio_uninit(ci->bio);
>  }
>
> -static void __send_changing_extent_only(struct clone_info *ci, struct
> dm_target *ti,
> -                                       unsigned int num_bios)
> -{
> -       unsigned int len, bios;
> -
> -       len =3D min_t(sector_t, ci->sector_count,
> -                   max_io_len_target_boundary(ti, dm_target_offset(ti,
> ci->sector)));
> -
> -       atomic_add(num_bios, &ci->io->io_count);
> -       bios =3D __send_duplicate_bios(ci, ti, num_bios, &len);
> -       /*
> -        * alloc_io() takes one extra reference for submission, so the
> -        * reference won't reach 0 without the following (+1) subtraction
> -        */
> -       atomic_sub(num_bios - bios + 1, &ci->io->io_count);
> -
> -       ci->sector +=3D len;
> -       ci->sector_count -=3D len;
> -}
> -
>  static bool is_abnormal_io(struct bio *bio)
>  {
>         enum req_op op =3D bio_op(bio);
> @@ -1602,11 +1588,16 @@ static bool is_abnormal_io(struct bio *bio)
>  static blk_status_t __process_abnormal_io(struct clone_info *ci,
>                                           struct dm_target *ti)
>  {
> -       unsigned int num_bios =3D 0;
> +       unsigned int bios, num_bios =3D 0;
> +       unsigned int len, max_granularity =3D 0;
>
>         switch (bio_op(ci->bio)) {
>         case REQ_OP_DISCARD:
>                 num_bios =3D ti->num_discard_bios;
> +               if (ti->max_discard_granularity) {
> +                       struct queue_limits *limits =3D
> dm_get_queue_limits(ti->table->md);
> +                       max_granularity =3D limits->max_discard_sectors;
> +               }
>                 break;
>         case REQ_OP_SECURE_ERASE:
>                 num_bios =3D ti->num_secure_erase_bios;
> @@ -1627,7 +1618,20 @@ static blk_status_t __process_abnormal_io(struct
> clone_info *ci,
>         if (unlikely(!num_bios))
>                 return BLK_STS_NOTSUPP;
>
> -       __send_changing_extent_only(ci, ti, num_bios);
> +       len =3D min_t(sector_t, ci->sector_count,
> +                   __max_io_len(ti, ci->sector, max_granularity));
> +
> +       atomic_add(num_bios, &ci->io->io_count);
> +       bios =3D __send_duplicate_bios(ci, ti, num_bios, &len);
> +       /*
> +        * alloc_io() takes one extra reference for submission, so the
> +        * reference won't reach 0 without the following (+1) subtraction
> +        */
> +       atomic_sub(num_bios - bios + 1, &ci->io->io_count);
> +
> +       ci->sector +=3D len;
> +       ci->sector_count -=3D len;
> +
>         return BLK_STS_OK;
>  }
>
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.=
h
> index 7975483816e4..8aa6b3ea91fa 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -358,6 +358,12 @@ struct dm_target {
>          */
>         bool discards_supported:1;
>
> +       /*
> +        * Set if this target requires that discards be split on both
> +        * 'discard_granularity' and 'max_discard_sectors' boundaries.
> +        */
> +       bool max_discard_granularity:1;
> +
>         /*
>          * Set if we need to limit the number of in-flight bios when
> swapping.
>          */
> diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.=
h
> index 7edf335778ba..1990b5700f69 100644
> --- a/include/uapi/linux/dm-ioctl.h
> +++ b/include/uapi/linux/dm-ioctl.h
> @@ -286,9 +286,9 @@ enum {
>  #define DM_DEV_SET_GEOMETRY    _IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD,
> struct dm_ioctl)
>
>  #define DM_VERSION_MAJOR       4
> -#define DM_VERSION_MINOR       47
> +#define DM_VERSION_MINOR       48
>  #define DM_VERSION_PATCHLEVEL  0
> -#define DM_VERSION_EXTRA       "-ioctl (2022-07-28)"
> +#define DM_VERSION_EXTRA       "-ioctl (2023-03-01)"
>
>  /* Status bits */
>  #define DM_READONLY_FLAG       (1 << 0) /* In/Out */
> --
> 2.40.0
>
>

--0000000000008c639405f78cab6f
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Also nacking=C2=A0this patch since you refused to test it.=
=C2=A0 I said I&#39;d test since you haven&#39;t, but you couldn&#39;t wait=
.<div><br></div><div>- Joe</div></div><br><div class=3D"gmail_quote"><div d=
ir=3D"ltr" class=3D"gmail_attr">On Wed, Mar 22, 2023 at 6:19=E2=80=AFPM Mik=
e Snitzer &lt;<a href=3D"mailto:snitzer@kernel.org">snitzer@kernel.org</a>&=
gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0=
px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">The b=
lock core (bio_split_discard) will already split discards based<br>
on the &#39;discard_granularity&#39; and &#39;max_discard_sectors&#39; queu=
e_limits.<br>
But the DM thin target also needs to ensure that it doesn&#39;t receive a<b=
r>
discard that spans a &#39;max_discard_sectors&#39; boundary.<br>
<br>
Introduce a dm_target &#39;max_discard_granularity&#39; flag that if set wi=
ll<br>
cause DM core to split discard bios relative to &#39;max_discard_sectors&#3=
9;.<br>
This treats &#39;discard_granularity&#39; as a &quot;min_discard_granularit=
y&quot; and<br>
&#39;max_discard_sectors&#39; as a &quot;max_discard_granularity&quot;.<br>
<br>
Requested-by: Joe Thornber &lt;<a href=3D"mailto:ejt@redhat.com" target=3D"=
_blank">ejt@redhat.com</a>&gt;<br>
Signed-off-by: Mike Snitzer &lt;<a href=3D"mailto:snitzer@kernel.org" targe=
t=3D"_blank">snitzer@kernel.org</a>&gt;<br>
---<br>
=C2=A0drivers/md/dm.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0| 54 +++++++++++++++++++----------------<br>
=C2=A0include/linux/device-mapper.h |=C2=A0 6 ++++<br>
=C2=A0include/uapi/linux/dm-ioctl.h |=C2=A0 4 +--<br>
=C2=A03 files changed, 37 insertions(+), 27 deletions(-)<br>
<br>
diff --git a/drivers/md/dm.c b/drivers/md/dm.c<br>
index b6ace995b9ca..eeb58f89369e 100644<br>
--- a/drivers/md/dm.c<br>
+++ b/drivers/md/dm.c<br>
@@ -1162,7 +1162,8 @@ static inline sector_t max_io_len_target_boundary(str=
uct dm_target *ti,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return ti-&gt;len - target_offset;<br>
=C2=A0}<br>
<br>
-static sector_t max_io_len(struct dm_target *ti, sector_t sector)<br>
+static sector_t __max_io_len(struct dm_target *ti, sector_t sector,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int max_granularity)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 sector_t target_offset =3D dm_target_offset(ti,=
 sector);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 sector_t len =3D max_io_len_target_boundary(ti,=
 target_offset);<br>
@@ -1173,11 +1174,16 @@ static sector_t max_io_len(struct dm_target *ti, se=
ctor_t sector)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*=C2=A0 =C2=A0explains why stacked chunk_=
sectors based splitting via<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*=C2=A0 =C2=A0bio_split_to_limits() isn&#=
39;t possible here.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!ti-&gt;max_io_len)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!max_granularity)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return len;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return min_t(sector_t, len,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 min(queue_max_secto=
rs(ti-&gt;table-&gt;md-&gt;queue),<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0blk_c=
hunk_sectors_left(target_offset, ti-&gt;max_io_len)));<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0blk_c=
hunk_sectors_left(target_offset, max_granularity)));<br>
+}<br>
+<br>
+static inline sector_t max_io_len(struct dm_target *ti, sector_t sector)<b=
r>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return __max_io_len(ti, sector, ti-&gt;max_io_l=
en);<br>
=C2=A0}<br>
<br>
=C2=A0int dm_set_target_max_io_len(struct dm_target *ti, sector_t len)<br>
@@ -1561,26 +1567,6 @@ static void __send_empty_flush(struct clone_info *ci=
)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 bio_uninit(ci-&gt;bio);<br>
=C2=A0}<br>
<br>
-static void __send_changing_extent_only(struct clone_info *ci, struct dm_t=
arget *ti,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned =
int num_bios)<br>
-{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int len, bios;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0len =3D min_t(sector_t, ci-&gt;sector_count,<br=
>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0max_i=
o_len_target_boundary(ti, dm_target_offset(ti, ci-&gt;sector)));<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_add(num_bios, &amp;ci-&gt;io-&gt;io_coun=
t);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0bios =3D __send_duplicate_bios(ci, ti, num_bios=
, &amp;len);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 * alloc_io() takes one extra reference for sub=
mission, so the<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 * reference won&#39;t reach 0 without the foll=
owing (+1) subtraction<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_sub(num_bios - bios + 1, &amp;ci-&gt;io-=
&gt;io_count);<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0ci-&gt;sector +=3D len;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0ci-&gt;sector_count -=3D len;<br>
-}<br>
-<br>
=C2=A0static bool is_abnormal_io(struct bio *bio)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 enum req_op op =3D bio_op(bio);<br>
@@ -1602,11 +1588,16 @@ static bool is_abnormal_io(struct bio *bio)<br>
=C2=A0static blk_status_t __process_abnormal_io(struct clone_info *ci,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 s=
truct dm_target *ti)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int num_bios =3D 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int bios, num_bios =3D 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int len, max_granularity =3D 0;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 switch (bio_op(ci-&gt;bio)) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 case REQ_OP_DISCARD:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 num_bios =3D ti-&gt=
;num_discard_bios;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ti-&gt;max_disc=
ard_granularity) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0struct queue_limits *limits =3D dm_get_queue_limits(ti-&gt;table-=
&gt;md);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0max_granularity =3D limits-&gt;max_discard_sectors;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 case REQ_OP_SECURE_ERASE:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 num_bios =3D ti-&gt=
;num_secure_erase_bios;<br>
@@ -1627,7 +1618,20 @@ static blk_status_t __process_abnormal_io(struct clo=
ne_info *ci,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (unlikely(!num_bios))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return BLK_STS_NOTS=
UPP;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0__send_changing_extent_only(ci, ti, num_bios);<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0len =3D min_t(sector_t, ci-&gt;sector_count,<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__max=
_io_len(ti, ci-&gt;sector, max_granularity));<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_add(num_bios, &amp;ci-&gt;io-&gt;io_coun=
t);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0bios =3D __send_duplicate_bios(ci, ti, num_bios=
, &amp;len);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * alloc_io() takes one extra reference for sub=
mission, so the<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * reference won&#39;t reach 0 without the foll=
owing (+1) subtraction<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_sub(num_bios - bios + 1, &amp;ci-&gt;io-=
&gt;io_count);<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0ci-&gt;sector +=3D len;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0ci-&gt;sector_count -=3D len;<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return BLK_STS_OK;<br>
=C2=A0}<br>
<br>
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h<=
br>
index 7975483816e4..8aa6b3ea91fa 100644<br>
--- a/include/linux/device-mapper.h<br>
+++ b/include/linux/device-mapper.h<br>
@@ -358,6 +358,12 @@ struct dm_target {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 bool discards_supported:1;<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * Set if this target requires that discards be=
 split on both<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * &#39;discard_granularity&#39; and &#39;max_d=
iscard_sectors&#39; boundaries.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0bool max_discard_granularity:1;<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Set if we need to limit the number of i=
n-flight bios when swapping.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h<=
br>
index 7edf335778ba..1990b5700f69 100644<br>
--- a/include/uapi/linux/dm-ioctl.h<br>
+++ b/include/uapi/linux/dm-ioctl.h<br>
@@ -286,9 +286,9 @@ enum {<br>
=C2=A0#define DM_DEV_SET_GEOMETRY=C2=A0 =C2=A0 _IOWR(DM_IOCTL, DM_DEV_SET_G=
EOMETRY_CMD, struct dm_ioctl)<br>
<br>
=C2=A0#define DM_VERSION_MAJOR=C2=A0 =C2=A0 =C2=A0 =C2=A04<br>
-#define DM_VERSION_MINOR=C2=A0 =C2=A0 =C2=A0 =C2=A047<br>
+#define DM_VERSION_MINOR=C2=A0 =C2=A0 =C2=A0 =C2=A048<br>
=C2=A0#define DM_VERSION_PATCHLEVEL=C2=A0 0<br>
-#define DM_VERSION_EXTRA=C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;-ioctl (2022-07-2=
8)&quot;<br>
+#define DM_VERSION_EXTRA=C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;-ioctl (2023-03-0=
1)&quot;<br>
<br>
=C2=A0/* Status bits */<br>
=C2=A0#define DM_READONLY_FLAG=C2=A0 =C2=A0 =C2=A0 =C2=A0(1 &lt;&lt; 0) /* =
In/Out */<br>
-- <br>
2.40.0<br>
<br>
</blockquote></div>

--0000000000008c639405f78cab6f--

--===============6699112401431536753==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============6699112401431536753==--

