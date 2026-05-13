Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA4B39656D
	for <dm-devel@lists.linux.dev>; Wed, 13 May 2026 10:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778668676; cv=none; b=Zv8N9mhw/yNJjYPn/L6TaHzOZCq03GQ/2MiHTcdkUb9GWDoBMCQnUWBCBhHZeHga6B2uMJR8tVw0YVmt61B9Rj8Zt+c1S1utqLnlDKHB5DZM7yOpZ0uC9M4810lV3YwR7rQYtYaeX9RH/N9vB5tztqWLEzR79CEh+XeuaMfsFAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778668676; c=relaxed/simple;
	bh=si0YdMWLpEha1pR7cG27VlF7QB3J4cJXwn/noCs+xpM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=eEJroiYe894/rWG5KNA8c8DQor4bM51c0L3vXYgT/sv4ivJGkzg5pdAoQ50PXIYi5pvGl3A3gbd/PfhvbtO9Bxdpa3oAh3LFYeYDiEu0qX2hS/odDm5Nv90VVTHeprysjdowqeOL3UYRBcJIDpsXrnFsOXVnh4VR+zZG+s7fB9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A8MpdSzm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A8MpdSzm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778668673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vLIZtpme7lqA8uaBYjY0PoknW19oz1RAiCg1eSrGKpU=;
	b=A8MpdSzmC+w02c8FkJ0Ex8NCEkm1P2T7qE93aHPmgzBQkTKzXsWFXLMVrcYenEWf+yh3Wa
	kGgYIGUnEJlBZ2QTb9ewjK95Deo61I+6JaNUTnrhqBiWsSF2h3t0BkygipYvq8KLuwlCHp
	WsMTpHmebDmVzgs5nNzSU1lvs5d/wko=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-436-SHXkheLvN3OeujhFH9nbRA-1; Wed,
 13 May 2026 06:37:52 -0400
X-MC-Unique: SHXkheLvN3OeujhFH9nbRA-1
X-Mimecast-MFC-AGG-ID: SHXkheLvN3OeujhFH9nbRA_1778668671
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ACA151956094;
	Wed, 13 May 2026 10:37:51 +0000 (UTC)
Received: from [10.44.34.151] (unknown [10.44.34.151])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F96730001BB;
	Wed, 13 May 2026 10:37:49 +0000 (UTC)
Date: Wed, 13 May 2026 12:37:43 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Matthew Sakai <msakai@redhat.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Bruce Johnston <bjohnsto@redhat.com>, zkabelac@redhat.com, 
    dm-devel@lists.linux.dev
Subject: Re: [RFC PATCH] dm: add deviceless messages
In-Reply-To: <b775c420-da70-4568-afd6-3a3aabbe6b10@redhat.com>
Message-ID: <fe13dcbc-8b07-4a0a-89a5-9a5e123e9873@redhat.com>
References: <3bdbd9fa-52ce-ab52-569f-29d4a30c6780@redhat.com> <b775c420-da70-4568-afd6-3a3aabbe6b10@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: F3cOICfD-ibJfejqcflMRdvq3AbaaTfwylJLXi4GFLY_1778668671
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 12 May 2026, Matthew Sakai wrote:

> 
> 
> On 5/12/26 9:36 AM, Mikulas Patocka wrote:
> > The VDO code needs to perform some calculations before creating a device.
> > The calculations should be performed in the kernel, so that the same logic
> > is not duplicated in the kernel and in the userspace.
> > 
> > However, currently it is not possible to call a device mapper target
> > when no device exists.
> > 
> > This commit solves the problem by adding "deviceless" messages. If the
> > message starts with '%', the name is a name of a target, not a name of a
> > device. The message will be directed to the target by calling the
> > "deviceless_message" method. The target can perform the requested
> > calculations in this method and return the result back to userspace.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> I do wish that we could clean up the message interface. The sector number
> argument is completely meaningless for a deviceless message, so in theory we
> could distinguish this case by omitting the argument, e.g. "dmsetup message
> <target_type> <command>" and not require the special '%' notation, either. But
> that looks like it would require a lot more rearrangement of the message
> handling code.

I wanted to design it in such a way that we don't have to update the 
libdevmapper library or the dmsetup tool to send deviceless messages - 
that's why there is the unused sector number.

In the past, dm_stats was glueued to messages in a similar way (the 
dm_stats messages start with '@'), the sector number is also unused in 
this case.

Perhaps we could introduce a new ioctl DM_DEVICELESS_MSG_CMD and send 
deviceless messages with it, but that would need coordination with the 
libdevmapper+dmsetup maintainers. I think it would create maintenance 
burden (you couldn't use deviceless messages unless you update 
libdevmapper, you couldn't update libdevmapper unless you update libc, you 
couldn't update libc unless you update the whole distribution ... etc.).

> I agree this does what we need, so...
> 
> Reviewed-by: Matthew Sakai <msakai@redhat.com>

When you make a patch that needs deviceless messages, let me know and I 
will commit it. I will not commit deviceless messages now, because I want 
to have someone using it when committing it.

Mikulas

