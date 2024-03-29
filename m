Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE6E139578
	for <dm-devel@lists.linux.dev>; Fri, 29 Mar 2024 21:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711747355; cv=none; b=VgwDdMkiySmJLbty/J6u8dTeSFNTgBtRJskAdb3rPTp6A2BPDlCJEXjRdLApyZ86t+LEdZ0zhAzlNAH8dTJj+64FCle3RfJMMPgi7EIkojY1cQAs0Uzq4epcynmhZMpJc1McTMTKZA7WtptGU3BKW7l3/8J0/9p+StZgzCyRMEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711747355; c=relaxed/simple;
	bh=QgZYRYaa8a9iCxhW7qjxiU+OnRe8oTJFGisnmUV8P5c=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XsBCvwbiGVVr/CDETrcVX1RXUJHlLEZw1jSQx4sHNIOaJqrL1HQo7xeE6WfR4UmloMsGmF2VG9bhgVx89W0hqlCDO+h9e2rx1yoRp6UmVK8+uI3LSwAvh4S0Z5djNm5B9Lsy7OxCDinP7Ny2tKMcH774bkAZspNh97pqyxNK+vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vqlBIOnm; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vqlBIOnm"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V5tfK6FbzzlgVnN;
	Fri, 29 Mar 2024 21:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711747350; x=1714339351; bh=QgZYRYaa8a9iCxhW7qjxiU+O
	nRe8oTJFGisnmUV8P5c=; b=vqlBIOnmERprvcdhibbbOjSOXSiGVzGIYUBgy4t2
	f659cctbeAEw6pf19gZrbbQ7JegB6djAQB1ep9oAMzVksnZfYUbAhl3qvcR0Aoic
	3howFRbyJ2JejMPnnlnbviz04FAxLU240YDqGqDa2510ryTCWPgc5jpLlEkRmFT8
	Svq8+kNnXoENsWpoXpwXiD8FiAqh6NbfIr+w0NJCfTDcmuroEM5bxDGUFUTowfBT
	ZrJmsoMDbxtMEnBGFJlmwnk5rG+qoqKSqi2SstX7lVcShaL+BJVPW1J3sRIIb3+B
	tZpWO/GYo10SwD8OIQ36h9rmvmkmB5A7wbzUdKebMxOyYw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qEUGB76_WZXP; Fri, 29 Mar 2024 21:22:30 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V5tfC6gcvzlgTGW;
	Fri, 29 Mar 2024 21:22:27 +0000 (UTC)
Message-ID: <35ae7b56-b624-4bf7-b112-35c620719e11@acm.org>
Date: Fri, 29 Mar 2024 14:22:26 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/30] block: Implement zone append emulation
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-13-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328004409.594888-13-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 5:43 PM, Damien Le Moal wrote:
> Given that zone write plugging manages all writes to zones of a zoned
> block device and track the write pointer position of all zones,
> emulating zone append operations using regular writes can be
> implemented generically, without relying on the underlying device driver
> to implement such emulation. This is needed for devices that do not
> natively support the zone append command, e.g. SMR hard-disks.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
