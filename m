Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E818886337
	for <dm-devel@lists.linux.dev>; Thu, 19 Dec 2024 22:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734647594; cv=none; b=tOTjpG6KcgKZDxnnQyA8jzWdeR8IQP8EAbQnmBDBnRRi0BxBdt8o4DkRa7Fa5MDrMhd8izchNZKVlwGBQ0g+Tp/ObQoFfObWS1Q+OZgYxva+HqoHrMAwURtxzKM/+KxZJcLLnYUPUcU97CRzSwftZrGyoeTr/5V4dXsGUA1EW/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734647594; c=relaxed/simple;
	bh=cEY1EGnVOwPlr9Y2p+bpsMLOzxJ/JLwpXTZdx3ZXI/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=NRqZNrbQFwswWG/+r8MLiQBF3VYO5rGPjIPddWaPrAISdSwtQcM771+jleJwxciGYbBLzbgWutweMLbWjE69d+drjl8YmF4KCx0hkqxNgvWK2lCuX180lBodlhpC7/AtiMq38r6itEbSWWtHBgPGEJa8ZyJvjmW0MMXhKeXdh4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ONxmyE+y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ONxmyE+y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734647591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=smZB4f73ub+QCUGn+Vllh8XR/yP9LLDcF4kqSCPPeXs=;
	b=ONxmyE+y8HDpLxrcvwISBcwEAFkiooDU3tp8AOrCeBbyqKe7U+u8i3VdIK4hix8IHapZyD
	6hJGI+u6oktqyYHXcZr6WTTsTOYDSo+pYETKgwX1XhLqIKTDevrXYntlEGaZzY0BD+B14L
	8/Vsnsx5ST33O2lpU8aJpn9z9fuXr6I=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-400-AyharxRpPYGKYMsdWDPfzQ-1; Thu,
 19 Dec 2024 17:33:08 -0500
X-MC-Unique: AyharxRpPYGKYMsdWDPfzQ-1
X-Mimecast-MFC-AGG-ID: AyharxRpPYGKYMsdWDPfzQ
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9DD5F19560A3;
	Thu, 19 Dec 2024 22:33:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 55153300F9B5;
	Thu, 19 Dec 2024 22:33:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4BJMX5N81754158
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 19 Dec 2024 17:33:05 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4BJMX5F61754157;
	Thu, 19 Dec 2024 17:33:05 -0500
Date: Thu, 19 Dec 2024 17:33:05 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 00/14] multipathd: More map reload handling, and
 checkerloop work
Message-ID: <Z2SfIQprcmBc6G2S@redhat.com>
References: <20241211225909.298770-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20241211225909.298770-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: znVdJyM1hFQD28AyFjd-DMeYpuS8IYoMQcRMSyieZB4_1734647587
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 11, 2024 at 11:58:55PM +0100, Martin Wilck wrote:

For all the patches except 3, 4, and 8:
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>


> This patch set goes on top of Ben's set [1] for github issue 105 [2].
> 
> The first patch implements the remark I had on patch 2 on Ben's set, the 2nd
> is a minor cleanup.
> 
> Patch 3 moves the sync_mpp() call from the beginning to the end of the
> checkerloop, as suggested by Ben in [3]. If an inconsitency is found
> (mpp->need_reload), we reload the map and schedule another sync for the
> next tick (patch 4).
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
> Patch 12 changes the reload action for the ghost delay tick.
> 
> Patch 13 removes maps if that are not found in the kernel any more. This
> obsoletes the map garbage collector. Unlike the logic in v1, we won't remove
> maps on arbitrary error conditions any more.
> 
> Changes v1 -> v2:
> 
> Removed patch 3 and 4 of v1 and replaced them by an alternative approach.
> Instead of allowing map and path removal in the checker loop, the kernel sync
> is moved towards the end.
> 
> Patch 5 ff. in v1 contained a bug in the new checker_finished() function.
> If one "tick" function returned true, the other might not be executed any
> more. In v2, all tick functions are executed, and the action to be taken is
> selected according to the combined results.  Also, we won't call
> reload_and_sync_map() when we've already called update_map().
> 
> Patch 13 is new in v2. Patch 8 from v1 has been moved after patch 13.
> 
> (In the thread following the review of v1, I mistakenly wrote about an
> upcoming "v4" of this patch set. That was wrong, I meant this v2 here).
> 
> Reviews & comments welcome.
> 
> Regards
> Martin
> 
> [1] https://lore.kernel.org/dm-devel/20241205035638.1218953-1-bmarzins@redhat.com/
> [2] https://github.com/opensvc/multipath-tools/issues/105
> [3] https://lore.kernel.org/dm-devel/Z1iUekRg8sai8HLT@redhat.com/
> 
> 
> Martin Wilck (14):
>   multipathd: don't reload map in update_mpp_prio()
>   multipathd: remove dm_get_info() call from refresh_multipath()
>   multipathd: sync maps at end of checkerloop
>   multipathd: quickly re-sync if a map is inconsistent
>   multipathd: move yielding for waiters to start of checkerloop
>   multipathd: add checker_finished()
>   multipathd: move "tick" calls into checker_finished()
>   multipathd: don't call reload_and_sync_map() from
>     deferred_failback_tick()
>   multipathd: move retry_count_tick() into existing mpvec loop
>   multipathd: don't call update_map() from missing_uev_wait_tick()
>   multipathd: don't call udpate_map() from ghost_delay_tick()
>   multipathd: only call reload_and_sync_map() when ghost delay expires
>   multipathd: remove non-existent maps in checkerloop
>   multipathd: remove mpvec_garbage_collector()
> 
>  libmultipath/structs.h     |   2 +-
>  libmultipath/structs_vec.c |   1 -
>  multipathd/main.c          | 287 +++++++++++++++----------------------
>  3 files changed, 118 insertions(+), 172 deletions(-)
> 
> -- 
> 2.47.0

