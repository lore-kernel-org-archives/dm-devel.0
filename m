Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162AA275AF0
	for <dm-devel@lists.linux.dev>; Wed, 10 Dec 2025 06:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765346859; cv=none; b=ToDt00zltxUHSkxkYo0PHZ1uD1qikN+LNaWXotYXFP3NrUmwFaEGw1+F+vCbY6G5Z6zYzW9nLpjvKSoRy26mAznoFWHOia9dzMJ15jH+MU2bDkZx+lMO5mdcF77I1tsoa14Rcpfnn05d+sYDjaIiFVaCC/32hCWRdYQnVbdS8Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765346859; c=relaxed/simple;
	bh=bp5x0k6+GiJPki9TURchoV6Lwnbe6pMk2wz9kWTzDWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=I+Yk7EdwAz5l1pO+usyNdwcgevHkvFFcXmDQe2BZCK501BmI8JuRClL4lreuTC6Abj9zBjd8QXofTNiPfbnWdynlBxZi5GXaKkHQTu8TRWogSRtzYtoDEiYYYcBw6Q7i/Hjh/PC6NmcQQPnsHxorVSdIb1lsTLlUB7jFL8T78AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d4USnO4Q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d4USnO4Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765346855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/jKMe2I68qBFv9MHU05C2Iet4e7pdQsbuku7jvua0LQ=;
	b=d4USnO4Q+anMPZRp6l+Jw2Ca/TXZTE4Dh3WS8K0mvQibmZFpVwpbp4PBPbkMZkGYi8yu9/
	Tpt6yl7qEhOXl4liw2q/Sx+1diOhwVPdx4Yw/XRAtSv/bfi/Mg6tlGwwuUXo1ALWP+Nlbs
	uvXN30FLgjJhtmPvTMuNYwalUnX30R8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-693-YtVA-HTbMNCYXui4Y6Eypg-1; Wed,
 10 Dec 2025 01:07:34 -0500
X-MC-Unique: YtVA-HTbMNCYXui4Y6Eypg-1
X-Mimecast-MFC-AGG-ID: YtVA-HTbMNCYXui4Y6Eypg_1765346853
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3252E18002C0;
	Wed, 10 Dec 2025 06:07:33 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A799530001A5;
	Wed, 10 Dec 2025 06:07:32 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5BA67VAR1767619
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 10 Dec 2025 01:07:31 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5BA67VdU1767618;
	Wed, 10 Dec 2025 01:07:31 -0500
Date: Wed, 10 Dec 2025 01:07:31 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Yongpeng Yang <yangyongpeng.storage@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
        Yongpeng Yang <yangyongpeng@xiaomi.com>
Subject: Re: [PATCH 1/1] dm-stripe: adjust max_hw_discard_sectors to avoid
 unnecessary discard bio splitting
Message-ID: <aTkOIzJVOcEJB7SU@redhat.com>
References: <20251208100713.697542-2-yangyongpeng.storage@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251208100713.697542-2-yangyongpeng.storage@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aifd-9i7yWvEq9Bon8YQ3UTDqyTfGcLoK3meBpBzqTo_1765346853
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Dec 08, 2025 at 06:07:14PM +0800, Yongpeng Yang wrote:
> From: Yongpeng Yang <yangyongpeng@xiaomi.com>
> 
> Currently, the max_hw_discard_sectors of a stripe target is set to the
> minimum max_hw_discard_sectors among all sub devices. When the discard
> bio is larger than max_hw_discard_sectors, this may cause the stripe
> device to split discard bios unnecessarily, because the value of
> max_hw_discard_sectors affects max_discard_sectors, which equal to
> min(max_hw_discard_sectors, max_user_discard_sectors).
> 
> For example:
> root@vm:~# echo '0 33554432 striped 2 256 /dev/vdd 0 /dev/vde 0' | dmsetup create stripe_dev
> root@vm:~# cat /sys/block/dm-1/queue/discard_max_bytes
> 536870912
> root@vm:~# cat /sys/block/dm-1/slaves/vdd/queue/discard_max_bytes
> 536870912
> root@vm:~# blkdiscard -o 0 -l 1073741824 -p 1073741824 /dev/mapper/stripe_dev
> 
> dm-1 is the stripe device, and its discard_max_bytes is equal to
> each sub device’s discard_max_bytes. Since the requested discard
> length exceeds discard_max_bytes, the block layer splits the discard bio:
> 
> block_bio_queue: 252,1 DS 0 + 2097152 [blkdiscard]
> block_split: 252,1 DS 0 / 1048576 [blkdiscard]
> block_rq_issue: 253,48 DS 268435456 () 0 + 524288 be,0,4 [blkdiscard]
> block_bio_queue: 253,64 DS 524288 + 524288 [blkdiscard]
> 
> However, both vdd and vde can actually handle a discard bio of 536870912
> bytes, so this split is not necessary.
> 
> This patch updates the stripe target’s q->limits.max_hw_discard_sectors
> to be the minimum max_hw_discard_sectors of the sub devices multiplied
> by the # of stripe devices. This enables the stripe device to handle
> larger discard bios without incurring unnecessary splitting.
> 
> Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
> ---
>  drivers/md/dm-stripe.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
> index 1461dc740dae..799d6def699b 100644
> --- a/drivers/md/dm-stripe.c
> +++ b/drivers/md/dm-stripe.c
> @@ -38,6 +38,9 @@ struct stripe_c {
>  	uint32_t chunk_size;
>  	int chunk_size_shift;
>  
> +	/* The minimum max_hw_discard_sectors of all sub devices. */
> +	unsigned int max_hw_discard_sectors;
> +
>  	/* Needed for handling events */
>  	struct dm_target *ti;
>  
> @@ -169,6 +172,8 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	 * Get the stripe destinations.
>  	 */
>  	for (i = 0; i < stripes; i++) {
> +		struct request_queue *q;
> +
>  		argv += 2;
>  
>  		r = get_stripe(ti, sc, i, argv);
> @@ -180,6 +185,13 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  			return r;
>  		}
>  		atomic_set(&(sc->stripe[i].error_count), 0);
> +
> +		q = bdev_get_queue(sc->stripe[i].dev->bdev);
> +		if (i == 0)
> +			sc->max_hw_discard_sectors = q->limits.max_hw_discard_sectors;
> +		else
> +			sc->max_hw_discard_sectors = min_not_zero(sc->max_hw_discard_sectors,
> +					q->limits.max_hw_discard_sectors);

I don't think any of the above is necessary. When stripe_io_hints() is
called, dm_set_device_limits() will already have been called on all the
underlying stripe devices to combine the limits. So
limits->max_hw_discard_sectors should already be set to the same value
as you're computing for sc->max_hw_discard_sectors. Right?

>  	}
>  
>  	ti->private = sc;
> @@ -456,7 +468,7 @@ static void stripe_io_hints(struct dm_target *ti,
>  			    struct queue_limits *limits)
>  {
>  	struct stripe_c *sc = ti->private;
> -	unsigned int io_min, io_opt;
> +	unsigned int io_min, io_opt, max_hw_discard_sectors;
>  
>  	limits->chunk_sectors = sc->chunk_size;
>  
> @@ -465,6 +477,8 @@ static void stripe_io_hints(struct dm_target *ti,
>  		limits->io_min = io_min;
>  		limits->io_opt = io_opt;
>  	}
> +	if (!check_mul_overflow(sc->max_hw_discard_sectors, sc->stripes, &max_hw_discard_sectors))

sc->max_hw_discard_sectors should be the same as
limits->max_hw_discard_sectors here 

> +		limits->max_hw_discard_sectors = max_hw_discard_sectors;

I see a couple of issues with this calculation. First, this only works
if max_hw_discard_sectors is greater than sc->chunk_size. But more than
that, before you multiply the original limit by the number of stripes,
you must round it down to a multiple of chunk_size. Otherwise, you can
end up writing too much to some of the underlying devices. To show this
with simple numbers, imagine you had 3 stripes that with a chunk_size of
4 and all the underlying devices had a max_hw_discard_sectors of 5. You
would set max_hw_discard_sectors to 5 * 3 = 15. But if you discared 15
sectors from the beginning of the device, you would end up discarding
the first 4 sectors of each underlying device, and then loop around
discard 3 more sectors of the first device. This means that you would
discard 7 from the first device, instead of the 5 that it could handle.
Rounding max_hw_discard_sectors down to a multiple of chunk_size will
fix that.

Lastly, if you do overflow when multiplying max_hw_discard_sectors by
the number of stripes, you should probably just set
limits->max_hw_discard_sectors to UINT_MAX >> SECTOR_SHIFT, instead of
leaving it at what it was.

-Ben

>  }
>  
>  static struct target_type stripe_target = {
> -- 
> 2.43.0

