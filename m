Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B6B24A06A;
	Sat, 20 Jun 2026 21:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781990602; cv=none; b=lmA0sFo/SW2QyjW85kw5hE1Msqso0wBjRoTvl/ballLAQmNOIC3tT7veZ5Y82MxiJarsz1Q3Cp63dCmXRbSN0jAS96PTMKoAxI+X2fggKA/7UVGrGOlwQjZNx0itojNra3usv5Cs3nVNY7eOhq4Djj26JpQTAQ3mK4gAGvDRTcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781990602; c=relaxed/simple;
	bh=KXyzYG0KpQrHcoNvyoZ7Bv6yHtGXZ8EkE+gMhsbhCvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nJYOECagv7rUGsyowxupLFY15tZWBGwR/LOYxCKKPrkyZw28P56iiC5VjPJ9VEx/iXy97I/orCqt2deMmJMfdO+aglJ/e3q/GjNH/1ZWpCR+8FjTSydo1fgqBZyoEeOejk34m7YN4If66nFSyEBkIrc/V8E3SAHfB9zLu36tsjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=afycbD+p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="afycbD+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90471F000E9;
	Sat, 20 Jun 2026 21:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781990601;
	bh=jZea+AFBNagZCQ8peMnG/uZfIajT/e2quyg/s9yIYw8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=afycbD+pwcqmqW/VSlG5gJ9Vr1h39FFke+/WdBK4byaxYmx8qwknnkfj7pTOX/E3i
	 7tvTS7o6SkBbFzj9Y+k4VscL1BlqOtI+2z+tFfn0lGEAt3pEQGy+HXV2o+Gok2sRsz
	 vyalK9e9QmjW2MDhB6zfLw9Bzgocp90/hgr8GEtqX4U9tgj5n54I3dwvGuDc5W8asG
	 83vmQd5j3cfPWp9kd/0lGvnjvnAhxFbO39885RbDjAaCb9YSXTgX+HVi/lZkMLRicc
	 +f6Xr2j4MjOBtYGru/EIi/pzvrm59YDN6IuOYJ0TiKOG5xzwWVicuGDOfQ7O+OEakW
	 b4hfZCT4COsvQ==
Date: Sat, 20 Jun 2026 14:23:19 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Linlin Zhang <linlin.zhang@oss.qualcomm.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm-inlinecrypt: Fix an error handling path in
 inlinecrypt_ctr()
Message-ID: <20260620212319.GA1702@quark>
References: <2b6e6b71e66fbe90c75791669a9e16a36b48f7f6.1781983971.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b6e6b71e66fbe90c75791669a9e16a36b48f7f6.1781983971.git.christophe.jaillet@wanadoo.fr>

On Sat, Jun 20, 2026 at 09:33:03PM +0200, Christophe JAILLET wrote:
> All error handling paths, except but this one, branch to the 'bad' label in
> the error handling path.
> 
> If not done, there is a memory leak and some sensitive data may be kept
> around.
> 
> So, fix this error path and also do the needed clean-up.
> 
> Fixes: e7f57d2c47e2 ("dm-inlinecrypt: add target for inline block device encryption")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Compile tested only
> ---
>  drivers/md/dm-inlinecrypt.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-inlinecrypt.c b/drivers/md/dm-inlinecrypt.c
> index be1b4aa8f28b..bb4ded4757d1 100644
> --- a/drivers/md/dm-inlinecrypt.c
> +++ b/drivers/md/dm-inlinecrypt.c
> @@ -347,7 +347,8 @@ static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	err = get_key_size(&argv[1]);
>  	if (err < 0) {
>  		ti->error = "Cannot parse key size";
> -		return -EINVAL;
> +		err = -EINVAL;
> +		goto bad;
>  	}
>  	ctx->key_size = err;

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

The missing 'goto' below could use a patch too:

	if (ctx->iv_offset & ((ctx->sector_size >> SECTOR_SHIFT) - 1)) {
		ti->error = "Wrong alignment of iv_offset sector";
		err = -EINVAL;
	}
