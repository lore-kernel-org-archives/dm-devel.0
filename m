Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 209F6C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 13:26:50 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-V60PuJaRMGqQVv_MRB-M6g-1; Wed, 02 Feb 2022 08:26:46 -0500
X-MC-Unique: V60PuJaRMGqQVv_MRB-M6g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB20881C49C;
	Wed,  2 Feb 2022 13:26:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B2C13ADD5;
	Wed,  2 Feb 2022 13:26:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3A81A1809CB8;
	Wed,  2 Feb 2022 13:26:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 212DQdDW028121 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 08:26:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 84796492D46; Wed,  2 Feb 2022 13:26:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 800FB492D40
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 13:26:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67B8B1044562
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 13:26:39 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-518-cg5kTSFaMY-lka1709DwoA-1; Wed, 02 Feb 2022 08:26:38 -0500
X-MC-Unique: cg5kTSFaMY-lka1709DwoA-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1nFFZi-00FLFj-Aj; Wed, 02 Feb 2022 13:21:30 +0000
Date: Wed, 2 Feb 2022 05:21:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Message-ID: <YfqFWjFcdJSwjRaU@infradead.org>
References: <20220128213150.1333552-1-jane.chu@oracle.com>
	<20220128213150.1333552-2-jane.chu@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20220128213150.1333552-2-jane.chu@oracle.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, dave.jiang@intel.com, snitzer@redhat.com,
	djwong@kernel.org, david@fromorbit.com,
	linux-kernel@vger.kernel.org, willy@infradead.org,
	hch@infradead.org, dm-devel@redhat.com, vgoyal@redhat.com,
	vishal.l.verma@intel.com, linux-fsdevel@vger.kernel.org,
	dan.j.williams@intel.com, ira.weiny@intel.com,
	linux-xfs@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v5 1/7] mce: fix set_mce_nospec to always
 unmap the whole page
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

> +static inline int set_mce_nospec(unsigned long pfn)
>  {
>  	unsigned long decoy_addr;
>  	int rc;
> @@ -117,10 +113,7 @@ static inline int set_mce_nospec(unsigned long pfn, bool unmap)
>  	 */
>  	decoy_addr = (pfn << PAGE_SHIFT) + (PAGE_OFFSET ^ BIT(63));
>  
> -	if (unmap)
> -		rc = set_memory_np(decoy_addr, 1);
> -	else
> -		rc = set_memory_uc(decoy_addr, 1);
> +	rc = set_memory_np(decoy_addr, 1);
>  	if (rc)
>  		pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
>  	return rc;
> @@ -130,7 +123,7 @@ static inline int set_mce_nospec(unsigned long pfn, bool unmap)
>  /* Restore full speculative operation to the pfn. */
>  static inline int clear_mce_nospec(unsigned long pfn)
>  {
> -	return set_memory_wb((unsigned long) pfn_to_kaddr(pfn), 1);
> +	return _set_memory_present((unsigned long) pfn_to_kaddr(pfn), 1);
>  }

Wouldn't it make more sense to move these helpers out of line rather
than exporting _set_memory_present?

>  /*
> - * _set_memory_prot is an internal helper for callers that have been passed
> + * __set_memory_prot is an internal helper for callers that have been passed

This looks unrelated to the patch.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

