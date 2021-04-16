Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 195C6C433B4
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 09:07:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A3D386100C
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 09:07:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A3D386100C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1618564048;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=madAG/glkPZpprH3pVhF4bYY/INueN3/xHIcfI8U5oo=;
	b=KXRdSFeAQQd6o6W39lrlRyfyMQdxb3PVLOJBvFzkrPbheYcNwWwsmnpWc1KYswdqtdtYfr
	m/xbubwnNNgYzEkMv8z9t2gZcNwUgbLOUglWpzky9GV1iMVQiv/Dc34HiUKYf0Akc1sMGa
	smIxA7B+WfnLBfc4ltqTSujagQNDD9o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-sLr4Z4WeOZWPJ2rwKmu59Q-1; Fri, 16 Apr 2021 05:07:26 -0400
X-MC-Unique: sLr4Z4WeOZWPJ2rwKmu59Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D38646D249;
	Fri, 16 Apr 2021 09:07:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 81AE75D9C0;
	Fri, 16 Apr 2021 09:07:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7AE1B44A5E;
	Fri, 16 Apr 2021 09:07:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13G97Isl002163 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 05:07:18 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C5CB55D9DE; Fri, 16 Apr 2021 09:07:18 +0000 (UTC)
Received: from T590 (ovpn-12-36.pek2.redhat.com [10.72.12.36])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ABCBA5D9C0;
	Fri, 16 Apr 2021 09:07:06 +0000 (UTC)
Date: Fri, 16 Apr 2021 17:07:01 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jeffle Xu <jefflexu@linux.alibaba.com>
Message-ID: <YHlTtVtTEBpxa8Gh@T590>
References: <20210401021927.343727-12-ming.lei@redhat.com>
	<20210416080037.26335-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <20210416080037.26335-1-jefflexu@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com,
	snitzer@redhat.com
Subject: Re: [dm-devel] [PATCH] block: introduce QUEUE_FLAG_POLL_CAP flag
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Apr 16, 2021 at 04:00:37PM +0800, Jeffle Xu wrote:
> Hi,
> How about this patch to remove the extra poll_capable() method?
> 
> And the following 'dm: support IO polling for bio-based dm device' needs
> following change.
> 
> ```
> +       /*
> +        * Check for request-based device is remained to
> +        * dm_mq_init_request_queue()->blk_mq_init_allocated_queue().
> +        * For bio-based device, only set QUEUE_FLAG_POLL when all underlying
> +        * devices supporting polling.
> +        */
> +       if (__table_type_bio_based(t->type)) {
> +               if (dm_table_supports_poll(t)) {
> +                       blk_queue_flag_set(QUEUE_FLAG_POLL_CAP, q);
> +                       blk_queue_flag_set(QUEUE_FLAG_POLL, q);
> +               }
> +               else {
> +                       blk_queue_flag_clear(QUEUE_FLAG_POLL, q);
> +                       blk_queue_flag_clear(QUEUE_FLAG_POLL_CAP, q);
> +               }
> +       }
> ```

Frankly speaking, I don't see any value of using QUEUE_FLAG_POLL_CAP for
DM, and the result is basically subset of treating DM as always being capable
of polling.

Also underlying queue change(either limits or flag) won't be propagated
to DM/MD automatically. Strictly speaking it doesn't matter if all underlying
queues are capable of supporting polling at the exact time of 'write sysfs/poll',
cause any of them may change in future.

So why not start with the simplest approach(always capable of polling)
which does meet normal bio based polling requirement?



Thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

