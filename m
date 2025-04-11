Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4495D2586C2
	for <dm-devel@lists.linux.dev>; Fri, 11 Apr 2025 21:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744405301; cv=none; b=aiGHqfplc2RI88HbgTPNh24B5ePmJ0nPqv761zP6g2im/lfD0K0g4HvjpxG4fIcYqjMiJ3JsUHhi5BnlDzeC8nfXn6iFEZgbmQL/1OHUGc7SknbSZAKtP9bnVsAlEjlkv58cL6qZKPvlncujmy4Tn9rD+nmN9F3Ja6neuxst7oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744405301; c=relaxed/simple;
	bh=IoIuFmhAx+APl5NzV/4j9dsD4Cu92U00MVA/5a/4iak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=fOSge57r4kXRkn+1f/B/Aj7VvDDZeHyJJfKKk4W2h+P7kRlprnp1UyaBoUU+H1heSXu6CXp3lMRbHYPizvA6LmLc5RaiN6Su6S9PpdsHgNpVR8Z3Sra8wiS3vE5HgW0b8Gr6M8jRM8XGVsy+ngK76+scjgTOhfJhjjRHbEzU018=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R0bGj1is; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R0bGj1is"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744405298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AKa+kaxen9QfSGmuRjvLDElfeadaFYtU8VA85lW9Xo0=;
	b=R0bGj1isia6V2hwYae45T25h7U4MtTJ+9KHerMcoAWSMs+yjk8RVlPOjkFOgyvdezxTbOG
	0eQvkcRYJo5oaSZbp9YXSAyO/Dh24OCpORotz9QuPtE2athfHaRWK5Ib7Jopf0/oM4KqBb
	5NcztCesKp4mLWGiJb/0pKiWzenCOQw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-611-tJ6YIo9NOXusSyKBHBVrXA-1; Fri,
 11 Apr 2025 17:01:35 -0400
X-MC-Unique: tJ6YIo9NOXusSyKBHBVrXA-1
X-Mimecast-MFC-AGG-ID: tJ6YIo9NOXusSyKBHBVrXA_1744405294
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A5BB91956080;
	Fri, 11 Apr 2025 21:01:33 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2EC951955BC1;
	Fri, 11 Apr 2025 21:01:33 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53BL1Vha060905
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Apr 2025 17:01:32 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53BL1VDt060904;
	Fri, 11 Apr 2025 17:01:31 -0400
Date: Fri, 11 Apr 2025 17:01:31 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] dm-delay: Prevent zoned write reordering on suspend
Message-ID: <Z_mDK_p7n-x4ThGO@redhat.com>
References: <20250411000435.1007720-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250411000435.1007720-1-dlemoal@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Wyt_qilTKyaymjBD-mt4C9uidccIEGh751u5XOhnmbk_1744405294
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 11, 2025 at 09:04:35AM +0900, Damien Le Moal wrote:
> When a dm-delay device is being suspended, the .presuspend() operation
> is first executed (delay_presuspend()) to immediately issue all the BIOs
> present in the delayed list of the device and also sets the device
> may_delay boolean to false. At the same time, if any new BIO is issued
> to the device will not be delayed and immediately issued with
> delay_bio() returning DM_MAPIO_REMAPPED. This creates a situation where
> potentially 2 different contexts may be issuing write BIOs to the same
> zone of a zone device without respecting the issuing order from the
> user, that is, a newly issued write BIO may be issued before other write
> BIOs for the same target zone that are in the device delayed list. If
> such situation occurs, write BIOs may be failed by the underlying zoned
> device due to an unaligned write error.
> 
> Prevent this situation from happening by always handling newly issued
> write BIOs using the delayed list of BIOs, even when the device is being
> suspended. This is done by forcing the use of the worker kthread for
> zoned devices, and by modifying flush_worker_fn() to always flush all
> delayed BIOs if the device may_delay boolean is false.
> 
> Reported-by: Benjamin Marzinski <bmarzins@redhat.com>
> Fixes: d43929ef65a6 ("dm-delay: support zoned devices")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

This looks fine, other than the issue that flush_worker_fn() busy-waits
for an IO to be ready, and now it could do that for much longer. But
I just submitted a patch to fix that, so:

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
> Changes from v1:
>  - Fixed typo in commit message
>  - Added reported-by tag
> 
>  drivers/md/dm-delay.c | 29 +++++++++++++++++++++--------
>  1 file changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
> index d4cf0ac2a7aa..c665b2ab1115 100644
> --- a/drivers/md/dm-delay.c
> +++ b/drivers/md/dm-delay.c
> @@ -128,7 +128,7 @@ static int flush_worker_fn(void *data)
>  	struct delay_c *dc = data;
>  
>  	while (!kthread_should_stop()) {
> -		flush_delayed_bios(dc, false);
> +		flush_delayed_bios(dc, !dc->may_delay);
>  		spin_lock(&dc->delayed_bios_lock);
>  		if (unlikely(list_empty(&dc->delayed_bios))) {
>  			set_current_state(TASK_INTERRUPTIBLE);
> @@ -213,6 +213,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	struct delay_c *dc;
>  	int ret;
>  	unsigned int max_delay;
> +	bool is_zoned = false;
>  
>  	if (argc != 3 && argc != 6 && argc != 9) {
>  		ti->error = "Requires exactly 3, 6 or 9 arguments";
> @@ -236,6 +237,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	if (ret)
>  		goto bad;
>  	max_delay = dc->read.delay;
> +	is_zoned = bdev_is_zoned(dc->read.dev->bdev);
>  
>  	if (argc == 3) {
>  		ret = delay_class_ctr(ti, &dc->write, argv);
> @@ -251,6 +253,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	if (ret)
>  		goto bad;
>  	max_delay = max(max_delay, dc->write.delay);
> +	is_zoned = is_zoned || bdev_is_zoned(dc->write.dev->bdev);
>  
>  	if (argc == 6) {
>  		ret = delay_class_ctr(ti, &dc->flush, argv + 3);
> @@ -263,13 +266,16 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	if (ret)
>  		goto bad;
>  	max_delay = max(max_delay, dc->flush.delay);
> +	is_zoned = is_zoned || bdev_is_zoned(dc->flush.dev->bdev);
>  
>  out:
> -	if (max_delay < 50) {
> -		/*
> -		 * In case of small requested delays, use kthread instead of
> -		 * timers and workqueue to achieve better latency.
> -		 */
> +	/*
> +	 * In case of small requested delays, use kthread instead of timers and
> +	 * workqueue to achieve better latency. Also use a kthread for a zoned
> +	 * device so that we can preserve the order of write operations during
> +	 * suspend.
> +	 */
> +	if (max_delay < 50 || is_zoned) {
>  		dc->worker = kthread_run(&flush_worker_fn, dc, "dm-delay-flush-worker");
>  		if (IS_ERR(dc->worker)) {
>  			ret = PTR_ERR(dc->worker);
> @@ -313,8 +319,15 @@ static int delay_bio(struct delay_c *dc, struct delay_class *c, struct bio *bio)
>  
>  	spin_lock(&dc->delayed_bios_lock);
>  	if (unlikely(!dc->may_delay)) {
> -		spin_unlock(&dc->delayed_bios_lock);
> -		return DM_MAPIO_REMAPPED;
> +		/*
> +		 * Issue the BIO immediately if the device is not zoned. FOr a
> +		 * zoned device, preserver the ordering of write operations by
> +		 * using the delay list.
> +		 */
> +		if (!bdev_is_zoned(c->dev->bdev) || c != &dc->write) {
> +			spin_unlock(&dc->delayed_bios_lock);
> +			return DM_MAPIO_REMAPPED;
> +		}
>  	}
>  	c->ops++;
>  	list_add_tail(&delayed->list, &dc->delayed_bios);
> -- 
> 2.49.0

