Return-Path: <SRS0=YGrs=PR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B6FEC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 29 Oct 2021 11:07:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ECE6B61130
	for <dm-devel@archiver.kernel.org>; Fri, 29 Oct 2021 11:06:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org ECE6B61130
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-2joCaa98MHecWCeDji5AWA-1; Fri, 29 Oct 2021 07:06:46 -0400
X-MC-Unique: 2joCaa98MHecWCeDji5AWA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 647A510A8E05;
	Fri, 29 Oct 2021 11:06:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C4205F4EE;
	Fri, 29 Oct 2021 11:06:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6809A4E58F;
	Fri, 29 Oct 2021 11:06:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19T4wkuw029906 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 29 Oct 2021 00:58:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9FD6440CFD10; Fri, 29 Oct 2021 04:58:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9AACF40CFD0B
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 04:58:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FB7B811E78
	for <dm-devel@redhat.com>; Fri, 29 Oct 2021 04:58:46 +0000 (UTC)
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-241-5To21eeHOQ6ep0n81Ikr1g-1; Fri, 29 Oct 2021 00:58:42 -0400
X-MC-Unique: 5To21eeHOQ6ep0n81Ikr1g-1
X-IronPort-AV: E=McAfee;i="6200,9189,10151"; a="291423919"
X-IronPort-AV: E=Sophos;i="5.87,191,1631602800"; d="scan'208";a="291423919"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
	by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	28 Oct 2021 21:57:38 -0700
X-IronPort-AV: E=Sophos;i="5.87,191,1631602800"; d="scan'208";a="665692765"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
	by orsmga005-auth.jf.intel.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2021 21:57:38 -0700
Date: Thu, 28 Oct 2021 21:57:37 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20211029045737.GJ3538886@iweiny-DESK2.sc.intel.com>
References: <20211018044054.1779424-1-hch@lst.de>
	<20211018044054.1779424-4-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211018044054.1779424-4-hch@lst.de>
User-Agent: Mutt/1.11.1 (2018-12-01)
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
X-Mailman-Approved-At: Fri, 29 Oct 2021 07:06:18 -0400
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
	linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org
Subject: Re: [dm-devel] [PATCH 03/11] dax: simplify the dax_device <->
 gendisk association
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Oct 18, 2021 at 06:40:46AM +0200, Christoph Hellwig wrote:
> Replace the dax_host_hash with an xarray indexed by the pointer value
> of the gendisk, and require explicitl calls from the block drivers that
> want to associate their gendisk with a dax_device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/dax/bus.c            |   2 +-
>  drivers/dax/super.c          | 106 +++++++++--------------------------
>  drivers/md/dm.c              |   6 +-
>  drivers/nvdimm/pmem.c        |   8 ++-
>  drivers/s390/block/dcssblk.c |  11 +++-
>  fs/fuse/virtio_fs.c          |   2 +-
>  include/linux/dax.h          |  19 +++++--
>  7 files changed, 60 insertions(+), 94 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 6cc4da4c713d9..6d91b0186e3be 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1326,7 +1326,7 @@ struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
>  	 * No 'host' or dax_operations since there is no access to this
>  	 * device outside of mmap of the resulting character device.
>  	 */

NIT: this comment needs to be updated as well.

Ira

> -	dax_dev = alloc_dax(dev_dax, NULL, NULL, DAXDEV_F_SYNC);
> +	dax_dev = alloc_dax(dev_dax, NULL, DAXDEV_F_SYNC);
>  	if (IS_ERR(dax_dev)) {
>  		rc = PTR_ERR(dax_dev);
>  		goto err_alloc_dax;

[snip]

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

