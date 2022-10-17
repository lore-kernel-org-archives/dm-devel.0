Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A02EC4332F
	for <dm-devel@archiver.kernel.org>; Mon, 17 Oct 2022 19:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666035522;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YVglkdiGJOtch+RE3D3oZH3rHlFs5CHDsXABHkr0/Jc=;
	b=ePU30xUYc6qasNUSeuPgroQxB+QR0oOjs4l0dVfPhBfV2PnA5Mk4FARqp+vbD7pBRFT4WU
	BN9aT7nSFi6BouykrZluaS3M8I1IysIF3hKzCAFdwTTh9yzHHH6XciGTHP0pD6m7E+aPHY
	Pszp1K2jpCg1fOKhnM0z9lnFUQ0zT/4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-486-bM2bdWVzNwynKtHGcr65Tw-1; Mon, 17 Oct 2022 15:38:41 -0400
X-MC-Unique: bM2bdWVzNwynKtHGcr65Tw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30E0A3C02586;
	Mon, 17 Oct 2022 19:38:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 771FF422A9;
	Mon, 17 Oct 2022 19:38:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 420CB1946594;
	Mon, 17 Oct 2022 19:38:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B478F194658F
 for <dm-devel@listman.corp.redhat.com>; Mon, 17 Oct 2022 19:38:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D565E20227AB; Mon, 17 Oct 2022 19:38:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CE066202279C
 for <dm-devel@redhat.com>; Mon, 17 Oct 2022 19:38:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE438101A56D
 for <dm-devel@redhat.com>; Mon, 17 Oct 2022 19:38:36 +0000 (UTC)
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-537-LxdNw1e7NISq_BgQjEhzWg-1; Mon, 17 Oct 2022 15:38:35 -0400
X-MC-Unique: LxdNw1e7NISq_BgQjEhzWg-1
Received: by mail-qk1-f199.google.com with SMTP id
 h9-20020a05620a244900b006ee944ec451so10487245qkn.13
 for <dm-devel@redhat.com>; Mon, 17 Oct 2022 12:38:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=HFnOp3Wkg1GKboj4d8hJ1JshjMzyGnKQ7QLdx8EYPyg=;
 b=2j1gRuQ1jkKGWMAP9kROjqR2a5+dpcj+oRk+2X6qqQe3WCvLLKko4t3HUnlP8wLitk
 fMXEKCPCEN1GFZWj+z6jzSyqMeVLx5lzNmMrnO76Yq/Wa7Enr9UJGWWomNdsSv1W3R5X
 LPfgXpkyQtnonazTVLEBDJfR6CerdbYeMg9nCLq6/xdC2sUe2V1//EdU/VFcaJShacbt
 kiaiq3qlBGc5tczQ/tJix3sQteslQhs/byH6w89+TH5R7ZGS5QTlayc/+dfXudeUl1Su
 8pvJY9QQdXoGH2dBAPjZcBagaCutm24V1SqTNk8tJAUH0wd86YxzXCmjSHR9jPpFJh4x
 +EFQ==
X-Gm-Message-State: ACrzQf3PK2UNewZtLHXc+m1YZ4UdOfpzhvDr2UlyH2U2ixaeVAWzDL3B
 fAGtGjR///ShzS903k4x3BpF5trgX3NVX+3kT7sYLvj+M04dvn2IJN9wQ3eAAsPG6mLgtn2CUDQ
 LUMzq5LLzP4+jwA==
X-Received: by 2002:a05:6214:da9:b0:4b1:d600:f9d7 with SMTP id
 h9-20020a0562140da900b004b1d600f9d7mr9830053qvh.26.1666035514870; 
 Mon, 17 Oct 2022 12:38:34 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4vWvW66iPIu4z/LtfxYql28IzfRmmRRkNnwOtpZDj0JV82wQtVKh02PQ84kpc+dYUj8PEc+Q==
X-Received: by 2002:a05:6214:da9:b0:4b1:d600:f9d7 with SMTP id
 h9-20020a0562140da900b004b1d600f9d7mr9830039qvh.26.1666035514623; 
 Mon, 17 Oct 2022 12:38:34 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 x12-20020a05620a448c00b006ec5238eb97sm482702qkp.83.2022.10.17.12.38.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 17 Oct 2022 12:38:33 -0700 (PDT)
Date: Mon, 17 Oct 2022 15:38:32 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Luo Meng <luomeng@huaweicloud.com>
Message-ID: <Y02vOFnwZOHPrVY8@redhat.com>
References: <20221010143905.240306-1-luomeng@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <20221010143905.240306-1-luomeng@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] dm: Fix UAF in run_timer_softirq()
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
Cc: snitzer@kernel.org, ejt@redhat.com, dm-devel@redhat.com,
 luomeng12@huawei.com, yukuai3@huawei.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Oct 10 2022 at 10:39P -0400,
Luo Meng <luomeng@huaweicloud.com> wrote:

> From: Luo Meng <luomeng12@huawei.com>
> 
> When dm_resume() and dm_destroy() are concurrent, it will
> lead to UAF.
> 
> One of the concurrency UAF can be shown as below:
> 
>         use                                  free
> do_resume                           |
>   __find_device_hash_cell           |
>     dm_get                          |
>       atomic_inc(&md->holders)      |
>                                     | dm_destroy
> 				    |   __dm_destroy
> 				    |     if (!dm_suspended_md(md))
>                                     |     atomic_read(&md->holders)
> 				    |     msleep(1)
>   dm_resume                         |
>     __dm_resume                     |
>       dm_table_resume_targets       |
> 	pool_resume                 |
> 	  do_waker  #add delay work |
> 				    |     dm_table_destroy
> 				    |       pool_dtr
> 				    |         __pool_dec
>                                     |           __pool_destroy
>                                     |             destroy_workqueue
>                                     |             kfree(pool) # free pool
> 	time out
> __do_softirq
>   run_timer_softirq # pool has already been freed
> 
> This can be easily reproduced using:
>   1. create thin-pool
>   2. dmsetup suspend pool
>   3. dmsetup resume pool
>   4. dmsetup remove_all # Concurrent with 3
> 
> The root cause of UAF bugs is that dm_resume() adds timer after
> dm_destroy() skips cancel timer beause of suspend status. After
> timeout, it will call run_timer_softirq(), however pool has already
> been freed. The concurrency UAF bug will happen.
> 
> Therefore, canceling timer is moved after md->holders is zero.
> 
> Signed-off-by: Luo Meng <luomeng12@huawei.com>
> ---
>  drivers/md/dm.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 60549b65c799..379525313628 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2420,6 +2420,19 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
>  
>  	blk_mark_disk_dead(md->disk);
>  
> +	/*
> +	 * Rare, but there may be I/O requests still going to complete,
> +	 * for example.  Wait for all references to disappear.
> +	 * No one should increment the reference count of the mapped_device,
> +	 * after the mapped_device state becomes DMF_FREEING.
> +	 */
> +	if (wait)
> +		while (atomic_read(&md->holders))
> +			msleep(1);
> +	else if (atomic_read(&md->holders))
> +		DMWARN("%s: Forcibly removing mapped_device still in use! (%d users)",
> +		       dm_device_name(md), atomic_read(&md->holders));
> +
>  	/*
>  	 * Take suspend_lock so that presuspend and postsuspend methods
>  	 * do not race with internal suspend.
> @@ -2436,19 +2449,6 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
>  	dm_put_live_table(md, srcu_idx);
>  	mutex_unlock(&md->suspend_lock);
>  
> -	/*
> -	 * Rare, but there may be I/O requests still going to complete,
> -	 * for example.  Wait for all references to disappear.
> -	 * No one should increment the reference count of the mapped_device,
> -	 * after the mapped_device state becomes DMF_FREEING.
> -	 */
> -	if (wait)
> -		while (atomic_read(&md->holders))
> -			msleep(1);
> -	else if (atomic_read(&md->holders))
> -		DMWARN("%s: Forcibly removing mapped_device still in use! (%d users)",
> -		       dm_device_name(md), atomic_read(&md->holders));
> -
>  	dm_table_destroy(__unbind(md));
>  	free_dev(md);
>  }
> -- 
> 2.31.1
> 

Thanks for the report but your fix seems wrong.  A thin-pool specific
fix seems much more appropriate.  Does this fix the issue?

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index e76c96c760a9..dc271c107fb5 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2889,6 +2889,8 @@ static void __pool_destroy(struct pool *pool)
 	dm_bio_prison_destroy(pool->prison);
 	dm_kcopyd_client_destroy(pool->copier);
 
+	cancel_delayed_work_sync(&pool->waker);
+	cancel_delayed_work_sync(&pool->no_space_timeout);
 	if (pool->wq)
 		destroy_workqueue(pool->wq);
 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

