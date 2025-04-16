Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4432F233703
	for <dm-devel@lists.linux.dev>; Wed, 16 Apr 2025 12:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744806193; cv=none; b=grcjd/FmryMcSGlJHJkpRiszE513eA2tztlylG2IPjZhuYUFaBlRD+jW/S4TT0YklA4vH5SSdB4A75sN2u/v59U9TPCgmxwZqcwbhpFmdndu9kmy/D+sOT+bW3gVuxTRfNRG52Sy8eTvAPXLwuJMOgYzNJNMrVJladO5is1O84k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744806193; c=relaxed/simple;
	bh=BNNXHc3G4/P42wkC6YrERhqTngXbHGqYCDxu1ZPNtgw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=avZDogB05AuG+sWhvodKPZAdYO6mpumnkaOSLXqom7396ItyT4o6kgqBnYlqCktgiWnt57554QZUh9Fb6COW+9/0QXzlwAkJU8TKea1wy+9B13nWRWeT92Pw92aPf9Y9HRNlRV75ElG3WLMADuni/qp7jLd1V8YbjlGBvF6IChc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U2Z/F9Et; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U2Z/F9Et"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744806190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5+95kStl2BNlED8Hin7xB1+gkS6ToMqarNmefKmS1C8=;
	b=U2Z/F9Et+07iv/RvaAc+Uw6FydMxLO8X/2j5N/+PYSaY4ZJZMMeCWLwS8yxX5pUuJ/Bfur
	y8bCQwnmvHgepMKuYGXEe9nKf0jfLGcZJeUIxTzgWpsdQigTKrjVtOXqAG1zEw9TVNBUyS
	OhbLbiDVghwTZNPEAZ8/ZIy3W4SiWLU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-343-PSZ2yjHyNQ2m7Q0TR286ww-1; Wed,
 16 Apr 2025 08:23:06 -0400
X-MC-Unique: PSZ2yjHyNQ2m7Q0TR286ww-1
X-Mimecast-MFC-AGG-ID: PSZ2yjHyNQ2m7Q0TR286ww_1744806185
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D73518004A7;
	Wed, 16 Apr 2025 12:23:05 +0000 (UTC)
Received: from [10.22.80.44] (unknown [10.22.80.44])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C93C180045B;
	Wed, 16 Apr 2025 12:23:03 +0000 (UTC)
Date: Wed, 16 Apr 2025 14:22:59 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: LongPing Wei <weilongping@oppo.com>
cc: snitzer@kernel.org, dm-devel@lists.linux.dev, guoweichao@oppo.com
Subject: Re: [PATCH] dm-bufio: skip cond_resched when no_sleep is enabled
In-Reply-To: <20250416094512.3561667-1-weilongping@oppo.com>
Message-ID: <16733109-69f6-e347-e1af-02af6223ca8d@redhat.com>
References: <20250416094512.3561667-1-weilongping@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YShv_cKfUXS3X6Ye3L162aA0T2sCqxlJ1OdijHYewZc_1744806185
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 16 Apr 2025, LongPing Wei wrote:

> A BUG was reported as below when CONFIG_DEBUG_ATOMIC_SLEEP and
> try_verify_in_tasklet are enabled.
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index 9c8ed65cd87e..bdbd79e76f96 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -2424,6 +2424,10 @@ static void __scan(struct dm_bufio_client *c)
>  
>  			atomic_long_dec(&c->need_shrink);
>  			freed++;
> +
> +			if (static_branch_unlikely(&no_sleep_enabled) && c->no_sleep)
> +				continue;
> +
>  			cond_resched();
>  		}
>  	}
> -- 
> 2.34.1

Hi

Thanks for the bug report. I think it is not a good practice in general to 
hold a spinlock and loop over a list of unbounded size. So, I modified 
your patch so that it drops the lock after every 16 iterations and calls 
cond_resched() with the lock dropped.

Please, test this patch and report whether it works for you.

Mikulas


[PATCH] dm-bufio: don't schedule in atomic context

A BUG was reported as below when CONFIG_DEBUG_ATOMIC_SLEEP and
try_verify_in_tasklet are enabled.
[  129.444685][  T934] BUG: sleeping function called from invalid context at drivers/md/dm-bufio.c:2421
[  129.444723][  T934] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 934, name: kworker/1:4
[  129.444740][  T934] preempt_count: 201, expected: 0
[  129.444756][  T934] RCU nest depth: 0, expected: 0
[  129.444781][  T934] Preemption disabled at:
[  129.444789][  T934] [<ffffffd816231900>] shrink_work+0x21c/0x248
[  129.445167][  T934] kernel BUG at kernel/sched/walt/walt_debug.c:16!
[  129.445183][  T934] Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
[  129.445204][  T934] Skip md ftrace buffer dump for: 0x1609e0
[  129.447348][  T934] CPU: 1 PID: 934 Comm: kworker/1:4 Tainted: G        W  OE      6.6.56-android15-8-o-g6f82312b30b9-debug #1 1400000003000000474e5500b3187743670464e8
[  129.447362][  T934] Hardware name: Qualcomm Technologies, Inc. Parrot QRD, Alpha-M (DT)
[  129.447373][  T934] Workqueue: dm_bufio_cache shrink_work
[  129.447394][  T934] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  129.447406][  T934] pc : android_rvh_schedule_bug+0x0/0x8 [sched_walt_debug]
[  129.447435][  T934] lr : __traceiter_android_rvh_schedule_bug+0x44/0x6c
[  129.447451][  T934] sp : ffffffc0843dbc90
[  129.447459][  T934] x29: ffffffc0843dbc90 x28: ffffffffffffffff x27: 0000000000000c8b
[  129.447479][  T934] x26: 0000000000000040 x25: ffffff804b3d6260 x24: ffffffd816232b68
[  129.447497][  T934] x23: ffffff805171c5b4 x22: 0000000000000000 x21: ffffffd816231900
[  129.447517][  T934] x20: ffffff80306ba898 x19: 0000000000000000 x18: ffffffc084159030
[  129.447535][  T934] x17: 00000000d2b5dd1f x16: 00000000d2b5dd1f x15: ffffffd816720358
[  129.447554][  T934] x14: 0000000000000004 x13: ffffff89ef978000 x12: 0000000000000003
[  129.447572][  T934] x11: ffffffd817a823c4 x10: 0000000000000202 x9 : 7e779c5735de9400
[  129.447591][  T934] x8 : ffffffd81560d004 x7 : 205b5d3938373434 x6 : ffffffd8167397c8
[  129.447610][  T934] x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffffffc0843db9e0
[  129.447629][  T934] x2 : 0000000000002f15 x1 : 0000000000000000 x0 : 0000000000000000
[  129.447647][  T934] Call trace:
[  129.447655][  T934]  android_rvh_schedule_bug+0x0/0x8 [sched_walt_debug 1400000003000000474e550080cce8a8a78606b6]
[  129.447681][  T934]  __might_resched+0x190/0x1a8
[  129.447694][  T934]  shrink_work+0x180/0x248
[  129.447706][  T934]  process_one_work+0x260/0x624
[  129.447718][  T934]  worker_thread+0x28c/0x454
[  129.447729][  T934]  kthread+0x118/0x158
[  129.447742][  T934]  ret_from_fork+0x10/0x20
[  129.447761][  T934] Code: ???????? ???????? ???????? d2b5dd1f (d4210000)
[  129.447772][  T934] ---[ end trace 0000000000000000 ]---

dm_bufio_lock will call spin_lock_bh when try_verify_in_tasklet
is enabled, and __scan will be called in atomic context.

Signed-off-by: LongPing Wei <weilongping@oppo.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-bufio.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2025-04-14 16:01:58.000000000 +0200
+++ linux-2.6/drivers/md/dm-bufio.c	2025-04-16 14:18:44.000000000 +0200
@@ -2424,7 +2424,12 @@ static void __scan(struct dm_bufio_clien
 
 			atomic_long_dec(&c->need_shrink);
 			freed++;
-			cond_resched();
+
+			if (!(freed & 15)) {
+				dm_bufio_unlock(c);
+				cond_resched();
+				dm_bufio_lock(c);
+			}
 		}
 	}
 }

