Received: from w1.tutanota.de (w1.tutanota.de [81.3.6.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D126C24C95
	for <dm-devel@lists.linux.dev>; Tue, 10 Oct 2023 14:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tutanota.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tutanota.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tutanota.com header.i=@tutanota.com header.b="2jml1PNJ"
Received: from tutadb.w10.tutanota.de (unknown [192.168.1.10])
	by w1.tutanota.de (Postfix) with ESMTP id B2331FBF9F7;
	Tue, 10 Oct 2023 14:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1696948316;
	s=s1; d=tutanota.com;
	h=From:From:To:To:Subject:Subject:Content-Description:Content-ID:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Cc:Cc:Date:Date:In-Reply-To:In-Reply-To:MIME-Version:MIME-Version:Message-ID:Message-ID:Reply-To:References:References:Sender;
	bh=51KIV2yKzOWY/fX0C419KS/ogZhS1kFJXhj7Wx1yV2E=;
	b=2jml1PNJHX6eU5elQwRHQ7DwucLlvLg+lbKTRPpUZqF/Wz0Aa2iX9coY9LOh1zG4
	Bi1h3Ji3GuaRdGyfd7vE87+1+r60e2gJCtkVZG2wTLlBEzXpmfynNGlLv/GkUs0Sa/Z
	SyYklyvV0nwel2Y4ZChi+NSoxApChjskHQnolmHGxwn3CAk6ggu2bqAYsdn8ifI+Uam
	cHBE42aW6l+ecFTBXyhM48Wnre21Ypep0XzOUBuxkil8nGz9xgnUof3V6obwW4zdcDQ
	hp6iSZtxpFMLsQ8ELjBU1pbwn+u6THrffdHFbOsJ3cXW8NrpYCovECmWNTmYOFoAobF
	ZDOPPMzV+Q==
Date: Tue, 10 Oct 2023 16:31:56 +0200 (CEST)
From: charlesfdotz@tutanota.com
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Dm Devel <dm-devel@lists.linux.dev>
Message-ID: <NgP-4zc--7-9@tutanota.com>
In-Reply-To: <dc7c0122-8077-4aa5-87e6-87404f48a4ce@kernel.org>
References: <NgGvkdW--3-9@tutanota.com> <6276b986-fe9a-4ac4-9662-a0abf7dc68b4@suse.de> <dc7c0122-8077-4aa5-87e6-87404f48a4ce@kernel.org>
Subject: Re: Feature Request: Device Manager Fake Trim / Zero Trim
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


Oct 10, 2023, 06:48 by dlemoal@kernel.org:

> On 10/9/23 15:15, Hannes Reinecke wrote:
>
>> On 10/9/23 02:56, charlesfdotz@tutanota.com wrote:
>>
>>> Hello,
>>>
>>> I would like to request a new device manager layer be added that accepts
>>> trim requests for sectors and instead writes zeros to those sectors.
>>>
>>> This would be useful to deal with SMR (shingled magnetic recording) drives
>>> that do not support trim. Currently after an SMR drive has had enough data
>>> written to it the performance drops dramatically because the disk must 
>>> shuffle around data as if it were full and without trim support there is no
>>> way to inform the disk which sectors are no longer used. Currently there's
>>> no way to "fix" or reset this without doing an ATA secure erase despite 
>>> many of these disk being sold without informing customers that they were
>>> SMR drives (western digital was sued for selling SMR drives as NAS
>>> drives).
>>>
>> Gosh, no, please don't. SMR drives have a write pointer, and if the zone
>> needs to be reset you just reset the write pointer. Writing zeroes will
>> result in the opposite; the zone continues to be full, and no writes can
>> happen there.
>>
>
> Yes. And zone reset *is* a trim also since after a zone reset, the sectors in
> the zone cannot be read.
>
>> Which drive is this?
>>
>
> From reading the description of the "issue", it seems that this is related to
> drive managed SMR disks, which may or may not be detectable from the host (if
> the drive is honest and reports it, the scsi_disk zoned_cap attribute will say
> "drive-managed"). So no zone reset for a drive managed SMR disk since they are
> "normal" drives from the interface perspective.
>
> A drive managed SMR disk may or may not benefit from TRIM. That completely
> depends on the device internal implementation to handle the SMR constraint. If
> the drive does not have trim/discard support, it is likely because that serves
> no purpose or would be useless performance-wise...
>
> -- 
> Damien Le Moal
> Western Digital Research
>
As I've said in all of my emails this is regarding drive-managed SMR disks that do no support trim. Most of these aren't detectable by the host because if there were then people wouldn't buy them as they're not fit for purpose. Western digital was sued over this and lost.
https://arstechnica.com/gadgets/2020/05/western-digital-gets-sued-for-sneaking-smr-disks-into-its-nas-channel/
https://www.tomshardware.com/news/wd-red-smr-lawsuit-pays-out-pennies-in-settlement-damages

Oct 10, 2023, 06:53 by dlemoal@kernel.org:

> On 10/10/23 01:25, > charlesfdotz@tutanota.com>  wrote:
>
>>
>> Oct 9, 2023, 09:43 by >> mpatocka@redhat.com>> :
>>
>>>
>>>
>>> On Mon, 9 Oct 2023, Hannes Reinecke wrote:
>>>
>>>> On 10/9/23 02:56, >>>> charlesfdotz@tutanota.com>>>>  wrote:
>>>>
>>>>> Hello,
>>>>>
>>>>> I would like to request a new device manager layer be added that
>>>>> accepts trim requests for sectors and instead writes zeros to those
>>>>> sectors.
>>>>>
>>>>> This would be useful to deal with SMR (shingled magnetic recording)
>>>>> drives that do not support trim. Currently after an SMR drive has had
>>>>> enough data written to it the performance drops dramatically because
>>>>> the disk must shuffle around data as if it were full and without trim
>>>>> support there is no way to inform the disk which sectors are no longer
>>>>> used. Currently there's no way to "fix" or reset this without doing an
>>>>> ATA secure erase despite many of these disk being sold without
>>>>> informing customers that they were SMR drives (western digital was
>>>>> sued for selling SMR drives as NAS drives).
>>>>>
>>>> Gosh, no, please don't. SMR drives have a write pointer, and if the zone
>>>> needs to be reset you just reset the write pointer. Writing zeroes will
>>>> result in the opposite; the zone continues to be full, and no writes can
>>>> happen there.
>>>>
>>>> Which drive is this?
>>>>
>>>> Cheers,
>>>>
>>>> Hannes
>>>>
>> The drive in the link is a ST8000DM004-2CX188 according to the poster. To be
>> clear I'm talking about device managed SMR drives that don't support trim and
>> do not report being SMR *not* host aware drives. The DM-SMR drives work fine
>> until you've written their total capacity once then the write performance
>> craters permanently because the drive thinks all the data on it is important
>> and has to reshuffle it constantly during writes. We are talking sub-1MiB/s
>> and hangs waiting on the controller to move things around that can be several
>> minutes. WD was recently sued for selling some of these as "WD Red NAS"
>> drives.
>>
>> I'm not sure why writing zeros appears to work so this just speculation on my
>> part but I was thinking the drive might be smart enough to mark sectors full
>> of zeros as unused and then return any request for an unused sector as zeros.
>>
>
> If the drive does not even support trim/discard, thinking it has such
> intelligence is a long shot... I would not bet on it :)
>
>>>
>>> BTW. what about converting trims to zone reset? If the trim spans a whole
>>> zone, the kernel could convert it to REQ_OP_ZONE_RESET on host-aware zoned
>>> devices.
>>>
>>> Mikulas
>>>
>> This particular request was to try and make (some) device managed SMR drives
>> that don't report to the host that they are SMR more usable. I was thinking
>> if they are a model where zero sectors appear to "trim" one could just put
>> this "fake-trim" device mapper layer over it and then it would act like a
>> device managed SMR drive that supports trim.
>>
>
> Check /sys/block/sdX/device/scsi_disk/xxxx/zoned_cap. Does it say "drive-managed" ?
>
> I do not think that writing zeroes will help in any way. Drives do not generally
> (as far as I know) look at the data they are reading/writing to try to be smart.
> Writing zeroes is the same as writing random bytes. For a good reason: sometimes
> initializing sectors to contain zeroes *is* important !
>
> --
> Damien Le Moal
> Western Digital Research
>
You can opine that this unlikely but we have reports (which I've already linked) that this works on some SMR drives. It's also pretty ironic someone from western digital of all places is saying drives wouldn't lie about how they function so they must be writing zeros when told to.

Sincerely,
Chuck
