Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 533287711D
	for <dm-devel@lists.linux.dev>; Tue, 30 Apr 2024 15:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714490833; cv=none; b=SR1MY/dPcOn/Fr4letiFYHXkZtVtgJBGmZst0IZpnreoMPEvIiz00rQz2fihVtrPopHyIheNEtaNvUqQ2jgYXV1PDqwcRm4YJIYdQa6MPB3tYSI44KrVhafrKWZ41NUgthypnj7gmoPIz8fDDA/cdrgMs73uNqUivJNBqB8NgUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714490833; c=relaxed/simple;
	bh=oSf2x27jJ1M2be9JySgfZ4rR1elPXE8NE7XAtU6bOEI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P8H+majnCSYb6PZlsvaaaL8JLUXK1wC/2QLpENWcLNPZ0qkT7noasEtSMHizk+YIrEyhDiAIgLh/gfkjtSTz2Gz+S7msJOjAb6Cg9wW078QY/qv5RXWFqBk24GFz10gCv70E4tDJfjxRaCAXFRnIeu7ExUw4AMQitcoBszXgbXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 358202F4;
	Tue, 30 Apr 2024 08:27:37 -0700 (PDT)
Received: from [10.1.35.31] (e133047.arm.com [10.1.35.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8AE883F793;
	Tue, 30 Apr 2024 08:27:09 -0700 (PDT)
Message-ID: <bc673c7e-f705-46ce-a3c0-0d34f612fe30@arm.com>
Date: Tue, 30 Apr 2024 16:26:53 +0100
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
Content-Language: en-US
From: Christian Loehle <christian.loehle@arm.com>
In-Reply-To: <CAGNP_+Uocb_8YtY9P3EuMQ8sQwWaQtqEMszqbGZrVyrKw-udRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 30/04/2024 15:44, Joel Colledge wrote:
> On Tue, 30 Apr 2024 at 16:28, Christian Loehle <christian.loehle@arm.com> wrote:
>> Is this an issue for delay > 0 too somehow?
> 
> I believe it is. If there is simply no IO to the delay device, then
> nothing will wake the new thread and the same issue will occur.

Yes, but might be better to just set_current_state(TASK_INTERRUPTIBLE);
instead of the wakeup.

> 
> I haven't yet reproduced this case, because the system I am testing on
> submits reads on any new block device and I don't know offhand how to
> disable them. I think the reads are from scans for multipathd,
> bcachefs or similar.
> 
>> Indeed if we don't have a delay the process will never be woken up,
>> but in that case, why create the worker in the first place?
> 
> I agree. If this were only an issue with delay == 0, it would make
> more sense not to create the worker at all.
> 
> As mentioned above, I believe the issue can occur with delay > 0. So
> not creating the worker in the delay == 0 case is an additional
> optimization and out of the scope of this change.

Ah right because of the delay_is_fast() definition that is slightly more
work.

Regards,
Christian.

