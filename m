Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1ECEC433B4
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 15:04:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6C5EE611AC
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 15:04:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C5EE611AC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1618585458;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CN6hMrPsyIMj1V2LGwt5YJ66mxG+2v1phF+uewOSDMw=;
	b=HA/qw9fPgefEaabyZj/Q4tGUfT6/9Uq6y8VXVR/idtHOB97ghonznxCiXSpqokCvlB8wWT
	03jJlUaea9xYyN2BcRiwwU0nyXsEB8hsTrCV3HfCLu+Anr8P30jAQUhYQOolfjluCqWcXm
	jk8m5b1zpgl+Xj7FB+W4dzpIZ51gfqY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-xYTAkrFuPoKYWDSiPjNfRA-1; Fri, 16 Apr 2021 11:04:15 -0400
X-MC-Unique: xYTAkrFuPoKYWDSiPjNfRA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 327B21083E9F;
	Fri, 16 Apr 2021 15:04:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DD53118F15;
	Fri, 16 Apr 2021 15:04:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CA3AF44A5E;
	Fri, 16 Apr 2021 15:04:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13GF35go005579 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 11:03:05 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A282E5D749; Fri, 16 Apr 2021 15:03:05 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C784A5D751;
	Fri, 16 Apr 2021 15:03:01 +0000 (UTC)
Date: Fri, 16 Apr 2021 11:03:01 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Message-ID: <20210416150301.GC16047@redhat.com>
References: <20210415231530.95464-1-snitzer@redhat.com>
	<20210415231530.95464-4-snitzer@redhat.com>
	<6185100e-89e6-0a7f-8901-9ce86fe8f1ac@suse.de>
MIME-Version: 1.0
In-Reply-To: <6185100e-89e6-0a7f-8901-9ce86fe8f1ac@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
	linux-nvme@lists.infradead.org
Subject: Re: [dm-devel] [PATCH v2 3/4] nvme: introduce FAILUP handling for
 REQ_FAILFAST_TRANSPORT
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

On Fri, Apr 16 2021 at 10:07am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 4/16/21 1:15 AM, Mike Snitzer wrote:
> > If REQ_FAILFAST_TRANSPORT is set it means the driver should not retry
> > IO that completed with transport errors. REQ_FAILFAST_TRANSPORT is
> > set by multipathing software (e.g. dm-multipath) before it issues IO.
> > 
> > Update NVMe to allow failover of requests marked with either
> > REQ_NVME_MPATH or REQ_FAILFAST_TRANSPORT. This allows such requests
> > to be given a disposition of either FAILOVER or FAILUP respectively.
> > FAILUP handling ensures a retryable error is returned up from NVMe.
> > 
> > Introduce nvme_failup_req() for use in nvme_complete_rq() if
> > nvme_decide_disposition() returns FAILUP. nvme_failup_req() ensures
> > the request is completed with a retryable IO error when appropriate.
> > __nvme_end_req() was factored out for use by both nvme_end_req() and
> > nvme_failup_req().
> > 
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > ---
> >  drivers/nvme/host/core.c | 31 ++++++++++++++++++++++++++-----
> >  1 file changed, 26 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> > index 4134cf3c7e48..10375197dd53 100644
> > --- a/drivers/nvme/host/core.c
> > +++ b/drivers/nvme/host/core.c
> > @@ -299,6 +299,7 @@ enum nvme_disposition {
> >  	COMPLETE,
> >  	RETRY,
> >  	FAILOVER,
> > +	FAILUP,
> >  };
> >  
> >  static inline enum nvme_disposition nvme_decide_disposition(struct request *req)
> > @@ -318,10 +319,11 @@ static inline enum nvme_disposition nvme_decide_disposition(struct request *req)
> >  	    nvme_req(req)->retries >= nvme_max_retries)
> >  		return COMPLETE;
> >  
> > -	if (req->cmd_flags & REQ_NVME_MPATH) {
> > +	if (req->cmd_flags & (REQ_NVME_MPATH | REQ_FAILFAST_TRANSPORT)) {
> >  		if (nvme_is_path_error(nvme_req(req)->status) ||
> >  		    blk_queue_dying(req->q))
> > -			return FAILOVER;
> > +			return (req->cmd_flags & REQ_NVME_MPATH) ?
> > +				FAILOVER : FAILUP;
> >  	} else {
> >  		if (blk_queue_dying(req->q))
> >  			return COMPLETE;
> > @@ -330,10 +332,8 @@ static inline enum nvme_disposition nvme_decide_disposition(struct request *req)
> >  	return RETRY;
> >  }
> >  
> > -static inline void nvme_end_req(struct request *req)
> > +static inline void __nvme_end_req(struct request *req, blk_status_t status)
> >  {
> > -	blk_status_t status = nvme_error_status(nvme_req(req)->status);
> > -
> >  	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
> >  	    req_op(req) == REQ_OP_ZONE_APPEND)
> >  		req->__sector = nvme_lba_to_sect(req->q->queuedata,
> > @@ -343,6 +343,24 @@ static inline void nvme_end_req(struct request *req)
> >  	blk_mq_end_request(req, status);
> >  }
> >  
> > +static inline void nvme_end_req(struct request *req)
> > +{
> > +	__nvme_end_req(req, nvme_error_status(nvme_req(req)->status));
> > +}
> > +
> > +static void nvme_failup_req(struct request *req)
> > +{
> > +	blk_status_t status = nvme_error_status(nvme_req(req)->status);
> > +
> > +	if (WARN_ON_ONCE(!blk_path_error(status))) {
> > +		pr_debug("Request meant for failover but blk_status_t (errno=%d) was not retryable.\n",
> > +			 blk_status_to_errno(status));
> > +		status = BLK_STS_IOERR;
> > +	}
> > +
> > +	__nvme_end_req(req, status);
> > +}
> > +
> >  void nvme_complete_rq(struct request *req)
> >  {
> >  	trace_nvme_complete_rq(req);
> > @@ -361,6 +379,9 @@ void nvme_complete_rq(struct request *req)
> >  	case FAILOVER:
> >  		nvme_failover_req(req);
> >  		return;
> > +	case FAILUP:
> > +		nvme_failup_req(req);
> > +		return;
> >  	}
> >  }
> >  EXPORT_SYMBOL_GPL(nvme_complete_rq);
> > 
> 
> Hmm. Quite convoluted, methinks.

Maybe you didn't read the header or patch?

I'm cool with critical review when it is clear the reviewer fully
understands the patch but... ;)

> Shouldn't this achieve the same thing?
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index e89ec2522ca6..8c36a2196b66 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -303,8 +303,10 @@ static inline enum nvme_disposition
> nvme_decide_disposition(struct request *req)
>         if (likely(nvme_req(req)->status == 0))
>                 return COMPLETE;
> 
> -       if (blk_noretry_request(req) ||
> -           (nvme_req(req)->status & NVME_SC_DNR) ||
> +       if (blk_noretry_request(req))
> +               nvme_req(req)->status |= NVME_SC_DNR;
> +
> +       if ((nvme_req(req)->status & NVME_SC_DNR) ||
>             nvme_req(req)->retries >= nvme_max_retries)
>                 return COMPLETE;

Definitely won't achieve the same. And especially not with patch 1/4
("nvme: return BLK_STS_DO_NOT_RETRY if the DNR bit is set") that you
gave your Reviewed-by to earlier.

Instead of "FAILUP", I thought about using "FAILUP_AND_OVER" to convey
that this is a variant of failover.  Meaning it takes the same patch as
nvme "FAILOVER" until the very end; where it does REQ_FAILFAST_TRANSPORT
specific work detailed in nvme_failup_req().

And then patch 4/4 makes further use of nvme_failup_req() by adding a
call to the factored out nvme_update_ana().

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

