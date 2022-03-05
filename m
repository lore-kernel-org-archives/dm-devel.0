Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D766C433F5
	for <dm-devel@archiver.kernel.org>; Sat,  5 Mar 2022 01:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646443887;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1PyHpos5fL8mQelQlP74ZAAofwwtT+JxYtEpu6XJBvQ=;
	b=TDsMnDDT2hBOld1XD02oiq4FMERNv58JSYi+WKCfSsP9HbKYiK3qYU4FAZ6uNYjYhr+ZXo
	dfAj+pbvUZrNLpILToddwmfHYlbAk8GHcDs1sQhHccPeORtmwe5VL4jz7fSUsL6zmvjp9I
	pR0AR8oMfYwtqv9hJEavs4Xwk7JCx4c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-318-yrzlT5OYO6i6JXzeqYQNrQ-1; Fri, 04 Mar 2022 20:31:23 -0500
X-MC-Unique: yrzlT5OYO6i6JXzeqYQNrQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D5745200;
	Sat,  5 Mar 2022 01:31:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 18BFC1078646;
	Sat,  5 Mar 2022 01:31:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5DD204A701;
	Sat,  5 Mar 2022 01:31:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2251UrKZ026627 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Mar 2022 20:30:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B304C2024CAE; Sat,  5 Mar 2022 01:30:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AD0462026D7F
	for <dm-devel@redhat.com>; Sat,  5 Mar 2022 01:30:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71F59811E75
	for <dm-devel@redhat.com>; Sat,  5 Mar 2022 01:30:49 +0000 (UTC)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
	[209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-132-ifcv60EaNGeKbZCtwtc6-A-1; Fri, 04 Mar 2022 20:30:48 -0500
X-MC-Unique: ifcv60EaNGeKbZCtwtc6-A-1
Received: by mail-qk1-f198.google.com with SMTP id
	k23-20020a05620a139700b0062cda5c6cecso6978238qki.6
	for <dm-devel@redhat.com>; Fri, 04 Mar 2022 17:30:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=f4W8ElG6mZSwqXHqNnnksVWh+tmZbEVnR0mSgqWcpZ0=;
	b=eav4jL9TC9+HLGtSRv8UHRfLIstCYqt+PuNAlzlrOXxWUzboyBvoTMssNkdAUGbUSd
	E9sviI1xLKyjVrrAhYesawOax7H3oA0N1RqUNn2ChSjrBwSarqRSWtwcuxnj7LMAj/K9
	yIfZYZGHOuyanrI6YsqZohp43WYdBM7EPpZkaViCZMCyiSrb3Bnk1UOpJ4jsPMC2WtG1
	//zmuyyCe58U3o2gt5VltrfDF5bsbMro+L0elYqgrigYLgvkc1Fsl+aE2MKHSWwuznzL
	MfkIdib9Ruo/aDRD9JKUe87Qbyf79flh1MnNfDz1Son+DiC5AXaw4cdbWwzGKuXcKpe5
	AE0g==
X-Gm-Message-State: AOAM532bRgQqVB9i20sb7hNqImpeGtAduOXEXojS4OeTVkG43n7+zgOA
	kEGI4DcWFb2TjlAw3+3FmcvI2sAZE3/u7xkAySAWMnlAyoj2380M5yUJ1lrgepAozZFCTjb+nb/
	ZSrLDAYOaCO6MMg==
X-Received: by 2002:a05:6214:c4d:b0:432:923d:17ae with SMTP id
	r13-20020a0562140c4d00b00432923d17aemr1003996qvj.18.1646443847883;
	Fri, 04 Mar 2022 17:30:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx0ZfdGLhXz1qz87zG4hDSJWdc7ym3JCEtuN3XDxEZNrkSgeSmockEsKIFOYmh6d+2StzLyfg==
X-Received: by 2002:a05:6214:c4d:b0:432:923d:17ae with SMTP id
	r13-20020a0562140c4d00b00432923d17aemr1003988qvj.18.1646443847636;
	Fri, 04 Mar 2022 17:30:47 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	g2-20020a37e202000000b00607e264a208sm3125054qki.40.2022.03.04.17.30.46
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 04 Mar 2022 17:30:47 -0800 (PST)
Date: Fri, 4 Mar 2022 20:30:46 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <YiK9Rgvx0Z3aOGNQ@redhat.com>
References: <20220304212623.34016-1-snitzer@redhat.com>
	<20220304212623.34016-2-snitzer@redhat.com>
	<68dc8fb0-86df-effe-4ef2-8ed9c350d836@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <68dc8fb0-86df-effe-4ef2-8ed9c350d836@kernel.dk>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de,
	ming.lei@redhat.com
Subject: Re: [dm-devel] [PATCH v4 1/2] block: add ->poll_bio to
	block_device_operations
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

On Fri, Mar 04 2022 at  4:39P -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 3/4/22 2:26 PM, Mike Snitzer wrote:
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 94bf37f8e61d..e739c6264331 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -985,10 +985,16 @@ int bio_poll(struct bio *bio, struct io_comp_batch *iob, unsigned int flags)
> >  
> >  	if (blk_queue_enter(q, BLK_MQ_REQ_NOWAIT))
> >  		return 0;
> > -	if (WARN_ON_ONCE(!queue_is_mq(q)))
> > -		ret = 0;	/* not yet implemented, should not happen */
> > -	else
> > +	if (queue_is_mq(q)) {
> >  		ret = blk_mq_poll(q, cookie, iob, flags);
> > +	} else {
> > +		struct gendisk *disk = q->disk;
> > +
> > +		if (disk && disk->fops->poll_bio)
> > +			ret = disk->fops->poll_bio(bio, iob, flags);
> > +		else
> > +			ret = !WARN_ON_ONCE(1);
> 
> This is an odd way to do it, would be a lot more readable as
> 
> 	ret = 0;
> 	WARN_ON_ONCE(1);
> 
> if we even need that WARN_ON?

Would be a pretty glaring oversight for a bio-based driver developer
to forget to define ->poll_bio but remember to clear BLK_QC_T_NONE in
bio->bi_cookie and set QUEUE_FLAG_POLL in queue flags.

Silent failure it is! ;)

> > diff --git a/block/genhd.c b/block/genhd.c
> > index e351fac41bf2..eb43fa63ba47 100644
> > --- a/block/genhd.c
> > +++ b/block/genhd.c
> > @@ -410,6 +410,8 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
> >  	struct device *ddev = disk_to_dev(disk);
> >  	int ret;
> >  
> > +	WARN_ON_ONCE(queue_is_mq(disk->queue) && disk->fops->poll_bio);
> 
> Also seems kind of useless, maybe at least combine it with failing to
> add the disk. This is a "I'm developing some new driver or feature"
> failure, and would be more visible that way. And if you do that, then
> the WARN_ON_ONCE() seems pointless anyway, and I'd just do:
> 
> 	if (queue_is_mq(disk->queue) && disk->fops->poll_bio)
> 		return -EINVAL;
> 
> or something like that, with a comment saying why that doesn't make any
> sense.

Absolutely. The thought did cross my mind that it seemed WARN_ON heavy.

Will fix it up and send v5.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

