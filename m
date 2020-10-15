Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 749F4C43467
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:20:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C8BEE20848
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:20:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C8BEE20848
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-qcvktNI3N2GfF5WYAqCE9Q-1; Fri, 16 Oct 2020 06:20:55 -0400
X-MC-Unique: qcvktNI3N2GfF5WYAqCE9Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33D6281CBDD;
	Fri, 16 Oct 2020 10:20:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 168035C1D0;
	Fri, 16 Oct 2020 10:20:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E0EDA44A64;
	Fri, 16 Oct 2020 10:20:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09FM5VY2002643 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 15 Oct 2020 18:05:31 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 402772011540; Thu, 15 Oct 2020 22:05:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B55B2011541
	for <dm-devel@redhat.com>; Thu, 15 Oct 2020 22:05:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB03C858289
	for <dm-devel@redhat.com>; Thu, 15 Oct 2020 22:05:27 +0000 (UTC)
Received: from mail-pj1-f66.google.com (mail-pj1-f66.google.com
	[209.85.216.66]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-338-ghOj-tCxPNueWVGrQMNDsg-1; Thu, 15 Oct 2020 18:05:25 -0400
X-MC-Unique: ghOj-tCxPNueWVGrQMNDsg-1
Received: by mail-pj1-f66.google.com with SMTP id az3so213679pjb.4
	for <dm-devel@redhat.com>; Thu, 15 Oct 2020 15:05:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=700dSlreVGZIbwr3AdAuK7QeFJxaPoeuAx3F/ELDRDo=;
	b=lG917whoBoCUUILqhB/fxpPA0AGxKe5RuGuJ1o1OJlOu0d7ZPn9MWfCVysFqJbPFWF
	v02bqfWFE7KFtm69WOhI1DORXgtcnIC/4/JkiX1sMPwCJuygjWuzHNNVu4TaCWZeEZPa
	zVgn1QkvcXCASAroLRslJ+IFR4vI5BBf3L0qE59jniyB734yVfh1z9rOJmr2gltiAGsP
	hiJyfcmouCq8ILnSdF+og4RpgFCY6QV2cdW4BiUkCDI9SSStlqZRV0T6DYNxpp+Zl1Yi
	33hgmqDjJSTf/V1l2flf/RF42cTwm3i9rloMTmOQjvtoM3lCIqng501eqLV9uQxrjkCI
	pHug==
X-Gm-Message-State: AOAM531WeYEqAhIW/otZp55u37IyLhD1mE6ex4+IL+YMRXz2ozoBgnwT
	H8CbEzufuN4R2Nf3+AT7TIYeiQ==
X-Google-Smtp-Source: ABdhPJzUX9wxifuk/NX4KO9hxnbTmPIzCu5nOp+krk3Lv2bCZAZCkS014tzTx/UPz0a1f2BvXPsGKQ==
X-Received: by 2002:a17:90a:9317:: with SMTP id
	p23mr762160pjo.160.1602799523789; 
	Thu, 15 Oct 2020 15:05:23 -0700 (PDT)
Received: from google.com (154.137.233.35.bc.googleusercontent.com.
	[35.233.137.154])
	by smtp.gmail.com with ESMTPSA id e8sm295045pgj.8.2020.10.15.15.05.23
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 15 Oct 2020 15:05:23 -0700 (PDT)
Date: Thu, 15 Oct 2020 22:05:19 +0000
From: Satya Tangirala <satyat@google.com>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <20201015220519.GB48329@google.com>
References: <20200909234422.76194-1-satyat@google.com>
	<20200909234422.76194-3-satyat@google.com>
	<20200924012103.GE10500@redhat.com>
	<20200924073842.GA1894729@google.com>
	<20200924142353.GC13849@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20200924142353.GC13849@redhat.com>
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
X-Mailman-Approved-At: Fri, 16 Oct 2020 06:18:45 -0400
Cc: Jens Axboe <axboe@kernel.dk>, Eric Biggers <ebiggers@google.com>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/3] dm: add support for passing through
 inline crypto support
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

On Thu, Sep 24, 2020 at 10:23:54AM -0400, Mike Snitzer wrote:
> On Thu, Sep 24 2020 at  3:38am -0400,
> Satya Tangirala <satyat@google.com> wrote:
> 
> > On Wed, Sep 23, 2020 at 09:21:03PM -0400, Mike Snitzer wrote:
> > > On Wed, Sep 09 2020 at  7:44pm -0400,
> > > Satya Tangirala <satyat@google.com> wrote:
> > > 
> > > > From: Eric Biggers <ebiggers@google.com>
> > > > 
> > > > Update the device-mapper core to support exposing the inline crypto
> > > > support of the underlying device(s) through the device-mapper device.
> > > > 
> > > > This works by creating a "passthrough keyslot manager" for the dm
> > > > device, which declares support for encryption settings which all
> > > > underlying devices support.  When a supported setting is used, the bio
> > > > cloning code handles cloning the crypto context to the bios for all the
> > > > underlying devices.  When an unsupported setting is used, the blk-crypto
> > > > fallback is used as usual.
> > > > 
> > > > Crypto support on each underlying device is ignored unless the
> > > > corresponding dm target opts into exposing it.  This is needed because
> > > > for inline crypto to semantically operate on the original bio, the data
> > > > must not be transformed by the dm target.  Thus, targets like dm-linear
> > > > can expose crypto support of the underlying device, but targets like
> > > > dm-crypt can't.  (dm-crypt could use inline crypto itself, though.)
> > > > 
> > > > When a key is evicted from the dm device, it is evicted from all
> > > > underlying devices.
> > > > 
> > > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > > Co-developed-by: Satya Tangirala <satyat@google.com>
> > > > Signed-off-by: Satya Tangirala <satyat@google.com>
> > > > ---
> > > >  block/blk-crypto.c              |  1 +
> > > >  block/keyslot-manager.c         | 34 ++++++++++++
> > > >  drivers/md/dm-core.h            |  4 ++
> > > >  drivers/md/dm-table.c           | 52 +++++++++++++++++++
> > > >  drivers/md/dm.c                 | 92 ++++++++++++++++++++++++++++++++-
> > > >  include/linux/device-mapper.h   |  6 +++
> > > >  include/linux/keyslot-manager.h |  7 +++
> > > >  7 files changed, 195 insertions(+), 1 deletion(-)
> > > > 
> 
> > > > diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
> > > > index c4ef1fceead6..4542050eebfc 100644
> > > > --- a/drivers/md/dm-core.h
> > > > +++ b/drivers/md/dm-core.h
> > > > @@ -12,6 +12,7 @@
> > > >  #include <linux/kthread.h>
> > > >  #include <linux/ktime.h>
> > > >  #include <linux/blk-mq.h>
> > > > +#include <linux/keyslot-manager.h>
> > > >  
> > > >  #include <trace/events/block.h>
> > > >  
> > > > @@ -49,6 +50,9 @@ struct mapped_device {
> > > >  
> > > >  	int numa_node_id;
> > > >  	struct request_queue *queue;
> > > > +#ifdef CONFIG_BLK_INLINE_ENCRYPTION
> > > > +	struct blk_keyslot_manager ksm;
> > > > +#endif
> > > >  
> > > >  	atomic_t holders;
> > > >  	atomic_t open_count;
> > > 
> > > Any reason you placed the ksm member where you did?
> > > 
> > > Looking at 'struct blk_keyslot_manager' I'm really hating adding that
> > > bloat to every DM device for a feature that really won't see much broad
> > > use (AFAIK).
> > > 
> > > Any chance you could allocate 'struct blk_keyslot_manager' as needed so
> > > that most users of DM would only be carrying 1 extra pointer (set to
> > > NULL)?
> >
> > I don't think there's any technical problem with doing that - the only
> > other thing that would need addressing is that the patch uses
> > "container_of" on that blk_keyslot_manager in dm_keyslot_evict() to get
> > a pointer to the struct mapped_device. I could try adding a "private"
> > field to struct blk_keyslot_manager and store a pointer to the struct
> > mapped_device there).
> 
> Yes, that'd be ideal.
> 
> As for the lifetime of the struct blk_keyslot_manager pointer DM would
> manage (in your future code revision): you meantioned in one reply that
> the request_queue takes care of setting up the ksm... but the ksm
> is tied to the queue at a later phase using blk_ksm_register(). 
> 
I probably wasn't clear in that reply :(. So the request_queue isn't
responsible for setting up the ksm - setting up the ksm in the request
queue is the responsibility of the DM device.
> In any case, I think my feature reequest (to have DM allocate the ksm
> struct only as needed) is a bit challenging because of how DM allocates
> the request_queue upfront in alloc_dev() and then later completes the
> request_queue initialization based on DM_TYPE* in dm_setup_md_queue().
> 
> It _could_ be that you'll need to add a new DM_TYPE_KSM_BIO_BASED or
> something.  But you have a catch-22 in that the dm-table.c code to
> establish the intersection of supported modes assumes ksm is already
> allocated.  So something needs to give by reasoning through: _what_ is
> the invariant that will trigger the delayed allocation of the ksm
> struct?  I don't yet see how you can make that informed decision that
> the target(s) in the DM table _will_ use the ksm if it exists.
> 
What I tried doing in the next version that I just sent out was to get
the DM device to set up the ksm as appropriate on table swaps (and also
to verify the "new" ksm on table swaps and loads, so that we reject any
new table that would require a new ksm that would drop any capabability
that the current ksm supports)
> But then once the ksm is allocated, it never gets allocated again
> because md->queue->ksm is already set, and it inherits the lifetime that
> is used when destroying the mapped_device (md->queue, etc).
>
This is what the new version of the series does :). It also just sets up
the ksm directly in md->queue, and completely drops the md->ksm field
(because unless I'm misunderstanding things, each DM device is
associated with exactly one queue).

Btw, the new version is at

https://lore.kernel.org/linux-block/20201015214632.41951-1-satyat@google.com/

> Mike
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

