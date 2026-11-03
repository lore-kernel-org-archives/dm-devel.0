Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793744543;
	b=tba6xZhvz4vkErsF4koT3I1k4cmZIxNaZ9LoWmAyNW2DCKWV+6wPVPA2puwXYw3Z9bw3
	 QrMGtdTMVsJ5wKmspOat7+lj0J3/tg1PDzJy3KbJdrkQydga54m9rjWi3DVUMpTR3QBfV
	 g8mpKXTEW0YHrDk3y4o2WW+u+wKDG0qWj9j/YoBofk+bdh2sRyNs+XTm5NbRBbJwMWwOD
	 dP0mc+R3hwq2Pp04cTShIpfP7wBMEZC3cqSDoMgiW742S/9EbH3P//zDUCS3+TKzydD6k
	 oc+rjMZOS/rJwXTB9UJZ/V/0v031wFp13TJWZdlN55rMsgP431//DWEZ1/Kz1QILTwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793744543;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=CRWgZbYbB+R5eRm2kScWUYQeRJH/ra2dV8Rl01TkDxc=;
	b=SVSB3oxEiOFLpctaInykRYgdbV84gmwmi1E2NvbJon53V8Q60aZ95EtTt1ABjktjubiZ
	 1RTwWLFdotLPn/m09FneJxKD9YpjgAktWzb6rvbRbvl1gisEA3Uf4CCTrCsoUkFewox7g
	 USDmWW3NEREVQUk7KtE1iNh/KvCMj7V9gVR3zqEonivbNgxCb4RucrIQaTQEPCy2+ATBj
	 5kWsXpVJtTJuGyCWc9IlUItoztSkFrG+dDV1Z4DCf8IqPZSHh8Ffbakv3eEdvY5EyZ5tK
	 fxO8PpdrswoRkF0ms/ZJKxI9mHGu4KPYiSUrxaKndZB65WXdAfJTOpC+ScBDBfo26hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cw3vMvX4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98753606A31B;
	Tue,  3 Nov 2026 22:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cw3vMvX4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096411F000C1;
	Tue,  3 Nov 2026 22:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793744543;
	bh=CRWgZbYbB+R5eRm2kScWUYQeRJH/ra2dV8Rl01TkDxc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Cw3vMvX4K1PsJOxdCD1G/M9XXxL7yKdwKvvcRNi8GmhlC8SfegP+HGGeLMMI9RzFf
	 At7z4j28Y5DZETtoEgbmcQ6+ZHFR0G2Pw5nZaI51FeDy5FoZL8rZ+hAO5kmB41rFvB
	 Hno0lU9278DO0wpVyIe2TIjDUImXbMtvbMmdynzu9+JCrEJxR+aFI9zBKzZznewLzx
	 VBEjvpn0zZ6V0JDw7PCFFXvEkpAqxuhQc3qNjdCm/G8+IZijJcwtm2kdL68RbfFyWV
	 2D+FEGwE0gcgFnu4kZmXElsRVC0sjksMX58HqTEKJeTWeYOf08Ui/dOUgZMXin3I9v
	 wHdchv30dw/dQ==
Message-ID: <759f9072-02df-4862-a563-7d537bf4ea63@kernel.org>
Date: Wed, 4 Nov 2026 07:22:20 +0900
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/2] dm zoned: back off when reclaim cannot make
 progress
To: Kyrylo Biryuk <illofspeed@gmail.com>, dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com, snitzer@kernel.org, agk@redhat.com,
 bmarzins@redhat.com, hare@kernel.org, hare@suse.de,
 linux-kernel@vger.kernel.org
References: <20261103220438.510609-1-illofspeed@gmail.com>
 <20261103220438.510609-2-illofspeed@gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20261103220438.510609-2-illofspeed@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/4/26 07:04, Kyrylo Biryuk wrote:
> When a reclaim pass cannot make progress, dmz_reclaim_work() still ends
> with dmz_schedule_reclaim(). If the target is idle, dmz_should_reclaim()
> keeps returning true, the work is queued again with no delay and the
> worker spins on the same failing pass. This patch handles two such
> cases:
> 
>   - dmz_do_reclaim() fails with -ENOSPC because no free zone is
>     available to copy the data into, for example on a target without
>     cache zones that has no free sequential zone left. The next patch
>     also makes this the expected result when an idle target with cache
>     zones has random zones but no free sequential zone.
>   - dmz_do_reclaim() finds no zone it can lock for reclaim and returns
>     -EBUSY. Since commit 90a9b8693f1b ("dm zoned: reclaim random zones
>     when idle"), dmz_should_reclaim() returns true on an idle target
>     whenever the total number of random (and cache) zones is non-zero,
>     whether or not any of them holds data. Each pass then also runs
>     dmz_check_dev(), which checks every device for media events (a TEST
>     UNIT READY on SCSI disks).
> 
> The -EBUSY loop lasts as long as the target stays idle; it ends when a
> pass finishes while the target is busy and has enough free zones. On
> three 27 TB host-managed SATA drives used as md RAID5 members (7.2.10
> with the module built out of tree, all random zones free, target idle
> for 300 seconds, kprobes attached, two other drives on the controller
> being zero-filled), each member's SCSI device counted about 108,000
> requests per second with the stock module and the system used about
> 915 s of CPU time, against about 46 s with this series. libata completes
> TEST UNIT READY in software, so these counters do not measure commands
> sent to the drives; the cost is CPU time.
> 
> When a pass fails with -ENOSPC or -EBUSY, retrying at once is unlikely
> to make progress: re-arm the idle poll instead, so that reclaim is
> retried after DMZ_IDLE_PERIOD unless a zone allocation or a "reclaim"
> message queues it earlier. On a busy target, zone allocations can
> restart reclaim immediately when free space is low enough to require
> reclaim. Re-arming also keeps the poll running after a complete idle
> drain. The poll can still stop after a pass that ends while reclaim is
> not needed; that is unchanged.
> 
> Skip the device check for these two results: they normally mean that
> there is no zone to copy into or no zone to reclaim, not that a device
> failed, and the I/O paths check the devices themselves. Use
> queue_delayed_work() so that work an allocation has already queued is
> not postponed.
> 
> A pass that fails with an I/O error, for example on an unreadable block
> of a device that stays online, is still retried at once while the
> target is idle; this patch does not change that.
> 
> Tested on 7.4-rc1 with this patch and the next one, on three emulated
> host-managed drives (scsi_debug, 1 GiB, 32 MiB zones) each under
> dm-zoned as md RAID5 members, all random zones free and the target idle
> for 300 seconds. With the stock module each member's SCSI device counted
> about 70.2 million requests and the reclaim workers used 726 s of CPU.
> With this series: 75 requests per member, 30 passes per worker (one per
> DMZ_IDLE_PERIOD) and 0.08 s of CPU. Data written during the tests read
> back with matching checksums, and no kernel warnings were logged.
> 
> Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
> Fixes: 90a9b8693f1b ("dm zoned: reclaim random zones when idle")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kyrylo Biryuk <illofspeed@gmail.com>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
