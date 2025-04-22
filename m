Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EBF20C49E
	for <dm-devel@lists.linux.dev>; Tue, 22 Apr 2025 10:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745319009; cv=none; b=sMGxRrZ4oSIL2HfJAS7PvPQRheLGEN/vGY7LFAxZHRpNRVxrTCi2oYYJSsDryNBas0KLgBBeJrxFN6lA10pGYCx3z/72q+15BdoOHCquPW6qqHrQhCSN24n9U24WnHhEc7sN26EFPAFNvUl68vuH634LJYrQEmdVA/FL6UHy8q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745319009; c=relaxed/simple;
	bh=kbUr7HaNhHVAhD78SIhO2Vq04+Rjspx8viH4YHaDrkA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=QSRRmMKdNSpQNtB0qWsDaRrtwev9trc9EBhbDEZKJFpCWi8SOC76vrKvpdk5EuE87aYfvmno6/Yg8T2ftxuEth8NepgR8Hb5nWWLlCxHAg+k4v1GOR7S+MkB7VjQ6ijfkZbrQjFCxm8N9L8pRDwt+w7VQtQFFuGUBItOyCgI1LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B+x/2492; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B+x/2492"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745319005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8L3mJRhluK/b8rkqU7uHMUHr5tvG7+MzE9bf6SZMVYA=;
	b=B+x/24924CTCIo8BTgqvNjNSoGVI5h+yq+3KAM/S8SlxlZpAmb1AA9EA2bOgyRlLX4HTMi
	0B5isosVZWrXvTPotJYLdSd7jKFVNLuUdRMPRapsYbh40C/XNUlShcJN64XiZVyIJWJWK/
	0kMHNb0JJXdVYKJAHELXAfH3QgPHCzo=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-97-6GL_YhPeO72UTGI0R7F7pQ-1; Tue,
 22 Apr 2025 06:50:02 -0400
X-MC-Unique: 6GL_YhPeO72UTGI0R7F7pQ-1
X-Mimecast-MFC-AGG-ID: 6GL_YhPeO72UTGI0R7F7pQ_1745319000
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0246319560BB;
	Tue, 22 Apr 2025 10:50:00 +0000 (UTC)
Received: from [10.22.80.44] (unknown [10.22.80.44])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4DADB180045C;
	Tue, 22 Apr 2025 10:49:58 +0000 (UTC)
Date: Tue, 22 Apr 2025 12:49:54 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: LongPing Wei <weilongping@oppo.com>
cc: dm-devel@lists.linux.dev, guoweichao@oppo.com, snitzer@kernel.org, 
    stable@vger.kernel.org
Subject: Re: [PATCH v3] dm-bufio: don't schedule in atomic context
In-Reply-To: <20250417030737.3683876-1-weilongping@oppo.com>
Message-ID: <ef40bdda-90a4-561c-65aa-1abd0e40793b@redhat.com>
References: <16733109-69f6-e347-e1af-02af6223ca8d@redhat.com> <20250417030737.3683876-1-weilongping@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Thanks, I staged this patch for 6.15.

Mikulas


On Thu, 17 Apr 2025, LongPing Wei wrote:

> A BUG was reported as below when CONFIG_DEBUG_ATOMIC_SLEEP and
> try_verify_in_tasklet are enabled.
> [  129.444685][  T934] BUG: sleeping function called from invalid context at drivers/md/dm-bufio.c:2421
> [  129.444723][  T934] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 934, name: kworker/1:4
> [  129.444740][  T934] preempt_count: 201, expected: 0
> [  129.444756][  T934] RCU nest depth: 0, expected: 0
> [  129.444781][  T934] Preemption disabled at:
> [  129.444789][  T934] [<ffffffd816231900>] shrink_work+0x21c/0x248
> [  129.445167][  T934] kernel BUG at kernel/sched/walt/walt_debug.c:16!
> [  129.445183][  T934] Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
> [  129.445204][  T934] Skip md ftrace buffer dump for: 0x1609e0
> [  129.447348][  T934] CPU: 1 PID: 934 Comm: kworker/1:4 Tainted: G        W  OE      6.6.56-android15-8-o-g6f82312b30b9-debug #1 1400000003000000474e5500b3187743670464e8
> [  129.447362][  T934] Hardware name: Qualcomm Technologies, Inc. Parrot QRD, Alpha-M (DT)
> [  129.447373][  T934] Workqueue: dm_bufio_cache shrink_work
> [  129.447394][  T934] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [  129.447406][  T934] pc : android_rvh_schedule_bug+0x0/0x8 [sched_walt_debug]
> [  129.447435][  T934] lr : __traceiter_android_rvh_schedule_bug+0x44/0x6c
> [  129.447451][  T934] sp : ffffffc0843dbc90
> [  129.447459][  T934] x29: ffffffc0843dbc90 x28: ffffffffffffffff x27: 0000000000000c8b
> [  129.447479][  T934] x26: 0000000000000040 x25: ffffff804b3d6260 x24: ffffffd816232b68
> [  129.447497][  T934] x23: ffffff805171c5b4 x22: 0000000000000000 x21: ffffffd816231900
> [  129.447517][  T934] x20: ffffff80306ba898 x19: 0000000000000000 x18: ffffffc084159030
> [  129.447535][  T934] x17: 00000000d2b5dd1f x16: 00000000d2b5dd1f x15: ffffffd816720358
> [  129.447554][  T934] x14: 0000000000000004 x13: ffffff89ef978000 x12: 0000000000000003
> [  129.447572][  T934] x11: ffffffd817a823c4 x10: 0000000000000202 x9 : 7e779c5735de9400
> [  129.447591][  T934] x8 : ffffffd81560d004 x7 : 205b5d3938373434 x6 : ffffffd8167397c8
> [  129.447610][  T934] x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffffffc0843db9e0
> [  129.447629][  T934] x2 : 0000000000002f15 x1 : 0000000000000000 x0 : 0000000000000000
> [  129.447647][  T934] Call trace:
> [  129.447655][  T934]  android_rvh_schedule_bug+0x0/0x8 [sched_walt_debug 1400000003000000474e550080cce8a8a78606b6]
> [  129.447681][  T934]  __might_resched+0x190/0x1a8
> [  129.447694][  T934]  shrink_work+0x180/0x248
> [  129.447706][  T934]  process_one_work+0x260/0x624
> [  129.447718][  T934]  worker_thread+0x28c/0x454
> [  129.447729][  T934]  kthread+0x118/0x158
> [  129.447742][  T934]  ret_from_fork+0x10/0x20
> [  129.447761][  T934] Code: ???????? ???????? ???????? d2b5dd1f (d4210000)
> [  129.447772][  T934] ---[ end trace 0000000000000000 ]---
> 
> dm_bufio_lock will call spin_lock_bh when try_verify_in_tasklet
> is enabled, and __scan will be called in atomic context.
> 
> Fixes: 7cd326747f46 ("dm bufio: remove dm_bufio_cond_resched()")
> Signed-off-by: LongPing Wei <weilongping@oppo.com>
> Cc: stable@vger.kernel.org
> ---
> v3: Always drops the lock after every 16 iterations and
> calls cond_resched() with the lock dropped;
> Change the judgment condition to a more understandable way.
> v2: When no_sleep is enabled, drops the lock after every 16 iterations and calls
> cond_resched() with the lock dropped.
> v1: skip cond_resched when no_sleep is enabled
> ---
>  drivers/md/dm-bufio.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index 9c8ed65cd87e..3088f9f9169a 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -68,6 +68,8 @@
>  #define LIST_DIRTY	1
>  #define LIST_SIZE	2
>  
> +#define SCAN_RESCHED_CYCLE	16
> +
>  /*--------------------------------------------------------------*/
>  
>  /*
> @@ -2424,8 +2426,13 @@ static void __scan(struct dm_bufio_client *c)
>  
>  			atomic_long_dec(&c->need_shrink);
>  			freed++;
> -			cond_resched();
> -		}
> +
> +			if (unlikely(freed % SCAN_RESCHED_CYCLE == 0)) {
> +				dm_bufio_unlock(c);
> +				cond_resched();
> +				dm_bufio_lock(c);
> +			}
> +	}
>  	}
>  }
>  
> -- 
> 2.34.1
> 

