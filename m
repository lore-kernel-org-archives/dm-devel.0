Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B833C77B73
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 07:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685431637;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=bo6wTfa2Yxm+USlg84I9axuM+qJCUb5Ir5F1HzU9YEk=;
	b=Zz8DMlmpeVBLGmORXG9gaRjUa1zPGe32/yZ5XKgQlJSx0eg1Y6ZZR447QbHviiRwVk79ft
	59dluR6B/s83ITZRlNILbKPARfFiIFeWV02ERa2Vx16FjGIcjyLEGhFVhh7EDb0AYklNU7
	IWjDD+jpeotiAkPkwiYUF6YPbBkNxSA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-387-0OfM34e5NbGlZgoc0-ao1A-1; Tue, 30 May 2023 03:27:13 -0400
X-MC-Unique: 0OfM34e5NbGlZgoc0-ao1A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 189D63850543;
	Tue, 30 May 2023 07:27:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 08097C154D3;
	Tue, 30 May 2023 07:27:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BF9161946595;
	Tue, 30 May 2023 07:27:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7895A194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 07:27:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 359002166B26; Tue, 30 May 2023 07:27:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2CEB72166B25
 for <dm-devel@redhat.com>; Tue, 30 May 2023 07:27:06 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C4CC101A53B
 for <dm-devel@redhat.com>; Tue, 30 May 2023 07:27:06 +0000 (UTC)
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-A116S1AWOv21odEz7vpSHw-1; Tue, 30 May 2023 03:27:04 -0400
X-MC-Unique: A116S1AWOv21odEz7vpSHw-1
Received: by mail-wr1-f69.google.com with SMTP id
 ffacd0b85a97d-30ae8776c12so991038f8f.1
 for <dm-devel@redhat.com>; Tue, 30 May 2023 00:27:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685431623; x=1688023623;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=8pS4XJS05t9e8Cv0v1TnfdKjXXEtonqfYdbK97XQxsM=;
 b=B0gRqsCjViK7bammYKRWSxzH7g7mIXYOEpe6TbA7DrWo7nN+BnEtmxLDIvmvQpa7Q9
 FgA0Eigj/Lg5i5hRy+11faGAFUBqfD/AkkGQsTpoCZaqmDWTo8iKpqAMyFP23thsL6YK
 OlWQ94c3H5GPyIlg9wRNHHqduLpy6wmXesFKDUjlIlunGC0nP/kB88np6w1IIiesNOCd
 H7VbDBoY2CMfiP94NXkcnp9IKgixCiVFQvjyD6Z6II+d7xvx1R1CPkoT23Ws9lBilF4O
 cgVwPrGw4khELk+Vhl3N+a2QljsnvnYha8LDQNH0O4UDiWRwETDN66lwhokAW2xHsSNo
 nz3Q==
X-Gm-Message-State: AC+VfDzkdBGgV02IBC6vpygFmkE2DUCXUsJo5VTaEIGjbRtseJwdz0XD
 HPq0AlfpJVRywcyyc8PrGXVM+VLfhyCLGz1HlgoEnJitG43xjpejG/TGc960OB9nyfaEcCt1adK
 olD0b/F846HWXTYdbLW/AL/eMArXhXSg=
X-Received: by 2002:a5d:6045:0:b0:306:3352:5b8c with SMTP id
 j5-20020a5d6045000000b0030633525b8cmr1168616wrt.7.1685431623405; 
 Tue, 30 May 2023 00:27:03 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5tGO149vFlmdoQxZZS3RtGFogq06sbqVX6c0aVsYwiYx+muS2OzK8FxigO8RpUSVJfx4uvBwt+OUyVt7qv7U0=
X-Received: by 2002:a5d:6045:0:b0:306:3352:5b8c with SMTP id
 j5-20020a5d6045000000b0030633525b8cmr1168591wrt.7.1685431623191; Tue, 30 May
 2023 00:27:03 -0700 (PDT)
MIME-Version: 1.0
References: <ZGb2Xi6O3i2pLam8@infradead.org> <ZGeKm+jcBxzkMXQs@redhat.com>
 <ZGgBQhsbU9b0RiT1@dread.disaster.area> <ZGu0LaQfREvOQO4h@redhat.com>
 <ZGzIJlCE2pcqQRFJ@bfoster> <ZGzbGg35SqMrWfpr@redhat.com>
 <ZG1dAtHmbQ53aOhA@dread.disaster.area>
 <ZG+KoxDMeyogq4J0@bfoster> <ZHB954zGG1ag0E/t@dread.disaster.area>
 <CAJ0trDbspRaDKzTzTjFdPHdB9n0Q9unfu1cEk8giTWoNu3jP8g@mail.gmail.com>
 <ZHFEfngPyUOqlthr@dread.disaster.area>
In-Reply-To: <ZHFEfngPyUOqlthr@dread.disaster.area>
From: Joe Thornber <thornber@redhat.com>
Date: Tue, 30 May 2023 08:27:04 +0100
Message-ID: <CAJ0trDZJQwvAzngZLBJ1hB0XkQ1HRHQOdNQNTw9nK-U5i-0bLA@mail.gmail.com>
To: Dave Chinner <david@fromorbit.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v7 0/5] Introduce provisioning primitives
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, Stefan Hajnoczi <stefanha@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Brian Foster <bfoster@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 Joe Thornber <ejt@redhat.com>, Christoph Hellwig <hch@infradead.org>,
 dm-devel@redhat.com, Andreas Dilger <adilger.kernel@dilger.ca>,
 Sarthak Kukreti <sarthakkukreti@chromium.org>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============8319042980980808329=="

--===============8319042980980808329==
Content-Type: multipart/alternative; boundary="000000000000319f8f05fce42177"

--000000000000319f8f05fce42177
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 27, 2023 at 12:45=E2=80=AFAM Dave Chinner <david@fromorbit.com>=
 wrote:

> On Fri, May 26, 2023 at 12:04:02PM +0100, Joe Thornber wrote:
>
> > 1) We have an api (ioctl, bio flag, whatever) that lets you
> > reserve/guarantee a region:
> >
> >   int reserve_region(dev, sector_t begin, sector_t end);
>
> A C-based interface is not sufficient because the layer that must do
> provsioning is not guaranteed to be directly under the filesystem.
> We must be able to propagate the request down to the layers that
> need to provision storage, and that includes hardware devices.
>
> e.g. dm-thin would have to issue REQ_PROVISION on the LBA ranges it
> allocates in it's backing device to guarantee that the provisioned
> LBA range it allocates is also fully provisioned by the storage
> below it....
>

Fine, bio flag it is.


>
> >   This api should be used minimally, eg, critical FS metadata only.
>
>
>
> Plan for having to support tens of GBs of provisioned space in
> filesystems, not tens of MBs....
>

Also fine.


I think there's a 2-3 solid days of coding to fully implement
> REQ_PROVISION support in XFS, including userspace tool support.
> Maybe a couple of weeks more to flush the bugs out before it's
> largely ready to go.
>
> So if there's buy in from the block layer and DM people for
> REQ_PROVISION as described, then I'll definitely have XFS support
> ready for you to test whenever dm-thinp is ready to go.
>

Great, this is what I wanted to hear.  I guess we need an ack from the
block guys and
then I'll get started.

- Joe

--000000000000319f8f05fce42177
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Sat, May 27, 2023 at 12:45=E2=80=
=AFAM Dave Chinner &lt;<a href=3D"mailto:david@fromorbit.com">david@fromorb=
it.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"m=
argin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left=
:1ex">On Fri, May 26, 2023 at 12:04:02PM +0100, Joe Thornber wrote:<br><br>
&gt; 1) We have an api (ioctl, bio flag, whatever) that lets you<br>
&gt; reserve/guarantee a region:<br>
&gt; <br>
&gt;=C2=A0 =C2=A0int reserve_region(dev, sector_t begin, sector_t end);<br>
<br>
A C-based interface is not sufficient because the layer that must do<br>
provsioning is not guaranteed to be directly under the filesystem.<br>
We must be able to propagate the request down to the layers that<br>
need to provision storage, and that includes hardware devices.<br>
<br>
e.g. dm-thin would have to issue REQ_PROVISION on the LBA ranges it<br>
allocates in it&#39;s backing device to guarantee that the provisioned<br>
LBA range it allocates is also fully provisioned by the storage<br>
below it....<br></blockquote><div><br></div><div>Fine, bio flag it is.</div=
><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px=
 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
<br>
&gt;=C2=A0 =C2=A0This api should be used minimally, eg, critical FS metadat=
a only.<br>
<br><br></blockquote><blockquote class=3D"gmail_quote" style=3D"margin:0px =
0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
<br>
Plan for having to support tens of GBs of provisioned space in<br>
filesystems, not tens of MBs....<br></blockquote><div><br></div><div>Also f=
ine.=C2=A0</div><div><br></div><div><br></div><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,20=
4);padding-left:1ex">I think there&#39;s a 2-3 solid days of coding to full=
y implement<br>
REQ_PROVISION support in XFS, including userspace tool support.<br>
Maybe a couple of weeks more to flush the bugs out before it&#39;s<br>
largely ready to go.<br>
<br>
So if there&#39;s buy in from the block layer and DM people for<br>
REQ_PROVISION as described, then I&#39;ll definitely have XFS support<br>
ready for you to test whenever dm-thinp is ready to go.<br></blockquote><di=
v><br></div><div>Great, this is what I wanted to hear.=C2=A0 I guess we nee=
d an ack from the block guys and</div><div>then I&#39;ll get started.</div>=
<div>=C2=A0</div><div>- Joe</div></div></div>

--000000000000319f8f05fce42177--

--===============8319042980980808329==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============8319042980980808329==--

