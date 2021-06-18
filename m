Return-Path: <SRS0=s8Rv=LW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDCD5C49EA7
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 09:52:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8700261C5D
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 09:52:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8700261C5D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-TvLWQqFrM2ule9eHWK3EMw-1; Mon, 28 Jun 2021 05:52:43 -0400
X-MC-Unique: TvLWQqFrM2ule9eHWK3EMw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59D8E804301;
	Mon, 28 Jun 2021 09:52:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 15DD160843;
	Mon, 28 Jun 2021 09:52:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AA0344EA2F;
	Mon, 28 Jun 2021 09:52:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15IID6SM029261 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Jun 2021 14:13:06 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 72F9ED93A0; Fri, 18 Jun 2021 18:13:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B5EAD93A2
	for <dm-devel@redhat.com>; Fri, 18 Jun 2021 18:13:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08ABA800B35
	for <dm-devel@redhat.com>; Fri, 18 Jun 2021 18:13:04 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-433-_LlKNVBxP4qs_GVCh4H8EA-1;
	Fri, 18 Jun 2021 14:12:59 -0400
X-MC-Unique: _LlKNVBxP4qs_GVCh4H8EA-1
IronPort-SDR: Y3FuI9/9LFC2QyaS7oT3ir42Ck7tPPxnIolqAkhEbGwiv9O3oQITwRAAIp7CqbPf5OgRULhxTm
	1muslnKeyG8Q==
X-IronPort-AV: E=McAfee;i="6200,9189,10019"; a="204772304"
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; d="scan'208";a="204772304"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
	by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jun 2021 11:12:58 -0700
IronPort-SDR: fZjz2UBcjkF09ZLFZzZqWyvwCbkGqlZanM6atUtLAcrBp3dXyferraXT69g8eiZc0puz+dQdsp
	3jQAgCFqGSuA==
X-IronPort-AV: E=Sophos;i="5.83,284,1616482800"; d="scan'208";a="453226714"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
	by fmsmga008-auth.fm.intel.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2021 11:12:58 -0700
Date: Fri, 18 Jun 2021 11:12:58 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <20210618181258.GC1905674@iweiny-DESK2.sc.intel.com>
References: <20210615132456.753241-1-hch@lst.de>
	<20210615132456.753241-2-hch@lst.de>
	<20210618030157.GA1905674@iweiny-DESK2.sc.intel.com>
	<20210618033728.GA16787@gondor.apana.org.au>
MIME-Version: 1.0
In-Reply-To: <20210618033728.GA16787@gondor.apana.org.au>
User-Agent: Mutt/1.11.1 (2018-12-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 28 Jun 2021 05:52:34 -0400
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Mike Snitzer <snitzer@redhat.com>, "David S. Miller" <davem@davemloft.net>,
	Geoff Levand <geoff@infradead.org>,
	Christoph Lameter <cl@gentwo.de>, ceph-devel@vger.kernel.org,
	linux-mips@vger.kernel.org, Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	dm-devel@redhat.com, linux-arch@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ilya Dryomov <idryomov@gmail.com>, linuxppc-dev@lists.ozlabs.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH 01/18] mm: add a kunmap_local_dirty helper
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jun 18, 2021 at 11:37:28AM +0800, Herbert Xu wrote:
> On Thu, Jun 17, 2021 at 08:01:57PM -0700, Ira Weiny wrote:
> >
> > > +		flush_kernel_dcache_page(__page);		\
> > 
> > Is this required on 32bit systems?  Why is kunmap_flush_on_unmap() not
> > sufficient on 64bit systems?  The normal kunmap_local() path does that.
> > 
> > I'm sorry but I did not see a conclusion to my query on V1. Herbert implied the
> > he just copied from the crypto code.[1]  I'm concerned that this _dirty() call
> > is just going to confuse the users of kmap even more.  So why can't we get to
> > the bottom of why flush_kernel_dcache_page() needs so much logic around it
> > before complicating the general kernel users.
> > 
> > I would like to see it go away if possible.
> 
> This thread may be related:
> 
> https://lwn.net/Articles/240249/

Interesting!  Thanks!

Digging around a bit more I found:

https://lore.kernel.org/patchwork/patch/439637/

Auditing all the flush_dcache_page() arch code reveals that the mapping field
is either unused, or is checked for NULL.  Furthermore, all the implementations
call page_mapping_file() which further limits the page to not be a swap page.

All flush_kernel_dcache_page() implementations appears to operate the same way
in all arch's which define that call.

So I'm confident now that additional !PageSlab(__page) checks are not needed
and this patch is unnecessary.   Christoph, can we leave this out of the kmap
API and just fold the flush_kernel_dcache_page() calls back into the bvec code?

Unfortunately, I'm not convinced this can be handled completely by
kunmap_local() nor the mem*_page() calls because there is a difference between
flush_dcache_page() and flush_kernel_dcache_page() in most archs...  [parisc
being an exception which falls back to flush_kernel_dcache_page()]...

It seems like the generic unmap path _should_ be able to determine which call
to make based on the page but I'd have to look at that more.

Ira

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

