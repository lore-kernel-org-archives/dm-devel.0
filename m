Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1543359FBB
	for <dm-devel@lists.linux.dev>; Mon, 19 Jan 2026 14:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768831994; cv=none; b=uyPJfX4Zcu/qXLdGxO961Ma0WrDqZmbzOsUMcCibzdTXzRHb+GixxVGD+zoJI7pOb7IADs3SylVjg5yLJLgK51B7+mrnzklZ9Ho2CnqBw4HT5rpFf2QUrYlAppbqnZqWRbaHJiUjy2MWal4Vw7CL5g/uTmIjq5fyWRxgVAox+JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768831994; c=relaxed/simple;
	bh=q2yvCaRRVefdrHz3CNu6AX98LWiSeHMub59QXmMy0FQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=XVScsAcsGhZNlqLRnhGXA47aiRLp4uUwzXS+DjVBNEgVu5FQAy4XucvmPgY2J5LvsCSYQFMPxOjniRfd+jVleGmDHSohXL3fqAWX4r4AnwggVTs3BcHJ9CfseQ1xFBdpydZd/ffb/F2poVFYVfwBaLZ/E4W0CPO5r30MpLiOTG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GAxkDw/o; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GAxkDw/o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768831991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ebyI3bLKLnk3wVMppHXYyVkPOPXPK9J8Jgvz46YG0MA=;
	b=GAxkDw/ogUuTuwUkol12khZLThcK7ATxEyk9mHWd1J4eUP1mt8isr/gZYvI6oJ7VDn9mzf
	5UG0U2KlkXR7VXikC7bd2ZeaI8gEhm4uV8pDGh4G9wBGyuN3bm2AZCzYGS3vJfD3uDF91j
	1J3xWHWmqWYpJXvSxXnUwSAv1w8SOzY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-556-lkwWE78zPYGN1Vi05oQi4g-1; Mon,
 19 Jan 2026 09:13:10 -0500
X-MC-Unique: lkwWE78zPYGN1Vi05oQi4g-1
X-Mimecast-MFC-AGG-ID: lkwWE78zPYGN1Vi05oQi4g_1768831989
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5E75618005BA;
	Mon, 19 Jan 2026 14:13:09 +0000 (UTC)
Received: from [10.44.34.158] (unknown [10.44.34.158])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EF6811800285;
	Mon, 19 Jan 2026 14:13:07 +0000 (UTC)
Date: Mon, 19 Jan 2026 15:13:04 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Matt Whitlock <kernel@mattwhitlock.name>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev
Subject: Re: Patch for mapping bug in drivers/md/dm-unstripe.c
In-Reply-To: <68f72c7d-7e4e-4182-87fc-78c138046cd3@mattwhitlock.name>
Message-ID: <113951bf-b1f9-02ad-3e9b-9fc1e30a575b@redhat.com>
References: <68f72c7d-7e4e-4182-87fc-78c138046cd3@mattwhitlock.name>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aIeHbw0B3511_tJtwe_41E2GK66wEgXmTiEKalG0EJU_1768831989
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

The patch is OK. Please re-send it with the "Signed-off-by: Matt Whitlock 
<kernel@mattwhitlock.name>" line inserted - this line indicates that you 
have legal right to send the patch.

Mikulas



On Sun, 18 Jan 2026, Matt Whitlock wrote:

> The "unstriped" device-mapper target incorrectly calculates the sector offset on the mapped device when the target's origin is not zero.
> 
> Take for example this hypothetical concatenation of the members of a two-disk RAID0:
> 
> linearized:       0 2097152 unstriped 2 128 0 /dev/md/raid0 0
> linearized: 2097152 2097152 unstriped 2 128 1 /dev/md/raid0 0
> 
> The intent in this example is to create a single device named 
> /dev/mapper/linearized that comprises all of the chunks of the first 
> disk of the RAID0 set, followed by all of the chunks of the second disk 
> of the RAID0 set.
> 
> This fails because dm-unstripe.c's map_to_core function does its 
> computations based on the sector number within the mapper device rather 
> than the sector number within the target. The bug turns invisible when 
> the target's origin is at sector zero of the mapper device, as is the 
> common case. In the example above, however, what happens is that the 
> first half of the mapper device gets mapped correctly to the first disk 
> of the RAID0, but the second half of the mapper device gets mapped past 
> the end of the RAID0 device, and accesses to any of those sectors return 
> errors.
> 
> Here is a very simple (tested) patch that corrects the problem:
> 
> --- drivers/md/dm-unstripe.c~	2025-11-28 22:33:48.000000000 -0500
> +++ drivers/md/dm-unstripe.c	2026-01-18 12:48:52.378293579 -0500
> @@ -117,7 +117,7 @@
>  static sector_t map_to_core(struct dm_target *ti, struct bio *bio)
>  {
>  	struct unstripe_c *uc = ti->private;
> -	sector_t sector = bio->bi_iter.bi_sector;
> +	sector_t sector = dm_target_offset(ti, bio->bi_iter.bi_sector);
>  	sector_t tmp_sector = sector;
>  
>  	/* Shift us up to the right "row" on the stripe */
> 
> 

