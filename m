Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A131662FD
	for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 14:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720706886; cv=none; b=dpruGwfGMjZ4JPHgl2ditUejLomfQMs+xxME7jlWgyB89Igg5j/6nvDscZsSCApjmrGsTOVRHoEvCbGb+sQPkwsmtskH227Ksq0+mfjB+9YHQuJmqfv1dNUCOk/bFaymVEx3U67h8wjPJhsf4cXZHbOT1ZI2VsxeE5q8NSJ2pGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720706886; c=relaxed/simple;
	bh=fExN7iQu15s7NGPpjOlW8GY1Gd+TwefdMYVqPIgWcD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m5N+j3jkCQQFNBo/9VDSkrAeCNVJEBa1yM5nCorlhZkuCWHNsuCAhL03S0b2Y4qaCAUcKEbgRITvj5dyrCnbhc86rIgYZrdb/owuIY7U19qhAm62GGak+U4MAsJEh+JWEoq1Dv3gNckZqvFyIbKx1l62nttoZh32ZTM/ApI+t4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U+qtZeiY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U+qtZeiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D2DC32786;
	Thu, 11 Jul 2024 14:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720706886;
	bh=fExN7iQu15s7NGPpjOlW8GY1Gd+TwefdMYVqPIgWcD8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U+qtZeiYmAnQXZDOk87Denpm25MAnTHTM1otmslDNi5JSWTImIp5PWX4skc11DlHr
	 FZVFDBISaw3Q1SrS06TPKo0Msj/bv3Po9w5uBdrCyuEGlrbEH9upt5TcdvI9HEEl61
	 Yct46bFplW6wxj+6bgxv8o/5/bYoeoiHoC99dE0f6ZhcHDJDj6cI0c7wHzRms4/xCC
	 MypoDeUSPxGHTizCTdld7TptltD+fR0Rvjqr41QzalM5zV5N6co7T3C/HLTQXdpsBD
	 SGgUCOz+m90gSvZqBUmJwUCAGnjAkAK8VLPJIJw4MI7Kx5V/c1eIfUexkFrpn92hst
	 KOVDyJjdPztzQ==
Date: Thu, 11 Jul 2024 10:08:04 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Matthew Sakai <msakai@redhat.com>
Cc: dm-devel@lists.linux.dev, Bruce Johnston <bjohnsto@redhat.com>
Subject: Re: dm vdo: replace max_discard_sectors with max_hw_discard_sectors
Message-ID: <Zo_nRLC_Xp9Z4vQl@kernel.org>
References: <a99e5c45b2c8f7e85e2cd25d02560deb2120c4a3.1720640089.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a99e5c45b2c8f7e85e2cd25d02560deb2120c4a3.1720640089.git.msakai@redhat.com>

On Wed, Jul 10, 2024 at 03:37:30PM -0400, Matthew Sakai wrote:
> From: Bruce Johnston <bjohnsto@redhat.com>
> 
> Commit 4f563a64732d ("block: add a max_user_discard_sectors queue
> limit") changed block core to set max_discard_sectors to:
> min(lim->max_hw_discard_sectors, lim->max_user_discard_sectors)
> 
> Commit 825d8bbd2f32 ("dm: always manage discard support in terms
> of max_hw_discard_sectors") fixed most dm targetss to deal with
> this, by replacing max_discard_sectors with max_hw_discard_sectors.
> Unfortunately, dm-vdo did not get fixed at that time.
> 
> Fixes: 825d8bbd2f32 ("dm: always manage discard support in terms of max_hw_discard_sectors")
> Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
> Signed-off-by: Matthew Sakai <msakai@redhat.com>
> ---
>  drivers/md/dm-vdo/dm-vdo-target.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
> index 5a4b0a927f56..af77084969e0 100644
> --- a/drivers/md/dm-vdo/dm-vdo-target.c
> +++ b/drivers/md/dm-vdo/dm-vdo-target.c
> @@ -945,7 +945,7 @@ static void vdo_io_hints(struct dm_target *ti, struct queue_limits *limits)
>  	 * The value is used by dm-thin to determine whether to pass down discards. The block layer
>  	 * splits large discards on this boundary when this is set.
>  	 */
> -	limits->max_discard_sectors =
> +	limits->max_hw_discard_sectors =
>  		(vdo->device_config->max_discard_blocks * VDO_SECTORS_PER_BLOCK);
>  
>  	/*
> -- 
> 2.45.2
> 
> 

Not sure why I missed vdo, sorry about that.

Reviewed-by: Mike Snitzer <snitzer@kernel.org>
