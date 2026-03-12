Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42DD31E82C;
	Thu, 12 Mar 2026 06:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773297393; cv=none; b=lavxJd4Khz2rvz+c8168H8luIs1uckU/AEdU2NGmgL3OLlel2HyqOgqwVE5t9fhXZ7eskB4F9VZwGpC2KpT6osxwSx0qt/Q4CkB+BfueCGDP1xheSy+nZVFg7gOacj2Jr6bXaxCwdZVCMmF+LmwJUha7i0V/CBgyd+DSjJf1MSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773297393; c=relaxed/simple;
	bh=CLTu0Trx+S/HUg7OzUyEvoRk46s+lgsFC268LDKO0CU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tQ9V7nVRQUWPAgVVPoVYe3CQX5GubkSxVlE10NyzSwlvtVPthtoYm7Npu3H/nGvP4cFvudrOrJbHSAxvI2xT2T/cOKjedJhp8w9SMBilniToEpxdTVee6pf7tUh+zv4TR5gvpiRmjMIUl2/PTiYkzHhNSMh4T9gZ4AOUHrqzkVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gw6yshKS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gw6yshKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29084C4CEF7;
	Thu, 12 Mar 2026 06:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773297393;
	bh=CLTu0Trx+S/HUg7OzUyEvoRk46s+lgsFC268LDKO0CU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gw6yshKSRUWzsjPOkWeEHGcF93vSRE1jOdDYIjVLoDFCsngsCHl/+XYDjCFEN1OjF
	 ZiUso89K3gLvMfMrMoZa3PXc/bsAEcjy//cR5oxh4LpS56/kTV6zYnFjjXsyXsiVGd
	 iQfrZJnDpCJw2roMs2gLTT+qFqfbV0wJsoV58d5Dte6gmMWo894/5NGxFC4hFljjZ6
	 LS1LfmIx6WEGdSoFdCbppE5YT+FYPMBiuYiXFAL2Na1GT2NsE+zWyhJSBn16kv2KEL
	 LuUdwizxxTVvG5jt5VVsFRGiDJTixoV680jnTMb4ilbnkXt6EOrZpe4S7m2Pyj+Nt3
	 tz5AKdoazJPZA==
Date: Wed, 11 Mar 2026 23:35:34 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	adrianvovk@gmail.com, dm-devel@lists.linux.dev,
	quic_mdalam@quicinc.com, gmazyland@gmail.com, israelr@nvidia.com,
	mpatocka@redhat.com
Subject: Re: [PATCH v1 3/3] dm-inlinecrypt: Expose inline crypto caps to the
 device
Message-ID: <20260312063534.GC2359@sol>
References: <20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com>
 <20260304121729.1532469-4-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304121729.1532469-4-linlin.zhang@oss.qualcomm.com>

On Wed, Mar 04, 2026 at 04:17:28AM -0800, Linlin Zhang wrote:
> Add a new DM flag, which means the inline crypto capabilities
> from underlying devices can be exposed to the DM device, and
> the DM device consumes these capabilities, rather pass through
> them to the upper layer.
> 
> Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
> ---
>  drivers/md/dm-inlinecrypt.c   | 2 +-
>  drivers/md/dm-table.c         | 3 ++-
>  include/linux/device-mapper.h | 7 +++++++
>  3 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-inlinecrypt.c b/drivers/md/dm-inlinecrypt.c
> index 251760da9f7e..eda56893d430 100644
> --- a/drivers/md/dm-inlinecrypt.c
> +++ b/drivers/md/dm-inlinecrypt.c
> @@ -396,7 +396,7 @@ static struct target_type inlinecrypt_target = {
>  	 * Do not set DM_TARGET_PASSES_CRYPTO, since dm-inlinecrypt consumes the
>  	 * crypto capability itself.
>  	 */
> -	.features		= DM_TARGET_ZONED_HM,
> +	.features		= DM_TARGET_CONSUME_CRYPTO | DM_TARGET_ZONED_HM,
>  	.module			= THIS_MODULE,
>  	.ctr			= inlinecrypt_ctr,
>  	.dtr			= inlinecrypt_dtr,
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 7be1d8dc8bdd..f0580935394a 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1407,7 +1407,8 @@ static int dm_table_construct_crypto_profile(struct dm_table *t)
>  	for (i = 0; i < t->num_targets; i++) {
>  		struct dm_target *ti = dm_table_get_target(t, i);
>  
> -		if (!dm_target_passes_crypto(ti->type)) {
> +		if (!dm_target_passes_crypto(ti->type)
> +				&& !dm_target_consume_crypto(ti->type)) {
>  			blk_crypto_intersect_capabilities(profile, NULL);
>  			break;
>  		}
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 38f625af6ab4..6abd1b4fcb76 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -306,6 +306,13 @@ struct target_type {
>  #define dm_target_supports_mixed_zoned_model(type) (false)
>  #endif
>  
> +/*
> + * A target consumes inline crypto capabilities itself and doesn't support
> + * passing through inline crypto support.
> + */
> +#define DM_TARGET_CONSUME_CRYPTO		0x00000300
> +#define dm_target_consume_crypto(type) ((type)->features & DM_TARGET_CONSUME_CRYPTO)

This patch doesn't make any sense.  First, no new flag is needed, as the
behavior is already correct if you just leave DM_TARGET_PASSES_CRYPTO
unset, as far as I can tell.  Second, the new flag is numerically equal
to DM_TARGET_PASSES_CRYPTO|CONFIG_BLK_DEV_ZONED.  Third, even if it had
a unique bit as seems to have been intended, the behavior is the same as
DM_TARGET_PASSES_CRYPTO, which should not be used on this target.

- Eric
