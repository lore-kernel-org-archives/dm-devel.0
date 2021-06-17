Return-Path: <SRS0=ZDE9=LL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 057B9C2B9F4
	for <dm-devel@archiver.kernel.org>; Thu, 17 Jun 2021 23:09:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9F60861042
	for <dm-devel@archiver.kernel.org>; Thu, 17 Jun 2021 23:09:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F60861042
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1623971370;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FG5FGnX80t+rYT2gc/kvlIVtZ1qmqPB+mVkPYcoVm4w=;
	b=QUScWqX3NWuL8E+v1CQLcHOjN7tadqPQxcIMpCUCkfnLaJDTxL4aAdKeOZao4H/QN70B9O
	kq61aIMIghoZ8ZduT7UDo3yZkoLM8mOmIKGoLWMfbJduklKq7t6drPENsbhvGrcSlFNcFt
	NZOJ5B40tvu/0ULOADa0BhrV4gqiAyI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-WomyrdTlPoSzDAbGiYDZ3A-1; Thu, 17 Jun 2021 19:09:29 -0400
X-MC-Unique: WomyrdTlPoSzDAbGiYDZ3A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86F711850600;
	Thu, 17 Jun 2021 23:09:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2373E6064B;
	Thu, 17 Jun 2021 23:09:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D31971809CAE;
	Thu, 17 Jun 2021 23:09:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15HN9G3U027876 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Jun 2021 19:09:16 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DA6595C1D1; Thu, 17 Jun 2021 23:09:16 +0000 (UTC)
Received: from T590 (ovpn-12-22.pek2.redhat.com [10.72.12.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C12C5C22A;
	Thu, 17 Jun 2021 23:09:03 +0000 (UTC)
Date: Fri, 18 Jun 2021 07:08:59 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Message-ID: <YMvWC2vNCsnTkfrc@T590>
References: <20210617103549.930311-1-ming.lei@redhat.com>
	<20210617103549.930311-4-ming.lei@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210617103549.930311-4-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, Jeffle Xu <jefflexu@linux.alibaba.com>,
	dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH V2 3/3] dm: support bio polling
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jun 17, 2021 at 06:35:49PM +0800, Ming Lei wrote:
> Support bio(REQ_POLLED) polling in the following approach:
> 
> 1) only support io polling on normal READ/WRITE, and other abnormal IOs
> still fallback on IRQ mode, so the target io is exactly inside the dm
> io.
> 
> 2) hold one refcnt on io->io_count after submitting this dm bio with
> REQ_POLLED
> 
> 3) support dm native bio splitting, any dm io instance associated with
> current bio will be added into one list which head is bio->bi_end_io
> which will be recovered before ending this bio
> 
> 4) implement .poll_bio() callback, call bio_poll() on the single target
> bio inside the dm io which is retrieved via bio->bi_bio_drv_data; call
> dec_pending() after the target io is done in .poll_bio()
> 
> 4) enable QUEUE_FLAG_POLL if all underlying queues enable QUEUE_FLAG_POLL,
> which is based on Jeffle's previous patch.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

...

> @@ -938,8 +945,12 @@ static void dec_pending(struct dm_io *io, blk_status_t error)
>  		end_io_acct(io);
>  		free_io(md, io);
>  
> -		if (io_error == BLK_STS_DM_REQUEUE)
> +		if (io_error == BLK_STS_DM_REQUEUE) {
> +			/* not poll any more in case of requeue */
> +			if (bio->bi_opf & REQ_POLLED)
> +				bio->bi_opf &= ~REQ_POLLED;

It becomes not necessary to clear REQ_POLLED before requeuing since
every dm_io is added into the hlist_head which is reused from
bio->bi_end_io, so all dm-io(include the one to be requeued) will be
polled.

Thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

