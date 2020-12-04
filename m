Return-Path: <SRS0=D9Ri=FI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB495C433FE
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 17:50:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DD2BB22AAD
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 17:50:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD2BB22AAD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1607104218;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rXNCqBorZIYwkDDgOzqLEURfUKc4HZRettV+cEn+A0w=;
	b=OMBeOVaNUN1PO/9IGE8Gmo15aVThPocCuvSoEZSy1I825bMNZmH52eLnIyb0i5TwC55H6r
	BIF9MiQgSuD7bdpsx+4h968em8KEiH8BtXsLUC+wlQNdsWwsz8ASeRO6aMQd3i0aHo589Z
	KyktEPX6+bph5wpDZ2sQyx1/txqAjQI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-hk9Vxi86MEWpnsbu7-XnlA-1; Fri, 04 Dec 2020 12:50:16 -0500
X-MC-Unique: hk9Vxi86MEWpnsbu7-XnlA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84760107ACF5;
	Fri,  4 Dec 2020 17:50:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 79F951349A;
	Fri,  4 Dec 2020 17:50:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A42A44BB7B;
	Fri,  4 Dec 2020 17:50:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B4Ho6uo017248 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Dec 2020 12:50:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4BCDE2166B32; Fri,  4 Dec 2020 17:50:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 472652166B2F
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 17:50:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0985310580C1
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 17:50:04 +0000 (UTC)
Received: from mail-qt1-f196.google.com (mail-qt1-f196.google.com
	[209.85.160.196]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-288-eI06SyfDNOu-7eP6lOtZtQ-1; Fri, 04 Dec 2020 12:49:59 -0500
X-MC-Unique: eI06SyfDNOu-7eP6lOtZtQ-1
Received: by mail-qt1-f196.google.com with SMTP id z9so4531597qtn.4;
	Fri, 04 Dec 2020 09:49:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=oitHTfBdVphAOM+mbFAdZYptH/VPFC/0n1/PDOfj93Y=;
	b=YnOrCq33m3nULLcs2gG93J+9AQapLq+xPEm7jyQPg4nmqxvrV1YTgULblhI9mz+grP
	dCRtR7Bg0pWbLufQjlhzwt5euwUswehtYetg5L1wp/DX6V7jkVrv8uEvc1+8gmb0nXtn
	2LuNXUCq38AJ93YQS3EmfUqPVNRpBQIZP2EPEnVMiM6DCP98oGg6+bf9Ay8Ac0V64GgP
	0CNf1W6jzCopi2/FnB6xf99g8xSU0vvwwgfcSLZy3yDW85007EuoLDVj6ic6Quf1M7s/
	JIK2nPUKY+kTxWe5z/IuCwiO45kwAyX4XJeFkcFMR+hiX3ORlPR5YgcC9hNxjttPDUab
	fJhQ==
X-Gm-Message-State: AOAM532lR4cTrGl8nRNuxbjOk02QZIJaQyUIdqDePiQtsNp1CQfCExNH
	t2bIVcb5SUrc/pBNBYUuLfek7vgtKx0O3A==
X-Google-Smtp-Source: ABdhPJyPbVuo1ABXSDkwor+v9nZkKMGg0Vz3OqeqMWB2otHrjLqpPIPjyf/Ul5xGTD7DxsuPvyJ5ig==
X-Received: by 2002:ac8:7395:: with SMTP id t21mr10555669qtp.358.1607104198922;
	Fri, 04 Dec 2020 09:49:58 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	r18sm5554061qtp.89.2020.12.04.09.49.58
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 04 Dec 2020 09:49:58 -0800 (PST)
Date: Fri, 4 Dec 2020 12:49:57 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Ming Lei <ming.lei@redhat.com>, axboe@kernel.dk
Message-ID: <20201204174957.GA61818@lobo>
References: <20201130171805.77712-1-snitzer@redhat.com>
	<20201201160709.31748-1-snitzer@redhat.com>
	<20201203032608.GD540033@T590> <20201203143359.GA29261@redhat.com>
	<20201204011243.GB661914@T590> <20201204020343.GA32150@redhat.com>
	<20201204035924.GD661914@T590> <20201204164759.GA2761@redhat.com>
	<20201204173238.GA59222@lobo>
MIME-Version: 1.0
In-Reply-To: <20201204173238.GA59222@lobo>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, bjohnsto@redhat.com,
	jdorminy@redhat.com, martin.petersen@oracle.com
Subject: Re: [dm-devel] [RFC PATCH] dm: fix IO splitting [was: Re: [PATCH
 v2] block: use gcd() to fix chunk_sectors limit stacking]
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Dec 04 2020 at 12:32P -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Fri, Dec 04 2020 at 11:47P -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > On Thu, Dec 03 2020 at 10:59pm -0500,
> > Ming Lei <ming.lei@redhat.com> wrote:
> > 
> > > On Thu, Dec 03, 2020 at 09:03:43PM -0500, Mike Snitzer wrote:
> > > > Stacking chunk_sectors seems ill-conceived.  One size-fits-all splitting
> > > > is too rigid.
> > > 
> > > DM/VDO knows exactly it is one hard chunk_sectors limit, and DM shouldn't play
> > > the stacking trick on VDO's chunk_sectors limit, should it?
> > 
> > Feel like I already answered this in detail but... correct, DM cannot
> > and should not use stacked chunk_sectors as basis for splitting.
> > 
> > Up until 5.9, where I changed DM core to set and then use chunk_sectors
> > for splitting via blk_max_size_offset(), DM only used its own per-target
> > ti->max_io_len in drivers/md/dm.c:max_io_len().
> > 
> > But I reverted back to DM's pre-5.9 splitting in this stable@ fix that
> > I'll be sending to Linus today for 5.10-rcX:
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.10-rcX&id=6bb38bcc33bf3093c08bd1b71e4f20c82bb60dd1
> > 
> > DM is now back to pre-5.9 behavior where it doesn't even consider
> > chunk_sectors for splitting (NOTE: dm-zoned sets ti->max_io_len though
> > so it is effectively achieves the same boundary splits via max_io_len).
> 
> Last question for all, I'd be fine with the following fix instead of
> the above referenced commit 6bb38bcc33. It'd allow DM to continue to
> use blk_max_size_offset(), any opinions?
> 
> From: Mike Snitzer <snitzer@redhat.com>
> Date: Fri, 4 Dec 2020 12:03:25 -0500
> Subject: [RFC PATCH] dm: fix IO splitting
> 
> FIXME: add proper header
> Add chunk_sectors override to blk_max_size_offset().
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  block/blk-merge.c      |  2 +-
>  drivers/md/dm-table.c  |  5 -----
>  drivers/md/dm.c        | 19 +++++++++++--------
>  include/linux/blkdev.h |  9 +++++----
>  4 files changed, 17 insertions(+), 18 deletions(-)
> 
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index bcf5e4580603..97b7c2821565 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -144,7 +144,7 @@ static struct bio *blk_bio_write_same_split(struct request_queue *q,
>  static inline unsigned get_max_io_size(struct request_queue *q,
>  				       struct bio *bio)
>  {
> -	unsigned sectors = blk_max_size_offset(q, bio->bi_iter.bi_sector);
> +	unsigned sectors = blk_max_size_offset(q, bio->bi_iter.bi_sector, 0);
>  	unsigned max_sectors = sectors;
>  	unsigned pbs = queue_physical_block_size(q) >> SECTOR_SHIFT;
>  	unsigned lbs = queue_logical_block_size(q) >> SECTOR_SHIFT;
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 2073ee8d18f4..7eeb7c4169c9 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -18,7 +18,6 @@
>  #include <linux/mutex.h>
>  #include <linux/delay.h>
>  #include <linux/atomic.h>
> -#include <linux/lcm.h>
>  #include <linux/blk-mq.h>
>  #include <linux/mount.h>
>  #include <linux/dax.h>
> @@ -1449,10 +1448,6 @@ int dm_calculate_queue_limits(struct dm_table *table,
>  			zone_sectors = ti_limits.chunk_sectors;
>  		}
>  
> -		/* Stack chunk_sectors if target-specific splitting is required */
> -		if (ti->max_io_len)
> -			ti_limits.chunk_sectors = lcm_not_zero(ti->max_io_len,
> -							       ti_limits.chunk_sectors);
>  		/* Set I/O hints portion of queue limits */
>  		if (ti->type->io_hints)
>  			ti->type->io_hints(ti, &ti_limits);
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 98866e725f25..f7eb3d2964f3 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1039,15 +1039,18 @@ static sector_t max_io_len(struct dm_target *ti, sector_t sector)
>  	sector_t max_len;
>  
>  	/*
> -	 * Does the target need to split even further?
> -	 * - q->limits.chunk_sectors reflects ti->max_io_len so
> -	 *   blk_max_size_offset() provides required splitting.
> -	 * - blk_max_size_offset() also respects q->limits.max_sectors
> +	 * Does the target need to split IO even further?
> +	 * - varied (per target) IO splitting is a tenet of DM; this
> +	 *   explains why stacked chunk_sectors based splitting via
> +	 *   blk_max_size_offset() isn't possible here. So pass in
> +	 *   ti->max_io_len to override stacked chunk_sectors.
>  	 */
> -	max_len = blk_max_size_offset(ti->table->md->queue,
> -				      target_offset);
> -	if (len > max_len)
> -		len = max_len;
> +	if (ti->max_io_len) {
> +		max_len = blk_max_size_offset(ti->table->md->queue,
> +					      target_offset, ti->max_io_len);
> +		if (len > max_len)
> +			len = max_len;
> +	}
>  
>  	return len;
>  }
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 639cae2c158b..f56dc5497e67 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1073,11 +1073,12 @@ static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
>   * file system requests.
>   */
>  static inline unsigned int blk_max_size_offset(struct request_queue *q,
> -					       sector_t offset)
> +					       sector_t offset,
> +					       unsigned int chunk_sectors)
>  {
> -	unsigned int chunk_sectors = q->limits.chunk_sectors;
> -
> -	if (!chunk_sectors)
> +	if (!chunk_sectors && q->limits.chunk_sectors)
> +		chunk_sectors = q->limits.chunk_sectors;
> +	else
>  		return q->limits.max_sectors;
>  
>  	if (likely(is_power_of_2(chunk_sectors)))

FYI, above blkdev.h diff missed this hunk:

@@ -1101,7 +1102,7 @@ static inline unsigned int blk_rq_get_max_sectors(struct request *rq,
 	    req_op(rq) == REQ_OP_SECURE_ERASE)
 		return blk_queue_get_max_sectors(q, req_op(rq));
 
-	return min(blk_max_size_offset(q, offset),
+	return min(blk_max_size_offset(q, offset, 0),
 			blk_queue_get_max_sectors(q, req_op(rq)));
 }
 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

