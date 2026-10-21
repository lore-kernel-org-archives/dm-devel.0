Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792612224;
	b=ECZy/aIF9Vp6T/0495L2RGZiiP4m7T+4q4o39GKfLGVbbYNTdj9FmY30aE/HEHrMcd6Y
	 lgVvV8t5iRlSj6KHeYYkAem4Q7lGGFMHvbN+oB5A+XXhgON7LPVgaoROLHXLGBLbxrM0c
	 NKg5l+yV07fMWQJDtiuSY91cYL285XS3cS3MWJYRhk5c0x4ciN9Mje5Aw2nJkAC7V/tKF
	 ALa6E8wgEkZWDRpNcVF3DbC+zy5zqdbI3y25qCqEUoUNgVp2ZOgVmZ/Hh/2gpcIPEQjtT
	 czJrk0G4Npt2JGtMt1jzC3h+LZmikSPvHarr41fMRvqgB2NZTzaEoYcw7Tqdp/+Gj/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792612224;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition;
	bh=Za2CwP6HmBJYi07I6wd+0q4CR1vBFR1xr45Vd8HGjV4=;
	b=mo22/KkqCy+Mf7Uvr1VFV2sEAVXPyWwQOYa+K27lSoYHyGGwKBsOTorf7aMCj4VTueT/
	 +ZF2uIfY+be87Ogh9RsiUtHE+y0tzdQj1GCaNaNJ90YmVdpyy4n3milCp53VwcSALIaNb
	 gHm1XR+LIILKsMhqMN9crgu9hiqExgfOVB9QnNlfwIouX/5Sdm30wB4ED83ShAHLx8q+s
	 60AyA9YwIAPJiBp0iWt1MFiEDqoimzV8qKmh8j2h6+bq64Xp+yjC0TLWfT1bfzqxiI+3H
	 dLUtHfAEIRZ13rC2sbAgSGR3OXblNp8tVOOSyKTXnQPZus8hg8TaMvQIqRjHciDqMiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=BdPs5q6H;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DF2606A319
	for <dm-devel@lists.linux.dev>; Wed, 21 Oct 2026 19:50:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67DF2606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=BdPs5q6H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792612222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Za2CwP6HmBJYi07I6wd+0q4CR1vBFR1xr45Vd8HGjV4=;
	b=BdPs5q6HeuCUqsXg04FLYwx4U5Y6qGECZ33pduWGb4CHXz1TGoiTz0irnFje2PG/0aYfAi
	7mISnihV0O9scdq++4C7sL1g0PNSndxIoXwzfKT8SDD6G1csng8MEh++beBTvMwzJn+Vse
	+b0cR/jboOa/cSWOJpWOs8xFFtP3KNc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-43-ZNAIrspKMw6z15IwSHAZJw-1; Wed,
 21 Oct 2026 15:50:18 -0400
X-MC-Unique: ZNAIrspKMw6z15IwSHAZJw-1
X-Mimecast-MFC-AGG-ID: ZNAIrspKMw6z15IwSHAZJw_1792612217
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 671F619560A7;
	Wed, 21 Oct 2026 19:50:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 057BA1955F08;
	Wed, 21 Oct 2026 19:50:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 69LJoFPR4126114
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 15:50:15 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 69LJoFZY4126021;
	Wed, 21 Oct 2026 15:50:15 -0400
Date: Wed, 21 Oct 2026 15:50:15 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Brian Bunker <brian@purestorage.com>
Cc: dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v2 1/1] multipathd: don't leave maps read-only after
 write protect is cleared
Message-ID: <atkXd_j6KLmtLmBK@redhat.com>
References: <20261021182759.30106-1-brian@purestorage.com>
 <20261021182759.30106-2-brian@purestorage.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261021182759.30106-2-brian@purestorage.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hsrSUt6ueJmC9wd-fayEsosnOHqxWLJ_liCl6SalgP4_1792612217
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 21, 2026 at 11:27:59AM -0700, Brian Bunker wrote:
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
> when a load succeeds:
> 
> - needs_ro_update() now sets force_readonly whenever it returns true:
>   to 1 for a DISK_RO=1 uevent, to 0 when all of the map's paths are
>   writable, and from the paths' state when the map has no dm info.
>   uev_update_path() no longer sets or clears it itself.
> 
> - ev_add_path() sets it from all of the map's paths rather than only
>   the path being added, and only when it is about to load the map
>   (need_do_map). mpp->paths is up to date there after adopt_paths(),
>   while mpp->pg doesn't contain the new paths yet.

Oops. Good catch.

> 
> - update_map(), which does reloads that were delayed while the map was
>   waiting for udev (UDEV_WAIT_RELOAD), recomputes it from the map's
>   paths before setting up the map.
> 
> - dm_addmap() clears it after a successful load, as it does for
>   need_reload, so it can't outlive the load it was set for.
> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

