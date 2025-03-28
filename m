Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0938410FD
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 15:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743176689; cv=none; b=gtslKJaBgKYp2FkubRPpTVdf7mqr15Y1nz+qtrJE5Pxc2Ptn8fXMuLJPL8refHY6xW1Gdy2W7EswHHJeC2i32qwmFrSoc8J2YY3cPJVtDAL4/BZjcdj9Y87j5KC2U0+6JSsCvBH3Nwi8Zu+WlRdf6LfF0jIookTjCJwc6egaaBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743176689; c=relaxed/simple;
	bh=GiMFFaLZYbZChZp0cSq2OnAZMlNphEadxOUiJjQcKtg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fu1xtzkeexy4LPU7kzkS4DBqpZNTyGk1XqumQHMbKJExJztOLCyPXK4IibcaiLtKAHlTkE2/BTap++WjgXe+Z10sD4mMiPCkWjD7+fpmMG39o2ySh7+JmGZEJ7TcyLZ4IOe97XXdcm8k49i+a9Y1xJKQL8fYWX3+0KwAJcwWP4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bEf8o3qH; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bEf8o3qH"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZPPwZ6KJLzm24gk;
	Fri, 28 Mar 2025 15:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1743176685; x=1745768686; bh=8pXMnBEnxfNO++exnpabooz6
	aLJyfwdzkCrSAJq2u9Q=; b=bEf8o3qH3+YIjpQrbslhFWUYut8s38aMBIDBZ3Vl
	63VXDeJhaqCShaM8O+i30LT+PCmE7eWUntewM5u/1niLCsrbJP+HZu0cGlbJkyIn
	qEWr2UlHus6j1NXwOsIsuRuRiy83SFB365XM0pHou2c3Iw8tsUjlPWvhSi2ec3FV
	01KVeFGBMMpMi9bb8ZaxW7n6QfzLGuK3UdZTiOXaaXD9YoWpjoFxNstIV0X7/gef
	S9/No4xyAUh2N6mQzJxV0d9c5Chisl3rVSpawJJqSnOFAgaengRULftjZP6wro8E
	tlSXl0DL/LLpc5eGJWG7YDRRnhASPHj4nBo5qwTrdqxb5Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kFbYx9j0JHWu; Fri, 28 Mar 2025 15:44:45 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZPPwV4Pclzm26pt;
	Fri, 28 Mar 2025 15:44:41 +0000 (UTC)
Message-ID: <d634feda-406c-47c0-90b9-97e6b9a5419c@acm.org>
Date: Fri, 28 Mar 2025 08:44:40 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-ebs: fix prefetch-vs-suspend race
To: Mikulas Patocka <mpatocka@redhat.com>,
 Heinz Mauelshagen <heinzm@redhat.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev
References: <cd746c88-fcfd-12c0-8d57-29881ec4c96c@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <cd746c88-fcfd-12c0-8d57-29881ec4c96c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/25 8:19 AM, Mikulas Patocka wrote:
> +static void ebs_postsuspend(struct dm_target *ti)
> +{
> +	struct ebs_c *ec = ti->private;
> +	dm_bufio_client_reset(ec->bufio);
> +}

Isn't it expected to leave a blank line between the declaration block
and statements in Linux kernel code? Same comment for the dm-verity
patch.

Thanks,

Bart.
