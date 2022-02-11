Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEEE5C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 16:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644595703;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=83Qg4pqxK5DOOmpkwuoybQWxRwdKWP2wbYSG2spPusU=;
	b=aZjobvwPW+s6SRPDmBiwxYw8Wz5mfakyo3XDsmAhNKmnvXQiKt4JtxGsnd/dWwfhH0I0nc
	AsU1v4T6pPpesB625iXoyaduw2Pyn+iOuvat7knlRle8aU+h3UefhVKggc9Bqj8qWnx+vp
	0TwGu18LlFwI/d+W02luC/UVdUGz+nY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-Mj-pQr6HNNqypPyOOuVAug-1; Fri, 11 Feb 2022 11:08:20 -0500
X-MC-Unique: Mj-pQr6HNNqypPyOOuVAug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88A4E8143EB;
	Fri, 11 Feb 2022 16:08:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 72F82838F0;
	Fri, 11 Feb 2022 16:08:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 233961809CB8;
	Fri, 11 Feb 2022 16:08:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21BG89t0031472 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Feb 2022 11:08:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2A738492D54; Fri, 11 Feb 2022 16:08:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 27149492D57
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 16:08:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E6B43804518
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 16:08:09 +0000 (UTC)
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
	[209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-241-y-EA7tvdOLaPDO7-eeNHrw-1; Fri, 11 Feb 2022 11:08:08 -0500
X-MC-Unique: y-EA7tvdOLaPDO7-eeNHrw-1
Received: by mail-qk1-f197.google.com with SMTP id
	x16-20020a05620a449000b00508582d0db2so5901349qkp.0
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 08:08:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=xDSn/nRcop2PCw/+kmnkQe2uEKQJ2Nfc05g0qLPhlMI=;
	b=pyuJ5CTFv9BXFSr055kD46EteNy50q+b07mEbjJRBxo3yc/SmiNTYuOkGSu3JsXELp
	Uw/VqF0DF48QMXoKAKZI1v4K0823AxwIOA//uyG59ZTL6pnTCSCBDqxtbF4oSgN8YFH5
	jLMx5EUJ8tdWCMnuh68rMx8MJNxuLdeGWcwYzunsR0yVrc3zuKPbvx9A3dnPNYU1hq2Y
	Us0DvJBv8Dpr5BW5VMjfcPpn4WTrmFoLrsXbFglDF/zter9CBdeWl6xwCMQ2is6G0BeN
	dcVsEqVsPTCbd//bctTyw8prpMEFVXJFNAudkJm4NVX6ozGfQK9c1vf23CzsXkzSR42F
	cy6w==
X-Gm-Message-State: AOAM530JzXPPYx+2VpPQQNUHi6XtYcZnHuExntvGKv//0Brx4VGMLpB5
	ak42opqFEtQCMadypAWDo2uzujaxlTDUN81xthJ0BpZ0Oeas7S3zYfei2TZQqb/FJOeC26128xp
	poAfcaGtrH/uR4Q==
X-Received: by 2002:ad4:5d68:: with SMTP id fn8mr1614188qvb.34.1644595687309; 
	Fri, 11 Feb 2022 08:08:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxGidnfBOVBlzWtcODapNt5p+QSDjZsgy81lE/i5lKnwx0SWZO7YdRPU3xT36v+3Miaf5Xrww==
X-Received: by 2002:ad4:5d68:: with SMTP id fn8mr1614175qvb.34.1644595687093; 
	Fri, 11 Feb 2022 08:08:07 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	d17sm11885744qkn.84.2022.02.11.08.08.06
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 11 Feb 2022 08:08:06 -0800 (PST)
Date: Fri, 11 Feb 2022 11:08:05 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <YgaJ5bqSIR+OtYJt@redhat.com>
References: <alpine.LRH.2.02.2202110959350.30005@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2202110959350.30005@file01.intranet.prod.int.rdu2.redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com
Subject: Re: [dm-devel] dm: fix dm_stats accounting
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Feb 11 2022 at 10:01P -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Exactly the same sector number and length must be passed to both calls of
> dm_stats_account_io, otherwise its per-zone in_flight counters go out of
> sync. This patch fixes it.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> Index: linux-dm/drivers/md/dm.c
> ===================================================================
> --- linux-dm.orig/drivers/md/dm.c	2022-02-11 15:32:56.000000000 +0100
> +++ linux-dm/drivers/md/dm.c	2022-02-11 15:40:11.000000000 +0100
> @@ -487,16 +487,20 @@ EXPORT_SYMBOL_GPL(dm_start_time_ns_from_
>  
>  static void start_io_acct(struct dm_io *io, struct bio *bio)
>  {
> +	struct bio *orig_bio;
> +
>  	/* Ensure IO accounting is only ever started once */
>  	if (xchg(&io->was_accounted, 1) == 1)
>  		return;
>  
> +	orig_bio = io->orig_bio;
> +
>  	bio_start_io_acct_remapped(bio, io->start_time,
> -				   io->orig_bio->bi_bdev);
> +				   orig_bio->bi_bdev);
>  
>  	if (unlikely(dm_stats_used(&io->md->stats)))
> -		dm_stats_account_io(&io->md->stats, bio_data_dir(bio),
> -				    bio->bi_iter.bi_sector, bio_sectors(bio),
> +		dm_stats_account_io(&io->md->stats, bio_data_dir(orig_bio),
> +				    orig_bio->bi_iter.bi_sector, bio_sectors(orig_bio),
>  				    false, 0, &io->stats_aux);
>  }
>  
> 

You cannot account using the orig_bio because it doesn't reflect
splits that occurred.  orig_bio will be updated to reflect the split
after __map_bio returns all the way back to dm_split_and_process_bio.

So there is no imbalance between start_io_acct and end_io_acct's calls
to dm_stats_account_io.

Also, in_flight counters don't (or shouldn't) care about the payload.

So again, I'm not following the reasoning on this patch.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

