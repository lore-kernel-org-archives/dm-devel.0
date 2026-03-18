Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D04B2E888A
	for <dm-devel@lists.linux.dev>; Wed, 18 Mar 2026 18:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773858097; cv=none; b=F67BnVB8xJ7vM371erY3mdX+xMoBoV1PrsvZcS/emI4J4DJJ9pNyDnN0yt34DPvDO1DsE6Q0DasIdj6bI6HxJ7bhEaMlP7CdhjpIFUC1rkRrCY0aTX7X8Kh4PXIpFi0aiQsefto9Zf4SPstBB5qX2v92KG5YDf0/mSSSwOdspH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773858097; c=relaxed/simple;
	bh=KudeWfXzRpzNYAwNK/TNR0LxDzCYq6S2Psn5dEqZXBY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jjNlgkiAmgUbzfRsI/++TbNUPak7/rCoXl0PzbDAJrDer4TKHnoD5a5dR/uQLnYzvrO7DgjtNDmVPaX6CF6723vy4+QSCTN1IK1hF6E6fHUjkJJLCqNJNQNS7qkDryaqzX6uvefWOqgzXKwAq4R9Pv5fM/3uCVc8lQkCh84K0eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Kd5cgP4O; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Kd5cgP4O"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fbcbZ3HYrzlfpMB;
	Wed, 18 Mar 2026 18:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773858085; x=1776450086; bh=9wSd/csnwm6zvrNQERDgHsR0
	vC0NTf/cgU5fB8YquAk=; b=Kd5cgP4OgWusrkA3bycQMWpJPW1HOzFsA2skfQ1i
	7jDOiSzUIINqERHqvqN8nmgaLHJol4FTsUtC+2vO4EwBfCzCA9GHy2PM71umUurm
	u19lqmvIE31tSb1yYA5L5ztioi0z3z5Amr+9WfD9zQax2N+xdvee2YvoMvEJmp/Z
	KsgQbE/RXUxPhqM7YXoRe5sGyDQLDGSPELmLwpbEunu7iTGXLJCpiE60Xih2+kHf
	ek2caHjPYrnNexZVd/3YwHYq1y5sibkiKt7poKH0tZielY1aZXos2OP2h9Mn6e9D
	fBbOzO90dKi8Yba8ObikA5gx0XvEOUBeUzonquPPAMLqBQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Ttdm6xLs9W9I; Wed, 18 Mar 2026 18:21:25 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fbcbP6RPwzlfvpK;
	Wed, 18 Mar 2026 18:21:21 +0000 (UTC)
Message-ID: <cd7974ff-e6ad-4e21-906c-df2ddc33c567@acm.org>
Date: Wed, 18 Mar 2026 11:21:20 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] dm: make "dmsetup remove_all" interruptible
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Zdenek Kabelac <zkabelac@redhat.com>, dm-devel@lists.linux.dev
References: <4a39a67d-37e6-bb5c-d08f-0fd4b75e5181@redhat.com>
 <79941ba6-cac8-4283-82b6-807c20729e76@acm.org>
 <bec39289-bf7a-2ba7-70c0-ec227c30d078@redhat.com>
 <8c60292b-bab9-4a7e-8014-8fa2dda3965c@acm.org>
 <54739cf3-acf1-f309-9d12-b7f59c0ca127@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <54739cf3-acf1-f309-9d12-b7f59c0ca127@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/26 7:31 AM, Mikulas Patocka wrote:
> The command "dmsetup remove_all" may take a long time (a minute for
> removing 1000 devices), so make it interruptible with fatal signals.
> 
> For better readability, the bool arguments were changed to flags.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
