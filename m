Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBF945D933;
	Sun, 11 Oct 2026 14:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791729007; cv=none; b=B6V/TQWKmDZHBvzgKiT9LHOcx13kiyUEsNb+i/OnJaFAi4xJy0u6TyCK+IU/rDwBJW6HBGh2oOn44VcdzrpOWRZfucP9hxj/Odz1/5vXlWm3WUzWNC66HInOCSJk/EF7o8kh0LF0NCRB3LBvZMqubDFkrRjZsYCyMVV1Nx2R8gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791729007; c=relaxed/simple;
	bh=w8FGrqVWKFCzjl0x9dELitvCaV77+8+v6qhp1fulAHA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o7f1QpIP+K4W7LzJD1L0QwVkNhQ2AWGFGmG0VrKdd4XNYFOqWNyDi0gsVt4Phlj66pPbvdM82/sYH4yITphfUipAJEZWMwzGPLjnRYC+UMb5DHEqWKHW6nPJfLiZ+ekwwFeJnPFW91MJkGc1ep688ftWg/x3w5hSEaikxsCpDbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tn+lfsLu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tn+lfsLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC311F0089C;
	Sun, 11 Oct 2026 14:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791729005;
	bh=n0PovXFZQUHP8cry42Q1ldeCjZWewXjs25eS/GbljiI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Tn+lfsLu6G/95ifOxJnDFbxLoiZVUanB/AMXN7P1zsP28kvef8ru3mVKNzhwk7gqf
	 KVDXxblRMySaOQo8xSRatI2/QjMeqGmR7LE5zobrRDSdn5aA1BFTX3uP+EvGdqla81
	 LTVupUS1Dj2Eud/teNI4CDGzB77dB8DUuY4d6XefmUKCOCYH4nRpzkJ2ORh/zBpByw
	 SXybnUpg4mc6t5PzFbfSxyRDWheb5wr861t2F/2xcEu/7rnqGpLhADhR6A616ny7+o
	 aKfs5BTZtvGUPGZXJWoQsGEoyzDALxBGUWkrYXdi8as36HCL/eiisXdFVdttdB7jTq
	 3iFguZ2hcj4Sg==
Message-ID: <d4adf5de-9d72-4977-b4c0-3e1f163872a1@kernel.org>
Date: Sun, 11 Oct 2026 16:30:01 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] dm zoned: do not reclaim a random zone into
 another random zone
To: illofspeed <illofspeed@gmail.com>, dm-devel@lists.linux.dev
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 bmarzins@redhat.com, hare@suse.de, linux-kernel@vger.kernel.org
References: <20261010161613.396-1-illofspeed@gmail.com>
 <20261010161613.396-3-illofspeed@gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261010161613.396-3-illofspeed@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/10 18:16, illofspeed wrote:
> dmz_reclaim_rnd_data() falls back to a random destination zone when no
> free sequential zone is available and the target has cache zones. When
> the target is idle and the cache zone list is empty,
> dmz_get_rnd_zone_for_reclaim() selects random zones of the zoned device
> as well, so a random zone is then copied into another random zone. That
> frees nothing: the next pass picks the next random zone and copies it
> again, for as long as the target stays idle.
> 
> Seen on a two-device target (256 GiB regular cache device plus a 27 TB
> host-managed drive) used as an md RAID5 member: after a full rebuild
> every chunk was mapped and no sequential zone was free, and the idle
> drive read and wrote about 72 MB/s each without pause for hours while
> the free zone counters in "dmsetup status" did not change. Reproduced on
> emulated host-managed drives (tcmu-runner ZBC handler): 340 MB/s of
> copying on an idle target, 0 MB/s with this patch.
> 
> Only allow the random-zone fallback when the zone being reclaimed is a
> cache zone: moving it to the zoned device still frees cache space.
> 
> Fixes: c5c788595292 ("dm zoned: start reclaim with sequential zones")
> Assisted-by: LLM
> Signed-off-by: illofspeed <illofspeed@gmail.com>
> ---
>  drivers/md/dm-zoned-reclaim.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
> index 315f0da99f3..2bcc163d209 100644
> --- a/drivers/md/dm-zoned-reclaim.c
> +++ b/drivers/md/dm-zoned-reclaim.c
> @@ -288,7 +288,14 @@ static int dmz_reclaim_rnd_data(struct dmz_reclaim *zrc, struct dm_zone *dzone)
>  again:
>  	szone = dmz_alloc_zone(zmd, zrc->dev_idx,
>  			       alloc_flags | DMZ_ALLOC_RECLAIM);
> -	if (!szone && alloc_flags == DMZ_ALLOC_SEQ && dmz_nr_cache_zones(zmd)) {
> +	/*
> +	 * Without a free sequential zone, moving a cache zone into a random
> +	 * zone of the zoned device still frees cache space. Moving a random
> +	 * zone into another random zone gains nothing, and when the target
> +	 * is idle it repeats forever. Only fall back for cache zones.

"fall back" to what? This comment is not clear.

> +	 */
> +	if (!szone && alloc_flags == DMZ_ALLOC_SEQ && dmz_nr_cache_zones(zmd) &&

Long line. Please split after "DMZ_ALLOC_SEQ &&".
Also, is the test for dmz_nr_cache_zones() needed? dmz_is_cache(dzone) will
never be true if there are no cache zones.

> +	    dmz_is_cache(dzone)) {
>  		alloc_flags = DMZ_ALLOC_RND;
>  		goto again;
>  	}


-- 
Damien Le Moal
Western Digital Research
