Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F243C43334
	for <dm-devel@archiver.kernel.org>; Mon, 27 Jun 2022 22:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656369463;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=cW2VpfHFuFdj+oY2Bo61WLBad2hFdlNZoDNj+0Ist3Y=;
	b=GYpn3mZ3NBOIanJ47dvG16gMuyVjP8f8fEG7/PMw4QPNYaMJiDLnP6I8mWiulKzStUEKJ7
	CF8B3A2hcgagTPFaTSvx06+dxBPRLDMXKlz8I1jfWYMAM8mcegJarUdBERMeWH1qnH6ZXd
	Wdg+2HxwgQGF1ntloJb5YpldlhFoXr4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-dsUyJlf3OUu0umjDLRTzFw-1; Mon, 27 Jun 2022 18:37:39 -0400
X-MC-Unique: dsUyJlf3OUu0umjDLRTzFw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A58E29AB450;
	Mon, 27 Jun 2022 22:37:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 51D021121314;
	Mon, 27 Jun 2022 22:37:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2A7F9194704A;
	Mon, 27 Jun 2022 22:37:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D2CE119466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Jun 2022 22:37:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BE3D49D54; Mon, 27 Jun 2022 22:37:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B9F0B815B
 for <dm-devel@redhat.com>; Mon, 27 Jun 2022 22:37:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A7F51C04B61
 for <dm-devel@redhat.com>; Mon, 27 Jun 2022 22:37:35 +0000 (UTC)
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-oQKaVaWiMA61wN08XdU7iw-1; Mon, 27 Jun 2022 18:37:34 -0400
X-MC-Unique: oQKaVaWiMA61wN08XdU7iw-1
Received: by mail-oa1-f71.google.com with SMTP id
 586e51a60fabf-f2bdeb5298so7408900fac.5
 for <dm-devel@redhat.com>; Mon, 27 Jun 2022 15:37:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=TFa66qRM6exFQouj4lF7x/ZwP4/mAeWgLGYTtSCTK0U=;
 b=SPJ1OGPgC80WunRbJM1XZfpxlnifQYc7wziUZBOIFOeOniEQANDpdHJ0UH5QAoLRML
 ESfV1Z1GIJohd0Mx8R8TQQ1dMDJcy8Kbs4dxW67X0fDC4hkCM8WniO/zSqAnvA/YXaXF
 lT8BNhvd7uPKk55U2LiafF8MUxwOV5I2jfqHBLGDtSBfZeSi2lMmDlyKXKZYX9QsFlTJ
 CICSZz6Z3mWqUF1RgR9wDKq2Qmjdc2FPawdhg4Op1/E5jDnjEoVgemAxofZyAUc98f7V
 nbVob05B7RNZpq2VjlGnTCGuBjSHApqnIvI7K3328zm8TS0ksbXMrqNhXy6ZIOtAohkP
 ux/w==
X-Gm-Message-State: AJIora+ZT8lVAsrauDe4EYX3co1oqT723lPugRVH/TgC626he0funp7+
 hSjbTwUX1APoqnNdV+bJqx5ED/ZQ7AGeVdy3oMwh2BxotIipQGxKacwSc/k7L5jvYNtlZlO2+6G
 +qXQq3kFniY5UxXHuE2B3lNdtd9Q7dgc=
X-Received: by 2002:a05:6870:9a28:b0:fe:4636:98aa with SMTP id
 fo40-20020a0568709a2800b000fe463698aamr9124118oab.21.1656369453333; 
 Mon, 27 Jun 2022 15:37:33 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vkxfQJJHnTgghD6HtmsI7Y59sb+pppArEWZ0gJeHYndzkwlZHM4PHmrbG3lNDll/frCmi9nAzcwt/3YZLb5rw=
X-Received: by 2002:a05:6870:9a28:b0:fe:4636:98aa with SMTP id
 fo40-20020a0568709a2800b000fe463698aamr9124105oab.21.1656369453096; Mon, 27
 Jun 2022 15:37:33 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2206270858520.13562@file01.intranet.prod.int.rdu2.redhat.com>
 <CAM23VxqOH9SeZFvfbFD2zUF_WFDUVY1Xh0ngp_1E+7n=7+7TUQ@mail.gmail.com>
 <alpine.LRH.2.02.2206270954570.16147@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2206270954570.16147@file01.intranet.prod.int.rdu2.redhat.com>
From: Heinz Mauelshagen <heinzm@redhat.com>
Date: Tue, 28 Jun 2022 00:37:22 +0200
Message-ID: <CAM23Vxqd2RVywyEumbPC=JMCaus5neYNTRJ6kqbmSbs3rVmNQQ@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v2] dm-raid: fix out of memory accesses in
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============4482733968574758919=="

--===============4482733968574758919==
Content-Type: multipart/alternative; boundary="000000000000de7aa805e2759093"

--000000000000de7aa805e2759093
Content-Type: text/plain; charset="UTF-8"

From 852b91efc183e9b87ac50f15fb4df86f26f73532 Mon Sep 17 00:00:00 2001
From: Heinz Mauelshagen <heinzm@redhat.com>
Date: Mon, 27 Jun 2022 23:54:24 +0200
Subject: [PATCH] dm-raid: fix array out of bounds (OOB)

Supersedes "[PATCH] dm-raid: fix out of memory accesses in dm-raid"


On RAID mapping construction, dm-raid allocates an array
rs->devs[rs->raid_disks]
for the raid device members.  rs->raid_disks is defined by the number of
raid
metadata and image tupples passed into the target's constructor.

That number can be different from the current number of members for
existing raid
sets as defined in their superblocks in case of layout changes requested:

- raid1 legs being added/removed

- raid4/5/6/10 number of stripes changed (stripe reshaping)

- takeover to higher raid level (e.g. raid5 -> raid6)

Accessing array members, rs->raid_disks has to be used in loops instead of
potentially larger rs->md.raid_disks causing OOB access on the devices
array.

Patch changes instances prone to OOB.
Also ensures added devices are validated in validate_raid_redundancy().

Initially discovered by KASAN.

Passes all LVM2 RAID tests (KASAN enabled).

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Tested-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 2b26435a6946..bcec0e1a049d 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1001,12 +1001,13 @@ static int validate_region_size(struct raid_set
*rs, unsigned long region_size)
 static int validate_raid_redundancy(struct raid_set *rs)
 {
        unsigned int i, rebuild_cnt = 0;
-       unsigned int rebuilds_per_group = 0, copies;
+       unsigned int rebuilds_per_group = 0, copies, raid_disks;
        unsigned int group_size, last_group_start;

-       for (i = 0; i < rs->md.raid_disks; i++)
-               if (!test_bit(In_sync, &rs->dev[i].rdev.flags) ||
-                   !rs->dev[i].rdev.sb_page)
+       for (i = 0; i < rs->raid_disks; i++)
+               if (!test_bit(FirstUse, &rs->dev[i].rdev.flags) &&
+                   ((!test_bit(In_sync, &rs->dev[i].rdev.flags) ||
+                     !rs->dev[i].rdev.sb_page)))
                        rebuild_cnt++;

        switch (rs->md.level) {
@@ -1046,8 +1047,9 @@ static int validate_raid_redundancy(struct raid_set
*rs)
                 *          A    A    B    B    C
                 *          C    D    D    E    E
                 */
+               raid_disks = min(rs->raid_disks, rs->md.raid_disks);
                if (__is_raid10_near(rs->md.new_layout)) {
-                       for (i = 0; i < rs->md.raid_disks; i++) {
+                       for (i = 0; i < raid_disks; i++) {
                                if (!(i % copies))
                                        rebuilds_per_group = 0;
                                if ((!rs->dev[i].rdev.sb_page ||
@@ -1070,10 +1072,10 @@ static int validate_raid_redundancy(struct raid_set
*rs)
                 * results in the need to treat the last (potentially
larger)
                 * set differently.
                 */
-               group_size = (rs->md.raid_disks / copies);
-               last_group_start = (rs->md.raid_disks / group_size) - 1;
+               group_size = (raid_disks / copies);
+               last_group_start = (raid_disks / group_size) - 1;
                last_group_start *= group_size;
-               for (i = 0; i < rs->md.raid_disks; i++) {
+               for (i = 0; i < raid_disks; i++) {
                        if (!(i % copies) && !(i > last_group_start))
                                rebuilds_per_group = 0;
                        if ((!rs->dev[i].rdev.sb_page ||
@@ -1588,7 +1590,7 @@ static sector_t __rdev_sectors(struct raid_set *rs)
 {
        int i;

-       for (i = 0; i < rs->md.raid_disks; i++) {
+       for (i = 0; i < rs->raid_disks; i++) {
                struct md_rdev *rdev = &rs->dev[i].rdev;

                if (!test_bit(Journal, &rdev->flags) &&
@@ -3771,7 +3773,7 @@ static int raid_iterate_devices(struct dm_target *ti,
        unsigned int i;
        int r = 0;

-       for (i = 0; !r && i < rs->md.raid_disks; i++)
+       for (i = 0; !r && i < rs->raid_disks; i++)
                if (rs->dev[i].data_dev)
                        r = fn(ti,
                                 rs->dev[i].data_dev,
-- 
2.36.1


On Mon, Jun 27, 2022 at 3:56 PM Mikulas Patocka <mpatocka@redhat.com> wrote:

> dm-raid allocates the array of devices with rs->raid_disks entries and
> then accesses it in a loop for rs->md.raid_disks. During reshaping,
> rs->md.raid_disks may be greater than rs->raid_disks, so it accesses
> entries beyond the end of the array.
>
> We fix this bug by limiting the iteration to rs->raid_disks.
>
> The bug is triggered when running lvm test shell/lvconvert-raid.sh and the
> kernel is compiled with kasan.
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
> --- linux-2.6.orig/drivers/md/dm-raid.c 2022-06-27 15:44:12.000000000 +0200
> +++ linux-2.6/drivers/md/dm-raid.c      2022-06-27 15:44:12.000000000 +0200
> @@ -1004,7 +1004,7 @@ static int validate_raid_redundancy(stru
>         unsigned int rebuilds_per_group = 0, copies;
>         unsigned int group_size, last_group_start;
>
> -       for (i = 0; i < rs->md.raid_disks; i++)
> +       for (i = 0; i < rs->raid_disks; i++)
>                 if (!test_bit(In_sync, &rs->dev[i].rdev.flags) ||
>                     !rs->dev[i].rdev.sb_page)
>                         rebuild_cnt++;
> @@ -1047,7 +1047,7 @@ static int validate_raid_redundancy(stru
>                  *          C    D    D    E    E
>                  */
>                 if (__is_raid10_near(rs->md.new_layout)) {
> -                       for (i = 0; i < rs->md.raid_disks; i++) {
> +                       for (i = 0; i < rs->raid_disks; i++) {
>                                 if (!(i % copies))
>                                         rebuilds_per_group = 0;
>                                 if ((!rs->dev[i].rdev.sb_page ||
> @@ -1073,7 +1073,7 @@ static int validate_raid_redundancy(stru
>                 group_size = (rs->md.raid_disks / copies);
>                 last_group_start = (rs->md.raid_disks / group_size) - 1;
>                 last_group_start *= group_size;
> -               for (i = 0; i < rs->md.raid_disks; i++) {
> +               for (i = 0; i < rs->raid_disks; i++) {
>                         if (!(i % copies) && !(i > last_group_start))
>                                 rebuilds_per_group = 0;
>                         if ((!rs->dev[i].rdev.sb_page ||
> @@ -1588,7 +1588,7 @@ static sector_t __rdev_sectors(struct ra
>  {
>         int i;
>
> -       for (i = 0; i < rs->md.raid_disks; i++) {
> +       for (i = 0; i < rs->raid_disks; i++) {
>                 struct md_rdev *rdev = &rs->dev[i].rdev;
>
>                 if (!test_bit(Journal, &rdev->flags) &&
> @@ -3766,7 +3766,7 @@ static int raid_iterate_devices(struct d
>         unsigned int i;
>         int r = 0;
>
> -       for (i = 0; !r && i < rs->md.raid_disks; i++)
> +       for (i = 0; !r && i < rs->raid_disks; i++)
>                 if (rs->dev[i].data_dev)
>                         r = fn(ti,
>                                  rs->dev[i].data_dev,
> @@ -3817,7 +3817,7 @@ static void attempt_restore_of_faulty_de
>
>         memset(cleared_failed_devices, 0, sizeof(cleared_failed_devices));
>
> -       for (i = 0; i < mddev->raid_disks; i++) {
> +       for (i = 0; i < rs->raid_disks; i++) {
>                 r = &rs->dev[i].rdev;
>                 /* HM FIXME: enhance journal device recovery processing */
>                 if (test_bit(Journal, &r->flags))
>
>

--000000000000de7aa805e2759093
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">From 852b91efc183e9b87ac50f15fb4df86f26f73532 Mon Sep 17 0=
0:00:00 2001<br>From: Heinz Mauelshagen &lt;<a href=3D"mailto:heinzm@redhat=
.com">heinzm@redhat.com</a>&gt;<br>Date: Mon, 27 Jun 2022 23:54:24 +0200<br=
>Subject: [PATCH] dm-raid: fix array out of bounds (OOB)<br><br>Supersedes =
&quot;[PATCH] dm-raid: fix out of memory accesses in dm-raid&quot;<br><br><=
br>On RAID mapping construction, dm-raid allocates an array rs-&gt;devs[rs-=
&gt;raid_disks]<br>for the raid device members. =C2=A0rs-&gt;raid_disks is =
defined by the number of raid<br>metadata and image tupples passed into the=
 target&#39;s constructor.<br><br>That number can be different from the cur=
rent number of members for existing raid<br>sets as defined in their superb=
locks in case of layout changes requested:<br><br>- raid1 legs being added/=
removed<br><br>- raid4/5/6/10 number of stripes changed (stripe reshaping)<=
br><br>- takeover to higher raid level (e.g. raid5 -&gt; raid6)<br><br>Acce=
ssing array members, rs-&gt;raid_disks has to be used in loops instead of<b=
r>potentially larger rs-&gt;md.raid_disks causing OOB access on the devices=
 array.<br><br>Patch changes instances prone to OOB.<br>Also ensures added =
devices are validated in validate_raid_redundancy().<br><br>Initially disco=
vered by KASAN.<br><br>Passes all LVM2 RAID tests (KASAN enabled).<br><br>S=
igned-off-by: Heinz Mauelshagen &lt;<a href=3D"mailto:heinzm@redhat.com">he=
inzm@redhat.com</a>&gt;<br>Tested-by: Heinz Mauelshagen &lt;<a href=3D"mail=
to:heinzm@redhat.com">heinzm@redhat.com</a>&gt;<br>---<br>=C2=A0drivers/md/=
dm-raid.c | 22 ++++++++++++----------<br>=C2=A01 file changed, 12 insertion=
s(+), 10 deletions(-)<br><br>diff --git a/drivers/md/dm-raid.c b/drivers/md=
/dm-raid.c<br>index 2b26435a6946..bcec0e1a049d 100644<br>--- a/drivers/md/d=
m-raid.c<br>+++ b/drivers/md/dm-raid.c<br>@@ -1001,12 +1001,13 @@ static in=
t validate_region_size(struct raid_set *rs, unsigned long region_size)<br>=
=C2=A0static int validate_raid_redundancy(struct raid_set *rs)<br>=C2=A0{<b=
r>=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int i, rebuild_cnt =3D 0;<br>- =C2=
=A0 =C2=A0 =C2=A0 unsigned int rebuilds_per_group =3D 0, copies;<br>+ =C2=
=A0 =C2=A0 =C2=A0 unsigned int rebuilds_per_group =3D 0, copies, raid_disks=
;<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int group_size, last_group_start;=
<br>=C2=A0<br>- =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i &lt; rs-&gt;md.raid_di=
sks; i++)<br>- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!test_b=
it(In_sync, &amp;rs-&gt;dev[i].rdev.flags) ||<br>- =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 !rs-&gt;dev[i].rdev.sb_page)<br>+ =
=C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i &lt; rs-&gt;raid_disks; i++)<br>+ =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!test_bit(FirstUse, &amp;=
rs-&gt;dev[i].rdev.flags) &amp;&amp;<br>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ((!test_bit(In_sync, &amp;rs-&gt;dev[i].rde=
v.flags) ||<br>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 !rs-&gt;dev[i].rdev.sb_page)))<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rebuild_cnt++;<br>=
=C2=A0<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 switch (rs-&gt;md.level) {<br>@@ -104=
6,8 +1047,9 @@ static int validate_raid_redundancy(struct raid_set *rs)<br>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0A =C2=A0 =C2=A0A =C2=A0 =C2=A0B =C2=A0 =C2=A0B =C2=
=A0 =C2=A0C<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0* =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0C =C2=A0 =C2=A0D =C2=A0 =C2=A0D =C2=
=A0 =C2=A0E =C2=A0 =C2=A0E<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0*/<br>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r=
aid_disks =3D min(rs-&gt;raid_disks, rs-&gt;md.raid_disks);<br>=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (__is_raid10_near(rs-&gt;m=
d.new_layout)) {<br>- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i &lt; rs-&gt;md.raid_disks; i++) {<=
br>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 for (i =3D 0; i &lt; raid_disks; i++) {<br>=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 if (!(i % copies))<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 rebuilds_per_group =3D 0;<br>=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 if ((!rs-&gt;dev[i].rdev.sb_page ||<br>@@ -1070,10 +10=
72,10 @@ static int validate_raid_redundancy(struct raid_set *rs)<br>=C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* results in the ne=
ed to treat the last (potentially larger)<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* set differently.<br>=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>- =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 group_size =3D (rs-&gt;md.raid_disks / copies);=
<br>- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 last_group_start =3D=
 (rs-&gt;md.raid_disks / group_size) - 1;<br>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 group_size =3D (raid_disks / copies);<br>+ =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 last_group_start =3D (raid_disks / g=
roup_size) - 1;<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
last_group_start *=3D group_size;<br>- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 for (i =3D 0; i &lt; rs-&gt;md.raid_disks; i++) {<br>+ =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i &lt; raid_disks;=
 i++) {<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 if (!(i % copies) &amp;&amp; !(i &gt; last_group_start=
))<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rebuilds_per_group =3D 0;<br>=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 if ((!rs-&gt;dev[i].rdev.sb_page ||<br>@@ -1588,7 +1590,7 @@ static =
sector_t __rdev_sectors(struct raid_set *rs)<br>=C2=A0{<br>=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 int i;<br>=C2=A0<br>- =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i &l=
t; rs-&gt;md.raid_disks; i++) {<br>+ =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i &=
lt; rs-&gt;raid_disks; i++) {<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 struct md_rdev *rdev =3D &amp;rs-&gt;dev[i].rdev;<br>=C2=A0<b=
r>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!test_bit(Jou=
rnal, &amp;rdev-&gt;flags) &amp;&amp;<br>@@ -3771,7 +3773,7 @@ static int r=
aid_iterate_devices(struct dm_target *ti,<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 un=
signed int i;<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r =3D 0;<br>=C2=A0<br>- =
=C2=A0 =C2=A0 =C2=A0 for (i =3D 0; !r &amp;&amp; i &lt; rs-&gt;md.raid_disk=
s; i++)<br>+ =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; !r &amp;&amp; i &lt; rs-&gt=
;raid_disks; i++)<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (rs-&gt;dev[i].data_dev)<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D fn(ti,<br>=C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rs-&gt;dev[i].data_dev,<br>-- <br>2.36.1<br>=
<div><br></div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=
=3D"gmail_attr">On Mon, Jun 27, 2022 at 3:56 PM Mikulas Patocka &lt;<a href=
=3D"mailto:mpatocka@redhat.com">mpatocka@redhat.com</a>&gt; wrote:<br></div=
><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border=
-left:1px solid rgb(204,204,204);padding-left:1ex">dm-raid allocates the ar=
ray of devices with rs-&gt;raid_disks entries and<br>
then accesses it in a loop for rs-&gt;md.raid_disks. During reshaping,<br>
rs-&gt;md.raid_disks may be greater than rs-&gt;raid_disks, so it accesses<=
br>
entries beyond the end of the array.<br>
<br>
We fix this bug by limiting the iteration to rs-&gt;raid_disks.<br>
<br>
The bug is triggered when running lvm test shell/lvconvert-raid.sh and the<=
br>
kernel is compiled with kasan.<br>
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
--- linux-2.6.orig/drivers/md/dm-raid.c 2022-06-27 15:44:12.000000000 +0200=
<br>
+++ linux-2.6/drivers/md/dm-raid.c=C2=A0 =C2=A0 =C2=A0 2022-06-27 15:44:12.=
000000000 +0200<br>
@@ -1004,7 +1004,7 @@ static int validate_raid_redundancy(stru<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int rebuilds_per_group =3D 0, copies;<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int group_size, last_group_start;<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; rs-&gt;md.raid_disks; i++)=
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; rs-&gt;raid_disks; i++)<br=
>
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
=A0 =C2=A0for (i =3D 0; i &lt; rs-&gt;raid_disks; i++) {<br>
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
; rs-&gt;raid_disks; i++) {<br>
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
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; rs-&gt;raid_disks; i++) {<=
br>
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
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; !r &amp;&amp; i &lt; rs-&gt;raid_=
disks; i++)<br>
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
+=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; rs-&gt;raid_disks; i++) {<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D &amp;rs-&gt;d=
ev[i].rdev;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* HM FIXME: enhanc=
e journal device recovery processing */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (test_bit(Journa=
l, &amp;r-&gt;flags))<br>
<br>
</blockquote></div>

--000000000000de7aa805e2759093--

--===============4482733968574758919==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============4482733968574758919==--

