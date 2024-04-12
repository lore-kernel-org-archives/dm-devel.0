Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B369383A5
	for <dm-devel@lists.linux.dev>; Fri, 12 Apr 2024 06:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712901976; cv=none; b=dzGdkyPVyyDxdCedCMhUCE9VmGNYqAXjhBcUvM37pcXXQOgCaLk8z7EVAf9DWsab9cAs+rgSYUIudyiGsQpMqrQWJ+9yJRC4KplLnh714TYZWvPdIHmwXfC2gwXeYbjUaoxeRlQ3a06RhMCIRUzqz1lLVAmzMdtr1uppXnoH1GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712901976; c=relaxed/simple;
	bh=G3pr5LPUGO9t79qiAnaITY/2vre975QTtoMPgOs5E8w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X1W0wzdlJIoaDC9oWrp+FEwJs+R5eCS3C6b2Rf2nf3hHELBEZY7yNllLBItoQ8q9l5fYwnptfeuGRE7B2d+ZKxA504WEO3EO0cFmaRhToiwaR5s2ZXqgMqmK9J2Bu80WZ63XceugpQpad7lANjYIpkD8HYw20z7zEzG9ZQvHIvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=U5iplOW/; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="U5iplOW/"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-34388753650so207851f8f.3
        for <dm-devel@lists.linux.dev>; Thu, 11 Apr 2024 23:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712901972; x=1713506772; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J8GNh5ybVxw/DykKt798BH/xXgYhGYVh2tS08spZGHU=;
        b=U5iplOW/km2Rbe8qYO9hJJcqn9sIumskxYD5xLlQgNxHQu3xGP86FtHcZOfAn9BYie
         lmAksAkgQ5E53GHCUk2mk575P2tNtRw9mRqUU99dSUP+VSJiWjFUPoI5PPZLtqNEXf0M
         cFahKYjMylg4OrMJ5kFvUXcyOrSkXnNjI9wL2h2GWEAN5Kl5KB43oOnuPm8aXg2dZLyd
         gcWbpGgLtgs0uwLvFPPD7QRU7m5qWWYGq9YMHIZdDWzgcS9PIHtYu2zskdZb33H9vlqp
         Eb9jaSX+81PjKq2ZbVv0GBxM8X5mA1fLa2p9HClrbnNsKWCKzG0D7KigoPf8TIquZO0V
         xk3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712901972; x=1713506772;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J8GNh5ybVxw/DykKt798BH/xXgYhGYVh2tS08spZGHU=;
        b=OqRF6rs2PRNRpSSeK/FAx/u9/OjzO0YZdZeyC7rmC2XII3wPiEqqzFRR0ZJ+KCHBLH
         WMXSB25gE7j5/6yBHd+C/tuJauMz3YDZ5LKrpefKDASPNcw4EzNbYbDw1fSyyukeZOU0
         izb8b/gvZGZlSXxjGgvxuzQAczauiDejQ8qUCR231jEGL7o/ZtunCjE7b20G+XHQQ2uk
         OrL/QCxLXN3RX5s9f0SBw2TlZHbu7poqloiTBGgMM7Tr3dh2TlYThUc52qU+Auaaaa2t
         GZPkrpzzV1rCcPuRQD9gtBHUrKquf4HK8mMAjshsTJI+L4aaQNdNd2ewPi+HLJbzd1lE
         k7Gw==
X-Forwarded-Encrypted: i=1; AJvYcCUR+/wigdNu4+oSNwclSBBxGadnNK1dIg867i+q7litQgeMKcjt7ZcS+WyCUFbX+IUcIxgd5g5fB7CTAj0LE8zaZoA12ceuMcs=
X-Gm-Message-State: AOJu0Yw8ixMbbv8p3Xxbue0l1jJkeEE5EfDAoiySQOmMYucXAwtlt+P5
	5BWdzDTjDMqW5ArxrwCE7IGiCwySc6Ei2M5mN0j14XyF2cC0bO9YsQH+/lp5gPg=
X-Google-Smtp-Source: AGHT+IFnNlkWGsmUoyZkKCFgPN6JKLMh7QMphM5zZgNw275CWWB0100Gnn9/GELhw1Ev0sYZPPEN3Q==
X-Received: by 2002:a5d:4248:0:b0:343:742c:6a57 with SMTP id s8-20020a5d4248000000b00343742c6a57mr1023846wrr.35.1712901972410;
        Thu, 11 Apr 2024 23:06:12 -0700 (PDT)
Received: from ?IPV6:2001:a61:2b3c:8a01:4b64:83a6:b824:8156? ([2001:a61:2b3c:8a01:4b64:83a6:b824:8156])
        by smtp.gmail.com with ESMTPSA id l26-20020adfa39a000000b00343e825d679sm3439474wrb.87.2024.04.11.23.06.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 23:06:12 -0700 (PDT)
Message-ID: <13eefee4-02ab-4cdf-b317-6a8585b4afdf@suse.com>
Date: Fri, 12 Apr 2024 08:06:11 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Problem with [PATCH] libmultipath: fix max_sectors_kb on adding
 path
To: Martin Wilck <mwilck@suse.com>, "bmarzins@redhat.com"
 <bmarzins@redhat.com>, Etienne Aujames <eaujames@ddn.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 nilesh.javali@marvell.com, DM-DEVEL ML <dm-devel@lists.linux.dev>
References: <ac898b4b79947c22d510bb365e9b507faac1f016.camel@ddn.com>
 <9bb4ca089c3d2dd5b331df88f3f89953916b0b17.camel@suse.com>
 <7742003e19b5a49398067dc0c59dfa8ddeffc3d7.camel@suse.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <7742003e19b5a49398067dc0c59dfa8ddeffc3d7.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/11/24 19:41, Martin Wilck wrote:
> Hello Ben, hello Etienne,
> 
> On Wed, 2023-08-23 at 21:51 +0200, Martin Wilck wrote:
>> On Wed, 2023-08-23 at 16:24 +0000, Etienne Aujames wrote:
>>> From: Etienne AUJAMES <eaujames@ddn.com>
>>>
>>> A user can change the value of max_sectors_kb on the multipath
>>> device
>>> and its path devices.
>>> So when a path is deleted and then re-added, its value will not be
>>> the
>>> same as the multipath device. In that case the IOs could be mis-
>>> sized.
>>>
>>> On reload, this patch re-apply max_sectors_kb value of the
>>> multipath
>>> device on its path devices.
>>>
>>> Signed-off-by: Etienne AUJAMES <eaujames@ddn.com>
>>
>> Looks good to me.
>> Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
> We've seen issues in our beta-testing with this patch.
> 
> Consider a device with an odd max_sectors number (in 512 byte blocks).
> If you look through the kernel sources, you'll see that there are quite
> a few devices with odd max_sectors defaults. In our testing, we used
> bnx2i (max_sectors = 127).
> 
> When a multipath map is set up, the kernel will call
> blk_stack_limits(), making sure that the map has a max_sectors value
> that doesn't exceed the max of all path devices.
> The map will have max_sectors = 127 in the bnx2i case.
> 
> When a device is added, multipathd will read max_sectors_kb from sysfs,
> and obtain (127 >> 1) == 63. It will then write this value to the path
> devices, causing the kernel-internal max_sectors value to be set to
> (63 << 1) = 126. But the map's max_sectors is still 127. The path
> devices have now a lower limit than the map. This leads to errors like
> this:
> 
> [  254.652934][  T820] blk_insert_cloned_request: over max size limit. (127 > 126)
> 
> If the map was reloaded after that, the kernel would fix this
> discrepancy autmatically through the blk_stack_limits() algorithm. But
> as long as this doesn't happen, the blk_insert_cloned_request() error
> will repeat and possibly cause the system to hang, and even if a reload
> happens, if the map is currently active, there will be a race window
> during which IO may fail.
> 
> I'm working on a fix for this. My first idea was just to revert
> Etienne's patch bbb77f3 ("libmultipath: fix max_sectors_kb on adding
> path"). The code that exhibits the above issue is actually from 8fd4868
> ("libmultipath: don't set max_sectors_kb on reloads").
> 
> My thoughts so far:
> 
> 1) We must strictly avoid max_sectors(path) < max_sectors(map).
> 2) max_sectors(path) > max_sectors(map) doesn't hurt.
> 3) We currently have no way to tell if the kernel value for max_sectors
> of a path device is even or odd.
> 4) As soon as we or someone else writes anything to max_sectors_kb, the
> kernel internal value will be even. This applies to both path and map
> devices.
> 5) The max_sectors value of a map device will be equal to the lowest
> max_sectors of all path devices after each reload.
> 6) Therefore, if max_sectors_kb is set in multipath.conf and we have
> set it at least once in a reload, we're on the safe side wrt the
> scenario above. This is why we see no issue with 8fd4868
> ("libmultipath: don't set max_sectors_kb on reloads"), even though that
> commit introduced the code that rounds the max_sectors value down.
> 7) Arguably, the kernel should be patched to provide the raw
> max_sectors value to user space, but that will take time.
> 8) If users change max_sectors_kb, either for path devices or for map
> devices or other stacked devices, after the mapping has been set up,
> they are asking for trouble. We can't avoid errors resulting from such
> user actions, and I believe it's futile to try. This is not a
> multipath-specific problem, it applies to any stacked block device.
> 
> AFAIU, bbb77f3 ("libmultipath: fix max_sectors_kb on adding path") just
> "fixes" a scenario where a user had manipulated max_sectors_kb, which
> is a situation we can't correctly deal with anyway (see (8)). So
> perhaps just reverting bbb77f3 is enough.
> 
> OTOH, 8fd4868 is somewhat inconsistent. If it's correct to set
> max_sectors_kb when path devices are added to make the value consistent
> with the map, it should also be correct if max_sectors_kb was not
> configured. This is what bbb77f3 tried to fix.
> 
> In light of (2) above, I think we shouldn't change a path devices'
> max_sectors_kb unless it's smaller than the value of the map.
> If we do it this way, the scenario above couldn't occur.
> 
We have gone into great pains in the kernel to ensure the queue limits
are sane, and updated correctly. Even for stacking devices.
I sinserely doubt we need this patch from multipath anymore.
Having to adjust max_sectors_kb really should be reserved for
corner-cases where the user has a dodgy hardware which doesn't
report correct limits.
But even that should rather be handled by blacklisting.
Can't we just set max_sectors_kb to readonly in the kernel and
be done with it?

BTW: Brilliant analysis!

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

