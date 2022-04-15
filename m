Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D190C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 15 Apr 2022 21:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1650056831;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ar5eUP6DwNQgNfelcnNyLhj7V/ZleHe1S9mMqzGbmPQ=;
	b=Ct1GFsPiYmsSUFxHsBrMdYUwGTfvM+k/fWiIRGmjmDk2GPNdxbRx5WoujWBb2yxbb55KPC
	JnE59+ZdMJqaHvXYkAX45FmI2BKS9mhQYkSeBUd/zz5ZHxlqAmoIGpTwI6UaAAIVEJAi58
	t+2y+KS5mn6lC1EHNYTE9xFNXyWyVHM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-275-KRSSF-1qMWuW9f0AiiHSeg-1; Fri, 15 Apr 2022 17:07:08 -0400
X-MC-Unique: KRSSF-1qMWuW9f0AiiHSeg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3ED0A1C06912;
	Fri, 15 Apr 2022 21:07:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E231540317A;
	Fri, 15 Apr 2022 21:07:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A467519451F0;
	Fri, 15 Apr 2022 21:07:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 57BB619451EF
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Apr 2022 21:07:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 34F679E77; Fri, 15 Apr 2022 21:07:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 30E6153CD
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 21:06:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA39585A5BC
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 21:06:58 +0000 (UTC)
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-qomq58w5OHyLtJOawlmnDg-1; Fri, 15 Apr 2022 17:06:57 -0400
X-MC-Unique: qomq58w5OHyLtJOawlmnDg-1
Received: by mail-qt1-f199.google.com with SMTP id
 v14-20020ac8748e000000b002ed0d38283aso5884680qtq.5
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 14:06:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=JV0FBdm7tqCQoUCwywcoxKy10EKetc4+nBiR3O/l8NY=;
 b=1t0GRL9MsfwqJMdptaGQiuVuTpGNkR62fYZLD6Y9aAL3K/J76wfOXA8a4pE5cUMiun
 bpGgCf4ExhAonX048aIZuPuZZv3iGOOkmDhetNsAgY+NgL6E0Jp72kuW/kvK5O9Of35U
 5CeZMf8i4iF+e7ys7Z1hJMDXwEZREqoYQZQHmYfmjlMl9Q7++cRSv67AtMTbMJruw5P6
 psiGJqalpeplPWFr8iRNIQl5X3qvcUWC4zsIvBqM0O44SscBLu8/ayoEiybZ0oY9LRll
 gFFawN7BS36fw4ORKlFipgZVJbRHJNUbof3BczmjnLxeZOq53M4fwhULEhorlN4zqLcW
 iU3g==
X-Gm-Message-State: AOAM532iku2N7slGuSUltirZa2ofhXJ7ep74LlKCKM17jUsSRHCXSrDg
 TVCgNemtTiYNsAApXUJItHvQcEuM5wWSygrKeLOjZuetRkZInR4Tv0yHS4fFR3uDmEHaLYP5OUv
 UD+jj68Lxx1h+hg==
X-Received: by 2002:a05:6214:260e:b0:446:4518:7445 with SMTP id
 gu14-20020a056214260e00b0044645187445mr319564qvb.101.1650056816559; 
 Fri, 15 Apr 2022 14:06:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7CMqmTjnyxGA/97jD6NAHM7pgxKQA/c+FLzxfl+dwSkkSqlLM6DmOcJ8Ra37lj3wR8513Cw==
X-Received: by 2002:a05:6214:260e:b0:446:4518:7445 with SMTP id
 gu14-20020a056214260e00b0044645187445mr319554qvb.101.1650056816357; 
 Fri, 15 Apr 2022 14:06:56 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 i18-20020ac85c12000000b002eea9d556c9sm3426950qti.20.2022.04.15.14.06.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 15 Apr 2022 14:06:55 -0700 (PDT)
Date: Fri, 15 Apr 2022 17:06:55 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <Ylneb0NWsCab0HqI@redhat.com>
References: <YlXmmB6IO7usz2c1@redhat.com> <YlYt2rzM0NBPARVp@T590>
 <YlZp3+VrP930VjIQ@redhat.com> <YlbBf0mJa/BPHSSq@T590>
 <YlcPXslr6Y7cHOSU@redhat.com> <Yldsqh2YsclXYl3s@T590>
 <YleGKbZiHeBIJidI@redhat.com> <YlebwjTKH2MU9tCD@T590>
 <Ylhdvac5SY85r+1R@redhat.com> <Yli48LmLi7dEngLn@T590>
MIME-Version: 1.0
In-Reply-To: <Yli48LmLi7dEngLn@T590>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Apr 14 2022 at  8:14P -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> On Thu, Apr 14, 2022 at 01:45:33PM -0400, Mike Snitzer wrote:
> > On Wed, Apr 13 2022 at 11:57P -0400,
> > Ming Lei <ming.lei@redhat.com> wrote:
> > 
> > > On Wed, Apr 13, 2022 at 10:25:45PM -0400, Mike Snitzer wrote:
> > > > On Wed, Apr 13 2022 at  8:36P -0400,
> > > > Ming Lei <ming.lei@redhat.com> wrote:
> > > > 
> > > > > On Wed, Apr 13, 2022 at 01:58:54PM -0400, Mike Snitzer wrote:
> > > > > > 
> > > > > > The bigger issue with this patch is that you've caused
> > > > > > dm_submit_bio_remap() to go back to accounting the entire original bio
> > > > > > before any split occurs.  That is a problem because you'll end up
> > > > > > accounting that bio for every split, so in split heavy workloads the
> > > > > > IO accounting won't reflect when the IO is actually issued and we'll
> > > > > > regress back to having very inaccurate and incorrect IO accounting for
> > > > > > dm_submit_bio_remap() heavy targets (e.g. dm-crypt).
> > > > > 
> > > > > Good catch, but we know the length of mapped part in original bio before
> > > > > calling __map_bio(), so io->sectors/io->offset_sector can be setup here,
> > > > > something like the following delta change should address it:
> > > > > 
> > > > > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > > > > index db23efd6bbf6..06b554f3104b 100644
> > > > > --- a/drivers/md/dm.c
> > > > > +++ b/drivers/md/dm.c
> > > > > @@ -1558,6 +1558,13 @@ static int __split_and_process_bio(struct clone_info *ci)
> > > > >  
> > > > >  	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
> > > > >  	clone = alloc_tio(ci, ti, 0, &len, GFP_NOIO);
> > > > > +
> > > > > +	if (ci->sector_count > len) {
> > > > > +		/* setup the mapped part for accounting */
> > > > > +		dm_io_set_flag(ci->io, DM_IO_SPLITTED);
> > > > > +		ci->io->sectors = len;
> > > > > +		ci->io->sector_offset = bio_end_sector(ci->bio) - ci->sector;
> > > > > +	}
> > > > >  	__map_bio(clone);
> > > > >  
> > > > >  	ci->sector += len;
> > > > > @@ -1603,11 +1610,6 @@ static void dm_split_and_process_bio(struct mapped_device *md,
> > > > >  	if (error || !ci.sector_count)
> > > > >  		goto out;
> > > > >  
> > > > > -	/* setup the mapped part for accounting */
> > > > > -	dm_io_set_flag(ci.io, DM_IO_SPLITTED);
> > > > > -	ci.io->sectors = bio_sectors(bio) - ci.sector_count;
> > > > > -	ci.io->sector_offset = bio_end_sector(bio) - bio->bi_iter.bi_sector;
> > > > > -
> > > > >  	bio_trim(bio, ci.io->sectors, ci.sector_count);
> > > > >  	trace_block_split(bio, bio->bi_iter.bi_sector);
> > > > >  	bio_inc_remaining(bio);
> > > > > 
> > > > > -- 
> > > > > Ming
> > > > > 
> > > > 
> > > > Unfortunately we do need splitting after __map_bio() because a dm
> > > > target's ->map can use dm_accept_partial_bio() to further reduce a
> > > > bio's mapped part.
> > > > 
> > > > But I think dm_accept_partial_bio() could be trained to update
> > > > tio->io->sectors?
> > > 
> > > ->orig_bio is just for serving io accounting, but ->orig_bio isn't
> > > passed to dm_accept_partial_bio(), and not gets updated after
> > > dm_accept_partial_bio() is called.
> > > 
> > > If that is one issue, it must be one existed issue in dm io accounting
> > > since ->orig_bio isn't updated when dm_accept_partial_bio() is called.
> > 
> > Recall that ->orig_bio is updated after the bio_split() at the bottom of
> > dm_split_and_process_bio().
> > 
> > That bio_split() is based on ci->sector_count, which is reduced as a
> > side-effect of dm_accept_partial_bio() reducing tio->len_ptr.  It is
> > pretty circuitous so I can absolutely understand why you didn't
> > immediately appreciate the interface.  The block comment above
> > dm_accept_partial_bio() does a pretty comprehensive job of explaining.
> 
> Go it now, thanks for the explanation.
> 
> As you mentioned, it can be addressed in dm_accept_partial_bio()
> by updating ti->io->sectors.

Yes, I rebased your patchset ontop of dm-5.19 and fixed up your
splitting like we discussed.  I'll be rebasing ontop of v5.18-rc3 once
it is released but please have a look at this 'dm-5.19-v2' branch:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.19-v2

And this commit in particular:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.19-v2&id=fe5a99da8b0d0518342f5cdb522a06b0f123ca09

Once I've verified with you that it looks OK I'll fold it into your
commit (at the same time I rebase on v5.18-rc3 early next week).

In general this rebase sucked.. but I wanted to layer your changes
ontop of earlier changes I had already staged for 5.19. I've at least
verified that DM's bio polling seems to work like usual and also
verified that cryptsetup's 'make check' passes.

No urgency on you reviewing before early next week.  Have a great
weekend.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

