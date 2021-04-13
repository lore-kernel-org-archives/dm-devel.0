Return-Path: <SRS0=RJDn=JK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF71C433ED
	for <dm-devel@archiver.kernel.org>; Tue, 13 Apr 2021 09:37:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8B8FC6121E
	for <dm-devel@archiver.kernel.org>; Tue, 13 Apr 2021 09:37:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B8FC6121E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1618306621;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bO3brCiHkcBvZniJ1H3dP87xNl4svu4taaH97viG514=;
	b=cgFaZqnRXYMcSi/zoy6zvktr1iF3Is4o/GWr8NTteEUCH/T4mi//mES0ao9C1gja2lREAV
	PmZXod+RJilJ+y/HumQt1RfJBBAci/TgrbBRTlD0GDcCkY8wg0Fqfvp6iTu72I7tcCyyNz
	/2AKJEQaYuexj2Yux9cidyWDg1FqF30=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-tWhJMLbtPk-Kysf3uXmnQQ-1; Tue, 13 Apr 2021 05:36:57 -0400
X-MC-Unique: tWhJMLbtPk-Kysf3uXmnQQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C59676D241;
	Tue, 13 Apr 2021 09:36:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3290B1000324;
	Tue, 13 Apr 2021 09:36:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9E5F844A5A;
	Tue, 13 Apr 2021 09:36:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13D9aiKf009759 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 13 Apr 2021 05:36:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A550460CF0; Tue, 13 Apr 2021 09:36:44 +0000 (UTC)
Received: from T590 (ovpn-12-66.pek2.redhat.com [10.72.12.66])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 05D916F98A;
	Tue, 13 Apr 2021 09:36:30 +0000 (UTC)
Date: Tue, 13 Apr 2021 17:36:26 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <YHVmGggTOkqZYOM+@T590>
References: <20210401021927.343727-1-ming.lei@redhat.com>
	<20210401021927.343727-6-ming.lei@redhat.com>
	<20210412092653.GA972763@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20210412092653.GA972763@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Jeffle Xu <jefflexu@linux.alibaba.com>
Subject: Re: [dm-devel] [PATCH V5 05/12] block: add new field into 'struct
	bvec_iter'
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

On Mon, Apr 12, 2021 at 10:26:53AM +0100, Christoph Hellwig wrote:
> I don't like where this is going.
> 
> I think the model of storing the polling cookie in the bio is useful,
> but:
> 
>  (1) I think having this in the iter is a mess.  Can you measure if
>      just marking bvec_iter __packed will generate much worse code
>      at all anymore?  If not we can just move this into the bio

Just test with packed 'struct bvec_iter' by running io_uring/libaio over
nvme/null_blk with different bs size, not see obvious difference
compared with unpacked bvec_iter.

So will switch to packed bvec_iter in next version.

>      If it really generates much worse code I think you need to pick
>      a different name as  as that i really confusing vs the bio field
>      of the same name that is used entirely differenly.  Similarly
>      the bio_get_private_data and bio_set_private_data helpers are
>      entirely misnamed, as the names suggest they deal with the
>      bi_private field in struct bio.  I actually suspect not having
>      these helpers would be much preferable

OK, how about naming it as .bi_poll_data?


Thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

