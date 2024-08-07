Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2E323D7;
	Wed,  7 Aug 2024 04:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723006148; cv=none; b=fALlo8Lw+lcoH/2qV413rGRRUfLhkMqRLNTl0rf0iH6v0TjYo5RfgX9AyXW7fRiQuforIP9h+K+lznAUu9uhi8hpqjNzCKb10Y1p8O5yVse285KqEpGl6bAtSSoZf7FSKUkGUs1MLqPylNQEe8hgR38Vj0U1OI7KqZDC62XVtI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723006148; c=relaxed/simple;
	bh=qa39epjqjdsOVNsHgEqDKXlLdppVmF7MiqUmOzTRPYU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s65zp0BYHhmENg/Ym7sODpQYyzlUnP2MZQ9Et7Pl1X+Cxnm9IRBBKHlk49vZIGQuX3/Z7uuYekMCF74eXQG3egwbUxU3ixufI+RqnDymdy/OVk13l0rCxBlW3EnSjVAB4qglfiNDPPo8tt/Df4PpIKbgnHYR8SEJr5DyBEik26g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.3] (ip5f5af7d2.dynamic.kabel-deutschland.de [95.90.247.210])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 4D7E161E5FE01;
	Wed,  7 Aug 2024 06:48:21 +0200 (CEST)
Message-ID: <5880e801-e896-4bf0-9a69-2cf5acb51ec3@molgen.mpg.de>
Date: Wed, 7 Aug 2024 06:48:20 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 20/20] MAINTAINERS: ipe: add ipe maintainer
 information
To: Paul Moore <paul@paul-moore.com>
Cc: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 eparis@redhat.com, linux-doc@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
 fsverity@lists.linux.dev, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, audit@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1722665314-21156-1-git-send-email-wufan@linux.microsoft.com>
 <1722665314-21156-21-git-send-email-wufan@linux.microsoft.com>
 <de7857fb-63d9-42fc-af1e-12ffcdfcdda8@molgen.mpg.de>
 <CAHC9VhRmcReVM_Le5bYor2deotnSe4OT08UYhL6xhiKCu0+3kA@mail.gmail.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <CAHC9VhRmcReVM_Le5bYor2deotnSe4OT08UYhL6xhiKCu0+3kA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Paul,


Am 06.08.24 um 22:54 schrieb Paul Moore:
> On Sat, Aug 3, 2024 at 4:15 AM Paul Menzel wrote:

>> Thank you very much for your patch. Two nits, should you sent another
>> interation: A more specific summary would avoid people having to look at
>> the message body or diff, and `git log --oneline` would be enough.
>>
>> MAINTAINERS: Add IPE entry with M: Fan Wu
>>
>> MAINTAINERS: Add IPE entry with Fan Wu as maintainer
>>
>> Am 03.08.24 um 08:08 schrieb Fan Wu:
>>> Update MAINTAINERS to include ipe maintainer information.
>>
>> I’d at least mention Integrity Policy Enforcement. As you not only
>> include the maintainer information but add a new entry, I’d leave the
>> body out, or mention that a new entry is added.
>>
>>> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> 
> Working under the current assumption that a new revision is not
> needed, I can fix this up during the merge.  Fan, other-Paul, are you
> both okay with the following:
> 
>    "MAINTAINERS: add IPE entry with Fan Wu as maintainer
> 
>     Add a MAINTAINERS entry for the Integrity Policy Enforcement (IPE) LSM."

Thank you. That is fine by me.


Kind regards,

Paul


>>> --
>>> v1-v16:
>>>     + Not present
>>>
>>> v17:
>>>     + Introduced
>>>
>>> v18:
>>>     + No changes
>>>
>>> v19:
>>>     + No changes
>>>
>>> v20:
>>>     + No changes
>>> ---
>>>    MAINTAINERS | 10 ++++++++++
>>>    1 file changed, 10 insertions(+)
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index 8766f3e5e87e..4cdf2d5a2058 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -11118,6 +11118,16 @@ T:   git git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git
>>>    F:  security/integrity/
>>>    F:  security/integrity/ima/
>>>
>>> +INTEGRITY POLICY ENFORCEMENT (IPE)
>>> +M:   Fan Wu <wufan@linux.microsoft.com>
>>> +L:   linux-security-module@vger.kernel.org
>>> +S:   Supported
>>> +T:   git https://github.com/microsoft/ipe.git
>>> +F:   Documentation/admin-guide/LSM/ipe.rst
>>> +F:   Documentation/security/ipe.rst
>>> +F:   scripts/ipe/
>>> +F:   security/ipe/
>>> +
>>>    INTEL 810/815 FRAMEBUFFER DRIVER
>>>    M:  Antonino Daplas <adaplas@gmail.com>
>>>    L:  linux-fbdev@vger.kernel.org
