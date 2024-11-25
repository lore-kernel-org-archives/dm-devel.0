Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14BD2500AC
	for <dm-devel@lists.linux.dev>; Mon, 25 Nov 2024 06:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732514623; cv=none; b=WIrpGjhz2gUC2R7TuC2/RkqGn+vmhEXOHVMvwEJFdRbIhdavlFg2U57pE0jUihQUU+aqYY+mJ00QEoFi6l7CNzgn0WqBebgj56z1DcO2v0ui/QH4sOhcYoxSsVT47bSvCSOjppSkJ/thjZboDvRAR7xyNfGFBLCzh1LtphUpgG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732514623; c=relaxed/simple;
	bh=izMDj/i1I3CdTudZFfZFK+2ZNRz2sBJ0PVLUcpVXgqw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c89RMgzf6dIWrCa3/jKhv06XHraAGtsoRQJa1LQtFAMGG5EEE64tx8xA+hiI8Nch0RWLMleHvw0OO1w8p9ox8j0VsEO6bDp2MmpjZC+pn8OGWYLuT1QNQ5OHttsAw0nn9S9H1kH1u1sCHkZyQVydemfqUtqGn4ArerVOYEAc+/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dTQlqs5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dTQlqs5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA074C4CECE;
	Mon, 25 Nov 2024 06:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732514623;
	bh=izMDj/i1I3CdTudZFfZFK+2ZNRz2sBJ0PVLUcpVXgqw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dTQlqs5xQhiXlJBdwHKPcPPqHWrsmsK6n/7Z9P6LXwtKLUzRsMI67pBTVS5X7OfW6
	 PZkgXcJTFdgYyXvOkLibS5jgTkkFgT+B6tgf+cHZN3M4F/BgzdQp/sdlLlaP3DIcvI
	 n/fSDamh/Fvi8yN1xSP1HFNMSSAej6+pj9eb2A+GoBDir1LLtDgm8kFImKIGmi9KN0
	 CAp0YB/y2NNNXu4cFfNSvTP3cDDCyytnn1bNCHuEqURHLVOUhIGXzaSuFq7dNdWt3Z
	 YfAsAzz5/Eh1jb3fHOe923UvzTqSCsWu5wCtYxI4UaMl8czFeYhVy1ZEoYWu4UBVgQ
	 EgyfRkOTObpgg==
Message-ID: <f62a05bc-4127-4271-9ee8-e9c879e9c6aa@kernel.org>
Date: Mon, 25 Nov 2024 15:03:28 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-crypt: set max_io_len as chunk_sectors of zoned device
To: =?UTF-8?B?6Z+m6b6Z5bmzKEdyb290KQ==?= <weilongping@oppo.com>,
 Christoph Hellwig <hch@infradead.org>
Cc: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
 "snitzer@redhat.com" <snitzer@redhat.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 "ebiggers@google.com" <ebiggers@google.com>
References: <SEZPR02MB7967C480572B3B15D5F57F92D42E2@SEZPR02MB7967.apcprd02.prod.outlook.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <SEZPR02MB7967C480572B3B15D5F57F92D42E2@SEZPR02MB7967.apcprd02.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/25/24 2:58 PM, 韦龙平(Groot) wrote:
> On Sun, 24 Nov 2024 21:00:52 -0800, Christoph Hellwig wrote:
>> On Mon, Nov 25, 2024 at 11:22:51AM +0800, LongPing Wei wrote:
>>> When dm level submit a bio with bi_size > max_sectors_kb of lower device,
>>> blk_mq_submit_bio will split it into several ones with limited bi_size.
>>> It may be a potential unordered issue as it breaks the ZWL design in dm
>>> on 6.6.
>>
>> What is ZWL?  And why mention 6.6?  And why do you care about ordering?
> ZWL is Zone-Write-Locking and it was replaced by Zone-Write-Plugging on 6.12.

6.10.

>> There is no real ordering requirement in the block layer.
> According to the design constraints of zoned device, write requests in the same
> zone must be dispatched in order of address and there can be no holes in the middle


-- 
Damien Le Moal
Western Digital Research
