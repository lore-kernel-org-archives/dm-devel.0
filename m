Return-Path: <SRS0=RkM6=LB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A648C47082
	for <dm-devel@archiver.kernel.org>; Mon,  7 Jun 2021 18:57:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D1D94610A1
	for <dm-devel@archiver.kernel.org>; Mon,  7 Jun 2021 18:57:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D1D94610A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1623092272;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=iePeQ23iTfYdd7Z5RLlj+78iYVO0VMT9q8+uG3OuK6Q=;
	b=LlfQeLq2I5dnnLbUBtvpsHXHQ2lIx2kfLeqHkjII9CEUpdSo7Qupl3/2DUD4y/JprnCedT
	Cje3gYIPAWkNI1TmEWLeRrlhbSaKVdFTpXhL5XraGdlhjDLlRHzEutH3Vp+LM4A5WjCNMq
	txIKQ+XNzYZaSlAn67Ts/coyiabG4EA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-4e_mChiVMiC6L0oU_PP6bw-1; Mon, 07 Jun 2021 14:57:49 -0400
X-MC-Unique: 4e_mChiVMiC6L0oU_PP6bw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D344F5120;
	Mon,  7 Jun 2021 18:57:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AD9465D9DC;
	Mon,  7 Jun 2021 18:57:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1D45444A59;
	Mon,  7 Jun 2021 18:57:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 157IvdDK032592 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Jun 2021 14:57:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AF618205D6CC; Mon,  7 Jun 2021 18:57:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AABE0200D8C0
	for <dm-devel@redhat.com>; Mon,  7 Jun 2021 18:57:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EFC918316EF
	for <dm-devel@redhat.com>; Mon,  7 Jun 2021 18:57:36 +0000 (UTC)
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
	[209.85.219.198]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-519-qdj8bFVeO6eTujBAI2o3Rg-1; Mon, 07 Jun 2021 14:57:34 -0400
X-MC-Unique: qdj8bFVeO6eTujBAI2o3Rg-1
Received: by mail-yb1-f198.google.com with SMTP id
	q63-20020a25d9420000b0290532e824f77cso23626117ybg.10
	for <dm-devel@redhat.com>; Mon, 07 Jun 2021 11:57:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=txMP9xlDTz/TNS29Td1OlEya3TdWLygQbprSKJgWjVQ=;
	b=p7b6dWALTNbS4+W8b3f+0Ofb9oau+KS0Y92Pt3SI0Y1bNx6wyyPIQg/7irO/vdi+xR
	iM0N7A13RdYuEH/2CjoFp6hrWqhC1b1j36lKGLG0aE3Jjk85Ztp+OzOHs7ploETlhTal
	73lz9D0lMwngIptFqHUzOkm9jRY8L+9XNOUG/ko3fvEr0ibC0m3HMveVcmc1/mQbHQqn
	R78j7E3w+GBU2/fOmSPVT/08TCegBiMoT4QZ0lOfe33b/RNyyM3VXHowe/I5O3E0m6fu
	sDuFfxY4XK+ATcrH6OLWvPlChlBkD1iH9r22BlA/mqFFd2KauQlYNrIlUTPzw7wRZdR8
	5cLQ==
X-Gm-Message-State: AOAM531Oz+b7ZYM1g63Eizso95WzMd83VFv4VLgenBon8497rLIs/BuB
	9YJHCLuoYX7qIAp6YmN4HPy1yEKUxbMbwGVo5Zo1grP8EKKHB48PL+IdC2vpDeoTcLHUsm/xPUp
	0/L4M995jtsvOsB6FfP5ObjoBV+edCwc=
X-Received: by 2002:a5b:58e:: with SMTP id l14mr10138415ybp.303.1623092254287; 
	Mon, 07 Jun 2021 11:57:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwphIL11hRT14mRq8JLWM/+BGcTCGle1EZaNtq0Ec76HGnr35gYIFNnTOJTvhr2m+jcYqdGsp83KcswwvBpZQ4=
X-Received: by 2002:a5b:58e:: with SMTP id l14mr10138396ybp.303.1623092254102; 
	Mon, 07 Jun 2021 11:57:34 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2106061610240.27406@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2106061610240.27406@file01.intranet.prod.int.rdu2.redhat.com>
From: Heinz Mauelshagen <heinzm@redhat.com>
Date: Mon, 7 Jun 2021 20:57:23 +0200
Message-ID: <CAM23Vxp0AYWX2_bpQsB-oVjYuD3FRzfLncu7-e9bttaTMa9iHg@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] dm-writecache: commit just one block,
 not a full page
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============3759649324057547764=="

--===============3759649324057547764==
Content-Type: multipart/alternative; boundary="0000000000003e67d405c4319d6f"

--0000000000003e67d405c4319d6f
Content-Type: text/plain; charset="UTF-8"

On Sun, Jun 6, 2021 at 10:14 PM Mikulas Patocka <mpatocka@redhat.com> wrote:

> When comitting superblock, we need to write just one block, we don't need
> to write full page. Some architectures have pages larger than 4k and
> committing full page is needless overhead.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>
> Index: linux-2.6/drivers/md/dm-writecache.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-writecache.c
> +++ linux-2.6/drivers/md/dm-writecache.c
> @@ -532,11 +532,7 @@ static void ssd_commit_superblock(struct
>
>         region.bdev = wc->ssd_dev->bdev;
>         region.sector = 0;
> -       region.count = PAGE_SIZE >> SECTOR_SHIFT;
> -
> -       if (unlikely(region.sector + region.count > wc->metadata_sectors))
> -               region.count = wc->metadata_sectors - region.sector;
> -
> +       region.count = wc->block_size >> SECTOR_SHIFT;
>

You can use to_sector() here.


>         region.sector += wc->start_sector;
>
>         req.bi_op = REQ_OP_WRITE;
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
>
>

--0000000000003e67d405c4319d6f
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">On Sun, Jun 6, 2021 at 10:14 PM Mikulas P=
atocka &lt;<a href=3D"mailto:mpatocka@redhat.com">mpatocka@redhat.com</a>&g=
t; wrote:<br></div><div class=3D"gmail_quote"><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,20=
4);padding-left:1ex">When comitting superblock, we need to write just one b=
lock, we don&#39;t need<br>
to write full page. Some architectures have pages larger than 4k and<br>
committing full page is needless overhead.<br>
<br>
Signed-off-by: Mikulas Patocka &lt;<a href=3D"mailto:mpatocka@redhat.com" t=
arget=3D"_blank">mpatocka@redhat.com</a>&gt;<br>
<br>
Index: linux-2.6/drivers/md/dm-writecache.c<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
--- linux-2.6.orig/drivers/md/dm-writecache.c<br>
+++ linux-2.6/drivers/md/dm-writecache.c<br>
@@ -532,11 +532,7 @@ static void ssd_commit_superblock(struct<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 region.bdev =3D wc-&gt;ssd_dev-&gt;bdev;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 region.sector =3D 0;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0region.count =3D PAGE_SIZE &gt;&gt; SECTOR_SHIF=
T;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(region.sector + region.count &gt; =
wc-&gt;metadata_sectors))<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0region.count =3D wc=
-&gt;metadata_sectors - region.sector;<br>
-<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0region.count =3D wc-&gt;block_size &gt;&gt; SEC=
TOR_SHIFT;<br></blockquote><div><br></div><div>You can use to_sector() here=
.</div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0=
px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
=C2=A0 =C2=A0 =C2=A0 =C2=A0 region.sector +=3D wc-&gt;start_sector;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 req.bi_op =3D REQ_OP_WRITE;<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://listman.redhat.com/mailman/listinfo/dm-devel" rel=3D"nor=
eferrer" target=3D"_blank">https://listman.redhat.com/mailman/listinfo/dm-d=
evel</a><br>
<br>
</blockquote></div></div>

--0000000000003e67d405c4319d6f--

--===============3759649324057547764==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============3759649324057547764==--

