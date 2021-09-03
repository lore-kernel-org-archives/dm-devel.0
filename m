Return-Path: <SRS0=d4ru=NZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C9FC433F5
	for <dm-devel@archiver.kernel.org>; Fri,  3 Sep 2021 13:33:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E4A7461056
	for <dm-devel@archiver.kernel.org>; Fri,  3 Sep 2021 13:33:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E4A7461056
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1630676009;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=RvkMXB4lwBlpRMCwA0IJ6rn7zcKX8PN0AXFFdHGjRIw=;
	b=XzQLUD+1GQ3Gns19RGrkyaGWPncMpBuD2qFI/Eicb/oyN5ZptJn3FtS0sZTRuCIbbSFcy1
	03n1/JOiG48zFf21Q8Ij9CbgrwiGGjRzbypahqOa0AsSjtpVU/Zr7BpEDAbBuFv/vglOZw
	2QUa+5ElxCg1pHYc0ovOrYJkA2i/f8g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-Qcs_1EJXP--YB3zHTVUSJg-1; Fri, 03 Sep 2021 09:33:26 -0400
X-MC-Unique: Qcs_1EJXP--YB3zHTVUSJg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF6AE84A5EB;
	Fri,  3 Sep 2021 13:33:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C46B100238C;
	Fri,  3 Sep 2021 13:33:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C92CF4EEA2;
	Fri,  3 Sep 2021 13:33:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 183DV2GS024778 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 3 Sep 2021 09:31:02 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7A77020C1643; Fri,  3 Sep 2021 13:31:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 751D420C1642
	for <dm-devel@redhat.com>; Fri,  3 Sep 2021 13:30:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE53E800963
	for <dm-devel@redhat.com>; Fri,  3 Sep 2021 13:30:58 +0000 (UTC)
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
	[209.85.219.197]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-144--ANSAxarO0uSaetE5gZkLw-1; Fri, 03 Sep 2021 09:30:55 -0400
X-MC-Unique: -ANSAxarO0uSaetE5gZkLw-1
Received: by mail-yb1-f197.google.com with SMTP id
	f64-20020a2538430000b0290593bfc4b046so6456293yba.9
	for <dm-devel@redhat.com>; Fri, 03 Sep 2021 06:30:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=kh2E7hGqy1qEjDjv1B2utugb3/KaMXhJ/P7wHBAB3/M=;
	b=KdH84c7/3BY2CCF+WYLrrlO0T6zeDu2Ud6mWu4BOHEK9hxl2nzi5/P2A/FjYsS+uZk
	m6xzdErtGkZgmuCUaaWzBp7vLxzqTIirHOFn1vAAoDum+H3uwwm4CwJ7JfxBOHQHpeGw
	bciuh5kuUyyMOLfShGqytBQC8pOErjgPCWt7TV63u2BGn3Hr++BY1seMGOaU175YtPs3
	RBCw+3oye5L71i4zZXYeQ12cjaPnrPm/Qo0Bc+UlfRi2gVZjUHFzjkeLp2+7c/QbOFa1
	bgbVjlTcH+RObiFCP0PPBmSgv1aYIer1d7iMu5c8c9Dt1k2npi4GhWWRrB6cwjS3QPzl
	Zh0Q==
X-Gm-Message-State: AOAM531Gym0ePMzw22L+ncVmPdt6Vu/OAdBA3D76KcEn4yzAGR9ZA9R1
	vqYaxRC3oD47Qea1hdiUSNfs3Jal+jlu/upUxZ2odHShQbQiddoiYCGh9a6akZQAqxsLOMO/hNU
	r6vdacmgoLCgKIzQl+p7kDDK2PIdByVg=
X-Received: by 2002:a25:4708:: with SMTP id u8mr1002098yba.536.1630675854801; 
	Fri, 03 Sep 2021 06:30:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwECu/b56GeBrwr5FhgLoE/c73pFoGxEi0bWD1/CxlfQ+tE+AFBfAH+V9Hy3jcU4jGgY9xeJDLmbMANDFTgL04=
X-Received: by 2002:a25:4708:: with SMTP id u8mr1002082yba.536.1630675854615; 
	Fri, 03 Sep 2021 06:30:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210903075531.20310-1-dinghao.liu@zju.edu.cn>
In-Reply-To: <20210903075531.20310-1-dinghao.liu@zju.edu.cn>
From: Heinz Mauelshagen <heinzm@redhat.com>
Date: Fri, 3 Sep 2021 15:30:43 +0200
Message-ID: <CAM23VxrzCk4XxbsG3dwqCq2PAnxNiEXoFXyp=t4t41o32THYrA@mail.gmail.com>
To: Dinghao Liu <dinghao.liu@zju.edu.cn>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, kjlu@umn.edu, Mike Snitzer <snitzer@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] dm raid: add missed unlock in raid_ctr
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============2692351388341830332=="

--===============2692351388341830332==
Content-Type: multipart/alternative; boundary="0000000000000efca305cb174fde"

--0000000000000efca305cb174fde
Content-Type: text/plain; charset="UTF-8"

On Fri, Sep 3, 2021 at 10:02 AM Dinghao Liu <dinghao.liu@zju.edu.cn> wrote:

> mddev_unlock() is called on all paths after we call mddev_lock_nointr(),
> except for three error handling paths, which may cause a deadlock. This
> bug is suggested by a static analysis tool, please advise.
>

Hi,

correct, those unlock calls are missing.

As we are bailing out after md_run() with lock held,
we can clean the lot of error paths underneath up by jumping to before
md_stop() and add the mddev_unlock upfront it like:

>From 5c72f1d07195127f5fd49bccbe0705854463c199 Mon Sep 17 00:00:00 2001
Message-Id: <
5c72f1d07195127f5fd49bccbe0705854463c199.1630675612.git.heinzm@redhat.com>
From: Heinz Mauelshagen <heinzm@redhat.com>
Date: Fri, 3 Sep 2021 15:26:50 +0200
Subject: [PATCH] dm raid: fix mddev unlocking in raid_ctr() error paths

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index d9ef52159a22..741bab00e922 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3249,14 +3249,12 @@ static int raid_ctr(struct dm_target *ti, unsigned
int argc, char **argv)
        rs->md.in_sync = 0; /* Assume already marked dirty */
        if (r) {
                ti->error = "Failed to run raid array";
-               mddev_unlock(&rs->md);
-               goto bad;
+               goto bad_unlock;
        }

        r = md_start(&rs->md);
        if (r) {
                ti->error = "Failed to start raid array";
-               mddev_unlock(&rs->md);
                goto bad_md_start;
        }

@@ -3265,7 +3263,6 @@ static int raid_ctr(struct dm_target *ti, unsigned
int argc, char **argv)
                r = r5c_journal_mode_set(&rs->md, rs->journal_dev.mode);
                if (r) {
                        ti->error = "Failed to set raid4/5/6 journal mode";
-                       mddev_unlock(&rs->md);
                        goto bad_journal_mode_set;
                }
        }
@@ -3304,10 +3301,12 @@ static int raid_ctr(struct dm_target *ti, unsigned
int argc, char **argv)
        mddev_unlock(&rs->md);
        return 0;

+bad_unlock:
 bad_md_start:
 bad_journal_mode_set:
 bad_stripe_cache:
 bad_check_reshape:
+       mddev_unlock(&rs->md);
        md_stop(&rs->md);
 bad:
        raid_set_free(rs);
-- 
2.31.1


-- lvmguy


>
> Fixes: 9dbd1aa3a81c ("dm raid: add reshaping support to the target")
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> ---
>  drivers/md/dm-raid.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index d9ef52159a22..79f36a806082 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -3276,15 +3276,19 @@ static int raid_ctr(struct dm_target *ti, unsigned
> int argc, char **argv)
>         /* Try to adjust the raid4/5/6 stripe cache size to the stripe
> size */
>         if (rs_is_raid456(rs)) {
>                 r = rs_set_raid456_stripe_cache(rs);
> -               if (r)
> +               if (r) {
> +                       mddev_unlock(&rs->md);
>                         goto bad_stripe_cache;
> +               }
>         }
>
>         /* Now do an early reshape check */
>         if (test_bit(RT_FLAG_RESHAPE_RS, &rs->runtime_flags)) {
>                 r = rs_check_reshape(rs);
> -               if (r)
> +               if (r) {
> +                       mddev_unlock(&rs->md);
>                         goto bad_check_reshape;
> +               }
>
>                 /* Restore new, ctr requested layout to perform check */
>                 rs_config_restore(rs, &rs_layout);
> @@ -3293,6 +3297,7 @@ static int raid_ctr(struct dm_target *ti, unsigned
> int argc, char **argv)
>                         r = rs->md.pers->check_reshape(&rs->md);
>                         if (r) {
>                                 ti->error = "Reshape check failed";
> +                               mddev_unlock(&rs->md);
>                                 goto bad_check_reshape;
>                         }
>                 }
> --
> 2.17.1
>
>

--0000000000000efca305cb174fde
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">On Fri, Sep 3, 2021 at 10:02 AM Dinghao L=
iu &lt;<a href=3D"mailto:dinghao.liu@zju.edu.cn">dinghao.liu@zju.edu.cn</a>=
&gt; wrote:<br></div><div class=3D"gmail_quote"><blockquote class=3D"gmail_=
quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,=
204);padding-left:1ex">mddev_unlock() is called on all paths after we call =
mddev_lock_nointr(),<br>
except for three error handling paths, which may cause a deadlock. This<br>
bug is suggested by a static analysis tool, please advise.<br></blockquote>=
<div><br></div><div>Hi,</div><div><br></div><div>correct, those unlock call=
s are missing.</div><div><br></div><div>As we are bailing out after md_run(=
) with lock held,=C2=A0</div><div>we can clean=C2=A0the lot of error paths =
underneath up by jumping to before<br>md_stop() and add the mddev_unlock up=
front it like:</div><div><br></div><div>From 5c72f1d07195127f5fd49bccbe0705=
854463c199 Mon Sep 17 00:00:00 2001<br>Message-Id: &lt;<a href=3D"mailto:5c=
72f1d07195127f5fd49bccbe0705854463c199.1630675612.git.heinzm@redhat.com">5c=
72f1d07195127f5fd49bccbe0705854463c199.1630675612.git.heinzm@redhat.com</a>=
&gt;<br>From: Heinz Mauelshagen &lt;<a href=3D"mailto:heinzm@redhat.com">he=
inzm@redhat.com</a>&gt;<br>Date: Fri, 3 Sep 2021 15:26:50 +0200<br>Subject:=
 [PATCH] dm raid: fix mddev unlocking in raid_ctr() error paths<br><br>Sign=
ed-off-by: Heinz Mauelshagen &lt;<a href=3D"mailto:heinzm@redhat.com">heinz=
m@redhat.com</a>&gt;<br>---<br>=C2=A0drivers/md/dm-raid.c | 7 +++----<br>=
=C2=A01 file changed, 3 insertions(+), 4 deletions(-)<br><br>diff --git a/d=
rivers/md/dm-raid.c b/drivers/md/dm-raid.c<br>index d9ef52159a22..741bab00e=
922 100644<br>--- a/drivers/md/dm-raid.c<br>+++ b/drivers/md/dm-raid.c<br>@=
@ -3249,14 +3249,12 @@ static int raid_ctr(struct dm_target *ti, unsigned i=
nt argc, char **argv)<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 rs-&gt;md.in_sync =3D =
0; /* Assume already marked dirty */<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (r) =
{<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ti-&gt;error =
=3D &quot;Failed to run raid array&quot;;<br>- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 mddev_unlock(&amp;rs-&gt;md);<br>- =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto bad;<br>+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 goto bad_unlock;<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 } =C2=
=A0 <br>=C2=A0<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D md_start(&amp;rs-&gt;md=
);<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (r) {<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ti-&gt;error =3D &quot;Failed to start raid arr=
ay&quot;;<br>- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mddev_unloc=
k(&amp;rs-&gt;md);<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 goto bad_md_start;<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 } =C2=A0 <br>=C2=A0<b=
r>@@ -3265,7 +3263,6 @@ static int raid_ctr(struct dm_target *ti, unsigned =
int argc, char **argv)<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 r =3D r5c_journal_mode_set(&amp;rs-&gt;md, rs-&gt;journal_dev.mode);=
<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (r) {<br>=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 ti-&gt;error =3D &quot;Failed to set raid4/5/6 journal mode&quot;;<b=
r>- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 mddev_unlock(&amp;rs-&gt;md);<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto bad_journal_mode_set;=
<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } =C2=A0 <br>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 } =C2=A0 <br>@@ -3304,10 +3301,12 @@ static int=
 raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)<br>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 mddev_unlock(&amp;rs-&gt;md);<br>=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 return 0;<br>=C2=A0<br>+bad_unlock:<br>=C2=A0bad_md_start:<br>=C2=A0=
bad_journal_mode_set:<br>=C2=A0bad_stripe_cache:<br>=C2=A0bad_check_reshape=
:<br>+ =C2=A0 =C2=A0 =C2=A0 mddev_unlock(&amp;rs-&gt;md);<br>=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 md_stop(&amp;rs-&gt;md);<br>=C2=A0bad:<br>=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 raid_set_free(rs);<br>-- <br>2.31.1<br><br></div><div><br></div>=
<div>-- lvmguy</div><div>=C2=A0</div><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);paddin=
g-left:1ex">
<br>
Fixes: 9dbd1aa3a81c (&quot;dm raid: add reshaping support to the target&quo=
t;)<br>
Signed-off-by: Dinghao Liu &lt;<a href=3D"mailto:dinghao.liu@zju.edu.cn" ta=
rget=3D"_blank">dinghao.liu@zju.edu.cn</a>&gt;<br>
---<br>
=C2=A0drivers/md/dm-raid.c | 9 +++++++--<br>
=C2=A01 file changed, 7 insertions(+), 2 deletions(-)<br>
<br>
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c<br>
index d9ef52159a22..79f36a806082 100644<br>
--- a/drivers/md/dm-raid.c<br>
+++ b/drivers/md/dm-raid.c<br>
@@ -3276,15 +3276,19 @@ static int raid_ctr(struct dm_target *ti, unsigned =
int argc, char **argv)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Try to adjust the raid4/5/6 stripe cache siz=
e to the stripe size */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rs_is_raid456(rs)) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D rs_set_raid45=
6_stripe_cache(rs);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (r)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (r) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0mddev_unlock(&amp;rs-&gt;md);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto bad_stripe_cache;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Now do an early reshape check */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (test_bit(RT_FLAG_RESHAPE_RS, &amp;rs-&gt;ru=
ntime_flags)) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D rs_check_resh=
ape(rs);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (r)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (r) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0mddev_unlock(&amp;rs-&gt;md);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto bad_check_reshape;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Restore new, ctr=
 requested layout to perform check */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rs_config_restore(r=
s, &amp;rs_layout);<br>
@@ -3293,6 +3297,7 @@ static int raid_ctr(struct dm_target *ti, unsigned in=
t argc, char **argv)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 r =3D rs-&gt;md.pers-&gt;check_reshape(&amp;rs-&gt;md);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (r) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ti-&gt;error =3D &quot;Reshape check=
 failed&quot;;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mddev_unlock(&amp;rs-&gt;md);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto bad_check_reshape;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
-- <br>
2.17.1<br>
<br>
</blockquote></div></div>

--0000000000000efca305cb174fde--

--===============2692351388341830332==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============2692351388341830332==--

