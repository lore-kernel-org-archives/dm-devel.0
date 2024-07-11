Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8696C12D205
	for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 17:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720720778; cv=none; b=jH1Z3i9BF+WIzy8il7sqsZuS5W8Yu7nXSy/95AvnVPQSbVCqyyoS07UjyTVrF2jFxOmbNYFcRaaVn3dUPVXpyfsty9M9dUgwiJnQVmoXD45IFehAwv77MWA2zOJ/Vm/t1BTdrDi3M3TG6ddgvHQD5caTzf+4afc3J8KkIctIPNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720720778; c=relaxed/simple;
	bh=ylJ6o6bHYygfqwj8nQodeINNa6RSg4/HCe8TwGomfL0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MZDa1H8lk3TRUs7zZnXyfPlYKjEWa1KKfZEVJUBrTPUYk35BJHZFa2YblMxd4M3ksYuIoBVLhtcspcWYzCtEKw8lJvC8vcTr7UOe7R2SZUNMRf9MVWxubiV4CgeDeXVES6V0j0xfA20PqdkxpfZZfMj3V70jHL4GJyafrBlWq/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=U5zdrOk3; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="U5zdrOk3"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WKjD90HC0z6CmM6X;
	Thu, 11 Jul 2024 17:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1720720774; x=1723312775; bh=ylJ6o6bHYygfqwj8nQodeINN
	a6RSg4/HCe8TwGomfL0=; b=U5zdrOk3OoTtE/kXICPQkF/BfHov8F9vkpYDngSf
	Po++M9IWA40/6gPtzLxe5sphv4CIuONqRCJBW+Z12402HAAqCF1Hs8ZbYAZY26iH
	iLMHhOoJEiJA9kdMedAKkAgMmSzzXbVo/z5tE+vzH1Hso03Uv+BY/2jXisZLb7Hb
	gG7QQKv7fBWmF/KIH8IENrRMqZRLlaoDXfoX7iQ03hYdPAmXXJN5KYLzCjaNMtPW
	GbKNJ7gbvvrNAk320MLAdWZKXQZhKjZ6VH+9i5TYrzvh8IF75LmvbQS41+LZ9uX9
	Yz2bwbw4+0yt8P6jJRSSXmJsdNjge8h85RB08mAql+/43A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7HQ2kdDD27Qc; Thu, 11 Jul 2024 17:59:34 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WKjD6103vz6CmM6V;
	Thu, 11 Jul 2024 17:59:33 +0000 (UTC)
Message-ID: <bba377b4-16f8-4a28-9177-bcfec2f75c89@acm.org>
Date: Thu, 11 Jul 2024 10:59:32 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH blktests] dm/002: repeat dmsetup remove command on failure
 with EBUSY
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: Bryan Gurney <bgurney@redhat.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
 "snitzer@kernel.org" <snitzer@kernel.org>
References: <20240709124441.139769-1-shinichiro.kawasaki@wdc.com>
 <CAHhmqcT6F_b8ZJMbm9jbL0Zg-vv6zq9oxfMttzf1K4GH-zz=NQ@mail.gmail.com>
 <e767864a-7ecf-8459-30d5-daa654b4c0d2@redhat.com>
 <nmildf5tauvp34aeibmzwcxao4ujbwnkkkesollifa4w5uwf2v@qi3pzxidduca>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <nmildf5tauvp34aeibmzwcxao4ujbwnkkkesollifa4w5uwf2v@qi3pzxidduca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/11/24 3:39 AM, Shinichiro Kawasaki wrote:
> It showed "Comm: (udev-worker)" is the process which keeps the DM
> device open. [ ... ] Just adding "udevadm settle" before "dmsetup
> remove" will avoid the failure.

I'm OK with either the retry loop from the patch at the start of this
email thread or adding "udevadm settle"

Thanks,

Bart.

