Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36D95C636CC
	for <dm-devel@archiver.kernel.org>; Tue,  7 Feb 2023 15:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675782242;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=1Fqp/btISvGOwdYGAwmdLyh2oKsQrcYRWmjVeMwffMg=;
	b=Zypuwq9Pm0I0pU8N/yd4NRz7DoMoDm/PIve5b9lkFoyrocVpxahRUWnzEwwoNRCmLdKCYa
	15uTWMVi/aB6Kpu12mESlVL1JwExsCWzOrGCozwA+72UQlxD+q8xuG1eWJXfNeBj+UCx1D
	gz4i0cUAew7QKlDpEg+MyKau0JyilPU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-BeLczd2nNaCMc6gAqohWUA-1; Tue, 07 Feb 2023 10:03:45 -0500
X-MC-Unique: BeLczd2nNaCMc6gAqohWUA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B18629AB3EC;
	Tue,  7 Feb 2023 15:03:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F0640112131B;
	Tue,  7 Feb 2023 15:03:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AD8EC194658D;
	Tue,  7 Feb 2023 15:03:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D796D19465A3
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Feb 2023 15:03:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 83AE2492B22; Tue,  7 Feb 2023 15:03:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B27C492B21
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 15:03:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E9633804505
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 15:03:32 +0000 (UTC)
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-358-UI6fZuDXPoiKV7FLB0lTfw-1; Tue, 07 Feb 2023 10:03:30 -0500
X-MC-Unique: UI6fZuDXPoiKV7FLB0lTfw-1
Received: by mail-yb1-f200.google.com with SMTP id
 o131-20020a25d789000000b00859dddecf8eso14749219ybg.17
 for <dm-devel@redhat.com>; Tue, 07 Feb 2023 07:03:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=QDKEcd1YYgGQz5LuaoQZ3t/DFCUAHpMTHeUkko/yUVY=;
 b=ZS2Lky8SXHyPJXSb1o4J34JNMrY4kQSbaIRsj+LJGKtVRl5Q90DhJLmWhvGwIUsNLF
 gVvNWsjnRvY7zR3pOFwy3f3ydM5cpgoG7QVhkelgIZYaa1UEaTiMZm7bBI/moMXekucH
 Mv5bF4XdDApp074/8andedcgOLGGMD5k+SMs+4sW7xtosjlPBQl/ywec+P+FTgIDTfcU
 kdgZt+14n76G03ba5o8M/PQlz3SXN1pkgVdZzb8E+uL+xfwzuVp1ltsMmXpzxL+zfrIC
 CXYEfWZ+jopAOH0Y/f4zdLBrqLjTM+gVDex8SO0ui7VQvWUQ4sX7manPYrDYZ+2MYsL0
 CeMg==
X-Gm-Message-State: AO0yUKXv2Eeeh92w3xv1GUekpr6GUWA/bgBNNI/UZ1F4Jlfowj4HCi85
 J9LHcC349T3Uloj0cijZG4UtA+TrJID95R5DpTSBoJsG6grsCJ1Rs7dMhfw4kE7+L5+X7fY7wcu
 0JDvTz4KtSwy3D/uJyK2YA+H0hqcg4PM=
X-Received: by 2002:a81:4e0f:0:b0:526:44ea:af6c with SMTP id
 c15-20020a814e0f000000b0052644eaaf6cmr362045ywb.241.1675782183048; 
 Tue, 07 Feb 2023 07:03:03 -0800 (PST)
X-Google-Smtp-Source: AK7set/mzrLI9uOURI11lXt18z6ok+O4spHfRhTEChNYX973ZMQV2I2p5UN0Fx0UWBIMF6LS7fwJRRa8JwL4/ZLKT/A=
X-Received: by 2002:a81:4e0f:0:b0:526:44ea:af6c with SMTP id
 c15-20020a814e0f000000b0052644eaaf6cmr362035ywb.241.1675782182559; Tue, 07
 Feb 2023 07:03:02 -0800 (PST)
MIME-Version: 1.0
References: <20230207011849.1343-1-demi@invisiblethingslab.com>
In-Reply-To: <20230207011849.1343-1-demi@invisiblethingslab.com>
From: Joe Thornber <thornber@redhat.com>
Date: Tue, 7 Feb 2023 15:02:51 +0000
Message-ID: <CAJ0trDZsTcD43s3GQ7aKR_3eABWv0rREMrajw8xBQiu96X+B8w@mail.gmail.com>
To: Demi Marie Obenour <demi@invisiblethingslab.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 1/2] Fail I/O to thin pool devices
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 =?UTF-8?Q?Marek_Marczykowski=2DG=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, Alasdair Kergon <agk@redhat.com>,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============8558341122848341735=="

--===============8558341122848341735==
Content-Type: multipart/alternative; boundary="000000000000b6759305f41d7178"

--000000000000b6759305f41d7178
Content-Type: text/plain; charset="UTF-8"

Nack.

I don't see the security issue; how is this any different from running the
thin tools on any incorrect device?  Or even the data device that the pool
is mirroring.  In general the thin tools don't modify the metadata they're
running on.  If you know of a security issue with the thin tools please let
me know.


On Tue, Feb 7, 2023 at 7:56 AM Demi Marie Obenour <
demi@invisiblethingslab.com> wrote:

> A thin pool device currently just passes all I/O to its origin device,
> but this is a footgun: the user might not realize that tools that
> operate on thin pool metadata must operate on the metadata volume.  This
> could have security implications.
>
> Fix this by failing all I/O to thin pool devices.
>
> Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
> ---
>  drivers/md/dm-thin.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index
> 64cfcf46881dc5d87d5dfdb5650ba9babd32cd31..d85fdbd782ae5426003c99a4b4bf53818cc85efa
> 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -3405,19 +3405,14 @@ static int pool_ctr(struct dm_target *ti, unsigned
> argc, char **argv)
>
>  static int pool_map(struct dm_target *ti, struct bio *bio)
>  {
> -       int r;
> -       struct pool_c *pt = ti->private;
> -       struct pool *pool = pt->pool;
> -
>         /*
> -        * As this is a singleton target, ti->begin is always zero.
> +        * Previously, access to the pool was passed down to the origin
> device.
> +        * However, this turns out to be error-prone: if the user runs any
> of
> +        * the thin tools on the pool device, the tools could wind up
> parsing
> +        * potentially attacker-controlled data.  This mistake has actually
> +        * happened in practice.  Therefore, fail all I/O on the pool
> device.
>          */
> -       spin_lock_irq(&pool->lock);
> -       bio_set_dev(bio, pt->data_dev->bdev);
> -       r = DM_MAPIO_REMAPPED;
> -       spin_unlock_irq(&pool->lock);
> -
> -       return r;
> +       return -EIO;
>  }
>
>  static int maybe_resize_data_dev(struct dm_target *ti, bool *need_commit)
> --
> Sincerely,
> Demi Marie Obenour (she/her/hers)
> Invisible Things Lab
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
>
>

--000000000000b6759305f41d7178
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Nack.<div><br></div><div>I don&#39;t see the security issu=
e; how is this any different from running the thin tools on any incorrect d=
evice?=C2=A0 Or even the data device that the pool is mirroring.=C2=A0 In g=
eneral the thin tools don&#39;t modify the metadata they&#39;re running on.=
=C2=A0 If you know of a security issue with the thin tools please let me kn=
ow.</div><div><br></div></div><br><div class=3D"gmail_quote"><div dir=3D"lt=
r" class=3D"gmail_attr">On Tue, Feb 7, 2023 at 7:56 AM Demi Marie Obenour &=
lt;<a href=3D"mailto:demi@invisiblethingslab.com">demi@invisiblethingslab.c=
om</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margi=
n:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex=
">A thin pool device currently just passes all I/O to its origin device,<br=
>
but this is a footgun: the user might not realize that tools that<br>
operate on thin pool metadata must operate on the metadata volume.=C2=A0 Th=
is<br>
could have security implications.<br>
<br>
Fix this by failing all I/O to thin pool devices.<br>
<br>
Signed-off-by: Demi Marie Obenour &lt;<a href=3D"mailto:demi@invisiblething=
slab.com" target=3D"_blank">demi@invisiblethingslab.com</a>&gt;<br>
---<br>
=C2=A0drivers/md/dm-thin.c | 17 ++++++-----------<br>
=C2=A01 file changed, 6 insertions(+), 11 deletions(-)<br>
<br>
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c<br>
index 64cfcf46881dc5d87d5dfdb5650ba9babd32cd31..d85fdbd782ae5426003c99a4b4b=
f53818cc85efa 100644<br>
--- a/drivers/md/dm-thin.c<br>
+++ b/drivers/md/dm-thin.c<br>
@@ -3405,19 +3405,14 @@ static int pool_ctr(struct dm_target *ti, unsigned =
argc, char **argv)<br>
<br>
=C2=A0static int pool_map(struct dm_target *ti, struct bio *bio)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0int r;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct pool_c *pt =3D ti-&gt;private;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0struct pool *pool =3D pt-&gt;pool;<br>
-<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 * As this is a singleton target, ti-&gt;begin =
is always zero.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * Previously, access to the pool was passed do=
wn to the origin device.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * However, this turns out to be error-prone: i=
f the user runs any of<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * the thin tools on the pool device, the tools=
 could wind up parsing<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * potentially attacker-controlled data.=C2=A0 =
This mistake has actually<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 * happened in practice.=C2=A0 Therefore, fail =
all I/O on the pool device.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_irq(&amp;pool-&gt;lock);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0bio_set_dev(bio, pt-&gt;data_dev-&gt;bdev);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D DM_MAPIO_REMAPPED;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock_irq(&amp;pool-&gt;lock);<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0return r;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return -EIO;<br>
=C2=A0}<br>
<br>
=C2=A0static int maybe_resize_data_dev(struct dm_target *ti, bool *need_com=
mit)<br>
-- <br>
Sincerely,<br>
Demi Marie Obenour (she/her/hers)<br>
Invisible Things Lab<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://listman.redhat.com/mailman/listinfo/dm-devel" rel=3D"nor=
eferrer" target=3D"_blank">https://listman.redhat.com/mailman/listinfo/dm-d=
evel</a><br>
<br>
</blockquote></div>

--000000000000b6759305f41d7178--

--===============8558341122848341735==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============8558341122848341735==--

