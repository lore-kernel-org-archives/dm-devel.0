Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E9464D
	for <dm-devel@lists.linux.dev>; Mon, 14 Apr 2025 00:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744590264; cv=none; b=osmrdTHG7S98caxpa4B0owseaJ8iu/We5A+dlGRHYjt6d614vkIyKsF0dWLFY/C/JHlCJGyLNfzZQ5HSuqgZav6GoIW/2MtpAfRgFK/7FlhG8VBGrp7ZFSGr+9TgeE7QhYAJvygN3Tp5/S/nd4n0YI8IkFTNPjM3jTj7mA6/9OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744590264; c=relaxed/simple;
	bh=PGD7drQY6mfaZUroT3/blMumacpLqff7lrWxL1w0m/8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zylk+ENuwb5Rkba5m+Jr+td7e77KNGTaFZ36HqMviUwNAI8nhcoaezSS0OplPuJJd46csk3wWla5+QoYQWlj749T6K6/5nX39PgMWrzShxC+lnfZz/j8K968xWfLWPBS3jzCCxgAI90IRK5Ww65R/x8uvZbp8b+2uVb7oDE8N9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P00ZUa4L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P00ZUa4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D6DC4CEDD;
	Mon, 14 Apr 2025 00:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744590263;
	bh=PGD7drQY6mfaZUroT3/blMumacpLqff7lrWxL1w0m/8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=P00ZUa4Lt6rswa1hqDCr2lvAK87XTBpBSmRYPi1XFah0lwwWbcLVcyd1XFm59gNbg
	 c6SCEZkBwDP2BmSsjcvCRs0RI1OO9ZC/HdwbIIuBz/rnVXLk1MB7cuqxCGNtpSPuhF
	 +U1o+BufWiLxgQSZGCDUh51piwKCaO1vUn9TqJryCtSAFmeDCBmurZDkPH09h0cq34
	 GmFVQF6gTMArED/gXZijP13bJdArUaQIlgKv5HvC7zeZAMp+KPHxt2mXs6F5JEpvhK
	 gW36iigoExDXwPq5JE+pmvgwxn5qQBlPsaERTgFLqyS7KkiAdZdmVD5jqYekoiXi+K
	 NebAOms5tZgkQ==
Message-ID: <99d3e0b0-faac-4262-8f8c-1979b5bc839d@kernel.org>
Date: Mon, 14 Apr 2025 09:23:35 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/6] dm: fix issues with swapping dm tables
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
 Mike Snitzer <snitzer@redhat.com>, dm-devel@lists.linux.dev,
 Christoph Hellwig <hch@lst.de>
References: <20250410194943.9326-1-bmarzins@redhat.com>
 <80cfd413-1bee-4ed1-a49f-163a28d0b426@kernel.org>
 <35ea47e0-21dc-a0b9-8531-b1c49fce08c3@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <35ea47e0-21dc-a0b9-8531-b1c49fce08c3@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/11/25 8:41 PM, Mikulas Patocka wrote:
> 
> 
> On Fri, 11 Apr 2025, Damien Le Moal wrote:
> 
>> On 4/11/25 04:49, Benjamin Marzinski wrote:
>>> There were multiple places in dm's __bind() function where it could fail
>>> and not completely roll back, leaving the device using the the old
>>> table, but with device limits and resources from the new table.
>>> Additionally, unused mempools for request-based devices were not always
>>> freed immediately.
>>>
>>> Also, there were a number of issues with switching zoned tables that
>>> emulate zone append (in other words, dm-crypt on top of zoned devices).
>>> dm_blk_report_zones() could be called while the device was initially
>>> setting up a zoned table and creating zoned resources or could possibly
>>> fail to end a srcu read section.  More importantly,
>>> blk_revalidate_disk_zones() would never get called when updating a zoned
>>> table. This could cause the dm device to see the wrong zone write
>>> offsets, not have a large enough zwplugs reserved in its mempool, or
>>> read invalid memory when checking the conventional zones bitmap.
>>>
>>> Finally, any DM device created on top of a device emulating zone appeads
>>> will automatically have zone write plug resources created for it, since
>>> max_hw_zone_append_sectors will always be 0 for a device stacked on top
>>> of a device max_hw_zone_append_sectors = 0
>>>
>>> This patchset fixes these issues. It deals with the problems around
>>> blk_revalidate_disk_zones() by only calling it for devices that have no
>>> zone write plug resources. This will always correctly update the zoned
>>> settings. If a device has zone write plug resources, calling
>>> blk_revalidate_disk_zones() will not correctly update them in many
>>> cases, so DM simply doesn't call it for devices with zone write plug
>>> resources. Instead of allowing people to load tables that can break the
>>> device, like currently happens, DM disallosw any table reloads that
>>> change the zoned setting for devices that already have zone write plug
>>> resources. Finally, it deals with the max_hw_zone_append_sectors issue
>>> by making sure that it is non-zero for zoned DM devices that do not need
>>> zone write append emulation.
>>>
>>> Changes in V4:
>>> - Fixed typos in 2 commit messages (patches 4 and 5)
>>> - rephrased comment in dm_revalidate_zones() (patch 5)
>>
>> I gave this a quick spin and did not detect any issues.
>> So feel free to add:
>>
>> Tested-by: Damien Le Moal <dlemoal@kernel.org>
>>
>> -- 
>> Damien Le Moal
>> Western Digital Research
> 
> Thanks.
> 
> I staged the patches for the next merge window.

Hmmm... These are all fixes, so shouldn't they go into rc3 ?


-- 
Damien Le Moal
Western Digital Research
