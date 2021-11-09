Return-Path: <SRS0=0A1B=P4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4864C433FE
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 07:58:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 48376610FF
	for <dm-devel@archiver.kernel.org>; Tue,  9 Nov 2021 07:58:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 48376610FF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-Wxlyo2LAPGeldfmzXAJ2tg-1; Tue, 09 Nov 2021 02:58:31 -0500
X-MC-Unique: Wxlyo2LAPGeldfmzXAJ2tg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F2EF1018720;
	Tue,  9 Nov 2021 07:58:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C283760D30;
	Tue,  9 Nov 2021 07:58:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0B1B04A703;
	Tue,  9 Nov 2021 07:58:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A97wJlr012885 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Nov 2021 02:58:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B2AD04047279; Tue,  9 Nov 2021 07:58:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF04B4047272
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 07:58:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97E92802813
	for <dm-devel@redhat.com>; Tue,  9 Nov 2021 07:58:19 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-386-x5UBcMsHNuSzUp3RXMromw-1; Tue, 09 Nov 2021 02:58:17 -0500
X-MC-Unique: x5UBcMsHNuSzUp3RXMromw-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1mkLXM-000sHh-6h; Tue, 09 Nov 2021 07:27:20 +0000
Date: Mon, 8 Nov 2021 23:27:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Message-ID: <YYoi2JiwTtmxONvB@infradead.org>
References: <20211106011638.2613039-1-jane.chu@oracle.com>
	<20211106011638.2613039-3-jane.chu@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20211106011638.2613039-3-jane.chu@oracle.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, dave.jiang@intel.com, snitzer@redhat.com,
	djwong@kernel.org, david@fromorbit.com,
	linux-kernel@vger.kernel.org, willy@infradead.org,
	hch@infradead.org, dm-devel@redhat.com, vgoyal@redhat.com,
	vishal.l.verma@intel.com, linux-fsdevel@vger.kernel.org,
	dan.j.williams@intel.com, ira.weiny@intel.com,
	linux-xfs@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v2 2/2] dax,
	pmem: Implement pmem based dax data recovery
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

On Fri, Nov 05, 2021 at 07:16:38PM -0600, Jane Chu wrote:
>  static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
>  		void *addr, size_t bytes, struct iov_iter *i, int mode)
>  {
> +	phys_addr_t pmem_off;
> +	size_t len, lead_off;
> +	struct pmem_device *pmem = dax_get_private(dax_dev);
> +	struct device *dev = pmem->bb.dev;
> +
> +	if (unlikely(mode == DAX_OP_RECOVERY)) {
> +		lead_off = (unsigned long)addr & ~PAGE_MASK;
> +		len = PFN_PHYS(PFN_UP(lead_off + bytes));
> +		if (is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512, len)) {
> +			if (lead_off || !(PAGE_ALIGNED(bytes))) {
> +				dev_warn(dev, "Found poison, but addr(%p) and/or bytes(%#lx) not page aligned\n",
> +					addr, bytes);
> +				return (size_t) -EIO;
> +			}
> +			pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
> +			if (pmem_clear_poison(pmem, pmem_off, bytes) !=
> +						BLK_STS_OK)
> +				return (size_t) -EIO;
> +		}
> +	}

This is in the wrong spot.  As seen in my WIP series individual drivers
really should not hook into copying to and from the iter, because it
really is just one way to write to a nvdimm.  How would dm-writecache
clear the errors with this scheme?

So IMHO going back to the separate recovery method as in your previous
patch really is the way to go.  If/when the 64-bit store happens we
need to figure out a good way to clear the bad block list for that.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

