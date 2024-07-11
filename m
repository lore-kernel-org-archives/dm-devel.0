Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1625B12F386
	for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 06:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720680972; cv=none; b=gU5SiHuburBcxn+2vR/HR370hgHO5A9ieCNg69djEvLmRv5fLU+0q2lqEk8jVjQGq8uWHzbBRRFgPl2TLumgY8HPZ86tFfy0M0gyVahuisbl+HP7HDXnQaW26xAxigvM1eQL8fF7QygycPVxzZe7MFdXBlXPZO19fYvuYCY/WLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720680972; c=relaxed/simple;
	bh=33UQvO88SWlTEwz946I6C2kBCPwopmYpJ41tABa9aoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=G6FIQKXapVRkyXQ8HkNDoeoIZPmskQrAy/k1Kmeh86GLgsesNZEQaAx5AQNh8S0E61ic7ULoNdZ3lZba8SezRYrGq/nBwHpX1VJI1qAuzvBOVMo1S0MUtSoGauwkx1BNKtGFQOClHPsAWcL5VotCIBFgW0PYSSIkXold+1Acr3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Syhr20AJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Syhr20AJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720680965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cr8/E2A27rq00dTZIAxvurp3gWbpDFE18V9XcmCIGAk=;
	b=Syhr20AJdwg1PSnk9GlMgikPB0y4xNsodCdj0z34KPDx7Frs9Qd/yTRpzqIyOgENqYZMQ3
	VZx5PEIdx2ttAQ2znqPJ56V56MEs5Ovv/lW94iyfw3glzex2pV3CfOo2HcuddZVApE1gEU
	aLBtRiuSibLSVF0S4vnEieUF2XVJ0gw=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-462-1PiKSXC_Oxik7wUXQz-o_w-1; Thu,
 11 Jul 2024 02:56:02 -0400
X-MC-Unique: 1PiKSXC_Oxik7wUXQz-o_w-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 10F6A1955F45;
	Thu, 11 Jul 2024 06:56:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8614D1955E70;
	Thu, 11 Jul 2024 06:56:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46B6txID1933500
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 02:55:59 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46B6twXF1933499;
	Thu, 11 Jul 2024 02:55:58 -0400
Date: Thu, 11 Jul 2024 02:55:58 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 00/44] multipath-tools: devmapper API refactored
Message-ID: <Zo-B_oibYgaoAzyh@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240709213935.177028-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2024 at 11:38:51PM +0200, Martin Wilck wrote:

For all the patches that I didn't reply to:
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Patch 1-9 are generic cleanups, partly targeting the previously reported
> issues with multipath-tools installation on NixOS by removing hard-coded
> paths as much as possible.
> 
> Patch 10-16 are basic cleanups for the devmapper code.
> 
> Patch 17 is the heart of this patch set, introducing the function
> libmp_mapinfo(), which is supposed to serve as general API for fetching
> information about maps from libdevmapper. It can work with arbitrary
> input for identifying a map, and produce any combination of desired
> outputs, with the most lightweight (combination of) ioctls possible.
> This part of the set removes some code that had been changed
> in patch 10-16. This is sort of suboptimal, but IMO it improves
> the readability of the set as  a whole.
> 
> Patch 18 adds unit tests for this function.
> 
> Patch 19-44 change the libmultipath code to use the new API everywhere,
> and add some additional minor improvements and fixes.
> 
> The code is pushed to https://github.com/openSUSE/multipath-tools/tree/tip.
> 
> Comments and reviews welcome.
> 
> Martin Wilck (44):
>   multipath-tools CI: more fixes for arm/v7
>   multipath-tools CI: fix dmevents test for Debian Sid, arm/v7
>   create-config.mk: use printf instead of /bin/echo
>   multipathd.service.in: use @BINDIR@ instead of /sbin
>   Makefile.inc: replace @BINDIR@ with $(TGTDIR)/$(bindir)
>   kpartx.rules: use @BINDIR@ to locate kpartx
>   multipath-tools: Remove hard-coded paths to executables
>   multipath-tools: compile_commands.json fixes
>   multipath-tools: .gitignore: ignore o.wrap files for CI helpers
>   libmultipath: remove unused includes in devmapper.h
>   libmultipath: use DM_DEVICE_INFO in dm_mapname()
>   multipath-tools: don't call dm_task_no_open_count()
>   libmpathutil: export cleanup_udev_device()
>   libmpathutil: add cleanup_vector()
>   libmultipath: add cleanup helpers for struct multipath
>   libmultipath: add cleanup_dm_task(), and use it in devmapper.c
>   libmultipath: add libmp_mapinfo()
>   libmultipath tests: add tests for libmp_mapinfo()
>   libmultipath: implement dm_get_info() and dm_map_present() with new
>     API
>   libmultipath: remove dm_get_prefixed_uuid()
>   libmultipath: is_mpath_part(): improve parsing
>   libmultipath: rename dm_get_uuid() -> dm_get_wwid()
>   libmultipath: improve dm_get_wwid() return value logic
>   libmultipath: reimplement dm_map_name() with new API
>   libmultipath: reimplement dm_map_present_by_uuid()
>   libmultipath: reimplement dm_get_opencount() with new API
>   libmpathpersist: skip redundant dm_map_present() call
>   libmultipath: implement dm_is_mpath() with new API
>   libmultipath: implement dm_get_multipath() with new API
>   libmultipath: use libmp_mapinfo() in _dm_flush_map()
>   libmultipath: add is_mpath_uuid() helper
>   libmultipath: add is_mpath_part_uuid() helper
>   libmultipath: add dmp_errstr() helper
>   libmultipath: use libmp_mapinfo() in do_foreach_partmaps()
>   libmultipath: use libmp_pathinfo() in update_multipath_table()
>   libmultipath: update mpp->dmi in update_multipath_table()
>   libmultipath: drop extra call to dm_map_present() in domap()
>   libmultipath: split off update_multipath_table__()
>   multipath: implement check_usable_paths() with libmp_pathinfo()
>   multipathd: implement add_map_without_path() with libmp_mapinfo()
>   libmultipath: simplify dm_get_maps()
>   llibmultipath: fix return code check for dm_is_suspended()
>   libmpathpersist: use libmp_mapinfo() in get_mpvec()
>   libmpathpersist: use mpp->alias in do_mpath_persistent_reserve_out()
> 
>  .gitignore                               |    4 +
>  Makefile                                 |    4 +-
>  Makefile.inc                             |   29 +-
>  create-config.mk                         |    4 +-
>  kpartx/Makefile                          |    4 +-
>  kpartx/devmapper.c                       |   15 -
>  kpartx/{kpartx.rules => kpartx.rules.in} |    2 +-
>  kpartx/kpartx_id                         |    8 +-
>  libmpathpersist/mpath_persist_int.c      |   85 +-
>  libmpathutil/libmpathutil.version        |    5 +
>  libmpathutil/util.c                      |    6 +
>  libmpathutil/util.h                      |    3 +
>  libmpathutil/vector.c                    |    6 +
>  libmpathutil/vector.h                    |    1 +
>  libmultipath/alias.c                     |    5 +-
>  libmultipath/configure.c                 |   27 +-
>  libmultipath/devmapper.c                 | 1020 ++++++++------------
>  libmultipath/devmapper.h                 |  101 +-
>  libmultipath/libmultipath.version        |   10 +-
>  libmultipath/print.c                     |    6 -
>  libmultipath/structs.c                   |   12 +
>  libmultipath/structs.h                   |    2 +
>  libmultipath/structs_vec.c               |   50 +-
>  libmultipath/structs_vec.h               |    2 +
>  libmultipath/valid.c                     |    2 +-
>  libmultipath/wwids.c                     |    2 +-
>  multipath/11-dm-mpath.rules.in           |    4 +-
>  multipath/main.c                         |   60 +-
>  multipath/multipath.rules.in             |    6 +-
>  multipathd/dmevents.c                    |    6 +-
>  multipathd/main.c                        |   71 +-
>  multipathd/multipathd.service.in         |    4 +-
>  multipathd/waiter.c                      |    2 -
>  tests/Makefile                           |    5 +-
>  tests/alias.c                            |   32 +-
>  tests/dmevents.c                         |   34 +-
>  tests/mapinfo.c                          | 1121 ++++++++++++++++++++++
>  tests/valid.c                            |   10 +-
>  tests/wrap64.h                           |    9 +-
>  39 files changed, 1916 insertions(+), 863 deletions(-)
>  rename kpartx/{kpartx.rules => kpartx.rules.in} (96%)
>  create mode 100644 tests/mapinfo.c
> 
> -- 
> 2.45.2

