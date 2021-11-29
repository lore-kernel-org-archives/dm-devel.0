Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78620C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 30 Nov 2021 06:12:12 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-184-tXgEgfQgMwCwjZaWyDWFsQ-1; Tue, 30 Nov 2021 01:12:06 -0500
X-MC-Unique: tXgEgfQgMwCwjZaWyDWFsQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEB7D1018720;
	Tue, 30 Nov 2021 06:12:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6329619EF9;
	Tue, 30 Nov 2021 06:12:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0F43E1809C89;
	Tue, 30 Nov 2021 06:12:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ATGpqdW019170 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Nov 2021 11:51:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 01A2751E1; Mon, 29 Nov 2021 16:51:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EC5BB51E2
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 16:51:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 085B7823F6F
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 16:51:49 +0000 (UTC)
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com
	[209.85.219.50]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-572-7X4Au5JAP7SGB5lGwW_jRw-1; Mon, 29 Nov 2021 11:51:44 -0500
X-MC-Unique: 7X4Au5JAP7SGB5lGwW_jRw-1
Received: by mail-qv1-f50.google.com with SMTP id jo22so15123081qvb.13
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 08:51:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=A288ZfdtXAVVBN7fUbSRNT5AUuE8LkM9CxPDC6zUQ1I=;
	b=FmsvfJWQIZ4ivQ1UfzuHwNZ+mdMziC3zHGczBj0spn7uGQDX4F8GLlM/bmC2Xuhw7Q
	J7UEvCFxB2QfNK2TMk6wwtHHZAJ4mr3jiiVv1BTQxyoIYKlplnztmzWZrapm/h/Li2S5
	ohg37W+GlGd7VLf+piVHxc24oRXBphEEj8gTN0taomJHUM2YA2syRyzCDdZ+D3wi0ElQ
	8Uqj2NHt5hVbDPv/p93h4zkpvIz25w12xU9QpILQ+oLMeX5PHSJ+2uj8j2N8Em/oGVKL
	I935zneMWp2xuBpV3MSv7e8tZ3TANJBPws8gqqzLGsT6ZESziejPHoyEjoYAOK8eP/7o
	6Xvg==
X-Gm-Message-State: AOAM533bXw7uXnn3pTsWG7mmzyPIPMj++Cxx2BdQNrHJd9c3YJhZ9Q9a
	ucYdnclJQjezIq1W3bhAMB75/sqpUb2N3fQ0trovIg==
X-Google-Smtp-Source: ABdhPJwUWolrq/E3obEwYzTUMoZIiH87uo9P2QDgxirup78dhA1ZhrsM8yBL++tOYrdFycr1K2SlItW/c5OZihCLuNQ=
X-Received: by 2002:a05:6214:f61:: with SMTP id
	iy1mr42760625qvb.0.1638204704159; 
	Mon, 29 Nov 2021 08:51:44 -0800 (PST)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2111231421490.24195@file01.intranet.prod.int.rdu2.redhat.com>
	<CABSDvDL23UZ8KMrjK+qm0Lw0bfDaWh2TruZ2kLgGXqidgOt0jQ@mail.gmail.com>
	<20211124003831.GB63964@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
	<20211124010239.GC63964@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
	<CABSDvDL5gi9KQ3+x1+0vonSFX-OZdd6NeD-XO-d_nvwXtbRMqA@mail.gmail.com>
	<alpine.LRH.2.02.2111290858100.9550@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2111290858100.9550@file01.intranet.prod.int.rdu2.redhat.com>
From: zhangkelvin <zhangkelvin@google.com>
Date: Mon, 29 Nov 2021 08:51:31 -0800
Message-ID: <CAOSmRzh=FwuHvWmzsQ=E4S3fKdcwG81jP5niWu0vCRpok=bibg@mail.gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 30 Nov 2021 01:11:05 -0500
Cc: Mike Snitzer <msnitzer@redhat.com>, Tianjie Xu <xunchang@google.com>,
	Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com,
	David Anderson <dvander@google.com>, Akilesh Kailash <akailash@google.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] announcing the dm-update target
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============6200409062192908294=="

--===============6200409062192908294==
Content-Type: multipart/alternative; boundary="000000000000764c3905d1f0412b"

--000000000000764c3905d1f0412b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

1. OTA does not control placement of files. That=E2=80=99s done by file
systems(ext4)
2. OTA work at block device level. Not file level
3. Often times, a file would have few of its blocks changed/shuffled, and
rest of the blocks retain old content.

On Mon, Nov 29, 2021 at 06:05 Mikulas Patocka <mpatocka@redhat.com> wrote:

>
>
> On Tue, 23 Nov 2021, Akilesh Kailash wrote:
>
> > With OTA, it is challenging to have one general COW format - for instan=
ce
> > what is good for the Android ecosystem may not be useful for the
> > enterprise world.
> > For ex: Most of the space savings in Android comes from COPY operation
> i.e
> > for an incremental OTA, we would have metadata which states:
> >
> > COPY BLOCK X -> BLOCK Y
> >
> > There is no compression involved with these operations. Compression is
> only
> > when a block is "replaced". All these are too specific to the Android
> ecosystem.
>
> Why does Android OTA need the COPY operation? If a file is not changed by
> the update, the file could be placed at the same location and no update o=
f
> the file is needed. If a file is changed, it is improbable that the new
> file will contain permutation of blocks of the old file, so I don't see
> how COPY will help here.
>
> Mikulas
>
> --
Sincerely,

Kelvin Zhang

--000000000000764c3905d1f0412b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">1. OTA does not control placement of files. That=E2=80=99=
s done by file systems(ext4)</div><div dir=3D"auto">2. OTA work at block de=
vice level. Not file level</div><div dir=3D"auto">3. Often times, a file wo=
uld have few of its blocks changed/shuffled, and rest of the blocks retain =
old content.</div><div><br><div class=3D"gmail_quote"><div dir=3D"ltr" clas=
s=3D"gmail_attr">On Mon, Nov 29, 2021 at 06:05 Mikulas Patocka &lt;<a href=
=3D"mailto:mpatocka@redhat.com">mpatocka@redhat.com</a>&gt; wrote:<br></div=
><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border=
-left-width:1px;border-left-style:solid;padding-left:1ex;border-left-color:=
rgb(204,204,204)"><br>
<br>
On Tue, 23 Nov 2021, Akilesh Kailash wrote:<br>
<br>
&gt; With OTA, it is challenging to have one general COW format - for insta=
nce<br>
&gt; what is good for the Android ecosystem may not be useful for the<br>
&gt; enterprise world.<br>
&gt; For ex: Most of the space savings in Android comes from COPY operation=
 i.e<br>
&gt; for an incremental OTA, we would have metadata which states:<br>
&gt; <br>
&gt; COPY BLOCK X -&gt; BLOCK Y<br>
&gt; <br>
&gt; There is no compression involved with these operations. Compression is=
 only<br>
&gt; when a block is &quot;replaced&quot;. All these are too specific to th=
e Android ecosystem.<br>
<br>
Why does Android OTA need the COPY operation? If a file is not changed by <=
br>
the update, the file could be placed at the same location and no update of =
<br>
the file is needed. If a file is changed, it is improbable that the new <br=
>
file will contain permutation of blocks of the old file, so I don&#39;t see=
 <br>
how COPY will help here.<br>
<br>
Mikulas<br>
<br>
</blockquote></div></div>-- <br><div dir=3D"ltr" class=3D"gmail_signature" =
data-smartmail=3D"gmail_signature"><div dir=3D"ltr">Sincerely,<div><br></di=
v><div>Kelvin Zhang</div></div></div>

--000000000000764c3905d1f0412b--

--===============6200409062192908294==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============6200409062192908294==--

