Return-Path: <SRS0=owAl=EM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C99EC2D0A3
	for <dm-devel@archiver.kernel.org>; Fri,  6 Nov 2020 16:22:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C21BD2151B
	for <dm-devel@archiver.kernel.org>; Fri,  6 Nov 2020 16:22:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G50lY2In"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C21BD2151B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1604679737;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2HepJtnwwrv2gJAPnRAZnDkjzWGAayWIscXU6GvaOJI=;
	b=G50lY2InDuEmorintXOH2dRTt4SUnWx4+O2SMQD7O9HjiNHfotenHDjopXe350IaXJS4QZ
	H8hj7TNqEKVK6KXp8YAM6zWtOYR4cK61TvcJPgi1f9iate9Dh2yuo9q+8ul+2ivVYnku8w
	EX/5NBVmjAw/169mPdYosN7NzLhlN5Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-k-W7KHTlMauG32UIcYG1ow-1; Fri, 06 Nov 2020 11:22:15 -0500
X-MC-Unique: k-W7KHTlMauG32UIcYG1ow-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 459035F9C1;
	Fri,  6 Nov 2020 16:22:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6BF0351573;
	Fri,  6 Nov 2020 16:22:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 94387922F3;
	Fri,  6 Nov 2020 16:22:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A6GM1Bu008824 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 6 Nov 2020 11:22:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E143421EC3; Fri,  6 Nov 2020 16:22:01 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE3162617B;
	Fri,  6 Nov 2020 16:21:58 +0000 (UTC)
Date: Fri, 6 Nov 2020 10:21:32 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <20201106152132.GA12366@redhat.com>
References: <20201103092329.17694-1-jefflexu@linux.alibaba.com>
	<b042e052-fa66-6542-f382-8bf33c4ffc24@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <b042e052-fa66-6542-f382-8bf33c4ffc24@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: joseph.qi@linux.alibaba.com, dm-devel@redhat.com
Subject: Re: [dm-devel] Why queue_work unneeded for REQUEUE bio
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 05 2020 at 10:49pm -0500,
JeffleXu <jefflexu@linux.alibaba.com> wrote:

> Hi Mike,
> 
> 
> I have another question about dm, though it's irrelevant to this original
> 
> mail.
> 
> 
> Currently abnormal IO will call blk_queue_split() and normal IO will
> 
> be split considering @max_sectors/@chunk_sectos (in max_io_len()).
> 
> 
> Question 1: Why bio should be split considering queue_limits in dm layer?
> 
> After all the underlying device will split themselves by queue_limits if
> 
> the dm layer doesn't split by queue_limits.

Some targets have "abnormal IO" constraints in their implementation that
is reflected in the queue_limits -- discards in particular.

> Then Question 2: Currently only @max_sectors is considered when splitting
> 
> normal IO in dm layer. Should we also consider
> @max_segments/@max_segment_size
> 
> as blk_queue_split() does?

Great question, it does appear the one gap in DM's splitting for
"normal" IO. I'm less familiar with @max_segments/@max_segment_size. 

Since commit 5091cdec56fa ("dm: change max_io_len() to use
blk_max_size_offset()") DM is making use of more block core code to
calculate its splits -- the offset based splitting is much more natural 
for DM to perform given that potential for spanning multiple targets,
etc.  But DM targets really don't get involved with concern for
@max_segments/@max_segment_size

dm-crypt.c:crypt_io_hints is the only DM target code that concerns
itself with @max_segment_size -- and it is punitive by setting it to
PAGE_SIZE, please see commit 586b286b110e94e ("dm crypt: constrain crypt
device's max_segment_size to PAGE_SIZE") for more context.

Mike


> On 11/3/20 5:23 PM, Jeffle Xu wrote:
> >Hi Mike,
> >
> >Why queue_work() is unnecessary here for bio with BLK_STS_DM_REQUEUE
> >returned?
> >
> >Thanks
> >Jeffle Xu
> >
> >---
> >  drivers/md/dm.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> >diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> >index c18fc2548518..ae550daa99b5 100644
> >--- a/drivers/md/dm.c
> >+++ b/drivers/md/dm.c
> >@@ -908,9 +908,11 @@ static void dec_pending(struct dm_io *io, blk_status_t error)
> >  			 * Target requested pushing back the I/O.
> >  			 */
> >  			spin_lock_irqsave(&md->deferred_lock, flags);
> >-			if (__noflush_suspending(md))
> >+			if (__noflush_suspending(md)) {
> >  				/* NOTE early return due to BLK_STS_DM_REQUEUE below */
> >  				bio_list_add_head(&md->deferred, io->orig_bio);
> >+				queue_work(md->wq, &md->work);
> >+			}
> >  			else
> >  				/* noflush suspend was interrupted. */
> >  				io->status = BLK_STS_IOERR;
> 
> -- 
> Thanks,
> Jeffle
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

