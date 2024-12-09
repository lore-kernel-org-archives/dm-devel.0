Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96711E86E;
	Mon,  9 Dec 2024 08:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733733622; cv=none; b=WZkGSvHRlGPwjQgYFaafj3INR9V9iRjtf1+W88T8qQ2KvsuyKjXX0CNtgYwMunOkmplfl+VnGPxhMyAO7OBBXOgMbmA7XCXU7sXnQSbwGlC6QBnXh9ONIkD5HGkGzVqvxa/ElV1w3RdABG3zyaINyZse+UFnNLS2s+0si6cialE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733733622; c=relaxed/simple;
	bh=+zXbQpC8eRE2IOKbKykJmRr0t8JwW226m1ySHSY1ng0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uuu2T81lBSpzXb67zVi3V1QF0ZyJ9UUP6sCOB4kdj14qSqv1oRbC5u0CPr9bcaeklg0lQR1aWtCFKW0nkwRUrz9t6HJ2uw8LjsfXJARwEmk3LITyIPtRMcBRFIg5FQz00kpAYyrnae/cYpGGSlhCsMXi0PZ8KtMzLYxe27IgHsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O965D8z6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O965D8z6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC98C4CED1;
	Mon,  9 Dec 2024 08:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733733621;
	bh=+zXbQpC8eRE2IOKbKykJmRr0t8JwW226m1ySHSY1ng0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=O965D8z6Qtgnzbt9bBtKTxoyg2uMCh8QvtPq09ltvcUZn0j9zK5o22jY4aA73KDic
	 hwsKEKmMwIuSNVucqyvFlJbGJGQmIao1pKhqtGUjcWhgxQYIQBgZT61gGRG1kRvbQU
	 fJTZhcmDXE+lgabed02qJRXn3Oe9LzNIidrI8eDBUS77h8QAUTlVpoUjJrgdfSjBh8
	 zazqMzDOM37LuGuxY+LH1oAOn83QJqToueEWcMMgOLC1SVqjLjyYbR47Xq9Nvc3NQ0
	 9c/oUrsvkdZ8pJ0KrBhjv063wuJSjcMqMZkTrU+jjVv12fDnhLZZzUHUfMGpILhf+B
	 9gjluVFXYIl8g==
Message-ID: <a478509f-bac3-4324-8408-465c6ed3e8bd@kernel.org>
Date: Mon, 9 Dec 2024 17:40:19 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] dm: Fix dm-zoned-reclaim zone write pointer
 alignment
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 dm-devel@lists.linux.dev, Bart Van Assche <bvanassche@acm.org>
References: <20241208225758.219228-1-dlemoal@kernel.org>
 <20241208225758.219228-5-dlemoal@kernel.org> <20241209074408.GA24323@lst.de>
 <56ee11bb-0dbc-4498-a529-b2f47e92e934@kernel.org>
 <20241209083938.GA27113@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241209083938.GA27113@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/9/24 17:39, Christoph Hellwig wrote:
> On Mon, Dec 09, 2024 at 05:38:40PM +0900, Damien Le Moal wrote:
>>
>> The problem with doing that is that there is absolutely nothing to patch/fix
>> before the previous patch, since the "recovery/report zones" was done
>> automatically. So if anything, maybe I should just squash this patch together
>> with the previous one to be consistent against bisect ? That does make sense
>> since this patch is needed *because* of the previous patch change.
> 
> But it's also harmless to do the extra zone report.  So just state that
> in the commit log.

OK.

-- 
Damien Le Moal
Western Digital Research
