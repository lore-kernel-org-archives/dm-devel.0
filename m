Return-Path: <SRS0=RcAx=E2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 985EBC56202
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 11:21:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DDEA82222F
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 11:21:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDEA82222F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-zQZt1F6BPWWdAhsYFiXK6w-1; Fri, 20 Nov 2020 06:21:40 -0500
X-MC-Unique: zQZt1F6BPWWdAhsYFiXK6w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E87789CDAD;
	Fri, 20 Nov 2020 11:21:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 59FCA6085A;
	Fri, 20 Nov 2020 11:21:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D75095002C;
	Fri, 20 Nov 2020 11:21:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AKBLUrZ008019 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Nov 2020 06:21:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8EEC6101B54F; Fri, 20 Nov 2020 11:21:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8ADE2101B54B
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 11:21:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8EF518007D9
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 11:21:27 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-228-SImiRL-lNWKJLzK5UykkTQ-1;
	Fri, 20 Nov 2020 06:21:23 -0500
X-MC-Unique: SImiRL-lNWKJLzK5UykkTQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id C4C79AED9;
	Fri, 20 Nov 2020 11:21:21 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id 2825E1E130B; Fri, 20 Nov 2020 12:21:21 +0100 (CET)
Date: Fri, 20 Nov 2020 12:21:21 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201120112121.GB15537@quack2.suse.cz>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-15-hch@lst.de>
	<20201119120525.GW1981@quack2.suse.cz>
	<20201120090820.GD21715@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201120090820.GD21715@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>,
	xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [dm-devel] [PATCH 14/20] block: remove the nr_sects field in
 struct hd_struct
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

On Fri 20-11-20 10:08:20, Christoph Hellwig wrote:
> On Thu, Nov 19, 2020 at 01:05:25PM +0100, Jan Kara wrote:
> > > @@ -613,7 +613,7 @@ void guard_bio_eod(struct bio *bio)
> > >  	rcu_read_lock();
> > >  	part = __disk_get_part(bio->bi_disk, bio->bi_partno);
> > >  	if (part)
> > > -		maxsector = part_nr_sects_read(part);
> > > +		maxsector = bdev_nr_sectors(part->bdev);
> > >  	else
> > >  		maxsector = get_capacity(bio->bi_disk);
> > 
> > I have to say that after these changes I find it a bit confusing that we
> > have get/set_capacity() and bdev_nr_sectors() / bdev_set_nr_sectors() and
> > they are all the same thing (i_size of the bdev). Is there a reason for the
> > distinction?
> 
> get_capacity/set_capacity are the existing unchanged interfaces that
> work on struct gendisk, and unchanged from what we had before.  They also
> have lots of users which makes them kinda awkward to touch.
> 
> bdev_nr_sectors is the public interface to query the size for any
> kind of struct block device, to be used by consumers of the block
> device interface.
> 
> bdev_set_nr_sectors is a private helper for the partitions core that
> avoids duplicating a bit of code, and works on partitions.

OK, I guess I'll get used to this...

> > > @@ -38,6 +38,16 @@ static void disk_add_events(struct gendisk *disk);
> > >  static void disk_del_events(struct gendisk *disk);
> > >  static void disk_release_events(struct gendisk *disk);
> > >  
> > > +void set_capacity(struct gendisk *disk, sector_t sectors)
> > > +{
> > > +	struct block_device *bdev = disk->part0.bdev;
> > > +
> > > +	spin_lock(&bdev->bd_size_lock);
> > > +	i_size_write(bdev->bd_inode, (loff_t)sectors << SECTOR_SHIFT);
> > > +	spin_unlock(&bdev->bd_size_lock);
> > 
> > AFAICT bd_size_lock is pointless after these changes so we can just remove
> > it?
> 
> I don't think it is, as reuqiring bd_mutex for size updates leads to
> rather awkward lock ordering problems.

OK, let me ask differently: What is bd_size_lock protecting now? Ah, I see,
on 32-bit it is needed to prevent torn writes to i_size, right?

> > >  	if (capacity != size && capacity != 0 && size != 0) {
> > >  		char *envp[] = { "RESIZE=1", NULL };
> > >  
> > > +		pr_info("%s: detected capacity change from %lld to %lld\n",
> > > +		       disk->disk_name, size, capacity);
> > 
> > So we are now missing above message for transitions from / to 0 capacity?
> > Is there any other notification in the kernel log when e.g. media is
> > inserted into a CD-ROM drive? I remember using these messages for detecting
> > that...
> 
> True, I guess we should keep the messages for that case at least under
> some circumstances.  Let me take a closer look at what could make sense.
> 
> > Also what about GENHD_FL_HIDDEN devices? Are we sure we never set capacity
> > for them?
> 
> We absolutely set the capacity for them, as we have to.  And even use
> this interface.  But yes, I think we should skip sending the uevent for
> them.

Also previously we were not printing any messages for hidden devices and
now we do. I'm not sure whether that's intended or not.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

