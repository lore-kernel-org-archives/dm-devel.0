Return-Path: <SRS0=NHnu=EJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 855AFC2D0A3
	for <dm-devel@archiver.kernel.org>; Tue,  3 Nov 2020 14:49:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E28F42242F
	for <dm-devel@archiver.kernel.org>; Tue,  3 Nov 2020 14:49:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NEMnwyMC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E28F42242F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1604414954;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/V7OLYi7AM4omqHXgP0nXhYcGHmQ5QKhtcMNFLX+hB0=;
	b=NEMnwyMCbTMDpsMtWt7YX+Lykm3VVbCwoZjjqol/jpVCF3PWfoa0jPQUJ6oAeyu1miVmGY
	LnHXpychSugg2qT2f7qMgvFKf5NW+g4GCZOx+8l3OibLwqguVK7KLZ15QASXjk1cZ3JjJY
	+KUyA6qpcWbgAx9WCsHvrzYHmC2cJq0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-gIpc3YirM4-2BF7h1MPVoQ-1; Tue, 03 Nov 2020 09:49:12 -0500
X-MC-Unique: gIpc3YirM4-2BF7h1MPVoQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62FA71842170;
	Tue,  3 Nov 2020 14:49:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BC2E60BF1;
	Tue,  3 Nov 2020 14:49:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 21D261826D35;
	Tue,  3 Nov 2020 14:49:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A3EmwXt032521 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 3 Nov 2020 09:48:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E17D7747C6; Tue,  3 Nov 2020 14:48:58 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C297D75127;
	Tue,  3 Nov 2020 14:48:55 +0000 (UTC)
Date: Tue, 3 Nov 2020 08:48:25 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Jeffle Xu <jefflexu@linux.alibaba.com>
Message-ID: <20201103134824.GA26430@redhat.com>
References: <20201103092329.17694-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <20201103092329.17694-1-jefflexu@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: joseph.qi@linux.alibaba.com, dm-devel@redhat.com
Subject: Re: [dm-devel] Why queue_work unneeded for REQUEUE bio
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 03 2020 at  4:23am -0500,
Jeffle Xu <jefflexu@linux.alibaba.com> wrote:

> Hi Mike,
> 
> Why queue_work() is unnecessary here for bio with BLK_STS_DM_REQUEUE
> returned?
> 
> Thanks
> Jeffle Xu
> 
> ---
>  drivers/md/dm.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index c18fc2548518..ae550daa99b5 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -908,9 +908,11 @@ static void dec_pending(struct dm_io *io, blk_status_t error)
>  			 * Target requested pushing back the I/O.
>  			 */
>  			spin_lock_irqsave(&md->deferred_lock, flags);
> -			if (__noflush_suspending(md))
> +			if (__noflush_suspending(md)) {
>  				/* NOTE early return due to BLK_STS_DM_REQUEUE below */
>  				bio_list_add_head(&md->deferred, io->orig_bio);
> +				queue_work(md->wq, &md->work);
> +			}
>  			else
>  				/* noflush suspend was interrupted. */
>  				io->status = BLK_STS_IOERR;
> -- 
> 2.27.0
> 

For the case you highlighted (BLK_STS_DM_REQUEUE + __noflush_suspending)
I think the missing queue_work is because we're actively dealing with
the fact that we do _not_ want to flush IO.  SO kicking the workqueue
there isn't helpful because it just processes work that cannot be issued
yet -- the workqueue will be kicked upon resume (see __dm_resume's
dm_queue_flush).

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

