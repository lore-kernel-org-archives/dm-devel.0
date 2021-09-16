Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A289C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 17:34:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9B76A61056
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 17:34:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9B76A61056
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-gCJsBl18Mj2RSjry7QYaLg-1; Thu, 16 Sep 2021 13:34:36 -0400
X-MC-Unique: gCJsBl18Mj2RSjry7QYaLg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A16B19057A0;
	Thu, 16 Sep 2021 17:34:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6BD505B826;
	Thu, 16 Sep 2021 17:34:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E35FF4EA2A;
	Thu, 16 Sep 2021 17:34:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18GHSL6q010416 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 16 Sep 2021 13:28:21 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B5BB820A88AF; Thu, 16 Sep 2021 17:28:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B1D0220A0535
	for <dm-devel@redhat.com>; Thu, 16 Sep 2021 17:28:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DBAA2899ED0
	for <dm-devel@redhat.com>; Thu, 16 Sep 2021 17:28:18 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-6-OrA9-QWqPY6iNmmxRIEI7A-1;
	Thu, 16 Sep 2021 13:28:16 -0400
X-MC-Unique: OrA9-QWqPY6iNmmxRIEI7A-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id C64B1610E9;
	Thu, 16 Sep 2021 17:28:15 +0000 (UTC)
Date: Thu, 16 Sep 2021 10:28:14 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <YUN+rv31Wm3+dfo+@sol.localdomain>
References: <20210913013135.102404-1-ebiggers@kernel.org>
	<20210913013135.102404-3-ebiggers@kernel.org>
	<YUGjSR1g+EH0o2xo@infradead.org> <YUIyVajIjZdkPO7F@sol.localdomain>
	<YUL0ytosYfrs7nNi@infradead.org>
MIME-Version: 1.0
In-Reply-To: <YUL0ytosYfrs7nNi@infradead.org>
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
Cc: linux-block@vger.kernel.org, Satya Tangirala <satyaprateek2357@gmail.com>,
	dm-devel@redhat.com, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 2/5] blk-crypto-fallback: consolidate static
	variables
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

On Thu, Sep 16, 2021 at 08:39:54AM +0100, Christoph Hellwig wrote:
> On Wed, Sep 15, 2021 at 10:50:13AM -0700, Eric Biggers wrote:
> > Using "blk_crypto_fallback_*" for all these variables results in some pretty
> > long names, e.g. "blk_crypto_fallback_crypt_ctx_cache" and
> > "blk_crypto_fallback_num_prealloc_crypt_ctxs".  This proposal gives the best of
> > both worlds; the names are properly "namespaced" but there is also a shortcut to
> > refer to them (struct blk_crypto_fallback *fallback = &blk_crypto_fallback).
> 
> I'd just drop the second crypt in those.
> 
> > If this is going to be controversial I can just drop this patch, but I was
> > hoping there would be a way to make things more consistent.
> 
> I personally detest that pattern.  Not sure if that counts as
> controversial or even matters :)

The names are still pretty long even with the second "crypt" dropped from those
two.  How about just "fallback_*"?  It might be clear enough from the context.

Anyway, I've dropped this patch from the series for now.  This can be done later
we can agree on which approach to take.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

