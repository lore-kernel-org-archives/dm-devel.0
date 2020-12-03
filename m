Return-Path: <SRS0=8v/u=FH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 711B5C63777
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 09:34:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B93EC2222E
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 09:34:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B93EC2222E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1606988057;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=U8UAaDSqvfPJXWjSC/bDjni56aVSyi6hoq8l4Vs4ZxI=;
	b=UIJ2n6xeQCPJg6sOTGmJASEqJkJz0p+abDAQcw6gjMMTdL/j9fxOd68QiLoje6r1oBISev
	fzrEKx+APH+SMqqJhEJTBeUwkoQNOq19kCziH5otm8fXoJbDmsj2+javhfMWh9biWQnram
	WRo7WJ1/lKjDxF8yVqorq0ZeqLpubkQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-0pfEtzScPiyGwX3cHQVyKA-1; Thu, 03 Dec 2020 04:34:15 -0500
X-MC-Unique: 0pfEtzScPiyGwX3cHQVyKA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78B49107464E;
	Thu,  3 Dec 2020 09:34:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 973FA5D6AC;
	Thu,  3 Dec 2020 09:34:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A5B0E5002C;
	Thu,  3 Dec 2020 09:34:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B39WObs015365 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 04:32:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2A8FE13470; Thu,  3 Dec 2020 09:32:24 +0000 (UTC)
Received: from T590 (ovpn-13-173.pek2.redhat.com [10.72.13.173])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 627CB1899A;
	Thu,  3 Dec 2020 09:32:10 +0000 (UTC)
Date: Thu, 3 Dec 2020 17:32:01 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201203093201.GC633702@T590>
References: <20201201165424.2030647-1-hch@lst.de>
	<20201201165424.2030647-4-hch@lst.de>
	<20201203063941.GA629758@T590> <20201203071055.GA633702@T590>
	<20201203082951.GA15581@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201203082951.GA15581@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-s390@vger.kernel.org,
	linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>,
	linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, linux-block@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 3/9] block: store a block_device pointer in
	struct bio
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Dec 03, 2020 at 09:29:51AM +0100, Christoph Hellwig wrote:
> On Thu, Dec 03, 2020 at 03:10:55PM +0800, Ming Lei wrote:
> > On Thu, Dec 03, 2020 at 02:40:04PM +0800, Ming Lei wrote:
> > > On Tue, Dec 01, 2020 at 05:54:18PM +0100, Christoph Hellwig wrote:
> > > > Replace the gendisk pointer in struct bio with a pointer to the newly
> > > > improved struct block device.  From that the gendisk can be trivially
> > > > accessed with an extra indirection, but it also allows to directly
> > > > look up all information related to partition remapping.
> > > 
> > > The extra indirection is often done in fast path, so just wondering why
> > > you don't consider to embed gendisk into block_device? Then the extra
> > > indirection can be avoided.
> > 
> > oops, that is only possible for disk, and indirection is still needed
> > for partitions.
> 
> I looked into that, but given that the block device is allocated as part
> of the inode we'd need to tell ->alloc_inode if we want to allocate the
> small inode without the gendisk, or the large one with it which doesn't
> work with the current interface.

I guess it could be done without fs code change, because now block device is
always allocated by bdev_alloc() since 22ae8ce8b892("block: simplify bdev/disk
lookup in blkdev_get"). And one manual inode allocation with a bit duplication
from new_inode_pseudo() should be fine:

	allocate big inode for disk, and small for partition
	inode_init_always(sb, inode);
    if (inode) {
            spin_lock(&inode->i_lock);
            inode->i_state = 0;
            spin_unlock(&inode->i_lock);
            INIT_LIST_HEAD(&inode->i_sb_list);
			inode_sb_list_add(inode);
    }

> Beause the hd_struct is gone we're
> still not using more structures in the I/O path than we did before.

Indeed, and block_device instance is often cached in IO path.


thanks,
Ming

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

