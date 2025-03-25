Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0070D1A5B90
	for <dm-devel@lists.linux.dev>; Tue, 25 Mar 2025 17:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742924601; cv=none; b=EunVApxXDXClZbDVhnBEeWLRwaEPd4uYXDOtb+MDmlrxvE5h4Bavnjt69HtHzrKElscI7YvgyqFkDocNPU9BUkXocYg9wR8Y4OpXdmJPbhmS1JWHCBXJPB0DLYO3xig12bZhPjgz6dw+z+yK+CcQmU0/mIrRU1+REw1hNau23wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742924601; c=relaxed/simple;
	bh=kGx3rKSGENU9gKOiB29pU2/4zwJ79Y6b4hwKx/kZl+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RGHlTMVtyzGRzyO7b4qUJ2Dk4k/i0M08hTKI0B4fOp04YHgeuXK/3/AW9AkAxCRPiNafNCM/xWvudsWZtRsDxcL4d82pU6cDzUcU3+A+Etoik4zcd/LqosFdn6v7kY0g5VUCz9k63fR1YzQHbztHDXoj0wZYqU6K+h8V6+Kb04M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GIA8jETf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GIA8jETf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55666C4CEE4;
	Tue, 25 Mar 2025 17:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742924600;
	bh=kGx3rKSGENU9gKOiB29pU2/4zwJ79Y6b4hwKx/kZl+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GIA8jETf3pUMBpoLERsYej42fLQyEKBWEPAMiWAIATRrOUDgey9W7uCKvv284gXav
	 LlLZ8xKiEZyicbGTmzcPGsw+iBOMftXs13zvalf7aJTrqVRs6BIQRMmFZ/5aBZjkhh
	 6Ayb/WIzqNbVaw7eke6O3xHROwTOh814cBHK233XgZtdhufZOY5CxG0Hqf6XxumY8x
	 bNrFaQks7tXhZGvptvYOkWlU7nybzDVh5Csnm1HS0F/K0uR/WesNs9uh6Lmmb+fvgh
	 vpy04qb+HWq3g6CBBLtzqPWOSHiJGddIRAQRhd5YhCk5QG6YLzsXmege7DR50rcifo
	 LM/71wuCzjcZA==
Date: Tue, 25 Mar 2025 17:43:18 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: LongPing Wei <weilongping@oppo.com>
Cc: snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev,
	guoweichao@oppo.com, Eran Messeri <eranm@google.com>
Subject: Re: [PATCH] dm-verity: support block number limits for different
 ioprio classes
Message-ID: <20250325174318.GA559858@google.com>
References: <20250325104942.1170388-1-weilongping@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250325104942.1170388-1-weilongping@oppo.com>

Hi LongPing,

On Tue, Mar 25, 2025 at 06:49:43PM +0800, LongPing Wei wrote:
> Calling verity_verify_io in bh for IO of all sizes is not suitable for
> embedded devices. From our tests, it can improve the performance of 4K
> synchronise random reads.
> For example:
> ./fio --name=rand_read --ioengine=psync --rw=randread --bs=4K \
>  --direct=1 --numjobs=8 --runtime=60 --time_based --group_reporting \
>  --filename=/dev/block/mapper/xx-verity
> 
> But it will degrade the performance of 512K synchronise sequential reads
> on our devices.
> For example:
> ./fio --name=read --ioengine=psync --rw=read --bs=512K --direct=1 \
>  --numjobs=8 --runtime=60 --time_based --group_reporting \
>  --filename=/dev/block/mapper/xx-verity
> 
> A parameter array is introduced by this change. And users can modify the
> default config by /sys/module/dm_verity/parameters/use_bh_blocks.
> 
> The default limits for NONE/RT/BE/IDLE is set to UINT_MAX to keep the
> original behaviour.
> 
> Signed-off-by: LongPing Wei <weilongping@oppo.com>
> ---
>  drivers/md/dm-verity-target.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index e86c1431b108..1e0d0920d6a9 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -30,6 +30,7 @@
>  #define DM_VERITY_ENV_VAR_NAME		"DM_VERITY_ERR_BLOCK_NR"
>  
>  #define DM_VERITY_DEFAULT_PREFETCH_SIZE	262144
> +#define DM_VERITY_USE_BH_DEFAULT_BLOCKS	UINT_MAX
>  
>  #define DM_VERITY_MAX_CORRUPTED_ERRS	100
>  
> @@ -49,6 +50,15 @@ static unsigned int dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE
>  
>  module_param_named(prefetch_cluster, dm_verity_prefetch_cluster, uint, 0644);
>  
> +static unsigned int dm_verity_use_bh_blocks[4] = {
> +	DM_VERITY_USE_BH_DEFAULT_BLOCKS,	// IOPRIO_CLASS_NONE
> +	DM_VERITY_USE_BH_DEFAULT_BLOCKS,	// IOPRIO_CLASS_RT
> +	DM_VERITY_USE_BH_DEFAULT_BLOCKS,	// IOPRIO_CLASS_BE
> +	DM_VERITY_USE_BH_DEFAULT_BLOCKS		// IOPRIO_CLASS_IDLE
> +};
> +
> +module_param_array_named(use_bh_blocks, dm_verity_use_bh_blocks, uint, NULL, 0644);
> +
>  static DEFINE_STATIC_KEY_FALSE(use_bh_wq_enabled);
>  
>  /* Is at least one dm-verity instance using ahash_tfm instead of shash_tfm? */
> @@ -652,6 +662,12 @@ static void verity_bh_work(struct work_struct *w)
>  	verity_finish_io(io, errno_to_blk_status(err));
>  }
>  
> +static inline bool verity_use_bh(unsigned int n_blocks, unsigned short ioprio)
> +{
> +	return ioprio <= IOPRIO_CLASS_IDLE &&
> +		n_blocks <= READ_ONCE(dm_verity_use_bh_blocks[ioprio]);
> +}
> +
>  static void verity_end_io(struct bio *bio)
>  {
>  	struct dm_verity_io *io = bio->bi_private;
> @@ -664,7 +680,8 @@ static void verity_end_io(struct bio *bio)
>  		return;
>  	}
>  
> -	if (static_branch_unlikely(&use_bh_wq_enabled) && io->v->use_bh_wq) {
> +	if (static_branch_unlikely(&use_bh_wq_enabled) && io->v->use_bh_wq &&
> +		verity_use_bh(io->n_blocks, IOPRIO_PRIO_CLASS(bio->bi_ioprio))) {
>  		INIT_WORK(&io->bh_work, verity_bh_work);
>  		queue_work(system_bh_wq, &io->bh_work);

Thanks for working on this and sending a patch!

Just for some background: "try_verify_in_tasklet" was originally developed for
use in Android, but it did not actually end up being used there because of
concern about softirqs interfering with real-time tasks.  Yet, the scheduling
delay in dm-verity remains a problem.  I think that opportunistically doing the
verity work in softirq context remains promising (not necessarily ideal, but
helpful in practice), especially in cases where the block softirq already has to
run so the work can just be done in-line.  dm-verity mainly just needs to be
smarter about whether it chooses to use softirq or kworker for each request.

Choosing softirq context only for short requests seems helpful, and it's the
same idea I had.  In practice, dm-verity I/O request lengths have a bimodal
distribution with peaks at 4 KiB for synchronous reads and 128 KiB for
readahead.  These cases are quite different, and it makes sense that different
solutions could be optimal for them.  SHA-256 hashing a 4 KiB block takes only
2-6 microseconds, so there is not much reason to punt it to a kworker.

Taking the I/O priority into account makes sense too.  In theory, the higher the
priority, the more softirq should be preferred.  Though, I do wonder if almost
all the benefit actually just comes from the 4 KiB case, in which case there
would not be much reason to bother looking the I/O priority.

FWIW, other ideas that I have are:

    - When possible, make dm-verity do the work inline in the existing block
      softirq, instead of using the BH workqueue.  This would reduce the amount
      of overhead.  Note that dm-crypt does it this way.

    - If the CPU has been in softirq context for too long, then stop choosing
      softirq context and instead fall back to the traditional workqueue.  This
      could help address objections about increased use of softirq context.

But this patch seems like a good start.

> The default limits for NONE/RT/BE/IDLE is set to UINT_MAX to keep the
> original behaviour.

Let's just set good parameters by default instead.  "try_verify_in_tasklet" is
kind of useless as-is, and we should just fix it.  Especially since it only
affects performance and not other behavior, I don't think there are any
compatibility concerns with changing what it does exactly.

- Eric
