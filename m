Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2962C026C
	for <dm-devel@lists.linux.dev>; Tue,  2 Dec 2025 17:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764695019; cv=none; b=Z5bxx8/MOsspx68nh8ru5BiHvu6T7T/N4aeH0I9jGZm1Pxbqejhw3u+0ml+LalpNK/ECIZUxGDw1NrZlxXWpYe6scF5AVsVR+IZ9ZWH92nGtNRIDsK6QQEdxIY9PHgdEp0BURJKQyS4inXtIe61KhzFFL8nVZPrM1TaEKPx90nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764695019; c=relaxed/simple;
	bh=1/d1obDgDGUrozDCLxhkp7fRQx3TB6siqG+aUtbDHKA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=g53l5MrQut8YKBegKiFE7NvEUDVjaHdn2i/IrdogIsw2Oj8Yj65JFn6VoM01SY6orCkPAe4j6grd7Y3+TusTm8IrCFHdjfiEyFjW7/8MEWWGA7DhE3a9Et2tUn76+mCUsl1rPX7yx5S07TZnYrauANADPaN3vtB4xIMwdLjx8IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V5lO8hiB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V5lO8hiB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764695016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9cnS1ntG4QnvTed6Zu3vNjJkvTx5JXwT00EvHNNevCI=;
	b=V5lO8hiBxGlYXyI0OcFILKQ8hDBI0ea94WiqYGGnXCaBHhcfEpfK6FfXx7Kf3IKaE/35gL
	IBrbrJGImTAmhePgVFJ39Az3z6yqHeHZn31AijrYakltmQEP8pqY/AZAk/SmZMmJxnteh1
	bqawc51+1lUnyzXUsy4UxhEQ/730nrU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-601-FAXfqkVKPvSJqeIcb0Ixjg-1; Tue,
 02 Dec 2025 12:03:33 -0500
X-MC-Unique: FAXfqkVKPvSJqeIcb0Ixjg-1
X-Mimecast-MFC-AGG-ID: FAXfqkVKPvSJqeIcb0Ixjg_1764695011
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 70CC71955F44;
	Tue,  2 Dec 2025 17:03:31 +0000 (UTC)
Received: from [10.44.33.72] (unknown [10.44.33.72])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C4A80195608E;
	Tue,  2 Dec 2025 17:03:29 +0000 (UTC)
Date: Tue, 2 Dec 2025 18:03:23 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Jiping Ma <jiping.ma2@windriver.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm-snapshot: fix 'scheduling while atomic' on real-time
 kernels
In-Reply-To: <aS4U3zt_jUkpjLlR@redhat.com>
Message-ID: <4370a6f7-f472-7fc9-3fc1-a28646d8f37e@redhat.com>
References: <747444e7-6884-cc1b-a761-c1e3bb7b888f@redhat.com> <aS4U3zt_jUkpjLlR@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QXPb-sokwsbKsmcWbMGsnpW331OIosA8sVKR_319UjA_1764695011
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Mon, 1 Dec 2025, Benjamin Marzinski wrote:

> On Mon, Dec 01, 2025 at 10:13:10PM +0100, Mikulas Patocka wrote:
> > There is reported 'scheduling while atomic' bug when using dm-snapshot on
> > real-time kernels. The reason for the bug is that the hlist_bl code does
> > preempt_disable() when taking the lock and the kernel attempts to take
> > other spinlocks while holding the hlist_bl lock.
> > 
> > Fix this by converting a hlist_bl spinlock into a regular spinlock.
> 
> This looks correct, but it will either cause an increase in the memory
> used, or a possible performance hit due to lock contention on a smaller
> number of hash buckets, depending on whether the number of hash buckets
> calculated by the device/chunk size is larger than the new, smaller
> calc_max_buckets() limit. Since calc_max_buckets() limits the memory use
> to 2MB, I suspect that for most devices, this will result in fewer
> buckets (a 2G cow device with a 16K chunk size on a 64bit machine would
> hit the calc_max_buckets() limit of 262144 buckets before.  Depending on
> how the kernel is configured, the limit is now likely half that, so cow
> devices of over 1G are likely to start having fewer buckets).  
> 
> I wonder if we should double the calc_max_buckets() memory limit, or
> perhaps play some #ifdef games so that only real-time kernels are
> effected by this change.
> 
> -Ben

On 32-bit architectures, the vmalloc space is limited (to about 128MiB), 
so I wouldn't increase the total limit.

Mikulas

