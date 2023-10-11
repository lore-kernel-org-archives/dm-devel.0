Received: from w1.tutanota.de (w1.tutanota.de [81.3.6.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1AE312E4E
	for <dm-devel@lists.linux.dev>; Wed, 11 Oct 2023 19:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tutanota.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tutanota.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tutanota.com header.i=@tutanota.com header.b="Lg8GwdTU"
Received: from tutadb.w10.tutanota.de (unknown [192.168.1.10])
	by w1.tutanota.de (Postfix) with ESMTP id B77A0FBF831;
	Wed, 11 Oct 2023 19:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1697051265;
	s=s1; d=tutanota.com;
	h=From:From:To:To:Subject:Subject:Content-Description:Content-ID:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Cc:Cc:Date:Date:In-Reply-To:In-Reply-To:MIME-Version:MIME-Version:Message-ID:Message-ID:Reply-To:References:References:Sender;
	bh=5ImCitugzzk2uZXYWL6j92SSTClY4wvQPKV+hngjsPk=;
	b=Lg8GwdTUeLYhq6hnyJH+fHVfwNLwxLLZG1rSELGk9rEtTOOQof3f0nbxQ7asraf6
	PCDtmI+WKg0SlxMr59HwKhCsa+T2qFcfFhoY+HfXIuZo3AGxuJMXk0ZSyzprbssGy97
	r+cG4r4smgK+GJyoZw8fujPr6xQw9oWRHZz257xSyOvXC1M4ww4qVkOrBhi2q6ymcAf
	m2AATo2+yD6op+QWzqyz7pYusLIHpHK1BCWEu7h2goODUtwmZBcniLKtaTxapahcFeg
	XQy5SUdVj+jvKCNvjgZnbFfIQt9TppUNlreppps7gGjmu2IVGuJQieCCR5YcDTGXrFJ
	Iiwy1yqHkQ==
Date: Wed, 11 Oct 2023 21:07:45 +0200 (CEST)
From: charlesfdotz@tutanota.com
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Dm Devel <dm-devel@lists.linux.dev>
Message-ID: <NgUxgpw--3-9@tutanota.com>
In-Reply-To: <64e727f6-edcf-4b61-a2de-cb36d971fa2a@kernel.org>
References: <NgGvkdW--3-9@tutanota.com> <6276b986-fe9a-4ac4-9662-a0abf7dc68b4@suse.de> <dc7c0122-8077-4aa5-87e6-87404f48a4ce@kernel.org> <NgP-4zc--7-9@tutanota.com> <64e727f6-edcf-4b61-a2de-cb36d971fa2a@kernel.org>
Subject: Re: Feature Request: Device Manager Fake Trim / Zero Trim
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Oct 11, 2023, 00:33 by dlemoal@kernel.org:

> On 10/10/23 23:31, charlesfdotz@tutanota.com wrote:
>
>> As I've said in all of my emails this is regarding drive-managed SMR disks that do no support trim. Most of these aren't detectable by the host because if there were then people wouldn't buy them as they're not fit for purpose. Western digital was sued over this and lost.
>> https://arstechnica.com/gadgets/2020/05/western-digital-gets-sued-for-sneaking-smr-disks-into-its-nas-channel/
>> https://www.tomshardware.com/news/wd-red-smr-lawsuit-pays-out-pennies-in-settlement-damages
>>
>
> There is no need to name names or point fingers here. Kernel open source
> development is vendor agnostic and while my employer is indeed Western Digital,
> I do not talk as a representative of WD products but as a kernel developer. So
> calm down please if you want to keep the discussion open.
>
>> You can opine that this unlikely but we have reports (which I've already linked) that this works on some SMR drives. It's also pretty ironic someone from western digital of all places is saying drives wouldn't lie about how they function so they must be writing zeros when told to.
>>
>
> Again, the finger pointing here is totally inappropriate. My points are all in
> good faith and I am talking about the drives I know of.
>
> In any case, the key-word in your statement is "some drives". Given that you are
> talking about something that is not standardized and so cannot be safely
> generalized, there is nothing we can do. It is a hard NO from me to replace the
> lack of trim support with writing zeroes.
>
>>
>> Sincerely,
>> Chuck
>>
>
> --
> Damien Le Moal
> Western Digital Research
>
Presumably drives of the same model will work the say way so when I say "some drives" we're talking hundreds of thousands or millions if even a few models function this way. In my initial email I included a link where this seems to help on some models so I think it's very possible this could've made quite a lot of drives much more usable. I was requesting a separate device mapper layer with the thought that someone with one of these drives would test it and if zeroing sectors helped then they could add a "dm-trimemulation" layer on top of it. That's not replacing anything only adding an option for users.

I also don't understand why you would say "calm down please" if I "want to keep this discussion open" while in the same breath saying "it is a hard NO". If the answer is "NO" then "keep[ing] this discussion open" is pointless. In any case I brought up the deception by western digital to highlight that many buyers (myself included) were tricked into unintentionally buying drives that were not fit for purpose so trying to regain some functionality would be worthwhile. And someone from WD saying drives don't lie about how they function *is* ironic.

Going on about "good faith" after saying this probably wouldn't "help in any way" while seemingly ignoring the link to discussions where it very much appears to help is shitty.

Sincerely,
Chuck
