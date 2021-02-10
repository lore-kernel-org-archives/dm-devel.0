Return-Path: <SRS0=/g2B=HM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F94C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 10 Feb 2021 13:34:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C20F364E16
	for <dm-devel@archiver.kernel.org>; Wed, 10 Feb 2021 13:34:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C20F364E16
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-9pNNzRnXO9OCgDIz-MG7BQ-1; Wed, 10 Feb 2021 08:34:18 -0500
X-MC-Unique: 9pNNzRnXO9OCgDIz-MG7BQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28DAE801962;
	Wed, 10 Feb 2021 13:34:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A74B860BE2;
	Wed, 10 Feb 2021 13:34:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E662018095C9;
	Wed, 10 Feb 2021 13:34:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11ADY3HE014288 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Feb 2021 08:34:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 127632026D49; Wed, 10 Feb 2021 13:34:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CB212026D46
	for <dm-devel@redhat.com>; Wed, 10 Feb 2021 13:33:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2946185AD0A
	for <dm-devel@redhat.com>; Wed, 10 Feb 2021 13:33:55 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-142-OW1d3BOWO7OavQW0oVqKjA-1;
	Wed, 10 Feb 2021 08:33:51 -0500
X-MC-Unique: OW1d3BOWO7OavQW0oVqKjA-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id BABDE68B02; Wed, 10 Feb 2021 14:33:47 +0100 (CET)
Date: Wed, 10 Feb 2021 14:33:47 +0100
From: Christoph Hellwig <hch@lst.de>
To: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Message-ID: <20210210133347.GD30109@lst.de>
References: <20210208105530.3072869-1-ruansy.fnst@cn.fujitsu.com>
	<20210208105530.3072869-6-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
In-Reply-To: <20210208105530.3072869-6-ruansy.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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
Cc: y-goto@fujitsu.com, qi.fuli@fujitsu.com, snitzer@redhat.com,
	linux-nvdimm@lists.01.org, rgoldwyn@suse.de,
	darrick.wong@oracle.com, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com,
	hch@lst.de, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v3 05/11] mm,
 fsdax: Refactor memory-failure handler for dax mapping
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> +extern int mf_dax_mapping_kill_procs(struct address_space *mapping, pgoff_t index, int flags);

No nee for the extern, please avoid the overly long line.

> @@ -120,6 +121,13 @@ static int hwpoison_filter_dev(struct page *p)
>  	if (PageSlab(p))
>  		return -EINVAL;
>  
> +	if (pfn_valid(page_to_pfn(p))) {
> +		if (is_device_fsdax_page(p))
> +			return 0;
> +		else
> +			return -EINVAL;
> +	}
> +

This looks odd.  For one there is no need for an else after a return.
But more importantly page_mapping() as called below pretty much assumes
a valid PFN, so something is fishy in this function.

> +	if (is_zone_device_page(p)) {
> +		if (is_device_fsdax_page(p))
> +			tk->addr = vma->vm_start +
> +					((pgoff - vma->vm_pgoff) << PAGE_SHIFT);

The arithmetics here scream for a common helper, I suspect there might
be other places that could use the same helper.

> +int mf_dax_mapping_kill_procs(struct address_space *mapping, pgoff_t index, int flags)

Overly long line.  Also the naming scheme with the mf_ seems rather
unusual. Maybe dax_kill_mapping_procs?  Also please add a kerneldoc
comment describing the function given that it exported.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

