Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358771A8403
	for <dm-devel@lists.linux.dev>; Sat,  8 Mar 2025 18:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741457972; cv=none; b=RVbojc1ZT1QVAdVqXTsPG82+zxdlVUZcqemuQ2Ug7YLmMxtsDm3KMRAAGg/hPS8xIbz/A3lfh1hy8Q1WOcg6SGQayi76nGlC27co1FoG+Wc9mYg3UJ0XxTyufdHuzoVndOCozKizwymUjmbouJp7s6EB8RrdvEVUIl6QF6jn4uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741457972; c=relaxed/simple;
	bh=RdFDDgUiDhzEz8Jwc31ZQKK2jsLwI4aJbZx5lnoDsZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z3GXm0e8AGD4MIw/LTCIeXpBIf1Gi2QTqKp4CewHz7B5+WAp5e86c+m8VKwbvTigz1akiQRdZ+csgiyjqeFRNmnS9aktZKS7gpPeFNB/EKi5f/zNxhsDJN0x6Q9TYBHXzkT/YOk408g6HeaaSzIJXXIc4z21vZcICqKjA8ErWdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=thSha2NT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="thSha2NT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B71C4CEE0;
	Sat,  8 Mar 2025 18:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741457972;
	bh=RdFDDgUiDhzEz8Jwc31ZQKK2jsLwI4aJbZx5lnoDsZQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=thSha2NTAUtt3fFoKGVzqVWCwnEWjTq4KWjHwk7e/fAut74eXOGdIOgnKnt3ydNkI
	 BkXSY8MAbE3iU3VjrdGepJGxBn5xX7+3f2zaLEYgKrk+RGhvWV2vNsG/WiDmI6Deup
	 D6m310xnqY9GSwOf6Gl8XJlqvNEqZ7z2YJe6Q5MwJbWCTjdy1mhv9Q/D8yD/17Vbtb
	 eAWGBi3R1k8DT/JkpdeYZ++oReME8wuCrfPE6QzoURsm1ldJbIcIi2ML6WFrS4UMR+
	 q6iw6ezQeR57gu0E45mMTgjKBxZ8RKjDLEPJSjZQM/FYgobgxmH8ktmgwOgJKFhxCT
	 eh9x92mqO24xw==
Date: Sat, 8 Mar 2025 13:19:30 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: dm-devel@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: dm-flakey: Fix memory corruption
Message-ID: <Z8yKMlhd-Z0sf6tG@kernel.org>
References: <20250308155011.1742461-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250308155011.1742461-1-kent.overstreet@linux.dev>

On Sat, Mar 08, 2025 at 10:50:08AM -0500, Kent Overstreet wrote:
> So, this code clearly isn't getting tested - at all. Besides this bug,
> the parsing for the "corrupt" modes is also broken.
> 
> Guys, don't push broken crap, and figure out how to write some tests.

Thank you sir, may we have another?

Like you never introduced a bug in your life?

Not going to tolerate your entitled primadonna attitude here.  You are
capable of being better, you've chosen not to be on this issue (twice)

> -- >8 --

Also, your patch header is pathetically bad.  But we get it, you're
far too busy to write a proper patch header that explains your change.

Or adds a Fixes tag, e.g.:

Fixes: 1d9a94389853 ("dm flakey: clone pages on write bio before corrupting them")

> Cc: dm-devel@lists.linux.dev
> Cc: Mikulas Patocka <mpatocka@redhat.com>
> Cc: Mike Snitzer <snitzer@kernel.org>
> Cc: Alasdair Kergon <agk@redhat.com>
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> ---
>  drivers/md/dm-flakey.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)

And what's with your inaccurate diffstat?

> diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
> index 731467d4ed10..5ceb5d68f65c 100644
> --- a/drivers/md/dm-flakey.c
> +++ b/drivers/md/dm-flakey.c
> @@ -426,7 +430,7 @@ static struct bio *clone_bio(struct dm_target *ti, struct flakey_c *fc, struct b
>  	if (!clone)
>  		return NULL;
>  
> -	bio_init(clone, fc->dev->bdev, bio->bi_inline_vecs, nr_iovecs, bio->bi_opf);
> +	bio_init(clone, fc->dev->bdev, clone->bi_inline_vecs, nr_iovecs, bio->bi_opf);
>  
>  	clone->bi_iter.bi_sector = flakey_map_sector(ti, bio->bi_iter.bi_sector);
>  	clone->bi_private = bio;
> -- 
> 2.47.2
> 
