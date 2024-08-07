Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8152312FB0A;
	Wed,  7 Aug 2024 18:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723053689; cv=none; b=RZ+PP23c7W5ofOwZ/pgJv8PGUXgOqw9nochpUUH+7R4PCY7UbWT+EQ2weShFhut3tFZKOBBgZuSuYjbLrLoNEZiCD5Ql88wmfkrGSxT6T6eTQFTRzys0v5AugxOsO9pkJ92ZgrruvLCsbHvT3v2vlvJXFmi0La5G68eGsV3rwZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723053689; c=relaxed/simple;
	bh=yqp0uOSR8Q8K4/5lXUBRuESQesWcvdBjwX8QJL9PB5s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sunedk90meUAdCccxGLirvGYQIWGRpODkrvJKfkbOPdvZt3WBn0sXJAv3QEeEbrD2HAsq8gCh0b7yZy6Eu+WT9px501d057gEIyOquI7ZNtfvY3YZxoVEZEDsLMkR4+hh7StRhQt6mdbDGOEoUiJ2oklKNtU7AiKxkHC0TRafgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=aunZM4VX; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="aunZM4VX"
Received: from [10.137.106.151] (unknown [131.107.174.23])
	by linux.microsoft.com (Postfix) with ESMTPSA id C5D4820B7165;
	Wed,  7 Aug 2024 11:01:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C5D4820B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1723053682;
	bh=JBD5S5GVsNdnH6wjmW/+nIlLS6fh9sw+q0ZHaDgSzqo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aunZM4VX0xcprS96+2RmSgZf60XSA27qvPVhz6D4bvlUDHm+AAedz7t9cP58XP5T7
	 3Kw+15MQrOnztwHPz4/UKECWCiy/kTOPbSWECYJk+1FBYPIsOxRjrLe6i/+8l5mh0W
	 ZoKEt4JNNiwgMXddXYZEieQG4zU6t4SqwHnsWmMw=
Message-ID: <080c93d1-9c02-478f-a0be-f4bd3869c1fd@linux.microsoft.com>
Date: Wed, 7 Aug 2024 11:01:21 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 20/20] MAINTAINERS: ipe: add ipe maintainer
 information
To: Paul Menzel <pmenzel@molgen.mpg.de>, Paul Moore <paul@paul-moore.com>
Cc: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
 tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, eparis@redhat.com,
 linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
 linux-security-module@vger.kernel.org, fsverity@lists.linux.dev,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 audit@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1722665314-21156-1-git-send-email-wufan@linux.microsoft.com>
 <1722665314-21156-21-git-send-email-wufan@linux.microsoft.com>
 <de7857fb-63d9-42fc-af1e-12ffcdfcdda8@molgen.mpg.de>
 <CAHC9VhRmcReVM_Le5bYor2deotnSe4OT08UYhL6xhiKCu0+3kA@mail.gmail.com>
 <5880e801-e896-4bf0-9a69-2cf5acb51ec3@molgen.mpg.de>
Content-Language: en-US
From: Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <5880e801-e896-4bf0-9a69-2cf5acb51ec3@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/6/2024 9:48 PM, Paul Menzel wrote:
> Dear Paul,
> 
> 
> Am 06.08.24 um 22:54 schrieb Paul Moore:
>> On Sat, Aug 3, 2024 at 4:15 AM Paul Menzel wrote:
> 
>>> Thank you very much for your patch. Two nits, should you sent another
>>> interation: A more specific summary would avoid people having to look at
>>> the message body or diff, and `git log --oneline` would be enough.
>>>
>>> MAINTAINERS: Add IPE entry with M: Fan Wu
>>>
>>> MAINTAINERS: Add IPE entry with Fan Wu as maintainer
>>>
>>> Am 03.08.24 um 08:08 schrieb Fan Wu:
>>>> Update MAINTAINERS to include ipe maintainer information.
>>>
>>> I’d at least mention Integrity Policy Enforcement. As you not only
>>> include the maintainer information but add a new entry, I’d leave the
>>> body out, or mention that a new entry is added.
>>>
>>>> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
>>
>> Working under the current assumption that a new revision is not
>> needed, I can fix this up during the merge.  Fan, other-Paul, are you
>> both okay with the following:
>>
>>    "MAINTAINERS: add IPE entry with Fan Wu as maintainer
>>
>>     Add a MAINTAINERS entry for the Integrity Policy Enforcement (IPE) 
>> LSM."
> 
> Thank you. That is fine by me.
> 
> 
> Kind regards,
> 
> Paul
> 
> 

Hi Paul and Paul,

Thank you both for your feedback and coordination on this. I'm good with 
the proposed changes and appreciate your efforts.

-Fan



