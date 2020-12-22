Return-Path: <SRS0=qgMK=F2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09AF8C433E6
	for <dm-devel@archiver.kernel.org>; Tue, 22 Dec 2020 14:53:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6CAF6229CA
	for <dm-devel@archiver.kernel.org>; Tue, 22 Dec 2020 14:53:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6CAF6229CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1608648831;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FSmBPPUP0z5/N8yxLmkfNQYAMnIa+qkyCuyDNBJe06k=;
	b=eeVV3YmEYsmoZZaQbD7lbmlrMvdmBJNZQaFzqKXlAwipEW1JJu0W2XqGlPtEWQdAA4uK25
	VB8g0Ck8kSRukgZ3zYh6Fc3S9cOEvc2GvKaYabbPWWFOPC6ScaEmIqwcRIo4+hkUJuUoCV
	fgWVPM1uGwNEF4i9FcUlaMumINm1RQk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-a7XmGOwwMSG387L7MuJDLw-1; Tue, 22 Dec 2020 09:53:46 -0500
X-MC-Unique: a7XmGOwwMSG387L7MuJDLw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3978190B2A5;
	Tue, 22 Dec 2020 14:53:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 716745D735;
	Tue, 22 Dec 2020 14:53:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3DD845002C;
	Tue, 22 Dec 2020 14:53:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BMEra1B022671 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Dec 2020 09:53:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 649AC5D9E2; Tue, 22 Dec 2020 14:53:36 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C21AC5D9CC;
	Tue, 22 Dec 2020 14:53:27 +0000 (UTC)
Date: Tue, 22 Dec 2020 09:53:27 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	dm-devel@redhat.com
Message-ID: <20201222145327.GC12885@redhat.com>
References: <20201222095056.7a5ac0a0@canb.auug.org.au>
	<20201222131528.GA29822@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201222131528.GA29822@lst.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Stephen Rothwell <sfr@canb.auug.org.au>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Alasdair G Kergon <agk@redhat.com>
Subject: [dm-devel] DM's filesystem lookup in dm_get_dev_t() [was: Re:
 linux-next: manual merge of the device-mapper tree with Linus' tree]
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

[added linux-block and dm-devel, if someone replies to this email to
continue "proper discussion" _please_ at least drop sfr and linux-next
from Cc]

On Tue, Dec 22 2020 at  8:15am -0500,
Christoph Hellwig <hch@lst.de> wrote:

> Mike, Hannes,
> 
> I think this patch is rather harmful.  Why does device mapper even
> mix file system path with a dev_t and all the other weird forms
> parsed by name_to_dev_t, which was supposed to be be for the early
> init code where no file system is available.

OK, I'll need to revisit (unless someone beats me to it) because this
could've easily been a blind-spot for me when the dm-init code went in.
Any dm-init specific enabling interface shouldn't be used by more
traditional DM interfaces.  So Hannes' change might be treating symptom
rather than the core problem (which would be better treated by factoring
out dm-init requirements for a name_to_dev_t()-like interface?).

DM has supported passing maj:min and blockdev names on DM table lines
forever... so we'll need to be very specific about where/why things
regressed.

> Can we please kick off a proper discussion for this on the linux-block
> list?

Sure, done. But I won't drive that discussion in the near-term. I need
to take some time off for a few weeks.

In the meantime I'll drop Hannes' patch for 5.11; I'm open to an
alternative fix that I'd pickup during 5.11-rcX.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

