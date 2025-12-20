Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C781A4F3C
	for <dm-devel@lists.linux.dev>; Sat, 20 Dec 2025 04:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766205716; cv=none; b=cWL9s/hgkan1vXpGV8AmPtitYkRqmry00ADH78C0Ik4W0/Zod+4hgDff/59Uv9nDgIGtDlvMeikJA5jLFKSPYDXqX+zZiS6RZVP/OPZdYjrJfkEzvqOB2PJmXEW4DWlFNyg/88mnZKyTcvHHNW/mG2HOZ/1MBTXkaDTGFOvWrxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766205716; c=relaxed/simple;
	bh=/ql5gzRwMwtNxDMR6NG4GRXqCPzo9Z5ISMHXE37nKic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Tqvbqgjw3omObIkG37wd73FMCK3I3ayCRF+ZGjCvNeMqoPJWusDwZKGqteYYKqwkrKt0hFD2xMpDb9WZJh9m2HdoxL079Sh3cKWBjQwL1Jne/q9f/dzKgB/jW6lI7d8hnlOLdo/hxaps58+Mm52uMUXhZSlDqcCregkiboeh6mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HLeUFazI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HLeUFazI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766205712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RgsDlGMcVlkko0XjEbbK0TWzTcv4FLi9kX/9r1hXkVo=;
	b=HLeUFazIMLG3X//a5aaIV7mjHa3XB+S9iEL1VYRut6AZreEDEwWT8kw8+Vnown7rGQ0MJ6
	TqC3QRXm56T9IFSBTuly4Q9Aex0lPI0pyMvHuoY20zDtUGt3PRCu7y6j1sh4Y9nviF0fwU
	ltBDfrjg/wBzuUxtob/ja2Oxj+rTkPg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-616-COb60c6KN7ysLKiDO9DcSg-1; Fri,
 19 Dec 2025 23:41:50 -0500
X-MC-Unique: COb60c6KN7ysLKiDO9DcSg-1
X-Mimecast-MFC-AGG-ID: COb60c6KN7ysLKiDO9DcSg_1766205709
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0C09F1956080;
	Sat, 20 Dec 2025 04:41:49 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CAB941800367;
	Sat, 20 Dec 2025 04:41:48 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5BK4flhf2174194
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 19 Dec 2025 23:41:47 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5BK4flvp2174193;
	Fri, 19 Dec 2025 23:41:47 -0500
Date: Fri, 19 Dec 2025 23:41:47 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 00/26] Multipath-tools: various bug fixes
Message-ID: <aUYpC_LaTHXIUkVU@redhat.com>
References: <20251219144108.237928-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251219144108.237928-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oCsdRokfbiQf7tzDq7h79h7ttJJVgTWMpGq3G4easYQ_1766205709
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 19, 2025 at 03:40:42PM +0100, Martin Wilck wrote:

For everything but patches 14 & 16:
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Changes v1 -> v2
> 
> Fixed the issues pointed out by Benjamin Marzinski in v1.
> 
> - paths are still removed in sync_paths(), as before. I added some comments
>   lest we forget about this.
> - in the checker loop, only orphan paths in REMOVED/PARTIAL state are freed
> - removed the free_paths argument from free_multipath, and changed
>   add_map_without_path and check_usable_paths() as suggested by Ben.
>   free_multipath() doesn't free paths any more.
> - the BITFIELD macro now creates a field of fixed length.
> - fixed whitespace issues.
> 
> These changes required shuffling the patches around. Therefore I'm resending
> the entire series. I kept Ben's Reviewed-by: trailers.
> 
> I also fixed some formatting issues reported by clang-format.
> clang-format also changes context line of diffs, which I accepted.
> 
> v1 cover letter
> ---------------
> 
> (note: I did not fix the patch numbers)
> 
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
> Martin Wilck (26):
>   libmultipath: drop drop_multipath
>   libmultipath: don't access path members in free_pgvec()
>   libmpathutil: constify find_slot()
>   libmultipath: don't touch mpvec in remove_map()
>   libmultipath: export orphan_paths()
>   libmultipath: export cleanup_multipath()
>   libmultipath: add cleanup_pathvec_and_free_paths()
>   libmultipath: don't free paths in orphan_paths()
>   multipathd: free orphaned paths in checker_finished()
>   libmultipath: remove free_paths argument from free_pathgroup()
>   libmultipath: remove free_paths argument from free_pgvec()
>   libmultipath: remove free_paths argument from free_multipathvec()
>   multipath: free paths through pathvec in check_usable_paths()
>   multipathd: add_map_without_path(): orphan paths instead of freeing
>     them
>   libmultipath: remove free_paths argument from free_multipath()
>   libmultipath: remove cleanup_multipath_and_paths()
>   libmultipaths: annotate functions that may free paths
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
>  libmpathutil/util.h                   |  49 +-
>  libmpathutil/vector.c                 |   3 +-
>  libmpathutil/vector.h                 |   2 +-
>  libmpathvalid/mpath_valid.c           |   2 +-
>  libmultipath/blacklist.c              |   2 +-
>  libmultipath/blacklist.h              |   2 +-
>  libmultipath/config.c                 |   2 +-
>  libmultipath/configure.c              |  24 +-
>  libmultipath/devmapper.c              |   2 +-
>  libmultipath/dict.c                   |   2 +-
>  libmultipath/discovery.c              |  44 +-
>  libmultipath/dmparser.c               |   6 +-
>  libmultipath/foreign.c                |   2 +-
>  libmultipath/foreign.h                |   2 +-
>  libmultipath/foreign/nvme.c           |   2 +-
>  libmultipath/libmultipath.version     |   5 +-
>  libmultipath/pgpolicies.c             |  14 +-
>  libmultipath/print.c                  |   2 +-
>  libmultipath/prio.c                   |   2 +-
>  libmultipath/prioritizers/alua_rtpg.c |   2 +-
>  libmultipath/prioritizers/ana.c       |   2 +-
>  libmultipath/prkey.c                  |   4 +-
>  libmultipath/prkey.h                  |   2 +-
>  libmultipath/propsel.c                |   2 +-
>  libmultipath/structs.c                |  82 +--
>  libmultipath/structs.h                |  13 +-
>  libmultipath/structs_vec.c            |  88 +--
>  libmultipath/structs_vec.h            |   4 +-
>  libmultipath/sysfs.c                  |   2 +-
>  libmultipath/uevent.c                 |   2 +-
>  libmultipath/valid.c                  |   2 +-
>  mpathpersist/main.c                   |   2 +-
>  multipath/main.c                      |  22 +-
>  multipathd/cli_handlers.c             |   2 +-
>  multipathd/fpin_handlers.c            |   2 +-
>  multipathd/init_unwinder.c            |   4 +-
>  multipathd/main.c                     |  59 +-
>  tests/Makefile                        |  22 +-
>  tests/alias.c                         |  50 +-
>  tests/blacklist.c                     |   2 +-
>  tests/cli.c                           |   8 +-
>  tests/cmocka-compat.h                 |  16 +
>  tests/devt.c                          |   6 +-
>  tests/directio.c                      |  23 +-
>  tests/dmevents.c                      |  74 +--
>  tests/features.c                      |   2 +-
>  tests/hwtable.c                       |   6 +-
>  tests/mapinfo.c                       |  85 +--
>  tests/mpathvalid.c                    |  18 +-
>  tests/parser.c                        |   2 +-
>  tests/pgpolicy.c                      |   4 +-
>  tests/strbuf.c                        | 131 ++---
>  tests/sysfs.c                         |  76 +--
>  tests/test-lib.c                      |  95 ++--
>  tests/test-log.c                      |  10 +-
>  tests/uevent.c                        |   2 +-
>  tests/unaligned.c                     |   8 +-
>  tests/util.c                          | 123 ++--
>  tests/valid.c                         |  30 +-
>  tests/vpd.c                           |  12 +-
>  77 files changed, 1748 insertions(+), 625 deletions(-)
>  create mode 100644 libmpathutil/mt-libudev.c
>  create mode 100644 libmpathutil/mt-libudev.h
>  create mode 100644 libmpathutil/mt-udev-wrap.h
>  create mode 100644 tests/cmocka-compat.h
> 
> -- 
> 2.52.0

