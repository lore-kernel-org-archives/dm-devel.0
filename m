Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C10C13635C
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 00:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766104833; cv=none; b=lYKRaU3Ab1r8C3brn3p8lvtSRD9P4iD4RsX4XPB9aHFsmgtLhcZV0mwstQZll4TKgEXoTSqyYnHJJhOMSUcy6KL4U0WalbQQ/Ibe6yT/X37mqsG3Ax+8HsY3yaLEc+p9b0+Z+MwyQb1oWvw525b9igErsf1D22kzvZ3OOr33IVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766104833; c=relaxed/simple;
	bh=Tnz5vCogLTGIwDMieqOZJfhj4cWQ0uVWajmz4ylc6iM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=SnrSwG2ZQ8XLdIb4DYzwsargwjwXC+bFmpuFZMCJyjCE9hyG5NrWqV/c6wiVHj/io7mbC4lICwvNAzUL1T4T/fxGCUOFuTcl0ZG+qlZMIGqlqvCpi9TsdKVoKhKHCY/VQ9pn+vmSjOfxE1i30YwQRNfh/8xTOfbZTMZAPB24M+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OCSeSYFK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OCSeSYFK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766104830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L1sXiWHRvnklt1lUtlmxzJVYC7536tZyAW8JHL+/NxI=;
	b=OCSeSYFK+XTipRADbRUuyk3oLYaLgkB5V5OplK7YZ8XiNZuhytMIpf7GWFPIBpRbA+v2Uc
	7nFHAmJ8v/18bNtTviakrSGm0hNoDsQ319hqKOAhKZkZA/lTGg7pXA4RXgZ5K3Rr/KWczJ
	y5vVLsMlO8x+OrGDhfdXUBb7H4PmVJw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-363-jVHNKE0TMWO_4iuouxfOHA-1; Thu,
 18 Dec 2025 19:40:28 -0500
X-MC-Unique: jVHNKE0TMWO_4iuouxfOHA-1
X-Mimecast-MFC-AGG-ID: jVHNKE0TMWO_4iuouxfOHA_1766104827
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 20DBB1956080;
	Fri, 19 Dec 2025 00:40:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE0011956056;
	Fri, 19 Dec 2025 00:40:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5BJ0ePoP2124936
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 19:40:25 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5BJ0ePWP2124935;
	Thu, 18 Dec 2025 19:40:25 -0500
Date: Thu, 18 Dec 2025 19:40:25 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 00/21] Multipath-tools: various bug fixes
Message-ID: <aUSe-dt4O7-Snhs3@redhat.com>
References: <20251217212113.234959-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251217212113.234959-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gZhuH1hhm6syCudxyMhjc_GW2m4a-A3Ez0b2SrkaY2g_1766104827
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 17, 2025 at 10:20:52PM +0100, Martin Wilck wrote:
> This series contains a number of fixes for various recent issues with
> multipath-tools. The starting point was a use-after-free issue reported on
> GitHub [1]. The actual fixes for that are 02/21 and 06/21. Because this
> Patches 3-12 generally rework the freeing of maps, trying to avoid unexpected
> freeing of paths while freeing multipath structures.
> 
> Because this changes memory handling in multipathd, I ran a set of tests to
> make sure the series doesn't open up new memory leaks. The good news is that I
> haven't found any, except some trivial ones (15/21, 16/21). But I did see one
> minor issue related to libudev [2]. After I found a warning in the libudev man
> page about the library not being thread-safe, I suspected that this might be
> causing the leak, and came up with code wrapping all libudev calls with a
> mutex (18/21, 19/21).  Unfortunately it didn't fix the observed leak, but I
> suppose it's still useful because multipathd is using libudev in a way that
> the authors of the library explicitly dismiss as unsupported.
> 
> The release of cmocka 2.0 [3] necessitated rather large-ish adaptations in our
> unit test code (20/21, 21/21).
> 
> Finally 13/21 and 17/21 are bug fixes; in particular the latter is rather nasty.
> 
> [1] https://github.com/opensvc/multipath-tools/issues/128
> [2] https://github.com/opensvc/multipath-tools/issues/130
> [3] https://github.com/opensvc/multipath-tools/issues/129
> 

For everything but 3,9,12, and 17

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Martin Wilck (21):
>   libmultipath: drop drop_multipath
>   libmultipath: don't access path members in free_pgvec()
>   multipathd: free paths in checker_finished()
>   libmultipath: don't touch mpvec in remove_map()
>   libmpathutil: constify find_slot()
>   libmultipath: don't free paths in orphan_paths()
>   libmultipath: free orphaned paths in check_removed_paths()
>   libmultipath: remove free_paths argument from free_pathgroup()
>   libmultipath: fix numeric value of free_paths in free_multipaths()
>   libmultipath: remove free_paths argument from free_pgvec()
>   libmultipath: remove free_paths argument from free_multipathvec()
>   libmultipath: free_multipath: fix FREE_PATHS case
>   multipath-tools: Fix ISO C23 errors with strchr()
>   libmultipath: simplify sysfs_get_target_nodename()
>   multipathd: join the init_unwinder dummy thread
>   kpartx: fix some memory leaks
>   libmpathutil: use union for bitfield
>   libmpathutil: add wrapper code for libudev
>   multipath-tools: use the libudev wrapper functions
>   Makefile: add functionality to determine cmocka version
>   multipath-tools tests: adaptations for cmocka 2.0
> 
>  Makefile.inc                          |   2 +-
>  create-config.mk                      |   5 +
>  kpartx/kpartx.c                       |  18 +-
>  libdmmp/Makefile                      |   2 +-
>  libdmmp/libdmmp.c                     |   2 +-
>  libmpathpersist/mpath_persist.c       |   2 +-
>  libmpathpersist/mpath_persist_int.c   |   2 +-
>  libmpathpersist/mpath_pr_ioctl.c      |   2 +-
>  libmpathpersist/mpath_updatepr.c      |   2 +-
>  libmpathutil/Makefile                 |   2 +-
>  libmpathutil/globals.c                |   2 +-
>  libmpathutil/libmpathutil.version     |  62 ++
>  libmpathutil/mt-libudev.c             | 776 ++++++++++++++++++++++++++
>  libmpathutil/mt-libudev.h             | 120 ++++
>  libmpathutil/mt-udev-wrap.h           |  90 +++
>  libmpathutil/parser.c                 |   2 +-
>  libmpathutil/util.c                   |  12 +-
>  libmpathutil/util.h                   |  43 +-
>  libmpathutil/vector.c                 |   3 +-
>  libmpathutil/vector.h                 |   2 +-
>  libmpathvalid/mpath_valid.c           |   2 +-
>  libmultipath/blacklist.c              |   2 +-
>  libmultipath/blacklist.h              |   2 +-
>  libmultipath/config.c                 |   2 +-
>  libmultipath/configure.c              |  22 +-
>  libmultipath/dict.c                   |   2 +-
>  libmultipath/discovery.c              |  36 +-
>  libmultipath/dmparser.c               |   6 +-
>  libmultipath/foreign.c                |   2 +-
>  libmultipath/foreign.h                |   2 +-
>  libmultipath/foreign/nvme.c           |   2 +-
>  libmultipath/libmultipath.version     |   2 +
>  libmultipath/pgpolicies.c             |  14 +-
>  libmultipath/print.c                  |   2 +-
>  libmultipath/prio.c                   |   2 +-
>  libmultipath/prioritizers/alua_rtpg.c |   2 +-
>  libmultipath/prioritizers/ana.c       |   2 +-
>  libmultipath/prkey.c                  |   4 +-
>  libmultipath/prkey.h                  |   2 +-
>  libmultipath/propsel.c                |   2 +-
>  libmultipath/structs.c                |  94 ++--
>  libmultipath/structs.h                |   7 +-
>  libmultipath/structs_vec.c            |  58 +-
>  libmultipath/structs_vec.h            |   4 +-
>  libmultipath/sysfs.c                  |   2 +-
>  libmultipath/uevent.c                 |   2 +-
>  libmultipath/valid.c                  |   2 +-
>  mpathpersist/main.c                   |   2 +-
>  multipath/main.c                      |  16 +-
>  multipathd/cli_handlers.c             |   2 +-
>  multipathd/fpin_handlers.c            |   2 +-
>  multipathd/init_unwinder.c            |   4 +-
>  multipathd/main.c                     |  20 +-
>  tests/Makefile                        |  22 +-
>  tests/alias.c                         |  44 +-
>  tests/blacklist.c                     |   2 +-
>  tests/cli.c                           |   8 +-
>  tests/cmocka-compat.h                 |  16 +
>  tests/devt.c                          |   6 +-
>  tests/directio.c                      |  23 +-
>  tests/dmevents.c                      |  74 +--
>  tests/features.c                      |   2 +-
>  tests/hwtable.c                       |   6 +-
>  tests/mapinfo.c                       |  82 +--
>  tests/mpathvalid.c                    |  18 +-
>  tests/parser.c                        |   2 +-
>  tests/pgpolicy.c                      |   4 +-
>  tests/strbuf.c                        | 130 ++---
>  tests/sysfs.c                         |  76 +--
>  tests/test-lib.c                      |  90 +--
>  tests/test-log.c                      |  10 +-
>  tests/uevent.c                        |   2 +-
>  tests/unaligned.c                     |   8 +-
>  tests/util.c                          | 116 ++--
>  tests/valid.c                         |  30 +-
>  tests/vpd.c                           |  12 +-
>  76 files changed, 1680 insertions(+), 581 deletions(-)
>  create mode 100644 libmpathutil/mt-libudev.c
>  create mode 100644 libmpathutil/mt-libudev.h
>  create mode 100644 libmpathutil/mt-udev-wrap.h
>  create mode 100644 tests/cmocka-compat.h
> 
> -- 
> 2.52.0

