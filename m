Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4098E2882CC
	for <dm-devel@lists.linux.dev>; Thu,  9 Oct 2025 23:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760052573; cv=none; b=FvX9W7Fp/Zspml2JXEBw7arXP+0bZpk++kva/4KZc+qfUIW18hSFkr8peXzAeyRQVYdJBkFw6nBV2pp7PUvuV+2cLkTuQIgojswoPSwl+OsSSUxU65JxGlEMZ3hkCiHMBYI7VEXqad00ej1kQcghTtZ6+BU3jpB3drLLVkNMVrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760052573; c=relaxed/simple;
	bh=Puj5bzBwPmZcelM0ZE9ITN4oZJ26SD2JEHSS8Uc2bvU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oXcPf4/IUt0wIXDGE3wQKBfL63PLwiodndYAnzcUMoL3XK3VRJoefUICJ8HcjLRTz2tGVuen2wzNxo4INw1P3ORwsJ78gw6sBRUXvd6kOAgZ2ZivvM55XD4DuEphKaDpbsVKsIz2aSp2G6bgiZtquqPirx8ONDCnbvvOo0bNLYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=C0qYgq1T; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="C0qYgq1T"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cjR0p0SvpzlgqVQ;
	Thu,  9 Oct 2025 23:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1760052568; x=1762644569; bh=t9JIKO9hp+2hB33E7lyqCEmf
	XpCNYq14w/Ac9cHH/1c=; b=C0qYgq1TAX10ak5tbMDQaIF3Ro7xjrR1PuHDHpk0
	J0AN/aAd4vfNKw4LbTjg0oT6pitU2WgR4RehlWu0LjLQ7W/goR3JaycFNxL73y9a
	ztVn2wkqvoNi0w/pxm6+Cs32kWk3MYZgVVhH95lNWbNzlCIh1/EoRJDcra3NqGTL
	szTUZc5KlF5sL0P00/6pKMUq3CnBjhWdZLx406fTknjIAF1oBlc+PG90tUB35TbP
	bR+VHWWYNCnHWMoBIY1iJZvorbkiRG5uWMRKOyNALyny/xobo/9QAJUxwLOX7Dou
	ESYIcks9ntaBckoQ2hKa3eQ3pEwPssr2ZIENGPXgiSPF2g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1qQ13vPvviAN; Thu,  9 Oct 2025 23:29:28 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cjR0g6B2wzlgqVF;
	Thu,  9 Oct 2025 23:29:22 +0000 (UTC)
Message-ID: <033ca444-4c68-4a4f-bc2b-32232e80e848@acm.org>
Date: Thu, 9 Oct 2025 16:29:21 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: Fix deadlock when reloading a multipath table
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org
References: <20251009030431.2895495-1-bmarzins@redhat.com>
 <ed792d72a1ca47937631af6e12098d9a20626bcf.camel@suse.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ed792d72a1ca47937631af6e12098d9a20626bcf.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/25 2:57 AM, Martin Wilck wrote:
> In general, I'm wondering whether we need a more generic solution to
> this problem. Therefore I've added linux-block to cc.
> 
> The way I see it, if a device has queued IO without any means to
> perform the IO, it can't be frozen. We'd either need to fail all queued
> IO in this case, or refuse attempts to freeze the queue.

If a device has queued I/O and the I/O can't make progress then it isn't
necessary to call blk_mq_freeze_queue(), isn't it? See also "[PATCH 0/3] 
Fix a deadlock related to modifying queue attributes"
(https://lore.kernel.org/linux-block/20250702182430.3764163-1-bvanassche@acm.org/).

BTW, that patch series is not upstream. I apply it manually every time
before I run blktests.

Bart.
