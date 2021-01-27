Return-Path: <SRS0=jLbn=G6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 573C8C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jan 2021 17:27:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B4FE560187
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jan 2021 17:27:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4FE560187
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1611768448;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=X4WrTukjIDqKlYMS52neDCnC5lfLd8zUSBSo9zn1/zE=;
	b=N6xtV+ohssUvopLLsvUvGeV9Ot+9G77YjK1LUTmGomywuZ57rwWMZgfpPU3Y5JQCngs4oT
	3/iHqfN54MTevEDsMJcn8KRSvgyyEI88/Gh6n+BxwMK7Z2CSgYVoguCDAWYOXjyK/hnSyw
	XgAOPFJ232rJsT7FlDqWSaXzUY1L6bI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-lKpMiZ-fP0eOd1QsLX_6gQ-1; Wed, 27 Jan 2021 12:27:25 -0500
X-MC-Unique: lKpMiZ-fP0eOd1QsLX_6gQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D3C5802B47;
	Wed, 27 Jan 2021 17:27:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 16F6119481;
	Wed, 27 Jan 2021 17:27:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 447A44BB7B;
	Wed, 27 Jan 2021 17:27:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10RHDP7Y015256 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 27 Jan 2021 12:13:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0B7C660854; Wed, 27 Jan 2021 17:13:25 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BDBB660873;
	Wed, 27 Jan 2021 17:13:21 +0000 (UTC)
Date: Wed, 27 Jan 2021 12:13:21 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Jeffle Xu <jefflexu@linux.alibaba.com>
Message-ID: <20210127171320.GA11535@redhat.com>
References: <20210125121340.70459-1-jefflexu@linux.alibaba.com>
	<20210125121340.70459-6-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <20210125121340.70459-6-jefflexu@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v2 5/6] block: add QUEUE_FLAG_POLL_CAP flag
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jan 25 2021 at  7:13am -0500,
Jeffle Xu <jefflexu@linux.alibaba.com> wrote:

> Introduce QUEUE_FLAG_POLL_CAP flag representing if the request queue
> capable of polling or not.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>

Why are you adding QUEUE_FLAG_POLL_CAP?  Doesn't seem as though DM or
anything else actually needs it.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

