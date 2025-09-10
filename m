Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADBA1F03D9
	for <dm-devel@lists.linux.dev>; Wed, 10 Sep 2025 01:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757467766; cv=none; b=qFkY0qSCOKy3NWWjKrlHNfMqob//t+aT8RRMZKHp+MoZpPuVBj8fxMxJsTkgpKCs+kD9884fujPuyg0/8byfk0uyxp+4p7WqV3u+UYUpyj4D1hiVsEWoO8KroO3WM2bTQzvFZBugGNVjLWKGS53xoeF8mgkETSL5trw6KXciOS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757467766; c=relaxed/simple;
	bh=HyggJ3mTDFchye6Sfdl2xFIe/F/+92yY85vZm+6tATI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PxzES/oOt3gB4o4Rj4NXGCfoTo4vmYFh+FUZ8528C/TIxJQKZTKehsB6v+TzscaikLRdsGJFQdKmW1Tfaq9nwO2wa6mD4saK9Kcs3BcoIOivtITjY3cR3a/8piulehBZlptysvWYzLI7X2WRi6yfbM0RhlRP6xgdRddXvNPN9i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QkTJzV0i; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QkTJzV0i"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cM34x0XPLzlgqVg;
	Wed, 10 Sep 2025 01:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757467759; x=1760059760; bh=cGHQ5h8BcXyWseI6OtGMESR0
	igIvtu47KUAgoTqLVSo=; b=QkTJzV0ioilsJUaqm32V+vtB03hhVoYAB6mYcFKF
	BaOXWhEeclyPohIPIZ35ZsY+mzcjEoAeOQbwwXjbmuL1TA2TUKeP8JSAgbo5VCB4
	kMizdY/YnIZl8BLJPo8WtIkDmWgrV7Q7cuKQPI/+VlEGgqXsnvd6yJ4TVCC4nkji
	/NGV06jE05U58oyK4kcNUrnGdKTiFIIpWbt9uhhinxyXafVvlmiekY8KjUSN/pzb
	IjLT2/hb6Cga5t8L7rOVibAZToeO7dqMeCDpMSjUeubpWwtmZaMUBm0aa81XBeZz
	oBUrWJNkHisrIijlsEXQ4SXHLs6P4Fz3EyFog4AMeb/j5Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id K2952WkFIXg1; Wed, 10 Sep 2025 01:29:19 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cM34r0R62zlgqVL;
	Wed, 10 Sep 2025 01:29:14 +0000 (UTC)
Message-ID: <f4ca5122-a24d-4d37-8b90-2fdc2aed7699@acm.org>
Date: Tue, 9 Sep 2025 18:29:13 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: Preserve the order of REQ_PREFLUSH writes
To: Damien Le Moal <dlemoal@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Alasdair Kergon <agk@redhat.com>
References: <20250909182641.3496300-1-bvanassche@acm.org>
 <aec57265-20e4-4012-b3ae-8cb9c375da60@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aec57265-20e4-4012-b3ae-8cb9c375da60@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/25 5:53 PM, Damien Le Moal wrote:
> On 9/10/25 3:26 AM, Bart Van Assche wrote:
>> Splitting a bio into an empty flush bio and a non-flush data bio is
>> only necessary if there are multiple underlying devices. Do not split
>> REQ_PREFLUSH bios if there is only one underlying device. This patch
>> preserves the order of REQ_PREFLUSH writes if there is only one
>> underlying device and if multiple writes are queued. This patch fixes
>> a write error observed with zoned storage devices and with write
>> pipelining enabled.
> 
> Write pipelining is not upstream.

That doesn't matter in this case because this patch also improves
performance without write pipelining, even for conventional (non zoned) 
storage devices.

BTW, I'm still waiting for a review from you for this patch series that
was posted two weeks ago: "[PATCH v24 00/18] Improve write performance
for zoned UFS devices"
(https://lore.kernel.org/linux-block/20250827212937.2759348-1-bvanassche@acm.org/)

Thanks,

Bart.
