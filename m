Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941E53DB625;
	Tue, 13 Oct 2026 09:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884177; cv=none; b=PQ8susv4tzNYyyRvSYT7FATMoLoGt13YPDH/KEcGKB7zBy9/blBmp+pFu9B89l86f0Ww9nsCofLWhZPi0E/N8lvvps5WrVAdRPG2/1b21zu6XVhCvIxGytmDfW1bQVzlUiaNV3enxzRnSy9kuMW2diTxFUqycYpkLJHdE4c+s44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884177; c=relaxed/simple;
	bh=o6fItdcwNjRx9XbC1pmp5BurSSI8BFN0K5LPIG2SM+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IMXvK2f0oCEsMf2bv+hjd5gn+ih+6OmRmbmQSYgyYCcLMKljFphV5sfUsHpX3/3EB9uHuj8dKE7Q7ZYzQFdLLsi3jR+QX4QeUDrycIKTvUCBv6pvNtHMzSTbj8+EuGuYp8tWHkFAf8OHSIuc4u6zE+nBnXw/O/xRqn/YH6PD2u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TIYA4JVM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TIYA4JVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF621F000FF;
	Tue, 13 Oct 2026 09:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791884176;
	bh=3AesqUMWyjvMZWunFdp1g4dV3G3m72b3b6B/gEZi3zM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TIYA4JVMadkg6zv4DJYB+g0XlO/4XL/VEzs7bvFU66S+DTxmB2sgdWaqLshPMZ5m9
	 2UJ90gZI1GaIh4CB1c26xatZm7SuCl5EZRJYIsj/xufCE+4vEJad4R+ZYa2GhQZON/
	 wt45//A0iE1EnH+bX/TOQ/giwxuaThEQfdCNPR/QMIhd5NXc41fgAaxzjowLZeWtcp
	 BG0AqQlxmwhIGRK/ojMHDtiUfp7r0snQAPVjZRDs6nfktgiawWLn3z9NMizV+zVkgu
	 7BMLdhAf9vnNlc7otZaUq9lMq7NSbUUd4PjF/mUYR905eeSeakYmsJDsNiDRP3IQgh
	 6xgQZsxrcH0Qw==
Message-ID: <725db95b-c763-4d97-b6b0-9ffd4cdaff3f@kernel.org>
Date: Tue, 13 Oct 2026 11:36:13 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] dm zoned: do not reclaim a random zone into
 another random zone
To: Kyrylo Biryuk <illofspeed@gmail.com>, dm-devel@lists.linux.dev
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 bmarzins@redhat.com, hare@suse.de, linux-kernel@vger.kernel.org
References: <20261011175450.952-1-illofspeed@gmail.com>
 <20261011175450.952-3-illofspeed@gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261011175450.952-3-illofspeed@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/11 19:54, Kyrylo Biryuk wrote:
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
> Only switch to a random destination zone when the zone being reclaimed
> is a cache zone: moving it to the zoned device still frees cache space.
> 
> Fixes: c5c788595292 ("dm zoned: start reclaim with sequential zones")
> Assisted-by: LLM
> Signed-off-by: Kyrylo Biryuk <illofspeed@gmail.com>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
