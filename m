Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77DFEC433FE
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 08:53:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-UrAEjuckNZyKLvNjiaC-mw-1; Tue, 22 Mar 2022 04:53:26 -0400
X-MC-Unique: UrAEjuckNZyKLvNjiaC-mw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85036801E67;
	Tue, 22 Mar 2022 08:53:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2595B2026D13;
	Tue, 22 Mar 2022 08:53:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BA8311949762;
	Tue, 22 Mar 2022 08:53:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 571721947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 08:53:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 48C3676C2; Tue, 22 Mar 2022 08:53:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 434C37AD1
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 08:53:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F26DD28035E1
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 08:53:13 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-rhVoFqePPE6Oj0a4UPRVTQ-1; Tue, 22 Mar 2022 04:53:09 -0400
X-MC-Unique: rhVoFqePPE6Oj0a4UPRVTQ-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1nWaGF-00AVAX-ND; Tue, 22 Mar 2022 08:53:03 +0000
Date: Tue, 22 Mar 2022 01:53:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Message-ID: <YjmOb0dSY9GG/Q6r@infradead.org>
References: <20220319062833.3136528-1-jane.chu@oracle.com>
 <20220319062833.3136528-6-jane.chu@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20220319062833.3136528-6-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v6 5/6] pmem: refactor pmem_clear_poison()
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> -static void hwpoison_clear(struct pmem_device *pmem,
> -		phys_addr_t phys, unsigned int len)
> +static phys_addr_t to_phys(struct pmem_device *pmem, phys_addr_t offset)
>  {
> +	return pmem->phys_addr + offset;
> +}
> +
> +static sector_t to_sect(struct pmem_device *pmem, phys_addr_t offset)
> +{
> +	return (offset - pmem->data_offset) / 512;
> +}
> +
> +static phys_addr_t to_offset(struct pmem_device *pmem, sector_t sector)
> +{
> +	return sector * 512 + pmem->data_offset;
> +}

The multiplicate / divison using 512 could use shifts using
SECTOR_SHIFT.

> +
> +static void clear_hwpoison(struct pmem_device *pmem, phys_addr_t offset,
> +		unsigned int len)

> +static void clear_bb(struct pmem_device *pmem, sector_t sector, long blks)

All these functions lack a pmem_ prefix.

> +static blk_status_t __pmem_clear_poison(struct pmem_device *pmem,
> +		phys_addr_t offset, unsigned int len,
> +		unsigned int *blks)
> +{
> +	phys_addr_t phys = to_phys(pmem, offset);
>  	long cleared;
> +	blk_status_t rc;
>  
> +	cleared = nvdimm_clear_poison(to_dev(pmem), phys, len);
> +	*blks = cleared / 512;
> +	rc = (cleared < len) ? BLK_STS_IOERR : BLK_STS_OK;
> +	if (cleared <= 0 || *blks == 0)
> +		return rc;

This look odd.  I think just returing the cleared byte value would
make much more sense:

static long __pmem_clear_poison(struct pmem_device *pmem,
		phys_addr_t offset, unsigned int len)
{
	long cleared = nvdimm_clear_poison(to_dev(pmem), phys, len);

	if (cleared > 0) {
		clear_hwpoison(pmem, offset, cleared);
		arch_invalidate_pmem(pmem->virt_addr + offset, len);
	}

	return cleared;
}

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

