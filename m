Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D000CCA473
	for <dm-devel@archiver.kernel.org>; Mon, 27 Jun 2022 13:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656337897;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=6x64t66NMBKhQT7AC2YGuHjuaLNrhssSdm0a9aJEwg4=;
	b=QqHwrmpXgEN3RGSugnD/YIvC6t/5KUt8FlsfTup7PMIM0+PssPml4hwVU9t5eP2Nzw7ATJ
	BoAvRbCSa3LdK0D7pBE5sdOvl3S7l5AVnPvSWwY8ln2U4rCz71ScSSPIAqsWaJPXgiOp2d
	JnI3YnWFR+BbePrd5PEAc4MKLN4tIbk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-E3mUVmraNbCKAde1mt3Q7Q-1; Mon, 27 Jun 2022 09:51:33 -0400
X-MC-Unique: E3mUVmraNbCKAde1mt3Q7Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C4D3811E9B;
	Mon, 27 Jun 2022 13:51:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AEF7D4010E53;
	Mon, 27 Jun 2022 13:51:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 813C21947041;
	Mon, 27 Jun 2022 13:51:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 489941947040
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Jun 2022 13:51:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0BC3A2026D07; Mon, 27 Jun 2022 13:51:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 079AD2026D64
 for <dm-devel@redhat.com>; Mon, 27 Jun 2022 13:51:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB7721019C83
 for <dm-devel@redhat.com>; Mon, 27 Jun 2022 13:51:28 +0000 (UTC)
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-50-lziBs_uUOhSTV6_y2HoOSQ-1; Mon, 27 Jun 2022 09:51:27 -0400
X-MC-Unique: lziBs_uUOhSTV6_y2HoOSQ-1
Received: by mail-oa1-f70.google.com with SMTP id
 586e51a60fabf-f313416010so6650420fac.2
 for <dm-devel@redhat.com>; Mon, 27 Jun 2022 06:51:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=DGsM8V5Eta4K051kTO9LJ2lkSIVQAE1i69Nj9z7Xpqk=;
 b=4DhCYL+83KlUFDUrwx+kbtBj7MAHM5QICB08pk/KQGlIB6kGWRgbYs9E1vPnkxgNmS
 cIeELhUbel9VYBfg8QciYkZ+v7ZIxs2DG2CiN0Fc9h3yIziDTKlJOdIl5wddZLR/dEan
 CdWrqSGlatRg4ixel0rsk3dsgLdqsQOD/zaPQBY0lG6Ti45R+GII0lvTspvDBE4VdTsk
 cjhCFgtG/4qQbbGYzzrw1j93tsHswE7bkTHz+GfhVjdUWqy46yYJc/X8xDcwUNYYS5iy
 9OIPLDVSTqL+P/cSJxS1/DzCvee/4xFH9vxsCgTJesNIqeMqj3idBF+X+rCA+8MQX1b/
 0syA==
X-Gm-Message-State: AJIora//1mVz2yyw5Od6TGs9rOHAalBVhsUmqOghUpGpvhPIfBgbfyBY
 9mJWVvHYjjLovVX3R+XkyUU+q6vzZA0Cttt67V/yHgY+Aa8e57kflLEdT+J9nLWZ+EasBGpDsA7
 bngNlGqBI7A/HF28BDfA2yrdj5k3cRiI=
X-Received: by 2002:a9d:60d2:0:b0:616:d6a5:a8d8 with SMTP id
 b18-20020a9d60d2000000b00616d6a5a8d8mr1232823otk.90.1656337886474; 
 Mon, 27 Jun 2022 06:51:26 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tl/cq9Q6DMt1Lg4nXue32nMdNpIkTADleUp4rcZpFlJFffEM9ZY57spylI/VNBleXXY+5QwhWGYeb2vRD3OjA=
X-Received: by 2002:a9d:60d2:0:b0:616:d6a5:a8d8 with SMTP id
 b18-20020a9d60d2000000b00616d6a5a8d8mr1232812otk.90.1656337886287; Mon, 27
 Jun 2022 06:51:26 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2206270858520.13562@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2206270858520.13562@file01.intranet.prod.int.rdu2.redhat.com>
From: Heinz Mauelshagen <heinzm@redhat.com>
Date: Mon, 27 Jun 2022 15:51:15 +0200
Message-ID: <CAM23VxqOH9SeZFvfbFD2zUF_WFDUVY1Xh0ngp_1E+7n=7+7TUQ@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH] dm-raid: fix out of memory accesses in
 dm-raid
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
Cc: Mike Snitzer <msnitzer@redhat.com>, Marian Csontos <mcsontos@redhat.com>,
 linux-raid <linux-raid@vger.kernel.org>, Song Liu <song@kernel.org>,
 dm-devel@redhat.com, Ming Lei <minlei@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============6027774755211298421=="

--===============6027774755211298421==
Content-Type: multipart/alternative; boundary="000000000000572d7f05e26e37c0"

--000000000000572d7f05e26e37c0
Content-Type: text/plain; charset="UTF-8"

NACK,
loop conditionals have to be on rs->raid_disks, as we add legs to raid1 or
stripes to raid4/5/6/10 in which case rs->raid_disks will be larger than
rs->md.raid_disks.
As a result, the new legs wouldn't be processed during RAID validation or
device iterations.

Will rework the patch and share here after running it through the lvm test
suite raid tests...

On Mon, Jun 27, 2022 at 3:00 PM Mikulas Patocka <mpatocka@redhat.com> wrote:

> dm-raid allocates the array of devices with rs->raid_disks entries and
> then accesses it in a loop for rs->md.raid_disks. During reshaping,
> rs->md.raid_disks may be greater than rs->raid_disks, so it accesses
> entries beyond the end of the array.
>
> We fix this bug by limiting the iteration to rs->raid_disks.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
>
> ---
>  drivers/md/dm-raid.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> Index: linux-2.6/drivers/md/dm-raid.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-raid.c 2022-06-27 14:45:30.000000000 +0200
> +++ linux-2.6/drivers/md/dm-raid.c      2022-06-27 14:54:02.000000000 +0200
> @@ -1004,7 +1004,7 @@ static int validate_raid_redundancy(stru
>         unsigned int rebuilds_per_group = 0, copies;
>         unsigned int group_size, last_group_start;
>
> -       for (i = 0; i < rs->md.raid_disks; i++)
> +       for (i = 0; i < rs->md.raid_disks && i < rs->raid_disks; i++)
>                 if (!test_bit(In_sync, &rs->dev[i].rdev.flags) ||
>                     !rs->dev[i].rdev.sb_page)
>                         rebuild_cnt++;
> @@ -1047,7 +1047,7 @@ static int validate_raid_redundancy(stru
>                  *          C    D    D    E    E
>                  */
>                 if (__is_raid10_near(rs->md.new_layout)) {
> -                       for (i = 0; i < rs->md.raid_disks; i++) {
> +                       for (i = 0; i < rs->md.raid_disks && i <
> rs->raid_disks; i++) {
>                                 if (!(i % copies))
>                                         rebuilds_per_group = 0;
>                                 if ((!rs->dev[i].rdev.sb_page ||
> @@ -1073,7 +1073,7 @@ static int validate_raid_redundancy(stru
>                 group_size = (rs->md.raid_disks / copies);
>                 last_group_start = (rs->md.raid_disks / group_size) - 1;
>                 last_group_start *= group_size;
> -               for (i = 0; i < rs->md.raid_disks; i++) {
> +               for (i = 0; i < rs->md.raid_disks && i < rs->raid_disks;
> i++) {
>                         if (!(i % copies) && !(i > last_group_start))
>                                 rebuilds_per_group = 0;
>                         if ((!rs->dev[i].rdev.sb_page ||
> @@ -1588,7 +1588,7 @@ static sector_t __rdev_sectors(struct ra
>  {
>         int i;
>
> -       for (i = 0; i < rs->md.raid_disks; i++) {
> +       for (i = 0; i < rs->md.raid_disks && i < rs->raid_disks; i++) {
>                 struct md_rdev *rdev = &rs->dev[i].rdev;
>
>                 if (!test_bit(Journal, &rdev->flags) &&
> @@ -3766,7 +3766,7 @@ static int raid_iterate_devices(struct d
>         unsigned int i;
>         int r = 0;
>
> -       for (i = 0; !r && i < rs->md.raid_disks; i++)
> +       for (i = 0; !r && i < rs->md.raid_disks && i < rs->raid_disks; i++)
>                 if (rs->dev[i].data_dev)
>                         r = fn(ti,
>                                  rs->dev[i].data_dev,
> @@ -3817,7 +3817,7 @@ static void attempt_restore_of_faulty_de
>
>         memset(cleared_failed_devices, 0, sizeof(cleared_failed_devices));
>
> -       for (i = 0; i < mddev->raid_disks; i++) {
> +       for (i = 0; i < mddev->raid_disks && i < rs->raid_disks; i++) {
>                 r = &rs->dev[i].rdev;
>                 /* HM FIXME: enhance journal device recovery processing */
>                 if (test_bit(Journal, &r->flags))
>
>

--000000000000572d7f05e26e37c0
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">NACK,<div>loop conditionals have to be on rs-&gt;raid_disk=
s, as we add legs to raid1 or stripes=C2=A0to raid4/5/6/10 in which case rs=
-&gt;raid_disks will be larger than rs-&gt;md.raid_disks.<div>As a result, =
the new legs wouldn&#39;t be processed during RAID validation or device=C2=
=A0iterations.<div><br><div>Will rework the patch and share here after runn=
ing it through the lvm test suite raid tests...</div></div></div></div></di=
v><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On M=
on, Jun 27, 2022 at 3:00 PM Mikulas Patocka &lt;<a href=3D"mailto:mpatocka@=
redhat.com">mpatocka@redhat.com</a>&gt; wrote:<br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex">dm-raid allocates the array of devices wit=
h rs-&gt;raid_disks entries and<br>
then accesses it in a loop for rs-&gt;md.raid_disks. During reshaping,<br>
rs-&gt;md.raid_disks may be greater than rs-&gt;raid_disks, so it accesses<=
br>
entries beyond the end of the array.<br>
<br>
We fix this bug by limiting the iteration to rs-&gt;raid_disks.<br>
<br>
Signed-off-by: Mikulas Patocka &lt;<a href=3D"mailto:mpatocka@redhat.com" t=
arget=3D"_blank">mpatocka@redhat.com</a>&gt;<br>
Cc: <a href=3D"mailto:stable@vger.kernel.org" target=3D"_blank">stable@vger=
.kernel.org</a><br>
<br>
---<br>
=C2=A0drivers/md/dm-raid.c |=C2=A0 =C2=A012 ++++++------<br>
=C2=A01 file changed, 6 insertions(+), 6 deletions(-)<br>
<br>
Index: linux-2.6/drivers/md/dm-raid.c<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
--- linux-2.6.orig/drivers/md/dm-raid.c 2022-06-27 14:45:30.000000000 +0200=
<br>
+++ linux-2.6/drivers/md/dm-raid.c=C2=A0 =C2=A0 =C2=A0 2022-06-27 14:54:02.=
000000000 +0200<br>
@@ -1004,7 +1004,7 @@ static int validate_raid_redundancy(stru<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int rebuilds_per_group =3D 0, copies;<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int group_size, last_group_start;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; rs-&gt;md.raid_disks; i++)=
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; rs-&gt;md.raid_disks &amp;=
&amp; i &lt; rs-&gt;raid_disks; i++)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!test_bit(In_sy=
nc, &amp;rs-&gt;dev[i].rdev.flags) ||<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 !rs-&=
gt;dev[i].rdev.sb_page)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 rebuild_cnt++;<br>
@@ -1047,7 +1047,7 @@ static int validate_raid_redundancy(stru<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 C=C2=A0 =C2=A0 D=C2=A0 =C2=A0 D=C2=A0 =C2=A0 E=C2=
=A0 =C2=A0 E<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (__is_raid10_nea=
r(rs-&gt;md.new_layout)) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0for (i =3D 0; i &lt; rs-&gt;md.raid_disks; i++) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0for (i =3D 0; i &lt; rs-&gt;md.raid_disks &amp;&amp; i &lt; rs-&g=
t;raid_disks; i++) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!(i % copies))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rebuilds=
_per_group =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((!rs-&gt;dev[i].rdev.sb_page ||<=
br>
@@ -1073,7 +1073,7 @@ static int validate_raid_redundancy(stru<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 group_size =3D (rs-=
&gt;md.raid_disks / copies);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 last_group_start =
=3D (rs-&gt;md.raid_disks / group_size) - 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 last_group_start *=
=3D group_size;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt=
; rs-&gt;md.raid_disks; i++) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt=
; rs-&gt;md.raid_disks &amp;&amp; i &lt; rs-&gt;raid_disks; i++) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (!(i % copies) &amp;&amp; !(i &gt; last_group_start))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rebuilds_per_group =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if ((!rs-&gt;dev[i].rdev.sb_page ||<br>
@@ -1588,7 +1588,7 @@ static sector_t __rdev_sectors(struct ra<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; rs-&gt;md.raid_disks; i++)=
 {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; rs-&gt;md.raid_disks &amp;=
&amp; i &lt; rs-&gt;raid_disks; i++) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct md_rdev *rde=
v =3D &amp;rs-&gt;dev[i].rdev;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!test_bit(Journ=
al, &amp;rdev-&gt;flags) &amp;&amp;<br>
@@ -3766,7 +3766,7 @@ static int raid_iterate_devices(struct d<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int i;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r =3D 0;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; !r &amp;&amp; i &lt; rs-&gt;md.ra=
id_disks; i++)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; !r &amp;&amp; i &lt; rs-&gt;md.ra=
id_disks &amp;&amp; i &lt; rs-&gt;raid_disks; i++)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rs-&gt;dev[i].d=
ata_dev)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 r =3D fn(ti,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rs-&gt;dev[i].data_dev,<br>
@@ -3817,7 +3817,7 @@ static void attempt_restore_of_faulty_de<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(cleared_failed_devices, 0, sizeof(cleare=
d_failed_devices));<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; mddev-&gt;raid_disks; i++)=
 {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; mddev-&gt;raid_disks &amp;=
&amp; i &lt; rs-&gt;raid_disks; i++) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D &amp;rs-&gt;d=
ev[i].rdev;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* HM FIXME: enhanc=
e journal device recovery processing */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (test_bit(Journa=
l, &amp;r-&gt;flags))<br>
<br>
</blockquote></div>

--000000000000572d7f05e26e37c0--

--===============6027774755211298421==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============6027774755211298421==--

