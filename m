Return-Path: <SRS0=0/af=PZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F2EC433EF
	for <dm-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:53:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BCB6E6023D
	for <dm-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:53:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BCB6E6023D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-s3mt3O1EMa6tFZkUkXbTLQ-1; Sat, 06 Nov 2021 13:53:18 -0400
X-MC-Unique: s3mt3O1EMa6tFZkUkXbTLQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12B7A8749A8;
	Sat,  6 Nov 2021 17:53:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF10D60C17;
	Sat,  6 Nov 2021 17:53:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9E8824E58F;
	Sat,  6 Nov 2021 17:53:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A6HrBqr010253 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 6 Nov 2021 13:53:11 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3324651E4; Sat,  6 Nov 2021 17:53:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E28951E1
	for <dm-devel@redhat.com>; Sat,  6 Nov 2021 17:53:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1AA98106668D
	for <dm-devel@redhat.com>; Sat,  6 Nov 2021 17:53:02 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-262-ajfTw3wLN26HE0ZtiBL29Q-1;
	Fri, 05 Nov 2021 21:51:01 -0400
X-MC-Unique: ajfTw3wLN26HE0ZtiBL29Q-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D69C60EB4;
	Sat,  6 Nov 2021 01:50:59 +0000 (UTC)
Date: Fri, 5 Nov 2021 18:50:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jane Chu <jane.chu@oracle.com>
Message-ID: <20211106015058.GK2237511@magnolia>
References: <20211106011638.2613039-1-jane.chu@oracle.com>
	<20211106011638.2613039-2-jane.chu@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20211106011638.2613039-2-jane.chu@oracle.com>
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
Subject: Re: [dm-devel] [PATCH v2 1/2] dax: Introduce normal and recovery
 dax operation modes
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Nov 05, 2021 at 07:16:37PM -0600, Jane Chu wrote:
> Introduce DAX_OP_NORMAL and DAX_OP_RECOVERY operation modes to
> {dax_direct_access, dax_copy_from_iter, dax_copy_to_iter}.
> DAX_OP_NORMAL is the default or the existing mode, and
> DAX_OP_RECOVERY is a new mode for data recovery purpose.
> 
> When dax-FS suspects dax media error might be encountered
> on a read or write, it can enact the recovery mode read or write
> by setting DAX_OP_RECOVERY in the aforementioned APIs. A read
> in recovery mode attempts to fetch as much data as possible
> until the first poisoned page is encountered. A write in recovery
> mode attempts to clear poison(s) in a page-aligned range and
> then write the user provided data over.
> 
> DAX_OP_NORMAL should be used for all non-recovery code path.
> 
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  drivers/dax/super.c             | 15 +++++++++------
>  drivers/md/dm-linear.c          | 14 ++++++++------
>  drivers/md/dm-log-writes.c      | 19 +++++++++++--------
>  drivers/md/dm-stripe.c          | 14 ++++++++------
>  drivers/md/dm-target.c          |  2 +-
>  drivers/md/dm-writecache.c      |  8 +++++---
>  drivers/md/dm.c                 | 14 ++++++++------
>  drivers/nvdimm/pmem.c           | 11 ++++++-----
>  drivers/nvdimm/pmem.h           |  2 +-
>  drivers/s390/block/dcssblk.c    | 13 ++++++++-----
>  fs/dax.c                        | 14 ++++++++------
>  fs/fuse/dax.c                   |  4 ++--
>  fs/fuse/virtio_fs.c             | 12 ++++++++----
>  include/linux/dax.h             | 18 +++++++++++-------
>  include/linux/device-mapper.h   |  5 +++--
>  tools/testing/nvdimm/pmem-dax.c |  2 +-
>  16 files changed, 98 insertions(+), 69 deletions(-)
> 

<snip>

> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 324363b798ec..931586df2905 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -9,6 +9,10 @@
>  /* Flag for synchronous flush */
>  #define DAXDEV_F_SYNC (1UL << 0)
>  
> +/* dax operation mode dynamically set by caller */
> +#define	DAX_OP_NORMAL		0
> +#define	DAX_OP_RECOVERY		1

Mostly looks ok to me, but since this is an operation mode, should this
be an enum instead of an int?

Granted I also think six arguments is a lot... though I don't really
see any better way to do this.

(Dunno, I spent all day running internal patches through the process
gauntlet so this is the remaining 2% of my brain speaking...)

--D

> +
>  typedef unsigned long dax_entry_t;
>  
>  struct dax_device;
> @@ -22,8 +26,8 @@ struct dax_operations {
>  	 * logical-page-offset into an absolute physical pfn. Return the
>  	 * number of pages available for DAX at that pfn.
>  	 */
> -	long (*direct_access)(struct dax_device *, pgoff_t, long,
> -			void **, pfn_t *);
> +	long (*direct_access)(struct dax_device *, pgoff_t, long, int,
> +				void **, pfn_t *);
>  	/*
>  	 * Validate whether this device is usable as an fsdax backing
>  	 * device.
> @@ -32,10 +36,10 @@ struct dax_operations {
>  			sector_t, sector_t);
>  	/* copy_from_iter: required operation for fs-dax direct-i/o */
>  	size_t (*copy_from_iter)(struct dax_device *, pgoff_t, void *, size_t,
> -			struct iov_iter *);
> +			struct iov_iter *, int);
>  	/* copy_to_iter: required operation for fs-dax direct-i/o */
>  	size_t (*copy_to_iter)(struct dax_device *, pgoff_t, void *, size_t,
> -			struct iov_iter *);
> +			struct iov_iter *, int);
>  	/* zero_page_range: required operation. Zero page range   */
>  	int (*zero_page_range)(struct dax_device *, pgoff_t, size_t);
>  };
> @@ -186,11 +190,11 @@ static inline void dax_read_unlock(int id)
>  bool dax_alive(struct dax_device *dax_dev);
>  void *dax_get_private(struct dax_device *dax_dev);
>  long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
> -		void **kaddr, pfn_t *pfn);
> +		int mode, void **kaddr, pfn_t *pfn);
>  size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
> -		size_t bytes, struct iov_iter *i);
> +		size_t bytes, struct iov_iter *i, int mode);
>  size_t dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
> -		size_t bytes, struct iov_iter *i);
> +		size_t bytes, struct iov_iter *i, int mode);
>  int dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
>  			size_t nr_pages);
>  void dax_flush(struct dax_device *dax_dev, void *addr, size_t size);
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index a7df155ea49b..6596a8e0ceed 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -146,9 +146,10 @@ typedef int (*dm_busy_fn) (struct dm_target *ti);
>   * >= 0 : the number of bytes accessible at the address
>   */
>  typedef long (*dm_dax_direct_access_fn) (struct dm_target *ti, pgoff_t pgoff,
> -		long nr_pages, void **kaddr, pfn_t *pfn);
> +		long nr_pages, int mode, void **kaddr, pfn_t *pfn);
>  typedef size_t (*dm_dax_copy_iter_fn)(struct dm_target *ti, pgoff_t pgoff,
> -		void *addr, size_t bytes, struct iov_iter *i);
> +		void *addr, size_t bytes, struct iov_iter *i,
> +		int mode);
>  typedef int (*dm_dax_zero_page_range_fn)(struct dm_target *ti, pgoff_t pgoff,
>  		size_t nr_pages);
>  
> diff --git a/tools/testing/nvdimm/pmem-dax.c b/tools/testing/nvdimm/pmem-dax.c
> index af19c85558e7..71c225630e7e 100644
> --- a/tools/testing/nvdimm/pmem-dax.c
> +++ b/tools/testing/nvdimm/pmem-dax.c
> @@ -8,7 +8,7 @@
>  #include <nd.h>
>  
>  long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
> -		long nr_pages, void **kaddr, pfn_t *pfn)
> +		long nr_pages, int mode, void **kaddr, pfn_t *pfn)
>  {
>  	resource_size_t offset = PFN_PHYS(pgoff) + pmem->data_offset;
>  
> -- 
> 2.18.4
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

