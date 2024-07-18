Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6F57407A;
	Thu, 18 Jul 2024 14:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721312760; cv=none; b=Osw4yltu6qiXbjNQXv3ZF8qtiJJbA25qsfcv2aV6gGnHRG3RuxIZNiSACl0uyzEhzo7d6TW5QUpW5732yLk0FMDtjWiv+/zHdlW8nS5UmITA9hNpHzVPSC3vBmjk6r01fMhGk/bvdFLwnztMPG1/I2rY2j6iyXfHgLQVoaAN+qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721312760; c=relaxed/simple;
	bh=QxLSqqLbgC1YAN8cOfg/sJdekq31+FJBrmTDn9ZCo0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fG+aSYPGIBA6KmQqGR5kU1z8OmLShaotGbZUEr/4qfcKNQ60RprZAOOO3l9Hr89G43FAvS1DtCzTYxkome+SPtYOWvEUp6AR4LwO57pxKIZAggAg40M1n5ARc6tFBZX4luYbsSq+RXGnOo7VU7DbhdmvKoAmYKGF/hBxLWHH33Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mhy3BoSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mhy3BoSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF91C116B1;
	Thu, 18 Jul 2024 14:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721312760;
	bh=QxLSqqLbgC1YAN8cOfg/sJdekq31+FJBrmTDn9ZCo0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mhy3BoSbLRrU1aGVs2AovY+gKjIc4A7t4lpo/kHUv3tTTmCP02ca24SubGNhFjPET
	 PDyulwahROXlaD8jPDYVqwvXaQjXiLRhhfvwNFlmhSYKxiRnrD2rx8QWuqXgaKpc4y
	 i2rYfM5yTdHePmbj6i5sJR6GSIoXhiuc61tk8M+XJ8+bS3X37VVAnxsxa8jb7owje9
	 tRKEMmbzNVfT/YKrMZVHM5Gyyc2tvqweLoBoDa73uxo28I7J0O8PE5aWBy8q1J5KHm
	 ThTclwPaiQTqDT2PPRe7MmVAoarzFc6NjtWOSBtbQsM6jOOTvsWsKvFUq0QRcgQMng
	 skl1bKMhDNg+Q==
Date: Thu, 18 Jul 2024 10:25:58 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Khazhismel Kumykov <khazhy@chromium.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Khazhismel Kumykov <khazhy@google.com>
Subject: Re: [RFC PATCH v2] dm ioctl: fix erroneous EINVAL when signaled
Message-ID: <Zpkl9v6aYqodp6bE@kernel.org>
References: <CACGdZYKbdyALADEMDV+Vg+eog+UjjgGigEpmJTSKw_64RM8rbA@mail.gmail.com>
 <20240717231833.2090430-1-khazhy@google.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240717231833.2090430-1-khazhy@google.com>

On Wed, Jul 17, 2024 at 04:18:33PM -0700, Khazhismel Kumykov wrote:
> do_resume when loading a new map first calls dm_suspend, which could
> silently fail. When we proceeded to dm_swap_table, we would bail out
> with EINVAL. Instead, attempt to restore new_map and return ERESTARTSYS
> when signaled.
> 
> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
> ---
>  drivers/md/dm-ioctl.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> v2: don't leak new_map if we can't assign it back to hc.
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index c2c07bfa6471..0591455ad63c 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1181,8 +1181,27 @@ static int do_resume(struct dm_ioctl *param)
>  			suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
>  		if (param->flags & DM_NOFLUSH_FLAG)
>  			suspend_flags |= DM_SUSPEND_NOFLUSH_FLAG;
> -		if (!dm_suspended_md(md))
> -			dm_suspend(md, suspend_flags);
> +		if (!dm_suspended_md(md)) {
> +			r = dm_suspend(md, suspend_flags);
> +			if (r == -EINTR)
> +				r = -ERESTARTSYS;
> +			if (r) {
> +				down_write(&_hash_lock);
> +				hc = dm_get_mdptr(md);
> +				if (!hc)
> +					r = -ENXIO;
> +				if (hc && !hc->new_map) {
> +					hc->new_map = new_map;
> +					up_write(&_hash_lock);
> +				} else {
> +					up_write(&_hash_lock);
> +					dm_sync_table(md);
> +					dm_table_destroy(new_map);
> +				}
> +				dm_put(md);
> +				return r;
> +			}
> +		}
>  
>  		old_size = dm_get_size(md);
>  		old_map = dm_swap_table(md, new_map);
> -- 
> 2.45.2.993.g49e7a77208-goog
> 
> 

Thanks for the patch.  The header could use more context for how this
issue has caused problems in practice (you touched on that in reply to
Mikulas for v1).

But I will review this closely starting the week of July 29.  This is
a very fundamental codepath for DM so needs extended review.

Mike
