Return-Path: <SRS0=RcAx=E2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9218DC63697
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 01:26:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C6F1322254
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 01:26:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iMYfQmcF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6F1322254
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1605835593;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=zbCCvsspcJ/WF4wprYm0utzAY9f9ao14NrIwxYhzQCM=;
	b=iMYfQmcFdrgxPOo3uuUT95GxZAMwHlDOAu2LIKDaGwvGHIT/sr8oXksVmsVZFib7tAGGdx
	dXDd7LdsFYyZ8togWEmIzZDSGeyVr+lKXgcHTDtP5Vxpu7plTUhrWvmLBvCkaXS8DYN9pZ
	2WYk4+F/WSTj9kFf/8HBF7/TGDh9bTs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-JibxbBuDMNeJskx7qjfLWQ-1; Thu, 19 Nov 2020 20:26:30 -0500
X-MC-Unique: JibxbBuDMNeJskx7qjfLWQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3AE5180DE08;
	Fri, 20 Nov 2020 01:26:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8801D60636;
	Fri, 20 Nov 2020 01:26:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 39D64180954D;
	Fri, 20 Nov 2020 01:26:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AK1QM4a005824 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Nov 2020 20:26:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 42F142166B2B; Fri, 20 Nov 2020 01:26:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CE802166B2C
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 01:26:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E738C811E84
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 01:26:19 +0000 (UTC)
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
	[209.85.222.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-434-tleNtZgJOUCon7B6074X-A-1; Thu, 19 Nov 2020 20:26:15 -0500
X-MC-Unique: tleNtZgJOUCon7B6074X-A-1
Received: by mail-ua1-f71.google.com with SMTP id 93so2458920uav.7
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 17:26:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=0c4lUsEzPKs2fa2Uyg442M22M0mYBZgv2skyD+/Lq3s=;
	b=rD4oEF1HX10NZWo/myQ5FVcpOoTvlUu+yDFLUrIU7EHYi23hDvYrlNJ/SK/SBQf7nk
	/RG10zZbdwQBF7phCA2GuHgezdrgOP8RZHUOLwxckM/32i0ejXhnj7aLl4I+Mbdw5BLX
	Ju448pXKxDlduzxEidN1FIfCf5mxZm0cpQserN8E7r68vivisCgPGwD2GrqhWkrw7IRB
	MqShX72fRaREGu7KDNOXCb4PtGyqC8beoA/8uCN8RzsAMyI4aLfADnDcDkVnsj2dMxz7
	60GkNdb/UirxxqQxeECd1ATmV7PlSsJWYLCHCbABXklyKPrwOYowfXghpe1xNdsCy9Kh
	WMGQ==
X-Gm-Message-State: AOAM531PPP8Xoy+PCiMjCbz5JzBk1pecr5FnNBuH6B8L06EtXG0jRrVA
	CvuW7wvBHJYZVcRWYzoExjjkcUStQ4ZWsmCvy6N19aZQBu7K4TJ075/W6uEiVgZ0a5lZO3tq+aa
	rRndstRkNmJqItgylqdYAr3NkhzU2e4k=
X-Received: by 2002:a9f:3213:: with SMTP id x19mr11229090uad.98.1605835575135; 
	Thu, 19 Nov 2020 17:26:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwDuUTs6cCIn8zcFUtUpc6hYFmWVOeKKHI2Mjsloh06QTb94XnFrj+fdHyzzi8yFjvBtlsS4Zwk2FhnWJlpDWw=
X-Received: by 2002:a9f:3213:: with SMTP id x19mr11229078uad.98.1605835574903; 
	Thu, 19 Nov 2020 17:26:14 -0800 (PST)
MIME-Version: 1.0
References: <20201118203127.GA30066@redhat.com>
	<20201118203408.GB30066@redhat.com>
	<fc7c4efd-0bb3-f023-19c6-54359d279ca8@redhat.com>
	<alpine.LRH.2.02.2011190810001.32672@file01.intranet.prod.int.rdu2.redhat.com>
	<20201119172807.GC1879@redhat.com>
	<alpine.LRH.2.02.2011191337180.588@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2011191517360.10231@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2011191517360.10231@file01.intranet.prod.int.rdu2.redhat.com>
From: Sweet Tea Dorminy <sweettea@redhat.com>
Date: Thu, 19 Nov 2020 20:26:03 -0500
Message-ID: <CAMeeMh8xcL4+3P49+TbqJiQ7DrMsj6UYUhXKMvwXe0qkbr77PA@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Heinz Mauelshagen <heinzm@redhat.com>,
	Marian Csontos <mcsontos@redhat.com>,
	linux-block <linux-block@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	David Teigland <teigland@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [dm-devel] [PATCH] blk-settings: make sure that max_sectors is
 aligned on "logical_block_size" boundary.
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============2491810544342692323=="

--===============2491810544342692323==
Content-Type: multipart/alternative; boundary="000000000000029f8b05b47fbb9e"

--000000000000029f8b05b47fbb9e
Content-Type: text/plain; charset="UTF-8"

Greetings;

Might I suggest using SECTOR_SIZE instead of 512? Or, perhaps, >>
SECTOR_SHIFT instead of / 512.

I don't understand the three conditionals. I believe max_sectors is
supposed to be <= min(max_dev_sectors, max_hw_sectors), but I don't
understand why max_sectors being small should adjust max_hw_sectors and
max_dev_sectors. Are the conditions perhaps supposed to be different,
adjusting each max_*sectors up to at least PAGE_SIZE / SECTOR_SIZE?
Perhaps, like e.g. blk_queue_max_hw_sectors(), the conditionals should log
if they are adjusting max_*sectors up to the minimum.

Thanks!

John Dorminy

On Thu, Nov 19, 2020 at 3:37 PM Mikulas Patocka <mpatocka@redhat.com> wrote:

> We get these I/O errors when we run md-raid1 on the top of dm-integrity on
> the top of ramdisk:
> device-mapper: integrity: Bio not aligned on 8 sectors: 0xff00, 0xff
> device-mapper: integrity: Bio not aligned on 8 sectors: 0xff00, 0xff
> device-mapper: integrity: Bio not aligned on 8 sectors: 0xffff, 0x1
> device-mapper: integrity: Bio not aligned on 8 sectors: 0xffff, 0x1
> device-mapper: integrity: Bio not aligned on 8 sectors: 0x8048, 0xff
> device-mapper: integrity: Bio not aligned on 8 sectors: 0x8147, 0xff
> device-mapper: integrity: Bio not aligned on 8 sectors: 0x8246, 0xff
> device-mapper: integrity: Bio not aligned on 8 sectors: 0x8345, 0xbb
>
> The ramdisk device has logical_block_size 512 and max_sectors 255. The
> dm-integrity device uses logical_block_size 4096 and it doesn't affect the
> "max_sectors" value - thus, it inherits 255 from the ramdisk. So, we have
> a device with max_sectors not aligned on logical_block_size.
>
> The md-raid device sees that the underlying leg has max_sectors 255 and it
> will split the bios on 255-sector boundary, making the bios unaligned on
> logical_block_size.
>
> In order to fix the bug, we round down max_sectors to logical_block_size.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
>
> ---
>  block/blk-settings.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> Index: linux-2.6/block/blk-settings.c
> ===================================================================
> --- linux-2.6.orig/block/blk-settings.c 2020-10-29 12:20:46.000000000 +0100
> +++ linux-2.6/block/blk-settings.c      2020-11-19 21:20:18.000000000 +0100
> @@ -591,6 +591,16 @@ int blk_stack_limits(struct queue_limits
>                 ret = -1;
>         }
>
> +       t->max_sectors = round_down(t->max_sectors, t->logical_block_size
> / 512);
> +       if (t->max_sectors < PAGE_SIZE / 512)
> +               t->max_sectors = PAGE_SIZE / 512;
> +       t->max_hw_sectors = round_down(t->max_hw_sectors,
> t->logical_block_size / 512);
> +       if (t->max_sectors < PAGE_SIZE / 512)
> +               t->max_hw_sectors = PAGE_SIZE / 512;
> +       t->max_dev_sectors = round_down(t->max_dev_sectors,
> t->logical_block_size / 512);
> +       if (t->max_sectors < PAGE_SIZE / 512)
> +               t->max_dev_sectors = PAGE_SIZE / 512;
> +
>         /* Discard alignment and granularity */
>         if (b->discard_granularity) {
>                 alignment = queue_limit_discard_alignment(b, start);
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
>

--000000000000029f8b05b47fbb9e
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div>Greetings;<br><br></div>Might I suggest usi=
ng SECTOR_SIZE instead of 512? Or, perhaps, &gt;&gt; SECTOR_SHIFT instead o=
f / 512.=C2=A0 <br><br>I don&#39;t understand the three conditionals. I bel=
ieve max_sectors is supposed to be &lt;=3D min(max_dev_sectors, max_hw_sect=
ors), but I don&#39;t understand why max_sectors being small should adjust =
max_hw_sectors and max_dev_sectors. Are the conditions perhaps supposed to =
be different, adjusting each max_*sectors up to at least PAGE_SIZE / SECTOR=
_SIZE? Perhaps, like e.g. blk_queue_max_hw_sectors(), the conditionals shou=
ld log if they are adjusting max_*sectors up to the minimum.<br><br></div>T=
hanks!<br><br></div>John Dorminy<br></div><br><div class=3D"gmail_quote"><d=
iv dir=3D"ltr" class=3D"gmail_attr">On Thu, Nov 19, 2020 at 3:37 PM Mikulas=
 Patocka &lt;<a href=3D"mailto:mpatocka@redhat.com">mpatocka@redhat.com</a>=
&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px =
0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">We g=
et these I/O errors when we run md-raid1 on the top of dm-integrity on <br>
the top of ramdisk:<br>
device-mapper: integrity: Bio not aligned on 8 sectors: 0xff00, 0xff<br>
device-mapper: integrity: Bio not aligned on 8 sectors: 0xff00, 0xff<br>
device-mapper: integrity: Bio not aligned on 8 sectors: 0xffff, 0x1<br>
device-mapper: integrity: Bio not aligned on 8 sectors: 0xffff, 0x1<br>
device-mapper: integrity: Bio not aligned on 8 sectors: 0x8048, 0xff<br>
device-mapper: integrity: Bio not aligned on 8 sectors: 0x8147, 0xff<br>
device-mapper: integrity: Bio not aligned on 8 sectors: 0x8246, 0xff<br>
device-mapper: integrity: Bio not aligned on 8 sectors: 0x8345, 0xbb<br>
<br>
The ramdisk device has logical_block_size 512 and max_sectors 255. The <br>
dm-integrity device uses logical_block_size 4096 and it doesn&#39;t affect =
the <br>
&quot;max_sectors&quot; value - thus, it inherits 255 from the ramdisk. So,=
 we have <br>
a device with max_sectors not aligned on logical_block_size.<br>
<br>
The md-raid device sees that the underlying leg has max_sectors 255 and it<=
br>
will split the bios on 255-sector boundary, making the bios unaligned on<br=
>
logical_block_size.<br>
<br>
In order to fix the bug, we round down max_sectors to logical_block_size.<b=
r>
<br>
Signed-off-by: Mikulas Patocka &lt;<a href=3D"mailto:mpatocka@redhat.com" t=
arget=3D"_blank">mpatocka@redhat.com</a>&gt;<br>
Cc: <a href=3D"mailto:stable@vger.kernel.org" target=3D"_blank">stable@vger=
.kernel.org</a><br>
<br>
---<br>
=C2=A0block/blk-settings.c |=C2=A0 =C2=A010 ++++++++++<br>
=C2=A01 file changed, 10 insertions(+)<br>
<br>
Index: linux-2.6/block/blk-settings.c<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
--- linux-2.6.orig/block/blk-settings.c 2020-10-29 12:20:46.000000000 +0100=
<br>
+++ linux-2.6/block/blk-settings.c=C2=A0 =C2=A0 =C2=A0 2020-11-19 21:20:18.=
000000000 +0100<br>
@@ -591,6 +591,16 @@ int blk_stack_limits(struct queue_limits<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D -1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0t-&gt;max_sectors =3D round_down(t-&gt;max_sect=
ors, t-&gt;logical_block_size / 512);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (t-&gt;max_sectors &lt; PAGE_SIZE / 512)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0t-&gt;max_sectors =
=3D PAGE_SIZE / 512;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0t-&gt;max_hw_sectors =3D round_down(t-&gt;max_h=
w_sectors, t-&gt;logical_block_size / 512);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (t-&gt;max_sectors &lt; PAGE_SIZE / 512)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0t-&gt;max_hw_sector=
s =3D PAGE_SIZE / 512;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0t-&gt;max_dev_sectors =3D round_down(t-&gt;max_=
dev_sectors, t-&gt;logical_block_size / 512);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (t-&gt;max_sectors &lt; PAGE_SIZE / 512)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0t-&gt;max_dev_secto=
rs =3D PAGE_SIZE / 512;<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Discard alignment and granularity */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (b-&gt;discard_granularity) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 alignment =3D queue=
_limit_discard_alignment(b, start);<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br>
<br>
</blockquote></div>

--000000000000029f8b05b47fbb9e--

--===============2491810544342692323==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============2491810544342692323==--

