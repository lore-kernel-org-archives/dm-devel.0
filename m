Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 327ECC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 28 Apr 2022 17:34:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-8_hmFrI3PVSxUv5SdXqg_g-1; Thu, 28 Apr 2022 13:34:43 -0400
X-MC-Unique: 8_hmFrI3PVSxUv5SdXqg_g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 434AD101AA42;
	Thu, 28 Apr 2022 17:34:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 504BF7C55;
	Thu, 28 Apr 2022 17:34:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0F6871947046;
	Thu, 28 Apr 2022 17:34:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 80C4C19466DF
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Apr 2022 17:34:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5ED252024CCC; Thu, 28 Apr 2022 17:34:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A474200C0F3
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 17:34:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C717811E81
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 17:34:33 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-450-Ie6W5OLXPSSnwB0-J1pYZw-1; Thu, 28 Apr 2022 13:34:29 -0400
X-MC-Unique: Ie6W5OLXPSSnwB0-J1pYZw-1
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2
 (Red Hat Linux)) id 1nk81u-0083c3-7l; Thu, 28 Apr 2022 17:34:14 +0000
Date: Thu, 28 Apr 2022 10:34:14 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Message-ID: <YmrQFu9EbMmrL2Ys@bombadil.infradead.org>
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160313eucas1p1feecf74ec15c8c3d9250444710fd1676@eucas1p1.samsung.com>
 <20220427160255.300418-17-p.raghav@samsung.com>
 <2ffc46c7-945f-ba26-90db-737fccd74fdf@opensource.wdc.com>
MIME-Version: 1.0
In-Reply-To: <2ffc46c7-945f-ba26-90db-737fccd74fdf@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 16/16] dm-zoned: ensure only power of 2 zone
 sizes are allowed
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
Cc: jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org, clm@fb.com,
 dm-devel@redhat.com, hch@lst.de, agk@redhat.com, naohiro.aota@wdc.com,
 sagi@grimberg.me, gost.dev@samsung.com, jonathan.derrick@linux.dev,
 Pankaj Raghav <p.raghav@samsung.com>, kch@nvidia.com, chao@kernel.org,
 snitzer@kernel.org, josef@toxicpanda.com, linux-block@vger.kernel.org,
 dsterba@suse.com, kbusch@kernel.org, jaegeuk@kernel.org,
 matias.bjorling@wdc.com, bvanassche@acm.org, axboe@kernel.dk,
 johannes.thumshirn@wdc.com, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Apr 28, 2022 at 08:42:41AM +0900, Damien Le Moal wrote:
> On 4/28/22 01:02, Pankaj Raghav wrote:
> > From: Luis Chamberlain <mcgrof@kernel.org>
> > 
> > Today dm-zoned relies on the assumption that you have a zone size
> > with a power of 2. Even though the block layer today enforces this
> > requirement, these devices do exist and so provide a stop-gap measure
> > to ensure these devices cannot be used by mistake
> > 
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> > ---
> >  drivers/md/dm-zone.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> > index 57daa86c19cf..221e0aa0f1a7 100644
> > --- a/drivers/md/dm-zone.c
> > +++ b/drivers/md/dm-zone.c
> > @@ -231,6 +231,18 @@ static int dm_revalidate_zones(struct mapped_device *md, struct dm_table *t)
> >  	struct request_queue *q = md->queue;
> >  	unsigned int noio_flag;
> >  	int ret;
> > +	struct block_device *bdev = md->disk->part0;
> > +	sector_t zone_sectors;
> > +	char bname[BDEVNAME_SIZE];
> > +
> > +	zone_sectors = bdev_zone_sectors(bdev);
> > +
> > +	if (!is_power_of_2(zone_sectors)) {
> > +		DMWARN("%s: %s only power of two zone size supported\n",
> > +		       dm_device_name(md),
> > +		       bdevname(bdev, bname));
> > +		return 1;
> > +	}
> 
> Why ?
> 
> See my previous email about still allowing ZC < ZS for non power of 2 zone
> size drives. dm-zoned can easily support non power of 2 zone size as long
> as ZC == ZS for all zones.

Great, thanks for the heads up.

> The problem with dm-zoned is ZC < ZS *AND* potentially variable ZC per
> zone. That cannot be supported easily (still not impossible, but
> definitely a lot more complex).

I see thanks.

Testing would still be required to ensure this all works well with npo2.
So I'd prefer to do that as a separate effort, even if it is easy. So
for now I think it makes sense to avoid this as this is not yet well
tested.

As with filesystem support, we've even have gotten hints that support
for npo2 should be easy, but without proper testing it would not be
prudent to enable support for users yet.

One step at a time.

  Luis

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

