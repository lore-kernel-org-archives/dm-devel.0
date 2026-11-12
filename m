Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794515763;
	b=a1vz387fsE9pNWa7VMBKESU8LHUIqyhttB0PB+HkhNeI3oSl4Bq9NBtDJ+KETkKmGKKX
	 Cpl3jBDiHgD7tW8k4oFK655yTb6QUWmo/MLW61Y2hXPyr2eZ7R8kT/vCLleP/lJaS87rK
	 rcYwg51kujVdxaHd0tnGNJPJL5CxHYltXqpWPDYhiNHGGcWDHNZCRQBYkTtOpuNVETZOC
	 ekCp8VrIpszY8qc4znsAr1GzwQalqHllRDgBsAldTmtGuaDaLri1q7pQMATTsclAMAC1b
	 VZRvL30vzwvhSY0u03cn7bt5In3G1GvjvVqsHTGt2Vw1F1IZ6UelkQpPPtLibV2cEqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794515763;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 In-Reply-To:Message-ID:References:MIME-Version:X-Scanned-By:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=eZWosmTB2z09pzY3l2Lg25u9IuMg+1eDSXiFcCZwwKE=;
	b=HyI00t0S25LWIF4ahvz9PMJXKTlQpUXRAHjfkOuBXZCpFnURH8jcphVdBBYoDc4ZgeE0
	 ROyciUwsKAZ0Ku/EAkROR//L8RcTqxD99LpY8/OkkSBnwWPNbQyBiqKSWrvf9QZygS7Qu
	 V9iKPIT9fsWHduv5OG1rPwUwROK+ul/aOiJ0ncwJk8UjbNITMco4rwHCwBjyPqd6dxyA/
	 96YZT2HxV4GKYIqrtTuqbevpLJUcsks9LIy0UP6ilbWH7tKKay/6qzC8FVEuOVo05UKRA
	 N6nL62OqadaooLwJoq687E2mRww1itvhSMgdrYfUNxFPJKcwZxDgmDzW64D0mBhM+YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=funuZ9Co;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC284606A32D
	for <dm-devel@lists.linux.dev>; Thu, 12 Nov 2026 20:36:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC284606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=funuZ9Co
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794515761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eZWosmTB2z09pzY3l2Lg25u9IuMg+1eDSXiFcCZwwKE=;
	b=funuZ9CoHTMZDy9EVsbxA98PrKU8W65HKdNQE8Bm0DXKA8ILWjyZtxTzzlE3CVbF4VgAPU
	klHDFd5b0UFrUJRddQbcCBp953wPByY3u3MUxVscFi/ZQhbxGp2eKikYRjR7Q//CpNfG+K
	sf5CTHOZD6IbtTk2fWumRNK1PFe4lbo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-325-2-SFs9fUMcGyqhnckK5WRg-1; Thu,
 12 Nov 2026 15:35:57 -0500
X-MC-Unique: 2-SFs9fUMcGyqhnckK5WRg-1
X-Mimecast-MFC-AGG-ID: 2-SFs9fUMcGyqhnckK5WRg_1794515756
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 344011956059;
	Thu, 12 Nov 2026 20:35:56 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2416118004F5;
	Thu, 12 Nov 2026 20:35:52 +0000 (UTC)
Date: Thu, 12 Nov 2026 21:35:50 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Li Youhong <dayou5941@163.com>
cc: agk@redhat.com, snitzer@kernel.org, bmarzins@redhat.com, yukuai@fygo.io, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
    Li Youhong <liyouhong@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH] dm-raid: fix use-after-free in raid_dtr()
In-Reply-To: <20261112091206.1656622-1-dayou5941@163.com>
Message-ID: <2f7691db-0f26-bc0a-886e-2f97c2805bde@redhat.com>
References: <20261112091206.1656622-1-dayou5941@163.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: ZuyTHa_umjE6A8nOAdrSNo7ViJDeytS3LwhStS0Wxrw_1794515756
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

OK. I applied the patch, thanks.

Mikulas


On Thu, 12 Nov 2026, Li Youhong wrote:

> From: Li Youhong <liyouhong@kylinos.cn>
> 
> raid_dtr() currently flushes event_work only if work_pending() is true.
> This is insufficient because once a worker has dequeued the work, the
> PENDING bit is cleared while do_table_event() is still running. In that
> window raid_set_free() can free the raid_set, leading to a
> use-after-free when do_table_event() accesses rs->ti->table.
> 
> Flush event_work whenever it has been initialized, so raid_set is not
> freed while the event handler is still running. The .func guard skips the
> flush for mddev instances where INIT_WORK has not run yet.
> 
> Fixes: db29d79b34d9 ("dm-raid: delay flushing event_work() after reconfig_mutex is released")
> Cc: stable@vger.kernel.org
> Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
> ---
> v2: 
> - Fix incorrect Fixes tag; the work_pending() check in raid_dtr() was
>   introduced by db29d79b34d9, not a17d1bca5aba.
> - v1: https://lore.kernel.org/all/20261112075741.1449168-1-dayou5941@163.com/
> 
>  drivers/md/dm-raid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index ac019a0f5a92..c1f546e8c65d 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -3340,7 +3340,7 @@ static void raid_dtr(struct dm_target *ti)
>  	rs->md.dm_gendisk = NULL;
>  	mddev_unlock(&rs->md);
>  
> -	if (work_pending(&rs->md.event_work))
> +	if (rs->md.event_work.func)
>  		flush_work(&rs->md.event_work);
>  	raid_set_free(rs);
>  }
>  
> -- 
> 2.25.1
> 

