Return-Path: <SRS0=0/af=PZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 697E5C433F5
	for <dm-devel@archiver.kernel.org>; Sat,  6 Nov 2021 18:19:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ED7FE60F4A
	for <dm-devel@archiver.kernel.org>; Sat,  6 Nov 2021 18:19:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org ED7FE60F4A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-hFad3pJBNzmV6l0zK3_0UQ-1; Sat, 06 Nov 2021 14:19:35 -0400
X-MC-Unique: hFad3pJBNzmV6l0zK3_0UQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A921890F15;
	Sat,  6 Nov 2021 18:19:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E5E896483E;
	Sat,  6 Nov 2021 18:19:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 553984E9F4;
	Sat,  6 Nov 2021 18:19:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A6IIHgw014281 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 6 Nov 2021 14:18:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 57F1D51FF; Sat,  6 Nov 2021 18:18:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4ED3951DC
	for <dm-devel@redhat.com>; Sat,  6 Nov 2021 18:18:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 336D2857E9B
	for <dm-devel@redhat.com>; Sat,  6 Nov 2021 18:18:17 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-237-5mk2G67aMLCelKUKm5cDAg-1;
	Fri, 05 Nov 2021 22:05:01 -0400
X-MC-Unique: 5mk2G67aMLCelKUKm5cDAg-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDCB36108B;
	Sat,  6 Nov 2021 02:04:59 +0000 (UTC)
Date: Fri, 5 Nov 2021 19:04:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jane Chu <jane.chu@oracle.com>
Message-ID: <20211106020459.GL2237511@magnolia>
References: <20211106011638.2613039-1-jane.chu@oracle.com>
	<20211106011638.2613039-3-jane.chu@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20211106011638.2613039-3-jane.chu@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, dave.jiang@intel.com, snitzer@redhat.com,
	vishal.l.verma@intel.com, david@fromorbit.com,
	linux-kernel@vger.kernel.org, willy@infradead.org,
	hch@infradead.org, dm-devel@redhat.com, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com,
	ira.weiny@intel.com, linux-xfs@vger.kernel.org, agk@redhat.com
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Nov 05, 2021 at 07:16:38PM -0600, Jane Chu wrote:
> For /dev/pmem based dax, enable DAX_OP_RECOVERY mode for
> dax_direct_access to translate 'kaddr' over a range that
> may contain poison(s); and enable dax_copy_to_iter to
> read as much data as possible up till a poisoned page is
> encountered; and enable dax_copy_from_iter to clear poison
> among a page-aligned range, and then write the good data over.
> 
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  drivers/md/dm.c       |  2 ++
>  drivers/nvdimm/pmem.c | 75 ++++++++++++++++++++++++++++++++++++++++---
>  fs/dax.c              | 24 +++++++++++---
>  3 files changed, 92 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index dc354db22ef9..9b3dac916f22 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1043,6 +1043,7 @@ static size_t dm_dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
>  	if (!ti)
>  		goto out;
>  	if (!ti->type->dax_copy_from_iter) {
> +		WARN_ON(mode == DAX_OP_RECOVERY);
>  		ret = copy_from_iter(addr, bytes, i);
>  		goto out;
>  	}
> @@ -1067,6 +1068,7 @@ static size_t dm_dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff,
>  	if (!ti)
>  		goto out;
>  	if (!ti->type->dax_copy_to_iter) {
> +		WARN_ON(mode == DAX_OP_RECOVERY);

Maybe just return -EOPNOTSUPP here?

Warnings are kinda loud.

>  		ret = copy_to_iter(addr, bytes, i);
>  		goto out;
>  	}
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 3dc99e0bf633..8ae6aa678c51 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -260,7 +260,7 @@ __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
>  	resource_size_t offset = PFN_PHYS(pgoff) + pmem->data_offset;
>  
>  	if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
> -					PFN_PHYS(nr_pages))))
> +				 PFN_PHYS(nr_pages)) && mode == DAX_OP_NORMAL))
>  		return -EIO;
>  
>  	if (kaddr)
> @@ -303,20 +303,85 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
>  }
>  
>  /*
> - * Use the 'no check' versions of copy_from_iter_flushcache() and
> - * copy_mc_to_iter() to bypass HARDENED_USERCOPY overhead. Bounds
> - * checking, both file offset and device offset, is handled by
> - * dax_iomap_actor()
> + * Even though the 'no check' versions of copy_from_iter_flushcache()
> + * and copy_mc_to_iter() are used to bypass HARDENED_USERCOPY overhead,
> + * 'read'/'write' aren't always safe when poison is consumed. They happen
> + * to be safe because the 'read'/'write' range has been guaranteed
> + * be free of poison(s) by a prior call to dax_direct_access() on the
> + * caller stack.
> + * But on a data recovery code path, the 'read'/'write' range is expected
> + * to contain poison(s), and so poison(s) is explicit checked, such that
> + * 'read' can fetch data from clean page(s) up till the first poison is
> + * encountered, and 'write' requires the range be page aligned in order
> + * to restore the poisoned page's memory type back to "rw" after clearing
> + * the poison(s).
> + * In the event of poison related failure, (size_t) -EIO is returned and
> + * caller may check the return value after casting it to (ssize_t).
> + *
> + * TODO: add support for CPUs that support MOVDIR64B instruction for
> + * faster poison clearing, and possibly smaller error blast radius.

I get that it's still early days yet for whatever pmem stuff is going on
for 5.17, but I feel like this ought to be a separate function called by
pmem_copy_from_iter, with this huge comment attached to that recovery
function.

>   */
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

Looks reasonable enough to me, though you might want to restructure this
to reduce the amount of indent.

FWIW I dislike how is_bad_pmem mixes units (sector_t vs. bytes), that
was seriously confusing.  But I guess that's a weird quirk of the
badblocks API and .... ugh.

(I dunno, can we at least clean up the nvdimm parts and some day replace
the badblocks backend with something that can handle more than 16
records?  interval_tree is more than up to that task, I know, I use it
for xfs online fsck...)

> +		}
> +	}
> +
>  	return _copy_from_iter_flushcache(addr, bytes, i);
>  }
>  
>  static size_t pmem_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff,
>  		void *addr, size_t bytes, struct iov_iter *i, int mode)
>  {
> +	int num_bad;
> +	size_t len, lead_off;
> +	unsigned long bad_pfn;
> +	bool bad_pmem = false;
> +	size_t adj_len = bytes;
> +	sector_t sector, first_bad;
> +	struct pmem_device *pmem = dax_get_private(dax_dev);
> +	struct device *dev = pmem->bb.dev;
> +
> +	if (unlikely(mode == DAX_OP_RECOVERY)) {
> +		sector = PFN_PHYS(pgoff) / 512;
> +		lead_off = (unsigned long)addr & ~PAGE_MASK;
> +		len = PFN_PHYS(PFN_UP(lead_off + bytes));
> +		if (pmem->bb.count)
> +			bad_pmem = !!badblocks_check(&pmem->bb, sector,
> +					len / 512, &first_bad, &num_bad);
> +		if (bad_pmem) {
> +			bad_pfn = PHYS_PFN(first_bad * 512);
> +			if (bad_pfn == pgoff) {
> +				dev_warn(dev, "Found poison in page: pgoff(%#lx)\n",
> +					pgoff);
> +				return -EIO;
> +			}
> +			adj_len = PFN_PHYS(bad_pfn - pgoff) - lead_off;
> +			dev_WARN_ONCE(dev, (adj_len > bytes),
> +					"out-of-range first_bad?");
> +		}
> +		if (adj_len == 0)
> +			return (size_t) -EIO;

Uh, are we supposed to adjust bytes here or something?

--D

> +	}
> +
>  	return _copy_mc_to_iter(addr, bytes, i);
>  }
>  
> diff --git a/fs/dax.c b/fs/dax.c
> index bea6df1498c3..7640be6b6a97 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1219,6 +1219,8 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
>  		unsigned offset = pos & (PAGE_SIZE - 1);
>  		const size_t size = ALIGN(length + offset, PAGE_SIZE);
>  		const sector_t sector = dax_iomap_sector(iomap, pos);
> +		long nr_page = PHYS_PFN(size);
> +		int dax_mode = DAX_OP_NORMAL;
>  		ssize_t map_len;
>  		pgoff_t pgoff;
>  		void *kaddr;
> @@ -1232,8 +1234,13 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
>  		if (ret)
>  			break;
>  
> -		map_len = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size),
> -					    DAX_OP_NORMAL, &kaddr, NULL);
> +		map_len = dax_direct_access(dax_dev, pgoff, nr_page, dax_mode,
> +					    &kaddr, NULL);
> +		if (unlikely(map_len == -EIO)) {
> +			dax_mode = DAX_OP_RECOVERY;
> +			map_len = dax_direct_access(dax_dev, pgoff, nr_page,
> +						    dax_mode, &kaddr, NULL);
> +		}
>  		if (map_len < 0) {
>  			ret = map_len;
>  			break;
> @@ -1252,11 +1259,20 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
>  		 */
>  		if (iov_iter_rw(iter) == WRITE)
>  			xfer = dax_copy_from_iter(dax_dev, pgoff, kaddr,
> -					map_len, iter, DAX_OP_NORMAL);
> +					map_len, iter, dax_mode);
>  		else
>  			xfer = dax_copy_to_iter(dax_dev, pgoff, kaddr,
> -					map_len, iter, DAX_OP_NORMAL);
> +					map_len, iter, dax_mode);
>  
> +		/*
> +		 * If dax data recovery is enacted via DAX_OP_RECOVERY,
> +		 * recovery failure would be indicated by a -EIO return
> +		 * in 'xfer' casted as (size_t).
> +		 */
> +		if ((ssize_t)xfer == -EIO) {
> +			ret = -EIO;
> +			break;
> +		}
>  		pos += xfer;
>  		length -= xfer;
>  		done += xfer;
> -- 
> 2.18.4
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

