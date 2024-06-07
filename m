Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA6F1B974
	for <dm-devel@lists.linux.dev>; Fri,  7 Jun 2024 05:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717737735; cv=none; b=uXsJBTT3W/UgfQYWT2xVq3JvXrE5xRcE8Uh1Zks6/IjGKxXnaDBRCBhX89+fRkz/ITQ1kaN1I0TCQQMHF0mqpbnCVpkwhb7hsgk+Mx6XRNjNZ+OUXmyU4YorpkRKgzP5zlTO4o3T+SNRF2GQxgk5rvB+OvVteU5KVD2DD9ibmok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717737735; c=relaxed/simple;
	bh=TgiqEyX9QcvkNt8NP1zRKNQy2QhBhV1rerpvjXZlw2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i6WcowCTb1d67d4LdHeE8QIsmZZTZDz4eZbsESL61WXGRXux6NgFEuPm7yk7//+LcMafM8mek9cln/igwNJc1GWil1s7exfsjrZlPyj4nlceZK3kTiHo68oYDtQs3c8n2XNV4/3l12XEDc/BPIhTNbGCZsNX56Ngph8cuH+4noM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qXyRczcN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qXyRczcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AF2C2BBFC;
	Fri,  7 Jun 2024 05:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717737735;
	bh=TgiqEyX9QcvkNt8NP1zRKNQy2QhBhV1rerpvjXZlw2U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qXyRczcNJSLk7Ur4Ladsfmb2g7R1q4Wpr0xBuYXxpy3lZDW+bDgEXklaIJDIv1EMh
	 VManMKpnTd3O/uZtebBen5/YfUCjoNHoub7qhS3zDmIRAkYGwYivRR1iq7ArQUoDhU
	 wVANYrrvEm62tGNpouYCZ2zfrbLLYyo1gK/kDvmwUfdXsSB4lB6lLQhITHn4Zgl4be
	 4YPVB5YA+aj8AjywzCkn9TytguGQqeworaQ3kA8VW3UzFH2S37PsuODkwvF9KppyO0
	 Aj9ohsdUGO5eZtdk8O63RbbR5tEnrF87HTg2F4LOk4NTovN90E/RNwDAySUBcKDz2G
	 +D/QWuFUaLUPQ==
Date: Thu, 6 Jun 2024 22:22:14 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Sven <dm-devel@schwermer.no>
Cc: dm-devel@lists.linux.dev
Subject: Re: dm-verity requires WQ_UNBOUND with mxs-dcp
Message-ID: <20240607052214.GA38537@sol.localdomain>
References: <296810f8-367c-4a33-b315-3074690d4c36@schwermer.no>
 <20240528194201.GA1201@sol.localdomain>
 <744da05c-4adb-47e2-b4fb-ad30127d979e@schwermer.no>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <744da05c-4adb-47e2-b4fb-ad30127d979e@schwermer.no>

On Thu, Jun 06, 2024 at 03:12:26PM +0200, Sven wrote:
> Do you happen to have some more infos on the self-tests you mentioned? Can
> you point me at documentation, I coulnd't really find much useful stuff.
> 
> Thanks
> 
> On 5/28/24 9:42 PM, Eric Biggers wrote:
> > Does this driver pass all the crypto self-tests?

The crypto self-tests can be enabled by unsetting
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS, and preferably setting
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS in order to enable the full set of tests.

They might catch something, though they don't test parallel usage of drivers
which is where it sounds like the issue here might be here.

In any case the bug here is likely to be in the mxs-dcp driver, especially
considering that drivers tend to be much lower quality than the software crypto
(some driver developers apparently don't even bother to run the tests).

- Eric
