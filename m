Return-Path: <SRS0=bIvj=O3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 850ADC433F5
	for <dm-devel@archiver.kernel.org>; Thu,  7 Oct 2021 07:28:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0C8D2610C8
	for <dm-devel@archiver.kernel.org>; Thu,  7 Oct 2021 07:28:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0C8D2610C8
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1633591691;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0yXSgBNHO7jKVfdLY3R7Pk2316vPK7wKkF6MS2TS8EE=;
	b=Wyik1lwYPGDPktssH9P+qEvYfMKz5Fry+dMvqDkzkuQtn2iqJHU0Z32z2QPD61SWSTP1iP
	fahM+VFuUFHjOI4j30PnecEfl4EvrJc1jUaT/DswS9riJZN8Eq9GlIJJNjhvtakHOkQngm
	JVC+dU88GDprtQ+RVBjmCaiKUweTBvw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-vgz585STOzGp4WOH8AdsKg-1; Thu, 07 Oct 2021 03:28:08 -0400
X-MC-Unique: vgz585STOzGp4WOH8AdsKg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C41683DBC4;
	Thu,  7 Oct 2021 07:28:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8DB7A10013D7;
	Thu,  7 Oct 2021 07:28:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 54CEF1806D00;
	Thu,  7 Oct 2021 07:27:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 197770XD013017 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 7 Oct 2021 03:07:00 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 669D460657; Thu,  7 Oct 2021 07:07:00 +0000 (UTC)
Received: from T590 (ovpn-8-22.pek2.redhat.com [10.72.8.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C74D260583;
	Thu,  7 Oct 2021 07:06:58 +0000 (UTC)
Date: Thu, 7 Oct 2021 15:06:53 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <YV6cjZa3Dnnj46Nz@T590>
References: <20210923091131.1463013-1-ming.lei@redhat.com>
	<YV2vnlKScVXYvQMo@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YV2vnlKScVXYvQMo@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] dm-rq: don't queue request during suspend
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Oct 06, 2021 at 10:15:58AM -0400, Mike Snitzer wrote:
> On Thu, Sep 23 2021 at  5:11P -0400,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
> > DM uses blk-mq's quiesce/unquiesce to stop/start device mapper queue.
> > 
> > But blk-mq's unquiesce may come from outside events, such as elevator
> > switch, updating nr_requests or others, and request may come during
> > suspend, so simply ask for blk-mq to requeue it.
> > 
> > Fixes one kernel panic issue when running updating nr_requests and
> > dm-mpath suspend/resume stress test.
> > 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  drivers/md/dm-rq.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> > index 5b95eea517d1..a896dea9750e 100644
> > --- a/drivers/md/dm-rq.c
> > +++ b/drivers/md/dm-rq.c
> > @@ -490,6 +490,14 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
> >  	struct mapped_device *md = tio->md;
> >  	struct dm_target *ti = md->immutable_target;
> >  
> > +	/*
> > +	 * blk-mq's unquiesce may come from outside events, such as
> > +	 * elevator switch, updating nr_requests or others, and request may
> > +	 * come during suspend, so simply ask for blk-mq to requeue it.
> > +	 */
> > +	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)))
> > +		return BLK_STS_RESOURCE;
> > +
> >  	if (unlikely(!ti)) {
> >  		int srcu_idx;
> >  		struct dm_table *map = dm_get_live_table(md, &srcu_idx);
> > -- 
> > 2.31.1
> > 
> 
> Hey Ming,
> 
> I've marked this for stable@ and queued this up.  BUT this test is
> racey, could easily be that device gets suspended just after your
> test.

Hello Mike,

I understand the device shouldn't be suspended after the test given
it is just like the following two tasks running contiguously in the
test:

1) task1
- suspend device mapper
- resume device mapper

2) task2
- updating nr_requests of the device mapper

BTW, it is reported as RH BZ1891486 in which it is easily reproduced,
however, seems device suspended isn't observed.

thanks, 
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

