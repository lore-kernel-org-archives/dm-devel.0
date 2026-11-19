Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795116030;
	b=rZNN5Z1g8em8rH0nB8tvJ5ygSisOCnVq7LI7qjsopnG38opt7lE9wR5mgNfW0h8R9Bjk
	 FZZ3OOLK8b/6mM4+nPJNHtNEUxb+aasrclyKV+SB7DLY0rIWsuOlinlARzRLSclnAkCdW
	 asU/ilsiEUO8s22N22HL0txu8XsOBXSIEGJ7hU8/F8UDdRAt7ThcjYR6amjwSeGW2drgc
	 CwNPgvNGVxi8fEoaXzHETl42yJiDdTphwQhYX+X6Snl5fepmVKjr/q/agZ0Ety8PGZt/h
	 rAMR85n7Rxo3K4uq7OrNmaukxtxD6778DkyssAiZxxLRAIafWLIvhzsEjzi83jRYtNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795116030;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Type:Content-Disposition;
	bh=DfTV47JjtP50GhGwZ7AfK3DVBWS/1obgYuiq0TribuQ=;
	b=JoRwU9tk0MowSMIM55vMEttQSr6JBlNcJFgPpiCGk9iRuk9pfcNuUqtr6Nxegz+gurAo
	 lskrIi3kIToqUZJPuObejlnS/y/xrOVNq9RRYANPha6ynXqRHiWjLHssBVXYfqYexYFAn
	 6BGXGeaBtKJOw+ChQG8aU3O0Aaxn/l2S0o4E78bgmwzMkOHa2+01FFC/gzCbvTIcBBg15
	 h+muRL4A5n5uXCVaqyi0ercDt/BGnee4mGyDmc5Cqg4lNvgZDx12pR3oJgxpaE+FgN8yR
	 nUYhC2a4sko/Umktfl+iiwvcsGhIGi7tmj0uNf4gsua+PCC/99AIphLIqSWUZi2ZBTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OUwLpUMB;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED85606A325
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 19:20:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7ED85606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OUwLpUMB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795116028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DfTV47JjtP50GhGwZ7AfK3DVBWS/1obgYuiq0TribuQ=;
	b=OUwLpUMBkqcsyWr+yq3+gDi03zR6482RAKvOAPCZYmWs2O1ODkPF1U9s/09/lYsPU6SQQQ
	EtPUZVTNf42JnsEMWnFpP8gIavvv+fpqjBnM19AJJnNSxbJKFhqMDUI1Ua6Ujudqta9a8K
	YudYbork0xsCF28vyB+0+Ns59dqvAV4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-643-oOVQDF-1McuTwF7-NU5rNA-1; Thu,
 19 Nov 2026 14:20:22 -0500
X-MC-Unique: oOVQDF-1McuTwF7-NU5rNA-1
X-Mimecast-MFC-AGG-ID: oOVQDF-1McuTwF7-NU5rNA_1795116021
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E3BCB18004FC;
	Thu, 19 Nov 2026 19:20:20 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6CE111956087;
	Thu, 19 Nov 2026 19:20:20 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6AJJKJeZ880720
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 14:20:19 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6AJJKGKv880698;
	Thu, 19 Nov 2026 14:20:16 -0500
Date: Thu, 19 Nov 2026 14:20:16 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Qiliang Yuan <qiliang.yuan@linux.dev>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/3] dm thin: keep a thin on active_thins until its
 last reference is dropped
Message-ID: <av9L8MWVWbhGcON6@redhat.com>
References: <20261119-bug-dm-thin-rcu-gp-v3-0-c80ecc475e1e@linux.dev>
 <20261119-bug-dm-thin-rcu-gp-v3-2-c80ecc475e1e@linux.dev>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261119-bug-dm-thin-rcu-gp-v3-2-c80ecc475e1e@linux.dev>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: _50RPigNNq8qZjzIuXORQVDbvbQRA-X39XsUCmoHjbg_1795116021
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 19, 2026 at 06:05:07AM -0500, Qiliang Yuan wrote:
> get_first_thin() and get_next_thin() let the pool worker process the
> thins on pool->active_thins without holding rcu_read_lock() while it
> does: they take a reference on a thin under the lock, and
> get_next_thin() continues from that thin in a new read-side section.
> thin_dtr() takes the thin off the list, waits for a grace period and
> then for the references still held.
> 
> Once thin_dtr() has removed a thin that the worker holds, nothing
> updates its list.next pointer any more. If the thin after it is removed
> and freed before the worker calls get_next_thin(), the walk continues
> from freed memory:
> 
>   BUG: KASAN: slab-use-after-free in get_next_thin+0x8b/0x240 [dm_thin_pool]
>   Write of size 4 at addr ff11000116371cc8 by task kworker/u128:0/13
>   Workqueue: dm-thin do_worker [dm_thin_pool]
>   Call Trace:
>    get_next_thin+0x8b/0x240 [dm_thin_pool]
>    process_deferred_bios+0x34/0x650 [dm_thin_pool]
>    do_worker+0x2b7/0x4f0 [dm_thin_pool]
>    process_one_work+0x8ce/0x1850
>    worker_thread+0x639/0x1190
>   Allocated by task 2290:
>    thin_ctr+0x130/0x1260 [dm_thin_pool]
>    dm_table_add_target+0x65f/0xf60 [dm_mod]
>    table_load+0x1c2/0x480 [dm_mod]
>   Freed by task 2391:
>    kfree+0x15d/0x550
>    thin_dtr+0x21c/0x2c0 [dm_thin_pool]
>    dm_table_destroy+0x13c/0x570 [dm_mod]
>    __dm_destroy+0x2eb/0x5d0 [dm_mod]
>    dev_remove+0x2f1/0x3c0 [dm_mod]
> 
> Mark the thin as dying in thin_dtr() instead of removing it, and take it
> off the list only after the last reference is dropped, so that removing
> its neighbours keeps its list.next valid. Take references with
> refcount_inc_not_zero() and skip dying thins, so that thin_dtr() only
> waits for the references already taken, and have requeue_bios() and
> error_retry_list_with_code() skip dying thins as they skipped the thins
> already off the list.
> 
> With a test-only 3 s msleep() added to the worker after each thin it
> processes, thins 1 and 2 of a pool with three thins are suspended and
> then removed while the worker holds thin 1. Trials in which KASAN reports
> a slab-use-after-free in get_next_thin():
> 
>                  before (trials)   after (trials)   change
>   KASAN report            3 of 3           0 of 5     -100%
> 
> Fixes: 17181fb7a0c3 ("dm thin: fix a race in thin_dtr")
> Cc: stable@vger.kernel.org
> Reported-by: Benjamin Marzinski <bmarzins@redhat.com>
> Closes: https://lore.kernel.org/r/avz7qDWd2g-uubmL@redhat.com
> Co-developed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>

Thanks for updating this.

-Ben

