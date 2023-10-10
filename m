Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D8253BE
	for <dm-devel@lists.linux.dev>; Tue, 10 Oct 2023 06:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="olP5mxD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98791C433C7;
	Tue, 10 Oct 2023 06:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696920784;
	bh=28Gt9rHpjiybbQqzfC/TssjmpK2KLgJdrJpyWDkk0XU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=olP5mxD26AqSm32DEAoyAzHEIAkp3qDWvr6cvLz3o1RRLSwobIoghFsHD7xekXguZ
	 x8IQRiofc9oAViDUkNXRgL9Xm23wbvkQIxXvCpjwXgeZL9MVn3f1hUPZ1H+MX667TF
	 8RFa/chQyZXjbGVeyK27yPrFBcWUSzGmxs7dCFuw+Q39kbJKuOd2Bqxp+LK7y4MyPV
	 c7LukS48IALXDTHZQpRDGm031W8O1Iu/98R3EDymRedwYizCVOCZxEjVDT2AYammUE
	 dlGo4GfqqUWNsafR/fgkP7VscIZ+faeOAA0skZAsdpFs0781PQ1E0G+9PXGlNZv/nc
	 2+dBFbImxgbEw==
Message-ID: <61581185-65e8-41d2-b9e1-b22a00f52ea9@kernel.org>
Date: Tue, 10 Oct 2023 15:53:02 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Feature Request: Device Manager Fake Trim / Zero Trim
Content-Language: en-US
To: charlesfdotz@tutanota.com, Mikulas Patocka <mpatocka@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Dm Devel <dm-devel@lists.linux.dev>
References: <NgGvkdW--3-9@tutanota.com>
 <6276b986-fe9a-4ac4-9662-a0abf7dc68b4@suse.de>
 <12c1c045-7b52-8c7c-161c-599ceaadf48@redhat.com> <NgK6QGI--3-9@tutanota.com>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <NgK6QGI--3-9@tutanota.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/10/23 01:25, charlesfdotz@tutanota.com wrote:
> 
> Oct 9, 2023, 09:43 by mpatocka@redhat.com:
> 
>> 
>> 
>> On Mon, 9 Oct 2023, Hannes Reinecke wrote:
>> 
>>> On 10/9/23 02:56, charlesfdotz@tutanota.com wrote:
>>>> Hello,
>>>> 
>>>> I would like to request a new device manager layer be added that
>>>> accepts trim requests for sectors and instead writes zeros to those
>>>> sectors.
>>>> 
>>>> This would be useful to deal with SMR (shingled magnetic recording)
>>>> drives that do not support trim. Currently after an SMR drive has had
>>>> enough data written to it the performance drops dramatically because
>>>> the disk must shuffle around data as if it were full and without trim
>>>> support there is no way to inform the disk which sectors are no longer
>>>> used. Currently there's no way to "fix" or reset this without doing an
>>>> ATA secure erase despite many of these disk being sold without
>>>> informing customers that they were SMR drives (western digital was
>>>> sued for selling SMR drives as NAS drives).
>>>> 
>>> Gosh, no, please don't. SMR drives have a write pointer, and if the zone
>>> needs to be reset you just reset the write pointer. Writing zeroes will
>>> result in the opposite; the zone continues to be full, and no writes can
>>> happen there.
>>> 
>>> Which drive is this?
>>> 
>>> Cheers,
>>> 
>>> Hannes
>>> 
> The drive in the link is a ST8000DM004-2CX188 according to the poster. To be
> clear I'm talking about device managed SMR drives that don't support trim and
> do not report being SMR *not* host aware drives. The DM-SMR drives work fine
> until you've written their total capacity once then the write performance
> craters permanently because the drive thinks all the data on it is important
> and has to reshuffle it constantly during writes. We are talking sub-1MiB/s
> and hangs waiting on the controller to move things around that can be several
> minutes. WD was recently sued for selling some of these as "WD Red NAS"
> drives.
> 
> I'm not sure why writing zeros appears to work so this just speculation on my
> part but I was thinking the drive might be smart enough to mark sectors full
> of zeros as unused and then return any request for an unused sector as zeros.

If the drive does not even support trim/discard, thinking it has such
intelligence is a long shot... I would not bet on it :)

> 
>> 
>> BTW. what about converting trims to zone reset? If the trim spans a whole 
>> zone, the kernel could convert it to REQ_OP_ZONE_RESET on host-aware zoned 
>> devices.
>> 
>> Mikulas
>> 
> This particular request was to try and make (some) device managed SMR drives
> that don't report to the host that they are SMR more usable. I was thinking
> if they are a model where zero sectors appear to "trim" one could just put
> this "fake-trim" device mapper layer over it and then it would act like a
> device managed SMR drive that supports trim.

Check /sys/block/sdX/device/scsi_disk/xxxx/zoned_cap. Does it say "drive-managed" ?

I do not think that writing zeroes will help in any way. Drives do not generally
(as far as I know) look at the data they are reading/writing to try to be smart.
Writing zeroes is the same as writing random bytes. For a good reason: sometimes
initializing sectors to contain zeroes *is* important !

-- 
Damien Le Moal
Western Digital Research

