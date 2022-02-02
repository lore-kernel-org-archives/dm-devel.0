Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBF76C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 16:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643820143;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=T4RgMhe8M6ZEXNa/AeEtyLdHbtiVMSh/mP8CgoD0WPU=;
	b=UG2OjhxOM1QHitY5dC21CiBGWh5UPjq07EWt56QbdZK7uPulRWg4jmPUvLITmG61FMro+D
	lyNUgpco90+ejm1Toh0Q92mSeinRnxlF+fw+5Av+2HbOSOlRtHP+t3mvruNy/Lg7gTdX5j
	nzNDgIOSsV3ZcCyqdmYnE9bg8CnElX4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-JyX9R1UJPwGuXouBrjRphg-1; Wed, 02 Feb 2022 11:42:14 -0500
X-MC-Unique: JyX9R1UJPwGuXouBrjRphg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CF9394DCD;
	Wed,  2 Feb 2022 16:42:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2797E8464B;
	Wed,  2 Feb 2022 16:42:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C827E1806D03;
	Wed,  2 Feb 2022 16:42:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 212GeX0c023069 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 11:40:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1A7E62998F; Wed,  2 Feb 2022 16:40:33 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 914772B4C9;
	Wed,  2 Feb 2022 16:40:32 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 212GeW3G000735; Wed, 2 Feb 2022 11:40:32 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 212GeUkY000731; Wed, 2 Feb 2022 11:40:30 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Wed, 2 Feb 2022 11:40:30 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Keith Busch <kbusch@kernel.org>
In-Reply-To: <20220202162147.GC3077632@dhcp-10-100-145-180.wdc.com>
Message-ID: <alpine.LRH.2.02.2202021134400.31294@file01.intranet.prod.int.rdu2.redhat.com>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
	<20220201102122.4okwj2gipjbvuyux@mpHalley-2>
	<alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.2202011331570.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<20220202162147.GC3077632@dhcp-10-100-145-180.wdc.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: "djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"osandov@fb.com" <osandov@fb.com>,
	=?ISO-8859-15?Q?Javier_Gonz=E1lez?= <javier@javigon.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	"msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	Jens Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com >> Martin K. Petersen"
	<martin.petersen@oracle.com>, "jack@suse.com" <jack@suse.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [dm-devel] [RFC PATCH 1/3] block: add copy offload support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Wed, 2 Feb 2022, Keith Busch wrote:

> On Tue, Feb 01, 2022 at 01:32:29PM -0500, Mikulas Patocka wrote:
> > +int blkdev_issue_copy(struct block_device *bdev1, sector_t sector1,
> > +		      struct block_device *bdev2, sector_t sector2,
> > +		      sector_t nr_sects, sector_t *copied, gfp_t gfp_mask)
> > +{
> > +	struct page *token;
> > +	sector_t m;
> > +	int r = 0;
> > +	struct completion comp;
> > +
> > +	*copied = 0;
> > +
> > +	m = min(bdev_max_copy_sectors(bdev1), bdev_max_copy_sectors(bdev2));
> > +	if (!m)
> > +		return -EOPNOTSUPP;
> > +	m = min(m, (sector_t)round_down(UINT_MAX, PAGE_SIZE) >> 9);
> > +
> > +	if (unlikely(bdev_read_only(bdev2)))
> > +		return -EPERM;
> > +
> > +	token = alloc_page(gfp_mask);
> > +	if (unlikely(!token))
> > +		return -ENOMEM;
> > +
> > +	while (nr_sects) {
> > +		struct bio *read_bio, *write_bio;
> > +		sector_t this_step = min(nr_sects, m);
> > +
> > +		read_bio = bio_alloc(gfp_mask, 1);
> > +		if (unlikely(!read_bio)) {
> > +			r = -ENOMEM;
> > +			break;
> > +		}
> > +		bio_set_op_attrs(read_bio, REQ_OP_COPY_READ_TOKEN, REQ_NOMERGE);
> > +		bio_set_dev(read_bio, bdev1);
> > +		__bio_add_page(read_bio, token, PAGE_SIZE, 0);
> 
> You have this "token" payload as driver specific data, but there's no
> check that bdev1 and bdev2 subscribe to the same driver specific format.
> 
> I thought we discussed defining something like a "copy domain" that
> establishes which block devices can offload copy operations to/from each
> other, and that should be checked before proceeding with the copy
> operation.

There is nvme_setup_read_token that fills in the token:
	memcpy(token->subsys, "nvme", 4);
	token->ns = ns;
	token->src_sector = bio->bi_iter.bi_sector;
	token->sectors = bio->bi_iter.bi_size >> 9;

There is nvme_setup_write_token that checks these values:
	if (unlikely(memcmp(token->subsys, "nvme", 4)))
		return BLK_STS_NOTSUPP;
	if (unlikely(token->ns != ns))
		return BLK_STS_NOTSUPP;

So, if we attempt to copy data between the nvme subsystem and the scsi 
subsystem, the "subsys" check will fail. If we attempt to copy data 
between different nvme namespaces, the "ns" check will fail.

If the nvme standard gets extended with cross-namespace copies, we can 
check in nvme_setup_write_token if we can copy between the source and 
destination namespace.

Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

