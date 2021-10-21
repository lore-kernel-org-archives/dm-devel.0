Return-Path: <SRS0=XsJU=PJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED49DC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 21 Oct 2021 11:29:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0B6E360EFE
	for <dm-devel@archiver.kernel.org>; Thu, 21 Oct 2021 11:29:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0B6E360EFE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-QbwfiUKXNlm6eGnxoZ68mQ-1; Thu, 21 Oct 2021 07:29:09 -0400
X-MC-Unique: QbwfiUKXNlm6eGnxoZ68mQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D4C3806692;
	Thu, 21 Oct 2021 11:29:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 00B5E69FB9;
	Thu, 21 Oct 2021 11:29:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9A0FB4E590;
	Thu, 21 Oct 2021 11:29:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19LBT3gb011818 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 21 Oct 2021 07:29:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id F3A4440C1257; Thu, 21 Oct 2021 11:29:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EFBA8400F3E3
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 11:29:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6FB08022F4
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 11:29:02 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-598-Mern50lPPNKvYnyMdlB2gA-1; Thu, 21 Oct 2021 07:28:59 -0400
X-MC-Unique: Mern50lPPNKvYnyMdlB2gA-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1mdWFe-007Lv7-EG; Thu, 21 Oct 2021 11:28:50 +0000
Date: Thu, 21 Oct 2021 04:28:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Message-ID: <YXFO8uCgIDoIqTgC@infradead.org>
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<20211021001059.438843-6-jane.chu@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20211021001059.438843-6-jane.chu@oracle.com>
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
Subject: Re: [dm-devel] [PATCH 5/6] dax,
 pmem: Add data recovery feature to pmem_copy_to/from_iter()
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

> +	if (flags & DAXDEV_F_RECOVERY) {
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
> +					BLK_STS_OK)
> +				return (size_t) -EIO;
> +		}

Shouldn't this just go down in a separe ->clear_poison operation
to make the whole thing a little easier to follow?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

