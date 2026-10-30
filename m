Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793383790;
	b=HqaTbvI7L0OuTRhYBryqF+jEXNPja9hoVbrHM56kNFxlmEgSluo2ctk8MSwNcktPBMm0
	 IzvBpGdHTg3B8L6SZM131KX3ve44KeT6/9J44k/mKD1xdwD4O1Ns7DovBMMyK+cqYHaVn
	 n+iDhclw52iS6NzyBEV/8sEg7PoXnxLdQklT0IVzWBqG5UXnL5MLzbE4eQ4iMGKsISgEq
	 AktEgGla0eilG3HQTYX4CUEKzaOZRTPmjF0p28gTSDw4GVZkMn+j83aupZ/Oh58vf6WWj
	 DYB71wzjOPFSKFiG6K2V7B6fVONl1WbGMeuErHvmh0awjXrju71hvZOhNdX2THfPiMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793383790;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition;
	bh=90vf4Kp39kQ2P0Sr+0nPQSmTBZL1CFq99QDyMZxR5Gc=;
	b=kWJ7se+rR3ZSo7p2f35MNBG4HAtHCyF4XZT4cN7jIP1HG0BCaArzqOMGT2b/U7SYpDRi
	 wKif2kWP0JwVNh1lUEr38D6cnOWaxaEKy1dG+/UEvnzUS9ZRavK/YgCKQ6t2vylxkQgDX
	 DAp//BKDN3TiN3WAlQN5FwS4OmJYL5O27X9k1cYMBc/IH5FbL6Xtv6hl3O/n+RMJJfP6r
	 ymNj455DzsIIYsM5wV7wv3aRsjZrXS0nra0AGL9BWseQd/TuGdkotOF2MAwQL+BFKEPy4
	 g6dPdK3PkYGbB8sHR6m6Z5jVr3SCiIT6D3cZjXKmUFP7J7WSBjqn7AsIdS0ejXnNmkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=EHRSOnn0;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25EF606A338
	for <dm-devel@lists.linux.dev>; Fri, 30 Oct 2026 18:09:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B25EF606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=EHRSOnn0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793383788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=90vf4Kp39kQ2P0Sr+0nPQSmTBZL1CFq99QDyMZxR5Gc=;
	b=EHRSOnn0AhynJQOf2RW6P+XHs9yEO5k2Jz0TFwHCA+RvR+sG8b3ZpSDUhHcKLmEm7X35j9
	M5NiWt4dFw0DIBsZVqnxODg6Es2KzbeeBDABXfFrHgbu4M/TgMYPtdv0Tu8YcS+crLgQlr
	k/E/TsONBH8SGAfYhyB0dG403ciCzSU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-WF2_hqVIPrifnSWSes9lCQ-1; Fri,
 30 Oct 2026 14:09:45 -0400
X-MC-Unique: WF2_hqVIPrifnSWSes9lCQ-1
X-Mimecast-MFC-AGG-ID: WF2_hqVIPrifnSWSes9lCQ_1793383784
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0F6EE1954AD3;
	Fri, 30 Oct 2026 18:09:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C56B618005B7;
	Fri, 30 Oct 2026 18:09:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 69UI9g8i1098789
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 30 Oct 2026 14:09:42 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 69UI9gpT1098788;
	Fri, 30 Oct 2026 14:09:42 -0400
Date: Fri, 30 Oct 2026 14:09:42 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Brian Bunker <brian@purestorage.com>
Cc: dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v2 1/1] multipathd: verify udev WWIDs with the device
 before moving paths
Message-ID: <auTdZn84HV8DjGZ0@redhat.com>
References: <20261029235241.97614-1-brian@purestorage.com>
 <20261029235241.97614-2-brian@purestorage.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261029235241.97614-2-brian@purestorage.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HIZpD2OXdhrbL0u_kicV0CT2WCqUB9-I4xtlBHZU_2o_1793383784
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 29, 2026 at 04:52:41PM -0700, Brian Bunker wrote:
> multipathd takes a path's WWID from udev. When a change uevent reports
> a different WWID, uev_update_path() removes the path from its map and
> re-adds it through uev_add_path(), which places it in whatever map owns
> the new WWID. Nothing checks the new value against the device itself;
> recheck_wwid only covers paths coming back up in the checker and
> "multipathd add path". If udev reports the wrong WWID, or the uevent is
> stale by the time it is processed, the path goes into the map of a
> different LUN and I/O for one LUN is silently sent to another.
> 
> Use SG_IO to read VPD page 0x83 from the device in two places, for
> paths where can_recheck_wwid() is true:
> 
> - In uev_update_path(), if the device still reports the cached WWID,
>   ignore the udev value and leave the path where it is.
> 
> - In ev_add_path(), when a path is being re-added because its udev
>   data was missing or changed, refuse to add it if the device doesn't
>   confirm its WWID. The path is orphaned, its WWID is cleared and it
>   is marked INIT_MISSING_UDEV, so the checker retriggers udev (bounded
>   by retrigger_tries) and the path is re-added from fresh data.
> 
> To tell re-adds from ordinary adds, turn the need_do_map argument of
> uev_add_path() and ev_add_path() into enum path_add_mode, with a new
> PATH_ADD_REINIT value that behaves like PATH_ADD_MAP and also requests
> the WWID check. Ordinary adds are unchanged and never read the WWID
> from the device.
> 
> If the SG_IO read fails, behavior is unchanged.
> 
> Split the SG_IO read out of check_path_wwid_change() into
> get_sgio_wwid() so all the checks share it.
> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

