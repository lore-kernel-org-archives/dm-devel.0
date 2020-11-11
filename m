Return-Path: <SRS0=f+1/=ER=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE4FC388F9
	for <dm-devel@archiver.kernel.org>; Wed, 11 Nov 2020 11:34:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 835982074B
	for <dm-devel@archiver.kernel.org>; Wed, 11 Nov 2020 11:34:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 835982074B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-qeOv2dvfPTuI7UBd7l11ug-1; Wed, 11 Nov 2020 06:34:16 -0500
X-MC-Unique: qeOv2dvfPTuI7UBd7l11ug-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D8F5835B74;
	Wed, 11 Nov 2020 11:34:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 478827366E;
	Wed, 11 Nov 2020 11:34:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 016A8180BAFF;
	Wed, 11 Nov 2020 11:34:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ABA70mF005535 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 11 Nov 2020 05:07:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0A8C82011567; Wed, 11 Nov 2020 10:07:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 05AAA20110C9
	for <dm-devel@redhat.com>; Wed, 11 Nov 2020 10:06:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9136990E420
	for <dm-devel@redhat.com>; Wed, 11 Nov 2020 10:06:57 +0000 (UTC)
Received: from mail-ej1-f68.google.com (mail-ej1-f68.google.com
	[209.85.218.68]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-422-GWYGSS79OqiDnCiOAPb9JQ-1; Wed, 11 Nov 2020 05:06:55 -0500
X-MC-Unique: GWYGSS79OqiDnCiOAPb9JQ-1
Received: by mail-ej1-f68.google.com with SMTP id i19so1947745ejx.9
	for <dm-devel@redhat.com>; Wed, 11 Nov 2020 02:06:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=8BVYeCUTuKi3mlr+D1JejV3WQ4DReZqKao2un+osJdI=;
	b=FviYv7+o8r5M70vOrY1CZ9N31vrDDGlBJ5Z3er7yOqqL9gkqWdoZJfcO0ssnvIoyCo
	ha/QBh7Z71nrQ+HicOJtpBCgNCImR19PTMOR19ewwEmIaqSPcfrHlkYZ0yQAs5Y8ubgl
	xEsGq1Bcbos3hN/UfBxCJFZeHLilMQ8CIEqZBGrgV8R0LvQWBvw0uLH67Jrmx5zLJ7Hf
	iCubIKgWWHaE9TywFCWnWNTRH7xIsy5e35wyU2cmi3V74z3922PvY5QdCYKJ4iRJxMUo
	7wnfKEDRBKJTD6osvIjWqlc3d3pqf5Ekhlz96ALvJz2NUblDCC9X6UOOLnnuLHkHp1ji
	q5/Q==
X-Gm-Message-State: AOAM530eyKfNI3aqIuhqBebxDMIrXuc2Zjf9sbsRvZyw945PxrhBAPt0
	NoGbz5O9CghBRmUUEom5/Pdb01877xeDRKXKMVg+Bg==
X-Google-Smtp-Source: ABdhPJzsSG4n+ejxAi7LIm+JtRF2XZ0Zmfdo/Dim1Bn2zjoT1vntwc6k1ciTHUd7GwTXoyYPdOeDF7UWMmfnel/IKPk=
X-Received: by 2002:a17:907:c05:: with SMTP id
	ga5mr19170455ejc.212.1605089213881; 
	Wed, 11 Nov 2020 02:06:53 -0800 (PST)
MIME-Version: 1.0
References: <20201111082658.3401686-1-hch@lst.de>
	<20201111082658.3401686-18-hch@lst.de>
	<CAOi1vP-JjnNdAUqd9Gy6YdFgi8Ev4_Jt3zcB9DhAmdAvQhG7Eg@mail.gmail.com>
In-Reply-To: <CAOi1vP-JjnNdAUqd9Gy6YdFgi8Ev4_Jt3zcB9DhAmdAvQhG7Eg@mail.gmail.com>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Wed, 11 Nov 2020 11:06:43 +0100
Message-ID: <CAMGffEmU1ezUo68zF8DS4CRZZMosqhmDw3h7uiWzh2nL8tUs9g@mail.gmail.com>
To: Ilya Dryomov <idryomov@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 11 Nov 2020 06:33:51 -0500
Cc: Justin Sanders <justin@coraid.com>, Mike Snitzer <snitzer@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, linux-nvme@lists.infradead.org,
	Song Liu <song@kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
	xen-devel@lists.xenproject.org,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Josef Bacik <josef@toxicpanda.com>, nbd@other.debian.org,
	linux-raid <linux-raid@vger.kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Lars Ellenberg <drbd-dev@tron.linbit.com>,
	Ceph Development <ceph-devel@vger.kernel.org>,
	Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Minchan Kim <minchan@kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] [PATCH 17/24] rbd: use set_capacity_and_notify
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Nov 11, 2020 at 10:55 AM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Wed, Nov 11, 2020 at 9:27 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > Use set_capacity_and_notify to set the size of both the disk and block
> > device.  This also gets the uevent notifications for the resize for free.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> > ---
> >  drivers/block/rbd.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> > index f84128abade319..b7a194ffda55b4 100644
> > --- a/drivers/block/rbd.c
> > +++ b/drivers/block/rbd.c
> > @@ -4920,8 +4920,7 @@ static void rbd_dev_update_size(struct rbd_device *rbd_dev)
> >             !test_bit(RBD_DEV_FLAG_REMOVING, &rbd_dev->flags)) {
> >                 size = (sector_t)rbd_dev->mapping.size / SECTOR_SIZE;
> >                 dout("setting size to %llu sectors", (unsigned long long)size);
> > -               set_capacity(rbd_dev->disk, size);
> > -               revalidate_disk_size(rbd_dev->disk, true);
> > +               set_capacity_and_notify(rbd_dev->disk, size);
> >         }
> >  }
> >
> > --
> > 2.28.0
> >
>
> Hi Christoph,
>
> The Acked-by is wrong here.  I acked this patch (17/24, rbd), and Jack
> acked the next one (18/24, rnbd).
right. :)
>
> Thanks,
>
>                 Ilya

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

