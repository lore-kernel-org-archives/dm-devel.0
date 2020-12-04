Return-Path: <SRS0=D9Ri=FI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87748C4361A
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 02:11:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E4F8922510
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 02:11:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4F8922510
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1607047887;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=L6HE03qw3Owx3wJjb6bMity+k33R8/AMZgZLdpsfxEU=;
	b=HZ+0w0bMv2cwPRyV1uNTl62Xex3vJBWGfTBpmFe9WWhq7ZmMgQ3iu2RCPJD8TZRDP9/hnR
	z0+EQCaRAmB/h7a2jIf++vzrhcR0QO/AbtaFm+daRDtFgx1nrmZCTsyv113GTzHy62X5cy
	2oJNbpVyb+916eOzbLYVG3uJ0Bbs9O8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-FE8IlP3BP_akBIh9kc0J1A-1; Thu, 03 Dec 2020 21:11:25 -0500
X-MC-Unique: FE8IlP3BP_akBIh9kc0J1A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70FD7180A086;
	Fri,  4 Dec 2020 02:11:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 48CAF5C1D0;
	Fri,  4 Dec 2020 02:11:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C5EFE4A7C6;
	Fri,  4 Dec 2020 02:11:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B42BHK1002711 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 21:11:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C1A836085A; Fri,  4 Dec 2020 02:11:17 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EDB4160854;
	Fri,  4 Dec 2020 02:11:09 +0000 (UTC)
Date: Thu, 3 Dec 2020 21:11:08 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Ming Lei <ming.lei@redhat.com>, hare@suse.de
Message-ID: <20201204021108.GB32150@redhat.com>
References: <20201130171805.77712-1-snitzer@redhat.com>
	<20201201160709.31748-1-snitzer@redhat.com>
	<20201203032608.GD540033@T590> <20201203143359.GA29261@redhat.com>
	<20201203162738.GA3404013@dhcp-10-100-145-180.wdc.com>
	<20201204014535.GC661914@T590>
MIME-Version: 1.0
In-Reply-To: <20201204014535.GC661914@T590>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, martin.petersen@oracle.com, jdorminy@redhat.com,
	bjohnsto@redhat.com, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [dm-devel] [PATCH v2] block: use gcd() to fix chunk_sectors
	limit stacking
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

On Thu, Dec 03 2020 at  8:45pm -0500,
Ming Lei <ming.lei@redhat.com> wrote:

> On Thu, Dec 03, 2020 at 08:27:38AM -0800, Keith Busch wrote:
> > On Thu, Dec 03, 2020 at 09:33:59AM -0500, Mike Snitzer wrote:
> > > On Wed, Dec 02 2020 at 10:26pm -0500,
> > > Ming Lei <ming.lei@redhat.com> wrote:
> > > 
> > > > I understand it isn't related with correctness, because the underlying
> > > > queue can split by its own chunk_sectors limit further. So is the issue
> > > > too many further-splitting on queue with chunk_sectors 8? then CPU
> > > > utilization is increased? Or other issue?
> > > 
> > > No, this is all about correctness.
> > > 
> > > Seems you're confining the definition of the possible stacking so that
> > > the top-level device isn't allowed to have its own hard requirements on
> > > IO sizes it sends to its internal implementation.  Just because the
> > > underlying device can split further doesn't mean that the top-level
> > > virtual driver can service larger IO sizes (not if the chunk_sectors
> > > stacking throws away the hint the virtual driver provided because it
> > > used lcm_not_zero).
> > 
> > I may be missing something obvious here, but if the lower layers split
> > to their desired boundary already, why does this limit need to stack?
> > Won't it also work if each layer sets their desired chunk_sectors
> > without considering their lower layers? The commit that initially
> > stacked chunk_sectors doesn't provide any explanation.
> 
> There could be several reasons:
> 
> 1) some limits have to be stacking, such as logical block size, because
> lower layering may not handle un-aligned IO
> 
> 2) performance reason, if every limits are stacked on topmost layer, in
> theory IO just needs to be splitted in top layer, and not need to be
> splitted further from all lower layer at all. But there should be exceptions
> in unusual case, such as, lowering queue's limit changed after the stacking
> limits are setup.
> 
> 3) history reason, bio splitting is much younger than stacking queue
> limits.
> 
> Maybe others?

Hannes didn't actually justify why he added chunk_sectors to
blk_stack_limits:

commit 987b3b26eb7b19960160505faf9b2f50ae77e14d
Author: Hannes Reinecke <hare@suse.de>
Date:   Tue Oct 18 15:40:31 2016 +0900

    block: update chunk_sectors in blk_stack_limits()

    Signed-off-by: Hannes Reinecke <hare@suse.com>
    Signed-off-by: Damien Le Moal <damien.lemoal@hgst.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
    Reviewed-by: Shaun Tancheff <shaun.tancheff@seagate.com>
    Tested-by: Shaun Tancheff <shaun.tancheff@seagate.com>
    Signed-off-by: Jens Axboe <axboe@fb.com>

Likely felt it needed for zoned or NVMe devices.. dunno.

But given how we now have a model where block core, or DM core, will
split as needed I don't think normalizing chunk_sectors (to the degree
full use of blk_stack_limits does) and than using it as basis for
splitting makes a lot of sense.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

