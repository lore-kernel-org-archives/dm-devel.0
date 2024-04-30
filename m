Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E169117B4E6
	for <dm-devel@lists.linux.dev>; Tue, 30 Apr 2024 14:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714487310; cv=none; b=s+sg71CEGdJdjpCB+eqRX2FwEkyzP+/98HNKbvvjtAAManKf27UcrUGIe4EYOJLkl2o8AWkupVM4aLfMfa3FqkqPOzR4VkDA+i7p3ex19iMQ5V9/iAmhabL+8BFpglZyn+rsbiqkjpeE6QiBiH/urIoMqHGoLOic2tkGJgRgS+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714487310; c=relaxed/simple;
	bh=SygWmh4EZ/7zQA+H95ZTjYhUpXgz3ERjUz5ElgN46EM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qfs32uQLVmqUsLUpz+nw0FXuUM8KCtg9kOJ3mie4JSqw7Js+1foN6uSJv5KqjF9sgDHIUPwDDMvWDBxUbI1x+W6PbZBJBDv5oEV39oFvKps1rcDi8U/zygwXr62mBZq1lYAJo//MozqaOi+tVvfL+luzn8L9cC/KwGFBLVTLV40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A22562F4;
	Tue, 30 Apr 2024 07:28:53 -0700 (PDT)
Received: from [10.1.35.31] (e133047.arm.com [10.1.35.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3AA4A3F793;
	Tue, 30 Apr 2024 07:28:26 -0700 (PDT)
Message-ID: <71a31fdb-fad6-4ce9-bda0-2f86633d23a3@arm.com>
Date: Tue, 30 Apr 2024 15:28:24 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] dm-delay: fix hung task introduced by kthread mode
To: Joel Colledge <joel.colledge@linbit.com>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@lists.linux.dev
References: <20240426072135.291206-1-joel.colledge@linbit.com>
 <20240426072135.291206-2-joel.colledge@linbit.com>
Content-Language: en-US
From: Christian Loehle <christian.loehle@arm.com>
In-Reply-To: <20240426072135.291206-2-joel.colledge@linbit.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 26/04/2024 08:21, Joel Colledge wrote:
> If the worker thread is not woken due to a bio, then it is not woken at
> all. This causes the hung task check to trigger. For instance, when a
> delay of 0 is configured, delay_bio() returns without waking the worker,
> so this situation occurs.
> 
> Prevent the hung task check from triggering by waking up the newly
> minted worker in delay_ctr().
> 
> Fixes: 70bbeb29fab0 ("dm delay: for short delays, use kthread instead of timers and wq")
> Signed-off-by: Joel Colledge <joel.colledge@linbit.com>
> ---
>  drivers/md/dm-delay.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
> index 5eabdb06c649..003512bb5fea 100644
> --- a/drivers/md/dm-delay.c
> +++ b/drivers/md/dm-delay.c
> @@ -274,6 +274,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  			dc->worker = NULL;
>  			goto bad;
>  		}
> +		wake_up_process(dc->worker);
>  	} else {
>  		timer_setup(&dc->delay_timer, handle_delayed_timer, 0);
>  		INIT_WORK(&dc->flush_expired_bios, flush_expired_bios);

Is this an issue for delay > 0 too somehow?
Indeed if we don't have a delay the process will never be woken up,
but in that case, why create the worker in the first place?

You're missing lkml as recipient btw.

Kind Regards,
Christian
