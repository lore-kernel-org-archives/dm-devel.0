Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74F36C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jan 2022 19:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1641842805;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CshwySR61ua4GWTkCW7IB+WkN75pgGmheVFMx2zxn2U=;
	b=MCHwZ4zBdWA433zdj9S4JzngyyvGMH579mNP5TnDFLv0GMRs6zSwBotN6z+hudJsY0ZQw3
	zXQft5sQ3MllycOeiltQTHh07fNCflXRot4DL64mRCmktlDzPMKWNFPLcWUUnn7QHG1QAn
	ipUWzcHVZHFTkLwnI/NaYvTveDl9S5A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-bF5eqKiaMMerHjQ2p_htnA-1; Mon, 10 Jan 2022 14:26:41 -0500
X-MC-Unique: bF5eqKiaMMerHjQ2p_htnA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B42118C8C03;
	Mon, 10 Jan 2022 19:26:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E5D6A10001AF;
	Mon, 10 Jan 2022 19:26:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1B8E51809CB8;
	Mon, 10 Jan 2022 19:26:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20AJQXmE002837 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 10 Jan 2022 14:26:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9C337492D18; Mon, 10 Jan 2022 19:26:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 98026492CA3
	for <dm-devel@redhat.com>; Mon, 10 Jan 2022 19:26:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DC5D800141
	for <dm-devel@redhat.com>; Mon, 10 Jan 2022 19:26:33 +0000 (UTC)
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
	[209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-418-mguf0e4yOzyG4Q-XC0UnHA-1; Mon, 10 Jan 2022 14:26:32 -0500
X-MC-Unique: mguf0e4yOzyG4Q-XC0UnHA-1
Received: by mail-qv1-f70.google.com with SMTP id
	jo14-20020a056214500e00b00411de582251so14083359qvb.8
	for <dm-devel@redhat.com>; Mon, 10 Jan 2022 11:26:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=yZ08XZ8idEJY7dNL/CjmIYmeW6lP9L5GGjs6T10cj9s=;
	b=VtcKUi9GQIYTCWTZpb5Z/DEWup+wGV/6pzha3ifRT9yUQCSGS1AQ3lusOyRXOQmP5j
	lZBA/eOC1B1kqYPEhFU+IMC/SS+TqDOa5/ysSpUhl5fIgCTuPIzNUVqROwneKffEkZuM
	ayJA087P2PmRBV+lqKinWcpq2odpmKpP+xf4YhelQehOJuNWKzIXv7zSSWKbUAwM1yNk
	BgNxARVe+vxgb7ojZXFhQWSK5Ntre+x8t8Kq4rfCJ60Yms+29xKc1HCnEnWrjLpdSPgK
	YpgOAutl0mSHUEMZbX2D2waGzXLYMFY7F8ymQQko6q0C2waBie0z7v0DzU8sR4Bq03bw
	M9Wg==
X-Gm-Message-State: AOAM532sK3MmO2yo3Rjd3K/eX17RUKCjZyJUjk3bhNjcNiuZYpTCEws+
	/2sL8eNbxpTYY2cguLcs+pf9UkjZBpKYao7YJd6xqceGEFmNm0O13GpMoNVGSg81yZqGKeLmHXE
	lfEC9aHVFZOw1Vg==
X-Received: by 2002:a05:620a:2015:: with SMTP id
	c21mr883057qka.383.1641842791595; 
	Mon, 10 Jan 2022 11:26:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwwHjM+t1bgDCUU60h+0opXhwpp98ZNY2fG6MTGB7kRs/0equHHPiJppDI0OZXqDMqD3jRW+w==
X-Received: by 2002:a05:620a:2015:: with SMTP id
	c21mr883046qka.383.1641842791400; 
	Mon, 10 Jan 2022 11:26:31 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	o21sm5295158qta.89.2022.01.10.11.26.30
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 10 Jan 2022 11:26:30 -0800 (PST)
Date: Mon, 10 Jan 2022 14:26:29 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <YdyIZR4LkQTVjhWf@redhat.com>
References: <20211221141459.1368176-1-ming.lei@redhat.com>
	<YcH/E4JNag0QYYAa@infradead.org> <YcP4FMG9an5ReIiV@T590>
	<YcuB4K8P2d9WFb83@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YcuB4K8P2d9WFb83@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	dm-devel@redhat.com, linux-block@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 0/3] blk-mq/dm-rq: support BLK_MQ_F_BLOCKING
	for dm-rq
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

On Tue, Dec 28 2021 at  4:30P -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Wed, Dec 22 2021 at 11:16P -0500,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
> > On Tue, Dec 21, 2021 at 08:21:39AM -0800, Christoph Hellwig wrote:
> > > On Tue, Dec 21, 2021 at 10:14:56PM +0800, Ming Lei wrote:
> > > > Hello,
> > > > 
> > > > dm-rq may be built on blk-mq device which marks BLK_MQ_F_BLOCKING, so
> > > > dm_mq_queue_rq() may become to sleep current context.
> > > > 
> > > > Fixes the issue by allowing dm-rq to set BLK_MQ_F_BLOCKING in case that
> > > > any underlying queue is marked as BLK_MQ_F_BLOCKING.
> > > > 
> > > > DM request queue is allocated before allocating tagset, this way is a
> > > > bit special, so we need to pre-allocate srcu payload, then use the queue
> > > > flag of QUEUE_FLAG_BLOCKING for locking dispatch.
> > > 
> > > What is the benefit over just forcing bio-based dm-mpath for these
> > > devices?
> > 
> > At least IO scheduler can't be used for bio based dm-mpath, also there should
> > be other drawbacks for bio based mpath and request mpath is often the default
> > option, maybe Mike has more input about bio vs request dm-mpath.
> 
> Yeah, people use request-based for IO scheduling and more capable path
> selectors. Imposing bio-based would be a pretty jarring workaround for 
> BLK_MQ_F_BLOCKING. request-based DM should properly support it.
> 
> I'm on vacation for the next week but will have a look at this
> patchset once I'm back.

I replied last week and hoped Jens would pick this patchset up after
my Reviewed-by of patch 3/3.

Christoph wasn't back though, so best to kick this thread again.

Thoughts on this patchset?

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

