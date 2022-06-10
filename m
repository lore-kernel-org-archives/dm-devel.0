Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03ACEC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 10 Jun 2022 18:56:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-GT8AEGKPNNKd-ZUIEvkOVw-1; Fri, 10 Jun 2022 14:56:34 -0400
X-MC-Unique: GT8AEGKPNNKd-ZUIEvkOVw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E13A4802804;
	Fri, 10 Jun 2022 18:56:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 391A8492C3B;
	Fri, 10 Jun 2022 18:56:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DB3B31947055;
	Fri, 10 Jun 2022 18:56:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C890E1947054
 for <dm-devel@listman.corp.redhat.com>; Fri, 10 Jun 2022 18:56:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8C2A21121319; Fri, 10 Jun 2022 18:56:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 883E61121314
 for <dm-devel@redhat.com>; Fri, 10 Jun 2022 18:56:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CF56811E7A
 for <dm-devel@redhat.com>; Fri, 10 Jun 2022 18:56:29 +0000 (UTC)
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com
 [209.85.160.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-508-8fb_RGqnP7WTlZ71HFzOFA-1; Fri, 10 Jun 2022 14:56:27 -0400
X-MC-Unique: 8fb_RGqnP7WTlZ71HFzOFA-1
Received: by mail-qt1-f174.google.com with SMTP id f13so2066qtb.5
 for <dm-devel@redhat.com>; Fri, 10 Jun 2022 11:56:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=OvHTHLkhrUIWEvLDS0A9yBAIxMsiXZxW5mBwv3CZzSo=;
 b=3OcyyaZtHq0NhNG9Fs+/dmVVv5bBQf0x9CNWPfWQlx/realkU3+CPK5dPbeplwNayw
 xVL0d2sSR24Z4q3GFRT3Emw5YnLV/TA7Bvr92alja34nvVlcVnVqcwsgj1mM7YZQqu6Z
 hi5hMmLZrJ0AvsxYDu4tLPNmQW/qOkqdGa9i1GEHTgmSBApGtvI+e8rPk8gyvMY5FPg8
 GOL02xO8IkXO+xfEFvjBmZSGhz4jnMXdE/eGTO7eVg9/xNCNFlxqWooN/343V+RBj6GB
 jD+kLdJ95rtBmXQBmsNJ6SL0PRQjf4yXYARCgwauuTh1Y5EbpvkCxrtDv2tYykcyP4YQ
 5ohw==
X-Gm-Message-State: AOAM533xuNhMGemDnbWOA2ofGkJQJtV/DVf/KznoUEfmv+OetIpoWxZX
 xW/tvofgEer1m+4kuIXSs1ecqnM=
X-Google-Smtp-Source: ABdhPJyd97sX7qPx1H39m7yLOxF3pvcBOTKsn0CW78R+DHz88Sv/pd2uXSh+4AjjxRjLX/BDeatMDA==
X-Received: by 2002:a05:622a:13d0:b0:305:11b9:b53 with SMTP id
 p16-20020a05622a13d000b0030511b90b53mr7402132qtk.348.1654887387296; 
 Fri, 10 Jun 2022 11:56:27 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 de37-20020a05620a372500b006a71729a139sm175233qkb.44.2022.06.10.11.56.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 10 Jun 2022 11:56:26 -0700 (PDT)
Date: Fri, 10 Jun 2022 14:56:25 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Message-ID: <YqOT2QGR5YaZQyIb@redhat.com>
References: <20220609114300.453650-1-shinichiro.kawasaki@wdc.com>
 <YqNwqGeI/4sy9zn1@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YqNwqGeI/4sy9zn1@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] dm crypt: set bdev to clone bio
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
Cc: dm-devel@redhat.com, Damien Le Moal <damien.lemoal@opensource.wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jun 10 2022 at 12:26P -0400,
Mike Snitzer <snitzer@kernel.org> wrote:

> On Thu, Jun 09 2022 at  7:43P -0400,
> Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com> wrote:
> 
> > After the commit ca522482e3ea ("dm: pass NULL bdev to bio_alloc_clone"),
> > bdev is no longer set to clone bio for ->map function. Instead, each DM
> > targets shall set bdev to the clone bio by calling bio_set_dev() before
> > issuing IO. Also the commit ensured that dm_zone_endio() is called from
> > clone_endio() only when DM targets set bdev to the clone bio.
> > 
> > However, crypt_map() of dm-crypt does not call bio_set_dev() for every
> > clone bio. Then dm_zone_endio() is not called at completion of the bios
> > and zone locks are not properly unlocked. This triggers a hang when
> > blktests block/004 is run for dm-crypt on zoned block devices [1]. To
> > avoid the hang, call bio_set_dev() for every bio in crypt_map().
> > 
> > [1]
> > 
> > [ 6596.702977][T55017] run blktests block/004 at 2022-06-07 20:18:01
> 
> <snip>
> 
> Please refrain from putting stack traces in patch headers whenever
> possible.  Really no need for this, especially given how long this one
> is!
> 
> I revised the header as follows:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.19&id=cae0053631cd4b02bb882b53c7da20652b038049
>  
> > Fixes: ca522482e3ea ("dm: pass NULL bdev to bio_alloc_clone")
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >  drivers/md/dm-crypt.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> > index 159c6806c19b..c68523a89428 100644
> > --- a/drivers/md/dm-crypt.c
> > +++ b/drivers/md/dm-crypt.c
> > @@ -3378,6 +3378,8 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
> >  	struct dm_crypt_io *io;
> >  	struct crypt_config *cc = ti->private;
> >  
> > +	bio_set_dev(bio, cc->dev->bdev);
> > +
> >  	/*
> >  	 * If bio is REQ_PREFLUSH or REQ_OP_DISCARD, just bypass crypt queues.
> >  	 * - for REQ_PREFLUSH device-mapper core ensures that no IO is in-flight
> > @@ -3385,7 +3387,6 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
> >  	 */
> >  	if (unlikely(bio->bi_opf & REQ_PREFLUSH ||
> >  	    bio_op(bio) == REQ_OP_DISCARD)) {
> > -		bio_set_dev(bio, cc->dev->bdev);
> >  		if (bio_sectors(bio))
> >  			bio->bi_iter.bi_sector = cc->start +
> >  				dm_target_offset(ti, bio->bi_iter.bi_sector);
> > -- 
> > 2.36.1
> > 
> 
> BUT something isn't quite adding up with why you need this change
> given commit ca522482e3ea has this compatibility code:
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 9650ba2075b8..d62f1354ecbf 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -581,7 +581,9 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
>         struct dm_target_io *tio;
>         struct bio *clone;
> 
> -       clone = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOIO, &md->io_bs);
> +       clone = bio_alloc_clone(NULL, bio, GFP_NOIO, &md->io_bs);
> +       /* Set default bdev, but target must bio_set_dev() before issuing IO */
> +       clone->bi_bdev = md->disk->part0;
> 
>         tio = clone_to_tio(clone);
>         tio->flags = 0;
> 
> The clone bio passed to crypt_map() _should_ be the same as was passed
> before commit ca522482e3ea (It gets set to md->disk->part0 rather than
> bio->bi_bdev but they really should point to the same top-level DM
> bdev).
> 
> So why is your extra override to have dm-crypt point to its underlying
> data device important now?

Think the issue is not that the clone->bi_bdev isn't set.  It is that
it is merely not changed from the md->disk->part0 default.

Commit ca522482e3ea added this to clone_endio:

if (likely(bio->bi_bdev != md->disk->part0)) {
      ...
      if (static_branch_unlikely(&zoned_enabled) &&
	  unlikely(blk_queue_is_zoned(q)))
	      dm_zone_endio(io, bio);
}

So dm_zone_endio() isn't called unless you force dm-crypt (or any
other target) to remap the clone bio to a different bdev.

It is weird that a bio is completing without having been remapped by
dm-crypt; but there could be any number of reasons why that hasn't
happened.

Anyway, I think a correct fix needs to be to the logic in
clone_endio().  Could be that its best to just remove the gating
likely() conditional.

Can you please test this patch instead of your patch?

Thanks,
Mike

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8b21155d3c4f..d8f16183bf27 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1016,23 +1016,19 @@ static void clone_endio(struct bio *bio)
 	struct dm_io *io = tio->io;
 	struct mapped_device *md = io->md;
 
-	if (likely(bio->bi_bdev != md->disk->part0)) {
-		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
-
-		if (unlikely(error == BLK_STS_TARGET)) {
-			if (bio_op(bio) == REQ_OP_DISCARD &&
-			    !bdev_max_discard_sectors(bio->bi_bdev))
-				disable_discard(md);
-			else if (bio_op(bio) == REQ_OP_WRITE_ZEROES &&
-				 !q->limits.max_write_zeroes_sectors)
-				disable_write_zeroes(md);
-		}
-
-		if (static_branch_unlikely(&zoned_enabled) &&
-		    unlikely(blk_queue_is_zoned(q)))
-			dm_zone_endio(io, bio);
+	if (unlikely(error == BLK_STS_TARGET)) {
+		if (bio_op(bio) == REQ_OP_DISCARD &&
+		    !bdev_max_discard_sectors(bio->bi_bdev))
+			disable_discard(md);
+		else if (bio_op(bio) == REQ_OP_WRITE_ZEROES &&
+			 !bdev_write_zeroes_sectors(bio->bi_bdev))
+			disable_write_zeroes(md);
 	}
 
+	if (static_branch_unlikely(&zoned_enabled) &&
+	    unlikely(blk_queue_is_zoned(bdev_get_queue(bio->bi_bdev))))
+		dm_zone_endio(io, bio);
+
 	if (endio) {
 		int r = endio(ti, bio, &error);
 		switch (r) {

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

