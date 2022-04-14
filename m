Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3FC1C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 03:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649908704;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NyPhjHwL6kjE9Rv14ZYXkwGVl5sRL2q4zEqao6mReLI=;
	b=P7nOu+tZ1Ppv1Xx0ElP1NLxKNx3IH6PsZCg4x7dE7AzCsWveaLvy354euzcZEG5F7zbzMN
	7xl9QQOyrIsB4ep+lMXXqfdqjscwGc6FUok43pv6J5SwDe3fjs60beXGqgKC4AOxqKjBbV
	gQjp83y7HwEivlZ7IHwVP0DHPoaggSw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-18-2ZztMVG5OhG3lPQaa0Cqpw-1; Wed, 13 Apr 2022 23:58:21 -0400
X-MC-Unique: 2ZztMVG5OhG3lPQaa0Cqpw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 558E3811E76;
	Thu, 14 Apr 2022 03:58:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B785740CF8F7;
	Thu, 14 Apr 2022 03:58:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 724281940345;
	Thu, 14 Apr 2022 03:58:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 960D41940344
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 03:58:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 676CE2166BA4; Thu, 14 Apr 2022 03:58:16 +0000 (UTC)
Received: from T590 (ovpn-8-18.pek2.redhat.com [10.72.8.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E8E912166B4F;
 Thu, 14 Apr 2022 03:57:59 +0000 (UTC)
Date: Thu, 14 Apr 2022 11:57:54 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <YlebwjTKH2MU9tCD@T590>
References: <20220412085616.1409626-1-ming.lei@redhat.com>
 <20220412085616.1409626-6-ming.lei@redhat.com>
 <YlXmmB6IO7usz2c1@redhat.com> <YlYt2rzM0NBPARVp@T590>
 <YlZp3+VrP930VjIQ@redhat.com> <YlbBf0mJa/BPHSSq@T590>
 <YlcPXslr6Y7cHOSU@redhat.com> <Yldsqh2YsclXYl3s@T590>
 <YleGKbZiHeBIJidI@redhat.com>
MIME-Version: 1.0
In-Reply-To: <YleGKbZiHeBIJidI@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 5/8] dm: always setup ->orig_bio in alloc_io
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Damien Le Moal <damien.lemoal@opensource.wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Apr 13, 2022 at 10:25:45PM -0400, Mike Snitzer wrote:
> On Wed, Apr 13 2022 at  8:36P -0400,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
> > On Wed, Apr 13, 2022 at 01:58:54PM -0400, Mike Snitzer wrote:
> > > 
> > > The bigger issue with this patch is that you've caused
> > > dm_submit_bio_remap() to go back to accounting the entire original bio
> > > before any split occurs.  That is a problem because you'll end up
> > > accounting that bio for every split, so in split heavy workloads the
> > > IO accounting won't reflect when the IO is actually issued and we'll
> > > regress back to having very inaccurate and incorrect IO accounting for
> > > dm_submit_bio_remap() heavy targets (e.g. dm-crypt).
> > 
> > Good catch, but we know the length of mapped part in original bio before
> > calling __map_bio(), so io->sectors/io->offset_sector can be setup here,
> > something like the following delta change should address it:
> > 
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index db23efd6bbf6..06b554f3104b 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -1558,6 +1558,13 @@ static int __split_and_process_bio(struct clone_info *ci)
> >  
> >  	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
> >  	clone = alloc_tio(ci, ti, 0, &len, GFP_NOIO);
> > +
> > +	if (ci->sector_count > len) {
> > +		/* setup the mapped part for accounting */
> > +		dm_io_set_flag(ci->io, DM_IO_SPLITTED);
> > +		ci->io->sectors = len;
> > +		ci->io->sector_offset = bio_end_sector(ci->bio) - ci->sector;
> > +	}
> >  	__map_bio(clone);
> >  
> >  	ci->sector += len;
> > @@ -1603,11 +1610,6 @@ static void dm_split_and_process_bio(struct mapped_device *md,
> >  	if (error || !ci.sector_count)
> >  		goto out;
> >  
> > -	/* setup the mapped part for accounting */
> > -	dm_io_set_flag(ci.io, DM_IO_SPLITTED);
> > -	ci.io->sectors = bio_sectors(bio) - ci.sector_count;
> > -	ci.io->sector_offset = bio_end_sector(bio) - bio->bi_iter.bi_sector;
> > -
> >  	bio_trim(bio, ci.io->sectors, ci.sector_count);
> >  	trace_block_split(bio, bio->bi_iter.bi_sector);
> >  	bio_inc_remaining(bio);
> > 
> > -- 
> > Ming
> > 
> 
> Unfortunately we do need splitting after __map_bio() because a dm
> target's ->map can use dm_accept_partial_bio() to further reduce a
> bio's mapped part.
> 
> But I think dm_accept_partial_bio() could be trained to update
> tio->io->sectors?

->orig_bio is just for serving io accounting, but ->orig_bio isn't
passed to dm_accept_partial_bio(), and not gets updated after
dm_accept_partial_bio() is called.

If that is one issue, it must be one existed issue in dm io accounting
since ->orig_bio isn't updated when dm_accept_partial_bio() is called.

So do we have to update it?

> 
> dm_accept_partial_bio() has been around for a long time, it keeps
> growing BUG_ONs that are actually helpful to narrow its use to "normal
> IO", so it should be OK.
> 
> Running 'make check' in a built cryptsetup source tree should be a
> good test for DM target interface functionality.

Care to share the test tree?

> 
> But there aren't automated tests for IO accounting correctness yet.

I did verify io accounting by running dm-thin with blk-throttle, and the
observed throughput is same with expected setting. Running both small bs
and large bs, so non-split and split code path are covered.

Maybe you can add this kind of test into dm io accounting automated test.


Thanks,
Ming
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

