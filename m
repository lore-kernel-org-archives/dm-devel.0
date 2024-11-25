Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5001F43169
	for <dm-devel@lists.linux.dev>; Mon, 25 Nov 2024 06:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732514860; cv=none; b=Wtig0a1YGIF4Zu3z6jQLRvLogM0NdUCMfk2lMYA4DJQiCvkc/2ZJELzC8yKm/nxz8CD9xvC+H0nj1NH8ZPtgp9e2P+cruI328csnEIuMrH7DCnxK4k1WWdCSpamuzymlWZsLtQe8DZhsl7AG1DIXOGJsAZLapWyhXuKZ9YmZ/W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732514860; c=relaxed/simple;
	bh=EaF8LP6Cw0Q1IJbfvqHTKFcFWHP5cGdVqoQKdmZP+bA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rRVrTzsItT9c9MDBxl1ApIRvXStQkVvEATEb6kpzNgH5NNXkZg871kAEh4J0XTn3qv5nXV9IqI8udQk0m8PRswtY1BXJYNNnI62ks8v9e5H/A1pAPXFISeTjDOclDZ78vVSHq8J+U0dKmGQO61wE67cZoOcACmObDdU4ZvZtGWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CWocc4w8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CWocc4w8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB10C4CECE;
	Mon, 25 Nov 2024 06:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732514859;
	bh=EaF8LP6Cw0Q1IJbfvqHTKFcFWHP5cGdVqoQKdmZP+bA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CWocc4w8zC+Aj5dO+lV/PqTS0XKOuRukbPjzY2T9Qdisp11lZW6jF9KkkFufAqCEK
	 wr5ylMr35pClvbrdq1u3Qax5siidcx7+z5JNbGfDzmT6sGtv4LAKVUM2tzG0Y6tuhf
	 AMeu3uBik+MPI5C9fvFtHCpWgTLOO5ZbXepxfk9NuHcDtuKmhgdd1DWUYCmh7a+bvZ
	 bPVvJV+a/h53+GD5nbTiHy0S0brqjF9lshVotQXdtcNYKPbJpUBwp6tLcr0+v36SuA
	 pXrsUlC6/9HQblIEC/whvYaEjL8jNEjLghhZ2cTxiR+6jxQvWvDlKMoqjzTofqdSM2
	 aTEHDEUIEhOVw==
Message-ID: <b01f1929-f1bc-4ed6-ae57-dded68f23e26@kernel.org>
Date: Mon, 25 Nov 2024 15:07:24 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-crypt: set max_io_len as chunk_sectors of zoned device
To: Christoph Hellwig <hch@infradead.org>, =?UTF-8?B?6Z+m6b6Z5bmzKEdyb290?=
 =?UTF-8?Q?=29?= <weilongping@oppo.com>
Cc: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
 "snitzer@redhat.com" <snitzer@redhat.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 "ebiggers@google.com" <ebiggers@google.com>
References: <SEZPR02MB7967C480572B3B15D5F57F92D42E2@SEZPR02MB7967.apcprd02.prod.outlook.com>
 <Z0QSqndKs1fyiOmJ@infradead.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <Z0QSqndKs1fyiOmJ@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/25/24 3:01 PM, Christoph Hellwig wrote:
> On Mon, Nov 25, 2024 at 05:58:22AM +0000, 韦龙平(Groot) wrote:
>>> What is ZWL?  And why mention 6.6?  And why do you care about ordering?
>> ZWL is Zone-Write-Locking and it was replaced by Zone-Write-Plugging on 6.12.
> 
> That's not a generally accepted acronym.  But more importantly it's all
> gone now, so completely irrelevant.
> 
>>
>>> There is no real ordering requirement in the block layer.
>> According to the design constraints of zoned device, write requests in the same
>> zone must be dispatched in order of address and there can be no holes in the middle
> 
> Yes.  But none of that matters at the device mapper layer.  Either the
> submitter needs to ensure ordering, or you must use zone append.

100% agree. But in this case, dm-crypt sees a single BIO which gets split when
submitted to the underlying device. But the split issues the requests in
reverse order, which breaks write ordering. So this seems like an issue with
the block layer rather than dm-crypt. Though I do not understand why I have
never seen this issue before, despite all the testing we do with all the zone
block devices, dm and FS combinations we run every week (including f2fs). So I
am not sure that the story is complete here... Never had to play with that dm
max_io_len before to get things running correctly.


-- 
Damien Le Moal
Western Digital Research
