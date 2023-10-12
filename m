Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B11DCA77
	for <dm-devel@lists.linux.dev>; Thu, 12 Oct 2023 06:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bY+6XCGt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="74Q6FEHr"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1E36221871;
	Thu, 12 Oct 2023 06:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1697092420; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fCGNmRah1vs895FUbJRIJRGDXJ3+NSl1uT6tRctdCow=;
	b=bY+6XCGt37Gi4MhQY89l/46RV6tOwF95Y9N0ySqv0E0aYwxNwnyRALeW56rHl5jwYfTK25
	3fF0AIb7qj2s1mqyXaxy56pG/1KQBXG9xfKFLsXkjLbJyybFhv3sCMYaVYtMWcJuXgzMjN
	GZJVC5m04paZ3rwlfUqfmgw7WDO0nxE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1697092420;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fCGNmRah1vs895FUbJRIJRGDXJ3+NSl1uT6tRctdCow=;
	b=74Q6FEHrLru+7ZAtO7xgWFdT/9vTRp1W/rHl0ilLmv52pyKukwd8a2lKIE2BHB4v0uOebX
	R469dA/TCQMohNAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F2432139ED;
	Thu, 12 Oct 2023 06:33:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id kujmOUOTJ2VsEQAAMHmgww
	(envelope-from <hare@suse.de>); Thu, 12 Oct 2023 06:33:39 +0000
Message-ID: <5b937028-468d-4264-beb9-4d7415961150@suse.de>
Date: Thu, 12 Oct 2023 08:33:39 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Feature Request: Device Manager Fake Trim / Zero Trim
Content-Language: en-US
To: charlesfdotz@tutanota.com, Damien Le Moal <dlemoal@kernel.org>
Cc: Dm Devel <dm-devel@lists.linux.dev>
References: <NgGvkdW--3-9@tutanota.com>
 <6276b986-fe9a-4ac4-9662-a0abf7dc68b4@suse.de>
 <dc7c0122-8077-4aa5-87e6-87404f48a4ce@kernel.org> <NgP-4zc--7-9@tutanota.com>
 <64e727f6-edcf-4b61-a2de-cb36d971fa2a@kernel.org> <NgUxgpw--3-9@tutanota.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <NgUxgpw--3-9@tutanota.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -7.09
X-Spamd-Result: default: False [-7.09 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[3];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-3.00)[-1.000];
	 BAYES_HAM(-3.00)[100.00%];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-1.00)[-1.000];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_COUNT_TWO(0.00)[2];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Flag: NO

On 10/11/23 21:07, charlesfdotz@tutanota.com wrote:
> Oct 11, 2023, 00:33 by dlemoal@kernel.org:
> 
>> On 10/10/23 23:31, charlesfdotz@tutanota.com wrote:
>>
>>> As I've said in all of my emails this is regarding drive-managed SMR disks that do no support trim. Most of these aren't detectable by the host because if there were then people wouldn't buy them as they're not fit for purpose. Western digital was sued over this and lost.
>>> https://arstechnica.com/gadgets/2020/05/western-digital-gets-sued-for-sneaking-smr-disks-into-its-nas-channel/
>>> https://www.tomshardware.com/news/wd-red-smr-lawsuit-pays-out-pennies-in-settlement-damages
>>>
>>
>> There is no need to name names or point fingers here. Kernel open source
>> development is vendor agnostic and while my employer is indeed Western Digital,
>> I do not talk as a representative of WD products but as a kernel developer. So
>> calm down please if you want to keep the discussion open.
>>
>>> You can opine that this unlikely but we have reports (which I've already linked) that this works on some SMR drives. It's also pretty ironic someone from western digital of all places is saying drives wouldn't lie about how they function so they must be writing zeros when told to.
>>>
>>
>> Again, the finger pointing here is totally inappropriate. My points are all in
>> good faith and I am talking about the drives I know of.
>>
>> In any case, the key-word in your statement is "some drives". Given that you are
>> talking about something that is not standardized and so cannot be safely
>> generalized, there is nothing we can do. It is a hard NO from me to replace the
>> lack of trim support with writing zeroes.
>>
>>>
>>> Sincerely,
>>> Chuck
>>>
>>
>> --
>> Damien Le Moal
>> Western Digital Research
>>
> Presumably drives of the same model will work the say way so when I say "some drives" we're talking hundreds of
> thousands or millions if even a few models function this way. In my initial email I included a link where this
> seems to help on some models so I think it's very possible this could've made quite a lot of drives much more
> usable. I was requesting a separate device mapper layer with the thought that someone with one of these drives
> would test it and if zeroing sectors helped then they could add a "dm-trimemulation" layer on top of it. That's
> not replacing anything only adding an option for users.
> 
Oh, sure, they could. Problem here is that we don't have any specifics 
on why this 'dm-trimemulation' layer helps in this situation.
What we do know, though, is that it works exactly _against_ how SMR 
drives work internally. On SMR drives writing zeroes is about the 
worst-case scenario, as it'll fill the disk with meaningless data but 
_not_ reset zones such that you can write to it. IE essentially making 
the drive unusable.

Understandably that we're a little concerned here.

Even more so as this is a firmware emulation issue on the drive, so
it _could_ be fixed by the drive manufacturer in updating the firmware
to actually support TRIM.

But sure, if you found that there are drives for this such an emulation 
might help, by all means, send patches. I'd be happily reviewing them.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

