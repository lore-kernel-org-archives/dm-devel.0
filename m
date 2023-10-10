Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE63763CF
	for <dm-devel@lists.linux.dev>; Tue, 10 Oct 2023 06:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Te0lOT5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC592C433C7;
	Tue, 10 Oct 2023 06:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696920484;
	bh=1cvjKIJ+qGlXcRtTcnriA5KYy8PYtVGOVFUMPI/vUGk=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=Te0lOT5xZY5q+d0urFXN1WvuMwaLgRwOxZVD5VbFn/8MbRkMw/V/sPJZmuKbk0VK1
	 PRGmjB+EemLJJoDm6i/F4cET+tgcMFSxvHkm++4U8aMpPXbsyPUKXNcc/b6GFGUBaI
	 IN1ZSXyADpYGUf6vE33XP4rDezFwsnVPz7YGp7BXChKiUrtYadEZSsUlNLDPGvsmJ/
	 o6eaGZ31XOqJkPLc1B+zxo25emkYTQpOEWeXL8UFbjEK8/F5agXUvyO/5m7mjPyyCX
	 /pr1DQmVSbW4wAhjBj7QR+r1Z4AozSnO65Hlj1X7FcGN97c+TePyedl1uo8P+wh+sB
	 aFdM9QlLtaZyw==
Message-ID: <dc7c0122-8077-4aa5-87e6-87404f48a4ce@kernel.org>
Date: Tue, 10 Oct 2023 15:48:02 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Feature Request: Device Manager Fake Trim / Zero Trim
Content-Language: en-US
To: Hannes Reinecke <hare@suse.de>, charlesfdotz@tutanota.com,
 Dm Devel <dm-devel@lists.linux.dev>
References: <NgGvkdW--3-9@tutanota.com>
 <6276b986-fe9a-4ac4-9662-a0abf7dc68b4@suse.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <6276b986-fe9a-4ac4-9662-a0abf7dc68b4@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/9/23 15:15, Hannes Reinecke wrote:
> On 10/9/23 02:56, charlesfdotz@tutanota.com wrote:
>> Hello,
>> 
>> I would like to request a new device manager layer be added that accepts
>> trim requests for sectors and instead writes zeros to those sectors.
>> 
>> This would be useful to deal with SMR (shingled magnetic recording) drives
>> that do not support trim. Currently after an SMR drive has had enough data
>> written to it the performance drops dramatically because the disk must 
>> shuffle around data as if it were full and without trim support there is no
>> way to inform the disk which sectors are no longer used. Currently there's
>> no way to "fix" or reset this without doing an ATA secure erase despite 
>> many of these disk being sold without informing customers that they were
>> SMR drives (western digital was sued for selling SMR drives as NAS
>> drives).
>> 
> Gosh, no, please don't. SMR drives have a write pointer, and if the zone
> needs to be reset you just reset the write pointer. Writing zeroes will
> result in the opposite; the zone continues to be full, and no writes can
> happen there.

Yes. And zone reset *is* a trim also since after a zone reset, the sectors in
the zone cannot be read.

> Which drive is this?

From reading the description of the "issue", it seems that this is related to
drive managed SMR disks, which may or may not be detectable from the host (if
the drive is honest and reports it, the scsi_disk zoned_cap attribute will say
"drive-managed"). So no zone reset for a drive managed SMR disk since they are
"normal" drives from the interface perspective.

A drive managed SMR disk may or may not benefit from TRIM. That completely
depends on the device internal implementation to handle the SMR constraint. If
the drive does not have trim/discard support, it is likely because that serves
no purpose or would be useless performance-wise...

-- 
Damien Le Moal
Western Digital Research

