Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321EF33509A
	for <dm-devel@lists.linux.dev>; Mon, 16 Mar 2026 17:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773683926; cv=none; b=GnqCKNMtvkIj7YmVZu410s8bpOrYyZck52p3cCxiR7PICJoEUBk5hoi2BtFJDg24xwqYjlzYU9JEFpctLe/gxlCctJoqBCE02RpnblHZJrH17vzdOWExCMsA0SPSSTfMpZWWcWF6/8Uho/XgC5xErAIUlUq2Kw9T8T1AVXZYfis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773683926; c=relaxed/simple;
	bh=6JMNN/PgC19ArVZR4txicUclQE7LDvWqMnY6JK00IVs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=beFejdcp0/fwqJehc+8WsMdGu5w6sZL/Wtz5e/iwNYx8okBA/T7ENXT4lzZDh+zU8Z0ofLf/5pXMROQvkkf9KTT3xzP1zXzFAH+WFwACI7jM5FRtiIYge2k4UAKr98V6Lan23bHOz+5I2KicLeEfWmhEJbmqZBVwak+yn9r+r0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=g7BvYn9y; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="g7BvYn9y"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fZNBD5FhBz1XMFfn;
	Mon, 16 Mar 2026 17:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773683921; x=1776275922; bh=4L4cv9eTGdmFb5D5VqYy1jeI
	2EuOEr6X69hibzq3KBM=; b=g7BvYn9yRrSaHp+BMWmMRM69oz6InPyICcsZmCLY
	9RvfPL/1W9F4qIU3XuaHxW1AgJOddvwv9Rvi/QYgB8AbmhKC86fCdPxnJT3tPXzy
	HNBsI/+oYhKLCQR7jSbXGHFfOxakzO8E2B7pXPN8GdmUnj5C0g3mosZkOzeByal4
	yggCp+ADMGQox6yXqoYScX1KINaWfTARbQBqbG1PIpZchiB2CTfXRYSzhB35svQh
	5tLux4VSJeRNFKGVQqGTmIsV6R0eGcumvr6NcWeMOIbbiRs5wRYBTjtefefg9WQw
	sMoZorBexavge0A/T6w4WPRbo40XwWeaUcyuHbrMakBsdQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SG09Gy4Ubz8a; Mon, 16 Mar 2026 17:58:41 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fZNB83c0Lz1XM6Jf;
	Mon, 16 Mar 2026 17:58:40 +0000 (UTC)
Message-ID: <8c60292b-bab9-4a7e-8014-8fa2dda3965c@acm.org>
Date: Mon, 16 Mar 2026 10:58:39 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dm: make "dmsetup remove_all" interruptible
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Zdenek Kabelac <zkabelac@redhat.com>, dm-devel@lists.linux.dev
References: <4a39a67d-37e6-bb5c-d08f-0fd4b75e5181@redhat.com>
 <79941ba6-cac8-4283-82b6-807c20729e76@acm.org>
 <bec39289-bf7a-2ba7-70c0-ec227c30d078@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <bec39289-bf7a-2ba7-70c0-ec227c30d078@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/16/26 9:37 AM, Mikulas Patocka wrote:
> The command "dmsetup remove_all" may take a long time (a minute for
> removing 1000 devices), so make it interruptible with fatal signals.
> 
> For better readability, the bool arguments were changed to flags.

Does this patch follow the "one change per patch" rule?

> +#define KEEP_OPEN_DEVICES	1
> +#define MARK_DEFERRED		2
> +#define ONLY_DEFERRED		4
> +#define INTERRUPTIBLE		8

Has it been considered to add a (short) prefix to these flag names?

> +	int r = dm_hash_remove_all(KEEP_OPEN_DEVICES | (param->flags & DM_DEFERRED_REMOVE ? MARK_DEFERRED : 0) | INTERRUPTIBLE);

Code readability could be improved by writing the above code as follows:

	int r, flags = KEEP_OPEN_DEVICES | INTERRUPTIBLE;

	if (param->flags & DM_DEFERRED_REMOVE)
		flags |= MARK_DEFERRED;
	r = dm_hash_remove_all(flags);

Otherwise this patch looks good to me.

Thanks,

Bart.
