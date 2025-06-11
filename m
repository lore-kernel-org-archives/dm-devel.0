Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D557418D
	for <dm-devel@lists.linux.dev>; Wed, 11 Jun 2025 19:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749669242; cv=none; b=lKBvtYpZzqP3HG+Ok97KlgjsMib+qks6Fw9HBqVOhGwUZUotLFasgU+47eN8G2gSzwqSUjP7PuVzse8kKnP0hk0nYaujaSSB/r+MfBI3ylW7QNYg1NTkaeiLSPjnLq8Nsw1UxPSat86fjGpqCTKP5F6qkM3O5tv1mpgEOhuEkz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749669242; c=relaxed/simple;
	bh=4vsW4mP85ATKD2zm6InzkkKDDPu0bR7Qc9YMyVaiG9Y=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NeqqVeUoGsA04riRwCiXUvhpv25mnaMNI9P0sFGwghg123M/B/QHR+ZOMNm/O633fckympKB5ch5juAn4fD6pjpWluKObqFe6srHzyBN2v9oCMEAOdUSGg8O9MfQe5/CtKh9TtpyJdhe6yFLn7fyJrB1e1mRbtwE65rxZkeap/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VvWP7nzk; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VvWP7nzk"
Date: Wed, 11 Jun 2025 15:13:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749669238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2srZNtmx5Wa3SW1AlMcMbWVb1uoL5XwEoEHmmNILmtc=;
	b=VvWP7nzkIsJh9KwSZqIQLxc/IhKC4hKY7Nb6eSv5XHniut88xM+828B/LgK5HHifCn45p3
	zNCOfxBP7ECPR2e200lI1f0E2gKvNPmayLpPTMeBLfULfax0kK0XrZtfOMM64YXLecS6Bt
	b5+Bv+7zmhgCOXwojNbjFDZRZeRstec=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Benjamin Marzinski <bmarzins@redhat.com>, 
	Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm-flakey: Fix corrupt_bio_byte setup checks
Message-ID: <p7m5kjkxpfom67ot5etxuffjyocbt3ijpqwkwtji5pwcea6uri@cvggydbbeotd>
References: <20250611191221.3011309-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611191221.3011309-1-kent.overstreet@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 11, 2025 at 03:12:20PM -0400, Kent Overstreet wrote:
> Fix the error_reads mode - it's incompatible with corrupt_bio_byte, but
> that's only enabled if corrupt_bio_byte is nonzero.
> 
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Mikulas Patocka <mpatocka@redhat.com>
> Cc: Mike Snitzer <snitzer@kernel.org>
> Cc: dm-devel@lists.linux.dev
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

Also, I see that you guys still aren't testing your changes properly.

> ---
>  drivers/md/dm-flakey.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
> index c711db6f8f5c..cf17fd46e255 100644
> --- a/drivers/md/dm-flakey.c
> +++ b/drivers/md/dm-flakey.c
> @@ -215,16 +215,19 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
>  	}
>  
>  	if (test_bit(DROP_WRITES, &fc->flags) &&
> -	    (fc->corrupt_bio_rw == WRITE || fc->random_write_corrupt)) {
> +	    ((fc->corrupt_bio_byte && fc->corrupt_bio_rw == WRITE) ||
> +	     fc->random_write_corrupt)) {
>  		ti->error = "drop_writes is incompatible with random_write_corrupt or corrupt_bio_byte with the WRITE flag set";
>  		return -EINVAL;
>  
>  	} else if (test_bit(ERROR_WRITES, &fc->flags) &&
> -		   (fc->corrupt_bio_rw == WRITE || fc->random_write_corrupt)) {
> +		   ((fc->corrupt_bio_byte && fc->corrupt_bio_rw == WRITE) ||
> +		    fc->random_write_corrupt)) {
>  		ti->error = "error_writes is incompatible with random_write_corrupt or corrupt_bio_byte with the WRITE flag set";
>  		return -EINVAL;
>  	} else if (test_bit(ERROR_READS, &fc->flags) &&
> -		   (fc->corrupt_bio_rw == READ || fc->random_read_corrupt)) {
> +		   ((fc->corrupt_bio_byte && fc->corrupt_bio_rw == READ) ||
> +		    fc->random_read_corrupt)) {
>  		ti->error = "error_reads is incompatible with random_read_corrupt or corrupt_bio_byte with the READ flag set";
>  		return -EINVAL;
>  	}
> -- 
> 2.49.0
> 
