Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3712F7EF3;
	Sun, 11 Oct 2026 14:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791729237; cv=none; b=e84heklbGDr14tuxrkVHyOzHk4HJ+cSJ+OXUTn5NTNLSVMIjzVq9pb7wIUiIBpn4yPECyyseZGw6HLM/U2BW0fd3pSvfrzTlGaG4M3shk0pGODGRdkcXJSuUnNXG+D2zRwlNqRuP2Jww3c49/SO0/5fYEaVmidMp+bBUphu322U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791729237; c=relaxed/simple;
	bh=A7ndlWpF/T5S2MEaZOnnQmN9Ch8lL0qTNHrSAI8AQDY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=psqufVCu9OHoQs/nYV3Fz1dwMn+WfmWIL/I1BKu5RWYMEzAgb+Uc5npes5N4c2/aAjTf8PLdkHn5R4dBktlW+Dhoax2gbhUQsaaBHVZRlY8NogDSr+yK/YOYwaET5ao4myMam63KPRReabCmPstzg5H296u57uYGlrXVK55ez8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YMHwxt0A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YMHwxt0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB051F0089B;
	Sun, 11 Oct 2026 14:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791729236;
	bh=Way8FQM13K62H1GRR+ky7ygjLLbRXHA4sjCubV+ZjUM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YMHwxt0A+VwsxRzloo+nR2AQQ3cWikrS0HlgQRQiVK9kAX29wpeu9jlAp1JvEDxfH
	 SU726Tj/d4ax00TjGEMG4LRfS6bwo3joYh5q+9nKkDq/RqBFTx2nWo71gdipieA0dk
	 qgAiCdh5HfM41D/r2If6fM+Mi071GJ03mny7a092jVRbkn/9BdYMqphTmkihtzxKFj
	 qa7E0fsgTlx8ftLyBfX9aQMDm1mFGY68eilzN+4v7jtZiZgjYysOBzgIQVf5rpT0xM
	 7I6at9tirjCNZAgGe8oHGlsu5Q4Y/CslkusKsA2/oYeV3RFsh0YlXLaiFmjxVcC74Y
	 txvanwOVGq7jg==
Message-ID: <47d8f6d8-422e-4230-aa94-c6c882bcf467@kernel.org>
Date: Sun, 11 Oct 2026 16:33:52 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] dm zoned: fix two idle reclaim problems
To: illofspeed <illofspeed@gmail.com>, dm-devel@lists.linux.dev
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 bmarzins@redhat.com, hare@suse.de, linux-kernel@vger.kernel.org
References: <20261010161613.396-1-illofspeed@gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261010161613.396-1-illofspeed@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/10 18:16, illofspeed wrote:
> v2: no code changes. The only change is my author address: v1 went out on
> 2026-10-10 from my previous address. Please apply this version instead of v1.

OK. Missed this. So this answer my question about the changes.

> 
> These patches fix two problems in dm-zoned's reclaim worker, found while
> running md RAID5 on three dm-zoned targets on 27 TB host-managed SMR drives
> (WD Ultrastar DC HC680), each target with a regular cache device.
> 
> 1. On a target with cache zones and no free sequential zone, an idle
>    target keeps copying random zones into other random zones, forever
>    (patch 2; patch 1 makes the resulting -ENOSPC back off instead of
>    spinning). After a full md rebuild every chunk is mapped, so this
>    happens right after a rebuild: the idle member read and wrote about
>    72 MB/s nonstop for hours.
> 
> 2. After a reclaim pass that ends while the target is busy, the idle poll
>    is never re-armed, so zones filled under load are not reclaimed when the
>    target goes idle (patch 3). Users notice it as "the buffer never drains";
>    the workaround has been a timer sending "dmsetup message <dev> 0 reclaim".
> 
> Testing: the three patches were built as an out-of-tree dm-zoned module for
> 7.2.6 (the changed code is identical in current master) and tested
> - on emulated host-managed drives (tcmu-runner ZBC handler) in a VM: the
>   idle copy loop reproduced with the stock module (340 MB/s on an idle
>   target, zone counters unchanged), 0 MB/s with the patches;
> - on the three real drives since 2026-10-05: crash test, three 1.5 TiB
>   write benchmarks, and eight conversions between single-device and
>   cache-device layouts; emptied zones were reclaimed within minutes of the
>   targets going idle without the reclaim timer.
> - with a reproducer that needs no special hardware (scsi_debug zbc=managed,
>   64 MiB zones, plus a 1 GiB loop cache device): stock module ~600 MB/s of
>   read+write on the idle target with unchanged zone counters, patched
>   module 0 MB/s:
>   https://github.com/illofspeed/synology-host-managed-smr/tree/main/repro
> Not done: a test on current master itself (only 7.2.6), and a rebuild onto a
> cached member with the patches (the first problem was seen after a rebuild
> with the stock module).
> 
> Related, not addressed here: the double-free in dmz_load_sb() reported on
> dm-devel on 2026-05-30.
> 
> The problems were found and the patches written with the help of an AI
> coding assistant (hence Assisted-by); the analysis, the tests on real
> hardware and this description were reviewed by me.
> 
> illofspeed (3):
>   dm zoned: back off when reclaim finds no destination zone
>   dm zoned: do not reclaim a random zone into another random zone
>   dm zoned: keep polling for idle reclaim after a reclaim pass
> 
>  drivers/md/dm-zoned-reclaim.c | 28 ++++++++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)
> 


-- 
Damien Le Moal
Western Digital Research
