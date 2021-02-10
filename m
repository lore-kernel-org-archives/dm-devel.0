Return-Path: <SRS0=/g2B=HM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F112C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 10 Feb 2021 13:41:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D7CE664D87
	for <dm-devel@archiver.kernel.org>; Wed, 10 Feb 2021 13:41:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D7CE664D87
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-SUPhVFKtN_qXff7wfE8OkQ-1; Wed, 10 Feb 2021 08:41:18 -0500
X-MC-Unique: SUPhVFKtN_qXff7wfE8OkQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 495D1108C31D;
	Wed, 10 Feb 2021 13:41:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0657C5D9D0;
	Wed, 10 Feb 2021 13:41:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5037318095CD;
	Wed, 10 Feb 2021 13:41:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11ADf9uC014840 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Feb 2021 08:41:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1700011422DC; Wed, 10 Feb 2021 13:41:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1337711422DA
	for <dm-devel@redhat.com>; Wed, 10 Feb 2021 13:41:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD94C80122F
	for <dm-devel@redhat.com>; Wed, 10 Feb 2021 13:41:06 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-248-v1jb_g9fMwmShTnIf7u-0g-1;
	Wed, 10 Feb 2021 08:41:04 -0500
X-MC-Unique: v1jb_g9fMwmShTnIf7u-0g-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 97BF768B02; Wed, 10 Feb 2021 14:41:00 +0100 (CET)
Date: Wed, 10 Feb 2021 14:41:00 +0100
From: Christoph Hellwig <hch@lst.de>
To: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Message-ID: <20210210134100.GE30109@lst.de>
References: <20210208105530.3072869-1-ruansy.fnst@cn.fujitsu.com>
	<20210208105530.3072869-7-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
In-Reply-To: <20210208105530.3072869-7-ruansy.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: y-goto@fujitsu.com, qi.fuli@fujitsu.com, snitzer@redhat.com,
	linux-nvdimm@lists.01.org, rgoldwyn@suse.de,
	darrick.wong@oracle.com, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com,
	hch@lst.de, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v3 06/11] mm,
 pmem: Implement ->memory_failure() in pmem driver
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> +static int pmem_pagemap_memory_failure(struct dev_pagemap *pgmap,
> +		unsigned long pfn, int flags)
> +{
> +	struct pmem_device *pdev;
> +	struct gendisk *disk;
> +	loff_t disk_offset;
> +	int rc = 0;
> +	unsigned long size = page_size(pfn_to_page(pfn));
> +
> +	pdev = container_of(pgmap, struct pmem_device, pgmap);
> +	disk = pdev->disk;

Would be nice to initialize this at the time of declaration:

	struct pmem_device *pdev =
		container_of(pgmap, struct pmem_device, pgmap);
	struct gendisk *disk = pdev->disk
	unsigned long size = page_size(pfn_to_page(pfn));

> +	if (!disk)
> +		return -ENXIO;
> +
> +	disk_offset = PFN_PHYS(pfn) - pdev->phys_addr - pdev->data_offset;
> +	if (disk->fops->corrupted_range) {
> +		rc = disk->fops->corrupted_range(disk, NULL, disk_offset,
> +						 size, &flags);
> +		if (rc == -ENODEV)
> +			rc = -ENXIO;
> +	} else
> +		rc = -EOPNOTSUPP;

Why do we need the disk and fops check here? A pgmap registered by pmem.c
should always have a disk with pmem_fops.  And more importantly this
has no business going through the block layer.

Instead the file system should deposit a callback when starting to use
the dax_device using fs_dax_get_by_bdev / dax_get_by_host and a private
data (the superblock), and we avoid all the lookup problems.

> +int mf_generic_kill_procs(unsigned long long pfn, int flags)

This function seems to be only used inside of memory-failure.c, so it
could be marked static.  Also I'd name it dax_generic_memory_failure
or something like that to match the naming of the ->memory_failure
pgmap operation.

Also maybe just splitting this out into a helper would be a nice prep
patch.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

