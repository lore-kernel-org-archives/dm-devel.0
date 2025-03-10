Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F721DE3A6;
	Mon, 10 Mar 2025 23:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741648772; cv=none; b=Ekb0FLNrzBOYLrO0Li8hsFp9Df7MtLf6qN0zvmwhPo3yYx0ycNHk1UaWPuKI+3qdR28Q9UtWp6bqPs5Uo82ShFqHuBMjMrD2NQHsN53vQZlkX3H4fzVYBg49zoq7nvXXtRqQo53EYq6lqLayjtpTBfJlVAu5OCDn32hucrc4QLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741648772; c=relaxed/simple;
	bh=Q1Vd03yBA0PERbax4aDYGQnOux9KbTJmcG0er2jocME=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M8Y/2EtTCCxq7XCd5NEcluKzqRdYVkbApXUiX+2GZ643/+bpe7/cd4xplHMsc+fvRy/MMBnpf9ERwvaad6pFd7EznXvhlwFPh8PEHAjBJCthSB+zPzSDDb4KDPma+4VKOGjvsZx5Yp6XdgBhlIPaqDU1QA/M12zfRqfMw4K+8dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HQm3wGa9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HQm3wGa9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B57C4CEE5;
	Mon, 10 Mar 2025 23:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741648771;
	bh=Q1Vd03yBA0PERbax4aDYGQnOux9KbTJmcG0er2jocME=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HQm3wGa9pOWRskHFrWc0x1gL0xs461wBi22zas6bbijWvdWHgGUmHS0hujaYlWAMy
	 fRn6rcPEBNZU/zR28FqbTDi4nAg4cj2s4iBFT3A+6rk6eCrv4r7MqL1qMjJNakiA3w
	 xoZPt3DUnLm5CJkaSOGNGfBrwZnKdYEGZANYPkb8aETZY1MwRAhkNZRUNVV+VtDOI+
	 xcrWGi/33lSa1ExeHp2gTITRen4znUpLKzZU6tecnN2PbBZZlPJNCHVOgYNck6eiLu
	 dDBJwY8gDICoNfso+1F1CgPjpE9+7XT40Rr9lHCoa4PwAHJZMUdhXhb43qfSW8Ci+I
	 U6uPfNphqzG7A==
Message-ID: <ab56c408-c98d-4333-b4f1-c3f380008e12@kernel.org>
Date: Tue, 11 Mar 2025 08:19:29 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 7/7] dm: allow devices to revalidate existing zones
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20250309222904.449803-1-bmarzins@redhat.com>
 <20250309222904.449803-8-bmarzins@redhat.com>
 <7e0a1b47-3c96-4864-80b0-813f357845ad@kernel.org>
 <Z88k2RD6s5KpuxOD@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <Z88k2RD6s5KpuxOD@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/11/25 02:43, Benjamin Marzinski wrote:
> On Mon, Mar 10, 2025 at 08:59:26AM +0900, Damien Le Moal wrote:
>> On 3/10/25 07:29, Benjamin Marzinski wrote:
>>> dm_revalidate_zones() only allowed devices that had no zone resources
>>> set up to call blk_revalidate_disk_zones(). If the device already had
>>> zone resources, disk->nr_zones would always equal md->nr_zones so
>>> dm_revalidate_zones() returned without doing any work. Instead, always
>>> call blk_revalidate_disk_zones() if you are loading a new zoned table.
>>>
>>> However, if the device emulates zone append operations and already has
>>> zone append emulation resources, the table size cannot change when
>>> loading a new table. Otherwise, all those resources will be garbage.
>>>
>>> If emulated zone append operations are needed and the zone write pointer
>>> offsets of the new table do not match those of the old table, writes to
>>> the device will still fail. This patch allows users to safely grow and
>>> shrink zone devices. But swapping arbitrary zoned tables will still not
>>> work.
>>
>> I do not think that this patch correctly address the shrinking of dm zoned
>> device: blk_revalidate_disk_zones() will look at a smaller set of zones, which
>> will leave already hashed zone write plugs outside of that new zone range in the
>> disk zwplug hash table. disk_revalidate_zone_resources() does not cleanup and
>> reallocate the hash table if the number of zones shrinks.
> 
> This is necessary for DM. There could be plugged bios that are on on
> these no longer in-range zones.  They will obviously fail when they get
> reissued, but we need to keep the plugs around so that they *do* get
> reissued. A cleaner alternative would be to add code to immediately
> error out all the plugged bios on shrinks, but I was trying to avoid
> adding a bunch of code to deal with these cases (of course simply
> disallowing them adds even less code).

I am confused now :)
Under the assumption that we do not allow switching to a new table that changes
the zone configuration (in particualr, there is no grow/shrink of the device),
then I do not think we have to do anything special for DM.


-- 
Damien Le Moal
Western Digital Research
