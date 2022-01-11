Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8C89C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 11 Jan 2022 02:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1641867994;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mla9Vd35XYPPr+yP8YLxPX5LgkFQGyCdPkgjHSxhs6k=;
	b=J9na3x6QAqzc6c3/th18EWqTAuNa/4J32ORp6HVpMMD/SVhY+NvbqjKHLvqR2W7k+HcHpi
	Zyn6w1HY5iuSwhHlZFZ/vaHxOrHlQWBxm8C0gdhskaOe0l12X26YmvG7ztNieJxwogq4+5
	2zwmnyjpxuwjGz/zpCBkDBCojXrcDiE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-43-daiY_k69PgywARhRQyF3ig-1; Mon, 10 Jan 2022 21:26:33 -0500
X-MC-Unique: daiY_k69PgywARhRQyF3ig-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C8018143ED;
	Tue, 11 Jan 2022 02:26:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B85181948C;
	Tue, 11 Jan 2022 02:26:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1BD714BB7C;
	Tue, 11 Jan 2022 02:26:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20B2QNfm001416 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 10 Jan 2022 21:26:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B8E35519A3; Tue, 11 Jan 2022 02:26:23 +0000 (UTC)
Received: from T590 (ovpn-8-21.pek2.redhat.com [10.72.8.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C5E1519A2;
	Tue, 11 Jan 2022 02:26:14 +0000 (UTC)
Date: Tue, 11 Jan 2022 10:26:09 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <Ydzqwc7F4N1TTJ0O@T590>
References: <20220110075141.389532-1-ming.lei@redhat.com>
	<20220110075141.389532-2-ming.lei@redhat.com>
	<YdxuWlZAPJkPyr3h@infradead.org> <YdyC9KpQ7yC3l7RZ@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YdyC9KpQ7yC3l7RZ@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
	lining <lining2020x@163.com>, Tejun Heo <tj@kernel.org>,
	Chunguang Xu <brookxu@tencent.com>
Subject: Re: [dm-devel] [PATCH 1/2] block: add resubmit_bio_noacct()
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jan 10, 2022 at 02:03:16PM -0500, Mike Snitzer wrote:
> On Mon, Jan 10 2022 at 12:35P -0500,
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Mon, Jan 10, 2022 at 03:51:40PM +0800, Ming Lei wrote:
> > > Add block layer API of resubmit_bio_noacct() for handling blk-throttle
> > > iops limit correctly. Typical use case is that bio split, and it isn't
> > > good to export blk_throtl_charge_bio_split() for drivers, so add new API
> > > for serving such purpose.
> > 
> > Umm, submit_bio_noacct is meant exactly for this case of resubmitting
> > a bio.  We should not need another API for that.
> > 
> 
> Ming is lifting code out of __blk_queue_split() for reuse (by DM in
> this instance, because it has its own bio_split+bio_chain).
> 
> Are you saying submit_bio_noacct() should be made to call
> blk_throtl_charge_bio_split() and blk_throtl_charge_bio_split() simply
> return if not a split bio? (not sure bio has enough context to know,

DM or MD may submit split bio to underlying queue directly, so we can't
do that simply. Also some FS may call bio_split() too.

Or we simply let blk_throtl_bio cover everything? That is basically
what V1 did, and the only issue is that we can't run the account
in case that submit_bio_noacct() is called from blk_throtl_dispatch_work_fn().

> other than looking at some side-effect change from bio_chain)
> 
> But Ming: your __blk_queue_split() change seems wrong.
> Prior to your patch __blk_queue_split() did:
> 
> bio_chain(split, *bio);
> submit_bio_noacct(*bio);
> *bio = split;
> blk_throtl_charge_bio_split(*bio);
> 
> After your patch (effectively):
> 
> bio_chain(split, *bio);
> submit_bio_noacct(*bio);
> blk_throtl_charge_bio_split(bio);
> *bio = split;
> 
> Maybe that was intended? (or maybe it doesn't matter because bio_split
> copies fields with bio_clone_fast())?  Regardless, it is subtle.

It doesn't matter, blk_throtl_charge_bio_split() just accounts bio
number, here the split bio is submitted to the same queue.

> 
> Should blk_throtl_charge_bio_split() just be pushed down to
> bio_split()?

It is fragile, will the bio allocated from bio_split() always
submitted finally? or submitted to same queue?

> 
> In general, such narrow hacks for how to properly resubmit split bios
> are asking for further trouble.

I don't think it is hacks, it is one approach which has been verified as
workable in blk-mq.

> As is, I'm having to triage new
> reports of bio-based accounting issues (which has called into question
> my hack/fix commit a1e1cb72d9649 ("dm: fix redundant IO accounting for
> bios that need splitting") that papered over this bigger issue of
> needing proper split IO accounting, so likely needs to be revisited).

Here the issue is just about bio number accounting.

BTW, maybe you can follow blk-mq's way: just account after io is split,
such as, move start_io_acct() to the end of __split_and_process_non_flush(),
then you can just account io start once.


Thanks, 
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

