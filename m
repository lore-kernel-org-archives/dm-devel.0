Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18FE9C433F5
	for <dm-devel@archiver.kernel.org>; Sun, 17 Apr 2022 02:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1650162178;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wqiakUCPwIkFSwwlt19Y/8FiiRUAztwhvaTIEW4dyc4=;
	b=HmLxyVA8UJ2jRbWERZq9RDw3I9UoNZo7ijpwhqUAXdpqqM7gZG0yD6q4mi+ZPKOh2/mvZJ
	HohxY+DJfRH+V56FtHDYnF7Xcih3YaZRJFd0Acyjm178wkN3eh1X8D7XcHeqFfu0761fZo
	09zEjxWlaGplgLExqkbhKGusmKhFCPU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-A3EOmcjvMBSor4TxxUPnag-1; Sat, 16 Apr 2022 22:22:55 -0400
X-MC-Unique: A3EOmcjvMBSor4TxxUPnag-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC7041C04B74;
	Sun, 17 Apr 2022 02:22:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 87F61111C4A1;
	Sun, 17 Apr 2022 02:22:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5524D19451F1;
	Sun, 17 Apr 2022 02:22:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9BA3619466DF
 for <dm-devel@listman.corp.redhat.com>; Sun, 17 Apr 2022 02:22:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6B2CF111C4A0; Sun, 17 Apr 2022 02:22:51 +0000 (UTC)
Received: from T590 (ovpn-8-20.pek2.redhat.com [10.72.8.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E86A6111DD0D;
 Sun, 17 Apr 2022 02:22:33 +0000 (UTC)
Date: Sun, 17 Apr 2022 10:22:28 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <Ylt55PHHu6XShdfA@T590>
References: <YlYt2rzM0NBPARVp@T590> <YlZp3+VrP930VjIQ@redhat.com>
 <YlbBf0mJa/BPHSSq@T590> <YlcPXslr6Y7cHOSU@redhat.com>
 <Yldsqh2YsclXYl3s@T590> <YleGKbZiHeBIJidI@redhat.com>
 <YlebwjTKH2MU9tCD@T590> <Ylhdvac5SY85r+1R@redhat.com>
 <Yli48LmLi7dEngLn@T590> <Ylneb0NWsCab0HqI@redhat.com>
MIME-Version: 1.0
In-Reply-To: <Ylneb0NWsCab0HqI@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Apr 15, 2022 at 05:06:55PM -0400, Mike Snitzer wrote:
> On Thu, Apr 14 2022 at  8:14P -0400,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
> > On Thu, Apr 14, 2022 at 01:45:33PM -0400, Mike Snitzer wrote:
> > > On Wed, Apr 13 2022 at 11:57P -0400,
> > > Ming Lei <ming.lei@redhat.com> wrote:
> > > 
> > > > On Wed, Apr 13, 2022 at 10:25:45PM -0400, Mike Snitzer wrote:
> > > > > On Wed, Apr 13 2022 at  8:36P -0400,
> > > > > Ming Lei <ming.lei@redhat.com> wrote:
> > > > > 
> > > > > > On Wed, Apr 13, 2022 at 01:58:54PM -0400, Mike Snitzer wrote:
> > > > > > > 
> > > > > > > The bigger issue with this patch is that you've caused
> > > > > > > dm_submit_bio_remap() to go back to accounting the entire original bio
> > > > > > > before any split occurs.  That is a problem because you'll end up
> > > > > > > accounting that bio for every split, so in split heavy workloads the
> > > > > > > IO accounting won't reflect when the IO is actually issued and we'll
> > > > > > > regress back to having very inaccurate and incorrect IO accounting for
> > > > > > > dm_submit_bio_remap() heavy targets (e.g. dm-crypt).
> > > > > > 
> > > > > > Good catch, but we know the length of mapped part in original bio before
> > > > > > calling __map_bio(), so io->sectors/io->offset_sector can be setup here,
> > > > > > something like the following delta change should address it:
> > > > > > 
> > > > > > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > > > > > index db23efd6bbf6..06b554f3104b 100644
> > > > > > --- a/drivers/md/dm.c
> > > > > > +++ b/drivers/md/dm.c
> > > > > > @@ -1558,6 +1558,13 @@ static int __split_and_process_bio(struct clone_info *ci)
> > > > > >  
> > > > > >  	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
> > > > > >  	clone = alloc_tio(ci, ti, 0, &len, GFP_NOIO);
> > > > > > +
> > > > > > +	if (ci->sector_count > len) {
> > > > > > +		/* setup the mapped part for accounting */
> > > > > > +		dm_io_set_flag(ci->io, DM_IO_SPLITTED);
> > > > > > +		ci->io->sectors = len;
> > > > > > +		ci->io->sector_offset = bio_end_sector(ci->bio) - ci->sector;
> > > > > > +	}
> > > > > >  	__map_bio(clone);
> > > > > >  
> > > > > >  	ci->sector += len;
> > > > > > @@ -1603,11 +1610,6 @@ static void dm_split_and_process_bio(struct mapped_device *md,
> > > > > >  	if (error || !ci.sector_count)
> > > > > >  		goto out;
> > > > > >  
> > > > > > -	/* setup the mapped part for accounting */
> > > > > > -	dm_io_set_flag(ci.io, DM_IO_SPLITTED);
> > > > > > -	ci.io->sectors = bio_sectors(bio) - ci.sector_count;
> > > > > > -	ci.io->sector_offset = bio_end_sector(bio) - bio->bi_iter.bi_sector;
> > > > > > -
> > > > > >  	bio_trim(bio, ci.io->sectors, ci.sector_count);
> > > > > >  	trace_block_split(bio, bio->bi_iter.bi_sector);
> > > > > >  	bio_inc_remaining(bio);
> > > > > > 
> > > > > > -- 
> > > > > > Ming
> > > > > > 
> > > > > 
> > > > > Unfortunately we do need splitting after __map_bio() because a dm
> > > > > target's ->map can use dm_accept_partial_bio() to further reduce a
> > > > > bio's mapped part.
> > > > > 
> > > > > But I think dm_accept_partial_bio() could be trained to update
> > > > > tio->io->sectors?
> > > > 
> > > > ->orig_bio is just for serving io accounting, but ->orig_bio isn't
> > > > passed to dm_accept_partial_bio(), and not gets updated after
> > > > dm_accept_partial_bio() is called.
> > > > 
> > > > If that is one issue, it must be one existed issue in dm io accounting
> > > > since ->orig_bio isn't updated when dm_accept_partial_bio() is called.
> > > 
> > > Recall that ->orig_bio is updated after the bio_split() at the bottom of
> > > dm_split_and_process_bio().
> > > 
> > > That bio_split() is based on ci->sector_count, which is reduced as a
> > > side-effect of dm_accept_partial_bio() reducing tio->len_ptr.  It is
> > > pretty circuitous so I can absolutely understand why you didn't
> > > immediately appreciate the interface.  The block comment above
> > > dm_accept_partial_bio() does a pretty comprehensive job of explaining.
> > 
> > Go it now, thanks for the explanation.
> > 
> > As you mentioned, it can be addressed in dm_accept_partial_bio()
> > by updating ti->io->sectors.
> 
> Yes, I rebased your patchset ontop of dm-5.19 and fixed up your
> splitting like we discussed.  I'll be rebasing ontop of v5.18-rc3 once
> it is released but please have a look at this 'dm-5.19-v2' branch:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.19-v2
> 
> And this commit in particular:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.19-v2&id=fe5a99da8b0d0518342f5cdb522a06b0f123ca09
> 
> Once I've verified with you that it looks OK I'll fold it into your
> commit (at the same time I rebase on v5.18-rc3 early next week).

Hi Mike,

Your delta change looks good, thanks for fixing it!

Thanks,
Ming
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

