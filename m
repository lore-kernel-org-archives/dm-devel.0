Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AD28C4332F
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 17:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649958351;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rHmKAfZLTZ1Z+TUyXOg72BwEZNFD9pfgmPqFvdFv04g=;
	b=cwOh/erePaqJ0GDhR4iqV962qsKygcdAtQQmWG/E55oEzFJ2PCL58Q7S3z9HDUCGv5KNZo
	2u52/WZcPdRuDDY6f9Ry5BpO/LE3nrocIVNdWSIJiaSOVBU6gcLMOmsEjhFvF9VgUQ90JG
	jBqSeKBDZL8EAqgp7Uc/fPmURqhtul8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-le_dbwsyMfyweLuvJqCNkA-1; Thu, 14 Apr 2022 13:45:47 -0400
X-MC-Unique: le_dbwsyMfyweLuvJqCNkA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD1ED29DD9BF;
	Thu, 14 Apr 2022 17:45:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7DE18404776F;
	Thu, 14 Apr 2022 17:45:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 336701940344;
	Thu, 14 Apr 2022 17:45:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2A2AD19451F2
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 17:45:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 18B1C40470E1; Thu, 14 Apr 2022 17:45:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 14BC540D2848
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 17:45:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF99686B8A1
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 17:45:36 +0000 (UTC)
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-Q0daiOudMpyxNYivZPu3xw-1; Thu, 14 Apr 2022 13:45:35 -0400
X-MC-Unique: Q0daiOudMpyxNYivZPu3xw-1
Received: by mail-qk1-f199.google.com with SMTP id
 m23-20020a05620a221700b006809e1fa4fdso3754421qkh.6
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 10:45:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=usx95EEwfrYdBbdBHcf5uEzhLX1K5ppp1W762nvmhf0=;
 b=4ipKXcM13uo7DAaXsOvYP+01hn9c/JEAXjfz7mmu/d45d8I7F/u/nqb58m8QC6cv8H
 t89uxLFD7emxKHsSNC7s71tQy2Pzt5Tm6V4Z7KjG3OMQ3eXjxe67jP5OIrvi85NlAFkO
 z+hys8ZSk1oxEnoljkJ1t1fdum5zGmgtYXUca7J1WNde3GFl5g0RokLj+W9/OXJleKmB
 kc+F0uUbt9M4uNMw136vFrckB/mblrQUiAFmmfAC98dFiXThM+trgqaZF70rkaYJJLSy
 E9/LL8xr1uG3U2COz0INTT+1rd+RCadp540NOuxKQ6WTp/BDdj9YvyCUaP9gfZwY0xvk
 h+7w==
X-Gm-Message-State: AOAM531gV5fDK+5B9PP2rHZCy+VPwdX3rjqrpaXCaTKtbo0ixXEqTIH5
 JHe1qXBLuLuX3l8n/H+dCQDVumuGtQMqIAPC7NwOASKp7U7ZOAa2bLjqLN8dHPDM7i+ucAO2rDm
 pcHE4+T6lEZr4tQ==
X-Received: by 2002:a05:6214:1194:b0:444:45d6:d79d with SMTP id
 t20-20020a056214119400b0044445d6d79dmr4402765qvv.36.1649958335398; 
 Thu, 14 Apr 2022 10:45:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUpya9rdf13D61nFewCk4EkHcslczh8V8fddHYZSzprOrc5xsK/HVlJwVz8wlvQvvDIaifCw==
X-Received: by 2002:a05:6214:1194:b0:444:45d6:d79d with SMTP id
 t20-20020a056214119400b0044445d6d79dmr4402751qvv.36.1649958335179; 
 Thu, 14 Apr 2022 10:45:35 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 e126-20020a376984000000b0069c86b28524sm440264qkc.19.2022.04.14.10.45.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Apr 2022 10:45:34 -0700 (PDT)
Date: Thu, 14 Apr 2022 13:45:33 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <Ylhdvac5SY85r+1R@redhat.com>
References: <20220412085616.1409626-1-ming.lei@redhat.com>
 <20220412085616.1409626-6-ming.lei@redhat.com>
 <YlXmmB6IO7usz2c1@redhat.com> <YlYt2rzM0NBPARVp@T590>
 <YlZp3+VrP930VjIQ@redhat.com> <YlbBf0mJa/BPHSSq@T590>
 <YlcPXslr6Y7cHOSU@redhat.com> <Yldsqh2YsclXYl3s@T590>
 <YleGKbZiHeBIJidI@redhat.com> <YlebwjTKH2MU9tCD@T590>
MIME-Version: 1.0
In-Reply-To: <YlebwjTKH2MU9tCD@T590>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Apr 13 2022 at 11:57P -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> On Wed, Apr 13, 2022 at 10:25:45PM -0400, Mike Snitzer wrote:
> > On Wed, Apr 13 2022 at  8:36P -0400,
> > Ming Lei <ming.lei@redhat.com> wrote:
> > 
> > > On Wed, Apr 13, 2022 at 01:58:54PM -0400, Mike Snitzer wrote:
> > > > 
> > > > The bigger issue with this patch is that you've caused
> > > > dm_submit_bio_remap() to go back to accounting the entire original bio
> > > > before any split occurs.  That is a problem because you'll end up
> > > > accounting that bio for every split, so in split heavy workloads the
> > > > IO accounting won't reflect when the IO is actually issued and we'll
> > > > regress back to having very inaccurate and incorrect IO accounting for
> > > > dm_submit_bio_remap() heavy targets (e.g. dm-crypt).
> > > 
> > > Good catch, but we know the length of mapped part in original bio before
> > > calling __map_bio(), so io->sectors/io->offset_sector can be setup here,
> > > something like the following delta change should address it:
> > > 
> > > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > > index db23efd6bbf6..06b554f3104b 100644
> > > --- a/drivers/md/dm.c
> > > +++ b/drivers/md/dm.c
> > > @@ -1558,6 +1558,13 @@ static int __split_and_process_bio(struct clone_info *ci)
> > >  
> > >  	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
> > >  	clone = alloc_tio(ci, ti, 0, &len, GFP_NOIO);
> > > +
> > > +	if (ci->sector_count > len) {
> > > +		/* setup the mapped part for accounting */
> > > +		dm_io_set_flag(ci->io, DM_IO_SPLITTED);
> > > +		ci->io->sectors = len;
> > > +		ci->io->sector_offset = bio_end_sector(ci->bio) - ci->sector;
> > > +	}
> > >  	__map_bio(clone);
> > >  
> > >  	ci->sector += len;
> > > @@ -1603,11 +1610,6 @@ static void dm_split_and_process_bio(struct mapped_device *md,
> > >  	if (error || !ci.sector_count)
> > >  		goto out;
> > >  
> > > -	/* setup the mapped part for accounting */
> > > -	dm_io_set_flag(ci.io, DM_IO_SPLITTED);
> > > -	ci.io->sectors = bio_sectors(bio) - ci.sector_count;
> > > -	ci.io->sector_offset = bio_end_sector(bio) - bio->bi_iter.bi_sector;
> > > -
> > >  	bio_trim(bio, ci.io->sectors, ci.sector_count);
> > >  	trace_block_split(bio, bio->bi_iter.bi_sector);
> > >  	bio_inc_remaining(bio);
> > > 
> > > -- 
> > > Ming
> > > 
> > 
> > Unfortunately we do need splitting after __map_bio() because a dm
> > target's ->map can use dm_accept_partial_bio() to further reduce a
> > bio's mapped part.
> > 
> > But I think dm_accept_partial_bio() could be trained to update
> > tio->io->sectors?
> 
> ->orig_bio is just for serving io accounting, but ->orig_bio isn't
> passed to dm_accept_partial_bio(), and not gets updated after
> dm_accept_partial_bio() is called.
> 
> If that is one issue, it must be one existed issue in dm io accounting
> since ->orig_bio isn't updated when dm_accept_partial_bio() is called.

Recall that ->orig_bio is updated after the bio_split() at the bottom of
dm_split_and_process_bio().

That bio_split() is based on ci->sector_count, which is reduced as a
side-effect of dm_accept_partial_bio() reducing tio->len_ptr.  It is
pretty circuitous so I can absolutely understand why you didn't
immediately appreciate the interface.  The block comment above
dm_accept_partial_bio() does a pretty comprehensive job of explaining.

But basically dm_accept_partial_bio() provides DM targets access to
control DM core's splitting if they find that they cannot accommodate
the entirety of the clone bio that is sent to their ->map.
dm_accept_partial_bio() may only ever be called from a target's ->map

> So do we have to update it?
> 
> > 
> > dm_accept_partial_bio() has been around for a long time, it keeps
> > growing BUG_ONs that are actually helpful to narrow its use to "normal
> > IO", so it should be OK.
> > 
> > Running 'make check' in a built cryptsetup source tree should be a
> > good test for DM target interface functionality.
> 
> Care to share the test tree?

https://gitlab.com/cryptsetup/cryptsetup.git

> 
> > 
> > But there aren't automated tests for IO accounting correctness yet.
> 
> I did verify io accounting by running dm-thin with blk-throttle, and the
> observed throughput is same with expected setting. Running both small bs
> and large bs, so non-split and split code path are covered.
> 
> Maybe you can add this kind of test into dm io accounting automated test.

Yeah, something like that would be good.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

