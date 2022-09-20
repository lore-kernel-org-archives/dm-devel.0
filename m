Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C606AC54EE9
	for <dm-devel@archiver.kernel.org>; Tue, 20 Sep 2022 17:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663696053;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=szUVOm1dXL1p34x8KNeVKF6F5PU4SdZcuu0xXjH98yU=;
	b=GeVipnPxdN0KfzPo2KlhYOPPRWlp8I+Y60qHyPJtlTjEUT8EvAKSiKjbtyfMLgvNjuZHuC
	PVslcDuT/+zXqVrpJdM9hvkx/cgURyBE395CJjC1C0Mmzz1xiJmEayH91eQXmhKNbSyA14
	tHXQEBPGtw8+nEK9HvZJus4HOUKXUEA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-DEG4UzHmNWqIUx_SsIePpA-1; Tue, 20 Sep 2022 13:47:30 -0400
X-MC-Unique: DEG4UzHmNWqIUx_SsIePpA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA00C80206D;
	Tue, 20 Sep 2022 17:47:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A95612166B26;
	Tue, 20 Sep 2022 17:47:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 872AE1946589;
	Tue, 20 Sep 2022 17:47:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4ABCB1946588
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Sep 2022 17:47:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3C3F92166B26; Tue, 20 Sep 2022 17:47:27 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 28C3D2166B29;
 Tue, 20 Sep 2022 17:47:27 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 28KHlRS5025532; Tue, 20 Sep 2022 13:47:27 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 28KHlR3D025528; Tue, 20 Sep 2022 13:47:27 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Tue, 20 Sep 2022 13:47:27 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Christoph Hellwig <hch@infradead.org>
In-Reply-To: <YyluKtwOaLSPvNmI@infradead.org>
Message-ID: <alpine.LRH.2.02.2209201309270.22306@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2209151604410.13231@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2209160459470.543@file01.intranet.prod.int.rdu2.redhat.com>
 <YyluKtwOaLSPvNmI@infradead.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 3/4] brd: enable discard
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
 dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Tue, 20 Sep 2022, Christoph Hellwig wrote:

> > @@ -289,6 +308,23 @@ static void brd_submit_bio(struct bio *b
> >  	struct bio_vec bvec;
> >  	struct bvec_iter iter;
> >  
> > +	if (bio_op(bio) == REQ_OP_DISCARD) {
> > +		sector_t len = bio_sectors(bio);
> > +		sector_t front_pad = -sector & (PAGE_SECTORS - 1);
> > +		sector += front_pad;
> > +		if (unlikely(len <= front_pad))
> > +			goto endio;
> > +		len -= front_pad;
> > +		len = round_down(len, PAGE_SECTORS);
> > +		while (len) {
> > +			brd_free_page(brd, sector);
> > +			sector += PAGE_SECTORS;
> > +			len -= PAGE_SECTORS;
> > +			cond_resched();
> > +		}
> > +		goto endio;
> > +	}
> > +
> >  	bio_for_each_segment(bvec, bio, iter) {
> 
> Please add separate helpers to each type of IO and just make the
> main submit_bio method a dispatch on the types instead of this
> spaghetti code.
> 
> > +	disk->queue->limits.discard_granularity = PAGE_SIZE;
> > +	blk_queue_max_discard_sectors(disk->queue, UINT_MAX);
> 
> We'll probably want an opt in for this new feature.

OK. I addressed these concerns and I'll send a second version of the patch 
set.

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

