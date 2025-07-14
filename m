Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD781F0E26
	for <dm-devel@lists.linux.dev>; Mon, 14 Jul 2025 17:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752513433; cv=none; b=N+u1xc3eTLVsOCntyJMlda2BvddGNFa9PxeONXkjKpXR76P9f0ft0w71JP9mdGdupo67Ditl/7i7eopDVs5qX9OaJXxhHdS06NLs/2V9WDtFj6qluIcv8pKwnTSHsUe0IryZ0G6ByEz7P7Unnszy6QWybT2hyYEgE65KkW69c6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752513433; c=relaxed/simple;
	bh=tiJQhLSIHDjv009JUXLp1PzpzTY95wk8W039bMr5naQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=o3oHyXKV7XmbL0EUJOeuZSpSC+OBeC13A6jZupMreVpO+mNdnr3/oeBnxygXSgRSAzHG9lR8c+oio7wWYa9oyE9Hz2MZzEUchT1plTQlA+2Ri3ndqwEVQWyfCIttUXMK4obc0BbRNL0JAdpCy1tKBffhK/0TrIW5KFDi8aaZ5UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c2P9hVfH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c2P9hVfH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752513430;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=StenXae51hFgjVCmuBJO+neelh5zP4HIatFPuIaaQok=;
	b=c2P9hVfHPf8uM4BGhT5MFt94vLAB8CN3WZLtYlSyZf+Qdu5zkQ4s/e8QWZdQMcZ5nroF9B
	lUc1cPc4ZOS3pC4JTrgwcBL/J2BrTKkng8fs605aDd5oFG/EvhqPxDjSGhMFq0da8KJKTR
	G4OOxTAA+Sv/wAlaLqIVZwwD56VJ874=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-568-wQO2_PvMNU6UgxbTmF0Ykg-1; Mon,
 14 Jul 2025 13:17:09 -0400
X-MC-Unique: wQO2_PvMNU6UgxbTmF0Ykg-1
X-Mimecast-MFC-AGG-ID: wQO2_PvMNU6UgxbTmF0Ykg_1752513428
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D498A1800268;
	Mon, 14 Jul 2025 17:17:07 +0000 (UTC)
Received: from [10.22.80.10] (unknown [10.22.80.10])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5786B180045C;
	Mon, 14 Jul 2025 17:17:05 +0000 (UTC)
Date: Mon, 14 Jul 2025 19:17:00 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Sheng Yong <shengyong2021@gmail.com>
cc: agk@redhat.com, snitzer@kernel.org, nhuck@google.com, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
    Sheng Yong <shengyong1@xiaomi.com>, Wang Shuai <wangshuai12@xiaomi.com>
Subject: Re: [PATCH] dm-bufio: fix sched in atomic context
In-Reply-To: <20250710064855.239572-1-shengyong1@xiaomi.com>
Message-ID: <673ddfed-d874-9ffe-c2fe-a741e8fc69f1@redhat.com>
References: <20250710064855.239572-1-shengyong1@xiaomi.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111



On Thu, 10 Jul 2025, Sheng Yong wrote:

> From: Sheng Yong <shengyong1@xiaomi.com>
> 
> If "try_verify_in_tasklet" is set for dm-verity, DM_BUFIO_CLIENT_NO_SLEEP
> is enabled for dm-bufio. However, when bufio tries to evict buffers, there
> is a chance to trigger scheduling in spin_lock_bh, the following warning
> is hit:
> 
> BUG: sleeping function called from invalid context at drivers/md/dm-bufio.c:2745
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 123, name: kworker/2:2
> preempt_count: 201, expected: 0
> RCU nest depth: 0, expected: 0
> 4 locks held by kworker/2:2/123:
>  #0: ffff88800a2d1548 ((wq_completion)dm_bufio_cache){....}-{0:0}, at: process_one_work+0xe46/0x1970
>  #1: ffffc90000d97d20 ((work_completion)(&dm_bufio_replacement_work)){....}-{0:0}, at: process_one_work+0x763/0x1970
>  #2: ffffffff8555b528 (dm_bufio_clients_lock){....}-{3:3}, at: do_global_cleanup+0x1ce/0x710
>  #3: ffff88801d5820b8 (&c->spinlock){....}-{2:2}, at: do_global_cleanup+0x2a5/0x710
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 2 UID: 0 PID: 123 Comm: kworker/2:2 Not tainted 6.16.0-rc3-g90548c634bd0 #305 PREEMPT(voluntary)
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> Workqueue: dm_bufio_cache do_global_cleanup
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x53/0x70
>  __might_resched+0x360/0x4e0
>  do_global_cleanup+0x2f5/0x710
>  process_one_work+0x7db/0x1970
>  worker_thread+0x518/0xea0
>  kthread+0x359/0x690
>  ret_from_fork+0xf3/0x1b0
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> 
> That can be reproduced by:
> 
>   veritysetup format --data-block-size=4096 --hash-block-size=4096 /dev/vda /dev/vdb
>   SIZE=$(blockdev --getsz /dev/vda)
>   dmsetup create myverity -r --table "0 $SIZE verity 1 /dev/vda /dev/vdb 4096 4096 <data_blocks> 1 sha256 <root_hash> <salt> 1 try_verify_in_tasklet"
>   mount /dev/dm-0 /mnt -o ro
>   echo 102400 > /sys/module/dm_bufio/parameters/max_cache_size_bytes
>   [read files in /mnt]
> 
> Fixes: 5721d4e5a9cd ("dm verity: Add optional "try_verify_in_tasklet" feature")
> Signed-off-by: Wang Shuai <wangshuai12@xiaomi.com>
> Signed-off-by: Sheng Yong <shengyong1@xiaomi.com>
> ---
>  drivers/md/dm-bufio.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index ec84ba5e93e5..caf6ae9a8b52 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -2742,7 +2742,9 @@ static unsigned long __evict_a_few(unsigned long nr_buffers)
>  		__make_buffer_clean(b);
>  		__free_buffer_wake(b);
>  
> +		dm_bufio_unlock(c);
>  		cond_resched();
> +		dm_bufio_lock(c);
>  	}
>  
>  	dm_bufio_unlock(c);
> -- 
> 2.43.0

Hi

I accepted this patch. I changed it to:

-               cond_resched();
+               if (need_resched()) {
+                       dm_bufio_unlock(c);
+                       cond_resched();
+                       dm_bufio_lock(c);
+               }
        }

        dm_bufio_unlock(c);

so that we are not hammering on the dm bufio lock when scheduling is not 
needed.

Mikulas

