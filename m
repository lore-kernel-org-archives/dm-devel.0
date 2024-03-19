Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781263FBB9
	for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 13:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710853473; cv=none; b=n8Y8uIt3Ltw3RwQqVBYME2qQyr6yQci7y7RQBU5+VGHG3/U6Ekvk0ow+NrInzcXKnufLPa267XgjqNTP2pUavLuPS5J+bTS7MYmrdo2a7aM/f+pr2T8Pe1qpieeyT/gfWIhq6IGSbjR/uboC64XEDRP3nsOV7DNfcUMNl3+cGdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710853473; c=relaxed/simple;
	bh=t8/WbBOO17RV9PAifBmlRewT+u9NooCdKtAXog8FkVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=jq7ym2zhMS3slVMEAM3RXFpixHhtRfj5/nvCzRulTH6NcFOOsqM1fZv0JLGhSFj7GcgH1yQIXaH46flOJSdH3sc2r2BNOFEv6aZf1T3yrYX+5FAoXxliYdfPf10CXDIx1b8UHbX9FHwYxKnGqfeDDTM5vaRTyFUY97W9gS82dyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a1QEPwOJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a1QEPwOJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710853469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vGqQmj8V+iFqzes2z51VbLZdMwFXCUEPashuoA/Telo=;
	b=a1QEPwOJIqunsxWmSe0ZSLzujB0bllM7RDajWi3IlcWf66QjfJiuZFRCeKpttdlF8EffqO
	FqLI7s0lLo9e85TuQ7m7zFcAy6c7qabwQ6bFg2yr5d1Bx9kHTZpwccuygvI/kNYFbAsozt
	4dMmyFvjLQxgHy2SSrWuDS15t+tn2lc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355-P3QGoAUdN3yQfaM9_NMj6g-1; Tue, 19 Mar 2024 09:04:26 -0400
X-MC-Unique: P3QGoAUdN3yQfaM9_NMj6g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99C4F8007A6;
	Tue, 19 Mar 2024 13:04:25 +0000 (UTC)
Received: from fedora (unknown [10.72.116.95])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A32F910E47;
	Tue, 19 Mar 2024 13:04:20 +0000 (UTC)
Date: Tue, 19 Mar 2024 21:04:12 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>, dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.de>,
	Vasilis Liaskovitis <vliaskovitis@suse.com>, ming.lei@redhat.com
Subject: Re: [RFC Patch] dm: make sure to wait for all dispatched requests in
 __dm_suspend()
Message-ID: <ZfmNTK9uODx9YrLL@fedora>
References: <20240315231035.26046-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240315231035.26046-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Martin,

On Sat, Mar 16, 2024 at 12:10:35AM +0100, Martin Wilck wrote:
> In a recent kernel dump analysis, we found that the kernel crashed because
> dm_rq_target_io tio->ti was pointing to invalid memory in dm_end_request(),
> in a situation where multipathd was doing map reloads because of a storage
> failover. The map of the respective mapped_device had been replaced by a
> different struct dm_table.
> 
> We obverved this with a 5.3.18 distro kernel, but the code in question
> hasn't change much since then. Basically, we were only missing
> b4459b11e840 ("dm rq: don't queue request to blk-mq during DM suspend"),
> which doesn't guarantee that the race I'm thinking of (see below) can't
> happen.
> 
> When a map is resumed after a table reload, the live table is swapped, and
> the tio->ti member of any live request becomes stale.  __dm_resume() avoids
> this by quiescing the queue and calling dm_wait_for_completion(), which
> waits until blk_mq_queue_inflight() doesn't report any in-flight requests.
> 
> However, blk_mq_queue_inflight() counts only "started" requests. So, if a
> request is dispatched before the queue was quiesced, but
> dm_wait_for_completion() doesn't observe MQ_RQ_IN_FLIGHT for this request
> because of memory ordering effects, __dm_suspend() may finish successfully,

Can you explain a bit about the exact memory order which causes MQ_RQ_IN_FLIGHT
not observed?

blk-mq quiesce includes synchronize_rcu() which drains all in-flight
dispatch, so after blk_mq_quiesce_queue() returns,
if blk_mq_queue_inflight() returns 0, it does mean there isn't any
active inflight requests.

If there is bug in this pattern, I guess more drivers may have such
'risk'.

BTW, what is the underlying disks in your dm-mpath setting?

Thanks,
Ming

