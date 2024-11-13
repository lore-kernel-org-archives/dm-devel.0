Received: from osmtp.synthetel.com (osmtp.synthetel.com [149.56.45.145])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB4F618B48F
	for <dm-devel@lists.linux.dev>; Wed, 13 Nov 2024 21:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.56.45.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731532798; cv=none; b=NZN0tyBSgDJn4XewpEn3xoX6Yb0JxYmSXMygMSZF9SMgboXBegtkFFdQCmeXXJT71wYuGgWvCwWHBuwlGhFY1wNufi2Nrhjni+CoERLgOMkjsNYLermtzmYoBEIhKZsIgFTTNCy5Gr3JI7fvKXa1yT/nk12Lp61smaYekdJQhdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731532798; c=relaxed/simple;
	bh=u6vDIChTW6Rfu+ZeAXIgPgPoGtcl0csXi+jzI6cFHdI=;
	h=MIME-Version:Content-Type:Date:From:To:Cc:Subject:In-Reply-To:
	 References:Message-ID; b=uab9ahPn2hvWdLAnkA9KNWODJ4ONPwGvUhTwa3YogCS7Ly/GjhKX8AZUPi35gIOUJ5FIKOPsV1UmDzM6sAdFJlZg+CPl2wSb6A14JTFRZ3xlJaMsFJ499E1qoiZ3TWZ2ZQgU3IZk4tkT0Dl9MbhIvcfp+MoQCHs/sHHFhWscS+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=synthetel.com; spf=pass smtp.mailfrom=synthetel.com; dkim=pass (1024-bit key) header.d=synthetel.com header.i=@synthetel.com header.b=SZc6Ha45; arc=none smtp.client-ip=149.56.45.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=synthetel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synthetel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synthetel.com header.i=@synthetel.com header.b="SZc6Ha45"
Received: from sha0.net (unknown [10.0.0.13])
	by osmtp.synthetel.com (Postfix) with ESMTPSA id 01A80C0DAB;
	Wed, 13 Nov 2024 21:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synthetel.com;
	s=default; t=1731532788;
	bh=u6vDIChTW6Rfu+ZeAXIgPgPoGtcl0csXi+jzI6cFHdI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=SZc6Ha45F64RG32vQ9zMas3NuBXV03ZDWR9cxnkU1hFW+uCVZk92W1Or9+5duxNqX
	 e9qDiPutVHXKucKtJYA0ffWW5apB+yl1Q4l++uVLQO4G+5MhDNgwz3YMQAGFvtnMKX
	 FH+7Pqe+mBQTyoBN/x78jBDqgVZKbSA70gAIXuo8=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Wed, 13 Nov 2024 13:19:47 -0800
From: Shao Miller <device.mapper@synthetel.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: dm-devel@lists.linux.dev
Subject: Re: Copy on Read
Organization: Synthetel Corporation
In-Reply-To: <687e5f5d-b763-4255-afed-8adc4e1df0be@redhat.com>
References: <db1f26b55bd68277b0944179dd11b298@synthetel.com>
 <687e5f5d-b763-4255-afed-8adc4e1df0be@redhat.com>
Message-ID: <46200486d8cf95b5278bad934abaa913@synthetel.com>
X-Sender: device.mapper@synthetel.com
User-Agent: Roundcube Webmail/1.0.12

On 2024-11-13 02:59, Zdenek Kabelac wrote:
> Dne 12. 11. 24 v 20:40 Shao Miller napsal(a):
>> Good day, Device Mapper Folks.
>> 
>> In the format of an X Y Problem:
>> 
>> [Almost] Real goal (X): I would like to read storage-blocks locally 
>> from a far-away (remote, high latency) source and keep costs (for 
>> local storage, for network-traffic) to a minimum.  95% of the remote 
>> source will never be read and 5% will be read frequently.  If I read a 
>> storage-block 1,000,000 times over 10 years, ideally it should only 
>> traverse the network once during that time.
>> 
>> There is no mention of writes, so far.
>> 
>> Sub-goal (Y): Identify whether or not there is a device-mapper target 
>> with copy-on-read, read-only behaviour.  This seems like it could be 
>> useful in certain forensic situations in which "accesses" ought to be 
>> recorded.  "We" (device-mapper users) have the "write half" of 
>> "accesses" covered, already, with snapshots.
>> 
>> dm-cache might work out, except that it appears to've been designed 
>> with considerations for writes, which are irrelevant to the goal(s).
>> 
> 
> [...]
> 
> dm-cache should be likely your 'favorite'  since it's designed to
> handle different policies - for some reason not too many policies were
> ever written (maybe existing one is good enough for most to bother),
> but the idea behind was to be modular and handle different need of
> users - if they simply 'know more' upfront then the current 
> 'heuristic' smq policy might ever learn from observing  IO traffic
> within cached device.
> 
> So I'd highly recommend to read about those policies and eventually
> write a better one for you specific case (like instantly promote any
> blocks until cache is 100% full)
> 
> Although you should probably try to use the existing one first -and
> you might be surprised how good it will get over the time in picking
> your hot spots of your disks - although there might be some 'extra'
> reads from your origin device before the cache considers a block to be
> 'promoted' to cache.
> 
> As for your 'write' concerns - they are actually irrelevant itself -
> since if there is no write - there is no need to maintain the place
> for it....
> 
> [...]

OK, thanks.  I guess dm-cache "writeback" could work: reads will 
hopefully populate the cache and since no writes will ever happen, the 
details about writes are irrelevant.  That didn't seem to occur to me, 
the first time I read about it:
- https://www.kernel.org/doc/Documentation/device-mapper/cache.txt

- Shao Miller
Synthetel Corporation
