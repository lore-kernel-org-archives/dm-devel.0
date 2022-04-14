Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08AB7C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 02:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649903158;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FFSQq3zTsaZdehxuXPemFr9tVDAguuSoXf5/grcqTZg=;
	b=hZC9rerg36h1vhAZ0eWu4foV4ahF4EtdsLPwc3moerLCAcPxYjeHibJYMEy7cAE8SnCmW+
	b/l4P8odeus86yWiSVzegUIdOGiig60wY+SAk+RNVCIdSzspG0eRvP3/rJagNkhu8E4WWT
	dMijpXlMlRnfh2LI5EcAhDXYrEdMALk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-B6UTO9jSMQixtpboQON3sw-1; Wed, 13 Apr 2022 22:25:55 -0400
X-MC-Unique: B6UTO9jSMQixtpboQON3sw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83134101AA46;
	Thu, 14 Apr 2022 02:25:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3004E403D1DD;
	Thu, 14 Apr 2022 02:25:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D7F8B1940347;
	Thu, 14 Apr 2022 02:25:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 72AB31940345
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 02:25:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4EBEF2166B1B; Thu, 14 Apr 2022 02:25:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A6622166B4F
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 02:25:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 427E31C05ECC
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 02:25:49 +0000 (UTC)
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-ZyDDfHGpO8uDOFlJ2Y9pJw-1; Wed, 13 Apr 2022 22:25:48 -0400
X-MC-Unique: ZyDDfHGpO8uDOFlJ2Y9pJw-1
Received: by mail-qk1-f199.google.com with SMTP id
 i2-20020a05620a248200b0067b51fa1269so2354182qkn.19
 for <dm-devel@redhat.com>; Wed, 13 Apr 2022 19:25:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=0BQBb0f7oVDpvvl2qnf2tz1B/xNgX8iw6UNvB9T+NuU=;
 b=BDEhXBwct2OSAy9xZYgVBRQxbw/r3e6lwUj9bILPr8h6fQiR1RcdQDO9ROnkHgvTm4
 5PFFDUiYKm8GUPE1ibk8IM3aDgDqd/uPZhbni4PSQemOSuU5LRw2jrMgOsbBMntzA3nw
 qbyRqaqITPqu0mkGN9MuBi9zzJKkWDT1uFlEjzX3Q8wLONic7tIgrh65RvrF4ownftcb
 CnIGlBuhHyCOf6KQk0NR2ij9xZ5O5vUhAQPregYq7rHB8LQGc8bT7XgnQI3y3BO5Ui+8
 NiOBb8FvgJO27bQBu+bWx9dClYbyEQTdW3C/EWXhhEF0TmVKoLRrEd7eDuEaYPnKXYXV
 5I4A==
X-Gm-Message-State: AOAM533uh2O0sclrEq/0PXveBHyihMheDX7qTL/iBEXwWKADYcSRmyNv
 Qi/P0BLHodB+/fcynE8LrDpL7uzn2yjcKO1SRFtP+jU7Tv+glT4CMQAeVs8PpB2mOig67AMmUV7
 wA+MMQTnedqtoUQ==
X-Received: by 2002:a05:6214:2b07:b0:432:f7e6:e443 with SMTP id
 jx7-20020a0562142b0700b00432f7e6e443mr1521782qvb.125.1649903147624; 
 Wed, 13 Apr 2022 19:25:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCuqBXHKIMDdwqi70OXn3SDNyKoxwtxfUD4IOVc8mGvD+IypAu5rmYFF1A9Y4bMUBx+TkJaQ==
X-Received: by 2002:a05:6214:2b07:b0:432:f7e6:e443 with SMTP id
 jx7-20020a0562142b0700b00432f7e6e443mr1521773qvb.125.1649903147426; 
 Wed, 13 Apr 2022 19:25:47 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 e13-20020ac85dcd000000b002eb9458498esm426204qtx.95.2022.04.13.19.25.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 13 Apr 2022 19:25:46 -0700 (PDT)
Date: Wed, 13 Apr 2022 22:25:45 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <YleGKbZiHeBIJidI@redhat.com>
References: <20220412085616.1409626-1-ming.lei@redhat.com>
 <20220412085616.1409626-6-ming.lei@redhat.com>
 <YlXmmB6IO7usz2c1@redhat.com> <YlYt2rzM0NBPARVp@T590>
 <YlZp3+VrP930VjIQ@redhat.com> <YlbBf0mJa/BPHSSq@T590>
 <YlcPXslr6Y7cHOSU@redhat.com> <Yldsqh2YsclXYl3s@T590>
MIME-Version: 1.0
In-Reply-To: <Yldsqh2YsclXYl3s@T590>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Apr 13 2022 at  8:36P -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> On Wed, Apr 13, 2022 at 01:58:54PM -0400, Mike Snitzer wrote:
> > 
> > The bigger issue with this patch is that you've caused
> > dm_submit_bio_remap() to go back to accounting the entire original bio
> > before any split occurs.  That is a problem because you'll end up
> > accounting that bio for every split, so in split heavy workloads the
> > IO accounting won't reflect when the IO is actually issued and we'll
> > regress back to having very inaccurate and incorrect IO accounting for
> > dm_submit_bio_remap() heavy targets (e.g. dm-crypt).
> 
> Good catch, but we know the length of mapped part in original bio before
> calling __map_bio(), so io->sectors/io->offset_sector can be setup here,
> something like the following delta change should address it:
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index db23efd6bbf6..06b554f3104b 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1558,6 +1558,13 @@ static int __split_and_process_bio(struct clone_info *ci)
>  
>  	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
>  	clone = alloc_tio(ci, ti, 0, &len, GFP_NOIO);
> +
> +	if (ci->sector_count > len) {
> +		/* setup the mapped part for accounting */
> +		dm_io_set_flag(ci->io, DM_IO_SPLITTED);
> +		ci->io->sectors = len;
> +		ci->io->sector_offset = bio_end_sector(ci->bio) - ci->sector;
> +	}
>  	__map_bio(clone);
>  
>  	ci->sector += len;
> @@ -1603,11 +1610,6 @@ static void dm_split_and_process_bio(struct mapped_device *md,
>  	if (error || !ci.sector_count)
>  		goto out;
>  
> -	/* setup the mapped part for accounting */
> -	dm_io_set_flag(ci.io, DM_IO_SPLITTED);
> -	ci.io->sectors = bio_sectors(bio) - ci.sector_count;
> -	ci.io->sector_offset = bio_end_sector(bio) - bio->bi_iter.bi_sector;
> -
>  	bio_trim(bio, ci.io->sectors, ci.sector_count);
>  	trace_block_split(bio, bio->bi_iter.bi_sector);
>  	bio_inc_remaining(bio);
> 
> -- 
> Ming
> 

Unfortunately we do need splitting after __map_bio() because a dm
target's ->map can use dm_accept_partial_bio() to further reduce a
bio's mapped part.

But I think dm_accept_partial_bio() could be trained to update
tio->io->sectors?

dm_accept_partial_bio() has been around for a long time, it keeps
growing BUG_ONs that are actually helpful to narrow its use to "normal
IO", so it should be OK.

Running 'make check' in a built cryptsetup source tree should be a
good test for DM target interface functionality.

But there aren't automated tests for IO accounting correctness yet.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

