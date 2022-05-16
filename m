Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12870C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 17 May 2022 06:24:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-xc-dI_9bPNWpQzCr4NFnrg-1; Tue, 17 May 2022 02:24:06 -0400
X-MC-Unique: xc-dI_9bPNWpQzCr4NFnrg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80C2886B8AD;
	Tue, 17 May 2022 06:24:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DB1F42026D64;
	Tue, 17 May 2022 06:24:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8BDFC194705F;
	Tue, 17 May 2022 06:24:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E3904194704E
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 May 2022 14:33:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C42091121315; Mon, 16 May 2022 14:33:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BF8331121314
 for <dm-devel@redhat.com>; Mon, 16 May 2022 14:33:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7A4386B8AC
 for <dm-devel@redhat.com>; Mon, 16 May 2022 14:33:25 +0000 (UTC)
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com
 [209.85.217.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-1Smzi0PfOcSYv3erPBGA_g-1; Mon, 16 May 2022 10:33:23 -0400
X-MC-Unique: 1Smzi0PfOcSYv3erPBGA_g-1
Received: by mail-vs1-f41.google.com with SMTP id e19so15681317vsu.12;
 Mon, 16 May 2022 07:33:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=kKInsudTh8X0FJuDZeK57LOyaBmwoaio07Hcou3w5sI=;
 b=ZlIRhYlHwGNaO9mMVKpyA1xHWXAwMl0xrdUCvHdfIq1BQ5MOmL4bwvOMbNPM1Erhj7
 +B7ggkfQmZ7i8F7SOh2hK3WtLyJbEwRxzrIX8kg7A5RaV4htJurnQwLVutilo8yoJ5wO
 2Dd12tSatHRWWxD4Ccnb5Ee/ERwoTp3HlF64hPYFxNhDzOeT4tNDHjSq4BQ3+c5lUj2h
 5iiSwuFd4cT4kcfTEI7MUHVpjmoQNjVUODAZSsdpl94ck+11yc4VQRxnhDDu135dh4pY
 jwjzjf2iNncrIt8SyjyvrIO/tpWw5Hsj10jjDyM2G+s4k6m3o+iZ8JlUT78dzbneNyCj
 h25w==
X-Gm-Message-State: AOAM530bx13XfF2QZ/whGpCBeHU5RYSo3aOkIBoOjrsbrYZ7PXX/Y9P8
 22K8Fz9Yc4jGYRz+tYxLuOul7Rqa3QsoVSL2nk8=
X-Google-Smtp-Source: ABdhPJyyd+41Mk7EBFw7HLuTF0LPEdfBC0GPUDMyt3AKJ1NM82wZxR3dGVa90lmGjKbFvdtmsirb7qR4BWFwCuQ40yY=
X-Received: by 2002:a67:ea4f:0:b0:328:1db4:d85c with SMTP id
 r15-20020a67ea4f000000b003281db4d85cmr6043721vso.20.1652711602305; Mon, 16
 May 2022 07:33:22 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20220516133922eucas1p1c891cd1d82539b4e792acb5d1aa74444@eucas1p1.samsung.com>
 <20220516133921.126925-1-p.raghav@samsung.com>
 <31e03f27-6610-c4e4-58b9-6b9db000a753@opensource.wdc.com>
In-Reply-To: <31e03f27-6610-c4e4-58b9-6b9db000a753@opensource.wdc.com>
From: notnand <pankydev8@gmail.com>
Date: Mon, 16 May 2022 16:33:10 +0200
Message-ID: <CAHdDd+u0X5Xjm3=4fEtibXqNPSpFo78TGzUkweb2GAedhWf6-A@mail.gmail.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mailman-Approved-At: Tue, 17 May 2022 06:24:02 +0000
Subject: Re: [dm-devel] [PATCH v4 00/13] support non power of 2 zoned devices
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
Cc: jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 Chris Mason <clm@fb.com>, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 Bart Van Assche <bvanassche@acm.org>, gost.dev@samsung.com,
 jonathan.derrick@linux.dev, Pankaj Raghav <p.raghav@samsung.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, snitzer@kernel.org,
 Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@fb.com>,
 dsterba@suse.com, jaegeuk@kernel.org,
 =?UTF-8?Q?Matias_Bj=C3=B8rling?= <matias.bjorling@wdc.com>,
 Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
 linux-kernel@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
 linux-fsdevel@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============4485778915117985412=="

--===============4485778915117985412==
Content-Type: multipart/alternative; boundary="000000000000f8bf8e05df21e776"

--000000000000f8bf8e05df21e776
Content-Type: text/plain; charset="UTF-8"

My mail server got messed up for some reason because of the number of
people in cc. I will send the whole patch series again in some time as I am
traveling now. Sorry about that.

On Mon, 16 May 2022, 16:20 Damien Le Moal, <damien.lemoal@opensource.wdc.com>
wrote:

> On 2022/05/16 15:39, Pankaj Raghav wrote:
> [...]
> > - Patchset description:
> > This patchset aims at adding support to non power of 2 zoned devices in
> > the block layer, nvme layer, null blk and adds support to btrfs and
> > zonefs.
> >
> > This round of patches **will not** support DM layer for non
> > power of 2 zoned devices. More about this in the future work section.
> >
> > Patches 1-2 deals with removing the po2 constraint from the
> > block layer.
> >
> > Patches 3-4 deals with removing the constraint from nvme zns.
> >
> > Patches 5-9 adds support to btrfs for non po2 zoned devices.
> >
> > Patch 10 removes the po2 constraint in ZoneFS
> >
> > Patch 11-12 removes the po2 contraint in null blk
> >
> > Patches 13 adds conditions to not allow non power of 2 devices in
> > DM.
>
>
> Not sure what is going on but I only got the first 4 patches and I do not
> see
> the remaining patches on the lists anywhere.
>
>
> --
> Damien Le Moal
> Western Digital Research
>
>

--000000000000f8bf8e05df21e776
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div>My mail server got messed up for some reason because=
 of the number of people in cc. I will send the whole patch series again in=
 some time as I am traveling now. Sorry about that.<br><br><div class=3D"gm=
ail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Mon, 16 May 2022, 16:20=
 Damien Le Moal, &lt;<a href=3D"mailto:damien.lemoal@opensource.wdc.com">da=
mien.lemoal@opensource.wdc.com</a>&gt; wrote:<br></div><blockquote class=3D=
"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding=
-left:1ex">On 2022/05/16 15:39, Pankaj Raghav wrote:<br>
[...]<br>
&gt; - Patchset description:<br>
&gt; This patchset aims at adding support to non power of 2 zoned devices i=
n<br>
&gt; the block layer, nvme layer, null blk and adds support to btrfs and<br=
>
&gt; zonefs.<br>
&gt; <br>
&gt; This round of patches **will not** support DM layer for non<br>
&gt; power of 2 zoned devices. More about this in the future work section.<=
br>
&gt; <br>
&gt; Patches 1-2 deals with removing the po2 constraint from the<br>
&gt; block layer.<br>
&gt; <br>
&gt; Patches 3-4 deals with removing the constraint from nvme zns.<br>
&gt; <br>
&gt; Patches 5-9 adds support to btrfs for non po2 zoned devices.<br>
&gt; <br>
&gt; Patch 10 removes the po2 constraint in ZoneFS<br>
&gt; <br>
&gt; Patch 11-12 removes the po2 contraint in null blk<br>
&gt; <br>
&gt; Patches 13 adds conditions to not allow non power of 2 devices in<br>
&gt; DM.<br>
<br>
<br>
Not sure what is going on but I only got the first 4 patches and I do not s=
ee<br>
the remaining patches on the lists anywhere.<br><br>
<br>
-- <br>
Damien Le Moal<br>
Western Digital Research<br>
<br>
</blockquote></div></div></div>

--000000000000f8bf8e05df21e776--

--===============4485778915117985412==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============4485778915117985412==--

