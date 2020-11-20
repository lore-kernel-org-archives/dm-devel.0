Return-Path: <SRS0=RcAx=E2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7078DC63777
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:08:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B7A8322210
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:08:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7A8322210
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-5Ydd3umiO46Uf6Yb-vpMjQ-1; Fri, 20 Nov 2020 04:08:39 -0500
X-MC-Unique: 5Ydd3umiO46Uf6Yb-vpMjQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 676C1911E4;
	Fri, 20 Nov 2020 09:08:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 459B560BE2;
	Fri, 20 Nov 2020 09:08:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DDE474BB7B;
	Fri, 20 Nov 2020 09:08:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AK98TlT020791 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Nov 2020 04:08:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3E4C8E77A1; Fri, 20 Nov 2020 09:08:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 36B08E7795
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 09:08:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13DA7800B3B
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 09:08:27 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-191-_shOM7jxMTqHOsNDKXmpww-1;
	Fri, 20 Nov 2020 04:08:24 -0500
X-MC-Unique: _shOM7jxMTqHOsNDKXmpww-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0DA3867373; Fri, 20 Nov 2020 10:08:21 +0100 (CET)
Date: Fri, 20 Nov 2020 10:08:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Message-ID: <20201120090820.GD21715@lst.de>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-15-hch@lst.de>
	<20201119120525.GW1981@quack2.suse.cz>
MIME-Version: 1.0
In-Reply-To: <20201119120525.GW1981@quack2.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	linux-mm@kvack.org, Jan Kara <jack@suse.com>,
	Tejun Heo <tj@kernel.org>, xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org, Christoph Hellwig <hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 19, 2020 at 01:05:25PM +0100, Jan Kara wrote:
> > @@ -613,7 +613,7 @@ void guard_bio_eod(struct bio *bio)
> >  	rcu_read_lock();
> >  	part = __disk_get_part(bio->bi_disk, bio->bi_partno);
> >  	if (part)
> > -		maxsector = part_nr_sects_read(part);
> > +		maxsector = bdev_nr_sectors(part->bdev);
> >  	else
> >  		maxsector = get_capacity(bio->bi_disk);
> 
> I have to say that after these changes I find it a bit confusing that we
> have get/set_capacity() and bdev_nr_sectors() / bdev_set_nr_sectors() and
> they are all the same thing (i_size of the bdev). Is there a reason for the
> distinction?

get_capacity/set_capacity are the existing unchanged interfaces that
work on struct gendisk, and unchanged from what we had before.  They also
have lots of users which makes them kinda awkward to touch.

bdev_nr_sectors is the public interface to query the size for any
kind of struct block device, to be used by consumers of the block
device interface.

bdev_set_nr_sectors is a private helper for the partitions core that
avoids duplicating a bit of code, and works on partitions.



> > @@ -38,6 +38,16 @@ static void disk_add_events(struct gendisk *disk);
> >  static void disk_del_events(struct gendisk *disk);
> >  static void disk_release_events(struct gendisk *disk);
> >  
> > +void set_capacity(struct gendisk *disk, sector_t sectors)
> > +{
> > +	struct block_device *bdev = disk->part0.bdev;
> > +
> > +	spin_lock(&bdev->bd_size_lock);
> > +	i_size_write(bdev->bd_inode, (loff_t)sectors << SECTOR_SHIFT);
> > +	spin_unlock(&bdev->bd_size_lock);
> 
> AFAICT bd_size_lock is pointless after these changes so we can just remove
> it?

I don't think it is, as reuqiring bd_mutex for size updates leads to
rather awkward lock ordering problems.

> >  	if (capacity != size && capacity != 0 && size != 0) {
> >  		char *envp[] = { "RESIZE=1", NULL };
> >  
> > +		pr_info("%s: detected capacity change from %lld to %lld\n",
> > +		       disk->disk_name, size, capacity);
> 
> So we are now missing above message for transitions from / to 0 capacity?
> Is there any other notification in the kernel log when e.g. media is
> inserted into a CD-ROM drive? I remember using these messages for detecting
> that...

True, I guess we should keep the messages for that case at least under
some circumstances.  Let me take a closer look at what could make sense.

> Also what about GENHD_FL_HIDDEN devices? Are we sure we never set capacity
> for them?

We absolutely set the capacity for them, as we have to.  And even use
this interface.  But yes, I think we should skip sending the uevent for
them.

> > @@ -1158,8 +1169,7 @@ ssize_t part_size_show(struct device *dev,
> >  {
> >  	struct hd_struct *p = dev_to_part(dev);
> >  
> > -	return sprintf(buf, "%llu\n",
> > -		(unsigned long long)part_nr_sects_read(p));
> > +	return sprintf(buf, "%llu\n", bdev_nr_sectors(p->bdev));
> 
> Is sector_t really guaranteed to be unsigned long long?

Yes, it is these days, ever since I removed the option to have a 32-bit
one on 32-bit platforms a while ago.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

