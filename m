Return-Path: <SRS0=8HMs=E7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA43C56202
	for <dm-devel@archiver.kernel.org>; Wed, 25 Nov 2020 16:30:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3E3B320857
	for <dm-devel@archiver.kernel.org>; Wed, 25 Nov 2020 16:30:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E3B320857
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-ok2YcIyzMd6WlP5i2WiXkw-1; Wed, 25 Nov 2020 11:30:53 -0500
X-MC-Unique: ok2YcIyzMd6WlP5i2WiXkw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3BD31006C96;
	Wed, 25 Nov 2020 16:30:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B68C10021AA;
	Wed, 25 Nov 2020 16:30:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C7E2F180954D;
	Wed, 25 Nov 2020 16:30:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0APGTags006249 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 25 Nov 2020 11:29:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9C20E2026D3B; Wed, 25 Nov 2020 16:29:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 973952026D37
	for <dm-devel@redhat.com>; Wed, 25 Nov 2020 16:29:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 600F7811E78
	for <dm-devel@redhat.com>; Wed, 25 Nov 2020 16:29:33 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-594-R0B7p41qNvSaoO_OjBx5bA-1;
	Wed, 25 Nov 2020 11:29:30 -0500
X-MC-Unique: R0B7p41qNvSaoO_OjBx5bA-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 948AB68B02; Wed, 25 Nov 2020 17:29:26 +0100 (CET)
Date: Wed, 25 Nov 2020 17:29:26 +0100
From: Christoph Hellwig <hch@lst.de>
To: Tejun Heo <tj@kernel.org>
Message-ID: <20201125162926.GA1024@lst.de>
References: <20201124132751.3747337-1-hch@lst.de>
	<20201124132751.3747337-24-hch@lst.de>
	<X71g4Tm+3RiRg4Gf@mtj.duckdns.org>
MIME-Version: 1.0
In-Reply-To: <X71g4Tm+3RiRg4Gf@mtj.duckdns.org>
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
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	Richard Weinberger <richard@nod.at>, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org, linux-mm@kvack.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-fsdevel@vger.kernel.org, xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH 23/45] block: remove i_bdev
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 24, 2020 at 02:37:05PM -0500, Tejun Heo wrote:
> On Tue, Nov 24, 2020 at 02:27:29PM +0100, Christoph Hellwig wrote:
> > Switch the block device lookup interfaces to directly work with a dev_t
> > so that struct block_device references are only acquired by the
> > blkdev_get variants (and the blk-cgroup special case).  This means that
> > we not don't need an extra reference in the inode and can generally
>      ^
>      now
> > simplify handling of struct block_device to keep the lookups contained
> > in the core block layer code.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> ...
> > @@ -1689,14 +1599,12 @@ static int blkdev_open(struct inode * inode, struct file * filp)
> >  	if ((filp->f_flags & O_ACCMODE) == 3)
> >  		filp->f_mode |= FMODE_WRITE_IOCTL;
> >  
> > -	bdev = bd_acquire(inode);
> > -	if (bdev == NULL)
> > -		return -ENOMEM;
> > -
> > +	bdev = blkdev_get_by_dev(inode->i_rdev, filp->f_mode, filp);
> > +	if (IS_ERR(bdev))
> > +		return PTR_ERR(bdev);
> >  	filp->f_mapping = bdev->bd_inode->i_mapping;
> >  	filp->f_wb_err = filemap_sample_wb_err(filp->f_mapping);
> > -
> > -	return blkdev_get(bdev, filp->f_mode, filp);
> > +	return 0;
> >  }
> 
> I was wondering whether losing the stale bdev flushing in bd_acquire() would
> cause user-visible behavior changes but can't see how it would given that
> userland has no way of holding onto a specific instance of block inode.
> Maybe it's something worth mentioning in the commit message?

With stale bdev flushing do you mean the call to bd_forget if
i_bdev exists but is unhashed?  It doesn't actually flush anything but
just detaches the old bdev from the inode so that the new one can be
attached.  That problem goes away by definition if we don't attach
the bdev to the inode.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

