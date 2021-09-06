Return-Path: <SRS0=WplP=N4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C37C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  6 Sep 2021 12:43:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BC4AD60F43
	for <dm-devel@archiver.kernel.org>; Mon,  6 Sep 2021 12:43:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BC4AD60F43
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1630932216;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=PJGzLOaB5N7LYyJBYOIq7/PhjPGPN4xhYkxS5aK1ijw=;
	b=bSEkulMD10hPlnS35XW/svxer7XYJ6/hOz8zDRk32LrZ9q5yUAScRNEnT5Nb+nzw6Avj+3
	qjkfuVY5nhpizAX+DwF9fGX6uEZuimx4RfK68V9fV2YRJwHv+Zb9ahuaShEyQiUwaucMfA
	XFbg72rBsxoRBGU+CdZz52w/d8j+Xe0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-3d-QqwqXPqGJBiioYmrUhw-1; Mon, 06 Sep 2021 08:43:35 -0400
X-MC-Unique: 3d-QqwqXPqGJBiioYmrUhw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CAA5835DE0;
	Mon,  6 Sep 2021 12:43:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 270F65D740;
	Mon,  6 Sep 2021 12:43:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F3F534ED41;
	Mon,  6 Sep 2021 12:43:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 186ChLDZ025496 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 6 Sep 2021 08:43:22 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CA82721572BA; Mon,  6 Sep 2021 12:43:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C46F421572B9
	for <dm-devel@redhat.com>; Mon,  6 Sep 2021 12:43:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88DB3811E76
	for <dm-devel@redhat.com>; Mon,  6 Sep 2021 12:43:18 +0000 (UTC)
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
	[209.85.219.199]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-555-DiH2GvbAPg-s9oiukcmtkQ-1; Mon, 06 Sep 2021 08:43:14 -0400
X-MC-Unique: DiH2GvbAPg-s9oiukcmtkQ-1
Received: by mail-yb1-f199.google.com with SMTP id
	131-20020a251489000000b0059bdeb10a84so8198716ybu.15
	for <dm-devel@redhat.com>; Mon, 06 Sep 2021 05:43:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=0/egFrJvM0w02uMyhj600S7gq33hbuSsN8YYzoCc8uY=;
	b=TfX2/QPAi37ZntqaITXsKRzCqNL89fJM8uO3E9Eq1DqanuxwTybsP0aqYBHmdczBTG
	YPFUzOWPot1sYobyRMfdRbyFVZI99hHMKg2N7ll3Hv/lGZN3eLAO16nMw8ASADf9CfH9
	BCFx+8xUCdpx7BNQd9SzNy6yyZdnoBjYbxjx5t3OQdXD222Z9asz+Ri+vf0jhgrDg2KL
	cQlWRVo8T6AIH4luamr9vyIOigFYJkL+U2wDA6Ry9uqbdopRkeOWvbkUH9n+KAGp5p89
	hTIAm/H9XRTzDyBQsl9uRd5jEudZ0pRLgNlQMMpxUuD56El+VNPtZzM4TzvLSOYi35tN
	qWng==
X-Gm-Message-State: AOAM533lNofjkpfhduDNC58pJg7/gV8bLWdho4eYIdDiyWSfFw5Lz+Gg
	NzWAcRrz5dnS6FCCaiOAZnwsw6+HWQGjhuIVsbLFcfUyo+xLQhifXRW/N4Xi1AdYzdlvedDUuoM
	X6niIbxbao0mc/0X7rsO8TiV7gHqM+Cc=
X-Received: by 2002:a25:a527:: with SMTP id h36mr16287903ybi.326.1630932194214;
	Mon, 06 Sep 2021 05:43:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyYCHLOmQuqONSpc9xdIBhbfPSbwXBuX4Ly0X9+20p3RqUyxR6OyIj5g7NaRPWmK0N3njIW6+jIqjp/Hi4nPoo=
X-Received: by 2002:a25:a527:: with SMTP id h36mr16287884ybi.326.1630932194019;
	Mon, 06 Sep 2021 05:43:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210906041616.22812-1-dinghao.liu@zju.edu.cn>
In-Reply-To: <20210906041616.22812-1-dinghao.liu@zju.edu.cn>
From: Heinz Mauelshagen <heinzm@redhat.com>
Date: Mon, 6 Sep 2021 14:43:03 +0200
Message-ID: <CAM23Vxp8O5bdvSqYZBqQyqzuMJd1z2+-=mF9-QyKtoO1tR8qJg@mail.gmail.com>
To: Dinghao Liu <dinghao.liu@zju.edu.cn>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, kjlu@umn.edu, Mike Snitzer <snitzer@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] [v2] dm raid: fix mddev unlocking in
	raid_ctr() error paths
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============5397900947585332728=="

--===============5397900947585332728==
Content-Type: multipart/alternative; boundary="00000000000013e3e205cb52fe51"

--00000000000013e3e205cb52fe51
Content-Type: text/plain; charset="UTF-8"

Thanks for the updated patch, acked.

-- lvmguy

On Mon, Sep 6, 2021 at 6:17 AM Dinghao Liu <dinghao.liu@zju.edu.cn> wrote:

> mddev_unlock() is called on all paths after we call mddev_lock_nointr(),
> except for three error handling paths, which may cause a deadlock.
>
> Fixes: 9dbd1aa3a81c ("dm raid: add reshaping support to the target")
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
> ---
>
> Changelog:
>
> v2: - Simplify the error handling paths.
> ---
>  drivers/md/dm-raid.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index d9ef52159a22..741bab00e922 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -3249,14 +3249,12 @@ static int raid_ctr(struct dm_target *ti, unsigned
> int argc, char **argv)
>         rs->md.in_sync = 0; /* Assume already marked dirty */
>         if (r) {
>                 ti->error = "Failed to run raid array";
> -               mddev_unlock(&rs->md);
> -               goto bad;
> +               goto bad_unlock;
>         }
>
>         r = md_start(&rs->md);
>         if (r) {
>                 ti->error = "Failed to start raid array";
> -               mddev_unlock(&rs->md);
>                 goto bad_md_start;
>         }
>
> @@ -3265,7 +3263,6 @@ static int raid_ctr(struct dm_target *ti, unsigned
> int argc, char **argv)
>                 r = r5c_journal_mode_set(&rs->md, rs->journal_dev.mode);
>                 if (r) {
>                         ti->error = "Failed to set raid4/5/6 journal mode";
> -                       mddev_unlock(&rs->md);
>                         goto bad_journal_mode_set;
>                 }
>         }
> @@ -3304,10 +3301,12 @@ static int raid_ctr(struct dm_target *ti, unsigned
> int argc, char **argv)
>         mddev_unlock(&rs->md);
>         return 0;
>
> +bad_unlock:
>  bad_md_start:
>  bad_journal_mode_set:
>  bad_stripe_cache:
>  bad_check_reshape:
> +       mddev_unlock(&rs->md);
>         md_stop(&rs->md);
>  bad:
>         raid_set_free(rs);
> --
> 2.17.1
>
>

--00000000000013e3e205cb52fe51
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks=C2=A0for the updated patch, acked.<div><br></div><d=
iv>-- lvmguy</div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" cla=
ss=3D"gmail_attr">On Mon, Sep 6, 2021 at 6:17 AM Dinghao Liu &lt;<a href=3D=
"mailto:dinghao.liu@zju.edu.cn">dinghao.liu@zju.edu.cn</a>&gt; wrote:<br></=
div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bor=
der-left:1px solid rgb(204,204,204);padding-left:1ex">mddev_unlock() is cal=
led on all paths after we call mddev_lock_nointr(),<br>
except for three error handling paths, which may cause a deadlock.<br>
<br>
Fixes: 9dbd1aa3a81c (&quot;dm raid: add reshaping support to the target&quo=
t;)<br>
Signed-off-by: Dinghao Liu &lt;<a href=3D"mailto:dinghao.liu@zju.edu.cn" ta=
rget=3D"_blank">dinghao.liu@zju.edu.cn</a>&gt;<br>
Signed-off-by: Heinz Mauelshagen &lt;<a href=3D"mailto:heinzm@redhat.com" t=
arget=3D"_blank">heinzm@redhat.com</a>&gt;<br>
---<br>
<br>
Changelog:<br>
<br>
v2: - Simplify the error handling paths.<br>
---<br>
=C2=A0drivers/md/dm-raid.c | 7 +++----<br>
=C2=A01 file changed, 3 insertions(+), 4 deletions(-)<br>
<br>
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c<br>
index d9ef52159a22..741bab00e922 100644<br>
--- a/drivers/md/dm-raid.c<br>
+++ b/drivers/md/dm-raid.c<br>
@@ -3249,14 +3249,12 @@ static int raid_ctr(struct dm_target *ti, unsigned =
int argc, char **argv)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 rs-&gt;md.in_sync =3D 0; /* Assume already mark=
ed dirty */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (r) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ti-&gt;error =3D &q=
uot;Failed to run raid array&quot;;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mddev_unlock(&amp;r=
s-&gt;md);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto bad;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto bad_unlock;<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D md_start(&amp;rs-&gt;md);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (r) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ti-&gt;error =3D &q=
uot;Failed to start raid array&quot;;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mddev_unlock(&amp;r=
s-&gt;md);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto bad_md_start;<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
@@ -3265,7 +3263,6 @@ static int raid_ctr(struct dm_target *ti, unsigned in=
t argc, char **argv)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D r5c_journal_m=
ode_set(&amp;rs-&gt;md, rs-&gt;journal_dev.mode);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (r) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ti-&gt;error =3D &quot;Failed to set raid4/5/6 journal mode&quot=
;;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0mddev_unlock(&amp;rs-&gt;md);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto bad_journal_mode_set;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
@@ -3304,10 +3301,12 @@ static int raid_ctr(struct dm_target *ti, unsigned =
int argc, char **argv)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mddev_unlock(&amp;rs-&gt;md);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
<br>
+bad_unlock:<br>
=C2=A0bad_md_start:<br>
=C2=A0bad_journal_mode_set:<br>
=C2=A0bad_stripe_cache:<br>
=C2=A0bad_check_reshape:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mddev_unlock(&amp;rs-&gt;md);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 md_stop(&amp;rs-&gt;md);<br>
=C2=A0bad:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 raid_set_free(rs);<br>
-- <br>
2.17.1<br>
<br>
</blockquote></div>

--00000000000013e3e205cb52fe51--

--===============5397900947585332728==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============5397900947585332728==--

