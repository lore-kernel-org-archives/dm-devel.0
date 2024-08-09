Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF28386AFA
	for <dm-devel@lists.linux.dev>; Fri,  9 Aug 2024 18:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723227274; cv=none; b=XGs9r6e0uuI4g17BMN3XIpwoUXnnXxuSd0R2JYfl/0ipSVzdaUYF79gYyHZW89exbe6jKjcSKgqjc9A5OLb0PZ3JIijGc36GrFthEVvtsYsAwa9vGvd7+y/IwfDkL7BQD1iGY8/PMggrX5DDYpYCyVDG5f3yfp1R/UxpKn2s71M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723227274; c=relaxed/simple;
	bh=LlfxuJRnuRP99oLakhv8aWH8DvC4pyeD6lbG7JXuw+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ij6M6vyRzPbpCFVd2pT6yV7e0UGDigMMFPV0R/oJbdqfLWL21N6luBznmDeldxQ3RqnBcTLdzPEoeKz5S/4ToQOepjLwyTGIOf2ldyUEFZxxy3QweEYvxceIjflvla3V64W05Vbf5MUlqsAnhyMJcjb7IrFs8Td26elyRoAgxQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EmQmguBB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EmQmguBB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723227270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4WxCPj1lABsUp4BcLuD7oeGEHysAX1aEqtrVcaVE4kc=;
	b=EmQmguBB+ilGbm2bB5VXu50xuw+slODYrONoOhzAs6swq+Cdv01NSzpf2FxbEzpuWBPjie
	7WC+YGOtxccXWmLYca5yjRiLwMSgnSVgQ/t1QLBUrd4jO189hJl9PVkv59YGEf5TPonbf+
	vkZdwpWp6VPyPGYF6yQNfwF95JyrZBo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-329-ofu54qH2OhKWDDWGRQ3v8w-1; Fri,
 09 Aug 2024 14:14:28 -0400
X-MC-Unique: ofu54qH2OhKWDDWGRQ3v8w-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1ABFD19560A3;
	Fri,  9 Aug 2024 18:14:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B5255300018D;
	Fri,  9 Aug 2024 18:14:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 479IEPQu3340690
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 9 Aug 2024 14:14:25 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 479IEOB93340689;
	Fri, 9 Aug 2024 14:14:24 -0400
Date: Fri, 9 Aug 2024 14:14:24 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 00/41] multipath-tools: comply with C library reserved
 names
Message-ID: <ZrZcgEz8dHRvyXk-@redhat.com>
References: <20240808152620.93965-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240808152620.93965-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 08, 2024 at 05:25:39PM +0200, Martin Wilck wrote:
> The first 2 patches are minor, independent fixes.
> 
> The rest of the set renames identifiers that possibly conflict with reserved
> names of the C library, and should have no influence on the functionality
> of the code.
> 
> According to the glibc docs, user code must not redefine any type, function,
> variable, or macro names that are part of the ISO C standard [1]. Moreover,
> identifiers must not start with "__" (double underscore) or underscore and
> capital letter, and names starting with underscore are forbidden for globally
> visible symbols.
> 
> This patch series tries to make the multipath-tools code comply with these
> requirements, at least to some extent. I haven't bothered renaming local
> or static variables, or variables like "__x" in macro bodies, for example.
> The starting point for the series was the request not to export strlcat
> and strlcpy any more [2].
> 
> In most cases, I have simply replaced __xyz() or _xyz() by xyz__() (two
> underscores to make them better visible). In some cases, when xyz() was not
> defined, I've simply renamed _xyz() to xyz(). There are exceptions to these
> rules.

Despite some small misgivings about renaming symbols (which quite
possibly aren't being used by anyone) in our user-facing libraries,
libpmathpersist and libmpathcmd, for the set:

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
 
> The set also fixes some typos where __attribute__ was misspelled.
> 
> [1] https://www.gnu.org/software/libc/manual/html_node/Reserved-Names.html
> [2] https://github.com/opensvc/multipath-tools/issues/91
> 
> Martin Wilck (41):
>   multipath-tools tests: make alias.test succeed with increased
>     verbosity
>   libmpathutil: avoid extra memory allocation in print_strbuf()
>   libmpathutil: rename strlcat and strlcpy
>   libmpathutil.version: remove strlcpy and strlcat, and LIBMULTIPATH
>     section
>   libmpathutil: fix __attribute typo in log_pthread.c
>   libmultipath: devmapper.c: rename __DR_UNUSED__, and fix __attribute
>     typo
>   multipathd: fix __attribute typo
>   multipath-tools: use common convention for "header file included"
>     macros
>   libmpathcmd: rename __mpath_connect() to mpath_connect__()
>   libmpathutil: rename _MAX_CMD_LEN
>   libmpathutil: rename __append_strbuf_str() and __get_strbuf_buf()
>   libmpathutil: rename _log_bitfield_overflow()
>   libmpathutil: rename _install_keyword() to install_keyword__()
>   libmultipath: rename _NVME_LIB_C
>   libmultipath: checkers.h: fix __CHECKER_FIRST_MSG in comment
>   libmultipath: rename identifiers with leading underscores in
>     devmapper.h
>   libmultipath: rename identifiers with leading underscores in
>     discovery.h
>   libmultipath: rename __snprint_config()
>   libmultipath: rename __unlock()
>   libmultipath: rename __sysfs_attr_get_value()
>   libmultipath: rename __snprint_foreign_topology()
>   libmultipath: rename macros with double underscores in propsel.c
>   libmultipath: rename enum values with double underscores in structs.h
>   libmultipath: rename macros starting with underscore
>   libmultipath: rename __internal_config variable
>   libmultipath: rename _dm_flush_map() to dm_flush_map__()
>   libmultipath: foreign: rename _check() to check__()
>   libmultipath: rename _cleanup_foreign()
>   libmultipath: rename _init_config()
>   libmultipath: rename symbols starting with underscore in print.h
>   libmultipath: remove dead code in pgpolicies.h
>   libmultipath: remove struct and union names in cciss.h
>   libmpathpersist: rename functions with double leading underscore
>   libdmmp: rename macros starting with _DMMP
>   libdmmp: rename enum values and variables starting with _DMMP_
>   libdmmp: rename non-static functions starting with underscore
>   multipathd: rename symbols with double leading underscore
>   multipath-tools tests: rename functions with double underscores
>   kpartx: rename macros with leading underscores
>   libmpathutil: rename struct _vector to vector_s
>   libmultipath: don't define __user
> 
>  create-config.mk                         |  4 +-
>  kpartx/byteorder.h                       |  6 +-
>  kpartx/crc32.h                           |  6 +-
>  kpartx/dasd.h                            |  6 +-
>  kpartx/devmapper.c                       | 20 +++---
>  kpartx/devmapper.h                       |  6 +-
>  kpartx/dos.h                             |  2 +-
>  kpartx/efi.h                             |  6 +-
>  kpartx/gpt.h                             |  4 +-
>  kpartx/kpartx.h                          |  6 +-
>  kpartx/lopart.h                          |  3 +
>  kpartx/mac.h                             |  4 +-
>  kpartx/xstrncpy.h                        |  3 +
>  libdmmp/libdmmp.c                        | 72 +++++++++----------
>  libdmmp/libdmmp/libdmmp.h                |  6 +-
>  libdmmp/libdmmp_misc.c                   | 10 +--
>  libdmmp/libdmmp_mp.c                     | 12 ++--
>  libdmmp/libdmmp_path.c                   | 22 +++---
>  libdmmp/libdmmp_pg.c                     | 40 +++++------
>  libdmmp/libdmmp_private.h                | 32 ++++-----
>  libmpathcmd/libmpathcmd.version          |  4 +-
>  libmpathcmd/mpath_cmd.c                  |  4 +-
>  libmpathcmd/mpath_cmd.h                  |  8 +--
>  libmpathpersist/libmpathpersist.version  |  6 +-
>  libmpathpersist/mpath_persist.c          | 22 +++---
>  libmpathpersist/mpath_persist.h          | 45 ++++++------
>  libmpathpersist/mpath_persist_int.h      |  6 +-
>  libmpathpersist/mpath_pr_ioctl.h         |  5 ++
>  libmpathpersist/mpathpr.h                |  4 +-
>  libmpathutil/debug.h                     |  6 +-
>  libmpathutil/globals.h                   |  4 +-
>  libmpathutil/libmpathutil.version        | 90 ++++++++++--------------
>  libmpathutil/log.h                       |  6 +-
>  libmpathutil/log_pthread.c               |  2 +-
>  libmpathutil/log_pthread.h               |  6 +-
>  libmpathutil/msort.h                     |  4 +-
>  libmpathutil/parser.c                    |  6 +-
>  libmpathutil/parser.h                    | 32 ++++-----
>  libmpathutil/strbuf.c                    | 29 +++++---
>  libmpathutil/strbuf.h                    | 10 +--
>  libmpathutil/time-util.h                 |  6 +-
>  libmpathutil/util.c                      |  6 +-
>  libmpathutil/util.h                      | 25 ++++---
>  libmpathutil/uxsock.h                    |  7 +-
>  libmpathutil/vector.c                    |  2 +-
>  libmpathutil/vector.h                    | 10 +--
>  libmpathvalid/mpath_valid.h              |  6 +-
>  libmultipath/alias.c                     |  4 +-
>  libmultipath/alias.h                     |  6 +-
>  libmultipath/blacklist.c                 | 14 ++--
>  libmultipath/blacklist.h                 | 14 ++--
>  libmultipath/checkers.h                  |  8 +--
>  libmultipath/checkers/cciss.h            | 22 +++---
>  libmultipath/checkers/directio.c         |  8 +--
>  libmultipath/checkers/directio.h         |  6 +-
>  libmultipath/checkers/emc_clariion.c     | 20 +++---
>  libmultipath/checkers/emc_clariion.h     |  6 +-
>  libmultipath/checkers/hp_sw.h            |  6 +-
>  libmultipath/checkers/rdac.c             | 20 +++---
>  libmultipath/checkers/rdac.h             |  6 +-
>  libmultipath/checkers/readsector0.h      |  6 +-
>  libmultipath/checkers/tur.c              | 10 +--
>  libmultipath/checkers/tur.h              |  6 +-
>  libmultipath/config.c                    | 30 ++++----
>  libmultipath/config.h                    | 10 +--
>  libmultipath/configure.c                 |  2 +-
>  libmultipath/configure.h                 |  6 +-
>  libmultipath/defaults.h                  |  7 +-
>  libmultipath/devmapper.c                 | 28 ++++----
>  libmultipath/devmapper.h                 | 27 +++----
>  libmultipath/dict.c                      |  4 +-
>  libmultipath/dict.h                      |  9 +--
>  libmultipath/discovery.c                 | 18 ++---
>  libmultipath/discovery.h                 | 38 +++++-----
>  libmultipath/dm-generic.c                |  8 +--
>  libmultipath/dm-generic.h                |  6 +-
>  libmultipath/dmparser.c                  |  2 +-
>  libmultipath/dmparser.h                  |  7 +-
>  libmultipath/file.h                      |  6 +-
>  libmultipath/foreign.c                   | 36 +++++-----
>  libmultipath/foreign.h                   | 19 ++---
>  libmultipath/foreign/nvme.c              | 50 ++++++-------
>  libmultipath/generic.h                   | 14 ++--
>  libmultipath/hwtable.h                   |  6 +-
>  libmultipath/io_err_stat.c               |  4 +-
>  libmultipath/io_err_stat.h               |  6 +-
>  libmultipath/libmultipath.version        | 20 +++---
>  libmultipath/libsg.h                     |  6 +-
>  libmultipath/list.h                      |  6 +-
>  libmultipath/lock.c                      |  4 +-
>  libmultipath/lock.h                      |  8 +--
>  libmultipath/nvme-lib.c                  |  2 +-
>  libmultipath/nvme-lib.h                  |  8 +--
>  libmultipath/nvme/argconfig.h            |  4 +-
>  libmultipath/nvme/json.h                 |  4 +-
>  libmultipath/nvme/linux/nvme.h           |  6 +-
>  libmultipath/nvme/linux/nvme_ioctl.h     |  6 +-
>  libmultipath/nvme/nvme-ioctl.h           |  6 +-
>  libmultipath/nvme/nvme.h                 |  6 +-
>  libmultipath/nvme/plugin.h               |  4 +-
>  libmultipath/pgpolicies.h                | 10 +--
>  libmultipath/print.c                     | 68 +++++++++---------
>  libmultipath/print.h                     | 34 ++++-----
>  libmultipath/prio.h                      |  6 +-
>  libmultipath/prioritizers/alua.h         |  4 +-
>  libmultipath/prioritizers/alua_rtpg.c    |  1 -
>  libmultipath/prioritizers/alua_rtpg.h    |  6 +-
>  libmultipath/prioritizers/alua_spc3.h    |  6 +-
>  libmultipath/prioritizers/weightedpath.h |  4 +-
>  libmultipath/prkey.h                     |  6 +-
>  libmultipath/propsel.c                   | 10 +--
>  libmultipath/propsel.h                   |  3 +
>  libmultipath/sg_include.h                |  4 +-
>  libmultipath/structs.c                   | 12 ++--
>  libmultipath/structs.h                   | 22 +++---
>  libmultipath/structs_vec.c               |  2 +-
>  libmultipath/structs_vec.h               |  8 +--
>  libmultipath/switchgroup.h               |  5 ++
>  libmultipath/sysfs.c                     |  6 +-
>  libmultipath/sysfs.h                     |  4 +-
>  libmultipath/uevent.h                    |  6 +-
>  libmultipath/unaligned.h                 |  6 +-
>  libmultipath/valid.c                     | 14 ++--
>  libmultipath/valid.h                     |  6 +-
>  libmultipath/version.h                   |  6 +-
>  libmultipath/wwids.h                     |  6 +-
>  mpathpersist/main.c                      |  6 +-
>  mpathpersist/main.h                      |  4 ++
>  multipathd/cli.c                         |  6 +-
>  multipathd/cli.h                         | 16 ++---
>  multipathd/cli_handlers.c                |  8 +--
>  multipathd/cli_handlers.h                |  4 +-
>  multipathd/dmevents.c                    |  2 +-
>  multipathd/dmevents.h                    |  6 +-
>  multipathd/fpin.h                        |  4 +-
>  multipathd/init_unwinder.h               |  4 +-
>  multipathd/main.c                        | 36 +++++-----
>  multipathd/main.h                        |  6 +-
>  multipathd/pidfile.h                     |  4 ++
>  multipathd/uxclnt.h                      |  5 ++
>  multipathd/uxlsnr.c                      |  6 +-
>  multipathd/uxlsnr.h                      |  4 +-
>  multipathd/waiter.c                      |  2 +-
>  multipathd/waiter.h                      |  6 +-
>  tests/alias.c                            | 64 +++++++++++------
>  tests/mpathvalid.c                       |  2 +-
>  tests/strbuf.c                           | 80 +++++++++++++++++++--
>  tests/sysfs.c                            | 20 +++---
>  tests/test-lib.c                         |  4 +-
>  tests/test-lib.h                         | 20 +++---
>  tests/test-log.h                         |  4 +-
>  tests/valid.c                            | 16 ++---
>  tests/wrap64.h                           |  4 +-
>  153 files changed, 981 insertions(+), 853 deletions(-)
> 
> -- 
> 2.46.0

