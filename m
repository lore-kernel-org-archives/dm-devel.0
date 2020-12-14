Return-Path: <SRS0=pYhN=FS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E841C4361B
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 11:01:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9845522CB1
	for <dm-devel@archiver.kernel.org>; Mon, 14 Dec 2020 11:01:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9845522CB1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-djLx3foDP6CcEdguYnwMRg-1; Mon, 14 Dec 2020 06:01:07 -0500
X-MC-Unique: djLx3foDP6CcEdguYnwMRg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 684496D549;
	Mon, 14 Dec 2020 11:00:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 495047047D;
	Mon, 14 Dec 2020 11:00:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E9C375002D;
	Mon, 14 Dec 2020 11:00:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BE6vuFa006269 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Dec 2020 01:57:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D79C31111C89; Mon, 14 Dec 2020 06:57:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D38331111C88
	for <dm-devel@redhat.com>; Mon, 14 Dec 2020 06:57:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BCA708007D9
	for <dm-devel@redhat.com>; Mon, 14 Dec 2020 06:57:53 +0000 (UTC)
Received: from mail-ed1-f67.google.com (mail-ed1-f67.google.com
	[209.85.208.67]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-473-Sr1PcYNyPjqonYkdAS2o7Q-1; Mon, 14 Dec 2020 01:57:49 -0500
X-MC-Unique: Sr1PcYNyPjqonYkdAS2o7Q-1
Received: by mail-ed1-f67.google.com with SMTP id cw27so15996199edb.5;
	Sun, 13 Dec 2020 22:57:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=SBDQ/ozr1+cMGjDjwKraN3A/q+s0aVrfJg3tJsBwW/c=;
	b=nGcqDd+LCrZvbyVGw1vYDp6YMfyRqChk+vakqfzc9BV9qBMRtb3AT6RZTMcaHEi/yN
	9qMNQjej0/FInLrShP0MA2YFOnVo7ICvpWRRDov9m1qkHBS6+gDwwhde2eU8qGXgVZm7
	zGJWpnR1/ahiQhc82cqIKnElWptvxKpB4/NxEcf3yjin+CyzJ/UDMKYpFXg0obQKm6qK
	bxIrJq9fkf+6pTb1qFHKMBU3q20arDKlyvcH81fUEb3sAbH1hkqTNdvlPSBnUBgLCtg1
	JjELuDuaue9ODIRsl7L6Cb21OfnCnofpcx4+LxUeI+XPCaavaOSf7TK/1CZ4OkZWOxtB
	ApIQ==
X-Gm-Message-State: AOAM5331sTbYoonHbpuGqD0atyYcpP+0VMLm+Sy0qHRF6Ybvq0n+7Wfu
	sFL/zl8bE02sUDwp0WouWCd6XKqkzgfiKsByNcAiXG9peB0=
X-Google-Smtp-Source: ABdhPJy9fRCeat4gb5XKvmqoE7tXBBH2nVrfV3qBRQb1jokU/DqVjpgFa/P//03AdoLMtwqozlQM7SSYPoT/nhq5KVs=
X-Received: by 2002:a05:6402:17a3:: with SMTP id
	j3mr23295833edy.333.1607929067913; 
	Sun, 13 Dec 2020 22:57:47 -0800 (PST)
MIME-Version: 1.0
References: <20201211135139.49232-1-selvakuma.s1@samsung.com>
	<CGME20201211135200epcas5p217eaa00b35a59b3468c198d85309fd7d@epcas5p2.samsung.com>
	<20201211135139.49232-2-selvakuma.s1@samsung.com>
	<20201211180451.GA9103@redsun51.ssa.fujisawa.hgst.com>
In-Reply-To: <20201211180451.GA9103@redsun51.ssa.fujisawa.hgst.com>
From: Selva Jove <selvajove@gmail.com>
Date: Mon, 14 Dec 2020 12:27:32 +0530
Message-ID: <CAHqX9vYFudV1WX-R0oRBW7rKpCJzt_DgmW9FWZdDzOwMoCxfCw@mail.gmail.com>
To: Keith Busch <kbusch@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 14 Dec 2020 06:00:28 -0500
Cc: axboe@kernel.dk, Damien Le Moal <damien.lemoal@wdc.com>,
	SelvaKumar S <selvakuma.s1@samsung.com>, sagi@grimberg.me,
	linux-scsi@vger.kernel.org,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	snitzer@redhat.com, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, nj.shetty@samsung.com,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	mpatocka@redhat.com, martin.petersen@oracle.com,
	joshi.k@samsung.com, javier.gonz@samsung.com, hch@lst.de,
	bvanassche@acm.org
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Dec 11, 2020 at 11:35 PM Keith Busch <kbusch@kernel.org> wrote:
>
> On Fri, Dec 11, 2020 at 07:21:38PM +0530, SelvaKumar S wrote:
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
>
> The default value for this limit is 0, and this is the function for when
> the device doesn't support copy. Are we expecting drivers to set this
> value to something else for that case?

Sorry. Missed that. Will add a fix.

>
> > +     cur_dest = payload->dest;
> > +     buf = kvmalloc(max_range_len, GFP_ATOMIC);
> > +     if (!buf)
> > +             return -ENOMEM;
> > +
> > +     for (i = 0; i < nr_srcs; i++) {
> > +             bio = bio_alloc(gfp_mask, 1);
> > +             bio->bi_iter.bi_sector = payload->range[i].src;
> > +             bio->bi_opf = REQ_OP_READ;
> > +             bio_set_dev(bio, bdev);
> > +
> > +             cur_size = payload->range[i].len << SECTOR_SHIFT;
> > +             ret = bio_add_page(bio, virt_to_page(buf), cur_size,
> > +                                                offset_in_page(payload));
>
> 'buf' is vmalloc'ed, so we don't necessarily have congituous pages. I
> think you need to allocate the bio with bio_map_kern() or something like
> that instead with that kind of memory.
>

Sure. Will use bio_map_kern().

> > +             if (ret != cur_size) {
> > +                     ret = -ENOMEM;
> > +                     goto out;
> > +             }
> > +
> > +             ret = submit_bio_wait(bio);
> > +             bio_put(bio);
> > +             if (ret)
> > +                     goto out;
> > +
> > +             bio = bio_alloc(gfp_mask, 1);
> > +             bio_set_dev(bio, bdev);
> > +             bio->bi_opf = REQ_OP_WRITE;
> > +             bio->bi_iter.bi_sector = cur_dest;
> > +             ret = bio_add_page(bio, virt_to_page(buf), cur_size,
> > +                                                offset_in_page(payload));
> > +             if (ret != cur_size) {
> > +                     ret = -ENOMEM;
> > +                     goto out;
> > +             }
> > +
> > +             ret = submit_bio_wait(bio);
> > +             bio_put(bio);
> > +             if (ret)
> > +                     goto out;
> > +
> > +             cur_dest += payload->range[i].len;
> > +     }
>
> I think this would be a faster implementation if the reads were
> asynchronous with a payload buffer allocated specific to that read, and
> the callback can enqueue the write part. This would allow you to
> accumulate all the read data and write it in a single call.

Sounds like a better approach. Will add this implementation in v4.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

