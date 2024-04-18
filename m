Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B33A168B17
	for <dm-devel@lists.linux.dev>; Thu, 18 Apr 2024 18:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713465634; cv=none; b=kXYbJ28hIlAsy4cXi7ngMSRnh+HwaGxfpAUzdUj+0y6orMGBiSnML2PDZvcDs2frZDWHnSBA5RMi+dkcWAR1mSR3skVSYHrfaSuZf/yL2JgdvDu3vQFPMxt9Pcq/NBA+WWDagE/l9yrwNuBqT7uAnyY2mblCmI/BzKyLIJtPdkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713465634; c=relaxed/simple;
	bh=m6hvPgHdjwKocsCVHw/K+Yiqpq6HLC/GO43Vn7vjDuA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Dlkbi4ofIUGnIPYnv/Y1VWnstfPPKjPY72YJvgh7puc8G58ZZy1H/V4mBt44/SLZizpSd7YeGeKkjbtCpPO6rPd2eyqtp9lNY/Eqx4bIR6KifTn8yZ3iJ5o78m0JdLsf419RTAXScKX/T3U6Vt0hKFBeqsP1zySglWVDwxe76LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=igBx3PX7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="igBx3PX7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713465631;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=14nGL1nO4xYesuEVqnqe9xLSjQWXg61LUnm3vvolK2g=;
	b=igBx3PX7f8ZOyogHkUzmNoUIxNhInzolDih/BsmN+6DjdWO0/wOWSK1LTa3GwRRbwnFQ4k
	LY+JUI3QHZOqK8D+a9zSJAYKLw8BLyVCPsMR3rxysvEVeSsFtjiXucbvf2jWsZoq51eMf1
	a3LRROuNNVuVWaOugfcE0LrcT0ojqmQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-187-V-yqfijXOmick0DZVupbBw-1; Thu,
 18 Apr 2024 14:40:30 -0400
X-MC-Unique: V-yqfijXOmick0DZVupbBw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACF433C10174;
	Thu, 18 Apr 2024 18:40:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A24E1121312;
	Thu, 18 Apr 2024 18:40:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 43IIeTaG2028066
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 18 Apr 2024 14:40:29 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 43IIeSXk2028065;
	Thu, 18 Apr 2024 14:40:28 -0400
Date: Thu, 18 Apr 2024 14:40:28 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Etienne AUJAMES <eaujames@ddn.com>
Subject: Re: [PATCH 0/8] multipath-tools: max_sectors_kb rework
Message-ID: <ZiFpHC6oAEoCqwae@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240417184644.6193-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240417184644.6193-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 17, 2024 at 08:46:36PM +0200, Martin Wilck wrote:
> This patch series addresses the issue described in [1].

For the Set:
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>


> Changing max_sectors_kb on a live multipath map is dangerous. In particular,
> no path device may have a lower value than the map at any time, unless the
> device is suspended and all I/O has been flushed. It is also dangerous to
> read a max_sectors_kb value from sysfs and write it back, because this may
> actually cause the max_sectors value in the kernel (which is in 512 byte block
> units, not in kiB) to be rounded down to the next even number.
> 
> This patch set avoids both these problematic techniques. max_sectors_kb is
> only changed for maps that have the respective configuration parameter set,
> and only during map creation or during path addition. In the latter case,
> the limit is set on the new path before actually adding it to the map, thus
> avoiding a change on a live path. While it is generally recommended to set
> max_sectors_kb once and for all before creating a map, the latter technique
> can be used to change the value on a live map, by removing and re-adding
> a path device.
> 
> A side effect of this patch set is that not necessarily all path devices of
> a map that has max_sectors_kb set will have this limit configured. In
> particular, if max_sectors_kb is enforced by adding a path device, only the
> added path and the map itself will have the new max_sectors_kb value, because
> multipathd will not attempt to change the value of the other paths, which
> can therefore be higher than the configured limit. This is not a problem.
> Errors arise only if the limit of the map device is higher than that of
> any path device.
> 
> This patch set does not attempt to address issues between a multipath device
> and block layers stacked on to of it (e.g. LVM or MD raid), as discussed in
> the commit message of 8fd4868 ("libmultipath: don't set max_sectors_kb on
> reloads"). I think, and my experiments have confirmed it, that for bio-based
> stacked devices on top of multipath, max_sectors_kb is not a problem. bios
> with a large amount of I/O are split in the kernel to fit into the lower-level
> device's limits. Only request-based dm aka multipath is susceptible to errors
> caused by max_sectors_kb mismatch. If I am overlooking something here, please
> provide an example to prove me wrong.
> 
> https://lore.kernel.org/dm-devel/7742003e19b5a49398067dc0c59dfa8ddeffc3d7.camel@suse.com/

I reran the bug reproducer for original issue that inspired 8fd4868,
after manually increasing max_sectors_kb of the device on top of
multipathd, and it works fine on recent kernels.
 
> Martin Wilck (8):
>   multipath-tools: add TGTDIR option
>   libmultipath: move get_udev_for_mpp to sysfs.c
>   libmultipath: add mp_find_path_by_devt()
>   Revert "libmultipath: fix max_sectors_kb on adding path"
>   libmultipath: Only set max_sectors_kb on map creation
>   libmultipath: set max_sectors_kb in adopt_paths()
>   libmultipath: add wildcard %k for printing max_sectors_kb
>   multipath.conf(5): update documentation for max_sectors_kb
> 
>  .github/actions/spelling/expect.txt |  2 +
>  Makefile.inc                        |  8 ++--
>  README.md                           | 33 +++++++++++++++
>  libmultipath/configure.c            | 63 +++--------------------------
>  libmultipath/print.c                | 38 +++++++++++++++++
>  libmultipath/structs.c              | 19 +++++++++
>  libmultipath/structs.h              |  3 ++
>  libmultipath/structs_vec.c          | 62 +++++++++++++++++++++++++---
>  libmultipath/structs_vec.h          |  6 ++-
>  libmultipath/sysfs.c                | 19 +++++++++
>  libmultipath/sysfs.h                |  4 ++
>  multipath/multipath.conf.5.in       | 33 +++++++++++++--
>  multipathd/main.c                   |  6 +--
>  tests/Makefile                      |  2 +-
>  tests/test-lib.c                    |  9 ++++-
>  15 files changed, 229 insertions(+), 78 deletions(-)
> 
> -- 
> 2.44.0

