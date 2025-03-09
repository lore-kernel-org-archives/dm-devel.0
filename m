Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB4617A2E8;
	Sun,  9 Mar 2025 23:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741562206; cv=none; b=ETwtsN6yU7qQLkju+twuXRH4QHHleR145l3B6C0lZOFYLWeF4PvQgjwqSexR5+739+n0JrIWBRcjap5cxV5yUOqCzXeqfEte8oVbDRbzP8xNvLLotmCxFhVWeoyaBoaRZiNdNWTRRhtpiHc1VmAlN9pX0lnNXi8IgrmxJo2uzP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741562206; c=relaxed/simple;
	bh=n2+oRwgjdB7Lvmq/Gdy3FEN5R87wix1+i5qxZ1v4lzU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vh2+Avx5zchnOXJz0MRwCtx5qCUC61oEGkl+ZPdjmhoUIR1A6c6474czH9wWWtv4dZPY4ov61ldEU1tfUHS60ADsmV1/sQ6/dYO/CYxScL+x7IgyMu09Qxnh19lHjbzn7fvEix7sxjAy63UWItftM3QqkjKjlzhuAL/zeryKAZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AwM+t3Bt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AwM+t3Bt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9254DC4CEE3;
	Sun,  9 Mar 2025 23:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741562205;
	bh=n2+oRwgjdB7Lvmq/Gdy3FEN5R87wix1+i5qxZ1v4lzU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AwM+t3BtBo1mxIq4X75x4o0tExU0lw028Rgsu5JTF1VywKn5E2JXpaXC/BV2NYwkS
	 HpBmfLMW6EhnferfYLd/sBhjfzlHVaJYLRxlRNopPxxejranmrdRamE2Lrr8FyJcRv
	 tTQ6llg7emHtK9znINsFj/wnK8YWoEE3t2q3DOH4dwblDxLwzzbf62aJh1QH76iBQ7
	 kiprZIcNv+aVEF289zJZO8Rw7L6I14jVWted/6QGRd8xoxU2g4Qjb06VHS97X1Hv79
	 gRGHEFEnDs8PDVHbtlhBj7SOi1IE1lgGiXA67jw1uLL6OijyYiVoiJNLnMlxGkWp48
	 yV55WR2tkk3ZQ==
Message-ID: <788a1ec4-ac86-40fb-a709-eba7e6d5535f@kernel.org>
Date: Mon, 10 Mar 2025 08:16:43 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/7] dm: fix issues with swapping dm tables
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250309222904.449803-1-bmarzins@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250309222904.449803-1-bmarzins@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/10/25 07:28, Benjamin Marzinski wrote:
> There were multiple places in dm's __bind() function where it could fail
> and not completely roll back, leaving the device using the the old
> table, but with device limits and resources from the new table.
> Additionally, unused mempools for request-based devices were not always
> freed immediately.
> 
> Finally, there were a number of issues with switching zoned tables that
> emulate zone append (in other words, dm-crypt on top of zoned devices).
> dm_blk_report_zones() could be called while the device was suspended and
> modifying zoned resources or could possibly fail to end a srcu read
> section.  More importantly, blk_revalidate_disk_zones() would never get
> called when updating a zoned table. This could cause the dm device to
> see the wrong zone write offsets, not have a large enough zwplugs
> reserved in its mempool, or read invalid memory when checking the
> conventional zones bitmap.
> 
> This patchset fixes these issues. It does not make it so that
> device-mapper is able to load any zoned table from any other zoned
> table. Zoned dm-crypt devices can be safely grown and shrunk, but
> reloading a zoned dm-crypt device to, for instance, point at a
> completely different underlying device won't work correctly. IO might
> fail since the zone write offsets of the dm-crypt device will not be
> updated for all the existing zones with plugs. If the new device's zone
> offsets don't match the old device's offsets, IO to the zone will fail.
> If the ability to switch tables from a zoned dm-crypt device to an
> abritry other zoned dm-crypt device is important to people, it could be
> done as long as there are no plugged zones when dm suspends.

Thanks for fixing this.

Given that in the general case switching tables will always likely result in
unaligned write errors, I think we should just report a ENOTSUPP error if the
user attempts to swap tables.

> This patchset also doesn't touch the code for switching from a zoned to
> a non-zoned device. Switching from a zoned dm-crypt device to a
> non-zoned device is problematic if there are plugged zones, since the
> underlying device will not be prepared to handle these plugged writes.
> Switching to a target that does not pass down IOs, like the dm-error
> target, is fine. So is switching when there are no plugged zones, except
> that we do not free the zoned resources in this case, even though we
> safely could.

This is another case that does not make much sense in practice. So instead of
still allowing it knowing that it most likely will not work, we should return
ENOTSUPP here too I think.

> If people are interested in removing some of these limitations, I can
> send patches for them, but I'm not sure how much extra code we want,
> just to support niche zoned dm-crypt reloads.

I have never heard any complaints/bug reports from people attempting this. Which
likely means that no-one is needing/trying to do this. So as mentionned above,
we should make sure that this feature is not reported as not supported with a
ENOTSUPP error, and maybe a warning.



-- 
Damien Le Moal
Western Digital Research
