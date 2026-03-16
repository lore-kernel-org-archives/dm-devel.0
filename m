Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E596F3264DC
	for <dm-devel@lists.linux.dev>; Mon, 16 Mar 2026 16:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773677146; cv=none; b=N3TzMf7nl7QuXIguvypp/Pyn6B/0R4mjKykWytcEblYbG9P8gC5XntTwHNJ5GvRWZqesKncUOkg4qewCGPnheiCn0xdbogVNTKYplDFEHUvGputl8loR4W8xNdHsxBGRLO56Q+zViUpW7DAUPZSm60m78clXJ6VpQCOitvblhvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773677146; c=relaxed/simple;
	bh=payu0TckFHtcaeOewomzT3y4bitN2PUu4p7UEmCKWAY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=psZaiI03ANdwJxDj9Bsymw04uAmAFmzcv7JJNkznQTcvivLAwRoHyjpfiQjwuKgptuFQ4troWESAuSjHIIMri+uL5WtmwwDoV5i/D/96GXpGtvGn/uJTmWduu3H1VcSzLPE0j1DBG91SSb1zY7jNJKyb+iKRHi5uF8srjyOdGP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QK4DqfLr; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QK4DqfLr"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fZKgj2wbjzlfpMB;
	Mon, 16 Mar 2026 16:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773677130; x=1776269131; bh=T8yakr3dzy/WuQ3pV18aBS6H
	drRHTZpr2uplvFKp6vM=; b=QK4DqfLr/73YOSpd37CRkKecCSN20ZgCgzOf4exA
	32RzYtKt9K79sC2oN+lJd384iZSSXo/uXqDilal9iy1/b7AlCHR+SOaDBqmAEskN
	ingmJjhxJXT3u7vyWMoUBtMEGahTH77rAzihk8k08KWN7sSUkxZYWkpHncCD1HYy
	JfBcOJ+JwIZMKu/v3sNyfpgoDcF9kMbb2cERzALvmrgBi0DTQeeEeqypyninkrfq
	dlED+nhOGkkSLmFItfgb3UG0Pq9YKB5hSZy1cAxYT1tWZSN70lEipEjDwdnCcVKp
	9AvhIVeURjkPgbs11Drj45z+f8ZQsxTro2QiJ7vE8xdMMQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id r9b4W94acjyv; Mon, 16 Mar 2026 16:05:30 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fZKgX5GtczlgyGp;
	Mon, 16 Mar 2026 16:05:28 +0000 (UTC)
Message-ID: <79941ba6-cac8-4283-82b6-807c20729e76@acm.org>
Date: Mon, 16 Mar 2026 09:05:25 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: make "dmsetup remove_all" interruptible
To: Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Benjamin Marzinski <bmarzins@redhat.com>,
 Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@lists.linux.dev
References: <4a39a67d-37e6-bb5c-d08f-0fd4b75e5181@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4a39a67d-37e6-bb5c-d08f-0fd4b75e5181@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/16/26 8:55 AM, Mikulas Patocka wrote:
>   {
> -	dm_hash_remove_all(false, false, false);
> +	dm_hash_remove_all(false, false, false, false);
>   }

Three boolean arguments in a row make dm_hash_remove_all() calls much 
harder to read than necessary. Has it been considered to combine the
three boolean arguments into a single flags argument?

Thanks,

Bart.
