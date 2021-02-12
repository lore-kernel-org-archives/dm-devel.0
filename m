Return-Path: <SRS0=g2U3=HO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58883C433E0
	for <dm-devel@archiver.kernel.org>; Fri, 12 Feb 2021 11:35:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BACB464E16
	for <dm-devel@archiver.kernel.org>; Fri, 12 Feb 2021 11:35:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BACB464E16
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-WXkS4b0qOTu0lyLeBVEUhw-1; Fri, 12 Feb 2021 06:35:14 -0500
X-MC-Unique: WXkS4b0qOTu0lyLeBVEUhw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 949D680196C;
	Fri, 12 Feb 2021 11:35:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2830318A50;
	Fri, 12 Feb 2021 11:35:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 75E5B4EE76;
	Fri, 12 Feb 2021 11:35:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11CBZ1Qt025790 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Feb 2021 06:35:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 022F12166B28; Fri, 12 Feb 2021 11:35:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F03B42166B2D
	for <dm-devel@redhat.com>; Fri, 12 Feb 2021 11:34:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DA21101A53B
	for <dm-devel@redhat.com>; Fri, 12 Feb 2021 11:34:58 +0000 (UTC)
Received: from mx4.veeam.com (mx4.veeam.com [104.41.138.86]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-260-R7K5lIlpMxCUcMknT0Z-SA-1;
	Fri, 12 Feb 2021 06:34:54 -0500
X-MC-Unique: R7K5lIlpMxCUcMknT0Z-SA-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx4.veeam.com (Postfix) with ESMTPS id 61B68114A70;
	Fri, 12 Feb 2021 14:34:51 +0300 (MSK)
Received: from veeam.com (172.24.14.5) by prgmbx01.amust.local (172.24.0.171)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.721.2;
	Fri, 12 Feb 2021 12:34:49 +0100
Date: Fri, 12 Feb 2021 14:34:38 +0300
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <20210212113438.GA9877@veeam.com>
References: <1612881028-7878-1-git-send-email-sergei.shtepa@veeam.com>
	<1612881028-7878-6-git-send-email-sergei.shtepa@veeam.com>
	<20210211175151.GA13839@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210211175151.GA13839@redhat.com>
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx01.amust.local (172.24.0.171) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29C604D265617063
X-Veeam-MMEX: True
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
	"Damien.LeMoal@wdc.com" <Damien.LeMoal@wdc.com>,
	Pavel Tide <Pavel.TIde@veeam.com>, "jack@suse.cz" <jack@suse.cz>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"johannes.thumshirn@wdc.com" <johannes.thumshirn@wdc.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ming.lei@redhat.com" <ming.lei@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"steve@sk2.org" <steve@sk2.org>, "koct9i@gmail.com" <koct9i@gmail.com>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v5 5/6] dm: add 'noexcl' option for dm-linear
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The 02/11/2021 20:51, Mike Snitzer wrote:
> On Tue, Feb 09 2021 at  9:30am -0500,
> Sergei Shtepa <sergei.shtepa@veeam.com> wrote:
> 
> > The 'noexcl' option allow to open underlying block-device
> > without FMODE_EXCL.
> > 
> > Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
> > ---
> >  drivers/md/dm-linear.c        | 14 +++++++++++++-
> >  drivers/md/dm-table.c         | 14 ++++++++------
> >  drivers/md/dm.c               | 26 +++++++++++++++++++-------
> >  drivers/md/dm.h               |  2 +-
> >  include/linux/device-mapper.h |  7 +++++++
> >  5 files changed, 48 insertions(+), 15 deletions(-)
> > 
> > diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
> > index 00774b5d7668..b16d89802b9d 100644
> > --- a/drivers/md/dm-linear.c
> > +++ b/drivers/md/dm-linear.c
> > @@ -33,7 +33,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> >  	char dummy;
> >  	int ret;
> >  
> > -	if (argc != 2) {
> > +	if ((argc < 2) || (argc > 3)) {
> >  		ti->error = "Invalid argument count";
> >  		return -EINVAL;
> >  	}
> > @@ -51,6 +51,18 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> >  	}
> >  	lc->start = tmp;
> >  
> > +	ti->non_exclusive = false;
> > +	if (argc > 2) {
> > +		if (strcmp("noexcl", argv[2]) == 0)
> > +			ti->non_exclusive = true;
> > +		else if (strcmp("excl", argv[2]) == 0)
> > +			ti->non_exclusive = false;
> > +		else {
> > +			ti->error = "Invalid exclusive option";
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> >  	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &lc->dev);
> >  	if (ret) {
> >  		ti->error = "Device lookup failed";
> > diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> > index 4acf2342f7ad..f020459465bd 100644
> > --- a/drivers/md/dm-table.c
> > +++ b/drivers/md/dm-table.c
> > @@ -322,7 +322,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
> >   * device and not to touch the existing bdev field in case
> >   * it is accessed concurrently.
> >   */
> > -static int upgrade_mode(struct dm_dev_internal *dd, fmode_t new_mode,
> > +static int upgrade_mode(struct dm_dev_internal *dd, fmode_t new_mode, bool non_exclusive,
> >  			struct mapped_device *md)
> >  {
> >  	int r;
> > @@ -330,8 +330,8 @@ static int upgrade_mode(struct dm_dev_internal *dd, fmode_t new_mode,
> >  
> >  	old_dev = dd->dm_dev;
> >  
> > -	r = dm_get_table_device(md, dd->dm_dev->bdev->bd_dev,
> > -				dd->dm_dev->mode | new_mode, &new_dev);
> > +	r = dm_get_table_device(md, dd->dm_dev->bdev->bd_dev, dd->dm_dev->mode | new_mode,
> > +				non_exclusive, &new_dev);
> >  	if (r)
> >  		return r;
> >  
> > @@ -387,7 +387,8 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
> >  		if (!dd)
> >  			return -ENOMEM;
> >  
> > -		if ((r = dm_get_table_device(t->md, dev, mode, &dd->dm_dev))) {
> > +		r = dm_get_table_device(t->md, dev, mode, ti->non_exclusive, &dd->dm_dev);
> > +		if (r) {
> >  			kfree(dd);
> >  			return r;
> >  		}
> > @@ -396,8 +397,9 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
> >  		list_add(&dd->list, &t->devices);
> >  		goto out;
> >  
> > -	} else if (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) {
> > -		r = upgrade_mode(dd, mode, t->md);
> > +	} else if ((dd->dm_dev->mode != (mode | dd->dm_dev->mode)) &&
> > +		   (dd->dm_dev->non_exclusive != ti->non_exclusive)) {
> > +		r = upgrade_mode(dd, mode, ti->non_exclusive, t->md);
> >  		if (r)
> >  			return r;
> >  	}
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index 00c41aa6d092..c25dcc2fdb89 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -1117,33 +1117,44 @@ static void close_table_device(struct table_device *td, struct mapped_device *md
> >  	if (!td->dm_dev.bdev)
> >  		return;
> >  
> > -	bd_unlink_disk_holder(td->dm_dev.bdev, dm_disk(md));
> > -	blkdev_put(td->dm_dev.bdev, td->dm_dev.mode | FMODE_EXCL);
> > +	if (td->dm_dev.non_exclusive)
> > +		blkdev_put(td->dm_dev.bdev, td->dm_dev.mode);
> > +	else {
> > +		bd_unlink_disk_holder(td->dm_dev.bdev, dm_disk(md));
> > +		blkdev_put(td->dm_dev.bdev, td->dm_dev.mode | FMODE_EXCL);
> > +	}
> > +
> > +
> > +	blkdev_put(td->dm_dev.bdev, td->dm_dev.mode);
> > +
> >  	put_dax(td->dm_dev.dax_dev);
> >  	td->dm_dev.bdev = NULL;
> >  	td->dm_dev.dax_dev = NULL;
> > +	td->dm_dev.non_exclusive = false;
> >  }
> >  
> >  static struct table_device *find_table_device(struct list_head *l, dev_t dev,
> > -					      fmode_t mode)
> > +					      fmode_t mode, bool non_exclusive)
> >  {
> >  	struct table_device *td;
> >  
> >  	list_for_each_entry(td, l, list)
> > -		if (td->dm_dev.bdev->bd_dev == dev && td->dm_dev.mode == mode)
> > +		if (td->dm_dev.bdev->bd_dev == dev &&
> > +		    td->dm_dev.mode == mode &&
> > +		    td->dm_dev.non_exclusive == non_exclusive)
> >  			return td;
> >  
> >  	return NULL;
> >  }
> >  
> > -int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode,
> > +int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode, bool non_exclusive,
> >  			struct dm_dev **result)
> >  {
> >  	int r;
> >  	struct table_device *td;
> >  
> >  	mutex_lock(&md->table_devices_lock);
> > -	td = find_table_device(&md->table_devices, dev, mode);
> > +	td = find_table_device(&md->table_devices, dev, mode, non_exclusive);
> >  	if (!td) {
> >  		td = kmalloc_node(sizeof(*td), GFP_KERNEL, md->numa_node_id);
> >  		if (!td) {
> > @@ -1154,7 +1165,8 @@ int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode,
> >  		td->dm_dev.mode = mode;
> >  		td->dm_dev.bdev = NULL;
> >  
> > -		if ((r = open_table_device(td, dev, md))) {
> > +		r = open_table_device(td, dev, md, non_exclusive);
> > +		if (r) {
> >  			mutex_unlock(&md->table_devices_lock);
> >  			kfree(td);
> >  			return r;
> > diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> > index fffe1e289c53..7bf20fb2de74 100644
> > --- a/drivers/md/dm.h
> > +++ b/drivers/md/dm.h
> > @@ -179,7 +179,7 @@ int dm_open_count(struct mapped_device *md);
> >  int dm_lock_for_deletion(struct mapped_device *md, bool mark_deferred, bool only_deferred);
> >  int dm_cancel_deferred_remove(struct mapped_device *md);
> >  int dm_request_based(struct mapped_device *md);
> > -int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode,
> > +int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode, bool non_exclusive,
> >  			struct dm_dev **result);
> >  void dm_put_table_device(struct mapped_device *md, struct dm_dev *d);
> >  
> > diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> > index 61a66fb8ebb3..70002363bfc0 100644
> > --- a/include/linux/device-mapper.h
> > +++ b/include/linux/device-mapper.h
> > @@ -150,6 +150,7 @@ struct dm_dev {
> >  	struct block_device *bdev;
> >  	struct dax_device *dax_dev;
> >  	fmode_t mode;
> > +	bool non_exclusive;
> >  	char name[16];
> >  };
> >  
> > @@ -325,6 +326,12 @@ struct dm_target {
> >  	 * whether or not its underlying devices have support.
> >  	 */
> >  	bool discards_supported:1;
> > +
> > +	/*
> > +	 * Set if this target needs to open device without FMODE_EXCL
> > +	 * mode.
> > +	 */
> > +	bool non_exclusive:1;
> >  };
> >  
> >  void *dm_per_bio_data(struct bio *bio, size_t data_size);
> > -- 
> > 2.20.1
> > 
> 
> I'm really not liking this tug-of-war about FMODE_EXCL vs not.
> Especially dislike the prospect of needing to change _every_ DM target
> that would be made to support blk_interposer.
> 
> I've said this before, private or otherwise, but: Hannes' approach that
> fell back to opening without FMODE_EXCL if FMODE_EXCL open failed.  Have
> you explored that kind of approach?

Of course I explored that kind of approach. The easiest thing to do
is fell back to opening without FMODE_EXCL if FMODE_EXCL open failed.

But I remind you once again that in this case, without changing
the code of each target, we will change the behavior of each.
Any target will open the device without the FMODE_EXCL flag if the device
is already busy. This can cause errors and cause data loss.
I would not want the device mapper to get worse when adding new functionality.

I will do so in the next patch, as you are sure that it is better... Or
I'll think about it again and try to suggest a better implementation.

Thank you, Mike.

> 
> You _should_ be able to infer that interposer is being used given the
> requirement to use an explicit remap ioctl to establish the use of
> interposer.
> 
> Mike
> 

-- 
Sergei Shtepa
Veeam Software developer.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

