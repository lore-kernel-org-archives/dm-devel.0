Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793750596;
	b=w/ZOLzuVKvE3fi/h88Z+cPkkP+oIofGxlDp3PlHBRVUFRcDUziLBEADt9lwpFYbb5ACE
	 NP0n5jwn2i+baIncoXbfYruUBn/l2qP8iWT7tg255sL0lIeniBDxv+bDIpIOfpUFJq/0U
	 xjZVxDV1+0On3Qq5KPxMJVb+ysp+TPVvVxUf/7uxoPBoC+KEdeKQzm99FoVzyrZQ4q2P/
	 mdAI8M9eWsS+cRsvdDFLU44UpTIbjDNR2Q4HkhhgufcEWV/Yqq0IfeD8nOIKcDpmn6q8T
	 NF2pCPz4MynphYkohKt09dfFSdjSYStZODf8nnr4xxDluKTMTgRXZHCOY+rxMPDOQ6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793750596;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition;
	bh=7hI9kS60N6blSOYEBUE2VEvWB0MuuSanCs4+esYbLoc=;
	b=OAwPOPiay3ffAbEaJZZE/Jb5PeAShxMf9L/LJqMSQH5zjrmnWD5F6v/G5aciMUG7Nxdb
	 eKCE65NMOBAPth1YuTghbX+d6qAxlvZxP8aUTm+9tkxhhaCoSfSDq0Svcr8P3QZVd39a6
	 7GwgDI/aoe0kSPhbhkrLwCdQPD72DGL9nNwgqtiYT//52h1HwcBV+Wd2tx300QlfK+EB7
	 JRJU+X+KiFjpezTUJsJ0ctxj23OyJb9i+ptukSfPixX0cUWmumBg+DAsOQmJhKFAXmsaf
	 yyJq4wiYAY1RC2+ZPRAGmXZ5cOTkd4ckywxAK/Jc1dmEbZYMMYKlZ7c3ecwePMnvwVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MRm7n5OK;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3AF606A324
	for <dm-devel@lists.linux.dev>; Wed,  4 Nov 2026 00:03:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B3AF606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MRm7n5OK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793750595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7hI9kS60N6blSOYEBUE2VEvWB0MuuSanCs4+esYbLoc=;
	b=MRm7n5OKa4EJQUiazlqruP7MWTAth8J2mxMlJ9MNyIAXMEEa7tZlf0hyeBqZIZY3jM11M+
	onzINdFTT7EUwkckmkspxhk4yEifqONHDILTAd8vLtjO+AX3udwnA5Afb5gcT+XtxHvay7
	VQ76fX/3k0K2baSxQCA5fxIgPYNBqmU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-672-m_G5lG8TNP2iP_H9o05Oqw-1; Tue,
 03 Nov 2026 19:03:13 -0500
X-MC-Unique: m_G5lG8TNP2iP_H9o05Oqw-1
X-Mimecast-MFC-AGG-ID: m_G5lG8TNP2iP_H9o05Oqw_1793750592
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 849241956059;
	Wed,  4 Nov 2026 00:03:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 279E1195608C;
	Wed,  4 Nov 2026 00:03:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6A403AYk2664972
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 3 Nov 2026 19:03:11 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6A403AMe2664971;
	Tue, 3 Nov 2026 19:03:10 -0500
Date: Tue, 3 Nov 2026 19:03:10 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Brian Bunker <brian@purestorage.com>
Cc: dm-devel@lists.linux.dev, mwilck@suse.com, christophe.varoqui@opensvc.com
Subject: Re: [PATCH v6 1/1] multipathd: don't leave maps read-only after
 write protect is cleared
Message-ID: <aup2Pud9F51mim97@redhat.com>
References: <20261103003150.78513-1-brian@purestorage.com>
 <20261103003150.78513-2-brian@purestorage.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261103003150.78513-2-brian@purestorage.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pISt5aT98Iqhw9Sw18lqHDEnQZ8PcCQPrQIvHEtrIKE_1793750592
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 02, 2026 at 04:31:50PM -0800, Brian Bunker wrote:
> ev_add_path() sets mpp->force_readonly when a newly added path is
> read-only, but never clears it. If a map is created or reloaded while
> its storage is write protected, the flag stays set. When write protect
> is cleared, the reload that uev_update_path() does for the DISK_RO=0
> uevent uses the stale flag and loads the map read-only, even though all
> of its paths are read-write. uev_update_path() clears the flag after
> that reload, so the map only recovers if another DISK_RO=0 uevent
> reloads it again. If none comes, the map stays read-only, and since
> mpp->dmi.read_only is then 1, needs_ro_update() also ignores later
> DISK_RO=1 uevents for it.
> 
> Fix this by setting force_readonly before each load and clearing it
> once the load has succeeded:
> 
> - uev_update_path() no longer takes the path's ro state from the
>   uevent's DISK_RO. The uevent only says that something changed. The
>   kernel updates the ro attribute before it sends the uevent, so sysfs
>   is current when the uevent is handled, while the uevent itself may
>   have been queued behind later changes. It just calls
>   needs_ro_update(), which reads the ro state of all of the map's paths
>   from sysfs.
> 
> - needs_ro_update() no longer takes an ro value. It sets
>   force_readonly from the ro state of the map's paths, and returns true
>   if that differs from the map's current state. If the map is already
>   read-only and has to stay so, it clears the flag and returns false,
>   since dm has to reopen the paths for any read-write reload anyway. If
>   the map has no dm info, it fetches it, and returns false if that
>   fails, instead of assuming a reload is needed. Since the flag is
>   recomputed on every call, a failed read-only reload is retried on the
>   next uevent without any special handling.
> 
> - ev_add_path() sets it from all of the map's paths rather than only
>   the path being added, and only when it is about to load the map
>   (need_do_map). mpp->paths is up to date there after adopt_paths(),
>   while mpp->pg doesn't contain the new paths yet.
> 
> - update_map(), which does reloads that were delayed while the map was
>   waiting for udev (UDEV_WAIT_RELOAD), recomputes it from the map's
>   paths before setting up the map.
> 
> - dm_addmap_create() clears it as soon as it has read it. A failed
>   create leaves no map behind, and the next create computes the flag
>   again.
> 
> - dm_addmap_reload() clears it once the reload and resume have
>   succeeded. If the reload fails, the map keeps its old table, and the
>   flag stays set so that the next reload tries again.
> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>
Thanks for dealing with all the revisions

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

