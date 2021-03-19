Return-Path: <SRS0=pJ9r=IR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18ED3C433C1
	for <dm-devel@archiver.kernel.org>; Fri, 19 Mar 2021 18:45:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BC93B61980
	for <dm-devel@archiver.kernel.org>; Fri, 19 Mar 2021 18:45:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC93B61980
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1616179548;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hk0MrSw0zUyXfYq+A6Psae5jXxS8EgjVDeHpeMesgtk=;
	b=QdOzhFqVEGHqVebn/TCggzvk9CfnetJqlraxuFxQNuNwlPfDYABwdMfnDTA6jzuXSWoQS9
	DQ8fheQbuBthnPCKxB7jsftQT9NUYat4tVu2LuPyPFwQklBuYZLZuWAS0euv8e5LPUaL2l
	JiiEPue0jFZoNFtt98BRjbZEhE2QXU0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-aNlWbwMJNhG_NXV9l-LdMg-1; Fri, 19 Mar 2021 14:45:46 -0400
X-MC-Unique: aNlWbwMJNhG_NXV9l-LdMg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 647A110074A6;
	Fri, 19 Mar 2021 18:45:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0361F60D79;
	Fri, 19 Mar 2021 18:45:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 303521809C83;
	Fri, 19 Mar 2021 18:45:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12JIjbKq027401 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 19 Mar 2021 14:45:37 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E71705D72F; Fri, 19 Mar 2021 18:45:37 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 447995D6D5;
	Fri, 19 Mar 2021 18:45:30 +0000 (UTC)
Date: Fri, 19 Mar 2021 14:45:30 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <20210319184529.GB10212@redhat.com>
References: <20210318164827.1481133-1-ming.lei@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210318164827.1481133-1-ming.lei@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH V2 00/13] block: support bio based io
	polling
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

On Thu, Mar 18 2021 at 12:48pm -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> Hi,
> 
> Add per-task io poll context for holding HIPRI blk-mq/underlying bios
> queued from bio based driver's io submission context, and reuse one bio
> padding field for storing 'cookie' returned from submit_bio() for these
> bios. Also explicitly end these bios in poll context by adding two
> new bio flags.
> 
> In this way, we needn't to poll all underlying hw queues any more,
> which is implemented in Jeffle's patches. And we can just poll hw queues
> in which there is HIPRI IO queued.
> 
> Usually io submission and io poll share same context, so the added io
> poll context data is just like one stack variable, and the cost for
> saving bios is cheap.
> 
> Any comments are welcome.

I really like your approach and am very encouraged by the early results
Jeffle has shared.

Please review my various nits for your next iteration of this patchset.
But I think you aren't far from these changes being ready to make the
5.13 merge, which is really pretty awesome.

Outstanding job Ming, thanks so much for taking on this line of work!

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

