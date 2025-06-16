Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0322882DE
	for <dm-devel@lists.linux.dev>; Mon, 16 Jun 2025 02:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750041040; cv=none; b=qoNB/d9WUnYoNvuQR5QoUA6zWXOAmzRRFmsyv4qnrlTQCUv85D6jRhT7GdXGy9tY9iswjsA4ZR8EPBEfCMJH1+XER8kjjyNn026O+qeFMlKN9qC6E10vQRM37yrycMXNkOnzjIg31Qf2EjWRVEle31nXOx72I0aZQ67zRtWM8S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750041040; c=relaxed/simple;
	bh=lvuFPRsOwj2wVjKZ9MACsb3On+CRneeuQcaW1aHBkpo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=kt+eQqua79sUQ1JHT/6Frh4bAeeFRqWTwoeWJuLPTtbmFA9gM4gwD137r9W+718d8sOrhN0FlkLXgpcZuKmi8jB/FZRK1pCLAc9e3Tv4aHTFAHjatOfXwGSNgG6qs9whKb1QgvsRzdrcjBlPsLR055Ss9pVJ27ETPH68UzWzSoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X2eHhsE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X2eHhsE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1310C4CEE3;
	Mon, 16 Jun 2025 02:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750041037;
	bh=lvuFPRsOwj2wVjKZ9MACsb3On+CRneeuQcaW1aHBkpo=;
	h=Date:Subject:From:To:References:In-Reply-To:From;
	b=X2eHhsE6DJhOkaB4o5cGuJl1wp4gB8e4qcWqR7Y24dEdBBNiVJA9kPeKF9wio9vmQ
	 An3FiuttfToGYLtF7QGQjdPEQsGKq27pv08eL99kDphtop2nPjn35Q1OhZvDuOcApp
	 uuYv+Uuk0C8WjtjaldouB4MUf6J7T3frpt8RTXyutOQEMF14NpS98tpRm5BlrGWZlP
	 1q/WBkgZHzBQrwEV4VNC6/Gz43gPlzkQmLs7HHp88OIY9ErIdKyEmF5K5BHOX6CWzv
	 TC3Qlp44dmXVYbwjIzTYlH3E4rqtnjOAg/4xUPvfsAgH4Mv11/okIBQpN0liZFCdOd
	 GeNgT5sJHpcKQ==
Message-ID: <bb351a12-8b58-418d-bd14-a48364cd55d1@kernel.org>
Date: Mon, 16 Jun 2025 11:30:36 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Fix dm-crypt handling of emulated zone append
From: Damien Le Moal <dlemoal@kernel.org>
To: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>
References: <20250611011340.92226-1-dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250611011340.92226-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/25 10:13, Damien Le Moal wrote:
> Mike, Mikulas,
> 
> dm-crypt splitting a regular write used for emulating a zone append
> operation breaks the writeen sector return for zone append, causing all
> sorts of issues (e.g. corruptions) with file systems using the zone
> append operation (btrfs, xfs). The first patch addresses this issue.
> The second patch adds a check to detect if a DM target attempts to split
> such BIO.
> 
> Damien Le Moal (2):
>   dm: dm-crypt: Prevent splitting of emulated zone append operations
>   dm: Check for forbidden splitting of emulated zone append operations

Ping ?

This is a bug fix. Can we get these queued for 6.16-rc ?
Thank you.

> 
>  drivers/md/dm-crypt.c | 12 ++++++++++++
>  drivers/md/dm.c       |  6 ++++--
>  2 files changed, 16 insertions(+), 2 deletions(-)
> 


-- 
Damien Le Moal
Western Digital Research
