Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A943D1DE8BC
	for <dm-devel@lists.linux.dev>; Thu, 16 Jan 2025 12:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737032389; cv=none; b=LkKeLx4TQzgQKOf4PVPWqm/MUtqciUxbTd3bOLK/ylMuFoxoqlaCzTBvViq6IP16HmFgGRBrPuwNKsV+AMAqj6JJkSOYgETGgt/+MEyjeaTlhFb/V/humZV1Ki67G6+G8pXCKsIla0tXcrHdreQ31HzYqNHKKsIkUeNPzEIAZMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737032389; c=relaxed/simple;
	bh=O1GqtlUjNcSzYqHls1FpUISsdZIbZWRh+gmwhx7NG4U=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=iGcAw0An06G2O9ioYshBpMJJarzvSdHStwgsjVE/YWvPvWntSKUU4IHt3yXtgN6WyCP79nvc008oPzSmDAWob4FNbLLvsdrCc0B/8W95qFgeJk9jgbPI3OlWCQBXJkF1FlaJYLVsCMRSEYmqu4jzqSvs7pZCTMOEwD2YPctKpw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A3hJlU41; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A3hJlU41"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737032386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KhK9kl1gODmxD7g07wig6jOql8Pk7gySgfAJw8uztdE=;
	b=A3hJlU41baO13QmsnPZOdJdoVontdbnlTqmYX9E1l6qmGBGzUDqXTPPsAFYDx0vbDC+27A
	8FjeJo1f+ES1YtPGSLavOPzfbyk+AnPkWzzZARu9IN3lCxq9Vh+uogWPbV1xjpAesoMWvK
	h63wRuqoxU0oMdg500EQIU0QlDfJVAo=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-271-l3pmSGNCP0Ck9-p7Jk_E3Q-1; Thu,
 16 Jan 2025 07:59:44 -0500
X-MC-Unique: l3pmSGNCP0Ck9-p7Jk_E3Q-1
X-Mimecast-MFC-AGG-ID: l3pmSGNCP0Ck9-p7Jk_E3Q
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E4A5B19560B4;
	Thu, 16 Jan 2025 12:59:42 +0000 (UTC)
Received: from [10.45.224.57] (unknown [10.45.224.57])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2D57319560AA;
	Thu, 16 Jan 2025 12:59:38 +0000 (UTC)
Date: Thu, 16 Jan 2025 13:59:35 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: John Garry <john.g.garry@oracle.com>
cc: Mike Snitzer <snitzer@hammerspace.com>, axboe@kernel.dk, agk@redhat.com, 
    hch@lst.de, martin.petersen@oracle.com, linux-block@vger.kernel.org, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] device mapper atomic write support
In-Reply-To: <6a6f8cff-bd19-4079-8867-4ac17d09e915@oracle.com>
Message-ID: <e2be0a8c-3b97-f75c-362e-2174340b1b2c@redhat.com>
References: <20250106124119.1318428-1-john.g.garry@oracle.com> <Z3wSV0YkR39muivP@hammerspace.com> <dcbaadea-66c1-4d98-8a37-945d8b336d5b@oracle.com> <5328db9a-8345-2938-7204-3d4cdb138ee4@redhat.com> <6a6f8cff-bd19-4079-8867-4ac17d09e915@oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40



On Thu, 16 Jan 2025, John Garry wrote:

> On 07/01/2025 17:13, Mikulas Patocka wrote:
> > 
> > 
> > On Mon, 6 Jan 2025, John Garry wrote:
> > 
> > BTW. could it be possible to add dm-mirror support as well? dm-mirror is
> > used when the user moves the logical volume to another physical volume, so
> > it would be nice if this worked without resulting in not-supported errors.
> > 
> > dm-mirror uses dm-io to perform the writes on multiple mirror legs (see
> > the function do_write() -> dm_io()), I looked at the code and it seems
> > that the support for atomic writes in dm-mirror and dm-io would be
> > straightforward.
> 
> I tried this out, and it seems to work ok.
> 
> However, I need to set DM_TARGET_ATOMIC_WRITES in the mirror_target.features
> member, like:
> 
> diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
> index 9511dae5b556..913a92c55904 100644
> --- a/drivers/md/dm-raid1.c
> +++ b/drivers/md/dm-raid1.c
> @@ -1485,6 +1485,7 @@ static struct target_type mirror_target = {
> 	.name    = "mirror",
> 	.version = {1, 14, 0},
> 	.module  = THIS_MODULE,
> +	.features = DM_TARGET_ATOMIC_WRITES,
> 	.ctr     = mirror_ctr,
> 	.dtr     = mirror_dtr,
> 	.map     = mirror_map,
> 
> 
> Is this the right thing to do? I ask, as none of the other DM_TARGET* flags
> are set already, which makes me suspicious.
> 
> Thanks,
> John

Yes - that's right. I suggest that you verify that the atomic flag is 
really passed through the dm-raid1.c and dm-io.c stack. Add a printk that 
tests if REQ_ATOMIC is set to the function do_region in dm-io.c just 
before "submit_bio(bio)".

Alternatively, you can use blktrace to test if the REQ_ATOMIC is passed 
through correctly.

Mikulas

