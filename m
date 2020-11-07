Return-Path: <SRS0=GP8t=EO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCC51C4742C
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 17:05:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6490B206C0
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 17:05:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6490B206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-v1LnvEKYObKeeX4HOGmdnQ-1; Sun, 08 Nov 2020 12:05:27 -0500
X-MC-Unique: v1LnvEKYObKeeX4HOGmdnQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FB0980365F;
	Sun,  8 Nov 2020 17:05:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E30F277CD;
	Sun,  8 Nov 2020 17:05:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2171B92304;
	Sun,  8 Nov 2020 17:05:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A74hbFJ024639 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 6 Nov 2020 23:43:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A731FF5AC5; Sat,  7 Nov 2020 04:43:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A15D5F568D
	for <dm-devel@redhat.com>; Sat,  7 Nov 2020 04:43:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 507F390E424
	for <dm-devel@redhat.com>; Sat,  7 Nov 2020 04:43:35 +0000 (UTC)
Received: from mail-lf1-f65.google.com (mail-lf1-f65.google.com
	[209.85.167.65]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-65-3bGig_2lPVu5QRDD-jMc0A-1; Fri, 06 Nov 2020 23:43:28 -0500
X-MC-Unique: 3bGig_2lPVu5QRDD-jMc0A-1
Received: by mail-lf1-f65.google.com with SMTP id z21so3502590lfe.12;
	Fri, 06 Nov 2020 20:43:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=3jS9MbGtA3iifbgEcp45wxTOB4OKIZiUtDbS0BnZQ1E=;
	b=sgnRuGOgt3I52y4zelPq0wmJKIF0Y/FRROmdw5EXJSPvgW+GHN0s5mCb25K9jvDEVC
	SfqMGx+j2yDkF5Bbif8n56rAMeAE+L3JmvR/E3l4C9BzknSN7ZTFQcKHRy2955rVwr6j
	mBSFE+QHyT0K0ZG2CamJiSS37Xs3QENnqyYfsM+U+h7f1f0KzNBhzjhQywGX8wush2G+
	cHy6Q/B5Sz3z6QWt1pWyMRt/8DH5fJvpz5RCjfqXC+AKx3h6wJeuAeQH2Eyc8jvVYk0m
	IYepqvPGYVzrQsx/9j8d/9vBPEs/lgrMrl9pdfspPepqLHxfRduU/VrkSoFoMmvEfQ8t
	JDbA==
X-Gm-Message-State: AOAM5337sZDEVRSBkrPzZ5Tc8ZzMWSOh1qNWr0TCnm+AqoSvvPEdwFV1
	cuGlhH0fQj5I7wr43g3O5JOL1Qme2Lbjza68C2Q=
X-Google-Smtp-Source: ABdhPJzn/pNC05U4kPURn4luKn+squhbFoU/xCSDcnlGrkwpRVWPCp6PcYhGp25nUSiML9AX1uojvU9jJs5PJTDaJxo=
X-Received: by 2002:ac2:5209:: with SMTP id a9mr1446563lfl.86.1604724205658;
	Fri, 06 Nov 2020 20:43:25 -0800 (PST)
MIME-Version: 1.0
References: <20201106190337.1973127-1-hch@lst.de>
	<20201106190337.1973127-25-hch@lst.de>
In-Reply-To: <20201106190337.1973127-25-hch@lst.de>
From: Jack Wang <xjtuwjp@gmail.com>
Date: Sat, 7 Nov 2020 05:43:14 +0100
Message-ID: <CAD+HZHUaPLB0T2A3vAPq6gSr5gEGK3XLMSAmO0FLhkWaLzPBpg@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
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
X-Mailman-Approved-At: Sun, 08 Nov 2020 12:04:49 -0500
Cc: Justin Sanders <justin@coraid.com>, Mike Snitzer <snitzer@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, linux-nvme@lists.infradead.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-scsi@vger.kernel.org, xen-devel@lists.xenproject.org,
	Ilya Dryomov <idryomov@gmail.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Josef Bacik <josef@toxicpanda.com>, nbd@other.debian.org,
	linux-raid@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>, drbd-dev@tron.linbit.com,
	ceph-devel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Minchan Kim <minchan@kernel.org>, linux-fsdevel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] [PATCH 24/24] block: unexport revalidate_disk_size
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============6150643606095609838=="

--===============6150643606095609838==
Content-Type: multipart/alternative; boundary="0000000000003da75005b37cf8d6"

--0000000000003da75005b37cf8d6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Christoph Hellwig <hch@lst.de>=E4=BA=8E2020=E5=B9=B411=E6=9C=886=E6=97=A5 =
=E5=91=A8=E4=BA=9420:15=E5=86=99=E9=81=93=EF=BC=9A

> revalidate_disk_size is not only called from set_capacity_and_notify,
> so drop the export.

s/not/now

>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks!
Jack Wang

>
> ---
>  fs/block_dev.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 66ebf594c97f47..d8664f5c1ff669 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1362,7 +1362,6 @@ void revalidate_disk_size(struct gendisk *disk, boo=
l
> verbose)
>                 bdput(bdev);
>         }
>  }
> -EXPORT_SYMBOL(revalidate_disk_size);
>
>  void bd_set_nr_sectors(struct block_device *bdev, sector_t sectors)
>  {
> --
> 2.28.0
>
>
> _______________________________________________
> Linux-nvme mailing list
> Linux-nvme@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-nvme
>

--0000000000003da75005b37cf8d6
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div><br></div><div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=
=3D"gmail_attr">Christoph Hellwig &lt;<a href=3D"mailto:hch@lst.de">hch@lst=
.de</a>&gt;=E4=BA=8E2020=E5=B9=B411=E6=9C=886=E6=97=A5 =E5=91=A8=E4=BA=9420=
:15=E5=86=99=E9=81=93=EF=BC=9A<br></div><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-style:so=
lid;padding-left:1ex;border-left-color:rgb(204,204,204)">revalidate_disk_si=
ze is not only called from set_capacity_and_notify,<br>
so drop the export.</blockquote><div dir=3D"auto">s/not/now</div><blockquot=
e class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width=
:1px;border-left-style:solid;padding-left:1ex;border-left-color:rgb(204,204=
,204)" dir=3D"auto"><br>
<br>
Signed-off-by: Christoph Hellwig &lt;<a href=3D"mailto:hch@lst.de" target=
=3D"_blank">hch@lst.de</a>&gt;</blockquote><div dir=3D"auto">Thanks!</div><=
div dir=3D"auto">Jack Wang</div><blockquote class=3D"gmail_quote" style=3D"=
margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-style:solid;padd=
ing-left:1ex;border-left-color:rgb(204,204,204)" dir=3D"auto"><br>
---<br>
=C2=A0fs/block_dev.c | 1 -<br>
=C2=A01 file changed, 1 deletion(-)<br>
<br>
diff --git a/fs/block_dev.c b/fs/block_dev.c<br>
index 66ebf594c97f47..d8664f5c1ff669 100644<br>
--- a/fs/block_dev.c<br>
+++ b/fs/block_dev.c<br>
@@ -1362,7 +1362,6 @@ void revalidate_disk_size(struct gendisk *disk, bool =
verbose)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bdput(bdev);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0}<br>
-EXPORT_SYMBOL(revalidate_disk_size);<br>
<br>
=C2=A0void bd_set_nr_sectors(struct block_device *bdev, sector_t sectors)<b=
r>
=C2=A0{<br>
-- <br>
2.28.0<br>
<br>
<br>
_______________________________________________<br>
Linux-nvme mailing list<br>
<a href=3D"mailto:Linux-nvme@lists.infradead.org" target=3D"_blank">Linux-n=
vme@lists.infradead.org</a><br>
<a href=3D"http://lists.infradead.org/mailman/listinfo/linux-nvme" rel=3D"n=
oreferrer" target=3D"_blank">http://lists.infradead.org/mailman/listinfo/li=
nux-nvme</a><br>
</blockquote></div></div>

--0000000000003da75005b37cf8d6--

--===============6150643606095609838==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
--===============6150643606095609838==--

