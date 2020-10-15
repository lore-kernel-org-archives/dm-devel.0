Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84236C433DF
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:20:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D39F120848
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:20:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D39F120848
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-UyueqI9OPMeXa76-Be8Tbw-1; Fri, 16 Oct 2020 06:20:54 -0400
X-MC-Unique: UyueqI9OPMeXa76-Be8Tbw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33575100746A;
	Fri, 16 Oct 2020 10:20:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 19AC176649;
	Fri, 16 Oct 2020 10:20:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E6E4044A62;
	Fri, 16 Oct 2020 10:20:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09FLtjaF001954 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 15 Oct 2020 17:55:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 96CE62166BA0; Thu, 15 Oct 2020 21:55:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 915AE2166B28
	for <dm-devel@redhat.com>; Thu, 15 Oct 2020 21:55:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F793800186
	for <dm-devel@redhat.com>; Thu, 15 Oct 2020 21:55:43 +0000 (UTC)
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com
	[209.85.210.196]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-190-uaLTzILtPuOsVjtHMMOkdA-1; Thu, 15 Oct 2020 17:55:41 -0400
X-MC-Unique: uaLTzILtPuOsVjtHMMOkdA-1
Received: by mail-pf1-f196.google.com with SMTP id 144so246270pfb.4
	for <dm-devel@redhat.com>; Thu, 15 Oct 2020 14:55:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=Mp0fFCaPEBpQGNEbuV9IgZPXZ47zhWeprp5HxFaRp04=;
	b=lSrxP27F9vs7jYQIYAqGtdFLQb5NGDWawWIXnjM4b1lxMpq7n7ZaA3hP7syFKUToqA
	LpEktHIfRNpovonMbGMogOxoJEAHpEP8tOg7BI2M9R2E4ReGAKynOrYirRAgMrO9Mp3e
	Xjfw3+qqph1zKEbHHev1Q9MY4/CKrD4q8zuSpzjedsfivECb0ivFX3GPUYqJCTC2Vvaq
	IE+SAeEv5mIxykbgjoT8pSHFBQ0QHXquDeMlIFMr5oHiP+/yv4YNE/RRde2+AKrWlDd7
	lqdvTHX93rJFXoJi2PkXyeFsvG5CRkHkIwyzkpl6wku+eHmbrgwaPHYlkWYs9O7TGVh/
	YbnQ==
X-Gm-Message-State: AOAM533WZ+4AfpeX9y8gkzzFNpzvnGAi/aaxt/vH7z+BeUXu1HRrp1Du
	hxgvMwCHXvJv9Iv8vKhIRC7IeQ==
X-Google-Smtp-Source: ABdhPJxLXVcVr8KojpvEjCXdEZ6KAspUKoe2F0+QMs61OvnoBOXCEoHxSWNtaR7ijwwz2xclViQPrQ==
X-Received: by 2002:a62:7b11:0:b029:156:3610:7e25 with SMTP id
	w17-20020a627b110000b029015636107e25mr614898pfc.53.1602798939559;
	Thu, 15 Oct 2020 14:55:39 -0700 (PDT)
Received: from google.com (154.137.233.35.bc.googleusercontent.com.
	[35.233.137.154]) by smtp.gmail.com with ESMTPSA id
	js21sm303276pjb.14.2020.10.15.14.55.38
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 15 Oct 2020 14:55:38 -0700 (PDT)
Date: Thu, 15 Oct 2020 21:55:35 +0000
From: Satya Tangirala <satyat@google.com>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <20201015215535.GA48329@google.com>
References: <20200909234422.76194-1-satyat@google.com>
	<20200909234422.76194-3-satyat@google.com>
	<20200924012103.GE10500@redhat.com>
	<20200924074810.GB1894729@google.com>
	<20200924134021.GA13849@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20200924134021.GA13849@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Sep 24, 2020 at 09:40:22AM -0400, Mike Snitzer wrote:
> On Thu, Sep 24 2020 at  3:48am -0400,
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
> >
> > As in, any reason why it's placed right after the struct request_queue
> > *queue? The ksm is going to be set up in the request_queue and is a part
> > of the request_queue is some sense, so it seemed reasonable to me to
> > group them together....but I don't think there's any reason it *has* to
> > be there, if you think it should be put elsewhere (or maybe I'm
> > misunderstanding your question :) ).
> 
> Placing the full struct where you did is highly disruptive to the prior
> care taken to tune alignment of struct members within mapped_device.
> 
Ah I see - sorry about that! I ended up removing it entirely in the next
version of this series while trying to address this and your other
comments :). The next version is at

https://lore.kernel.org/linux-block/20201015214632.41951-5-satyat@google.com/

> Switching to a pointer will be less so, but even still it might be best
> to either find a hole in the struct (not looked recently, but there may
> not be one) or simply put it at the end of the structure.
> 
> The pahole utility is very useful for this kind of struct member
> placement, etc.  But it is increasingly unavailable in modern Linux
> distros...
> 
> Mike
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

