Return-Path: <SRS0=1Ivj=GK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10112C433DB
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jan 2021 20:31:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6C0C423435
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jan 2021 20:31:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C0C423435
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1610051500;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=d64CS3hbre3RWNL5yYWWSIupteGx/FAAY5/kClh+2Fk=;
	b=WXqAUGV9PUoiiP9x81Bf1c/he03wSWXSOL+CGZWhKm+phK/dRcifWFUkMX/swd47gY3JV9
	SBQZ+OusA20OUgJFzffldU+B+Kk0m8a4DFvYrjhRBp4h4xbEAMM6e5RGfks59+aWRUBqQT
	dd2LMYF0Hpu0uR4/WpBsiELE6hytV+8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-Xj9KSZ7zNVi-ywWH9ZMWiw-1; Thu, 07 Jan 2021 15:31:36 -0500
X-MC-Unique: Xj9KSZ7zNVi-ywWH9ZMWiw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58E7C800D55;
	Thu,  7 Jan 2021 20:31:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E6E5C60BF1;
	Thu,  7 Jan 2021 20:31:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9584B180954D;
	Thu,  7 Jan 2021 20:31:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 107KVQdD014431 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 7 Jan 2021 15:31:26 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 17D6E10016FB; Thu,  7 Jan 2021 20:31:26 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C0D41002391;
	Thu,  7 Jan 2021 20:31:21 +0000 (UTC)
Date: Thu, 7 Jan 2021 15:31:21 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Jeffle Xu <jefflexu@linux.alibaba.com>
Message-ID: <20210107203121.GB21239@redhat.com>
References: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
	<20201223112624.78955-3-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <20201223112624.78955-3-jefflexu@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH RFC 2/7] block: add helper function fetching
 gendisk from queue
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

On Wed, Dec 23 2020 at  6:26am -0500,
Jeffle Xu <jefflexu@linux.alibaba.com> wrote:

> Sometimes we need to get the corresponding gendisk from request_queue.
> 
> One such use case is that, the block device driver had ever stored the
> same private data both in queue->queuedata and gendisk->private_data,
> while nowadays gendisk->private_data is more preferable in such case,
> e.g. commit c4a59c4e5db3 ("dm: stop using ->queuedata"). So if only
> request_queue given, we need to get the corresponding gendisk from
> queue, to get the private data stored in gendisk.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  include/linux/blkdev.h       | 2 ++
>  include/trace/events/kyber.h | 6 +++---
>  2 files changed, 5 insertions(+), 3 deletions(-)

Looks good, but please update the patch subject and header to be:

block: add queue_to_disk() to get gendisk from request_queue

Sometimes we need to get the corresponding gendisk from request_queue.

It is preferred that block drivers store private data in
gendisk->private_data rather than request_queue->queuedata, e.g. see:
commit c4a59c4e5db3 ("dm: stop using ->queuedata").

So if only request_queue is given, we need to get its corresponding
gendisk to get the private data stored in that gendisk.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Review-by: Mike Snitzer <snitzer@redhat.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

