Return-Path: <SRS0=GP7Z=EX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE9FEC5519F
	for <dm-devel@archiver.kernel.org>; Tue, 17 Nov 2020 17:02:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1470122447
	for <dm-devel@archiver.kernel.org>; Tue, 17 Nov 2020 17:02:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dcWKnVF1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1470122447
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1605632522;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PqnJg61mvfGWkFOpLxsrmRMuekVL5kMe9cbOQPyS5X4=;
	b=dcWKnVF14ScFwD2PGYPeTakBfOTnsfV/rXM9jXRXMVvVArM/X9/ILQ3BlpDssyeBkJA0KY
	Dd/evdNQqQjhrQyr/+ejFc73j3I1iA9xxX0fwxsajyIsde2RAlot62uicfAboOeCZQ/wy/
	zfGuWBdDxhXWMtCBH1yw600zVAd2//4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-dZZnGr4VMIOFwEpxVo4YKg-1; Tue, 17 Nov 2020 12:01:58 -0500
X-MC-Unique: dZZnGr4VMIOFwEpxVo4YKg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFCBB1936B6E;
	Tue, 17 Nov 2020 17:01:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9948F100238C;
	Tue, 17 Nov 2020 17:01:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D5CC686BE8;
	Tue, 17 Nov 2020 17:01:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AHGA3wJ027874 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 17 Nov 2020 11:10:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8ED55176BB; Tue, 17 Nov 2020 16:10:03 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E0A3C62934;
	Tue, 17 Nov 2020 16:09:59 +0000 (UTC)
Date: Tue, 17 Nov 2020 11:09:59 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201117160958.GB27085@redhat.com>
References: <20201116212020.1099154-1-hch@lst.de>
	<20201117154629.GA27085@redhat.com> <20201117155100.GA20977@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201117155100.GA20977@lst.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Minchan Kim <minchan@kernel.org>,
	dm-devel@redhat.com, linux-block@vger.kernel.org
Subject: Re: [dm-devel] misc struct block_device related driver cleanups
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 17 2020 at 10:51am -0500,
Christoph Hellwig <hch@lst.de> wrote:

> On Tue, Nov 17, 2020 at 10:46:29AM -0500, Mike Snitzer wrote:
> > On Mon, Nov 16 2020 at  4:20pm -0500,
> > Christoph Hellwig <hch@lst.de> wrote:
> > 
> > > Hi Jens, Minchan and Mike,
> > > 
> > > this series cleans up a few interactions of driver with struct
> > > block_device, in preparation for big changes to struct block_device
> > > that I plan to send soon.
> > 
> > Thanks, I've picked up 5 and 6 for 5.11.
> 
> I actually need them in Jens' for-5.11/block tree for my next series..

Ah, OK.. no problem.

I'll reply with my Acked-by:s

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

