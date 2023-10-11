Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E272E6107
	for <dm-devel@lists.linux.dev>; Wed, 11 Oct 2023 00:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xu53MICE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F116CC433C7;
	Wed, 11 Oct 2023 00:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696984398;
	bh=qGwC35F6gAf6tjbCMJVQ9igDEQkboAxyuStDZ+VDOGU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Xu53MICE+oGfoeZXA0+17eybXOCzyzuE0/TFIUmrN/P+FTWOa9QNdXLU/SUbunTSs
	 qC3JqZzd4HeVSBjPnhTwuRP9sAQMT67ftOoeMJgowmoreg0VuHjvomdMqbJRz5GBye
	 c2Ma/UT2JepcAO93sARRcAmnLoawUKZR2iHiO6LH1cYZCPwkstM7rhYItWWV8yYu/b
	 rl4K42eflXvj6tTO38PfycTi7PMFtZSw9QondYNWCTcy9MMNh9LwJ22UCg4/n5k+uN
	 QG+UwugQcF3+SjhXNxB2Gn3AL1gDoAYbB2GrdTgFu1uyscZTIh1HROJdq/CrNVcdLf
	 r3aGt52QhuuWQ==
Message-ID: <64e727f6-edcf-4b61-a2de-cb36d971fa2a@kernel.org>
Date: Wed, 11 Oct 2023 09:33:16 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Feature Request: Device Manager Fake Trim / Zero Trim
To: charlesfdotz@tutanota.com
Cc: Hannes Reinecke <hare@suse.de>, Dm Devel <dm-devel@lists.linux.dev>
References: <NgGvkdW--3-9@tutanota.com>
 <6276b986-fe9a-4ac4-9662-a0abf7dc68b4@suse.de>
 <dc7c0122-8077-4aa5-87e6-87404f48a4ce@kernel.org> <NgP-4zc--7-9@tutanota.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <NgP-4zc--7-9@tutanota.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/10/23 23:31, charlesfdotz@tutanota.com wrote:
> As I've said in all of my emails this is regarding drive-managed SMR disks that do no support trim. Most of these aren't detectable by the host because if there were then people wouldn't buy them as they're not fit for purpose. Western digital was sued over this and lost.
> https://arstechnica.com/gadgets/2020/05/western-digital-gets-sued-for-sneaking-smr-disks-into-its-nas-channel/
> https://www.tomshardware.com/news/wd-red-smr-lawsuit-pays-out-pennies-in-settlement-damages

There is no need to name names or point fingers here. Kernel open source
development is vendor agnostic and while my employer is indeed Western Digital,
I do not talk as a representative of WD products but as a kernel developer. So
calm down please if you want to keep the discussion open.

> You can opine that this unlikely but we have reports (which I've already linked) that this works on some SMR drives. It's also pretty ironic someone from western digital of all places is saying drives wouldn't lie about how they function so they must be writing zeros when told to.

Again, the finger pointing here is totally inappropriate. My points are all in
good faith and I am talking about the drives I know of.

In any case, the key-word in your statement is "some drives". Given that you are
talking about something that is not standardized and so cannot be safely
generalized, there is nothing we can do. It is a hard NO from me to replace the
lack of trim support with writing zeroes.

> 
> Sincerely,
> Chuck
> 

-- 
Damien Le Moal
Western Digital Research

