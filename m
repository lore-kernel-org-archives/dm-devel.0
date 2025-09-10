Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D376522759C
	for <dm-devel@lists.linux.dev>; Wed, 10 Sep 2025 14:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757512951; cv=none; b=uJyt/q4uQ8NDjpqCyGDc7m2+WB0mhbgpsOk8Fa5u/Z2iLVYMtnK5MP03Fp9vde3Sif73Vf5tOWAlpBDXfuo9mhQx035wJH9v3YrBE/4a569Dq05gqnap37/KYnW+9sifGBoOvG5vXnIOCojqT3CEzjWtKInewWghXncOlmO+rQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757512951; c=relaxed/simple;
	bh=apsPxTLVgWJO+nn0BnBmexVj/Ub0db7wA4Bn3QcfsVg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hDDY79jw1uF5vSOTkiomkhlQODbLkzhan7BSumRQfjLd9N1MVgnpupPO3+1dumfsQWoF9gQ7dPYMyc981Fc4/uv5hPDpHVLLKkxNUZhPmRHQSwCWvAtKnxtk48s9Md+O0OW9p/7LaA0d9NHSxxm6pjA2PwGbAssx67Y5PEIRZqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hdygI1RG; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hdygI1RG"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cMMnw5DS0zlgqxf;
	Wed, 10 Sep 2025 14:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757512947; x=1760104948; bh=apsPxTLVgWJO+nn0BnBmexVj
	/Ub0db7wA4Bn3QcfsVg=; b=hdygI1RGFmG8QoGVp1lDEhMKDrsQ5NWTTPSwTMkl
	rUFI1LzfTtj/AU9ITLhWZUGDV1libaRZdtIbuuWtxBCQHQNA8kG8QuHHGRvENNt5
	6g83d3T2pWyBngfHHQa0SkKJZ+WX0PnPI2djZgTb4t3IdOs5TPWLtfphExfORhXx
	EeydPGu2VhIvSIaEZ0kNSa6jf13iUFB9DmjPOBzPPYB1LztL+qFJBuFkLyOnIxez
	LNuhAygbi4SVinXrdRoIbr7/+cwkoDUVU5+fF4T70ciQjhMU2HfO4Ko238W6Y995
	zG7vd+BoqD2cL+Qbr9xtJ9k3pAmzbHVHuJ7PmkhNv6auZQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wS4nmCHFWhYt; Wed, 10 Sep 2025 14:02:27 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cMMnq4hBrzlgqVc;
	Wed, 10 Sep 2025 14:02:22 +0000 (UTC)
Message-ID: <0113cd80-b743-49b6-8e5a-ca0dda4a01e9@acm.org>
Date: Wed, 10 Sep 2025 07:02:20 -0700
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
 <f4ca5122-a24d-4d37-8b90-2fdc2aed7699@acm.org>
 <f3c4dfe5-5930-4fde-bf33-1a5004a98b23@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f3c4dfe5-5930-4fde-bf33-1a5004a98b23@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 9/9/25 6:38 PM, Damien Le Moal wrote:
> Then please rewrite the commit message to clearly state that and add Fixes tags
> as appropriate.

Hi Damien,

Do we agree that sending REQ_PREFLUSH and data as a single bio instead
of as two bios is a performance optimization that neither affects which
data gets written nor the behavior in case of a power failure? Do we
agree that the Fixes tag should only be used for bug fixes and not for
performance optimizations?

Thanks,

Bart.
