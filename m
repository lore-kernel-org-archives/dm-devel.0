Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4402E8B84
	for <dm-devel@lists.linux.dev>; Mon, 15 Dec 2025 22:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765836248; cv=none; b=V4S0TfbIiB/dWDQoJbzQ8rzWm8ScGVk+gbKyZggOCbF8KVaxqV2sHhtajJmrBDRRvSN2Kq8pXYu3/aTnAQCFoljEw53qUGm5+j/XoGYLI6R+pDCWlM4LMxO0LQGNj6MWCnHVqFP/RPAk2yjr+KfrEBn963MNwBNYIoHvoJUg4ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765836248; c=relaxed/simple;
	bh=f95MHPi+kkYKU13c0/4NMNIo6nU0gYQaw81/juYWW2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=KH0F6JcyypNfUKHMpb4I1xgmMWTmisz+K3VbRbIZ/rmEZOk/cPS+AylDS93cQ4Pw5Lu9Gt0aWm7dnerobmseDa0CBpdk125aYxoOF+A+RLlB9k7Z2RdFDVi40M4Hv6GGCk11vlQcC/O5udROCyXViMvYycLiQP9VXUXDCAVODbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZK4oaYeV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZK4oaYeV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765836245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=51CIUCdCitT+GBmHunQ+VYjy3jWT1xzQPavEo+Z/niU=;
	b=ZK4oaYeVBQb+6eYvPmnDoQmh0sc3cnfVj6plgNy+fY25q0QC7e20aNWJu2NNim+WRoa44K
	YSFuE+hN/Gi3xPZw30+gOMCnjq4lW/ziiBJX9pY6SdRXrc8ODtMFATTMnyjh6JYjvAyns2
	Dr8rajY7WrB1UeFAfYDT3vG3/30dL4I=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-125-8tAHq5OoNCaFfQqacZjERA-1; Mon,
 15 Dec 2025 17:04:02 -0500
X-MC-Unique: 8tAHq5OoNCaFfQqacZjERA-1
X-Mimecast-MFC-AGG-ID: 8tAHq5OoNCaFfQqacZjERA_1765836241
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 47E7E1956094;
	Mon, 15 Dec 2025 22:04:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ABA5B19560A7;
	Mon, 15 Dec 2025 22:04:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5BFM3x0v1998705
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Dec 2025 17:03:59 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5BFM3xK81998704;
	Mon, 15 Dec 2025 17:03:59 -0500
Date: Mon, 15 Dec 2025 17:03:59 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Yongpeng Yang <yangyongpeng.storage@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
        Yongpeng Yang <yangyongpeng@xiaomi.com>,
        Yongpeng Yang <yangyongpeng.storage@outlook.com>
Subject: Re: [PATCH v3 1/1] dm-stripe: adjust max_hw_discard_sectors to avoid
 unnecessary discard bio splitting
Message-ID: <aUCFz_bwzRo4HSyk@redhat.com>
References: <20251212130955.466384-1-yangyongpeng.storage@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251212130955.466384-1-yangyongpeng.storage@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: s-9Fcaa4eOCWOWTV2yNqdVzk9Duw_O1cxhJRqSOhTCc_1765836241
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Dec 12, 2025 at 09:09:55PM +0800, Yongpeng Yang wrote:
> From: Yongpeng Yang <yangyongpeng@xiaomi.com>
> 
> Currently, the max_hw_discard_sectors of a stripe target is set to the
> minimum max_hw_discard_sectors among all sub devices. When the discard
> bio is larger than max_hw_discard_sectors, this may cause the stripe
> device to split discard bios unnecessarily, because the value of
> max_hw_discard_sectors affects max_discard_sectors, which equal to
> min(max_hw_discard_sectors, max_user_discard_sectors).
> 
> For example:
> root@vm:~# echo '0 33554432 striped 2 256 /dev/vdd 0 /dev/vde 0' | dmsetup create stripe_dev
> root@vm:~# cat /sys/block/dm-1/queue/discard_max_bytes
> 536870912
> root@vm:~# cat /sys/block/dm-1/slaves/vdd/queue/discard_max_bytes
> 536870912
> root@vm:~# blkdiscard -o 0 -l 1073741824 -p 1073741824 /dev/mapper/stripe_dev
> 
> dm-1 is the stripe device, and its discard_max_bytes is equal to
> each sub device’s discard_max_bytes. Since the requested discard
> length exceeds discard_max_bytes, the block layer splits the discard bio:
> 
> block_bio_queue: 252,1 DS 0 + 2097152 [blkdiscard]
> block_split: 252,1 DS 0 / 1048576 [blkdiscard]
> block_rq_issue: 253,48 DS 268435456 () 0 + 524288 be,0,4 [blkdiscard]
> block_bio_queue: 253,64 DS 524288 + 524288 [blkdiscard]
> 
> However, both vdd and vde can actually handle a discard bio of 536870912
> bytes, so this split is not necessary.
> 
> This patch updates the stripe target’s q->limits.max_hw_discard_sectors
> to be the minimum max_hw_discard_sectors of the sub devices multiplied
> by the # of stripe devices, and max_hw_discard_sectors must round down to
> chunk size multiply # of stripe devices to avoid issue discard bio to sub
> devices which is larger than max_hw_discard_sectors.
> 
> This patch enables the stripe device to handle larger discard bios
> without incurring unnecessary splitting.
> 
> Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

