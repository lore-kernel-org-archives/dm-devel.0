Return-Path: <SRS0=1REc=D5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D348AC4363A
	for <dm-devel@archiver.kernel.org>; Thu, 22 Oct 2020 18:35:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 29E962417D
	for <dm-devel@archiver.kernel.org>; Thu, 22 Oct 2020 18:35:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZOCsc6Oz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 29E962417D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1603391739;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EK2thpElORL+O7+ZLFKGCNsVhOxUedxuQqX3Oq+Oyxk=;
	b=ZOCsc6Oz+FjWjsNYdLSgK4TbjVm7IkeNuz1+IsAS2o4srR9bGHA0luYWDT3yTl/3tprKNj
	okl4Uj4RDZReBhA60nzgnEsPoAA5QyICNL+xhnQEEQqJ6REoX1aHnuchJcFYpOISz5wcrF
	hbC2lLeGg3fA92WzdKw2Tmu1WM6bbb8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-eUK_NtPqPs-57EE5GPlX9Q-1; Thu, 22 Oct 2020 14:35:35 -0400
X-MC-Unique: eUK_NtPqPs-57EE5GPlX9Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A6821074661;
	Thu, 22 Oct 2020 18:35:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EC7B19744;
	Thu, 22 Oct 2020 18:35:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 616F744A43;
	Thu, 22 Oct 2020 18:35:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09MIZJ8n030904 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 22 Oct 2020 14:35:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5AC54201828C; Thu, 22 Oct 2020 18:35:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 55B42206401F
	for <dm-devel@redhat.com>; Thu, 22 Oct 2020 18:35:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 381FC811E82
	for <dm-devel@redhat.com>; Thu, 22 Oct 2020 18:35:17 +0000 (UTC)
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com
	[209.85.210.195]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-433-mTQ6wqEVOGWN7iuCyuUNlg-1; Thu, 22 Oct 2020 14:35:15 -0400
X-MC-Unique: mTQ6wqEVOGWN7iuCyuUNlg-1
Received: by mail-pf1-f195.google.com with SMTP id e10so1695944pfj.1;
	Thu, 22 Oct 2020 11:35:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=1XI2Q+0LJ+MrF6PTdb/vTI0hg1qM7/BgdBxfc/cQLFU=;
	b=lhk+qQ4Wh/6+6Pi5x5PVEX4NhBfb4IoFuXuJo2w9GS6CBsswWbYeY487VuFMCLrxVC
	Ptkf0Waecg9JusXPH5sWpoAP2Vn6PtDzxuQ/QWIoR5S0WBcVIahH/TZXqpsogjAXPwAK
	aVcONCedr4p8bpbj032tc+4/EVCGmeGrAR0QdDK2QpAhqqOTyZ9wA9rB+xLykaOd8pp4
	GGbeZMzPOt+67etFfHhvB3456zt3lbsWts+ShqsRooB7+BAqWk9uXyKUWRR0C/UxjUAP
	qPAWnGPoX/2VNHuvzWGVtw0sJK4ElsR38PllZdEMCTsFlac1XpxQ8fmpTJ4tbcNUejxX
	QKtg==
X-Gm-Message-State: AOAM533tj3gNUADcHsgiD1feDlyIMmykVSLiJs4W6HmPjFUDtJ3+2CkE
	+e2HR6FaoNUBvyPTTbSef8+71ksYHoBN1l3mwG9leLgJYFiCiw==
X-Google-Smtp-Source: ABdhPJz36fkFyGr3qzw17+AgK9oYpIzBshcfChZVSHFTISPy8X4z6IdPGqE/7nwcLSyFF6/1DoPxCQ5X7a4DVfLIwnM=
X-Received: by 2002:a63:a546:: with SMTP id r6mr3310324pgu.160.1603391713825; 
	Thu, 22 Oct 2020 11:35:13 -0700 (PDT)
MIME-Version: 1.0
References: <1603271049-20681-1-git-send-email-sergei.shtepa@veeam.com>
In-Reply-To: <1603271049-20681-1-git-send-email-sergei.shtepa@veeam.com>
From: Mike Snitzer <snitzer@redhat.com>
Date: Thu, 22 Oct 2020 14:35:02 -0400
Message-ID: <CAMM=eLfTf2f2Me7f5tpL5DEGgKsqaFaAS0qTDVpLAYrwR5Jf5g@mail.gmail.com>
To: Sergei Shtepa <sergei.shtepa@veeam.com>
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
Cc: Jan Kara <jack@suse.cz>, gustavo@embeddedor.com, linux-mm@kvack.org,
	device-mapper development <dm-devel@redhat.com>,
	Pavel Machek <pavel@ucw.cz>, steve@sk2.org, osandov@fb.com,
	Bart Van Assche <bvanassche@acm.org>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Christoph Hellwig <hch@infradead.org>, len.brown@intel.com,
	linux-pm@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
	linux-block <linux-block@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, koct9i@gmail.com,
	Jens Axboe <axboe@kernel.dk>, Damien Le Moal <damien.lemoal@wdc.com>,
	johannes.thumshirn@wdc.com, rjw@rjwysocki.net,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-xfs@vger.kernel.org, Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [dm-devel] [PATCH 0/2] block layer filter and block device
	snapshot module
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Oct 21, 2020 at 5:04 AM Sergei Shtepa <sergei.shtepa@veeam.com> wrote:
>
> Hello everyone! Requesting for your comments and suggestions.
>
> # blk-filter
>
> Block layer filter allows to intercept BIO requests to a block device.
>
> Interception is performed at the very beginning of the BIO request
> processing, and therefore does not affect the operation of the request
> processing queue. This also makes it possible to intercept requests from
> a specific block device, rather than from the entire disk.
>
> The logic of the submit_bio function has been changed - since the
> function execution results are not processed anywhere (except for swap
> and direct-io) the function won't return a value anymore.

Your desire to switch to a void return comes exactly when I've noticed
we need it.

->submit_bio's blk_qc_t return is the cookie assigned by blk-mq.  Up
to this point we haven't actually used it for bio-based devices but it
seems clear we'll soon need for bio-based IO polling support.

Just today, I've been auditing drivers/md/dm.c with an eye toward
properly handling the blk_qc_t return (or lack thereof) from various
DM methods.

It could easily be that __submit_bio_noacct and __submit_bio_noacct_mq
will be updated to do something meaningful with the returned cookie
(or that DM will) to facilitate proper IO polling.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

