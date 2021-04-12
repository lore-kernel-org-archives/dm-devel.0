Return-Path: <SRS0=eE7R=JJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3304C433B4
	for <dm-devel@archiver.kernel.org>; Mon, 12 Apr 2021 14:35:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2C6776134F
	for <dm-devel@archiver.kernel.org>; Mon, 12 Apr 2021 14:35:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C6776134F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-HtSWGSMZMzuW6PnrzUqVbA-1; Mon, 12 Apr 2021 10:35:27 -0400
X-MC-Unique: HtSWGSMZMzuW6PnrzUqVbA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72C8E189C447;
	Mon, 12 Apr 2021 14:35:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E2D0819D61;
	Mon, 12 Apr 2021 14:35:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 251371806D15;
	Mon, 12 Apr 2021 14:35:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13CEZFD8026213 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 12 Apr 2021 10:35:15 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1862B2ED80; Mon, 12 Apr 2021 14:35:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1239D9D5A
	for <dm-devel@redhat.com>; Mon, 12 Apr 2021 14:35:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0091805F43
	for <dm-devel@redhat.com>; Mon, 12 Apr 2021 14:35:12 +0000 (UTC)
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com
	[209.85.166.171]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-591-YLHAnfZBNN6Wn_cgu8V8Aw-1; Mon, 12 Apr 2021 10:35:08 -0400
X-MC-Unique: YLHAnfZBNN6Wn_cgu8V8Aw-1
Received: by mail-il1-f171.google.com with SMTP id i22so6485312ila.11;
	Mon, 12 Apr 2021 07:35:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=nl+e8gruZE2jm3U6Sm5K1rbed6F1G7jwfaUBg/d7wnQ=;
	b=CRLgooTV2hwBJcQiAxIA3gSLDLKyoV2xXzmend6W3BCOUueyg+wVwA/tpzS5wd3n55
	ivQ+B7mHj3vWTj8IbC7HxDqVOk8yp3QzsFZs+YoQQ2yxo8lWoZ0m3j/1jpQVK1A3GMG8
	H47kv2zsS2UZp8FKW32Nn+UxtNGTMW21H47vuyllf/khKdmby8fraRLs5Ox36Fr9RVQ0
	JKjvAB7Chrb3PmhnxVwgTXAAuYG7pBqVIbCF06mYYTmQUL+ukeQH+/PyC7N/z2AHXE3t
	loXXG8nnr9fPUpkwCsts9t8t3zDq3Mt3+EzBv0ab2gRx8Zg5DBvhXuphN9Y2xA1Lu9TN
	FYkw==
X-Gm-Message-State: AOAM532pF9dAtoxs3iQ6fUfG8lRUEZFWIWZpCS/UtAwvOKBm9gg5ef9p
	dpKgl7rqtIDMc3B+YYok6HsfxrQVJ1sgzPY/jvg=
X-Google-Smtp-Source: ABdhPJzIyljg2UrVufiKLCV4AtEnX0lojUYHBV69oqiVNW99rdpYudFQX35/feDopBRdXXdq5MJ1SOwFrLXrR9vCLQU=
X-Received: by 2002:a05:6e02:11a9:: with SMTP id
	9mr13004896ilj.288.1618238107878; 
	Mon, 12 Apr 2021 07:35:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210219124517.79359-1-selvakuma.s1@samsung.com>
	<CGME20210219124603epcas5p33add0f2c1781b2a4d71bf30c9e1ac647@epcas5p3.samsung.com>
	<20210219124517.79359-3-selvakuma.s1@samsung.com>
	<BL0PR04MB6514EA91680D33A5890ECE16E7839@BL0PR04MB6514.namprd04.prod.outlook.com>
	<CAHqX9vb6GgaU9QdTQaq3=dGuoNCuWorLrGCF8gC5LEdFBESFcA@mail.gmail.com>
	<BL0PR04MB6514B34000467FABFD6BF385E7709@BL0PR04MB6514.namprd04.prod.outlook.com>
In-Reply-To: <BL0PR04MB6514B34000467FABFD6BF385E7709@BL0PR04MB6514.namprd04.prod.outlook.com>
From: Selva Jove <selvajove@gmail.com>
Date: Mon, 12 Apr 2021 20:04:55 +0530
Message-ID: <CAHqX9vYvtOaVL4LG0gAGCMz+a8uha8czH==Dgg3eG+TWA+xeVQ@mail.gmail.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "kch@kernel.org" <kch@kernel.org>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"nj.shetty@samsung.com" <nj.shetty@samsung.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"javier.gonz@samsung.com" <javier.gonz@samsung.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"joshiiitr@gmail.com" <joshiiitr@gmail.com>, "hch@lst.de" <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH v5 2/4] block: add simple copy support
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Apr 12, 2021 at 5:55 AM Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
>
> On 2021/04/07 20:33, Selva Jove wrote:
> > Initially I started moving the dm-kcopyd interface to the block layer
> > as a generic interface.
> > Once I dig deeper in dm-kcopyd code, I figured that dm-kcopyd is
> > tightly coupled with dm_io()
> >
> > To move dm-kcopyd to block layer, it would also require dm_io code to
> > be moved to block layer.
> > It would cause havoc in dm layer, as it is the backbone of the
> > dm-layer and needs complete
> > rewriting of dm-layer. Do you see any other way of doing this without
> > having to move dm_io code
> > or to have redundant code ?
>
> Right. Missed that. So reusing dm-kcopyd and making it a common interface will
> take some more efforts. OK, then. For the first round of commits, let's forget
> about this. But I still think that your emulation could be a lot better than a
> loop doing blocking writes after blocking reads.
>

Current implementation issues read asynchronously and once all the reads are
completed, then the write is issued as whole to reduce the IO traffic
in the queue.
I agree that things can be better. Will explore another approach of
sending writes
immediately once reads are completed and with  plugging to increase the chances
of merging.

> [...]
> >>> +int blkdev_issue_copy(struct block_device *src_bdev, int nr_srcs,
> >>> +             struct range_entry *src_rlist, struct block_device *dest_bdev,
> >>> +             sector_t dest, gfp_t gfp_mask, int flags)
> >>> +{
> >>> +     struct request_queue *q = bdev_get_queue(src_bdev);
> >>> +     struct request_queue *dest_q = bdev_get_queue(dest_bdev);
> >>> +     struct blk_copy_payload *payload;
> >>> +     sector_t bs_mask, copy_size;
> >>> +     int ret;
> >>> +
> >>> +     ret = blk_prepare_payload(src_bdev, nr_srcs, src_rlist, gfp_mask,
> >>> +                     &payload, &copy_size);
> >>> +     if (ret)
> >>> +             return ret;
> >>> +
> >>> +     bs_mask = (bdev_logical_block_size(dest_bdev) >> 9) - 1;
> >>> +     if (dest & bs_mask) {
> >>> +             return -EINVAL;
> >>> +             goto out;
> >>> +     }
> >>> +
> >>> +     if (q == dest_q && q->limits.copy_offload) {
> >>> +             ret = blk_copy_offload(src_bdev, payload, dest, gfp_mask);
> >>> +             if (ret)
> >>> +                     goto out;
> >>> +     } else if (flags & BLKDEV_COPY_NOEMULATION) {
> >>
> >> Why ? whoever calls blkdev_issue_copy() wants a copy to be done. Why would that
> >> user say "Fail on me if the device does not support copy" ??? This is a weird
> >> interface in my opinion.
> >>
> >
> > BLKDEV_COPY_NOEMULATION flag was introduced to allow blkdev_issue_copy() callers
> > to use their native copying method instead of the emulated copy that I
> > added. This way we
> > ensure that dm uses the hw-assisted copy and if that is not present,
> > it falls back to existing
> > copy method.
> >
> > The other users who don't have their native emulation can use this
> > emulated-copy implementation.
>
> I do not understand. Emulation or not should be entirely driven by the device
> reporting support for simple copy (or not). It does not matter which component
> is issuing the simple copy call: an FS to a real device, and FS to a DM device
> or a DM target driver. If the underlying device reported support for simple
> copy, use that. Otherwise, emulate with read/write. What am I missing here ?
>

blkdev_issue_copy() api will generally complete the copy-operation,
either by using
offloaded-copy or by using emulated-copy. The caller of the api is not
required to
figure the type of support. However, it can opt out of emulated-copy
by specifying
the flag BLKDEV_NOEMULATION. This is helpful for the case when the
caller already
has got a sophisticated emulation (e.g. dm-kcopyd users).

>
> [...]
> >>> @@ -565,6 +569,12 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
> >>>       if (b->chunk_sectors)
> >>>               t->chunk_sectors = gcd(t->chunk_sectors, b->chunk_sectors);
> >>>
> >>> +     /* simple copy not supported in stacked devices */
> >>> +     t->copy_offload = 0;
> >>> +     t->max_copy_sectors = 0;
> >>> +     t->max_copy_range_sectors = 0;
> >>> +     t->max_copy_nr_ranges = 0;
> >>
> >> You do not need this. Limits not explicitely initialized are 0 already.
> >> But I do not see why you can't support copy on stacked devices. That should be
> >> feasible taking the min() for each of the above limit.
> >>
> >
> > Disabling stacked device support was feedback from v2.
> >
> > https://patchwork.kernel.org/project/linux-block/patch/20201204094659.12732-2-selvakuma.s1@samsung.com/
>
> Right. But the initialization to 0 is still not needed. The fields are already
> initialized to 0.
>
>
> --
> Damien Le Moal
> Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

