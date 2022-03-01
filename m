Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76417C433F5
	for <dm-devel@archiver.kernel.org>; Tue,  1 Mar 2022 21:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646169612;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7mB4PIFB8w2tiUqoSsRHRXl9Lo6Yx/C/rxuynrFVF3w=;
	b=CGIVVTMxcJTKkuEP+fXWMFzq71JMyguuXrHaQLmsVs34dKvBGIQpuU1fokrb5/e/MsvcRJ
	hGZxISU+ZA+M+6WbRpsn1e+2eOD8ck9N2qkImrZWeyLWLb+qFplCZ/DMerOmU9QL7Wj5IN
	pOxirKNfJQRS3ke5tBK0dK7NMVOr57M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-253-5TOEtLI4OkqAWbENjL8lrQ-1; Tue, 01 Mar 2022 16:20:10 -0500
X-MC-Unique: 5TOEtLI4OkqAWbENjL8lrQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6904B1006AA7;
	Tue,  1 Mar 2022 21:20:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7833A56F71;
	Tue,  1 Mar 2022 21:20:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1DCA21809C98;
	Tue,  1 Mar 2022 21:19:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 221LJsk0027729 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Mar 2022 16:19:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5FDB51120AB2; Tue,  1 Mar 2022 21:19:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A060112133E
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 21:19:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58C2F8F3BC0
	for <dm-devel@redhat.com>; Tue,  1 Mar 2022 21:19:47 +0000 (UTC)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
	[209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-600-UlAWRq8HNBSk8gJ0T1gpjA-1; Tue, 01 Mar 2022 16:19:44 -0500
X-MC-Unique: UlAWRq8HNBSk8gJ0T1gpjA-1
Received: by mail-qt1-f197.google.com with SMTP id
	f13-20020ac8014d000000b002ddae786fb0so8218561qtg.19
	for <dm-devel@redhat.com>; Tue, 01 Mar 2022 13:19:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=zhGsISEne7ayegiBuC0VI77v51JSASEUVzAtdh+UqeM=;
	b=f+WNMFWGDwfXkVH49vQWKt1sXgYwqNPOyJs2GbSQ/LzKUMMGCe0KmzZHvaPAWIEAUc
	bpS+VupNj8cGPMCPTOLSJYDLcppRLcUpGvP3f1xeeOVC87YIofEeGuiU9G2dJBTrmUMf
	LaG8rEd2kxGOCwDTZg7xjrhsdr1ohPIQxNRO6rxzLUrXOirJWPCoYS6saP3wucC5Tzg6
	GnDsUYPpoEfUqW1XZwrWtUm6YiIv+Lbc23Fx1lxAobjBQIJM5PisP2qw/pdIeYd8cHnV
	I+ed6t4X55DT4mGUhMnUTpkaMtwi3+o61YkOdMBb5LyCrHxUOoMY8tpL1TTl+bfALXQf
	hGSg==
X-Gm-Message-State: AOAM533ASmiVUx+ATbvi+Eesz5BtHc0fXJbLW1mJHcoJoXNOUBqm0g2q
	32uDAo2ijmTySKvn/86e39Ocl1d3+U6ZJ5C8LjrdEQev2gKYcW2LWGpWxPaEgydivKgKO6a1MbN
	pNwerKdcG0yEJwA==
X-Received: by 2002:a37:464c:0:b0:60b:6be8:29ae with SMTP id
	t73-20020a37464c000000b0060b6be829aemr14693625qka.126.1646169583744;
	Tue, 01 Mar 2022 13:19:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxdhhv8FXLh+s6pIY25DENmaFxbVp4vb4H3/pCOuTKcqaohrWojF+hMg+3FnTB0/X5W7hjY7g==
X-Received: by 2002:a37:464c:0:b0:60b:6be8:29ae with SMTP id
	t73-20020a37464c000000b0060b6be829aemr14693615qka.126.1646169583532;
	Tue, 01 Mar 2022 13:19:43 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	o200-20020a37a5d1000000b0064904a35862sm7092093qke.96.2022.03.01.13.19.42
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 01 Mar 2022 13:19:43 -0800 (PST)
Date: Tue, 1 Mar 2022 16:19:42 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <Yh6N7msbMBcANFxg@redhat.com>
References: <20210623074032.1484665-1-ming.lei@redhat.com>
	<Yhz4AGXcn0DUeSwq@redhat.com> <Yh1vrWXlaTnEcrNd@T590>
MIME-Version: 1.0
In-Reply-To: <Yh1vrWXlaTnEcrNd@T590>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH V3 0/3] block/dm: support bio polling
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

On Mon, Feb 28 2022 at  7:58P -0500,
Ming Lei <ming.lei@redhat.com> wrote:

> On Mon, Feb 28, 2022 at 11:27:44AM -0500, Mike Snitzer wrote:
> > 
> > Hey Ming,
> > 
> > I'd like us to follow-through with adding bio-based polling support.
> > Kind of strange none of us that were sent this V3 ever responded,
> > sorry about that!
> > 
> > Do you have interest in rebasing this patchset (against linux-dm.git's
> > "dm-5.18" branch since there has been quite some churn)?  Or are you
> > OK with me doing the rebase?
> 
> Hi Mike,
> 
> Actually I have one local v5.17 rebase:
> 
> https://github.com/ming1/linux/tree/my_v5.17-dm-io-poll
> 
> Also one for-5.18/block rebase which is done just now:
> 
> https://github.com/ming1/linux/tree/my_v5.18-dm-bio-poll
> 
> In my previous test on v5.17 rebase, the IOPS improvement is a bit small,
> so I didn't post it out. Recently not get time to investigate
> the performance further, so please feel free to work on it.

OK, I've rebased it on dm-5.18.

Can you please share the exact test(s) you were running?  I assume you
were running directly against a request-based device and then
comparing polling perf through dm-linear to the same underlying
request-based device?

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

