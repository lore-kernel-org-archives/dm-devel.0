Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA5926F285
	for <dm-devel@lists.linux.dev>; Thu, 20 Nov 2025 16:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763656420; cv=none; b=p9miAj7uWGFHd3zH8iObSM7DKCxYPrzxYgo8B65UnTRNt7y6D8BRbNm23brlAhkY8x13LeT00v/CImE7gdqv9I5E8MZbKvjTgmTWUGpI8MZ0LrZaptcFtsff65EjahQjhgMuJ99RaoYEMSrssRF+10OJa7WWo/OjDSAWhdIq4oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763656420; c=relaxed/simple;
	bh=Uk8oiRhwyXd5ZcG6zsKeCLCXFDz/8CNKG0ICHlHPBpg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EZ3h26YZfvqMGIyDTYYMtNQMDhwrUg9fhnydqYEnTFG/Ub/kpkp9mI9CZMtVmTxrS02giW3IQ1L301Ss6BkW1kBagYZSpLqmeYZMA8fjDXmhwoKh1YgLHwnEbcbWz49xhSRR4BJf0je/z2fw1pE/yLPFm5IZVwsVlXnMCwAfz+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4M95xeCu; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4M95xeCu"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4dC3nY27x7zlvBYl;
	Thu, 20 Nov 2025 16:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1763656415; x=1766248416; bh=0HoYmzDaZ0wumgyy7MZbcCYd
	ZR76j6x/bR926aw6ER0=; b=4M95xeCuScajClc4/BHTUgSlTT3gmkDqlJWaiX+X
	fXtOJL02z5RXrWzsGiA5iYqF3wucg4xMla5Wv3yX62zbDSEDtH6Bo+G1ffJ3LTkO
	EFxuJ4udmsLF7mi2tlLF9Uh/Xp3NMgi1GRNKfRLwFb8C2GkSwraniT1hmHUTft9E
	+6ILcdy1oBuhYWPcxtXOIFKz369UQIovTNso7b5cmdoMZr7qSHhWqzeOwFVPK4wI
	ZybRu/og9SSz8TUNtZj+Q3Iev9dARsk7R/ZrN5dFR6qmC3t8g28g/6RXOWUYXoEs
	HPWUcWbxMFuthibDt7PtYe83WcTktP15Wnej2mXTYqEw/w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0RhdljYi_Wut; Thu, 20 Nov 2025 16:33:35 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4dC3nS1BFXzltH7K;
	Thu, 20 Nov 2025 16:33:30 +0000 (UTC)
Message-ID: <6bcc5168-c8ba-4cd7-8663-22cfb6ee1aee@acm.org>
Date: Thu, 20 Nov 2025 08:33:29 -0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: fix failure when empty flush's bi_sector points
 beyond the device end
To: Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Benjamin Marzinski <bmarzins@redhat.com>,
 Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@lists.linux.dev
References: <f99a8124-4b72-e049-3265-908fc48b7148@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f99a8124-4b72-e049-3265-908fc48b7148@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/25 3:08 AM, Mikulas Patocka wrote:
> An empty flush bio can have arbitrary bi_sector. The commit 2b1c6d7a890a
> introduced a regression that device mapper would fail an empty flush bio
> with -EIO if the sector pointed beyond the end of the device.
> 
> The commit introduced an optimization, that optimization would pass
> flushes to __split_and_process_bio and __split_and_process_bio is not
> prepared to handle empty bios. Fix this bug by passing only non-empty
> flushes to __split_and_process_bio - non-empty flushes must have valid
> bi_sector. Empty bios will go through __send_empty_flush, as they did
> before the optimization.
> 
> This problem can be reproduced by running the lvm2 test:
> make check_local T=lvconvert-thin.sh LVM_TEST_PREFER_BRD=0
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Fixes: 2b1c6d7a890a ("dm: optimize REQ_PREFLUSH with data when using the linear target")
> Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
> 
> ---
>   drivers/md/dm.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/md/dm.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm.c	2025-11-19 15:08:07.000000000 +0100
> +++ linux-2.6/drivers/md/dm.c	2025-11-19 15:08:35.000000000 +0100
> @@ -2005,7 +2005,7 @@ static void dm_split_and_process_bio(str
>   		 * linear target or multiple linear targets pointing to the same
>   		 * device), we can send the flush with data directly to it.
>   		 */
> -		if (map->flush_bypasses_map) {
> +		if (bio->bi_iter.bi_size && map->flush_bypasses_map) {
>   			struct list_head *devices = dm_table_get_devices(map);
>   			if (devices->next == devices->prev)
>   				goto send_preflush_with_data;
> 
> 

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
