Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952A519342F
	for <dm-devel@lists.linux.dev>; Tue, 21 Jan 2025 12:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737462677; cv=none; b=HmLtCDg7wCi5kH+pGaCrz2J0DfZ1UoKvKrnyNgNmFwPQ1nm2jAe1OuUPTIO7Z1yHIK1yklHJzVp0XJ74pjLhncpLiRlLW4zuwiWvscavQGlc/XvacmiBZIn3NdCSXhOpxs1YCgc0btIq6sH/WQ31yAWyfhD3+T8V+3SYPmZDZ50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737462677; c=relaxed/simple;
	bh=eQQSI7aX8teQ/PlHD6j2OduY1n+DoVmDJmwE1vLJeQI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=nrIGuAKvo+EhYtCriB6SMCYDL8RW8hhlCi+GHx3CrBlIclxcX0mHv5L5x5IgYbfbDB5jgciYdtILfzBuuxbPp3ugt2cleMKCICIimIkceMYofRxa5uSdwowsgCKsQxpstx52BZTX5Q5KwW6kfGZCNbIylhSwe425xuCcerUDXoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EaVh727P; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EaVh727P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737462674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TVwRDbUYkhH5Lk2TvvJR8UKk+yuKxoLllxy+r28q7wI=;
	b=EaVh727P+qtPd+8K2/WnCiHabl415Ier+eAjTAy3jIg9E5wiks2u+b6UPyykPmS+F6VuE0
	3RE6fgjzFMvzvgZBapM1X/Q7qL35BUB/Q+l0HfMKFjaz4Ac9sWq1M2VD58YOse1O2jOszC
	f2+cE/D/VX8wUJ4dGeqid23yVIE53Hg=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-116-vvCSyuy6Pg2vqBoSs-HqXQ-1; Tue,
 21 Jan 2025 07:31:10 -0500
X-MC-Unique: vvCSyuy6Pg2vqBoSs-HqXQ-1
X-Mimecast-MFC-AGG-ID: vvCSyuy6Pg2vqBoSs-HqXQ
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 60DE919560A3;
	Tue, 21 Jan 2025 12:31:08 +0000 (UTC)
Received: from [10.45.224.57] (unknown [10.45.224.57])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3529719560A7;
	Tue, 21 Jan 2025 12:31:05 +0000 (UTC)
Date: Tue, 21 Jan 2025 13:31:01 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Hou Tao <houtao@huaweicloud.com>
cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Ignat Korchagin <ignat@cloudflare.com>, houtao1@huawei.com
Subject: Re: [PATCH 0/6] dm-crypt: misc cleanups and fixes
In-Reply-To: <20250120082951.1423804-1-houtao@huaweicloud.com>
Message-ID: <a0c0eed2-a068-551f-9c86-2a07bd4e3eca@redhat.com>
References: <20250120082951.1423804-1-houtao@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12



On Mon, 20 Jan 2025, Hou Tao wrote:

> From: Hou Tao <houtao1@huawei.com>
> 
> Hi,
> 
> The patchset contains misc cleanups and minor fixes for dm-crypt. These
> problem were spotted during the code inspection. The patchset have been
> tested by running fio on dm-crypt devices (both with and without
> integrity feature). Patch #6 is tested by asynchronizing the
> crypt/decrypt algorithm when using random IV.
> 
> Please see individual patches for more details. Comments are always
> welcome.
> 
> Hou Tao (6):
>   dm-crypt: set atomic as false when calling crypt_convert() in kworker
>   dm-crypt: fully initialize clone->bi_iter in crypt_alloc_buffer()
>   dm-crypt: use bi_sector in bio when initialize integrity seed
>   dm-crypt: don't update io->sector after
>     kcryptd_crypt_write_io_submit()
>   dm-crypt: don't initialize cc_sector again
>   dm-crypt: track tag_offset in convert_context
> 
>  drivers/md/dm-crypt.c | 42 ++++++++++++++++--------------------------
>  1 file changed, 16 insertions(+), 26 deletions(-)
> 
> -- 
> 2.29.2

I applied the patches. Thanks.

Mikulas

