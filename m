Received: from mail-ed1-f65.google.com (mail-ed1-f65.google.com [209.85.208.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E24018E044
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130797; cv=none; b=Zx1rC+lRdabwNY5WwjBqAP9KsYhsQfbT3E+5O6Yi2QVVkATkqZuUg0fJRCFtYqt/LYsufJcrPrD4ub9To5DSJUSQKNPVe60WydopT8LpghYuo6u+EP7785TP1nPONNSnJpCCn07tFuu4EZvvXTQhmKuY7dQTWUD6FcD4k5mYOFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130797; c=relaxed/simple;
	bh=vgXKwXxjbnb1udCFxY+NKVGdJdxppEt8UL6DmQPDiHE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JX2jK663wVXPYYTBZJLfAoQ3kXf9uMg5GrjLE3iJBKmTiwfYv+vwHWqq381VQRQNm6eBFcBZor1jyX63BE+GLv/aZQs70keZxpkMaI0abBplIsnywX1kqoxC//xwipMGoJ7jjmma8HS+YprDDBwRpBDH/wPuB3pLV7Pdm0VIgiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UTIEiuEs; arc=none smtp.client-ip=209.85.208.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UTIEiuEs"
Received: by mail-ed1-f65.google.com with SMTP id 4fb4d7f45d1cf-5a309d1a788so1128080a12.3
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130794; x=1723735594; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NoF7X797YcNyoH3h8XDW91mfOXc7D/4WJhnGub55ZiM=;
        b=UTIEiuEshFGC5a7ozSkVozSuebkqoscrurE/hJbT3VYHSf+NF641x0NzyeNr0hJV4L
         ljRxwH82oM2MUwG+dov2e4NAsshpS83fzsTrEpPQ96cByGjBOFgso5vrgmt8xS+DPJOq
         AmTOBVBW9ZGfk7strG9fTi6vrZrIvRHQ8xcMyVhMAXZd3UXt2AaT7LZojJa5SpWCl46V
         i0v0cWnhji9FTcsNse3u38r8l5y3WDaU9N29yTgYCckVE1F00tjoUZInHc6SgnqZEeDS
         2cx7+uZFUbyAYdFbRM7Hs7JHKYAwwtq4tz+itLZLGVcKv93Szv7nd2a0XOlkvlht/4Wb
         CUWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130794; x=1723735594;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NoF7X797YcNyoH3h8XDW91mfOXc7D/4WJhnGub55ZiM=;
        b=U/HwIXCsBVu+JNov2rrwAACMlbAYxxHTopb5GzWvLI5bMYln1bT8dTwJC19JZtFw5r
         V83F3o2OSXjYbnsrpbbfymnFK/rcmW9Sl9//dVH1G7KRe6gwj0PkbVMfP/HZ/XhTUEv0
         LcZ/v2dbcCeHt3K/mShLX081uiwsb3UAq7bZfvsHrAT8LjHGLtmaWlQj2EbK4LSNT1Yh
         6BtZiaMByZXrhUtoWrCml9pFm2fLlu9rb/rrGEky+o1S4zfXv/bz6zdhZSFutUcnqm/i
         6qqzqnUD5dggu1kwkV1OOcHPWTLLU6VuhblZoI0x5FdBp84xIrka84ZCy2w/sYxpJNMv
         j5jw==
X-Gm-Message-State: AOJu0YwQ6NJZ+ovNmAfIXHCgGc7p+6iVEA3uoEA0yAuI4VUfFyGIYhU5
	ocpR/pST2dNC1Pu85N9BfjTwnFydUv83E31m6aPJi3dPaDYgahdu73a1K2PFUECJlTXrHa3RhLq
	4lgmzVw==
X-Google-Smtp-Source: AGHT+IEaYhKpnr+HDU3bAfikXFVX4cKjnP90WYYcUXAvNG+1mTxq7nJ6cmmNMx6uTbVfyhgK4QhEKQ==
X-Received: by 2002:a05:6402:1913:b0:57d:10c7:aa4b with SMTP id 4fb4d7f45d1cf-5bbb23c7817mr1646679a12.30.1723130793396;
        Thu, 08 Aug 2024 08:26:33 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5bbb2c409f8sm730711a12.38.2024.08.08.08.26.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:33 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 00/41] multipath-tools: comply with C library reserved names
Date: Thu,  8 Aug 2024 17:25:39 +0200
Message-ID: <20240808152620.93965-1-mwilck@suse.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The first 2 patches are minor, independent fixes.

The rest of the set renames identifiers that possibly conflict with reserved
names of the C library, and should have no influence on the functionality
of the code.

According to the glibc docs, user code must not redefine any type, function,
variable, or macro names that are part of the ISO C standard [1]. Moreover,
identifiers must not start with "__" (double underscore) or underscore and
capital letter, and names starting with underscore are forbidden for globally
visible symbols.

This patch series tries to make the multipath-tools code comply with these
requirements, at least to some extent. I haven't bothered renaming local
or static variables, or variables like "__x" in macro bodies, for example.
The starting point for the series was the request not to export strlcat
and strlcpy any more [2].

In most cases, I have simply replaced __xyz() or _xyz() by xyz__() (two
underscores to make them better visible). In some cases, when xyz() was not
defined, I've simply renamed _xyz() to xyz(). There are exceptions to these
rules.

The set also fixes some typos where __attribute__ was misspelled.

[1] https://www.gnu.org/software/libc/manual/html_node/Reserved-Names.html
[2] https://github.com/opensvc/multipath-tools/issues/91

Martin Wilck (41):
  multipath-tools tests: make alias.test succeed with increased
    verbosity
  libmpathutil: avoid extra memory allocation in print_strbuf()
  libmpathutil: rename strlcat and strlcpy
  libmpathutil.version: remove strlcpy and strlcat, and LIBMULTIPATH
    section
  libmpathutil: fix __attribute typo in log_pthread.c
  libmultipath: devmapper.c: rename __DR_UNUSED__, and fix __attribute
    typo
  multipathd: fix __attribute typo
  multipath-tools: use common convention for "header file included"
    macros
  libmpathcmd: rename __mpath_connect() to mpath_connect__()
  libmpathutil: rename _MAX_CMD_LEN
  libmpathutil: rename __append_strbuf_str() and __get_strbuf_buf()
  libmpathutil: rename _log_bitfield_overflow()
  libmpathutil: rename _install_keyword() to install_keyword__()
  libmultipath: rename _NVME_LIB_C
  libmultipath: checkers.h: fix __CHECKER_FIRST_MSG in comment
  libmultipath: rename identifiers with leading underscores in
    devmapper.h
  libmultipath: rename identifiers with leading underscores in
    discovery.h
  libmultipath: rename __snprint_config()
  libmultipath: rename __unlock()
  libmultipath: rename __sysfs_attr_get_value()
  libmultipath: rename __snprint_foreign_topology()
  libmultipath: rename macros with double underscores in propsel.c
  libmultipath: rename enum values with double underscores in structs.h
  libmultipath: rename macros starting with underscore
  libmultipath: rename __internal_config variable
  libmultipath: rename _dm_flush_map() to dm_flush_map__()
  libmultipath: foreign: rename _check() to check__()
  libmultipath: rename _cleanup_foreign()
  libmultipath: rename _init_config()
  libmultipath: rename symbols starting with underscore in print.h
  libmultipath: remove dead code in pgpolicies.h
  libmultipath: remove struct and union names in cciss.h
  libmpathpersist: rename functions with double leading underscore
  libdmmp: rename macros starting with _DMMP
  libdmmp: rename enum values and variables starting with _DMMP_
  libdmmp: rename non-static functions starting with underscore
  multipathd: rename symbols with double leading underscore
  multipath-tools tests: rename functions with double underscores
  kpartx: rename macros with leading underscores
  libmpathutil: rename struct _vector to vector_s
  libmultipath: don't define __user

 create-config.mk                         |  4 +-
 kpartx/byteorder.h                       |  6 +-
 kpartx/crc32.h                           |  6 +-
 kpartx/dasd.h                            |  6 +-
 kpartx/devmapper.c                       | 20 +++---
 kpartx/devmapper.h                       |  6 +-
 kpartx/dos.h                             |  2 +-
 kpartx/efi.h                             |  6 +-
 kpartx/gpt.h                             |  4 +-
 kpartx/kpartx.h                          |  6 +-
 kpartx/lopart.h                          |  3 +
 kpartx/mac.h                             |  4 +-
 kpartx/xstrncpy.h                        |  3 +
 libdmmp/libdmmp.c                        | 72 +++++++++----------
 libdmmp/libdmmp/libdmmp.h                |  6 +-
 libdmmp/libdmmp_misc.c                   | 10 +--
 libdmmp/libdmmp_mp.c                     | 12 ++--
 libdmmp/libdmmp_path.c                   | 22 +++---
 libdmmp/libdmmp_pg.c                     | 40 +++++------
 libdmmp/libdmmp_private.h                | 32 ++++-----
 libmpathcmd/libmpathcmd.version          |  4 +-
 libmpathcmd/mpath_cmd.c                  |  4 +-
 libmpathcmd/mpath_cmd.h                  |  8 +--
 libmpathpersist/libmpathpersist.version  |  6 +-
 libmpathpersist/mpath_persist.c          | 22 +++---
 libmpathpersist/mpath_persist.h          | 45 ++++++------
 libmpathpersist/mpath_persist_int.h      |  6 +-
 libmpathpersist/mpath_pr_ioctl.h         |  5 ++
 libmpathpersist/mpathpr.h                |  4 +-
 libmpathutil/debug.h                     |  6 +-
 libmpathutil/globals.h                   |  4 +-
 libmpathutil/libmpathutil.version        | 90 ++++++++++--------------
 libmpathutil/log.h                       |  6 +-
 libmpathutil/log_pthread.c               |  2 +-
 libmpathutil/log_pthread.h               |  6 +-
 libmpathutil/msort.h                     |  4 +-
 libmpathutil/parser.c                    |  6 +-
 libmpathutil/parser.h                    | 32 ++++-----
 libmpathutil/strbuf.c                    | 29 +++++---
 libmpathutil/strbuf.h                    | 10 +--
 libmpathutil/time-util.h                 |  6 +-
 libmpathutil/util.c                      |  6 +-
 libmpathutil/util.h                      | 25 ++++---
 libmpathutil/uxsock.h                    |  7 +-
 libmpathutil/vector.c                    |  2 +-
 libmpathutil/vector.h                    | 10 +--
 libmpathvalid/mpath_valid.h              |  6 +-
 libmultipath/alias.c                     |  4 +-
 libmultipath/alias.h                     |  6 +-
 libmultipath/blacklist.c                 | 14 ++--
 libmultipath/blacklist.h                 | 14 ++--
 libmultipath/checkers.h                  |  8 +--
 libmultipath/checkers/cciss.h            | 22 +++---
 libmultipath/checkers/directio.c         |  8 +--
 libmultipath/checkers/directio.h         |  6 +-
 libmultipath/checkers/emc_clariion.c     | 20 +++---
 libmultipath/checkers/emc_clariion.h     |  6 +-
 libmultipath/checkers/hp_sw.h            |  6 +-
 libmultipath/checkers/rdac.c             | 20 +++---
 libmultipath/checkers/rdac.h             |  6 +-
 libmultipath/checkers/readsector0.h      |  6 +-
 libmultipath/checkers/tur.c              | 10 +--
 libmultipath/checkers/tur.h              |  6 +-
 libmultipath/config.c                    | 30 ++++----
 libmultipath/config.h                    | 10 +--
 libmultipath/configure.c                 |  2 +-
 libmultipath/configure.h                 |  6 +-
 libmultipath/defaults.h                  |  7 +-
 libmultipath/devmapper.c                 | 28 ++++----
 libmultipath/devmapper.h                 | 27 +++----
 libmultipath/dict.c                      |  4 +-
 libmultipath/dict.h                      |  9 +--
 libmultipath/discovery.c                 | 18 ++---
 libmultipath/discovery.h                 | 38 +++++-----
 libmultipath/dm-generic.c                |  8 +--
 libmultipath/dm-generic.h                |  6 +-
 libmultipath/dmparser.c                  |  2 +-
 libmultipath/dmparser.h                  |  7 +-
 libmultipath/file.h                      |  6 +-
 libmultipath/foreign.c                   | 36 +++++-----
 libmultipath/foreign.h                   | 19 ++---
 libmultipath/foreign/nvme.c              | 50 ++++++-------
 libmultipath/generic.h                   | 14 ++--
 libmultipath/hwtable.h                   |  6 +-
 libmultipath/io_err_stat.c               |  4 +-
 libmultipath/io_err_stat.h               |  6 +-
 libmultipath/libmultipath.version        | 20 +++---
 libmultipath/libsg.h                     |  6 +-
 libmultipath/list.h                      |  6 +-
 libmultipath/lock.c                      |  4 +-
 libmultipath/lock.h                      |  8 +--
 libmultipath/nvme-lib.c                  |  2 +-
 libmultipath/nvme-lib.h                  |  8 +--
 libmultipath/nvme/argconfig.h            |  4 +-
 libmultipath/nvme/json.h                 |  4 +-
 libmultipath/nvme/linux/nvme.h           |  6 +-
 libmultipath/nvme/linux/nvme_ioctl.h     |  6 +-
 libmultipath/nvme/nvme-ioctl.h           |  6 +-
 libmultipath/nvme/nvme.h                 |  6 +-
 libmultipath/nvme/plugin.h               |  4 +-
 libmultipath/pgpolicies.h                | 10 +--
 libmultipath/print.c                     | 68 +++++++++---------
 libmultipath/print.h                     | 34 ++++-----
 libmultipath/prio.h                      |  6 +-
 libmultipath/prioritizers/alua.h         |  4 +-
 libmultipath/prioritizers/alua_rtpg.c    |  1 -
 libmultipath/prioritizers/alua_rtpg.h    |  6 +-
 libmultipath/prioritizers/alua_spc3.h    |  6 +-
 libmultipath/prioritizers/weightedpath.h |  4 +-
 libmultipath/prkey.h                     |  6 +-
 libmultipath/propsel.c                   | 10 +--
 libmultipath/propsel.h                   |  3 +
 libmultipath/sg_include.h                |  4 +-
 libmultipath/structs.c                   | 12 ++--
 libmultipath/structs.h                   | 22 +++---
 libmultipath/structs_vec.c               |  2 +-
 libmultipath/structs_vec.h               |  8 +--
 libmultipath/switchgroup.h               |  5 ++
 libmultipath/sysfs.c                     |  6 +-
 libmultipath/sysfs.h                     |  4 +-
 libmultipath/uevent.h                    |  6 +-
 libmultipath/unaligned.h                 |  6 +-
 libmultipath/valid.c                     | 14 ++--
 libmultipath/valid.h                     |  6 +-
 libmultipath/version.h                   |  6 +-
 libmultipath/wwids.h                     |  6 +-
 mpathpersist/main.c                      |  6 +-
 mpathpersist/main.h                      |  4 ++
 multipathd/cli.c                         |  6 +-
 multipathd/cli.h                         | 16 ++---
 multipathd/cli_handlers.c                |  8 +--
 multipathd/cli_handlers.h                |  4 +-
 multipathd/dmevents.c                    |  2 +-
 multipathd/dmevents.h                    |  6 +-
 multipathd/fpin.h                        |  4 +-
 multipathd/init_unwinder.h               |  4 +-
 multipathd/main.c                        | 36 +++++-----
 multipathd/main.h                        |  6 +-
 multipathd/pidfile.h                     |  4 ++
 multipathd/uxclnt.h                      |  5 ++
 multipathd/uxlsnr.c                      |  6 +-
 multipathd/uxlsnr.h                      |  4 +-
 multipathd/waiter.c                      |  2 +-
 multipathd/waiter.h                      |  6 +-
 tests/alias.c                            | 64 +++++++++++------
 tests/mpathvalid.c                       |  2 +-
 tests/strbuf.c                           | 80 +++++++++++++++++++--
 tests/sysfs.c                            | 20 +++---
 tests/test-lib.c                         |  4 +-
 tests/test-lib.h                         | 20 +++---
 tests/test-log.h                         |  4 +-
 tests/valid.c                            | 16 ++---
 tests/wrap64.h                           |  4 +-
 153 files changed, 981 insertions(+), 853 deletions(-)

-- 
2.46.0

