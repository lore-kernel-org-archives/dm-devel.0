Return-Path: <SRS0=zjfM=LD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB4DC47095
	for <dm-devel@archiver.kernel.org>; Wed,  9 Jun 2021 06:03:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AE4FF61278
	for <dm-devel@archiver.kernel.org>; Wed,  9 Jun 2021 06:03:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE4FF61278
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-JI2PGJP-Ny6ILGR2UyRceg-1; Wed, 09 Jun 2021 02:03:22 -0400
X-MC-Unique: JI2PGJP-Ny6ILGR2UyRceg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3720D1850609;
	Wed,  9 Jun 2021 06:03:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5190310023B5;
	Wed,  9 Jun 2021 06:03:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 92AFA4EBC6;
	Wed,  9 Jun 2021 06:03:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1591xSpQ018265 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Jun 2021 21:59:28 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B72F32094D3C; Wed,  9 Jun 2021 01:59:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B0BE32094D37
	for <dm-devel@redhat.com>; Wed,  9 Jun 2021 01:59:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DE74101A55F
	for <dm-devel@redhat.com>; Wed,  9 Jun 2021 01:59:26 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-3-e7W9awvHPay38MJVJF6_Vw-1; Tue, 08 Jun 2021 21:59:24 -0400
X-MC-Unique: e7W9awvHPay38MJVJF6_Vw-1
IronPort-SDR: l8PgSDw4zuN0iJXWiI61nFZGw+ISoFan87pG3GZdKHuqQ7XesLYLyVEQ9hrwa3LYTIL5OqHTTa
	wVFuGeVzptZA==
X-IronPort-AV: E=McAfee;i="6200,9189,10009"; a="205010296"
X-IronPort-AV: E=Sophos;i="5.83,259,1616482800"; d="scan'208";a="205010296"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
	by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	08 Jun 2021 18:58:20 -0700
IronPort-SDR: KYJW5Refe0V9ltnuDGlVJ6TLopiUWwZYULWIqWG34N4OkvARGXzz0Av7vRHCtdujeOQY9X1fyQ
	6/vheDgG7Nyg==
X-IronPort-AV: E=Sophos;i="5.83,259,1616482800"; d="scan'208";a="482201138"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
	by orsmga001-auth.jf.intel.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2021 18:58:19 -0700
Date: Tue, 8 Jun 2021 18:58:19 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20210609015819.GU3697498@iweiny-DESK2.sc.intel.com>
References: <20210608160603.1535935-1-hch@lst.de>
	<20210608160603.1535935-15-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210608160603.1535935-15-hch@lst.de>
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
X-Mailman-Approved-At: Wed, 09 Jun 2021 02:03:13 -0400
Cc: Jens Axboe <axboe@kernel.dk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Mike Snitzer <snitzer@redhat.com>,
	Geoff Levand <geoff@infradead.org>, linux-mips@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Ilya Dryomov <idryomov@gmail.com>,
	linuxppc-dev@lists.ozlabs.org, ceph-devel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 14/16] block: use memcpy_from_bvec in
	__blk_queue_bounce
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

On Tue, Jun 08, 2021 at 06:06:01PM +0200, Christoph Hellwig wrote:
> Rewrite the actual bounce buffering loop in __blk_queue_bounce to that
> the memcpy_to_bvec helper can be used to perform the data copies.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/bounce.c | 21 +++++++--------------
>  1 file changed, 7 insertions(+), 14 deletions(-)
> 
> diff --git a/block/bounce.c b/block/bounce.c
> index a2fc6326b6c9..b5ad09e07bcf 100644
> --- a/block/bounce.c
> +++ b/block/bounce.c
> @@ -243,24 +243,17 @@ void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
>  	 * because the 'bio' is single-page bvec.
>  	 */
>  	for (i = 0, to = bio->bi_io_vec; i < bio->bi_vcnt; to++, i++) {
> -		struct page *page = to->bv_page;
> +		struct page *bounce_page;
>  
> -		if (!PageHighMem(page))
> +		if (!PageHighMem(to->bv_page))
>  			continue;
>  
> -		to->bv_page = mempool_alloc(&page_pool, GFP_NOIO);
> -		inc_zone_page_state(to->bv_page, NR_BOUNCE);
> +		bounce_page = mempool_alloc(&page_pool, GFP_NOIO);
> +		inc_zone_page_state(bounce_page, NR_BOUNCE);
>  
> -		if (rw == WRITE) {
> -			char *vto, *vfrom;
> -
> -			flush_dcache_page(page);
> -
> -			vto = page_address(to->bv_page) + to->bv_offset;
> -			vfrom = kmap_atomic(page) + to->bv_offset;
> -			memcpy(vto, vfrom, to->bv_len);
> -			kunmap_atomic(vfrom);
> -		}
> +		if (rw == WRITE)
> +			memcpy_from_bvec(page_address(bounce_page), to);

NIT: the fact that the copy is from 'to' makes my head hurt...  But I don't
see a good way to change that without declaring unnecessary variables...  :-(

The logic seems right.

Ira

> +		to->bv_page = bounce_page;
>  	}
>  
>  	trace_block_bio_bounce(*bio_orig);
> -- 
> 2.30.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

