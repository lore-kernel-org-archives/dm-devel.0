Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EEA436342;
	Thu, 30 Jul 2026 13:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.63.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785417940; cv=none; b=Fa1bC7DV/H8iy5lomerrIi3+ewM95RzQjNOxO0T48u1z0SfSAj9I5Lp/HZZ3/wgKwUDEUvjBFVb4SRoMEq4eHRvUccwa61xVt3Y/j/T5xF54N+H0qhhgOeKqT+bLwiGUCukN0Exl9ty+tHzqM2IYbyFzSQJUkmdtD5n3Zk5wQnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785417940; c=relaxed/simple;
	bh=iBvn1V32UFbl1Y6DzEv+VRZO7wERFinlXh076KHj8f0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r58CweP4JV74Vgd2+9qX9jnuwfU+lan4VubdfXflAk2yoUC9MeUi0+DH7rzeLSBNj4htJf/am2nuiU9yRwu7CjEM1wH2EQtNM3e0nUBbZizC89rpHvlWwjYQNwxIqVyWzHyH2U4l4bPcE4kg+PWJAW2nbhVq6nbOenoLNO3p/mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=PCwBDXo1; arc=none smtp.client-ip=188.68.63.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="PCwBDXo1"
Received: from mors-relay-8201.netcup.net (localhost [127.0.0.1])
	by mors-relay-8201.netcup.net (Postfix) with ESMTPS id 4h9qh91q03z48C7;
	Thu, 30 Jul 2026 15:25:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1785417929;
	bh=iBvn1V32UFbl1Y6DzEv+VRZO7wERFinlXh076KHj8f0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PCwBDXo16INzC+PIvcUB7t+FFrZ2NaMLgI9Lpurjq9jifbsSnKE7HO0HbHVKOOQhD
	 ow9nu/8ujgv0PcryYdWRYbTx1yhKPxrf5VXEwZMqYvAAH23sAt8ZHOC+Aa5rWJJhoS
	 zNab4ukpD+5bOvziW+nzbTiu4UpKaCvT9aShRmsPDPAiLL3tYxcZXvpD3hb/P9awut
	 QdZAYXpbG3vHLIMBb6Kh20pEx05B80PjkyHiBqsECMzaJqvAeLSHkICu7YLnr+l2bX
	 NvrlC93dKfvT66MkSwe7wScIx0f/RAudRXrJtBveIgdtno9ODWx+04B6jxAxnBpb4k
	 WHzcHvKbvn1LQ==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8201.netcup.net (Postfix) with ESMTPS id 4h9qh915nQz47Rm;
	Thu, 30 Jul 2026 15:25:29 +0200 (CEST)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4h9qh82xXMz8tH7;
	Thu, 30 Jul 2026 15:25:28 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 7D39B5FC65;
	Thu, 30 Jul 2026 15:25:27 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <00104e90-48b8-4419-90c4-ac0c4a2e1c44@leemhuis.info>
Date: Thu, 30 Jul 2026 15:25:26 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 0/5] block: validate direct I/O memory alignment
To: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@meta.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 dm-devel@lists.linux.dev, brauner@kernel.org, djwong@kernel.org,
 viro@zeniv.linux.org.uk, regressions@lists.linux.dev,
 torvalds@linux-foundation.org
References: <20260720201057.1862857-1-kbusch@meta.com>
 <ampRQyXDbGgeg49V@kbusch-mbp>
 <fbe9e74d-c389-46f4-9874-3e9ffd9c91d3@kernel.dk>
 <ampce7mxSmxAwAiu@kbusch-mbp> <20260730112626.GA24827@lst.de>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: <20260730112626.GA24827@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <178541792804.408923.9815499278011439373@mxe9fb.netcup.net>
X-NC-CID: qByXBuGwsGHOqTUM3O1zOkkeWrvC9QArcgMtEQ9mkm6ZRzimk50=

On 7/30/26 13:26, Christoph Hellwig wrote:
> On Wed, Jul 29, 2026 at 02:03:07PM -0600, Keith Busch wrote:
>>>> Hi Jens, have you had a chance to look at this one yet? This addresses
>>>> previous issues with certain device mappers under direct io.
>>>
>>> I they look fine, but at this point we should toss them into 7.3. Yes
>>> I know there are regressions around this, but from 6.1x days. And the
>>> series doesn't apply to the current block-7.2 anyway.
>>
>> This series is kind of old at this point, but yes, it's not fixing a new
>> regression either. I'm okay if this goes to the next window, and I will
>> handle the stable follow-up.
> 
> Honestly, I think that'a a reall bad idea.  This is a regression in 6.18,
> and while it took a while for people to hit this with their a little
> more complicated lvm/md setups, it has stopped real systems from being
> used.  We need to fix this ASAP.
Thx for this, as I had been thinking along the same lines already and
was still considering if I wanted to speak up.

6.18 still qualifies as recent in my book, but YMMV. And it's not like
people "took forever to notice"[1], as they reported this for a while
now -- and there were a few attempts to fix this; it just took us some
time to see the full problem (@Keith: many thx for that and the fixes
for them). And some of the linked reports are quite recent, so people
really hit this.

Sure, as always there is the risk that this will cause other, bigger
regressions. Maybe that's why it's one of those situations where the
right approach is "submit this separately to Linus and let him decide",
unless of course he speaks up here.

Another reason to maybe merge this now is that Btrfs regression that
likely will only be fixed next week[2] -- so we already risk needing an
rc8 anyway.

Ciao, Thorsten

[1]
https://lore.kernel.org/all/CAHk-=wis_qQy4oDNynNKi5b7Qhosmxtoj1jxo5wmB6SRUwQUBQ@mail.gmail.com/
[2]
https://lore.kernel.org/linux-btrfs/69d0043e0f6a3d17048dfde857127ab0bf331154.1785190866.git.boris@bur.io/


