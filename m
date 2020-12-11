Return-Path: <SRS0=jAWR=FP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D0B5C4361B
	for <dm-devel@archiver.kernel.org>; Fri, 11 Dec 2020 17:04:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C961423329
	for <dm-devel@archiver.kernel.org>; Fri, 11 Dec 2020 17:04:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C961423329
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1607706248;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=UA/4z4G0KjmAglGV7r9sxizIrrzD3nttzUGN4iokDm8=;
	b=V0TcL7AqSjYkufkRAfL0uvxQe+u/hPr6+C2mBaWKIQ4wh8x9/sdDvX3NI1byM8pj2VPTGT
	PP9b2xe9WRYiKy5QuQ9Seps90Pj2C/1KnzzzwaxitpkZA0fazf0tNA5g2DVTQERgxt+bho
	q1hMSKPwnvGJHbw7LwAaQ57gLNsGnmc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-POhlZdiVNdaAqr7C1h3Y5A-1; Fri, 11 Dec 2020 12:04:05 -0500
X-MC-Unique: POhlZdiVNdaAqr7C1h3Y5A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74423800D62;
	Fri, 11 Dec 2020 17:03:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B92EC10013C0;
	Fri, 11 Dec 2020 17:03:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5FAD04A7C6;
	Fri, 11 Dec 2020 17:03:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BBH3tNe021179 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Dec 2020 12:03:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DC4866F447; Fri, 11 Dec 2020 17:03:55 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 77E0F60BD9;
	Fri, 11 Dec 2020 17:03:55 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 0BBH3t1k028577; Fri, 11 Dec 2020 12:03:55 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 0BBH3q7E028573; Fri, 11 Dec 2020 12:03:52 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Fri, 11 Dec 2020 12:03:52 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
In-Reply-To: <SN4PR0401MB359867B95139ACD1ACFF0E709BCA0@SN4PR0401MB3598.namprd04.prod.outlook.com>
Message-ID: <alpine.LRH.2.02.2012111200490.27753@file01.intranet.prod.int.rdu2.redhat.com>
References: <20201211135139.49232-1-selvakuma.s1@samsung.com>
	<CGME20201211135200epcas5p217eaa00b35a59b3468c198d85309fd7d@epcas5p2.samsung.com>
	<20201211135139.49232-2-selvakuma.s1@samsung.com>
	<SN4PR0401MB359867B95139ACD1ACFF0E709BCA0@SN4PR0401MB3598.namprd04.prod.outlook.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"selvajove@gmail.com" <selvajove@gmail.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"nj.shetty@samsung.com" <nj.shetty@samsung.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Fri, 11 Dec 2020, Johannes Thumshirn wrote:

> On 11/12/2020 15:57, SelvaKumar S wrote:
> [...] 
> > +int blk_copy_emulate(struct block_device *bdev, struct blk_copy_payload *payload,
> > +		gfp_t gfp_mask)
> > +{
> > +	struct request_queue *q = bdev_get_queue(bdev);
> > +	struct bio *bio;
> > +	void *buf = NULL;
> > +	int i, nr_srcs, max_range_len, ret, cur_dest, cur_size;
> > +
> > +	nr_srcs = payload->copy_range;
> > +	max_range_len = q->limits.max_copy_range_sectors << SECTOR_SHIFT;
> > +	cur_dest = payload->dest;
> > +	buf = kvmalloc(max_range_len, GFP_ATOMIC);
> 
> Why GFP_ATOMIC and not the passed in gfp_mask? Especially as this is a kvmalloc()
> which has the potential to grow quite big.

You are right, this is confusing.

There's this piece of code at the top of kvmalloc_node:
        if ((flags & GFP_KERNEL) != GFP_KERNEL)
                return kmalloc_node(size, flags, node);

So, when you use GFP_ATOMIC flag, it will always fall back to kmalloc.

Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

