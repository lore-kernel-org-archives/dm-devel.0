Return-Path: <SRS0=Vrzv=LM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D1AC48BE8
	for <dm-devel@archiver.kernel.org>; Fri, 18 Jun 2021 07:13:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5C3E1613AA
	for <dm-devel@archiver.kernel.org>; Fri, 18 Jun 2021 07:13:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C3E1613AA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-Eg1_DoudOxuHOKtjYoC6hQ-1; Fri, 18 Jun 2021 03:13:18 -0400
X-MC-Unique: Eg1_DoudOxuHOKtjYoC6hQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 833EC1084F42;
	Fri, 18 Jun 2021 07:13:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 275545C1A1;
	Fri, 18 Jun 2021 07:13:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9E55946F5B;
	Fri, 18 Jun 2021 07:13:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15I326xd012912 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Jun 2021 23:02:06 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 72F26213235E; Fri, 18 Jun 2021 03:02:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E37C215ADD3
	for <dm-devel@redhat.com>; Fri, 18 Jun 2021 03:02:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51965805C1D
	for <dm-devel@redhat.com>; Fri, 18 Jun 2021 03:02:02 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-204-2K2WIrwJMeueno106SIzUg-1; Thu, 17 Jun 2021 23:02:00 -0400
X-MC-Unique: 2K2WIrwJMeueno106SIzUg-1
IronPort-SDR: mgYjTXnGchBhoMNFIV/uCiBmG/jzSZBWfw0FJ/lcKOUvfowHztOmob/a/07XeEkVyXdHUDVRHD
	BuLDyQ8SWeYw==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="270334919"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; d="scan'208";a="270334919"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
	by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	17 Jun 2021 20:01:58 -0700
IronPort-SDR: kDCIXbw7lwEjZFI+nFNOMy4qgHpPd6rsmqYlpb0ps01Z+DdBhWSAQ5G+mGTpSRcepgH2/cP20z
	fFfj3eWUWROQ==
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; d="scan'208";a="451243562"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
	by orsmga008-auth.jf.intel.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 20:01:58 -0700
Date: Thu, 17 Jun 2021 20:01:57 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20210618030157.GA1905674@iweiny-DESK2.sc.intel.com>
References: <20210615132456.753241-1-hch@lst.de>
	<20210615132456.753241-2-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210615132456.753241-2-hch@lst.de>
User-Agent: Mutt/1.11.1 (2018-12-01)
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
X-Mailman-Approved-At: Fri, 18 Jun 2021 03:13:11 -0400
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Mike Snitzer <snitzer@redhat.com>, "David S. Miller" <davem@davemloft.net>,
	Geoff Levand <geoff@infradead.org>, ceph-devel@vger.kernel.org,
	linux-mips@vger.kernel.org, Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	dm-devel@redhat.com, linux-arch@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	linuxppc-dev@lists.ozlabs.org, Ilya Dryomov <idryomov@gmail.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 15, 2021 at 03:24:39PM +0200, Christoph Hellwig wrote:
> Add a helper that calls flush_kernel_dcache_page before unmapping the
> local mapping.  flush_kernel_dcache_page is required for all pages
> potentially mapped into userspace that were written to using kmap*,
> so having a helper that does the right thing can be very convenient.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/highmem-internal.h | 7 +++++++
>  include/linux/highmem.h          | 4 ++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/include/linux/highmem-internal.h b/include/linux/highmem-internal.h
> index 7902c7d8b55f..bd37706db147 100644
> --- a/include/linux/highmem-internal.h
> +++ b/include/linux/highmem-internal.h
> @@ -224,4 +224,11 @@ do {								\
>  	__kunmap_local(__addr);					\
>  } while (0)
>  
> +#define kunmap_local_dirty(__page, __addr)			\

I think having to store the page and addr to return to kunmap_local_dirty() is
going to be a pain in some code paths.  Not a show stopper but see below...

> +do {								\
> +	if (!PageSlab(__page))					\

Was there some clarification why the page can't be a Slab page?  Or is this
just an optimization?

> +		flush_kernel_dcache_page(__page);		\

Is this required on 32bit systems?  Why is kunmap_flush_on_unmap() not
sufficient on 64bit systems?  The normal kunmap_local() path does that.

I'm sorry but I did not see a conclusion to my query on V1. Herbert implied the
he just copied from the crypto code.[1]  I'm concerned that this _dirty() call
is just going to confuse the users of kmap even more.  So why can't we get to
the bottom of why flush_kernel_dcache_page() needs so much logic around it
before complicating the general kernel users.

I would like to see it go away if possible.

Ira

[1] https://lore.kernel.org/lkml/20210615050258.GA5208@gondor.apana.org.au/

> +	kunmap_local(__addr);					\
> +} while (0)
> +
>  #endif
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index 832b49b50c7b..65f548db4f2d 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -93,6 +93,10 @@ static inline void kmap_flush_unused(void);
>   * On HIGHMEM enabled systems mapping a highmem page has the side effect of
>   * disabling migration in order to keep the virtual address stable across
>   * preemption. No caller of kmap_local_page() can rely on this side effect.
> + *
> + * If data is written to the returned kernel mapping, the callers needs to
> + * unmap the mapping using kunmap_local_dirty(), else kunmap_local() should
> + * be used.
>   */
>  static inline void *kmap_local_page(struct page *page);
>  
> -- 
> 2.30.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

