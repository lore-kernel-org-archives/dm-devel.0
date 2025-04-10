Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3151E9B02
	for <dm-devel@lists.linux.dev>; Thu, 10 Apr 2025 04:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744260242; cv=none; b=Pi8gsG1oACRTAuOtk/fHQLYpD8Ma412JJJ+wm55SZS2XcWzD+4/RVjuOStsHPz3j4dS2GvI8WoZX17pBt1nzlLBPKfSLN0M2+SD8p+fKGsFtfQu4PFIDEX9fvAI2f5i4sTkyC1TiXTMtgQAXNOHmma/aD7+gU5kn8s7hW75OE9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744260242; c=relaxed/simple;
	bh=A7wqZdcrkEzHwjFgbR3+z3RIVPjCNe3hBSVt0WKl3iE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=j2aek3+b9dgaGQarNyN/1j47gnAA/sbRcBBvvUZUFlU/YHOZwetVdiVyrL3ys1ZZWe6CxPioO1oiKRcF6aaNnTfvAtS/3JL/pgoAduW/VdtYsLSG4tepyoasFEKI2yY6+abGd+xHWcF6F1TrODFsCCoDXXR5y4fUic7GqxNBewY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CXiU69eg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CXiU69eg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23050C4CEDD;
	Thu, 10 Apr 2025 04:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744260241;
	bh=A7wqZdcrkEzHwjFgbR3+z3RIVPjCNe3hBSVt0WKl3iE=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=CXiU69egvqPDCvDDWg2qLrWeepQk16GhCZAKrHnbRxqT5qdVm6Gy6M7dpr3dTjEJA
	 Pmm0o+cwbaCqrm0nA+qrgK8dLRnBUP3MrZjmJLQmGPMKfZJIq2lzjLUSJIHHfT4EWL
	 ROiXWBmNEPUV+va7U2lG2e6BwrmIkOsoJq3j+ivrl8UDYgWfSgbpYLsSq6cn7eBcWw
	 Q1IKZ39myj6VPjFpMjnw/wG/2hVOo6pL1o06Ai7dvSJzRsW4QSJZ9079MASD/HtM8S
	 lcOvkGmUfaXWF4NmIpuGaLAxJcj1uBdmE9iwodxOx03f1UPlvcx5AE6NEAY4Pb4+XA
	 ScXGF7mU4MIcw==
Message-ID: <20f97fad-cc0b-4ef9-ba5c-b88a0949c49a@kernel.org>
Date: Thu, 10 Apr 2025 13:43:19 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-delay: Prevent zoned write reordering on suspend
From: Damien Le Moal <dlemoal@kernel.org>
To: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Benjamin Marzinski <bmarzins@redhat.com>
References: <20250410043311.990675-1-dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250410043311.990675-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/10/25 1:33 PM, Damien Le Moal wrote:
> When a dm-delay devie is being suspended, the .presuspend() operation is
> first executed (delay_presuspend()) to immediately issue all the BIOs
> present in the delayed list of the device and also sets the device
> may_delay boolean to false. At the same time, any new BIO is issued to
> the device will not be delayed and immediately issued with delay_bio()
> returning DM_MAPIO_REMAPPED. This creates a situation where potentially
> 2 different contexts may be issuing write BIOs to the same zone of a
> zone device without respecting the issuing order from the user, that is,
> a newly issued write BIO may be issued before other write BIOs for the
> same target zone that are in the device delayed list. If such situation
> occurs, write BIOs may be failed by the underlying zoned device due to
> an unaligned write error.
> 
> Prevent this situation from happening by always handling newly issued
> write BIOs using the delayed list of BIOs, even when the device is being
> suspended. This is done by forcing the use of the worker kthread for
> zoned devices, and by modifying flush_worker_fn() to always flush all
> delayed BIOs if the device may_delay boolean is false.
> 
> Fixes: d43929ef65a6 ("dm-delay: support zoned devices")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

I probably should also add:

Reported-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
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


-- 
Damien Le Moal
Western Digital Research
