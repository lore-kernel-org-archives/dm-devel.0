Return-Path: <SRS0=zjfM=LD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BBAEC48BCF
	for <dm-devel@archiver.kernel.org>; Wed,  9 Jun 2021 06:03:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C357E61354
	for <dm-devel@archiver.kernel.org>; Wed,  9 Jun 2021 06:03:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C357E61354
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-2IPHCwhGPg-GxGv6n36GqA-1; Wed, 09 Jun 2021 02:03:22 -0400
X-MC-Unique: 2IPHCwhGPg-GxGv6n36GqA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C254100C610;
	Wed,  9 Jun 2021 06:03:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 69E8060C04;
	Wed,  9 Jun 2021 06:03:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 024074EE7F;
	Wed,  9 Jun 2021 06:03:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1591nZ03017116 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Jun 2021 21:49:36 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B7D202095BB3; Wed,  9 Jun 2021 01:49:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B298B2094D37
	for <dm-devel@redhat.com>; Wed,  9 Jun 2021 01:49:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 338DD101A55F
	for <dm-devel@redhat.com>; Wed,  9 Jun 2021 01:49:31 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-352-jrQ4no8sNXaNQVgficOdUw-1;
	Tue, 08 Jun 2021 21:49:29 -0400
X-MC-Unique: jrQ4no8sNXaNQVgficOdUw-1
IronPort-SDR: HBS53SXipy3ZAvJcJOGEWG1Q+3f6NZC72ijEyXge1Grvs3Hl2EeFEMDAebDjVurfLJ7GVMRUdA
	ncOGOtY/Zlbg==
X-IronPort-AV: E=McAfee;i="6200,9189,10009"; a="226347521"
X-IronPort-AV: E=Sophos;i="5.83,259,1616482800"; d="scan'208";a="226347521"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
	by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	08 Jun 2021 18:48:24 -0700
IronPort-SDR: SRFfjIkTZkgdiWUkfbuxO/DHCb0ZQrp7YLBvUKhmAbESyYDmfBnXBu/pgXAlW0d/t+PE9XTYIq
	c7l/dYjK3T5A==
X-IronPort-AV: E=Sophos;i="5.83,259,1616482800"; d="scan'208";a="448117931"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
	by orsmga008-auth.jf.intel.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2021 18:48:23 -0700
Date: Tue, 8 Jun 2021 18:48:22 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20210609014822.GT3697498@iweiny-DESK2.sc.intel.com>
References: <20210608160603.1535935-1-hch@lst.de>
	<20210608160603.1535935-10-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210608160603.1535935-10-hch@lst.de>
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
Subject: Re: [dm-devel] [PATCH 09/16] ps3disk: use memcpy_{from,to}_bvec
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jun 08, 2021 at 06:05:56PM +0200, Christoph Hellwig wrote:
>  
>  	rq_for_each_segment(bvec, req, iter) {
> -		unsigned long flags;
> -		dev_dbg(&dev->sbd.core, "%s:%u: bio %u: %u sectors from %llu\n",
> -			__func__, __LINE__, i, bio_sectors(iter.bio),
> -			iter.bio->bi_iter.bi_sector);
> -
> -		size = bvec.bv_len;
> -		buf = bvec_kmap_irq(&bvec, &flags);
>  		if (gather)
> -			memcpy(dev->bounce_buf+offset, buf, size);
> +			memcpy_from_bvec(dev->bounce_buf + offset, &bvec);
>  		else
> -			memcpy(buf, dev->bounce_buf+offset, size);
> -		offset += size;
> -		flush_kernel_dcache_page(bvec.bv_page);

I'm still not 100% sure that these flushes are needed but the are not no-ops on
every arch.  Would it be best to preserve them after the memcpy_to/from_bvec()?

Same thing in patch 11 and 14.

Ira

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

