Return-Path: <SRS0=eE7R=JJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB249C433B4
	for <dm-devel@archiver.kernel.org>; Mon, 12 Apr 2021 11:42:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4BE6461261
	for <dm-devel@archiver.kernel.org>; Mon, 12 Apr 2021 11:42:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4BE6461261
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1618227770;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=F1oy0UNCd6bMdt+x/m93VDCX2UHzBdhBwAi3EsEOcio=;
	b=bC5dW3eRLIUk0qwiwJZvTvq4jf+l3SxAWEG1EMWraH2WoHm7mQLkn/Pz6XH/y2MhgY8AOn
	PoGea8xbvDkysY/XIXUOXib10drk9wAbXAQm4gtTU/HlLqOby1knTftowwwOTmYPQpR0AH
	03i4wjrgonC1tqKkGc4rNNzdWWGQaOY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-9GAOuCrYOpmmF5dtR6KHmw-1; Mon, 12 Apr 2021 07:42:48 -0400
X-MC-Unique: 9GAOuCrYOpmmF5dtR6KHmw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC4946D246;
	Mon, 12 Apr 2021 11:42:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B261F608DB;
	Mon, 12 Apr 2021 11:42:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7EB904ED86;
	Mon, 12 Apr 2021 11:42:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13CBggIb006677 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 12 Apr 2021 07:42:42 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4ECC01042AB0; Mon, 12 Apr 2021 11:42:42 +0000 (UTC)
Received: from T590 (ovpn-12-111.pek2.redhat.com [10.72.12.111])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 43FF6100AE4E;
	Mon, 12 Apr 2021 11:42:20 +0000 (UTC)
Date: Mon, 12 Apr 2021 19:42:17 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <YHQyGVQb48g5rYsJ@T590>
References: <20210401021927.343727-1-ming.lei@redhat.com>
	<20210401021927.343727-9-ming.lei@redhat.com>
	<20210412095427.GA987123@infradead.org> <YHQfB83n8dQSwD3O@T590>
	<20210412102947.GA998763@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20210412102947.GA998763@infradead.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Jeffle Xu <jefflexu@linux.alibaba.com>
Subject: Re: [dm-devel] [PATCH V5 08/12] block: use per-task poll context to
 implement bio based io polling
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Apr 12, 2021 at 11:29:47AM +0100, Christoph Hellwig wrote:
> On Mon, Apr 12, 2021 at 06:20:55PM +0800, Ming Lei wrote:
> > > > +static inline void *bio_grp_data(struct bio *bio)
> > > > +{
> > > > +	return bio->bi_poll;
> > > > +}
> > > 
> > > What is the purpose of this helper?  And why does it have to lose the
> > > type information?
> > 
> > This patch stores bio->bi_end_io(shared with ->bi_poll) into one per-task
> > data structure, and links all bios sharing same .bi_end_io into one list
> > via ->bi_end_io. And their ->bi_end_io is recovered before calling
> > bio_endio().
> > 
> > The helper is used for checking if one bio can be added to bio group,
> > and storing the data. The helper just serves for document purpose.
> > 
> > And the type info doesn't matter.
> 
> So why is bi_poll typed to start with then just to need a accessor
> to remove the typer information?

It should be a bug from the beginning, either .bi_poll can be dropped
or it should be 'void *'. Just find it, thanks for pointing it out.


Thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

