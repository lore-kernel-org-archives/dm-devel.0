Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C050F28F948
	for <dm-devel@lists.linux.dev>; Fri, 11 Apr 2025 21:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744405948; cv=none; b=LUN4Dat+CwnObW3AN4T92UFdCHthLVeYcsbsUmwF8kxjzdAB5/nchz6WG63ACr6E5L8JDOlzxe7Q5m0NvtvWgFV1AF3inguPt22QsoGXLib0DQTpLlaJLVG5tAqem7o0Fz8nUuyTQYt+65a0QdtYm+nkGfkPDQ+kt7QUPYL13ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744405948; c=relaxed/simple;
	bh=dSlu1rEyvGLPFj2mt3I4W9pH7hiShmwh/LhpsJQiBic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=B0ox3PZT34B2V6dVtGOfixarKW0xUiIO8bpRfvD3nWZB9PkboSdD1Y70M9CaDf62NDIobwLTcG/FnbX7R1CuALE8q+OkpAbcZkSSTCBs0fWykFu9gn+kB/SyQrqYYN3OT8v0ITxwsI+O86HPzAMl5SSbbgWt9OEVC2e9BrwsBOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fbi3gMHt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fbi3gMHt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744405945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AVrHg4oiCC05IkrWLjhizrpFEBFDEJloyBFYu34R/bU=;
	b=Fbi3gMHtdXWdhuDpYx9gaYmp8Urn7gZ5ructZ0nQJpZNEBsdz+hWnWfKmI98nFupVC/AUi
	l6qnzz9Dol2iMbp9lTf4KAvceqNmowYjM7ox2qpV1V9pciMRkWQ3K+NZnqh3P8Y5XX9VOS
	2FmU7waDBZmor7zHwhFNsMdGuxLyqeQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-282-fxF5p6-LO3qZRZ_hFzDmeg-1; Fri,
 11 Apr 2025 17:12:24 -0400
X-MC-Unique: fxF5p6-LO3qZRZ_hFzDmeg-1
X-Mimecast-MFC-AGG-ID: fxF5p6-LO3qZRZ_hFzDmeg_1744405943
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C52BE180882E;
	Fri, 11 Apr 2025 21:12:22 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 206B63001D15;
	Fri, 11 Apr 2025 21:12:21 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53BLCKmS061248
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Apr 2025 17:12:20 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53BLCKLk061247;
	Fri, 11 Apr 2025 17:12:20 -0400
Date: Fri, 11 Apr 2025 17:12:20 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Damien Le Moal <dlemoal@kernel.org>,
        Christian Loehle <christian.loehle@arm.com>
Subject: Re: [PATCH] dm-delay: don't busy-wait in kthread
Message-ID: <Z_mFtK6H4CFdjHWZ@redhat.com>
References: <20250411205656.60709-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250411205656.60709-1-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YjZnAr2mi9lpRA5jWtnSYhIeCHiF2SkvyMXqs0v2zJ4_1744405943
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 11, 2025 at 04:56:56PM -0400, Benjamin Marzinski wrote:
> When using a kthread to delay the IOs, dm-delay would continuously loop,
> checking if IOs were ready to submit. It had a cond_resched() call in
> the loop, but might still loop hundreds of millions of times waiting for
> an IO that was scheduled to be submitted 10s of ms in the future. With
> the change to make dm-delay over zoned devices always use kthreads
> regardless of the length of the delay, this wasted work only gets worse.
> 
> To solve this and still keep roughly the same precision for very short
> delays, dm-delay now calls fsleep() for 1/8th of the smallest non-zero
> delay it will place on IOs, or 1 ms, whichever is smaller. The reason
> that dm-delay doesn't just use the actual expiration time of the next
> delayed IO to calculated the sleep time is that delay_dtr() must wait
> for the kthread to finish before deleting the table. If a zoned device
> with a long delay queued an IO shortly before being suspended and
> removed, the IO would be flushed in delay_presuspend(), but the removing
> the device would still have to wait for the remainder of the long delay.
> This time is now capped at 1 ms.

I just realized that this same issue can occur during suspending. If new
IOs come in while or after the IOs are flushed in delay_presuspend(),
they will wait until the kthread runs again, which is again capped at
1 ms.

> 
> Fixes: 70bbeb29fab09 ("dm delay: for short delays, use kthread instead of timers and wq")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> This patch is meant to apply on top of Damien Le Moal's "dm-delay:
> Prevent zoned write reordering on suspend" patch. If people think it's
> important to avoid either this much smaller amount of looping or the
> possible 1 ms delay on deleting a table, I can send a patch that uses
> usleep_range_state() and msleep_interruptible() to do an interruptible
> sleep with a duration based on the expiration time of the next delayed
> IO.
> 
>  drivers/md/dm-delay.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
> index c665b2ab1115..23027aa3fdca 100644
> --- a/drivers/md/dm-delay.c
> +++ b/drivers/md/dm-delay.c
> @@ -14,11 +14,14 @@
>  #include <linux/bio.h>
>  #include <linux/slab.h>
>  #include <linux/kthread.h>
> +#include <linux/delay.h>
>  
>  #include <linux/device-mapper.h>
>  
>  #define DM_MSG_PREFIX "delay"
>  
> +#define SLEEP_SHIFT 3
> +
>  struct delay_class {
>  	struct dm_dev *dev;
>  	sector_t start;
> @@ -34,6 +37,7 @@ struct delay_c {
>  	struct work_struct flush_expired_bios;
>  	struct list_head delayed_bios;
>  	struct task_struct *worker;
> +	unsigned int worker_sleep_ns;
>  	bool may_delay;
>  
>  	struct delay_class read;
> @@ -136,7 +140,8 @@ static int flush_worker_fn(void *data)
>  			schedule();
>  		} else {
>  			spin_unlock(&dc->delayed_bios_lock);
> -			cond_resched();
> +			if (dc->may_delay)
> +				fsleep(dc->worker_sleep_ns);
>  		}
>  	}
>  
> @@ -212,7 +217,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  {
>  	struct delay_c *dc;
>  	int ret;
> -	unsigned int max_delay;
> +	unsigned int max_delay, min_delay;
>  	bool is_zoned = false;
>  
>  	if (argc != 3 && argc != 6 && argc != 9) {
> @@ -236,7 +241,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	ret = delay_class_ctr(ti, &dc->read, argv);
>  	if (ret)
>  		goto bad;
> -	max_delay = dc->read.delay;
> +	min_delay = max_delay = dc->read.delay;
>  	is_zoned = bdev_is_zoned(dc->read.dev->bdev);
>  
>  	if (argc == 3) {
> @@ -253,6 +258,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	if (ret)
>  		goto bad;
>  	max_delay = max(max_delay, dc->write.delay);
> +	min_delay = min_not_zero(min_delay, dc->write.delay);
>  	is_zoned = is_zoned || bdev_is_zoned(dc->write.dev->bdev);
>  
>  	if (argc == 6) {
> @@ -266,6 +272,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	if (ret)
>  		goto bad;
>  	max_delay = max(max_delay, dc->flush.delay);
> +	min_delay = min_not_zero(min_delay, dc->flush.delay);
>  	is_zoned = is_zoned || bdev_is_zoned(dc->flush.dev->bdev);
>  
>  out:
> @@ -276,6 +283,10 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	 * suspend.
>  	 */
>  	if (max_delay < 50 || is_zoned) {
> +		if (min_delay >> SLEEP_SHIFT)
> +			dc->worker_sleep_ns = 1000;
> +		else
> +			dc->worker_sleep_ns = (min_delay * 1000) >> SLEEP_SHIFT;
>  		dc->worker = kthread_run(&flush_worker_fn, dc, "dm-delay-flush-worker");
>  		if (IS_ERR(dc->worker)) {
>  			ret = PTR_ERR(dc->worker);
> -- 
> 2.48.1
> 

