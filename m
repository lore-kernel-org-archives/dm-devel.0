Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A0A9C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 14:37:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E8EB564DD9
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 14:37:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8EB564DD9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-v3jreV6rOO-k2rI-uBAM9Q-1; Thu, 28 Jan 2021 09:37:38 -0500
X-MC-Unique: v3jreV6rOO-k2rI-uBAM9Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FC73107ACF9;
	Thu, 28 Jan 2021 14:37:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 089571A49B;
	Thu, 28 Jan 2021 14:37:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2FBC34BB40;
	Thu, 28 Jan 2021 14:37:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10SEasrP024270 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 09:36:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 61B342026D11; Thu, 28 Jan 2021 14:36:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D6E72026D76
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 14:36:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE671100FBC6
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 14:36:51 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-85-XQFHNVayNXGE2_AHTVUJwg-1; Thu, 28 Jan 2021 09:36:49 -0500
X-MC-Unique: XQFHNVayNXGE2_AHTVUJwg-1
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat
	Linux)) id 1l58PY-008Zc6-Qb; Thu, 28 Jan 2021 14:36:41 +0000
Date: Thu, 28 Jan 2021 14:36:40 +0000
From: Christoph Hellwig <hch@infradead.org>
To: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <20210128143640.GA2043450@infradead.org>
References: <20210125121340.70459-1-jefflexu@linux.alibaba.com>
	<20210125121340.70459-4-jefflexu@linux.alibaba.com>
	<20210128084016.GA1951639@infradead.org>
	<7d5402f2-c4d7-9d9a-e637-54a2dd349b3f@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <7d5402f2-c4d7-9d9a-e637-54a2dd349b3f@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: linux-block@vger.kernel.org, snitzer@redhat.com,
	Christoph Hellwig <hch@infradead.org>,
	joseph.qi@linux.alibaba.com, dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v2 3/6] block: add iopoll method to support
 bio-based IO polling
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jan 28, 2021 at 07:52:05PM +0800, JeffleXu wrote:
> 
> 
> On 1/28/21 4:40 PM, Christoph Hellwig wrote:
> > On Mon, Jan 25, 2021 at 08:13:37PM +0800, Jeffle Xu wrote:
> >> +int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
> > 
> > Can you split the guts of this function into two separate helpers
> > for the mq vs non-mq case?  As is is is a little hard to read and
> > introduced extra branches in the fast path.
> > 
> 
> I know your consideration, actually I had ever tried.
> 
> I can extract some helper functions, but I'm doubted if the extra
> function call is acceptable.
> 
> Besides, the iteration logic is generic and I'm afraid the branch or
> function call is unavoidable. Or if we maintain two separate function
> for mq and dm, the code duplication may be unavoidable.

I'd just split the functions entirely at the highest level.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

