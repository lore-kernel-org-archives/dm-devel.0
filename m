Return-Path: <SRS0=XsJU=PJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6249C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 21 Oct 2021 11:23:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 64D7560E9C
	for <dm-devel@archiver.kernel.org>; Thu, 21 Oct 2021 11:23:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 64D7560E9C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-598-KwEAJScuNt6mTsCjLb3Yhw-1; Thu, 21 Oct 2021 07:23:44 -0400
X-MC-Unique: KwEAJScuNt6mTsCjLb3Yhw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A2D89126B;
	Thu, 21 Oct 2021 11:23:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1573F908B;
	Thu, 21 Oct 2021 11:23:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 18751181A1D0;
	Thu, 21 Oct 2021 11:23:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19LBNVvb011382 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 21 Oct 2021 07:23:32 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3218E40CFD11; Thu, 21 Oct 2021 11:23:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2CDBD40CFD08
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 11:23:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12C1C803533
	for <dm-devel@redhat.com>; Thu, 21 Oct 2021 11:23:31 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-149-zKn9HrzANbGWlQoMjN_mDw-1; Thu, 21 Oct 2021 07:23:28 -0400
X-MC-Unique: zKn9HrzANbGWlQoMjN_mDw-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1mdWAK-007Kld-Ns; Thu, 21 Oct 2021 11:23:20 +0000
Date: Thu, 21 Oct 2021 04:23:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Message-ID: <YXFNqI/+nbdVEoif@infradead.org>
References: <20211021001059.438843-1-jane.chu@oracle.com>
	<20211021001059.438843-4-jane.chu@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20211021001059.438843-4-jane.chu@oracle.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, dave.jiang@intel.com, snitzer@redhat.com,
	djwong@kernel.org, david@fromorbit.com,
	linux-kernel@vger.kernel.org, willy@infradead.org,
	hch@infradead.org, dm-devel@redhat.com, vgoyal@redhat.com,
	vishal.l.verma@intel.com, linux-fsdevel@vger.kernel.org,
	dan.j.williams@intel.com, ira.weiny@intel.com,
	linux-xfs@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] [PATCH 3/6] pmem: pmem_dax_direct_access() to honor
 the DAXDEV_F_RECOVERY flag
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Oct 20, 2021 at 06:10:56PM -0600, Jane Chu wrote:
> -	if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
> -					PFN_PHYS(nr_pages))))
> +	if (unlikely(!(flags & DAXDEV_F_RECOVERY) &&
> +		is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
> +				PFN_PHYS(nr_pages))))

The indentation here is pretty messed up. Something like this would
be move normal:

	if (unlikely(!(flags & DAXDEV_F_RECOVERY) &&
			is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
				    PFN_PHYS(nr_pages)))) {

but if we don't really need the unlikely we could do an actually
readable variant:

	if (!(flags & DAXDEV_F_RECOVERY) &&
	    is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512, PFN_PHYS(nr_pages)))

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

