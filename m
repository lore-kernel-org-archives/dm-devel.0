Return-Path: <SRS0=pYhN=FS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17783C1B0E3
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 11:01:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7D8B122CB1
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 11:01:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D8B122CB1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-veRrxnOIP5-szt5Jmw0jMA-1; Mon, 14 Dec 2020 06:01:05 -0500
X-MC-Unique: veRrxnOIP5-szt5Jmw0jMA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86A0D1926DB8;
	Mon, 14 Dec 2020 11:00:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 15B6171C94;
	Mon, 14 Dec 2020 11:00:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DAD5E1809C9F;
	Mon, 14 Dec 2020 11:00:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BE77Ves006929 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Dec 2020 02:07:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D8A6944056; Mon, 14 Dec 2020 07:07:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D31BF44055
	for <dm-devel@redhat.com>; Mon, 14 Dec 2020 07:07:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89703858EEC
	for <dm-devel@redhat.com>; Mon, 14 Dec 2020 07:07:29 +0000 (UTC)
Received: from mail-ej1-f68.google.com (mail-ej1-f68.google.com
	[209.85.218.68]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-155-qc7m9LAmO_mXML3h-r3iDQ-1; Mon, 14 Dec 2020 02:07:25 -0500
X-MC-Unique: qc7m9LAmO_mXML3h-r3iDQ-1
Received: by mail-ej1-f68.google.com with SMTP id jx16so21033320ejb.10;
	Sun, 13 Dec 2020 23:07:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=QWzR/ajntQQ8OUu1eo9cHzjXBqYXTELyiik0EYAgp6c=;
	b=s+i2DzC6Xsdks0C3BwyF/rb1BjZhKCJnpyzFPdk+eELr6Yk10U6LQwKpdagVIMbIDK
	t6TRMsT4nFYy8DMRR0qBpEEDgfPzPoOL+aej+GUfjoF2NAYxvRDzJoQ6251KJRMjSChL
	pcSZyfz2wYbemUo5DM1/o8Svuzj8c3qj3j3Vl+mWSXmqwqYfECrOFdXkowka8W+omZdD
	sQdQdXiji5oBpRxMqQAaVRkjy4cRFSszUvAJWh7hK3PGvW48SWb+l5qPo5izviGNadWo
	cUd6Ys8gE1d09lcUuKby5nZ9yFVmyRj0Ly/5qpeQizxL/NiwXkFiRlVOCHP6JrtKGWOz
	V/+A==
X-Gm-Message-State: AOAM5306Awq3UTphoL91pVqBVcgIAB2CNLjFY8gKzP3HKx+XV8KBoMTO
	y3QpZpZmPFFFFATrfVrKf3P7T7KTE+VGQ+nNAdA=
X-Google-Smtp-Source: ABdhPJznXbr+iFcyZQ0stzB05Z3JXUu6f2/PCyWYcbP3IUZ3HcqQL6yvr7ZEoaMx/h/x22bIeETtTTVWUHBtMe+z7b0=
X-Received: by 2002:a17:906:68d1:: with SMTP id
	y17mr21530318ejr.447.1607929643589; 
	Sun, 13 Dec 2020 23:07:23 -0800 (PST)
MIME-Version: 1.0
References: <20201211135139.49232-1-selvakuma.s1@samsung.com>
	<CGME20201211135200epcas5p217eaa00b35a59b3468c198d85309fd7d@epcas5p2.samsung.com>
	<20201211135139.49232-2-selvakuma.s1@samsung.com>
	<SN4PR0401MB359867B95139ACD1ACFF0E709BCA0@SN4PR0401MB3598.namprd04.prod.outlook.com>
In-Reply-To: <SN4PR0401MB359867B95139ACD1ACFF0E709BCA0@SN4PR0401MB3598.namprd04.prod.outlook.com>
From: Selva Jove <selvajove@gmail.com>
Date: Mon, 14 Dec 2020 12:37:08 +0530
Message-ID: <CAHqX9vYfGONfavB1hLRtdeSwhU6VWrPLzXFfmgwkB6-pgB9o7g@mail.gmail.com>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
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
X-Mailman-Approved-At: Mon, 14 Dec 2020 06:00:28 -0500
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"nj.shetty@samsung.com" <nj.shetty@samsung.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"javier.gonz@samsung.com" <javier.gonz@samsung.com>,
	"hch@lst.de" <hch@lst.de>, "bvanassche@acm.org" <bvanassche@acm.org>
Subject: Re: [dm-devel] [RFC PATCH v3 1/2] block: add simple copy support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Dec 11, 2020 at 9:56 PM Johannes Thumshirn
<Johannes.Thumshirn@wdc.com> wrote:
>
> On 11/12/2020 15:57, SelvaKumar S wrote:
> [...]
> > +int blk_copy_emulate(struct block_device *bdev, struct blk_copy_payload *payload,
> > +             gfp_t gfp_mask)
> > +{
> > +     struct request_queue *q = bdev_get_queue(bdev);
> > +     struct bio *bio;
> > +     void *buf = NULL;
> > +     int i, nr_srcs, max_range_len, ret, cur_dest, cur_size;
> > +
> > +     nr_srcs = payload->copy_range;
> > +     max_range_len = q->limits.max_copy_range_sectors << SECTOR_SHIFT;
> > +     cur_dest = payload->dest;
> > +     buf = kvmalloc(max_range_len, GFP_ATOMIC);
>
> Why GFP_ATOMIC and not the passed in gfp_mask? Especially as this is a kvmalloc()
> which has the potential to grow quite big.
>
> > +int __blkdev_issue_copy(struct block_device *bdev, sector_t dest,
> > +             sector_t nr_srcs, struct range_entry *rlist, gfp_t gfp_mask,
> > +             int flags, struct bio **biop)
> > +{
>
> [...]
>
> > +     total_size = struct_size(payload, range, nr_srcs);
> > +     payload = kmalloc(total_size, GFP_ATOMIC | __GFP_NOWARN);
>
> Same here.
>
>
> > diff --git a/block/ioctl.c b/block/ioctl.c
> > index 6b785181344f..a4a507d85e56 100644
> > --- a/block/ioctl.c
> > +++ b/block/ioctl.c
> > @@ -142,6 +142,47 @@ static int blk_ioctl_discard(struct block_device *bdev, fmode_t mode,
> >                                   GFP_KERNEL, flags);
> >  }
> >
> > +static int blk_ioctl_copy(struct block_device *bdev, fmode_t mode,
> > +             unsigned long arg, unsigned long flags)
> > +{
>
> [...]
>
> > +
> > +     rlist = kmalloc_array(crange.nr_range, sizeof(*rlist),
> > +                     GFP_ATOMIC | __GFP_NOWARN);
>
> And here. I think this one can even be GFP_KERNEL.
>
>
>

Thanks. Will fix this.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

