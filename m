Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF455204C2A
	for <dm-devel@lists.linux.dev>; Tue, 18 Mar 2025 15:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742313535; cv=none; b=gVFbqP4ReizNBgUYe7VECLYtFNoZGxwwC3UObyBi49TAilwuVPFgTSDQMfpMo2754NLTzG7ZPo20oXZcvXURsuRttJTdacaBEq05scIWUe3HbKZHWxXZi6O+fLY/V6vxDk0RwP3J+xPNEYRlSyBKfTLm/4zeFDct1UVCKGT9C9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742313535; c=relaxed/simple;
	bh=UGfoUx6lMsH9eT9Pw7Oz4KHmCd2X1wzDfzHoq83/g4w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PZUTiA9nF0+/lBFvpEdwQ+f6pHNA9ekNqSzQpbXV3+w7cIe3HG21Lub8P8Yvk+/xVKp+CZja1Pg1M7KyjTF3CuEHXstLdCWptvRMpIuccW4q43vbe1tgMG4IEIsoZEQdmv+dRS6qPdUIezTaSP1XuL7qfYJlCoHzNirmGUbNIqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Df+gTtKE; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Df+gTtKE"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZHGjS44TVzlxYTq;
	Tue, 18 Mar 2025 15:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1742313531; x=1744905532; bh=UGfoUx6lMsH9eT9Pw7Oz4KHm
	Cd2X1wzDfzHoq83/g4w=; b=Df+gTtKEVZGttZdXe2Yds9+rIJTpQflH7z+qKj0q
	nKDkzOfXDF1kReDP0yLx//RGv5x4OYTZsLxlg1KvzQ9lv6PZfi8wnvq0Z841Jzqg
	13u2oieE1cH5MYYtf03L/F6eyux0Up1Bp7u+lFYezAggVoqMaYwK4NGFw5YxMaX7
	36EDbEdtpDFZoeZ6asEcT8yJKWUyYOqTccs/rwVLJ6pMHW1Uqpo1QQBQvAleMQOn
	n1tkfBkIh49e5A3zcKt2E8mfLihD4zxiZulGJCgEURf6lVHHloHRE+pUvFeGoc7j
	6aGcy2n8xedv+8wiYrvDpJADT7OahbCwZ2GTVExmaV6fbA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wodDOzFf-k6j; Tue, 18 Mar 2025 15:58:51 +0000 (UTC)
Received: from [172.20.20.20] (unknown [98.51.0.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZHGjL24jnzltP0X;
	Tue, 18 Mar 2025 15:58:44 +0000 (UTC)
Message-ID: <14dd4360-c846-43e3-86bc-b1e7448e5896@acm.org>
Date: Tue, 18 Mar 2025 08:58:41 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATC] block: update queue limits atomically
To: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev
References: <ee66a4f2-ecc4-68d2-4594-a0bcba7ffe9c@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ee66a4f2-ecc4-68d2-4594-a0bcba7ffe9c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/25 7:26 AM, Mikulas Patocka wrote:
> The block limits may be read while they are being modified. The statement
> "q->limits = *lim" is not really atomic. The compiler may turn it into
> memcpy (clang does).

Which code reads block limits while these are being updated? This should
be mentioned in the patch description.

Bart.
