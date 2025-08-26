Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A608834
	for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 14:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219832; cv=none; b=T15rV9Qxc8Cke7zlMAURF06aa8SbRNZkC4Oi/0uoDGSLI0XnB7ivY0WMb71XrpJX6zYewAUipuqI3ceKh2KUDMeS4Q8yRQAuRgD2EA+V5CCfQ+Fgz9/lvv/Ms9QcFgzgfgq6VtN84eLjbbNhEIuOQNhQ/ZX/otq7FAbHvdoceLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219832; c=relaxed/simple;
	bh=PC+WhoyCREwIz9MEZPFOsxPFtxb1GoWlvUCZSMoeTD4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=vDSsKbVWVmUhrerZIRw66pjloGZaBDUg0df3T8uaGXB76NOIMDIbCDG+fCcYfihJdzu4sOvysu/EKfx4HE3c8NeY0GTlCDUXnU8duNNBBa1f3riCmwmJW1mcGLjcvkSwuWttYx15IBbxEOiblbSY7h1Kb6JpLBczIzO3V6JJ0uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WLAffaW/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WLAffaW/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756219829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zcL5Ega7CZdWwkJSw5aVRg1bRkRFU8JdCVVQISDqVhc=;
	b=WLAffaW/5AeTWHA6HAn7ozZQ7/SPCmvpqaeMPHJojnTLkWvHFHa7TFq/uxiSfgfHGwiHc3
	Ya1QCYzsH3GYWf4QjFeB6XnD0xeKBPFMsccApMrbP2r8c3c9jMuwLc/Grk04EA7c+dii92
	6LJj8N8/sCwGz8kRyE3qfEYBS/mhs44=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-639-jLtX99O5MeO0Cyi-ZkquAg-1; Tue,
 26 Aug 2025 10:50:26 -0400
X-MC-Unique: jLtX99O5MeO0Cyi-ZkquAg-1
X-Mimecast-MFC-AGG-ID: jLtX99O5MeO0Cyi-ZkquAg_1756219824
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 38D3519541A4;
	Tue, 26 Aug 2025 14:50:23 +0000 (UTC)
Received: from [10.22.80.227] (unknown [10.22.80.227])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7D0E9180028A;
	Tue, 26 Aug 2025 14:50:18 +0000 (UTC)
Date: Tue, 26 Aug 2025 16:50:12 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Zheng Qixing <zhengqixing@huaweicloud.com>
cc: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk, ming.lei@redhat.com, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, yukuai3@huawei.com, 
    yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com, 
    zhengqixing@huawei.com
Subject: Re: [PATCH-next 0/2] dm: fix quiesce asymmetry and null pointer in
 suspend/load race
In-Reply-To: <20250826074204.390111-1-zhengqixing@huaweicloud.com>
Message-ID: <41409fd5-2df1-ab1d-848a-3b14e9983338@redhat.com>
References: <20250826074204.390111-1-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111



On Tue, 26 Aug 2025, Zheng Qixing wrote:

> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> Hello,
> 
> During reliability testing of the dm module, we discovered two bugs when
> performing create/remove and suspend/resume operations at high frequency.
> 
> Analysis revealed that race conditions between suspend and table load
> operations cause asymmetric handling of q->quiesce_depth and null pointer
> dereference issues with q->tag_set.
> 
> To address the q->tag_set null pointer issue, patch 2 determines whether
> to perform certain suspend actions for request-based devices based on the
> existence of the table (map).
> 
> For detailed information, please refer to the patch commits.
> 
> Additionally, since modern Linux kernels have indeed transitioned to
> multi-queue as the default (and single-queue is largely deprecated),
> is using queue_is_mq() to determine dm_request_based() obsolete?
> 
> Zheng Qixing (2):
>   dm: fix queue start/stop imbalance under suspend/load/resume races
>   dm: fix NULL pointer dereference in __dm_suspend()
> 
>  drivers/md/dm-core.h |  1 +
>  drivers/md/dm.c      | 13 ++++++++-----
>  2 files changed, 9 insertions(+), 5 deletions(-)
> 
> -- 
> 2.39.2

Both patches applied, thanks.

Mikulas

