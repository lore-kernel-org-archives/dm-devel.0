Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8253C433F5
	for <dm-devel@archiver.kernel.org>; Sat,  5 Mar 2022 02:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646446549;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fB4d9cJn4b1FknYYD6DMvyagFBpsydada3VteDcnjrc=;
	b=DPxr5ehe88BBq+XAUG6tVfAU4QU6/0EiFKp8U21FUZzYy8ZLEtnh8WNniMlyZS3+gWYXr4
	6n6f6Nme8wg3Z7hMSmaiiMHOaVUIZWD5TCbrsJ2mZ6pr0EdpETwmGHk6kKn2GKeK9dRSsW
	PfuWb1OnH9Ol+I8rpp3PgZq5NcKkRJg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37-F55gURIKM4Gnxi0geidBDA-1; Fri, 04 Mar 2022 21:15:46 -0500
X-MC-Unique: F55gURIKM4Gnxi0geidBDA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13349801AAD;
	Sat,  5 Mar 2022 02:15:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D74EC45D94;
	Sat,  5 Mar 2022 02:15:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 68A3D1809C98;
	Sat,  5 Mar 2022 02:15:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2252EOOZ029459 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Mar 2022 21:14:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1630640F9D45; Sat,  5 Mar 2022 02:14:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 11F2A40F9D40
	for <dm-devel@redhat.com>; Sat,  5 Mar 2022 02:14:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA590801585
	for <dm-devel@redhat.com>; Sat,  5 Mar 2022 02:14:23 +0000 (UTC)
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
	[209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-125--atKtYfkMqyg8lKp2yAEIg-1; Fri, 04 Mar 2022 21:14:22 -0500
X-MC-Unique: -atKtYfkMqyg8lKp2yAEIg-1
Received: by mail-qt1-f200.google.com with SMTP id
	b17-20020ac85bd1000000b002dd92bd20e4so7629792qtb.3
	for <dm-devel@redhat.com>; Fri, 04 Mar 2022 18:14:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=mQ3j752MT2c0Va4+BHXixIvzPf7SXNYhTYkAyxToXME=;
	b=5KgPxs2dtoiD4PYLF1hoiKktvnYHkCPndevJeP3VNrIuruT9WLVdwHTnQkKlcZQ4FU
	qmZyYe+WR1r9KIvmU6vuJe7xEwYQrFuOOhGuzmcylv0d/zWpQBMDr5FaXC8KLobwCnQq
	VHYhdwIgM4o4bFOYURCTz9TypSXGz5mY5myM0kjKTsF8T2FxfVDbdqD5VjSFk+umcZ0u
	LTvq4SzG74Us4tAs7lo/mxuqAR78J+658IrJWS0fLpNbP+uhRzVfd9DQ/XUtWTT9oCjc
	qQ9WQ8d5lmntuXOPi7sO5sz06keo1ootMbAyOu4zuR49qYOIbx6uyT4hzIhBcK7YCfrn
	zxmg==
X-Gm-Message-State: AOAM533NFz0jbF5p/8ph04v4A8q+POsq3/XY9MzLMjlel9O/mQKBEM87
	u3mU5Ylj9NaccGI2bMpkO/uatiqvNR5zfYikqLYcPv6Ew27huJknLxrtafe36NGcuzuWnd7FCO4
	GfDklxIh7q2Drow==
X-Received: by 2002:ad4:5f0e:0:b0:432:e889:810c with SMTP id
	fo14-20020ad45f0e000000b00432e889810cmr1361640qvb.37.1646446462507;
	Fri, 04 Mar 2022 18:14:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxMC+u1zy14ii7oCjULtwAClNOzsgkoDddDB0O4sbnNOAbYlXBNmZaVvJ/Fj9elFqDGl9rI5Q==
X-Received: by 2002:ad4:5f0e:0:b0:432:e889:810c with SMTP id
	fo14-20020ad45f0e000000b00432e889810cmr1361628qvb.37.1646446462303;
	Fri, 04 Mar 2022 18:14:22 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	a19-20020ac85b93000000b002e0023473edsm4515100qta.95.2022.03.04.18.14.21
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 04 Mar 2022 18:14:21 -0800 (PST)
Date: Fri, 4 Mar 2022 21:14:21 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <YiLHfRYPDryUAO2D@redhat.com>
References: <20220304212623.34016-1-snitzer@redhat.com> <YiLAJIOZz9UHbUKq@T590>
MIME-Version: 1.0
In-Reply-To: <YiLAJIOZz9UHbUKq@T590>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com,
	hch@lst.de
Subject: Re: [dm-devel] [PATCH v4 0/2] block/dm: support bio polling
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Mar 04 2022 at  8:43P -0500,
Ming Lei <ming.lei@redhat.com> wrote:

> On Fri, Mar 04, 2022 at 04:26:21PM -0500, Mike Snitzer wrote:
> > Hi,
> > 
> > I've rebased Ming's latest [1] ontop of dm-5.18 [2] (which is based on
> > for-5.18/block). End result available in dm-5.18-biopoll branch [3]
> > 
> > These changes add bio polling support to DM.  Tested with linear and
> > striped DM targets.
> > 
> > IOPS improvement was ~5% on my baremetal system with a single Intel
> > Optane NVMe device (555K hipri=1 vs 525K hipri=0).
> > 
> > Ming has seen better improvement while testing within a VM:
> >  dm-linear: hipri=1 vs hipri=0 15~20% iops improvement
> >  dm-stripe: hipri=1 vs hipri=0 ~30% iops improvement
> > 
> > I'd like to merge these changes via the DM tree when the 5.18 merge
> > window opens.  The first block patch that adds ->poll_bio to
> > block_device_operations will need review so that I can take it
> > through the DM tree.  Reason for going through the DM tree is there
> > have been some fairly extensive changes queued in dm-5.18 that build
> > on for-5.18/block.  So I think it easiest to just add the block
> > depenency via DM tree since DM is first consumer of ->poll_bio
> > 
> > FYI, Ming does have another DM patch [4] that looks to avoid using
> > hlist but I only just saw it.  bio_split() _is_ involved (see
> > dm_split_and_process_bio) so I'm not exactly sure where he is going
> > with that change. 
> 
> io_uring(polling) workloads often cares latency, so big IO request
> isn't involved usually, I guess. Then bio_split() is seldom called in
> dm_split_and_process_bio(), such as if 4k random IO is run on dm-linear
> or dm-stripe via io_uring, bio_split() won't be run into.
> 
> Single list is enough here, and efficient than hlist, just need
> a little care to delete element from the list since linux kernel doesn't
> have generic single list implementation.

OK, makes sense, thanks for clarifying. But yeah its a bit fiddley for sure.

> > But that is DM-implementation detail that we'll
> > sort out.
> 
> Yeah, that patch also needs more test.

Yeap, sounds good.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

