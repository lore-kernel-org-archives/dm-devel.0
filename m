Return-Path: <SRS0=8HMs=E7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E919CC5519F
	for <dm-devel@archiver.kernel.org>; Wed, 25 Nov 2020 11:41:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0C7C3206D4
	for <dm-devel@archiver.kernel.org>; Wed, 25 Nov 2020 11:41:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C7C3206D4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-k-kZ1EV8NO2wd8MQk8kkvw-1; Wed, 25 Nov 2020 06:41:04 -0500
X-MC-Unique: k-kZ1EV8NO2wd8MQk8kkvw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C36751E7C5;
	Wed, 25 Nov 2020 11:40:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3875160854;
	Wed, 25 Nov 2020 11:40:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 48D074BB7B;
	Wed, 25 Nov 2020 11:40:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0APBep9i019634 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 25 Nov 2020 06:40:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9511A2026D3C; Wed, 25 Nov 2020 11:40:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8EE9A2026D36
	for <dm-devel@redhat.com>; Wed, 25 Nov 2020 11:40:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30F6E811E76
	for <dm-devel@redhat.com>; Wed, 25 Nov 2020 11:40:49 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-442-6n3peBgINeGimg7JSkxXYA-1;
	Wed, 25 Nov 2020 06:40:46 -0500
X-MC-Unique: 6n3peBgINeGimg7JSkxXYA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 3F6BDAC41;
	Wed, 25 Nov 2020 11:40:45 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id D8B791E130F; Wed, 25 Nov 2020 12:40:44 +0100 (CET)
Date: Wed, 25 Nov 2020 12:40:44 +0100
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Message-ID: <20201125114044.GC16944@quack2.suse.cz>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-12-hch@lst.de>
	<X708BTJ5njtbC2z1@mtj.duckdns.org>
MIME-Version: 1.0
In-Reply-To: <X708BTJ5njtbC2z1@mtj.duckdns.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH 11/20] block: reference struct block_device
 from struct hd_struct
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Hello!

On Tue 24-11-20 11:59:49, Tejun Heo wrote:
> > diff --git a/block/partitions/core.c b/block/partitions/core.c
> > index a02e224115943d..0ba0bf44b88af3 100644
> > --- a/block/partitions/core.c
> > +++ b/block/partitions/core.c
> > @@ -340,12 +340,11 @@ void delete_partition(struct hd_struct *part)
> >  	device_del(part_to_dev(part));
> >  
> >  	/*
> > -	 * Remove gendisk pointer from idr so that it cannot be looked up
> > -	 * while RCU period before freeing gendisk is running to prevent
> > -	 * use-after-free issues. Note that the device number stays
> > -	 * "in-use" until we really free the gendisk.
> > +	 * Remove the block device from the inode hash, so that it cannot be
> > +	 * looked up while waiting for the RCU grace period.
> >  	 */
> > -	blk_invalidate_devt(part_devt(part));
> > +	remove_inode_hash(part->bdev->bd_inode);
> 
> I don't think this is necessary now that the bdev and inode lifetimes are
> one. Before, punching out the association early was necessary because we
> could be in a situation where we can successfully look up a part from idr
> and then try to pin the associated disk which may already be freed. With the
> new code, the lookup is through the inode whose lifetime is one and the same
> with gendisk, so use-after-free isn't possible and __blkdev_get() will
> reliably reject such open attempts.

I think the remove_inode_hash() call is actually still needed. Consider a
situation when the disk is unplugged, gendisk gets destroyed, bdev still
lives on (e.g. because it is still open). Device gets re-plugged, gendisk
for the same device number gets created. But we really need new bdev for
this because from higher level POV this is completely new device. And the
old bdev needs to live on as long as it is open. So IMO we still need to
just unhash the inode and leave it lingering in the background.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

