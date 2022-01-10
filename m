Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A21AC433FE
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jan 2022 19:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1641841418;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ChvW0p79NLfC846qpAMHHCi81y7KuS+u8MCzXySjRl4=;
	b=gtTnUW98bd9pMSHmfrSHDD81/UItSWYj7IbWNr+t2gh3DIt5NxuiHA5uEmKic4Buiv3wc2
	1KNMjMb51XpTdiNczXJt5fjP4tY1j8ZsMIs4jY9k9cN4u4Mq1mZqArdG9aitPMSWwdBW1B
	ODIUe2WaL1fbFpcaA+u285SZInhLqQ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-Atlbi9lpMTyDJ6SF2Qf1eg-1; Mon, 10 Jan 2022 14:03:28 -0500
X-MC-Unique: Atlbi9lpMTyDJ6SF2Qf1eg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 806CC83DEA7;
	Mon, 10 Jan 2022 19:03:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F0B75D6D5;
	Mon, 10 Jan 2022 19:03:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7C8A84BB7C;
	Mon, 10 Jan 2022 19:03:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20AJ3KR4001559 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 10 Jan 2022 14:03:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CDEC7400E117; Mon, 10 Jan 2022 19:03:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C9F1740149B4
	for <dm-devel@redhat.com>; Mon, 10 Jan 2022 19:03:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1085805BFC
	for <dm-devel@redhat.com>; Mon, 10 Jan 2022 19:03:20 +0000 (UTC)
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
	[209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-627-RB48vez-NaW1PgvCPdPTLQ-1; Mon, 10 Jan 2022 14:03:19 -0500
X-MC-Unique: RB48vez-NaW1PgvCPdPTLQ-1
Received: by mail-qv1-f70.google.com with SMTP id
	o14-20020ad45c8e000000b004112b52fc2cso14012783qvh.6
	for <dm-devel@redhat.com>; Mon, 10 Jan 2022 11:03:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=wJVpXmFJvi99AqmLB99IJstD9nuMHAk3xaEQkzCNADQ=;
	b=srZ2KPlDIi3zicpit7Y7P4UorDooGhDLK3Ogbp68qdDveqTcs6SfvSXZZgQJicTOmG
	0rXuBs/UqPLN2zvXbWO/COjWZpDt1kos2jfTM7CtnjAXs19mSB26YHcxljX6AsgqsEa4
	PQAlwzuDzlkN63trWshGgcmso/ThvX0gg6Zpr9IZ9pFwGJ/a0wCVI3vRO4oqVi+hbK0T
	R9NIPKS+Wtjas2jOdscqM1zr/7h652j5OLc+4zdOZGJ7cdmpavk2yaYQNc7XyoPfkP+h
	Cd4uzq39XCwL/udVizzi1NhC1Y0lL9wM6xxG1yOqg/shRpsZ77Y3awdgG9wgl9ijTRaX
	LBPw==
X-Gm-Message-State: AOAM532lxYFLByAqKoCM+QUpFU0+HHKt1FghodzZYmATthRZmJV5967U
	SUdznjx2wp+Lv/N0EtGvoq5BDDuCujf89uAU2kKKnAm7FFolnTrdN8r3eMekMzBnmptZvOmRhBA
	XgE4VciX4S3Ftlw==
X-Received: by 2002:a37:dc45:: with SMTP id v66mr833128qki.516.1641841398614; 
	Mon, 10 Jan 2022 11:03:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzDZRef9V/QtQImBhNEfUIX1j4IHs5Ip3sUthhzJGhtWzXF2cDrhAoBRB1f9r3zeMNRnQHO0A==
X-Received: by 2002:a37:dc45:: with SMTP id v66mr833116qki.516.1641841398397; 
	Mon, 10 Jan 2022 11:03:18 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	j22sm2687451qko.117.2022.01.10.11.03.17
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 10 Jan 2022 11:03:18 -0800 (PST)
Date: Mon, 10 Jan 2022 14:03:16 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <YdyC9KpQ7yC3l7RZ@redhat.com>
References: <20220110075141.389532-1-ming.lei@redhat.com>
	<20220110075141.389532-2-ming.lei@redhat.com>
	<YdxuWlZAPJkPyr3h@infradead.org>
MIME-Version: 1.0
In-Reply-To: <YdxuWlZAPJkPyr3h@infradead.org>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	lining <lining2020x@163.com>, Tejun Heo <tj@kernel.org>,
	Chunguang Xu <brookxu@tencent.com>
Subject: Re: [dm-devel] [PATCH 1/2] block: add resubmit_bio_noacct()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jan 10 2022 at 12:35P -0500,
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Jan 10, 2022 at 03:51:40PM +0800, Ming Lei wrote:
> > Add block layer API of resubmit_bio_noacct() for handling blk-throttle
> > iops limit correctly. Typical use case is that bio split, and it isn't
> > good to export blk_throtl_charge_bio_split() for drivers, so add new API
> > for serving such purpose.
> 
> Umm, submit_bio_noacct is meant exactly for this case of resubmitting
> a bio.  We should not need another API for that.
> 

Ming is lifting code out of __blk_queue_split() for reuse (by DM in
this instance, because it has its own bio_split+bio_chain).

Are you saying submit_bio_noacct() should be made to call
blk_throtl_charge_bio_split() and blk_throtl_charge_bio_split() simply
return if not a split bio? (not sure bio has enough context to know,
other than looking at some side-effect change from bio_chain)

But Ming: your __blk_queue_split() change seems wrong.
Prior to your patch __blk_queue_split() did:

bio_chain(split, *bio);
submit_bio_noacct(*bio);
*bio = split;
blk_throtl_charge_bio_split(*bio);

After your patch (effectively):

bio_chain(split, *bio);
submit_bio_noacct(*bio);
blk_throtl_charge_bio_split(bio);
*bio = split;

Maybe that was intended? (or maybe it doesn't matter because bio_split
copies fields with bio_clone_fast())?  Regardless, it is subtle.

Should blk_throtl_charge_bio_split() just be pushed down to
bio_split()?

In general, such narrow hacks for how to properly resubmit split bios
are asking for further trouble.  As is, I'm having to triage new
reports of bio-based accounting issues (which has called into question
my hack/fix commit a1e1cb72d9649 ("dm: fix redundant IO accounting for
bios that need splitting") that papered over this bigger issue of
needing proper split IO accounting, so likely needs to be revisited).

We also have the much bigger issue of IO poll support (or
lack-there-of) for split bios.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

