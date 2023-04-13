Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCF8FC77B77
	for <dm-devel@archiver.kernel.org>; Fri, 14 Apr 2023 06:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681455130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8HEWe6R95bxUE1KoRG5h/ZI+reE4sH+gdpF53BqUIF8=;
	b=jIqk2fXYK9U8YroE/A19YMzHs+zUs3TWDHhzPSAJqdSGkdyN1ibWStidM+Z8ThaTzKzuh8
	Man5V3I6pjpY8pZtfB4066v77hqcNiZ57kbLZsH4AuIjp2QIjH7UMdaw0Mr6FQwJ+PTO5b
	+EVv2MtRrhWVGRW1NuG6gq3vLiOBOSM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-352-NzU7Ka8SPHeckovJIFbqXA-1; Fri, 14 Apr 2023 02:52:07 -0400
X-MC-Unique: NzU7Ka8SPHeckovJIFbqXA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CB3D3C0F1AD;
	Fri, 14 Apr 2023 06:52:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 32DE2C15E7F;
	Fri, 14 Apr 2023 06:52:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9689F1946A71;
	Fri, 14 Apr 2023 06:52:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CBA4D19465B6
 for <dm-devel@listman.corp.redhat.com>; Thu, 13 Apr 2023 15:45:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BC2BDC1602A; Thu, 13 Apr 2023 15:45:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B48FBC16028
 for <dm-devel@redhat.com>; Thu, 13 Apr 2023 15:45:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 888F42A5954D
 for <dm-devel@redhat.com>; Thu, 13 Apr 2023 15:45:25 +0000 (UTC)
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-314-uYor3o2iP22iyUEJQyqFMQ-1; Thu,
 13 Apr 2023 11:45:23 -0400
X-MC-Unique: uYor3o2iP22iyUEJQyqFMQ-1
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200]
 helo=[192.168.0.10]) by ale.deltatee.com with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94.2)
 (envelope-from <logang@deltatee.com>)
 id 1pmyb1-007m0l-TO; Thu, 13 Apr 2023 09:10:48 -0600
Message-ID: <961691d0-7224-caad-6c19-d9c8ca07a801@deltatee.com>
Date: Thu, 13 Apr 2023 09:10:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To: Yu Kuai <yukuai1@huaweicloud.com>, dm-devel@redhat.com, song@kernel.org
References: <20230413113217.1934353-1-yukuai1@huaweicloud.com>
 <20230413113217.1934353-6-yukuai1@huaweicloud.com>
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20230413113217.1934353-6-yukuai1@huaweicloud.com>
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: yukuai1@huaweicloud.com, dm-devel@redhat.com,
 song@kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
X-SA-Exim-Mail-From: logang@deltatee.com
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Fri, 14 Apr 2023 06:52:02 +0000
Subject: Re: [dm-devel] [PATCH -next v6 5/5] md: protect md_thread with rcu
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: linux-raid@vger.kernel.org, yukuai3@huawei.com, yangerkun@huawei.com,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: deltatee.com
Content-Language: en-CA
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 2023-04-13 05:32, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Our test reports a uaf for 'mddev->sync_thread':
> 
> T1                      T2
> md_start_sync
>  md_register_thread
>  // mddev->sync_thread is set
> 			raid1d
> 			 md_check_recovery
> 			  md_reap_sync_thread
> 			   md_unregister_thread
> 			    kfree
> 
>  md_wakeup_thread
>   wake_up
>   ->sync_thread was freed
> 
> Root cause is that there is a small windown between register thread and
> wake up thread, where the thread can be freed concurrently.
> 
> Currently, a global spinlock 'pers_lock' is borrowed to protect
> 'mddev->thread', this problem can be fixed likewise, however, there are
> similar problems elsewhere, and use a global lock for all the cases is
> not good.
> 
> This patch protect all md_thread with rcu.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md-bitmap.c    | 10 ++++--
>  drivers/md/md-cluster.c   |  7 ++--
>  drivers/md/md-multipath.c |  4 +--
>  drivers/md/md.c           | 69 ++++++++++++++++++---------------------
>  drivers/md/md.h           |  8 ++---
>  drivers/md/raid1.c        |  7 ++--
>  drivers/md/raid1.h        |  2 +-
>  drivers/md/raid10.c       | 21 +++++++-----
>  drivers/md/raid10.h       |  2 +-
>  drivers/md/raid5-cache.c  | 22 ++++++++-----
>  drivers/md/raid5.c        | 15 +++++----
>  drivers/md/raid5.h        |  2 +-
>  12 files changed, 91 insertions(+), 78 deletions(-)
> 
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 29fd41ef55a6..ab27f66dbb1f 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -1221,13 +1221,19 @@ static bitmap_counter_t *md_bitmap_get_counter(struct bitmap_counts *bitmap,
>  static void mddev_set_timeout(struct mddev *mddev, unsigned long timeout,
>  			      bool force)
>  {
> -	struct md_thread *thread = mddev->thread;
> +	struct md_thread *thread;
> +
> +	rcu_read_lock();
> +	thread = rcu_dereference(mddev->thread);
>  
>  	if (!thread)
> -		return;
> +		goto out;
>  
>  	if (force || thread->timeout < MAX_SCHEDULE_TIMEOUT)
>  		thread->timeout = timeout;
> +
> +out:
> +	rcu_read_unlock();
>  }
>  
>  /*
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 10e0c5381d01..672dfa6a40ec 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -362,8 +362,8 @@ static void __recover_slot(struct mddev *mddev, int slot)
>  
>  	set_bit(slot, &cinfo->recovery_map);
>  	if (!cinfo->recovery_thread) {
> -		cinfo->recovery_thread = md_register_thread(recover_bitmaps,
> -				mddev, "recover");
> +		rcu_assign_pointer(cinfo->recovery_thread,
> +			md_register_thread(recover_bitmaps, mddev, "recover"));
>  		if (!cinfo->recovery_thread) {
>  			pr_warn("md-cluster: Could not create recovery thread\n");
>  			return;
> @@ -889,7 +889,8 @@ static int join(struct mddev *mddev, int nodes)
>  	}
>  	/* Initiate the communication resources */
>  	ret = -ENOMEM;
> -	cinfo->recv_thread = md_register_thread(recv_daemon, mddev, "cluster_recv");
> +	rcu_assign_pointer(cinfo->recv_thread,
> +			md_register_thread(recv_daemon, mddev, "cluster_recv"));
>  	if (!cinfo->recv_thread) {

This looks like it'll hit sparse warnings. without an
rcu_access_pointer(). Might be nicer to use a temporary variable, check
that it's not null, then call rcu_assign_pointer().

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

