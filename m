Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DD95C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 16:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644595300;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wm9MtjyeLPcG2sbGPbD40TvTiu88wZulhcmwPexcxyo=;
	b=hMZ4AscSeU2MaaGBTizrq/uqP7TDKNnSmXVDsLhMVeYQy5praAUbkZ7JEaYIlXNtbT2RdN
	UT1gn6vER02kA1jQhs3LJbXtWgAUO4v+x3jvEQAnDxwWVsBzxcRbzyVUO0OxxVsd+Zq8xO
	XS3nBcoWwux21xpnEBZBqGxPXdc3vBU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-456-JY6P8CqRNaqItVXG19NEow-1; Fri, 11 Feb 2022 11:01:37 -0500
X-MC-Unique: JY6P8CqRNaqItVXG19NEow-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D78F1088162;
	Fri, 11 Feb 2022 16:00:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 154875F92C;
	Fri, 11 Feb 2022 16:00:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 760394BB7C;
	Fri, 11 Feb 2022 16:00:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21BG0brl030407 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Feb 2022 11:00:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DBA6540885BD; Fri, 11 Feb 2022 16:00:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D806E40885BB
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 16:00:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF260800B21
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 16:00:37 +0000 (UTC)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
	[209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-574-ltP2Rzh_MMqIRwTQXk2cEw-1; Fri, 11 Feb 2022 11:00:36 -0500
X-MC-Unique: ltP2Rzh_MMqIRwTQXk2cEw-1
Received: by mail-qt1-f197.google.com with SMTP id
	x5-20020ac84d45000000b002cf826b1a18so7106889qtv.2
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 08:00:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=XGAeOV81utJ3y/BxzDk7FXWUXpEzhBA72qYE+Dwxgo0=;
	b=dpeIObL0zTwxssMbHoBJOTbzN1GnVKiu8x+hQzURyojaeZhnr1uThfrR/rQzBtWiN4
	n8zXAGLQb2fsCwZGr1QCFz+2GrY2gF17LdKKQ8qXHnT3S56rH9XfXQ82MfBWN4fWMsSC
	65aPiMzAbDA2iLoVdmo91VPLQn5uFtevfrorHitGKQhp+7cdpaoH9rqRGGAN/5mJ42wx
	8Z6/9CvvC01VpgGcXjFPohhdd4erND9xskY2D6g0gmx7FUywVvdWBn+PlgUYLdZeZbiN
	DoILO7hO3dnD40zKsif/g3r+N+pfcaAo+E9Rcc3oTD/qlKqtlSRGFtQbDN1/lRwBx0Ed
	+/Aw==
X-Gm-Message-State: AOAM532FL/9H2M7HKYxy2jdM66b5CEXd/brPFUyTmc3uFEDJ7BGYG8XI
	z22LXiJYvAFo9tpxoOrxDNWAyuFOyeOff3mgDzcAA1tmVTdTAYTW5cMV0j3GcpfCQeSiMSeIO9i
	XG5GC3esAmVqxPw==
X-Received: by 2002:a05:6214:c8f:: with SMTP id
	r15mr1537269qvr.109.1644595235662; 
	Fri, 11 Feb 2022 08:00:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzEbbFyprm7H18jo1KHn0UAGaNTHJ3BmAjscvFwVtguwVIBYqLgyx1pe/t2gTL15LEYJZh2FQ==
X-Received: by 2002:a05:6214:c8f:: with SMTP id
	r15mr1537252qvr.109.1644595235400; 
	Fri, 11 Feb 2022 08:00:35 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	j15sm13116840qta.83.2022.02.11.08.00.34
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 11 Feb 2022 08:00:34 -0800 (PST)
Date: Fri, 11 Feb 2022 11:00:34 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <YgaIIqRhaX2VmedJ@redhat.com>
References: <alpine.LRH.2.02.2202111001560.30005@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2202111001560.30005@file01.intranet.prod.int.rdu2.redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com
Subject: Re: [dm-devel] dm: account statistics correctly in case of bio split
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Feb 11 2022 at 10:03P -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> If a bio was split to multiple targets, only one target's sub-range was
> counted. This patch changes it so that all the targets' ranges are
> counted.
> 
> Note that calls to bio_start_io_acct_remapped and bio_end_io_acct must
> match, so we maintain a counter how many times we have called
> bio_start_io_acct_remapped. When the io finishes, we call end_io_acct
> repeatedly.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>


Sorry but I'm not understanding, because any split that is needed due
to target boundaries will occur and the remainder (destined for other
targets) gets recursively submit_bio_noacct()'d back to the DM device.

So why do you think this wasn't happening properly?

Mike


> 
> ---
>  drivers/md/dm-core.h |    2 +-
>  drivers/md/dm.c      |   39 ++++++++++++++++++++-------------------
>  2 files changed, 21 insertions(+), 20 deletions(-)
> 
> Index: linux-dm/drivers/md/dm-core.h
> ===================================================================
> --- linux-dm.orig/drivers/md/dm-core.h	2022-02-11 15:44:33.000000000 +0100
> +++ linux-dm/drivers/md/dm-core.h	2022-02-11 15:44:33.000000000 +0100
> @@ -230,7 +230,7 @@ struct dm_io {
>  	atomic_t io_count;
>  	struct bio *orig_bio;
>  	unsigned long start_time;
> -	int was_accounted;
> +	atomic_t n_accounted;
>  	spinlock_t lock;
>  	struct dm_stats_aux stats_aux;
>  	/* last member of dm_target_io is 'struct bio' */
> Index: linux-dm/drivers/md/dm.c
> ===================================================================
> --- linux-dm.orig/drivers/md/dm.c	2022-02-11 15:44:33.000000000 +0100
> +++ linux-dm/drivers/md/dm.c	2022-02-11 15:52:04.000000000 +0100
> @@ -487,27 +487,30 @@ EXPORT_SYMBOL_GPL(dm_start_time_ns_from_
>  
>  static void start_io_acct(struct dm_io *io, struct bio *bio)
>  {
> -	struct bio *orig_bio;
> -
> -	/* Ensure IO accounting is only ever started once */
> -	if (xchg(&io->was_accounted, 1) == 1)
> -		return;
> -
> -	orig_bio = io->orig_bio;
> +	struct bio *orig_bio = io->orig_bio;
>  
>  	bio_start_io_acct_remapped(bio, io->start_time,
>  				   orig_bio->bi_bdev);
>  
> -	if (unlikely(dm_stats_used(&io->md->stats)))
> +	if (unlikely(dm_stats_used(&io->md->stats))) {
> +		if (unlikely(atomic_inc_return(&io->n_accounted) != 1))
> +			return;
>  		dm_stats_account_io(&io->md->stats, bio_data_dir(orig_bio),
>  				    orig_bio->bi_iter.bi_sector, bio_sectors(orig_bio),
>  				    false, 0, &io->stats_aux);
> +	} else {
> +		atomic_inc(&io->n_accounted);
> +	}
>  }
>  
> -static void end_io_acct(struct mapped_device *md, struct bio *bio,
> +static void end_io_acct(struct mapped_device *md, unsigned n_accounted, struct bio *bio,
>  			unsigned long start_time, struct dm_stats_aux *stats_aux)
>  {
> -	bio_end_io_acct(bio, start_time);
> +	if (unlikely(!n_accounted))
> +		return;
> +	do {
> +		bio_end_io_acct(bio, start_time);
> +	} while (unlikely(--n_accounted));
>  
>  	if (unlikely(dm_stats_used(&md->stats)))
>  		dm_stats_account_io(&md->stats, bio_data_dir(bio),
> @@ -536,7 +539,7 @@ static struct dm_io *alloc_io(struct map
>  	spin_lock_init(&io->lock);
>  
>  	io->start_time = jiffies;
> -	io->was_accounted = 0;
> +	io->n_accounted = (atomic_t)ATOMIC_INIT(0);
>  
>  	return io;
>  }
> @@ -793,7 +796,7 @@ void dm_io_dec_pending(struct dm_io *io,
>  	blk_status_t io_error;
>  	struct bio *bio;
>  	struct mapped_device *md = io->md;
> -	bool was_accounted = false;
> +	int n_accounted;
>  	unsigned long start_time = 0;
>  	struct dm_stats_aux stats_aux;
>  
> @@ -827,14 +830,12 @@ void dm_io_dec_pending(struct dm_io *io,
>  		}
>  
>  		io_error = io->status;
> -		if (io->was_accounted) {
> -			was_accounted = true;
> -			start_time = io->start_time;
> -			stats_aux = io->stats_aux;
> -		}
> +		n_accounted = atomic_read(&io->n_accounted);
> +		start_time = io->start_time;
> +		stats_aux = io->stats_aux;
> +
>  		free_io(io);
> -		if (was_accounted)
> -			end_io_acct(md, bio, start_time, &stats_aux);
> +		end_io_acct(md, n_accounted, bio, start_time, &stats_aux);
>  
>  		/* nudge anyone waiting on suspend queue */
>  		if (unlikely(wq_has_sleeper(&md->wait)))
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

