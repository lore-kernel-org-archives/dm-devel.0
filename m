Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC9BB667
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 00:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733875384; cv=none; b=CE/3PuyAD+ZbBCFI9aN48YJH4//5+eE4OEDG3fTegqVpZe/PxKwcDVSwcMmhcn10BhDfIo/gO4zmUaOjJhjYcCJmqvCa1UhjYNQC3g6yf5FN3LyESbtfRQQLsJSBQlopPiWy6N2bkjJKDXP18qpNp7nZ5aZ6vnEBIFgTSCdkMAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733875384; c=relaxed/simple;
	bh=x4MqGrbPFKei8Pbo82eb0BjUzVZpEfsp+eM0nBYuCMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=K5xRGxpJ9mmMSYLpBiv7OgHUAacX3xvyYU9pgpyUGRT/Z7Fb1xEhaSdh8FGqxk4DeMXbW+tl4LgiAzsic0u9MUHxEVKtgFAWSMRU8RJZTZTANpawsMQI79MF4jn0aZtFTjaUcw+//7LWxsZP8A/AGFtCxMRANoz7gAqtir/PR5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QBHThMaf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QBHThMaf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733875381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dBKmAzH8zO/9t28XhPoYk0eN9oN+7bhM7u7dFSyDYzM=;
	b=QBHThMafoAiXHtRxEjuUuVufkes+Ql/OLOd97IgZxRXYKgn4K5X8eklG9PRoWOH5EfzFn0
	6PJGeg4jAhFoEsDaXW/1r1j5+jvUV1rZ5qysiT3oksp4Huyp+G88DxU6IkslhxU9dfJa41
	suhamY7EQ7eWEZwIupNs4g0HuReEwI8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-681-A49j2rojMdSnuHKdnjGcig-1; Tue,
 10 Dec 2024 19:02:59 -0500
X-MC-Unique: A49j2rojMdSnuHKdnjGcig-1
X-Mimecast-MFC-AGG-ID: A49j2rojMdSnuHKdnjGcig
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A3CBF1955E80;
	Wed, 11 Dec 2024 00:02:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 521171956054;
	Wed, 11 Dec 2024 00:02:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4BB02uBB1426400
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 19:02:56 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4BB02ugi1426399;
	Tue, 10 Dec 2024 19:02:56 -0500
Date: Tue, 10 Dec 2024 19:02:56 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 00/13] multipathd: More map reload handling, and
 checkerloop work
Message-ID: <Z1jWsMST0iRUH6aG@redhat.com>
References: <20241206233617.382200-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20241206233617.382200-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GD36nwQAZNn-uJBK2ymkOOa6kaR-ZYZqusKj0fu2WVk_1733875378
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 07, 2024 at 12:36:04AM +0100, Martin Wilck wrote:
> This patch set goes on top of Ben's set [1] for github issue 105 [2].
> 
> The first patch implements the remark I had on patch 2 on Ben's set.
> 
> Patch 2-4 add map reload logic for the case when update_pathvec_from_dm()
> detects an inconsistency: in this case, the map is now reloaded before
> the checkers are actually started. If the inconsistency can't be cleared,
> another attempt will be made when the checkers have finished.
> 
> Patch 5 ff. reshuffle the code in checkerloop(). There is now one function,
> checker_finished(), that takes all actions that need to be done with the vecs
> lock taken after the checkers have finished. checkerloop() enters this
> function immediately when the checkers have finished, without dropping and
> re-acquiring the vecs lock. The map reload logic is completely handled in this
> function.
> 
> The various _tick() functions don't loop over mpvec any more; they are now
> just called for a single mpp, and they simply return true if a map reload is
> required.  The actual reload action differs: if missing_uev_wait_tick()
> requests a reload, it needs to be a full update_map() (which calls
> adopt_paths()), whereas in the other cases, reload_and_sync_map() is sufficient.
> The last patch changes the reload action for the ghost delay tick.
> 
> Reviews & comments welcome.

For all the patches I haven't commented on:
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> Regards
> Martin
> 
> [1] https://lore.kernel.org/dm-devel/20241205035638.1218953-1-bmarzins@redhat.com/
> [2] https://github.com/opensvc/multipath-tools/issues/105
> 
> Martin Wilck (13):
>   multipathd: don't reload map in update_mpp_prio()
>   multipathd: remove dm_get_info() call from refresh_multipath()
>   multipathd: allow map removal in do_sync_mpp()
>   multipathd: reload maps in do_sync_mpp() if necessary
>   multipathd: move yielding for waiters to start of checkerloop
>   multipathd: add checker_finished()
>   multipathd: move "tick" calls into checker_finished()
>   multipathd: remove mpvec_garbage_collector()
>   multipathd: don't call reload_and_sync_map() from
>     deferred_failback_tick()
>   multipathd: move retry_count_tick() into existing mpvec loop
>   multipathd: don't call update_map() from missing_uev_wait_tick()
>   multipathd: don't call udpate_map() from ghost_delay_tick()
>   multipathd: only call reload_and_sync_map() when ghost delay expires
> 
>  multipathd/main.c | 295 +++++++++++++++++++---------------------------
>  1 file changed, 120 insertions(+), 175 deletions(-)
> 
> -- 
> 2.47.0

