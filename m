Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A05D4EED6
	for <dm-devel@lists.linux.dev>; Wed,  1 May 2024 08:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714551995; cv=none; b=O1vWXBORmPYq0PTxwBdyuUl5aIG2HO0z/bKlrPJPJePvVpHnehs2A7A6OtOxq3bLUlk03HorjSQ6lcrsUov1cSmWa7z6Qx5vZVLdX1SbCtX3ZM8yRYfnrYLz2yYMuRIGBqha1AXQ6JGkXIuQHtJMh1EBujlNAZJaNqbPtRFd1sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714551995; c=relaxed/simple;
	bh=jIxrOQTm41IHyfaxpihklaSd3JU75WV7W+FWaXoka6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ITfm2ACmi+XyUFRRiUfITCKAx6CIiMGlSp+AKeiZGDijrumBGhBBW105jlXayVYnJmABE7Mj+LfsfhfcVN2KLSRc5EMv30bPbkmOkuEVqqICz6z0xHTSfqVNQmd/XWPnhRoM7d/vL9lNLsjr597ELxjAqdd3Wzp1P8qqGau2kmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23457DA7;
	Wed,  1 May 2024 01:27:00 -0700 (PDT)
Received: from [10.1.34.50] (unknown [10.1.34.50])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4A4333F793;
	Wed,  1 May 2024 01:26:33 -0700 (PDT)
Message-ID: <d18e4aef-893b-4940-bc00-352036c34504@arm.com>
Date: Wed, 1 May 2024 09:26:31 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] dm-delay: fix hung task introduced by kthread mode
To: Joel Colledge <joel.colledge@linbit.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
References: <20240426072135.291206-1-joel.colledge@linbit.com>
 <20240426072135.291206-2-joel.colledge@linbit.com>
 <71a31fdb-fad6-4ce9-bda0-2f86633d23a3@arm.com>
 <CAGNP_+Uocb_8YtY9P3EuMQ8sQwWaQtqEMszqbGZrVyrKw-udRg@mail.gmail.com>
 <bc673c7e-f705-46ce-a3c0-0d34f612fe30@arm.com>
 <CAGNP_+WStY+C9=eT=gzC-dYhMtPTj4kzKDSuYiVHi0w41Qa_8w@mail.gmail.com>
Content-Language: en-US
From: Christian Loehle <christian.loehle@arm.com>
In-Reply-To: <CAGNP_+WStY+C9=eT=gzC-dYhMtPTj4kzKDSuYiVHi0w41Qa_8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 30/04/2024 17:12, Joel Colledge wrote:
> On Tue, 30 Apr 2024 at 17:27, Christian Loehle <christian.loehle@arm.com> wrote:
>> On 30/04/2024 15:44, Joel Colledge wrote:
>>> On Tue, 30 Apr 2024 at 16:28, Christian Loehle <christian.loehle@arm.com> wrote:
>>>> Is this an issue for delay > 0 too somehow?
>>>
>>> I believe it is. If there is simply no IO to the delay device, then
>>> nothing will wake the new thread and the same issue will occur.
>>
>> Yes, but might be better to just set_current_state(TASK_INTERRUPTIBLE);
>> instead of the wakeup.
> 
> I'm afraid I don't follow what you mean.
> set_current_state(TASK_INTERRUPTIBLE) would need to be called from the
> worker, but the worker isn't running yet, so it can't do that.

Sorry about that, wasn't thinking :/

> 
> When preparing this patch, I checked how common kthread_create()
> followed by wake_up_process() is. It is fairly common according to
> this very approximate metric:
> $ grep -r -I -A10 kthread_create | grep -c wake_up_process
> 49
> 
> I just looked through those matches in more detail and noticed that
> there is a kthread_run() macro which does exactly what we need. I will
> change my suggestion to use that instead.
> 
> I will wait for more comments before sending a new version of the patch.
> 
> Best regards,
> Joel

