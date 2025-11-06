Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924BA42AB7
	for <dm-devel@lists.linux.dev>; Thu,  6 Nov 2025 02:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762394664; cv=none; b=OYeIl6x1e2Z6/zMONESQxmPcQc6mZaS5yC+6BOrEFsvQ4ZRZpXqXEU4KQ3K+G2YpiSrNrORgI1evorFbpCqWpsQpxAt39XM4qhSKH6jXpYaO5OQAHa5yefEz8eHKFwD0PCrnlM+te/IUS4/InokqnhHORWU+Jp8kJ+jXom3xNN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762394664; c=relaxed/simple;
	bh=krhoiNW+NyPlB6EfCGLM5qaBK43SI0xb8Va+uLcZIOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=VRBgwZR3vI+Gn5zYK7+BxF/GN07eJzlFgOgj/Ct4lMBkWK+8D2xwKiggJD8XEeleSVeX1uPLK973sIBZo3R8dMo6xBeWTLue14BVE97yCw+CXbA3kmyvbuTl1TmadUqYvHpmerJuSZPhjcTl76QHdA+9Ea7ZvB3bDQCVdKAFA14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YAKqjrUt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YAKqjrUt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762394660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cTp366EL8cLzJWxfYmoXYHEzl7bHYZLJpN/G1zNoVGg=;
	b=YAKqjrUtYeQPjodADjaocXmYMxZpOxs9GDFbFi9GEOPFIqjMCbS4PsgZWbGm1/YfkRtzab
	ZkCo2cEwNjH3tKPBZlTU28VXKIoTsMSuBsgrV/1yb5HpOk0go2o+8DrUzrzsjJWGGLqfYy
	mSTDH5IH8XPZ3Q1NPs4rkpv9Dr11wTw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-669-2sjZopMuN6qzKNzbQlIXng-1; Wed,
 05 Nov 2025 21:04:17 -0500
X-MC-Unique: 2sjZopMuN6qzKNzbQlIXng-1
X-Mimecast-MFC-AGG-ID: 2sjZopMuN6qzKNzbQlIXng_1762394656
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 17D8E19560A5;
	Thu,  6 Nov 2025 02:04:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A8D8A3000198;
	Thu,  6 Nov 2025 02:04:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5A624Ekh411076
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 5 Nov 2025 21:04:14 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5A624EA7411075;
	Wed, 5 Nov 2025 21:04:14 -0500
Date: Wed, 5 Nov 2025 21:04:14 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: John Garry <john.g.garry@oracle.com>, agk@redhat.com, snitzer@kernel.org,
        dm-devel@lists.linux.dev, michael.christie@oracle.com,
        martin.petersen@oracle.com
Subject: Re: [PATCH 2/2] dm-crypt: enable DM_TARGET_ATOMIC_WRITES
Message-ID: <aQwCHqrdNMy1wy75@redhat.com>
References: <e0b99d8e-1159-a489-6df3-648b21c4f091@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <e0b99d8e-1159-a489-6df3-648b21c4f091@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RpPrqGs1QVOBWi-G_nLVJoZk_mzwdv7VKZlwlNBZgwg_1762394656
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 05, 2025 at 04:02:36PM +0100, Mikulas Patocka wrote:
> Allow handling of bios with REQ_ATOMIC flag set.
> 
> Don't split these bios and fail them if they overrun the hard limit
> "BIO_MAX_VECS << PAGE_SHIFT".
> 
> This commit joins the logic that avoids splitting emulated zone append
> bios with atomic write bios.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm-crypt.c |   39 ++++++++++++++++++++++++---------------
>  1 file changed, 24 insertions(+), 15 deletions(-)
> 
> Index: linux-2.6/drivers/md/dm-crypt.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-crypt.c	2025-11-05 14:50:28.000000000 +0100
> +++ linux-2.6/drivers/md/dm-crypt.c	2025-11-05 14:50:28.000000000 +0100
> @@ -254,22 +254,15 @@ static unsigned int max_write_size = 0;
>  module_param(max_write_size, uint, 0644);
>  MODULE_PARM_DESC(max_write_size, "Maximum size of a write request");
>  
> -static unsigned get_max_request_sectors(struct dm_target *ti, struct bio *bio)
> +static unsigned get_max_request_sectors(struct dm_target *ti, struct bio *bio, bool no_split)
>  {
>  	struct crypt_config *cc = ti->private;
>  	unsigned val, sector_align;
>  	bool wrt = op_is_write(bio_op(bio));
>  
> -	if (wrt) {
> -		/*
> -		 * For zoned devices, splitting write operations creates the
> -		 * risk of deadlocking queue freeze operations with zone write
> -		 * plugging BIO work when the reminder of a split BIO is
> -		 * issued. So always allow the entire BIO to proceed.
> -		 */
> -		if (ti->emulate_zone_append)
> -			return bio_sectors(bio);
> -
> +	if (no_split) {
> +		val = -1;
> +	} else if (wrt) {
>  		val = min_not_zero(READ_ONCE(max_write_size),
>  				   DM_CRYPT_DEFAULT_MAX_WRITE_SIZE);
>  	} else {
> @@ -3496,6 +3489,7 @@ static int crypt_map(struct dm_target *t
>  	struct dm_crypt_io *io;
>  	struct crypt_config *cc = ti->private;
>  	unsigned max_sectors;
> +	bool no_split;
>  
>  	/*
>  	 * If bio is REQ_PREFLUSH or REQ_OP_DISCARD, just bypass crypt queues.
> @@ -3513,10 +3507,20 @@ static int crypt_map(struct dm_target *t
>  
>  	/*
>  	 * Check if bio is too large, split as needed.
> -	 */
> -	max_sectors = get_max_request_sectors(ti, bio);
> -	if (unlikely(bio_sectors(bio) > max_sectors))
> +	 *
> +	 * For zoned devices, splitting write operations creates the
> +	 * risk of deadlocking queue freeze operations with zone write
> +	 * plugging BIO work when the reminder of a split BIO is
> +	 * issued. So always allow the entire BIO to proceed.
> +	 */
> +	no_split = (ti->emulate_zone_append && op_is_write(bio_op(bio))) ||
> +		   (bio->bi_opf & REQ_ATOMIC);
> +	max_sectors = get_max_request_sectors(ti, bio, no_split);
> +	if (unlikely(bio_sectors(bio) > max_sectors)) {
> +		if (unlikely(no_split))
> +			return DM_MAPIO_KILL;
>  		dm_accept_partial_bio(bio, max_sectors);
> +	}
>  
>  	/*
>  	 * Ensure that bio is a multiple of internal sector encryption size
> @@ -3762,6 +3766,11 @@ static void crypt_io_hints(struct dm_tar
>  	if (ti->emulate_zone_append)
>  		limits->max_hw_sectors = min(limits->max_hw_sectors,
>  					     BIO_MAX_VECS << PAGE_SECTORS_SHIFT);
> +
> +	limits->atomic_write_hw_unit_max = min(limits->atomic_write_hw_unit_max,
> +					       BIO_MAX_VECS << PAGE_SHIFT);
> +	limits->atomic_write_hw_max = min(limits->atomic_write_hw_max,
> +					  BIO_MAX_VECS << PAGE_SHIFT);
>  }

Do we need to cap these limits, instead of just accepting the underlying
device limits? Neither of them are really used for IO.
atomic_write_unit_max, which is used for IO, will already get a capped
value from atomic_write_hw_unit_max in
blk_atomic_writes_update_limits(). And capping atomic_write_hw_max seems
wrong, since atomic_write_hw_max == UINT_MAX is used
blk_validate_atomic_write_limits() to indicate that atomic writes were
never set up, because no underlying device supported them. I don't think
these caps will actually break things, but in my mind they make some
already confusing limits even more confusing. 

Or am I missing some reason why this is needed?

-Ben

>  
>  static struct target_type crypt_target = {
> @@ -3770,7 +3779,7 @@ static struct target_type crypt_target =
>  	.module = THIS_MODULE,
>  	.ctr    = crypt_ctr,
>  	.dtr    = crypt_dtr,
> -	.features = DM_TARGET_ZONED_HM,
> +	.features = DM_TARGET_ZONED_HM | DM_TARGET_ATOMIC_WRITES,
>  	.report_zones = crypt_report_zones,
>  	.map    = crypt_map,
>  	.status = crypt_status,
> 

