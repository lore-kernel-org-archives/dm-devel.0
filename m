Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237688828;
	Sat,  8 Jun 2024 20:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717879764; cv=none; b=B4RlR4hOjzn/xSDZbbiR5s0bQEnaELoe6JDt/oPqNlfWetm1hvykfSU4ZHOqNO2/bgyZ7mPumfKjBRJggb8DcsqaBsLx+Cl9dd8Suq/qJ9mxyTjtiEp7LQWDOxyUOfaatwNJl2S/Ap1kTf80X6i9Px4XqDENib2FohbuweRPCjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717879764; c=relaxed/simple;
	bh=0kGZD8MX2St5muruzo0JFVrFwFHiT4IiWX1Ui3nLMYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZneBpr7Go75vU56cq2Arh+vr3Ei0yFlGlSVT85UM7B2fwU2XfP5Hpbxs06Kg63CJSeRB56iNHsk2UCxKvHHTwm1nVC8l03oyUnHYSpFbs1PlasTdT8HwtADh+qaml39KHTQ+x4qACLVTKx/cw2o+1Z1nLG+FpVzq23Mp9irWvUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=bc/CoZuh; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="bc/CoZuh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=rpf2zlxdcYZsCHLf8SwDT+0k74c3JFHCMQ1U6HltCD4=; b=bc/CoZuhS83TzMBI
	htT2lW1SIAP2l7vgHlD71gTcPut2fREIOfKVEeHSG2koSrMu8NcGi9GvcuTa8GGhlDOPOsDk5/zBn
	dAclCMdMbh1bXK4FPHwfK/djMNu+bh28T4qwZaqiuAs7xS6yUskcra6NYwuItYOKLXAjl5NriB6w0
	Xf7R0/K1DQTZ4WaX6VAnZN9IDTXvahb5/1PYaPq+HmIYo+VYEQOUhaK0gcQFXzgK+8HmJqFo8X+Uf
	VDzu09/ysFrVVIWLErSN7X539dsxgbaBh/QhfTFSHSHFQm3x9vND2jl33dCNPFI5mNjmTSXL+63N1
	641HfbequAYgRe2ufw==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1sG2zq-0059yc-2W;
	Sat, 08 Jun 2024 20:49:06 +0000
Date: Sat, 8 Jun 2024 20:49:06 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm cache metadata: remove unused struct 'thunk'
Message-ID: <ZmTDwlUVu6HAyJ_X@gallifrey>
References: <20240523210550.309116-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20240523210550.309116-1-linux@treblig.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-21-amd64 (x86_64)
X-Uptime: 20:47:45 up 31 days,  8:01,  1 user,  load average: 0.00, 0.00, 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

* linux@treblig.org (linux@treblig.org) wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> 'thunk' has been unused since
> commit f177940a8091 ("dm cache metadata: switch to using the new
> cursor api for loading metadata").
> 
> Remove it.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>

Ping

> ---
>  drivers/md/dm-cache-metadata.c | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
> index 96751cd3d181..0ad9dc1824fa 100644
> --- a/drivers/md/dm-cache-metadata.c
> +++ b/drivers/md/dm-cache-metadata.c
> @@ -1282,15 +1282,6 @@ int dm_cache_insert_mapping(struct dm_cache_metadata *cmd,
>  	return r;
>  }
>  
> -struct thunk {
> -	load_mapping_fn fn;
> -	void *context;
> -
> -	struct dm_cache_metadata *cmd;
> -	bool respect_dirty_flags;
> -	bool hints_valid;
> -};
> -
>  static bool policy_unchanged(struct dm_cache_metadata *cmd,
>  			     struct dm_cache_policy *policy)
>  {
> -- 
> 2.45.1
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
