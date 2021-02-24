Return-Path: <SRS0=mVW8=H2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F0D6C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 24 Feb 2021 10:46:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 51BCB64ECF
	for <dm-devel@archiver.kernel.org>; Wed, 24 Feb 2021 10:46:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51BCB64ECF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-wMODXtzvPNqVF_Rl0SEQQw-1; Wed, 24 Feb 2021 05:46:39 -0500
X-MC-Unique: wMODXtzvPNqVF_Rl0SEQQw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1DAF803648;
	Wed, 24 Feb 2021 10:46:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 00FD077708;
	Wed, 24 Feb 2021 10:46:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 632AE18095CB;
	Wed, 24 Feb 2021 10:46:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11OAkR2d021852 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Feb 2021 05:46:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6994410329A; Wed, 24 Feb 2021 10:46:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6220EFED37
	for <dm-devel@redhat.com>; Wed, 24 Feb 2021 10:46:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA1471022F0D
	for <dm-devel@redhat.com>; Wed, 24 Feb 2021 10:46:24 +0000 (UTC)
Received: from mx2.veeam.com (mx2.veeam.com [64.129.123.6]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-499-zAPKQydYMxGSjVudyQwMxg-1;
	Wed, 24 Feb 2021 05:46:18 -0500
X-MC-Unique: zAPKQydYMxGSjVudyQwMxg-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx2.veeam.com (Postfix) with ESMTPS id 2EFD941507;
	Wed, 24 Feb 2021 05:46:13 -0500 (EST)
Received: from veeam.com (172.24.14.5) by prgmbx01.amust.local (172.24.0.171)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.721.2;
	Wed, 24 Feb 2021 11:46:10 +0100
Date: Wed, 24 Feb 2021 13:46:00 +0300
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <20210224104600.GA17757@veeam.com>
References: <1612881028-7878-1-git-send-email-sergei.shtepa@veeam.com>
	<1612881028-7878-6-git-send-email-sergei.shtepa@veeam.com>
	<20210211175151.GA13839@redhat.com>
	<20210212113438.GA9877@veeam.com>
	<20210212160631.GA19424@redhat.com>
	<20210215103444.GA11820@veeam.com>
	<20210215160831.GA5371@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210215160831.GA5371@redhat.com>
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx01.amust.local (172.24.0.171) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29C604D265607264
X-Veeam-MMEX: True
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
Content-Type: multipart/mixed; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline

--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline

The 02/15/2021 19:08, Mike Snitzer wrote:
> On Mon, Feb 15 2021 at  5:34am -0500,
> Sergei Shtepa <sergei.shtepa@veeam.com> wrote:
> 
> > The 02/12/2021 19:06, Mike Snitzer wrote:
> > > On Fri, Feb 12 2021 at  6:34am -0500,
> > > Sergei Shtepa <sergei.shtepa@veeam.com> wrote:
> > > 
> > > > The 02/11/2021 20:51, Mike Snitzer wrote:
> > > > > On Tue, Feb 09 2021 at  9:30am -0500,
> > > > > Sergei Shtepa <sergei.shtepa@veeam.com> wrote:
> > > > > 
> > > > > > The 'noexcl' option allow to open underlying block-device
> > > > > > without FMODE_EXCL.
> > > > > > 
> > > > > > Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
> > > > > > ---
> > > > > >  drivers/md/dm-linear.c        | 14 +++++++++++++-
> > > > > >  drivers/md/dm-table.c         | 14 ++++++++------
> > > > > >  drivers/md/dm.c               | 26 +++++++++++++++++++-------
> > > > > >  drivers/md/dm.h               |  2 +-
> > > > > >  include/linux/device-mapper.h |  7 +++++++
> > > > > >  5 files changed, 48 insertions(+), 15 deletions(-)
> > > > > > 
> > > > > > diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
> > > > > > index 00774b5d7668..b16d89802b9d 100644
> > > > > > --- a/drivers/md/dm-linear.c
> > > > > > +++ b/drivers/md/dm-linear.c
> > > > > > @@ -33,7 +33,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> > > > > >  	char dummy;
> > > > > >  	int ret;
> > > > > >  
> > > > > > -	if (argc != 2) {
> > > > > > +	if ((argc < 2) || (argc > 3)) {
> > > > > >  		ti->error = "Invalid argument count";
> > > > > >  		return -EINVAL;
> > > > > >  	}
> > > > > > @@ -51,6 +51,18 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> > > > > >  	}
> > > > > >  	lc->start = tmp;
> > > > > >  
> > > > > > +	ti->non_exclusive = false;
> > > > > > +	if (argc > 2) {
> > > > > > +		if (strcmp("noexcl", argv[2]) == 0)
> > > > > > +			ti->non_exclusive = true;
> > > > > > +		else if (strcmp("excl", argv[2]) == 0)
> > > > > > +			ti->non_exclusive = false;
> > > > > > +		else {
> > > > > > +			ti->error = "Invalid exclusive option";
> > > > > > +			return -EINVAL;
> > > > > > +		}
> > > > > > +	}
> > > > > > +
> > > > > >  	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &lc->dev);
> > > > > >  	if (ret) {
> > > > > >  		ti->error = "Device lookup failed";
> > > > > > diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> > > > > > index 4acf2342f7ad..f020459465bd 100644
> > > > > > --- a/drivers/md/dm-table.c
> > > > > > +++ b/drivers/md/dm-table.c
> > > > > > @@ -322,7 +322,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
> > > > > >   * device and not to touch the existing bdev field in case
> > > > > >   * it is accessed concurrently.
> > > > > >   */
> > > > > > -static int upgrade_mode(struct dm_dev_internal *dd, fmode_t new_mode,
> > > > > > +static int upgrade_mode(struct dm_dev_internal *dd, fmode_t new_mode, bool non_exclusive,
> > > > > >  			struct mapped_device *md)
> > > > > >  {
> > > > > >  	int r;
> > > > > > @@ -330,8 +330,8 @@ static int upgrade_mode(struct dm_dev_internal *dd, fmode_t new_mode,
> > > > > >  
> > > > > >  	old_dev = dd->dm_dev;
> > > > > >  
> > > > > > -	r = dm_get_table_device(md, dd->dm_dev->bdev->bd_dev,
> > > > > > -				dd->dm_dev->mode | new_mode, &new_dev);
> > > > > > +	r = dm_get_table_device(md, dd->dm_dev->bdev->bd_dev, dd->dm_dev->mode | new_mode,
> > > > > > +				non_exclusive, &new_dev);
> > > > > >  	if (r)
> > > > > >  		return r;
> > > > > >  
> > > > > > @@ -387,7 +387,8 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
> > > > > >  		if (!dd)
> > > > > >  			return -ENOMEM;
> > > > > >  
> > > > > > -		if ((r = dm_get_table_device(t->md, dev, mode, &dd->dm_dev))) {
> > > > > > +		r = dm_get_table_device(t->md, dev, mode, ti->non_exclusive, &dd->dm_dev);
> > > > > > +		if (r) {
> > > > > >  			kfree(dd);
> > > > > >  			return r;
> > > > > >  		}
> > > > > > @@ -396,8 +397,9 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
> > > > > >  		list_add(&dd->list, &t->devices);
> > > > > >  		goto out;
> > > > > >  
> > > > > > -	} else if (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) {
> > > > > > -		r = upgrade_mode(dd, mode, t->md);
> > > > > > +	} else if ((dd->dm_dev->mode != (mode | dd->dm_dev->mode)) &&
> > > > > > +		   (dd->dm_dev->non_exclusive != ti->non_exclusive)) {
> > > > > > +		r = upgrade_mode(dd, mode, ti->non_exclusive, t->md);
> > > > > >  		if (r)
> > > > > >  			return r;
> > > > > >  	}
> > > > > > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > > > > > index 00c41aa6d092..c25dcc2fdb89 100644
> > > > > > --- a/drivers/md/dm.c
> > > > > > +++ b/drivers/md/dm.c
> > > > > > @@ -1117,33 +1117,44 @@ static void close_table_device(struct table_device *td, struct mapped_device *md
> > > > > >  	if (!td->dm_dev.bdev)
> > > > > >  		return;
> > > > > >  
> > > > > > -	bd_unlink_disk_holder(td->dm_dev.bdev, dm_disk(md));
> > > > > > -	blkdev_put(td->dm_dev.bdev, td->dm_dev.mode | FMODE_EXCL);
> > > > > > +	if (td->dm_dev.non_exclusive)
> > > > > > +		blkdev_put(td->dm_dev.bdev, td->dm_dev.mode);
> > > > > > +	else {
> > > > > > +		bd_unlink_disk_holder(td->dm_dev.bdev, dm_disk(md));
> > > > > > +		blkdev_put(td->dm_dev.bdev, td->dm_dev.mode | FMODE_EXCL);
> > > > > > +	}
> > > > > > +
> > > > > > +
> > > > > > +	blkdev_put(td->dm_dev.bdev, td->dm_dev.mode);
> > > > > > +
> > > > > >  	put_dax(td->dm_dev.dax_dev);
> > > > > >  	td->dm_dev.bdev = NULL;
> > > > > >  	td->dm_dev.dax_dev = NULL;
> > > > > > +	td->dm_dev.non_exclusive = false;
> > > > > >  }
> > > > > >  
> > > > > >  static struct table_device *find_table_device(struct list_head *l, dev_t dev,
> > > > > > -					      fmode_t mode)
> > > > > > +					      fmode_t mode, bool non_exclusive)
> > > > > >  {
> > > > > >  	struct table_device *td;
> > > > > >  
> > > > > >  	list_for_each_entry(td, l, list)
> > > > > > -		if (td->dm_dev.bdev->bd_dev == dev && td->dm_dev.mode == mode)
> > > > > > +		if (td->dm_dev.bdev->bd_dev == dev &&
> > > > > > +		    td->dm_dev.mode == mode &&
> > > > > > +		    td->dm_dev.non_exclusive == non_exclusive)
> > > > > >  			return td;
> > > > > >  
> > > > > >  	return NULL;
> > > > > >  }
> > > > > >  
> > > > > > -int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode,
> > > > > > +int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode, bool non_exclusive,
> > > > > >  			struct dm_dev **result)
> > > > > >  {
> > > > > >  	int r;
> > > > > >  	struct table_device *td;
> > > > > >  
> > > > > >  	mutex_lock(&md->table_devices_lock);
> > > > > > -	td = find_table_device(&md->table_devices, dev, mode);
> > > > > > +	td = find_table_device(&md->table_devices, dev, mode, non_exclusive);
> > > > > >  	if (!td) {
> > > > > >  		td = kmalloc_node(sizeof(*td), GFP_KERNEL, md->numa_node_id);
> > > > > >  		if (!td) {
> > > > > > @@ -1154,7 +1165,8 @@ int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode,
> > > > > >  		td->dm_dev.mode = mode;
> > > > > >  		td->dm_dev.bdev = NULL;
> > > > > >  
> > > > > > -		if ((r = open_table_device(td, dev, md))) {
> > > > > > +		r = open_table_device(td, dev, md, non_exclusive);
> > > > > > +		if (r) {
> > > > > >  			mutex_unlock(&md->table_devices_lock);
> > > > > >  			kfree(td);
> > > > > >  			return r;
> > > > > > diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> > > > > > index fffe1e289c53..7bf20fb2de74 100644
> > > > > > --- a/drivers/md/dm.h
> > > > > > +++ b/drivers/md/dm.h
> > > > > > @@ -179,7 +179,7 @@ int dm_open_count(struct mapped_device *md);
> > > > > >  int dm_lock_for_deletion(struct mapped_device *md, bool mark_deferred, bool only_deferred);
> > > > > >  int dm_cancel_deferred_remove(struct mapped_device *md);
> > > > > >  int dm_request_based(struct mapped_device *md);
> > > > > > -int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode,
> > > > > > +int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode, bool non_exclusive,
> > > > > >  			struct dm_dev **result);
> > > > > >  void dm_put_table_device(struct mapped_device *md, struct dm_dev *d);
> > > > > >  
> > > > > > diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> > > > > > index 61a66fb8ebb3..70002363bfc0 100644
> > > > > > --- a/include/linux/device-mapper.h
> > > > > > +++ b/include/linux/device-mapper.h
> > > > > > @@ -150,6 +150,7 @@ struct dm_dev {
> > > > > >  	struct block_device *bdev;
> > > > > >  	struct dax_device *dax_dev;
> > > > > >  	fmode_t mode;
> > > > > > +	bool non_exclusive;
> > > > > >  	char name[16];
> > > > > >  };
> > > > > >  
> > > > > > @@ -325,6 +326,12 @@ struct dm_target {
> > > > > >  	 * whether or not its underlying devices have support.
> > > > > >  	 */
> > > > > >  	bool discards_supported:1;
> > > > > > +
> > > > > > +	/*
> > > > > > +	 * Set if this target needs to open device without FMODE_EXCL
> > > > > > +	 * mode.
> > > > > > +	 */
> > > > > > +	bool non_exclusive:1;
> > > > > >  };
> > > > > >  
> > > > > >  void *dm_per_bio_data(struct bio *bio, size_t data_size);
> > > > > > -- 
> > > > > > 2.20.1
> > > > > > 
> > > > > 
> > > > > I'm really not liking this tug-of-war about FMODE_EXCL vs not.
> > > > > Especially dislike the prospect of needing to change _every_ DM target
> > > > > that would be made to support blk_interposer.
> > > > > 
> > > > > I've said this before, private or otherwise, but: Hannes' approach that
> > > > > fell back to opening without FMODE_EXCL if FMODE_EXCL open failed.  Have
> > > > > you explored that kind of approach?
> > > > 
> > > > Of course I explored that kind of approach. The easiest thing to do
> > > > is fell back to opening without FMODE_EXCL if FMODE_EXCL open failed.
> > > > 
> > > > But I remind you once again that in this case, without changing
> > > > the code of each target, we will change the behavior of each.
> > > > Any target will open the device without the FMODE_EXCL flag if the device
> > > > is already busy. This can cause errors and cause data loss.
> > > > I would not want the device mapper to get worse when adding new functionality.
> > > 
> > > Right, but I'm not talking about a blind fallback that strips FMODE_EXCL
> > > if FMODE_EXCL open failed.
> > >  
> > > > I will do so in the next patch, as you are sure that it is better... Or
> > > > I'll think about it again and try to suggest a better implementation.
> > > > 
> > > > Thank you, Mike.
> > > > 
> > > > > 
> > > > > You _should_ be able to infer that interposer is being used given the
> > > > > requirement to use an explicit remap ioctl to establish the use of
> > > > > interposer.
> > > 
> > > I'm suggesting that open_table_device and close_table_device be made
> > > aware of the fact that they are operating on behalf of your remap ioctl
> > > (interpose).  So store state in the mapped_device that reflects a remap
> > > was used.
> > > 
> > > Still clunky but at least it confines it to an implementation detail
> > > managed by DM core rather than imposing awkward interface changes in
> > > both DM core and the DM targets.
> > > 
> > > Mike
> > > 
> > 
> > Based on your requirements, I conclude that the knowledge about the use
> > of interposer should be passed when creating target, since this is where
> > the open_table_device function is called.
> > This means that the 'noexcl' parameter is no longer needed, but will be
> > replaced with 'interposer'.
> > The ioctl is no longer needed, the target already knows that it works
> > through the interposer, and we can attach it already when creating
> > the target.
> > 
> > I like this logic, and I will implement it.
> 
> Yes, I never understood why a new ioctl was introduced.  But please be
> aware that this should _not_ be implemented in terms of each DM target
> needing to handle 'interposer' being passed as a text arg to the .ctr().
> 
> It should be an optional DM_INTERPOSER_FLAG added to DM_DEV_CREATE_CMD
> (much like optional DM_NOFLUSH_FLAG can be used with DM_DEV_SUSPEND_CMD).
> 
> Mike
> 

Hello, Mike.

I tried to do as you specified and I think I succeeded.
Before sending the next version of the patch, I would like to suggest
that you see if I am moving in the right direction.

I _attach_ the patches for the DM to the email.

The first one is nothing particularly new, I just put the code for
blk_interposer in the dm-interposer.c/.h file.

In the second one, I implemented the DM_INTERPOSED_DEV_FLAG flag.
No one of the targets were changed.

I haven't run this code yet. To do this, I need to further refine
dmsetup. This is in progress. But I think the code looks good.

-- 
Sergei Shtepa
Veeam Software developer.

--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset="utf-8"
Content-Disposition: attachment;
	filename="0004-dm-introduce-dm-interposer.patch"

>From f23ea4e073e263b6de2a0c08e7df965c26f1b3db Mon Sep 17 00:00:00 2001
From: Sergei Shtepa <sergei.shtepa@veeam.com>
Date: Tue, 23 Feb 2021 13:39:26 +0100
Subject: [PATCH 4/5] dm: introduce dm-interposer

dm-interposer.c/. h contains code for working with blk_interposer
and provides an API for interposer in device-mapper.

Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
---
 drivers/md/Makefile        |   2 +-
 drivers/md/dm-interposer.c | 250 +++++++++++++++++++++++++++++++++++++
 drivers/md/dm-interposer.h |  40 ++++++
 3 files changed, 291 insertions(+), 1 deletion(-)
 create mode 100644 drivers/md/dm-interposer.c
 create mode 100644 drivers/md/dm-interposer.h

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index ef7ddc27685c..bd5b38bee82e 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -5,7 +5,7 @@
 
 dm-mod-y	+= dm.o dm-table.o dm-target.o dm-linear.o dm-stripe.o \
 		   dm-ioctl.o dm-io.o dm-kcopyd.o dm-sysfs.o dm-stats.o \
-		   dm-rq.o
+		   dm-rq.o dm-interposer.o
 dm-multipath-y	+= dm-path-selector.o dm-mpath.o
 dm-historical-service-time-y += dm-ps-historical-service-time.o
 dm-io-affinity-y += dm-ps-io-affinity.o
diff --git a/drivers/md/dm-interposer.c b/drivers/md/dm-interposer.c
new file mode 100644
index 000000000000..f4413f0e1f82
--- /dev/null
+++ b/drivers/md/dm-interposer.c
@@ -0,0 +1,250 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bio.h>
+#include <linux/rwsem.h>
+#include <linux/refcount.h>
+#include <linux/device-mapper.h>
+#include <linux/interval_tree_generic.h>
+
+#include "dm-core.h"
+#include "dm-interposer.h"
+
+#define DM_MSG_PREFIX "interposer"
+
+struct dm_interposer {
+	struct blk_interposer blk_ip;
+
+	struct kref kref;
+	struct rw_semaphore ip_devs_lock;
+	struct rb_root_cached ip_devs_root; /* dm_interposed_dev tree */
+};
+
+/*
+ * Interval tree for device mapper
+ */
+#define START(node) ((node)->start)
+#define LAST(node) ((node)->last)
+INTERVAL_TREE_DEFINE(struct dm_rb_range, node, sector_t, _subtree_last,
+		     START, LAST,, dm_rb);
+
+static DEFINE_MUTEX(dm_interposer_attach_lock);
+
+static void dm_submit_bio_interposer_fn(struct bio *bio)
+{
+	struct dm_interposer *ip;
+	unsigned int noio_flag = 0;
+	sector_t start;
+	sector_t last;
+	struct dm_rb_range *node;
+
+	ip = container_of(bio->bi_disk->interposer, struct dm_interposer, blk_ip);
+	start = bio->bi_iter.bi_sector;
+	last = start + dm_sector_div_up(bio->bi_iter.bi_size, SECTOR_SIZE);
+
+	noio_flag = memalloc_noio_save();
+	down_read(&ip->ip_devs_lock);
+	node = dm_rb_iter_first(&ip->ip_devs_root, start, last);
+	while (node) {
+		struct dm_interposed_dev *ip_dev =
+			container_of(node, struct dm_interposed_dev, node);
+
+		atomic64_inc(&ip_dev->ip_cnt);
+		ip_dev->dm_interpose_bio(ip_dev->context, node->start, bio);
+
+		node = dm_rb_iter_next(node, start, last);
+	}
+	up_read(&ip->ip_devs_lock);
+	memalloc_noio_restore(noio_flag);
+}
+
+void dm_interposer_free(struct kref *kref)
+{
+	struct dm_interposer *ip = container_of(kref, struct dm_interposer, kref);
+
+	blk_interposer_detach(&ip->blk_ip, dm_submit_bio_interposer_fn);
+
+	kfree(ip);
+}
+
+struct dm_interposer *dm_interposer_new(struct gendisk *disk)
+{
+	int ret = 0;
+	struct dm_interposer *ip;
+
+	ip = kzalloc(sizeof(struct dm_interposer), GFP_NOIO);
+	if (!ip)
+		return ERR_PTR(-ENOMEM);
+
+	kref_init(&ip->kref);
+	init_rwsem(&ip->ip_devs_lock);
+	ip->ip_devs_root = RB_ROOT_CACHED;
+
+	ret = blk_interposer_attach(disk, &ip->blk_ip, dm_submit_bio_interposer_fn);
+	if (ret) {
+		DMERR("Failed to attack blk_interposer.");
+		kref_put(&ip->kref, dm_interposer_free);
+		return ERR_PTR(ret);
+	}
+
+	return ip;
+}
+
+static struct dm_interposer *dm_interposer_get(struct gendisk *disk)
+{
+	struct dm_interposer *ip;
+
+	if (!blk_has_interposer(disk))
+		return NULL;
+
+	if (disk->interposer->ip_submit_bio != dm_submit_bio_interposer_fn) {
+		DMERR("Disks interposer slot already occupied.");
+		return ERR_PTR(-EBUSY);
+	}
+
+	ip = container_of(disk->interposer, struct dm_interposer, blk_ip);
+
+	kref_get(&ip->kref);
+	return ip;
+}
+
+static inline void dm_disk_freeze(struct gendisk *disk)
+{
+	blk_mq_freeze_queue(disk->queue);
+	blk_mq_quiesce_queue(disk->queue);
+}
+
+static inline void dm_disk_unfreeze(struct gendisk *disk)
+{
+	blk_mq_unquiesce_queue(disk->queue);
+	blk_mq_unfreeze_queue(disk->queue);
+}
+
+/**
+ * dm_interposer_dev_init - initialize interposed device
+ * @ip_dev: interposed device
+ * @disk: disk for interposing
+ * @ofs: offset from the beginning of the disk
+ * @len: the length of the part of the disk to which requests will be interposed
+ * @context: parameter for interposing callback
+ * @interpose_fn: interposing callback
+ */
+void dm_interposer_dev_init(struct dm_interposed_dev *ip_dev,
+			    struct gendisk *disk, sector_t ofs, sector_t len,
+			    void *context, dm_interpose_bio_t interpose_fn)
+{
+	ip_dev->disk = disk;
+	ip_dev->node.start = ofs;
+	ip_dev->node.last = ofs + len - 1;
+	ip_dev->context = context;
+	ip_dev->dm_interpose_bio = interpose_fn;
+
+	atomic64_set(&ip_dev->ip_cnt, 0);
+}
+
+/**
+ * dm_interposer_dev_attach - attach interposed device to his disk
+ * @ip_dev: interposed device
+ *
+ * Return error code.
+ */
+int dm_interposer_dev_attach(struct dm_interposed_dev *ip_dev)
+{
+	int ret = 0;
+	struct dm_interposer *ip = NULL;
+	unsigned int noio_flag = 0;
+
+	if (!ip_dev)
+		return -EINVAL;
+
+	dm_disk_freeze(ip_dev->disk);
+	mutex_lock(&dm_interposer_attach_lock);
+	noio_flag = memalloc_noio_save();
+
+	ip = dm_interposer_get(ip_dev->disk);
+	if (ip == NULL)
+		ip = dm_interposer_new(ip_dev->disk);
+	if (IS_ERR(ip)) {
+		ret = PTR_ERR(ip);
+		goto out;
+	}
+
+	/* Attach dm_interposed_dev to dm_interposer */
+	down_write(&ip->ip_devs_lock);
+	do {
+		struct dm_rb_range *node;
+
+		/* checking that ip_dev already exists for this region */
+		node = dm_rb_iter_first(&ip->ip_devs_root, ip_dev->node.start, ip_dev->node.last);
+		if (node) {
+			DMERR("Disk part form [%llu] to [%llu] already have interposer.",
+			      node->start, node->last);
+
+			ret = -EBUSY;
+			break;
+		}
+
+		/* insert ip_dev to ip tree */
+		dm_rb_insert(&ip_dev->node, &ip->ip_devs_root);
+		/* increment ip reference counter */
+		kref_get(&ip->kref);
+	} while (false);
+	up_write(&ip->ip_devs_lock);
+
+	kref_put(&ip->kref, dm_interposer_free);
+
+out:
+	memalloc_noio_restore(noio_flag);
+	mutex_unlock(&dm_interposer_attach_lock);
+	dm_disk_unfreeze(ip_dev->disk);
+
+	return ret;
+}
+
+/**
+ * dm_interposer_detach_dev - detach interposed device from his disk
+ * @ip_dev: interposed device
+ *
+ * Return error code.
+ */
+int dm_interposer_detach_dev(struct dm_interposed_dev *ip_dev)
+{
+	int ret = 0;
+	struct dm_interposer *ip = NULL;
+	unsigned int noio_flag = 0;
+
+	if (!ip_dev)
+		return -EINVAL;
+
+	dm_disk_freeze(ip_dev->disk);
+	mutex_lock(&dm_interposer_attach_lock);
+	noio_flag = memalloc_noio_save();
+
+	ip = dm_interposer_get(ip_dev->disk);
+	if (IS_ERR(ip)) {
+		ret = PTR_ERR(ip);
+		DMERR("Interposer not found.");
+		goto out;
+	}
+	if (unlikely(ip == NULL)) {
+		ret = -ENXIO;
+		DMERR("Interposer not found.");
+		goto out;
+	}
+
+	down_write(&ip->ip_devs_lock);
+	do {
+		dm_rb_remove(&ip_dev->node, &ip->ip_devs_root);
+		/* the reference counter here cannot be zero */
+		kref_put(&ip->kref, dm_interposer_free);
+
+	} while (false);
+	up_write(&ip->ip_devs_lock);
+
+	/* detach and free interposer if it's not needed */
+	kref_put(&ip->kref, dm_interposer_free);
+out:
+	memalloc_noio_restore(noio_flag);
+	mutex_unlock(&dm_interposer_attach_lock);
+	dm_disk_unfreeze(ip_dev->disk);
+
+	return ret;
+}
diff --git a/drivers/md/dm-interposer.h b/drivers/md/dm-interposer.h
new file mode 100644
index 000000000000..77333dc35a47
--- /dev/null
+++ b/drivers/md/dm-interposer.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Device mapper's interposer.
+ */
+
+#include <linux/rbtree.h>
+
+struct dm_rb_range {
+	struct rb_node node;
+	sector_t start;		/* start sector of rb node */
+	sector_t last;		/* end sector of rb node */
+	sector_t _subtree_last; /* highest sector in subtree of rb node */
+};
+
+typedef void (*dm_interpose_bio_t) (void *context, sector_t start_sect,  struct bio *bio);
+
+struct dm_interposed_dev {
+	struct gendisk *disk;
+	struct dm_rb_range node;
+	void *context;
+	dm_interpose_bio_t dm_interpose_bio;
+
+	atomic64_t ip_cnt; /* for debug purpose only */
+};
+
+/*
+ * Just initialize structure dm_interposed_dev.
+ */
+void dm_interposer_dev_init(struct dm_interposed_dev *ip_dev,
+			    struct gendisk *disk, sector_t ofs, sector_t len,
+			    void *context, dm_interpose_bio_t interpose_fn);
+
+/*
+ * Attach interposer to his disk.
+ */
+int dm_interposer_dev_attach(struct dm_interposed_dev *ip_dev);
+/*
+ * Detach interposer from his disk.
+ */
+int dm_interposer_detach_dev(struct dm_interposed_dev *ip_dev);
-- 
2.20.1


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset="utf-8"
Content-Disposition: attachment;
	filename="0005-dm-new-DM_INTERPOSED_DEV_FLAG.patch"

>From 3d393e8a8d386c009a9b37e5bc40f66cd997c8bd Mon Sep 17 00:00:00 2001
From: Sergei Shtepa <sergei.shtepa@veeam.com>
Date: Tue, 23 Feb 2021 13:46:19 +0100
Subject: [PATCH 5/5] dm: new DM_INTERPOSED_DEV_FLAG

DM_INTERPOSED_DEV_FLAG allow to open underlying device without
FMODE_EXCL flag and create md device "on fly".

Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
---
 drivers/md/dm-core.h          |   6 ++
 drivers/md/dm-ioctl.c         |   9 +++
 drivers/md/dm-table.c         | 104 +++++++++++++++++++++++++++++++---
 drivers/md/dm.c               |  38 +++++++++----
 include/linux/device-mapper.h |   1 +
 include/uapi/linux/dm-ioctl.h |   2 +
 6 files changed, 139 insertions(+), 21 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 086d293c2b03..00fad638469f 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -20,6 +20,8 @@
 
 #define DM_RESERVED_MAX_IOS		1024
 
+struct dm_interposed_dev;
+
 struct dm_kobject_holder {
 	struct kobject kobj;
 	struct completion completion;
@@ -109,6 +111,10 @@ struct mapped_device {
 	bool init_tio_pdu:1;
 
 	struct srcu_struct io_barrier;
+
+	/* for interposers logic */
+	bool is_interposed;
+	struct dm_interposed_dev *ip_dev;
 };
 
 void disable_discard(struct mapped_device *md);
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 5e306bba4375..a7be745a6f2c 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1267,6 +1267,11 @@ static inline fmode_t get_mode(struct dm_ioctl *param)
 	return mode;
 }
 
+static inline bool get_interposer_flag(struct dm_ioctl *param)
+{
+	return (param->flags & DM_INTERPOSED_DEV_FLAG);
+}
+
 static int next_target(struct dm_target_spec *last, uint32_t next, void *end,
 		       struct dm_target_spec **spec, char **target_params)
 {
@@ -1338,6 +1343,8 @@ static int table_load(struct file *filp, struct dm_ioctl *param, size_t param_si
 	if (!md)
 		return -ENXIO;
 
+	md->is_interposed = get_interposer_flag(param);
+
 	r = dm_table_create(&t, get_mode(param), param->target_count, md);
 	if (r)
 		goto err;
@@ -2098,6 +2105,8 @@ int __init dm_early_create(struct dm_ioctl *dmi,
 	if (r)
 		goto err_hash_remove;
 
+	md->is_interposed = get_interposer_flag(dmi);
+
 	/* add targets */
 	for (i = 0; i < dmi->target_count; i++) {
 		r = dm_table_add_target(t, spec_array[i]->target_type,
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 4acf2342f7ad..2d8109876706 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -6,6 +6,7 @@
  */
 
 #include "dm-core.h"
+#include "dm-interposer.h"
 
 #include <linux/module.h>
 #include <linux/vmalloc.h>
@@ -221,12 +222,13 @@ void dm_table_destroy(struct dm_table *t)
 /*
  * See if we've already got a device in the list.
  */
-static struct dm_dev_internal *find_device(struct list_head *l, dev_t dev)
+static struct dm_dev_internal *find_device(struct list_head *l, dev_t dev, bool is_interposed)
 {
 	struct dm_dev_internal *dd;
 
 	list_for_each_entry (dd, l, list)
-		if (dd->dm_dev->bdev->bd_dev == dev)
+		if ((dd->dm_dev->bdev->bd_dev == dev) &&
+		    (dd->dm_dev->is_interposed == is_interposed))
 			return dd;
 
 	return NULL;
@@ -354,6 +356,79 @@ dev_t dm_get_dev_t(const char *path)
 }
 EXPORT_SYMBOL_GPL(dm_get_dev_t);
 
+/*
+ * Redirect bio from interposed device to dm device
+ */
+static void dm_interpose_fn(void *context, sector_t start_sect, struct bio *bio)
+{
+	struct mapped_device *md = context;
+
+	/* Set acceptor device.
+	 * dm devices have only one block device on disk.
+	 * So we can redirect directly to its disk without
+	 * calculating dm block device offset.
+	 */
+	bio->bi_disk = md->disk;
+
+	/* Remap disks offset */
+	bio->bi_iter.bi_sector -= start_sect;
+
+	/*
+	 * bio should be resubmitted.
+	 * We can just add bio to bio_list of the current process.
+	 * current->bio_list must be initialized when this function is called.
+	 * If call submit_bio_noacct(), the bio will be checked twice.
+	 */
+	BUG_ON(!current->bio_list);
+	bio_list_add(&current->bio_list[0], bio);
+}
+
+static int _interposer_dev_create(struct block_device *bdev, sector_t ofs, sector_t len,
+				  struct mapped_device *md)
+{
+	int ret;
+
+	DMDEBUG("Create dm interposer.");
+
+	if (md->ip_dev)
+		return -EALREADY;
+
+	if ((ofs + len) > bdev_nr_sectors(bdev))
+		return -ERANGE;
+
+	md->ip_dev = kzalloc(sizeof(struct dm_interposed_dev), GFP_KERNEL);
+	if (!md->ip_dev)
+		return -ENOMEM;
+
+	dm_interposer_dev_init(md->ip_dev, bdev->bd_disk,
+			       get_start_sect(bdev) + ofs, len,
+			       md, dm_interpose_fn);
+
+	ret = dm_interposer_dev_attach(md->ip_dev);
+	if (ret) {
+		DMERR("Failed to attach dm interposer.");
+		kfree(md->ip_dev);
+		md->ip_dev = NULL;
+	}
+
+	return ret;
+}
+
+static void _interposer_dev_remove(struct mapped_device *md)
+{
+	if (!md->ip_dev)
+		return;
+
+	DMDEBUG("Remove dm interposer. %llu bios was interposed.",
+		atomic64_read(&md->ip_dev->ip_cnt));
+
+	if (dm_interposer_detach_dev(md->ip_dev))
+		DMERR("Failed to detach dm interposer.");
+
+	kfree(md->ip_dev);
+	md->ip_dev = NULL;
+}
+
 /*
  * Add a device to the list, or just increment the usage count if
  * it's already present.
@@ -381,7 +456,7 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 			return -ENODEV;
 	}
 
-	dd = find_device(&t->devices, dev);
+	dd = find_device(&t->devices, dev, t->md->is_interposed);
 	if (!dd) {
 		dd = kmalloc(sizeof(*dd), GFP_KERNEL);
 		if (!dd)
@@ -394,15 +469,22 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 
 		refcount_set(&dd->count, 1);
 		list_add(&dd->list, &t->devices);
-		goto out;
-
 	} else if (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) {
 		r = upgrade_mode(dd, mode, t->md);
 		if (r)
 			return r;
+		refcount_inc(&dd->count);
 	}
-	refcount_inc(&dd->count);
-out:
+
+	if (t->md->is_interposed) {
+		r = _interposer_dev_create(dd->dm_dev->bdev, ti->begin, ti->len, t->md);
+		if (r) {
+			dm_put_device(ti, dd->dm_dev);
+			DMERR("Failed to attach dm interposer.");
+			return r;
+		}
+	}
+
 	*result = dd->dm_dev;
 	return 0;
 }
@@ -442,6 +524,7 @@ void dm_put_device(struct dm_target *ti, struct dm_dev *d)
 {
 	int found = 0;
 	struct list_head *devices = &ti->table->devices;
+	struct mapped_device *md = ti->table->md;
 	struct dm_dev_internal *dd;
 
 	list_for_each_entry(dd, devices, list) {
@@ -452,11 +535,14 @@ void dm_put_device(struct dm_target *ti, struct dm_dev *d)
 	}
 	if (!found) {
 		DMWARN("%s: device %s not in table devices list",
-		       dm_device_name(ti->table->md), d->name);
+		       dm_device_name(md), d->name);
 		return;
 	}
+	if (md->is_interposed)
+		_interposer_dev_remove(md);
+
 	if (refcount_dec_and_test(&dd->count)) {
-		dm_put_table_device(ti->table->md, d);
+		dm_put_table_device(md, d);
 		list_del(&dd->list);
 		kfree(dd);
 	}
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7bac564f3faa..f95226b50fed 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -747,16 +747,24 @@ static int open_table_device(struct table_device *td, dev_t dev,
 
 	BUG_ON(td->dm_dev.bdev);
 
-	bdev = blkdev_get_by_dev(dev, td->dm_dev.mode | FMODE_EXCL, _dm_claim_ptr);
-	if (IS_ERR(bdev))
-		return PTR_ERR(bdev);
+	if (md->is_interposed) {
 
-	r = bd_link_disk_holder(bdev, dm_disk(md));
-	if (r) {
-		blkdev_put(bdev, td->dm_dev.mode | FMODE_EXCL);
-		return r;
+		bdev = blkdev_get_by_dev(dev, td->dm_dev.mode, NULL);
+		if (IS_ERR(bdev))
+			return PTR_ERR(bdev);
+	} else {
+		bdev = blkdev_get_by_dev(dev, td->dm_dev.mode | FMODE_EXCL, _dm_claim_ptr);
+		if (IS_ERR(bdev))
+			return PTR_ERR(bdev);
+
+		r = bd_link_disk_holder(bdev, dm_disk(md));
+		if (r) {
+			blkdev_put(bdev, td->dm_dev.mode | FMODE_EXCL);
+			return r;
+		}
 	}
 
+	td->dm_dev.is_interposed = md->is_interposed;
 	td->dm_dev.bdev = bdev;
 	td->dm_dev.dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
 	return 0;
@@ -770,20 +778,26 @@ static void close_table_device(struct table_device *td, struct mapped_device *md
 	if (!td->dm_dev.bdev)
 		return;
 
-	bd_unlink_disk_holder(td->dm_dev.bdev, dm_disk(md));
-	blkdev_put(td->dm_dev.bdev, td->dm_dev.mode | FMODE_EXCL);
+	if (td->dm_dev.is_interposed)
+		blkdev_put(td->dm_dev.bdev, td->dm_dev.mode);
+	else {
+		bd_unlink_disk_holder(td->dm_dev.bdev, dm_disk(md));
+		blkdev_put(td->dm_dev.bdev, td->dm_dev.mode | FMODE_EXCL);
+	}
 	put_dax(td->dm_dev.dax_dev);
 	td->dm_dev.bdev = NULL;
 	td->dm_dev.dax_dev = NULL;
 }
 
 static struct table_device *find_table_device(struct list_head *l, dev_t dev,
-					      fmode_t mode)
+					      fmode_t mode, bool is_interposed)
 {
 	struct table_device *td;
 
 	list_for_each_entry(td, l, list)
-		if (td->dm_dev.bdev->bd_dev == dev && td->dm_dev.mode == mode)
+		if (td->dm_dev.bdev->bd_dev == dev &&
+		    td->dm_dev.mode == mode &&
+		    td->dm_dev.is_interposed == is_interposed)
 			return td;
 
 	return NULL;
@@ -796,7 +810,7 @@ int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode,
 	struct table_device *td;
 
 	mutex_lock(&md->table_devices_lock);
-	td = find_table_device(&md->table_devices, dev, mode);
+	td = find_table_device(&md->table_devices, dev, mode, md->is_interposed);
 	if (!td) {
 		td = kmalloc_node(sizeof(*td), GFP_KERNEL, md->numa_node_id);
 		if (!td) {
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 61a66fb8ebb3..c264b6beb12b 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -150,6 +150,7 @@ struct dm_dev {
 	struct block_device *bdev;
 	struct dax_device *dax_dev;
 	fmode_t mode;
+	bool is_interposed;
 	char name[16];
 };
 
diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
index 4933b6b67b85..033a84a9b0b7 100644
--- a/include/uapi/linux/dm-ioctl.h
+++ b/include/uapi/linux/dm-ioctl.h
@@ -362,4 +362,6 @@ enum {
  */
 #define DM_INTERNAL_SUSPEND_FLAG	(1 << 18) /* Out */
 
+#define DM_INTERPOSED_DEV_FLAG		(1 << 19) /* In */
+
 #endif				/* _LINUX_DM_IOCTL_H */
-- 
2.20.1


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--FL5UXtIhxfXey3p5--

