Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E28156F45
	for <dm-devel@lists.linux.dev>; Thu, 11 Sep 2025 23:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757632577; cv=none; b=Q1y4WheusScmevLD3N6iKFxFRJYa8F9p6DLwO+yp5veXXwxVxUF+3MMH+5+xwj22XiouQtq0VttPLrxsWwbEBwNPVk2XF6pTA0JErDLLAwMG7n1UyLAtWkCL8mTfSJz6yv0S9+t1L21/i0a4hS6kDpVnppUHgLZ0/Gbob5FhLYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757632577; c=relaxed/simple;
	bh=PtBSs8bYX1H1C5PJFO93yEt5BxKk3A2/Swr50J5lHHE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iy1u+bCYWcqd/zxoTZscxcs1xRwl6jqTq1GIL2TgIoSLPzmQHEsap8NxiKX0eG3KQhKHKwVsiuUBoE7d7NaNqxSPmfRrTZ1NAGSmfR7aDzJyq2CJyM3Zq50dmMyH2wv9LzJTnmokZzrwRo+m4Xq3H1Ucc53wtDScQAH2gzx6mgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Y711vjV7; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Y711vjV7"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cND2Q0b1HzlgqVQ;
	Thu, 11 Sep 2025 23:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757632572; x=1760224573; bh=Lm6cXYWeNpBkDor0mlJmSAxx
	wWY2p4UukqISO46Fxv4=; b=Y711vjV7Eeqx/1KKrucNAEB5t0qavbxCCkxEziv0
	U5YtYxCUAVgoIB1NitHZoqnBQCSJCPe3BXVFCteC+pzxW7HrFAG0+S9OxYvIwytk
	yU8GQTDwMmrvITmbv1WZ6+YmTYggSJAsbacqsGvSzpuC21hxvaFirAfBqXUgqAeb
	AjENIKVMdtRDer/rMmAkOply10wSJcxl9/a3TPaNqzAFDyyg0O26OkWIlseJxpPD
	A/lPweDI1Q8TE6vnK8rUMXX2FSJAljC1cw6+p59qmsQ0no9Sy7ZbmZhTGpxN7T4w
	qKZbxi2j8lVSVdgsBQIbiRDmfdEf3SJ6F4sBVFd6hN6mJA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iZuOR3hZFcQD; Thu, 11 Sep 2025 23:16:12 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cND2K263Pzlgqxj;
	Thu, 11 Sep 2025 23:16:07 +0000 (UTC)
Message-ID: <c89d0b4a-35a8-46eb-b078-e65102a0b817@acm.org>
Date: Thu, 11 Sep 2025 16:16:06 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dm: Preserve the order of REQ_PREFLUSH writes
To: Damien Le Moal <dlemoal@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Alasdair Kergon <agk@redhat.com>
References: <20250910172742.187645-1-bvanassche@acm.org>
 <4f959ea8-b3c2-402d-9777-48abdc488ba7@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4f959ea8-b3c2-402d-9777-48abdc488ba7@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 9/11/25 4:03 PM, Damien Le Moal wrote:
> I suspect it is because this will be handled by the flush machinery during the
> submit_bio() to the underlying device ?

Indeed.

> But if that is the case, why is it a problem with multiple devices ?
> The same block layer flush machinery will handle that preflush write for all devices.
The REQ_PREFLUSH semantics require that the REQ_PREFLUSH is submitted to 
*all* underlying devices before the data that is included in the bio is
written, even if the data in the bio only affects a single underlying
device.

Thanks,

Bart.
