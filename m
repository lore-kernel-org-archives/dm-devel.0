Return-Path: <SRS0=/efG=IB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D6FC433E0
	for <dm-devel@archiver.kernel.org>; Wed,  3 Mar 2021 10:05:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4393D64EEB
	for <dm-devel@archiver.kernel.org>; Wed,  3 Mar 2021 10:05:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4393D64EEB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1614765952;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vLs+wakl5Jg3kfIkNfIcLPRF+t+TDu+xRyznm6SR3ks=;
	b=ZLL0IEw+EWHBR5G1ldym4vdI6fDY+WCAhleC6ReQwSw8lLjLV6qIDKu6rs1VGNzM/ILqUT
	XYElxGFLcWGhj49N8XFQM7drQClCoE4eW0xULAIhanfeMxjoANitvF1vOrCda7Y9m8RRbB
	jaUuBKXh2gq5FRJS2UC+5tV7Ud+K3q0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-1CX3LUsuP5GSiWmjxepKvw-1; Wed, 03 Mar 2021 05:05:49 -0500
X-MC-Unique: 1CX3LUsuP5GSiWmjxepKvw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7EB68107ACE4;
	Wed,  3 Mar 2021 10:05:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CE05C5D9C6;
	Wed,  3 Mar 2021 10:05:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C2EE14E58D;
	Wed,  3 Mar 2021 10:05:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 123A5avK023001 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Mar 2021 05:05:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4B23410013DB; Wed,  3 Mar 2021 10:05:36 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 84D3410013C1;
	Wed,  3 Mar 2021 10:05:32 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 123A5VJq001824; Wed, 3 Mar 2021 05:05:31 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 123A5Uda001816; Wed, 3 Mar 2021 05:05:31 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Wed, 3 Mar 2021 05:05:30 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: JeffleXu <jefflexu@linux.alibaba.com>
In-Reply-To: <3e8b3b2e-f1f4-e946-4858-d2c78e2a8825@linux.alibaba.com>
Message-ID: <alpine.LRH.2.02.2103030430080.29593@file01.intranet.prod.int.rdu2.redhat.com>
References: <20210302190552.715551440@debian-a64.vm>
	<3e8b3b2e-f1f4-e946-4858-d2c78e2a8825@linux.alibaba.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, Mike Snitzer <msnitzer@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>, caspar@linux.alibaba.com,
	hch@lst.de, linux-block@vger.kernel.org,
	joseph.qi@linux.alibaba.com, dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 2/4] block: dont clear REQ_HIPRI for
 bio-based drivers
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Wed, 3 Mar 2021, JeffleXu wrote:

> 
> 
> On 3/3/21 3:05 AM, Mikulas Patocka wrote:
> > Don't clear REQ_HIPRI for bio-based drivers. Device mapper will need to
> > see this flag in order to support polling.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > ---
> >  block/blk-core.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: linux-2.6/block/blk-core.c
> > ===================================================================
> > --- linux-2.6.orig/block/blk-core.c	2021-03-02 10:43:28.000000000 +0100
> > +++ linux-2.6/block/blk-core.c	2021-03-02 10:53:50.000000000 +0100
> 
> I notice that the diff header indicates that the code base is from
> linux-2.6. Or it's just the name of your directory, while the code base
> is for the latest upstream 5.12?

It's just the name of the git repository. The patch is against 5.12-rc1.

> 
> > @@ -836,7 +836,7 @@ static noinline_for_stack bool submit_bi
> >  		}
> >  	}
> >  
> > -	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
> > +	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && !bdev->bd_disk->fops->submit_bio)
> >  		bio->bi_opf &= ~REQ_HIPRI;
> >  
> >  	switch (bio_op(bio)) {
> > 
> > --
> 
> What if dm device is built upon mq devices that are not capable of
> polling, i.e., mq devices without QUEUE_FLAG_POLL set? Then this dm
> device shall not support polling.

We will check if the underlying queue has QUEUE_FLAG_POLL in __map_bio - 
see this piece of code:

        case DM_MAPIO_REMAPPED:
                /* the bio has been remapped so dispatch it */
                trace_block_bio_remap(clone, bio_dev(io->orig_bio), sector);
                if (clone->bi_opf & REQ_HIPRI &&
                    test_bit(QUEUE_FLAG_POLL, &clone->bi_bdev->bd_disk->queue->queue_flags)) {
                        ci->poll_queue = clone->bi_bdev->bd_disk->queue;
                        ci->poll_cookie = submit_bio_noacct_mq_direct(clone);
                } else {
                        ci->poll_cookie = BLK_QC_T_NONE;
                        submit_bio_noacct(clone);
                }
                break;

Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

