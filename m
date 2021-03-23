Return-Path: <SRS0=HPtm=IV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C07CC433C1
	for <dm-devel@archiver.kernel.org>; Tue, 23 Mar 2021 12:01:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 893206191C
	for <dm-devel@archiver.kernel.org>; Tue, 23 Mar 2021 12:01:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 893206191C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1616500887;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IURrYhTqt7qMN7ajN2qSka1hHHewwv42siGZMCcR8vc=;
	b=fHcGi7F8DG68hRAm29Cq/Z/BWoQdkY0csEBmUmXVJOheYEY8Lyp63UNcztDoVjBa9Ea9LM
	5ziH/hLjuQrZAdn9DZzZXL7vbXMnYS+asm7WcT+rQq94HLh63ECuZbKcVFc0LlS5bxHlYG
	DOj+9W5p15GFNyQuYot0cRC/TdcbVNY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-JnlZwYuKPTWPWxZScpdYDw-1; Tue, 23 Mar 2021 08:01:24 -0400
X-MC-Unique: JnlZwYuKPTWPWxZScpdYDw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 015B08042BE;
	Tue, 23 Mar 2021 12:01:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A42F25D6AD;
	Tue, 23 Mar 2021 12:01:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 54FA24BB7C;
	Tue, 23 Mar 2021 12:01:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12NC1GX8026620 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Mar 2021 08:01:16 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9825B1F7; Tue, 23 Mar 2021 12:01:16 +0000 (UTC)
Received: from T590 (ovpn-13-171.pek2.redhat.com [10.72.13.171])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 61DC85D9F0;
	Tue, 23 Mar 2021 12:01:12 +0000 (UTC)
Date: Tue, 23 Mar 2021 20:01:08 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Sagi Grimberg <sagi@grimberg.me>
Message-ID: <YFnYhBIiFhiyX8Wb@T590>
References: <20210318164827.1481133-1-ming.lei@redhat.com>
	<20210318164827.1481133-10-ming.lei@redhat.com>
	<522a2c87-e9f3-e62a-e09b-084821c698a0@grimberg.me>
MIME-Version: 1.0
In-Reply-To: <522a2c87-e9f3-e62a-e09b-084821c698a0@grimberg.me>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Jeffle Xu <jefflexu@linux.alibaba.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH V2 09/13] block: use per-task poll
 context to implement bio based io poll
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Mar 22, 2021 at 08:46:04PM -0700, Sagi Grimberg wrote:
> 
> > +static void blk_bio_poll_post_submit(struct bio *bio, blk_qc_t cookie)
> > +{
> > +	bio->bi_iter.bi_private_data = cookie;
> > +}
> > +
> 
> Hey Ming, thinking about nvme-mpath, I'm thinking that this should be
> an exported function for failover. nvme-mpath updates bio.bi_dev
> when re-submitting I/Os to an alternate path, so I'm thinking
> that if this function is exported then nvme-mpath could do as little
> as the below to allow polling?
> 
> --
> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
> index 92adebfaf86f..e562e296153b 100644
> --- a/drivers/nvme/host/multipath.c
> +++ b/drivers/nvme/host/multipath.c
> @@ -345,6 +345,7 @@ static void nvme_requeue_work(struct work_struct *work)
>         struct nvme_ns_head *head =
>                 container_of(work, struct nvme_ns_head, requeue_work);
>         struct bio *bio, *next;
> +       blk_qc_t cookie;
> 
>         spin_lock_irq(&head->requeue_lock);
>         next = bio_list_get(&head->requeue_list);
> @@ -359,7 +360,8 @@ static void nvme_requeue_work(struct work_struct *work)
>                  * path.
>                  */
>                 bio_set_dev(bio, head->disk->part0);
> -               submit_bio_noacct(bio);
> +               cookie = submit_bio_noacct(bio);
> +               blk_bio_poll_post_submit(bio, cookie);
>         }
>  }
> --
> 
> I/O failover will create misalignment from the polling context cpu and
> the submission cpu (running requeue_work), but I don't see if there is
> something that would break here...

I understand requeue shouldn't be one usual event, and I guess it is just
fine to fallback to IRQ based mode?

This patchset actually doesn't cover such bio submission from kernel context.

-- 
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

