Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C002620B22;
	Mon, 10 Mar 2025 23:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741648439; cv=none; b=lOGsF9Q9BxqidJM7BWmwsSCLt/RVvGL4M1GuF+zZ9X4ARKH+78ZrtcoFbV7QLudGoCbktg9mL7l87yy02X8AaOIOWiuen2FbTUy4Fwp44nuskcc242aYkOf0BVRBIsYvtmYJKhOYCo4tL9UeHfWQ3ZqS74JpCJFO5mxRPvXaXKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741648439; c=relaxed/simple;
	bh=ZMPUuoxsJB05Imxo4EDg1YKKTGBgB9+iMvPW21LwCpo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iaSqP6fbNxwR6tzt8pzjVe5MA6oOWzbzSy4DL510ifGsLVRV71iXDGHxLreGWi4gAAp1e8Kg1hFBX7WpYMleVSlO2a5pdWKNBbNn8NGDYN892vmiu/PatVd3QgFkHs85i57GtxBYr0lFas40qXl+S65G/sgm2lpjLQqp5aHi37U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NYG8CvAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NYG8CvAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C38C4CEE5;
	Mon, 10 Mar 2025 23:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741648439;
	bh=ZMPUuoxsJB05Imxo4EDg1YKKTGBgB9+iMvPW21LwCpo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NYG8CvAsMJIPO3nNL45LwXxqXCtZVjSBclaUoX53dM2nWx2Z8RBRL03sghgXdme6P
	 2KOYG6IuUBANdHG5OlaLoUjYX3Q/AKM/QBc5+/OngXxywdcGazHBmc+vrZ73ZKChFD
	 teeo7lhJQKRlt3TI33KakWTRvpYDb0Ns2fh3MgLp5QiAm8moL3jNvaTA+TYhfit8QI
	 uvEG/fcE0D841LTVORG/4vpJB6kOvnLYEocV8zlpRP5RXq5FVeBxZW+GhvyMUjyC1b
	 Cv8GbxjvL/D6kW1GPuWkF0DgfY9+lW1LeYi7lkv6gu5zVZYeiCCsMJis9nwpKL5wbP
	 /Qj4lmTu3gSAA==
Message-ID: <0de801e9-1943-4243-9a88-5e3bce3fdfc0@kernel.org>
Date: Tue, 11 Mar 2025 08:13:57 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/7] dm: fix issues with swapping dm tables
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20250309222904.449803-1-bmarzins@redhat.com>
 <788a1ec4-ac86-40fb-a709-eba7e6d5535f@kernel.org>
 <Z88VdfOmo1MU73ue@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <Z88VdfOmo1MU73ue@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/11/25 01:38, Benjamin Marzinski wrote:
> On Mon, Mar 10, 2025 at 08:16:43AM +0900, Damien Le Moal wrote:
>> On 3/10/25 07:28, Benjamin Marzinski wrote:
>>> There were multiple places in dm's __bind() function where it could fail
>>> and not completely roll back, leaving the device using the the old
>>> table, but with device limits and resources from the new table.
>>> Additionally, unused mempools for request-based devices were not always
>>> freed immediately.
>>>
>>> Finally, there were a number of issues with switching zoned tables that
>>> emulate zone append (in other words, dm-crypt on top of zoned devices).
>>> dm_blk_report_zones() could be called while the device was suspended and
>>> modifying zoned resources or could possibly fail to end a srcu read
>>> section.  More importantly, blk_revalidate_disk_zones() would never get
>>> called when updating a zoned table. This could cause the dm device to
>>> see the wrong zone write offsets, not have a large enough zwplugs
>>> reserved in its mempool, or read invalid memory when checking the
>>> conventional zones bitmap.
>>>
>>> This patchset fixes these issues. It does not make it so that
>>> device-mapper is able to load any zoned table from any other zoned
>>> table. Zoned dm-crypt devices can be safely grown and shrunk, but
>>> reloading a zoned dm-crypt device to, for instance, point at a
>>> completely different underlying device won't work correctly. IO might
>>> fail since the zone write offsets of the dm-crypt device will not be
>>> updated for all the existing zones with plugs. If the new device's zone
>>> offsets don't match the old device's offsets, IO to the zone will fail.
>>> If the ability to switch tables from a zoned dm-crypt device to an
>>> abritry other zoned dm-crypt device is important to people, it could be
>>> done as long as there are no plugged zones when dm suspends.
>>
>> Thanks for fixing this.
>>
>> Given that in the general case switching tables will always likely result in
>> unaligned write errors, I think we should just report a ENOTSUPP error if the
>> user attempts to swap tables.
> 
> If we don't think there's any interest in growing or shrinking zoned
> dm-crypt devices, that's fine.  I do think we should make an exception
> for switching to the dm-error target. We specifically call that out with
> DM_TARGET_WILDCARD so that we can always switch to it from any table if
> we just want to fail out all the IO.

Arg ! dm-error is used in xfstests so we need it (for btrfs at least since btrfs
supports zoned devices, and soon xfs as well). So I guess we should disallow
switching tables when the new table changes something to the zone configuration
(grow, shrink, zone size, zoned/non-zoned). dm-error does not change anything,
so we should still be able to allow it.



-- 
Damien Le Moal
Western Digital Research
