Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26C43984A
	for <dm-devel@lists.linux.dev>; Wed, 31 Jan 2024 22:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706738571; cv=none; b=A739YWAussTNlwPn0vVhYmpfJaJKrjLGz5RNekuWfXKr8GjKD3VIVV0WcV1RJzQGt8YBXdDuoOxPFWZbU3KY/3Zwx1R1h2pLipa8fIgctYMO5e923L2e79o6ZeClPFcfa657Vug2mFHnCIfGW+UfOnS81oDugEyDMFHlV4Q5X1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706738571; c=relaxed/simple;
	bh=zYpL4lqLZcMZwHPGsHutXjfMxMqLdIP4q+lWTgr3/5g=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=cjdC6Ch5u5+rinoM5HrPW6EQspdvKXBgJ7I/IhrEGrba8yPzlk0kM0LeYHXbYH3IvA/Lm5wr1oXmCwmUTYljw+S0Qsd79CNG3a9aWFdV6UEwr4lsciCAFo9Nw02paMFSMqQQIyUirm/s3adeLN0A7R/Qb9KfLwHB6PXAQWt8lhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WbWcdndM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WbWcdndM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706738568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fdbEKrpyLSr/XfltsGu0Y6emup0IET0jljTchC3c+Yk=;
	b=WbWcdndMJehrT+L/tP7GJeC/Q5isShjuDt/AarCHDhavjRsCULOcNVnn4wJAxvgDjTOxqC
	ts/4JatOc+DFq3wL2DLiL50ZnJgzLpHZQdlBtAT81N23TtEMSXf404XxReFxjIiViEgoEH
	lF+t8sJizfz6Rxp3MXO59R8K1oMNENo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-HIqzZnzXPwy0fqocRmRlKw-1; Wed, 31 Jan 2024 17:02:44 -0500
X-MC-Unique: HIqzZnzXPwy0fqocRmRlKw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E29BD85A58C;
	Wed, 31 Jan 2024 22:02:43 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9776F40C1231;
	Wed, 31 Jan 2024 22:02:43 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 7F50730C14EB; Wed, 31 Jan 2024 22:02:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 7CA4A3F7DC;
	Wed, 31 Jan 2024 23:02:43 +0100 (CET)
Date: Wed, 31 Jan 2024 23:02:43 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Tejun Heo <tj@kernel.org>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, 
    dm-devel@lists.linux.dev, msnitzer@redhat.com, ignat@cloudflare.com, 
    damien.lemoal@wdc.com, bob.liu@oracle.com, houtao1@huawei.com, 
    peterz@infradead.org, mingo@kernel.org, netdev@vger.kernel.org, 
    allen.lkml@gmail.com, kernel-team@meta.com, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Subject: Re: [PATCH 8/8] dm-verity: Convert from tasklet to BH workqueue
In-Reply-To: <Zbq8cE3Y2ZL6dl8r@slm.duckdns.org>
Message-ID: <f48626b7-d1c-d696-7138-39fbc1c9cebd@redhat.com>
References: <20240130091300.2968534-1-tj@kernel.org> <20240130091300.2968534-9-tj@kernel.org> <c2539f87-b4fe-ac7d-64d9-cbf8db929c7@redhat.com> <Zbq8cE3Y2ZL6dl8r@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2



On Wed, 31 Jan 2024, Tejun Heo wrote:

> Hello,
> 
> On Wed, Jan 31, 2024 at 10:19:07PM +0100, Mikulas Patocka wrote:
> > > @@ -83,7 +83,7 @@ struct dm_verity_io {
> > >  	struct bvec_iter iter;
> > >  
> > >  	struct work_struct work;
> > > -	struct tasklet_struct tasklet;
> > > +	struct work_struct bh_work;
> > >  
> > >  	/*
> > >  	 * Three variably-size fields follow this struct:
> > 
> > Do we really need two separate work_structs here? They are never submitted 
> > concurrently, so I think that one would be enough. Or, am I missing 
> > something?
> 
> I don't know, so just did the dumb thing. If the caller always guarantees
> that the work items are never queued at the same time, reusing is fine.
> However, the followings might be useful to keep on mind:
> 
> - work_struct is pretty small - 4 pointers.
> 
> - INIT_WORK() on a queued work item isn't gonna be pretty.
> 
> - Flushing and no-concurrent-execution guarantee are broken on INIT_WORK().
>   e.g. If you queue_work(), INIT_WORK(), flush_work(), the flush isn't
>   actually going to wait for the work item to finish. Also, if you do
>   queue_work(), INIT_WORK(), queue_work(), the two queued work item
>   instances may end up running concurrently.
> 
> Muxing a single work item carries more risks of subtle bugs, but in some
> cases, the way it's used is clear (e.g. sequential chaining) and that's
> fine.

The code doesn't call INIT_WORK() on a queued work item and it doesn't 
flush the workqueue (it destroys it only in a situation when there are no 
work items running) so I think it's safe to use just one work_struct.

Mikulas

