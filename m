Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA25A2FB0B3
	for <dm-devel@lists.linux.dev>; Tue, 13 Jan 2026 20:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768337809; cv=none; b=AINxP5wXScrxQLAp3tNYzlh3dOPKGjtuAMHRhteMeekyVB2TIbNL+fjCXdK5C0WdgnpIqNt1NshSSFtEmy9QgssckgBk62fnoqKLjM759v3ifihL7asRrZ6OmuhO9I/FBmAOMXsXHC18GndGgCQ0zjzxiL0bUOPazSQnFKoRV8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768337809; c=relaxed/simple;
	bh=V8h6UZgnim+7f+g5QSpKEbZrs4Btx1Cr1341cXskVkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=kNRuC7Q/Ua8TBYzZhV8xBpnU3x+LZHRD38nLoKN3qLWKh8FBUIqdT9W8N+ZIM2hwB5kf7yWS1UK44M+CdNxiX+Choy1n/n6vCMlD/suFHydQehI922WV21MSDuTL54Bl++TcD50KXqjFOc0sP6V5XV0cQP2ZzxPikOIHpNzwgf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fQzNZ51T; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fQzNZ51T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768337806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pWzBiBUP/iRy4a1krobDb24CcVEQNe9zusviagmjDQc=;
	b=fQzNZ51Ta2CjKjANi6+QwnjvkyeSiCVUTu+oRIZlzBD/uzdMLrw/ey+pcoy2MTlN4hcgXX
	jvY/1o5GVznvNY4NrloZ4z00hQMWOWqhy2jgKk5sghrWggT9X/bl960mcW1xoRkGwyGwt1
	/m+TWdMCqlKTvxhPaJ/bbnFocInWsUw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-540-Te5iGk02PTuC4fZCHgGZRw-1; Tue,
 13 Jan 2026 15:56:44 -0500
X-MC-Unique: Te5iGk02PTuC4fZCHgGZRw-1
X-Mimecast-MFC-AGG-ID: Te5iGk02PTuC4fZCHgGZRw_1768337804
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C4CC4180047F;
	Tue, 13 Jan 2026 20:56:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 639D718001D5;
	Tue, 13 Jan 2026 20:56:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 60DKugC13277309
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 13 Jan 2026 15:56:42 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 60DKufxP3277308;
	Tue, 13 Jan 2026 15:56:41 -0500
Date: Tue, 13 Jan 2026 15:56:41 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: dm-devel@lists.linux.dev,
        Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/9] multipath-tools: more small fixes
Message-ID: <aWaxif6-mcbwq88d@redhat.com>
References: <20260109183907.201250-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260109183907.201250-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hhFJsJN24SKgMyIbRyJbNfyeJnybfBvooPGb5ZFvGUU_1768337804
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 09, 2026 at 07:38:58PM +0100, Martin Wilck wrote:
> 1 and 2 are minor cleanups. 
> 
> Patch 3-5 are follow-ups of the structure-freeing cleanup of my
> previous patch series "Multipath-tools: various bug fixes".
> The previous series tried to make sure that no freed "struct multipath"
> objects are ever referenced by any "struct path" objects. To achieve
> that, it nullified pp->mpp links from all paths in a struct multipath
> when the latter was discarded in free_multipath(). This is only safe
> if we make sure that the path referenced by a struct multipath (either
> via mpp->paths or mpp->pg[i]->paths for some i), aren't freed before
> the struct multipath itself. Ideally, the orphaning in free_multipath()
> wouldn't need to happen if we'd make sure that pp->mpp is set *if and
> only if* pp was referenced by mpp as explained above. I think we do
> a decent job at that, but it's hard to tell with 100% confidence.
> 
> In order to improve confidence, patch 4 and 5 add some logging. It's now an
> error if a path which is freed still links to a multipath map. Patch 3/5
> eliminates a few cases where this could still happen, even though the path was
> not member of the map. Patch 5 is mainly meant to debug cases pp->mpp was
> either NULL or pointing to a different map. This shouldn't happen and I
> haven't observed it in my testing so far.
> 
> Patch 6 avoids a strange behavior that multipathd has had forever - after
> grouping paths, mpp->paths was freed. In most of our code, we assume that
> mpp->paths and mpp->pg should reference the same set of path devices, and
> we have update_mpp_paths() and sync_paths() to take care of it. But right
> after path grouping, this is not the case. Subsequent invocations of
> update_mpp_path() (usually via refresh_multipath()) will re-allocate and
> fill the paths vector. This causes a lot of unnecessary heap operations.
> 
> Patch 7 and 8 are unrelated bug fixes which I came across lately.
> 
> Patch 9 is motivated by the recent patch "libmpathutil: use union for bitfield".
> I did some further experiments with strict aliasing and found that the
> multipath-tools code base just should not use it at all. Like the kernel,
> we use between low-level data structures that don't comply with strict
> aliasing rules. So like the kernel, we should disable strict aliasing.
> That basically obsoletes "libmpathutil: use union for bitfield", but having
> it doesn't hurt, either.
> 
> Interestingly, switching to -fno-strict-aliasing seems to have fixed [1],
> which I'd unsuccessfully tried to fix with various methods before.

For the set:
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> [1] https://github.com/opensvc/multipath-tools/issues/130
> 
> Martin Wilck (9):
>   libmultipath: reset pgindex in uninitialize_path()
>   libmultipath: clarify code in set_path_removed()
>   libmultipath: nullify pp->mpp before calling free_path()
>   libmultipath: log error when freeing path that refers to a map
>   libmultipath: sync_paths(): print message when fixing pp->mpp
>   libmultipath: don't free mpp->paths in group_paths()
>   libmultipath: warn only once in scsi_tmo_error_msg()
>   libmultipath: find_hwe(): fix gcc errors at high optimization levels
>   multipath-tools: compile with -fno-strict-aliasing
> 
>  Makefile.inc               |  2 +-
>  libmultipath/config.c      | 13 ++++++++++---
>  libmultipath/discovery.c   |  3 +++
>  libmultipath/pgpolicies.c  |  2 --
>  libmultipath/structs.c     |  4 ++++
>  libmultipath/structs_vec.c | 26 +++++++++++++++++---------
>  tests/pgpolicy.c           |  7 +++++--
>  7 files changed, 40 insertions(+), 17 deletions(-)
> 
> -- 
> 2.52.0

