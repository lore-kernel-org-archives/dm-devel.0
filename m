Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC3FAC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 09:01:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-XLJT6_GlO2inQ-dsHkki0g-1; Tue, 22 Mar 2022 05:01:53 -0400
X-MC-Unique: XLJT6_GlO2inQ-dsHkki0g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D401B38008A8;
	Tue, 22 Mar 2022 09:01:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7EC517ADA;
	Tue, 22 Mar 2022 09:01:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2663B1949762;
	Tue, 22 Mar 2022 09:01:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 449781947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 09:01:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C3BAD40C1257; Tue, 22 Mar 2022 09:01:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B77F44010A02
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 09:01:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B9D628EA6E3
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 09:01:49 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-60-Jvmv8c4dOheCDL4mpBL7OA-1; Tue, 22 Mar 2022 05:01:48 -0400
X-MC-Unique: Jvmv8c4dOheCDL4mpBL7OA-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1nWaOa-00AVwe-GZ; Tue, 22 Mar 2022 09:01:40 +0000
Date: Tue, 22 Mar 2022 02:01:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Message-ID: <YjmQdJdOWUr2IYIP@infradead.org>
References: <20220319062833.3136528-1-jane.chu@oracle.com>
 <20220319062833.3136528-5-jane.chu@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20220319062833.3136528-5-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v6 4/6] dax: add DAX_RECOVERY flag and
 .recovery_write dev_pgmap_ops
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: nvdimm@lists.linux.dev, dave.jiang@intel.com, snitzer@redhat.com,
 djwong@kernel.org, david@fromorbit.com, linux-kernel@vger.kernel.org,
 willy@infradead.org, hch@infradead.org, dm-devel@redhat.com, vgoyal@redhat.com,
 vishal.l.verma@intel.com, linux-fsdevel@vger.kernel.org,
 dan.j.williams@intel.com, ira.weiny@intel.com, linux-xfs@vger.kernel.org,
 agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Mar 19, 2022 at 12:28:31AM -0600, Jane Chu wrote:
> Introduce DAX_RECOVERY flag to dax_direct_access(). The flag is
> not set by default in dax_direct_access() such that the helper
> does not translate a pmem range to kernel virtual address if the
> range contains uncorrectable errors.  When the flag is set,
> the helper ignores the UEs and return kernel virtual adderss so
> that the caller may get on with data recovery via write.

This DAX_RECOVERY doesn't actually seem to be used anywhere here or
in the subsequent patches.  Did I miss something?

> Also introduce a new dev_pagemap_ops .recovery_write function.
> The function is applicable to FSDAX device only. The device
> page backend driver provides .recovery_write function if the
> device has underlying mechanism to clear the uncorrectable
> errors on the fly.

Why is this not in struct dax_operations?

>  
> +size_t dax_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
> +		void *addr, size_t bytes, struct iov_iter *iter)
> +{
> +	struct dev_pagemap *pgmap = dax_dev->pgmap;
> +
> +	if (!pgmap || !pgmap->ops->recovery_write)
> +		return -EIO;
> +	return pgmap->ops->recovery_write(pgmap, pgoff, addr, bytes,
> +				(void *)iter);

No need to cast a type pointer to a void pointer.  But more importantly
losing the type information here and passing it as void seems very
wrong.

> +static size_t pmem_recovery_write(struct dev_pagemap *pgmap, pgoff_t pgoff,
> +		void *addr, size_t bytes, void *iter)
> +{
> +	struct pmem_device *pmem = pgmap->owner;
> +
> +	dev_warn(pmem->bb.dev, "%s: not yet implemented\n", __func__);
> +
> +	/* XXX more later */
> +	return 0;
> +}

This shuld not be added here - the core code can cope with a NULL
method just fine.

> +		recov = 0;
> +		flags = 0;
> +		nrpg = PHYS_PFN(size);

Please spell out the words.  The recovery flag can also be
a bool to make the code more readable.

> +		map_len = dax_direct_access(dax_dev, pgoff, nrpg, flags,
> +					&kaddr, NULL);
> +		if ((map_len == -EIO) && (iov_iter_rw(iter) == WRITE)) {

No need for the inner braces.

> +			flags |= DAX_RECOVERY;
> +			map_len = dax_direct_access(dax_dev, pgoff, nrpg,
> +						flags, &kaddr, NULL);

And noneed for the flags variable at all really.

>  			xfer = dax_copy_from_iter(dax_dev, pgoff, kaddr,
>  					map_len, iter);
>  		else
> @@ -1271,6 +1286,11 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
>  		length -= xfer;
>  		done += xfer;
>  
> +		if (recov && (xfer == (ssize_t) -EIO)) {
> +			pr_warn("dax_recovery_write failed\n");
> +			ret = -EIO;
> +			break;

And no, we can't just use an unsigned variable to communicate a
negative error code.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

