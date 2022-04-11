Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50458C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 13:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649682142;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tekSyEHwVZruAjTNCqLtHiTXyyFydzwuWCVoeIbRc28=;
	b=DQacmbTZ+Cc93EFcen5Hm3dRRoca5dPvi1XGiG5vxiWxebIBf1VrIjLxEsBOT4wLCh97WH
	8rmybE/pfPj1oTdMOYC3AmwIbcpABTqKrHimGTa4jWgmB6NmaXprkf/bRqxCWpLecsR7sI
	K6nu6Hu1R5Qc2wGvJ8DDdmpMyie6FcE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-zbJtO9dCP6qliAMVZf9ajw-1; Mon, 11 Apr 2022 09:02:20 -0400
X-MC-Unique: zbJtO9dCP6qliAMVZf9ajw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C696286B8A6;
	Mon, 11 Apr 2022 13:02:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EE644429535;
	Mon, 11 Apr 2022 13:02:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AB2D619451F2;
	Mon, 11 Apr 2022 13:02:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9371119466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Apr 2022 13:02:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 60F1A40BB3F; Mon, 11 Apr 2022 13:02:14 +0000 (UTC)
Received: from T590 (ovpn-8-19.pek2.redhat.com [10.72.8.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C5DA41639E;
 Mon, 11 Apr 2022 13:02:10 +0000 (UTC)
Date: Mon, 11 Apr 2022 21:02:05 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Message-ID: <YlQmzcUmkwzi6meS@T590>
References: <20220411093838.1729001-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
In-Reply-To: <20220411093838.1729001-1-damien.lemoal@opensource.wdc.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH] dm: dm-zone: Fix NULL pointer dereference in
 dm_zone_map_bio()
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
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

On Mon, Apr 11, 2022 at 06:38:38PM +0900, Damien Le Moal wrote:
> Commit 0fbb4d93b38b ("dm: add dm_submit_bio_remap interface") changed
> the alloc_io() function to delay the initialization of struct dm_io
> orig_bio field, leaving this field as NULL until the first call to
> __split_and_process_bio() is executed for the user submitted BIO. This
> change causes a NULL pointer dereference in dm_zone_map_bio() when the
> original user BIO is inspected to detect the need for zone append
> command emulation.
> 
> Avoid this problem by adding a struct clone_info *ci argument to the
> __map_bio() function and a struct bio *orig_bio argument to
> dm_zone_map_bio(). Doing so, the call to dm_zone_map_bio() can be passed
> directly a pointer to the original user BIO using the bio field of
> struct clone_info.
> 
> Fixes: 0fbb4d93b38b ("dm: add dm_submit_bio_remap interface")
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---
>  drivers/md/dm-zone.c |  3 +--
>  drivers/md/dm.c      | 10 +++++-----
>  drivers/md/dm.h      |  5 +++--
>  3 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index c1ca9be4b79e..772161f0b029 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -513,13 +513,12 @@ static bool dm_need_zone_wp_tracking(struct bio *orig_bio)
>  /*
>   * Special IO mapping for targets needing zone append emulation.
>   */
> -int dm_zone_map_bio(struct dm_target_io *tio)
> +int dm_zone_map_bio(struct dm_target_io *tio, struct bio *orig_bio)
>  {
>  	struct dm_io *io = tio->io;
>  	struct dm_target *ti = tio->ti;
>  	struct mapped_device *md = io->md;
>  	struct request_queue *q = md->queue;
> -	struct bio *orig_bio = io->orig_bio;
>  	struct bio *clone = &tio->clone;
>  	unsigned int zno;
>  	blk_status_t sts;
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 3c5fad7c4ee6..1d8f24f04c7d 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1258,7 +1258,7 @@ static noinline void __set_swap_bios_limit(struct mapped_device *md, int latch)
>  	mutex_unlock(&md->swap_bios_lock);
>  }
>  
> -static void __map_bio(struct bio *clone)
> +static void __map_bio(struct clone_info *ci, struct bio *clone)
>  {
>  	struct dm_target_io *tio = clone_to_tio(clone);
>  	int r;
> @@ -1287,7 +1287,7 @@ static void __map_bio(struct bio *clone)
>  	 * map operation.
>  	 */
>  	if (dm_emulate_zone_append(io->md))
> -		r = dm_zone_map_bio(tio);
> +		r = dm_zone_map_bio(tio, ci->bio);

It depends if bio_split() in dm_split_and_process_bio() can be triggered
for dm-zone. If it can be triggered, here the actual original bio should
be the one returned from bio_split().

Thanks,
Ming
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

