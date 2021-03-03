Return-Path: <SRS0=/efG=IB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A963C433E0
	for <dm-devel@archiver.kernel.org>; Wed,  3 Mar 2021 08:47:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6ED5E64ED0
	for <dm-devel@archiver.kernel.org>; Wed,  3 Mar 2021 08:47:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6ED5E64ED0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-PG8SqCHkO26ancQJrf09Kw-1; Wed, 03 Mar 2021 03:47:44 -0500
X-MC-Unique: PG8SqCHkO26ancQJrf09Kw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B63C3107ACC7;
	Wed,  3 Mar 2021 08:47:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9030010013C1;
	Wed,  3 Mar 2021 08:47:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 36DBA18095CB;
	Wed,  3 Mar 2021 08:47:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1232LcvJ032473 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Mar 2021 21:21:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6D50C2026D14; Wed,  3 Mar 2021 02:21:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 67DF02026D48
	for <dm-devel@redhat.com>; Wed,  3 Mar 2021 02:21:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FB94186E1F1
	for <dm-devel@redhat.com>; Wed,  3 Mar 2021 02:21:31 +0000 (UTC)
Received: from out30-57.freemail.mail.aliyun.com
	(out30-57.freemail.mail.aliyun.com [115.124.30.57]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-273-2DoNA3I6PwOXi5mtTHhXhQ-1;
	Tue, 02 Mar 2021 21:21:28 -0500
X-MC-Unique: 2DoNA3I6PwOXi5mtTHhXhQ-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R211e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=10; SR=0;
	TI=SMTPD_---0UQADoLL_1614738083
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UQADoLL_1614738083) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 03 Mar 2021 10:21:24 +0800
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>, axboe@kernel.dk,
	caspar@linux.alibaba.com, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, hch@lst.de
References: <20210302190552.715551440@debian-a64.vm>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <3e8b3b2e-f1f4-e946-4858-d2c78e2a8825@linux.alibaba.com>
Date: Wed, 3 Mar 2021 10:21:23 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210302190552.715551440@debian-a64.vm>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 03 Mar 2021 03:47:16 -0500
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 3/3/21 3:05 AM, Mikulas Patocka wrote:
> Don't clear REQ_HIPRI for bio-based drivers. Device mapper will need to
> see this flag in order to support polling.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  block/blk-core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/block/blk-core.c
> ===================================================================
> --- linux-2.6.orig/block/blk-core.c	2021-03-02 10:43:28.000000000 +0100
> +++ linux-2.6/block/blk-core.c	2021-03-02 10:53:50.000000000 +0100

I notice that the diff header indicates that the code base is from
linux-2.6. Or it's just the name of your directory, while the code base
is for the latest upstream 5.12?


> @@ -836,7 +836,7 @@ static noinline_for_stack bool submit_bi
>  		}
>  	}
>  
> -	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
> +	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && !bdev->bd_disk->fops->submit_bio)
>  		bio->bi_opf &= ~REQ_HIPRI;
>  
>  	switch (bio_op(bio)) {
> 
> --

What if dm device is built upon mq devices that are not capable of
polling, i.e., mq devices without QUEUE_FLAG_POLL set? Then this dm
device shall not support polling.


-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

