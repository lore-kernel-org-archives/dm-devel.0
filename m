Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 272F2C761AF
	for <dm-devel@archiver.kernel.org>; Thu, 30 Mar 2023 06:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680157991;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5243c/ei5RS+etkNLJYebh1GDbIBCJ2k+uOjoN1TWuU=;
	b=ekm6EZa5G282mJMciNTv17sa3XGeVdvehRpGUNKBAxDGjPiKhIUIRSGXGnwBsObSReOiCo
	J77vCcOUmkm5zf/+xT5ePRDWrQy5bx9kH+j5EzAiSksGQLNQBGmXcsBI2r4wZ20tDjNhED
	5+0OiMzkS6GViC/uxx3UEgQqqqeAqvU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-96-WgHHFu5xPSyyR3o5rfhg6Q-1; Thu, 30 Mar 2023 02:33:07 -0400
X-MC-Unique: WgHHFu5xPSyyR3o5rfhg6Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1885688B7B0;
	Thu, 30 Mar 2023 06:33:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0007383B9C;
	Thu, 30 Mar 2023 06:33:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 53AC419472EE;
	Thu, 30 Mar 2023 06:33:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 55D731946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 30 Mar 2023 05:48:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3629D18EC6; Thu, 30 Mar 2023 05:48:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F25118EC2
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 05:48:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D4C438221CA
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 05:48:50 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-HWXNRi3mOsmhcH6GnBuDoA-1; Thu, 30 Mar 2023 01:48:46 -0400
X-MC-Unique: HWXNRi3mOsmhcH6GnBuDoA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 04227B825AB;
 Thu, 30 Mar 2023 05:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6990DC433D2;
 Thu, 30 Mar 2023 05:48:38 +0000 (UTC)
Date: Thu, 30 Mar 2023 07:48:35 +0200
From: Christian Brauner <brauner@kernel.org>
To: Nitesh Shetty <nj.shetty@samsung.com>
Message-ID: <20230330-strode-deforest-b65424417062@brauner>
References: <20230327084103.21601-1-anuj20.g@samsung.com>
 <CGME20230327084244epcas5p1b0ede867e558ff6faf258de3656a8aa4@epcas5p1.samsung.com>
 <20230327084103.21601-5-anuj20.g@samsung.com>
 <20230329-glitter-drainpipe-bdf9d3876ac4@brauner>
 <20230329124236.GB3895@green5>
MIME-Version: 1.0
In-Reply-To: <20230329124236.GB3895@green5>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Thu, 30 Mar 2023 06:32:57 +0000
Subject: Re: [dm-devel] [PATCH v8 4/9] fs,
 block: copy_file_range for def_blk_ops for direct block device.
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
Cc: linux-nvme@lists.infradead.org, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>,
 Sagi Grimberg <sagi@grimberg.me>, gost.dev@samsung.com,
 nitheshshetty@gmail.com, James Smart <james.smart@broadcom.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Mike Snitzer <snitzer@kernel.org>, ming.lei@redhat.com,
 linux-block@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
 bvanassche@acm.org, Jens Axboe <axboe@kernel.dk>, joshi.k@samsung.com,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 damien.lemoal@opensource.wdc.com, Alexander Viro <viro@zeniv.linux.org.uk>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Mar 29, 2023 at 06:12:36PM +0530, Nitesh Shetty wrote:
> On Wed, Mar 29, 2023 at 02:14:40PM +0200, Christian Brauner wrote:
> > On Mon, Mar 27, 2023 at 02:10:52PM +0530, Anuj Gupta wrote:
> > > From: Nitesh Shetty <nj.shetty@samsung.com>
> > > 
> > > For direct block device opened with O_DIRECT, use copy_file_range to
> > > issue device copy offload, and fallback to generic_copy_file_range incase
> > > device copy offload capability is absent.
> > > Modify checks to allow bdevs to use copy_file_range.
> > > 
> > > Suggested-by: Ming Lei <ming.lei@redhat.com>
> > > Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> > > Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> > > ---
> > >  block/blk-lib.c        | 22 ++++++++++++++++++++++
> > >  block/fops.c           | 20 ++++++++++++++++++++
> > >  fs/read_write.c        | 11 +++++++++--
> > >  include/linux/blkdev.h |  3 +++
> > >  4 files changed, 54 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/block/blk-lib.c b/block/blk-lib.c
> > > index a21819e59b29..c288573c7e77 100644
> > > --- a/block/blk-lib.c
> > > +++ b/block/blk-lib.c
> > > @@ -475,6 +475,28 @@ static inline bool blk_check_copy_offload(struct request_queue *q_in,
> > >  	return blk_queue_copy(q_in) && blk_queue_copy(q_out);
> > >  }
> > >  
> > > +int blkdev_copy_offload(struct block_device *bdev_in, loff_t pos_in,
> > > +		      struct block_device *bdev_out, loff_t pos_out, size_t len,
> > > +		      cio_iodone_t end_io, void *private, gfp_t gfp_mask)
> > > +{
> > > +	struct request_queue *in_q = bdev_get_queue(bdev_in);
> > > +	struct request_queue *out_q = bdev_get_queue(bdev_out);
> > > +	int ret = -EINVAL;
> > 
> > Why initialize to -EINVAL if blk_copy_sanity_check() initializes it
> > right away anyway?
> > 
> 
> acked.
> 
> > > +	bool offload = false;
> > 
> > Same thing with initializing offload.
> > 
> acked
> 
> > > +
> > > +	ret = blk_copy_sanity_check(bdev_in, pos_in, bdev_out, pos_out, len);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	offload = blk_check_copy_offload(in_q, out_q);
> > > +	if (offload)
> > > +		ret = __blk_copy_offload(bdev_in, pos_in, bdev_out, pos_out,
> > > +				len, end_io, private, gfp_mask);
> > > +
> > > +	return ret;
> > > +}
> > > +EXPORT_SYMBOL_GPL(blkdev_copy_offload);
> > > +
> > >  /*
> > >   * @bdev_in:	source block device
> > >   * @pos_in:	source offset
> > > diff --git a/block/fops.c b/block/fops.c
> > > index d2e6be4e3d1c..3b7c05831d5c 100644
> > > --- a/block/fops.c
> > > +++ b/block/fops.c
> > > @@ -611,6 +611,25 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
> > >  	return ret;
> > >  }
> > >  
> > > +static ssize_t blkdev_copy_file_range(struct file *file_in, loff_t pos_in,
> > > +				struct file *file_out, loff_t pos_out,
> > > +				size_t len, unsigned int flags)
> > > +{
> > > +	struct block_device *in_bdev = I_BDEV(bdev_file_inode(file_in));
> > > +	struct block_device *out_bdev = I_BDEV(bdev_file_inode(file_out));
> > > +	int comp_len = 0;
> > > +
> > > +	if ((file_in->f_iocb_flags & IOCB_DIRECT) &&
> > > +		(file_out->f_iocb_flags & IOCB_DIRECT))
> > > +		comp_len = blkdev_copy_offload(in_bdev, pos_in, out_bdev,
> > > +				 pos_out, len, NULL, NULL, GFP_KERNEL);
> > > +	if (comp_len != len)
> > > +		comp_len = generic_copy_file_range(file_in, pos_in + comp_len,
> > > +			file_out, pos_out + comp_len, len - comp_len, flags);
> > 
> > I'm not deeply familiar with this code but this looks odd. It at least
> > seems possible that comp_len could be -EINVAL and len 20 at which point
> > you'd be doing len - comp_len aka 20 - 22 = -2 in generic_copy_file_range().

20 - -22 = 44 ofc

> 
> comp_len should be 0 incase of error. We do agree, some function

I mean, not to hammer on this point too much but just to be clear
blk_copy_sanity_check(), which is introduced in the second patch, can
return both -EPERM and -EINVAL and is first called in
blkdev_copy_offload() so it's definitely possible for comp_len to be
negative.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

