Return-Path: <SRS0=pJ9r=IR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E37ECC433DB
	for <dm-devel@archiver.kernel.org>; Fri, 19 Mar 2021 17:44:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 38F096197E
	for <dm-devel@archiver.kernel.org>; Fri, 19 Mar 2021 17:44:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38F096197E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1616175880;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Y6OlTgHyR02bC1BePYguE9uGjHga8nMjgi8aTFYsHqM=;
	b=CXaM5Iu01wWNJBJFgovpa4ahU4pViqpEFP8SCv7GZnwm85B3L4ba9R4F9vuT2YSII2+iBs
	lkKLye8xaqRu9F0WtnbnoqJASXHKlXvrQ0jo+gDm4WX3NyeaFJvUfTAs5l9JKXczr9lqyI
	aFGl1VJqVy8qtPciRQ97Q3tRrXGC2s4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-7GyHHU3aMtWKdEw2Dw7f8w-1; Fri, 19 Mar 2021 13:44:37 -0400
X-MC-Unique: 7GyHHU3aMtWKdEw2Dw7f8w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF217817472;
	Fri, 19 Mar 2021 17:44:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 78FE962460;
	Fri, 19 Mar 2021 17:44:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 196CF4BB7C;
	Fri, 19 Mar 2021 17:44:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12JHiTaY020256 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 19 Mar 2021 13:44:29 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D0FD419D9D; Fri, 19 Mar 2021 17:44:29 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 766C019C79;
	Fri, 19 Mar 2021 17:44:23 +0000 (UTC)
Date: Fri, 19 Mar 2021 13:44:22 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <20210319174422.GD9938@redhat.com>
References: <20210318164827.1481133-1-ming.lei@redhat.com>
	<20210318164827.1481133-7-ming.lei@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210318164827.1481133-7-ming.lei@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH V2 06/13] block: add new field into
	'struct bvec_iter'
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

On Thu, Mar 18 2021 at 12:48pm -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> There is a hole at the end of 'struct bvec_iter', so put a new field
> here and we can save cookie returned from submit_bio() here for
> supporting bio based polling.
> 
> This way can avoid to extend bio unnecessarily.
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  include/linux/bvec.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/linux/bvec.h b/include/linux/bvec.h
> index ff832e698efb..61c0f55f7165 100644
> --- a/include/linux/bvec.h
> +++ b/include/linux/bvec.h
> @@ -43,6 +43,15 @@ struct bvec_iter {
>  
>  	unsigned int            bi_bvec_done;	/* number of bytes completed in
>  						   current bvec */
> +
> +	/*
> +	 * There is a hole at the end of bvec_iter, define one filed to

s/filed/field/

> +	 * hold something which isn't relate with 'bvec_iter', so that we can

s/relate/related/
or
s/isn't relate with/doesn't relate to/

> +	 * avoid to extend bio. So far this new field is used for bio based

s/to extend/extending/

> +	 * pooling, we will store returning value of underlying queue's

s/pooling/polling/

> +	 * submit_bio() here.
> +	 */
> +	unsigned int		bi_private_data;
>  };
>  
>  struct bvec_iter_all {
> -- 
> 2.29.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

