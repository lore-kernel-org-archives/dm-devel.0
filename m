Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E07FEC43217
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 13:29:04 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-qOMS-aPRP16qWj6ZKOCWew-1; Wed, 02 Feb 2022 08:29:00 -0500
X-MC-Unique: qOMS-aPRP16qWj6ZKOCWew-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0118F835BC3;
	Wed,  2 Feb 2022 13:28:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F46378AAD;
	Wed,  2 Feb 2022 13:28:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1C02B1809CB8;
	Wed,  2 Feb 2022 13:28:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 212DSqA2028320 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 08:28:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0AE2C401E4E; Wed,  2 Feb 2022 13:28:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 06717401E4A
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 13:28:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E092D28ECA82
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 13:28:51 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-375-bx4CGLfxP_CHcwtmLeK1Fw-1; Wed, 02 Feb 2022 08:28:50 -0500
X-MC-Unique: bx4CGLfxP_CHcwtmLeK1Fw-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1nFFgh-00FM5N-4U; Wed, 02 Feb 2022 13:28:43 +0000
Date: Wed, 2 Feb 2022 05:28:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Message-ID: <YfqHC8zpPlyWhVkj@infradead.org>
References: <20220128213150.1333552-1-jane.chu@oracle.com>
	<20220128213150.1333552-8-jane.chu@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20220128213150.1333552-8-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, dave.jiang@intel.com, snitzer@redhat.com,
	djwong@kernel.org, david@fromorbit.com,
	linux-kernel@vger.kernel.org, willy@infradead.org,
	hch@infradead.org, dm-devel@redhat.com, vgoyal@redhat.com,
	vishal.l.verma@intel.com, linux-fsdevel@vger.kernel.org,
	dan.j.williams@intel.com, ira.weiny@intel.com,
	linux-xfs@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v5 7/7] pmem: fix pmem_do_write() avoid
 writing to 'np' page
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jan 28, 2022 at 02:31:50PM -0700, Jane Chu wrote:
> +	if (!bad_pmem) {
>  		write_pmem(pmem_addr, page, page_off, len);
> +	} else {
> +		rc = pmem_clear_poison(pmem, pmem_off, len);
> +		if (rc == BLK_STS_OK)
> +			write_pmem(pmem_addr, page, page_off, len);
> +		else
> +			pr_warn("%s: failed to clear poison\n",
> +				__func__);

This warning probably needs ratelimiting.

Also this flow looks a little odd.  I'd redo the whole function with a
clear bad_mem case:

	if (unlikely(is_bad_pmem(&pmem->bb, sector, len))) {
		blk_status_t rc = pmem_clear_poison(pmem, pmem_off, len);

		if (rc != BLK_STS_OK) {
			pr_warn("%s: failed to clear poison\n", __func__);
			return rc;
		}
	}
	flush_dcache_page(page);
	write_pmem(pmem_addr, page, page_off, len);
	return BLK_STS_OK;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

