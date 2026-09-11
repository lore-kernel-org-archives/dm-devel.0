Received: from phd-imap.ethz.ch (phd-imap.ethz.ch [129.132.80.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8117395AF2
	for <dm-devel@lists.linux.dev>; Fri, 11 Sep 2026 11:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.132.80.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789127446; cv=none; b=Lp1hDqpX+kayWgT5yPwhetDPXTDIKOadfXOoXQ6Qi7GzlV9xO59lBt2hz4L2UGCCXqKs0ksPNnVQWl4bJW4SbqspqwjIsGISAt/RzbBl3jm7p4t0tKr2Z1ZXWwQQs85mvGics789fSuRrV5G0jf0gkPijPRMt3KkOHkFaWqrrkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789127446; c=relaxed/simple;
	bh=nAPoQQ13ge9PDtN96d+7KONCBuH3jx76Jp2u0TymNGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LNN8HfvK2C7t7mvEh5ZtPcnhnSfPx7tMT32tgpPalWPVWK7PcmLZ5lCcJ4E4B6ZEoNJGmv+NdDnGQrrL5AxRzzr68FGiZg7Y3ZoxJEfDk3Tb2uB4VloRsIYvUwxw6Xs5TN3XUt5kqrinWzl2tJuO4SZI5BEffpUzm6PbZ5R4Y1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=phys.ethz.ch; spf=pass smtp.mailfrom=phys.ethz.ch; dkim=pass (2048-bit key) header.d=phys.ethz.ch header.i=@phys.ethz.ch header.b=pu/pcVtb; arc=none smtp.client-ip=129.132.80.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=phys.ethz.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=phys.ethz.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=phys.ethz.ch header.i=@phys.ethz.ch header.b="pu/pcVtb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=phys.ethz.ch;
	s=2023; t=1789127055;
	bh=5XTp85lh48CiDWhdALFEwmrZcLeWXH3p723HIpOrGwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pu/pcVtbNNaLbVqD8N4tFlMyRZlE7o3n2TrNo5JgTV2b5VQcBUeu3xcAJjjCtHw3m
	 /jzoyEJ5N9hBpE5g/SRUtWgf6rfi+C80sMqWl13VM1jqVqWpu73wK6bvf4Qr6POEsX
	 M3Vhj1+fNu+ewYMnx1c9IwJMH2X3p621mT5xkRier4yE2urZY2KZ4v/WzNMprC1cMT
	 iYZ5FddLJsY6mG9L77R34fySUlbAGnS/iTZ7Wyza5VmSAj86N6uvOVWamSCqtdEQzW
	 MAa2pZ7gDhfmd6EJcLixulPtv4v2FhZmIK9JjW3AhBRvzrrkM45oN44DWevKQQH9xp
	 T8rzIbPPzbWBA==
Received: from localhost (192-168-127-49.net4.ethz.ch [192.168.127.49])
	by phd-imap.ethz.ch (Postfix) with ESMTP id 4hhCPW3xC0zP7;
	Fri, 11 Sep 2026 13:44:15 +0200 (CEST)
X-Virus-Scanned: Debian amavis at phys.ethz.ch
Received: from phd-mxin.ethz.ch ([192.168.127.53])
 by localhost (phd-mailscan.ethz.ch [192.168.127.49]) (amavis, port 10024)
 with LMTP id SbmWMhNq688n; Fri, 11 Sep 2026 13:44:15 +0200 (CEST)
Received: from dumbledore.ethz.ch (dumbledore.ethz.ch [192.33.96.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by phd-mxin.ethz.ch (Postfix) with ESMTPS id 4hhCPW2xVFzJn;
	Fri, 11 Sep 2026 13:44:15 +0200 (CEST)
Received: by dumbledore.ethz.ch (Postfix, from userid 13394)
	id 4hhCPW2cBPzCs6Z; Fri, 11 Sep 2026 13:44:15 +0200 (CEST)
From: =?UTF-8?q?Stephan=20M=C3=BCller?= <stephan.mueller@phys.ethz.ch>
To: mtsai@redhat.com
Cc: dm-devel@lists.linux.dev,
	ghuicao@163.com
Subject: Re: [PATCH] dm cache policy smq: fix promote level threshold clamp
Date: Fri, 11 Sep 2026 13:44:14 +0200
Message-ID: <20260911114415.4126987-1-stephan.mueller@phys.ethz.ch>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALjSBEvEOFPJy37tFMYD2RJL8BStreT6G20WGVrTV84t1DDN3Q@mail.gmail.com>
References: <CALjSBEvEOFPJy37tFMYD2RJL8BStreT6G20WGVrTV84t1DDN3Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

I try to understand the smq policy and stumbled also about the logic/comment
in update_promote_levels(). Luckily there this recent post :)

>On Wed, Jun 17, 2026 at 10:23 AM <ghuicao@163.com> wrote:
>>
>> From: Cao Guanghui <caoguanghui@kylinos.cn>
>>
>> In update_promote_levels(), the threshold_level is clamped against
>> NR_HOTSPOT_LEVELS (64) using max().  This is wrong: threshold_level is
>> later subtracted from NR_HOTSPOT_LEVELS to derive the actual promote
>> level, so a smaller threshold_level means a higher promote level (more
>> eager promotion).

I think this correct, but it reads a bit ambiguous - or it's just me. Anyway
I try to clarify:

should_promote() returns yes iff hs_e->level >= mq->read_promote_level

I.e. an entry in the hotspot queue needs a level above mq->read_promote_level
to be promoted. So a higher promote level sets a higher bar for promotion,
leading to a less eager promotion.
Or in other words:
  - smaller threshold == higher promote level == less eager promotion
  - higher threshold == lower promote level == more eager promotion

>> The comment above explicitly states that when the cache has unused
>> entries, "we want to be really eager to promote".  default_promote_level()
>> returns values in the range 1..8 for this case, which would produce a
>> promote level of 56..63 -- but max(threshold_level, 64) forces
>> threshold_level to 64, making the promote level 0 regardless of the
>> allocator state and defeating the eager-promotion logic entirely.

Yes, when using max(), the threshold_level does not depend on the allocator
state, so this is just a waste of CPU cycles. However it it does depend on
the hotspot_stats and may end up as 64, 32 or 16.

Using min() is also a waste of CPU cycles, because the initial value of
threshold_level is certainly smaller than NR_HOTSPOT_LEVELS (unless someone
messes up the defaults_promote_levels).

>Currently the promote_level could be {0, 32, 48}, depending on hotspot
>queue performance. Using min() instead would raise the promote_level
>to {32, 48, 56} when the cache is not full, or {56..63} when full,
>making the cache more conservative than the current setting in either
>case.

The promote_level is now 0 (WELL), 32 (FAIR) or 48 (POOR) for a non-full
cache or within {56..63} if the cache is filled entirely.
With min() this would be 32 (WELL), 48 (FAIR) or 56 (POOR). This is more
conservative.

BUT isn't this weird in the first place? Shouldn't a poorly performing
cache migrate more aggressively to increase the chance of cache hits?
And a well performing cache be conservative to maintain its good
performance?

>I noticed this ambiguity for a long time. A proper cleanup to remove
>default_promote_level() and simplify initialization is on my radar,
>but it's not urgent since the current behavior works.

Ok, what about just initialize threshold_level like this

threshold_level = allocator_empty(&mq->cache_alloc) ? 
                  default_promote_level(mq) : NR_HOTSPOT_LEVELS;

and remove the max/min line entirely. This does not change the current
behavior and spares some cycles?

   have a nice day
   stephan
