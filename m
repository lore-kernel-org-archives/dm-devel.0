Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646C554673
	for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 20:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721163243; cv=none; b=VCgKQxR5Q7C29CPxY85qkb67lDab9ANO0zJGHaVvS/ew4PVjdU1dqJpOlgn7+fta3WmZQwOnvbwrOTFYjHkByeJOTG6qDbfyWMrZAC+OY7Fo9zOLZDUroEwTvC+7hTgBbLOKtop0kBfpjT6EKUz/X0elsr9WaDGcdrLYs7iNXh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721163243; c=relaxed/simple;
	bh=y71BACYCIkds5ZJcsLt2WQWXvxcotpDErwW7GKJSuRE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=frhRdnyuXMX26CxDoXjUenjZA58DSKQjICbV6th/nEsMvCp2PzSUWKN6y/o6Em/Dbdi/qiYYmvzktuRUZcFjaudY9yZEvqjReZJOzxeKmFN4SE3zL3n6O5CnWPmH183yDMIBpm/IfQ+mibFFXK+2Q22rcgoYFRXXUXt3s2ZPTIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KMhT2TKn; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KMhT2TKn"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a7523f0870cso646959866b.3
        for <dm-devel@lists.linux.dev>; Tue, 16 Jul 2024 13:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721163239; x=1721768039; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Zyfhlq4L7TJrcD1auJTHJnStlDCL2rWbCxZPGBNsh90=;
        b=KMhT2TKn5B6HxGCpuZDTVk9EPOTOrOrIWi3JMtinDe8OdIbvCpRU/k43dzPgGnKFyU
         6kz4s1X+z8ragkjkyd/iGR09mTy2/3mL1sOxlFXJ/0B5a+qT23SUHc1RuoIFtMwu+Wan
         ew7+OgzOFqTUToAZdeIoShxGqbvukQign1dhO2YH1GWB3HbB4uF7EPmq1ldi0yoea5ec
         7Esgn9EptZy/GuiMMQEphFtR199zR49rzBIKlclIzePA/BN4ZP6Y+3z0NfL84VEDZJvc
         MWFHz5+IfYQm937lezZEQJG/5Bc8iZ5GXblG/ejssRC/L04sp2JKABnLO1zf9eY01b9R
         QEqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721163239; x=1721768039;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zyfhlq4L7TJrcD1auJTHJnStlDCL2rWbCxZPGBNsh90=;
        b=dGTRTTp4WyK7sNZJLL6ga2naoyHoszNeiXjmN6GOSDB0FczcC/WI509t2sRuRYd8V7
         /3YRi03yGTdWQqRl0l5ov21VFo4dYIS9+yrgFTNuIRsqn0rMvaWaD2mUFvMIY4bsu7xD
         q/EkOmoXjo5N1GBaNrNuEzZ3Sy59Tu47IwZRi7mU7MgwfDOqmKENS2QNxd+Qgt9RUKg4
         EsXeihLFuZImyQUBS/scTcsfmEcVhynRNjT7dnaVw75rX1m3L16JGvk14VMgePLIG+5Q
         4hkGOLic+FycSJ/P3VNERiIdJ6bS5w6WXsv6SgXQ2IA8gtlhDffeJ6z00aJetU2tZTUM
         gmfw==
X-Gm-Message-State: AOJu0YyUCv0HcEMDTyUwKGMJvnnW4GLrYh3QqJu+dGwRxZSM2XXqJuTc
	bFHRJddddKk0qeSClGl5nv+NlHDpcRXgWxYMDtdB6bcNYW45F8DzVKzx6dfRzlAofM6RbtoLycY
	p
X-Google-Smtp-Source: AGHT+IE+G+H2NKBdrtNnjq9NJyfKcG4diyVzw7NgmZnJ2KAeiHPBmUvbe7VT6nfsLyiX0E/VC1ojpg==
X-Received: by 2002:a17:906:4f08:b0:a6f:8265:8f2 with SMTP id a640c23a62f3a-a79ea4918c6mr227657666b.37.1721163238359;
        Tue, 16 Jul 2024 13:53:58 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a79bc5a35desm363008166b.11.2024.07.16.13.53.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 13:53:58 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH v3 00/49] multipath-tools: devmapper API refactored
Date: Tue, 16 Jul 2024 22:53:38 +0200
Message-ID: <20240716205344.146310-1-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1-9 are generic cleanups, partly targeting the previously reported
issues with multipath-tools installation on NixOS by removing hard-coded
paths as much as possible.

Patch 10-18 are basic cleanups for the devmapper code.

Patch 19 is the heart of this patch set, introducing the function
libmp_mapinfo(), which is supposed to serve as general API for fetching
information about maps from libdevmapper. It can work with arbitrary
input for identifying a map, and produce any combination of desired
outputs, with the most lightweight (combination of) ioctls possible.
This part of the set removes some code that had been changed
in patch 10-16. This is sort of suboptimal, but IMO it improves
the readability of the set as  a whole.

Patch 20 adds unit tests for this function.

Patch 21-45 change the libmultipath code to use the new API everywhere,
and add some additional minor improvements and fixes.

Patch 46-49 have been added in v2.

* 46: fix a long-standing bug I accidentally discovered during testing
* 47: implement Ben's idea from the comment of #31 in the old series.
* 48: simplify and fix the logic for determining whether a map is in use
* 49: unrelated, fixes for the directio test

The code is pushed to https://github.com/openSUSE/multipath-tools/tree/tip.

Comments and reviews welcome.

# Changes v2->v3 (all suggestions by Ben Marzinski)

Just posting the patches that have changed wrt v2.

* 16: remove variable r in do_foreach_partmaps
* 19: - print "libmp_mapinfo" rather than "libmp_mapinfo__" in log messages
      - use entire low byte of flags parameter for mapid type.
* 36: adapt to 11
* 42: Fix comment about steal_ptr
* 47: exchanged with 48, adapt to 14
* 48: exchanged with 47

# Changes v1->v2:

I'm posting the entire series, because some of those patches that Ben had
already reviewed are changed.

* 1: add fix for libaio
* 6: make sure kpartx.rules is built (Ben)
* 16: split this large patch between the changes that are just related
  to cleanup_dm_task(), and the other code modifications
* 17: new, used to be part of #16
* 18: new, used to be part of #17. Changed the treatment of DMP_ERR /
  DM_IS_MPATH_ERR (Ben)

(From here on, patch number n maps to (n-2) in the v1 set).

* 19 (was 17):
      - Allow passing a dev_t in mapid_t (Ben).
      - Remove the tgt_type field in mapinfo_t. Instead, introduce
        flags MAPINFO_MPATH_ONLY and MAPINFO_PART_ONLY to make
	libmp_mapinfo__() filter either multipath or partition devices,
	inspired by Ben's comment on patch #31 of the v1 series.
	See also #48.
      These changes require changes in users of the API in patch 30ff.
      I have not removed the Reviewed-by: tags in the followup patches.
* 20 (18): Adapt tests to #19.
* 25 (23):
      - dm_get_wwid() won't touch the output unless it returns DMP_OK
      - adjusted callers to make sure the uuid is not accessed unless
        DMP_OK was returned
      - distinguish between "multipath map is present" and "other map
        is present" in domap() (Ben)
      - Change handling of DMP_ERR in alias_already_taken() (Ben)
* 28 (26): Fixed bug in the return code handling in dm_dev_t()
* 30 (28):
      - Change return code handling in dm_type_match(), to distinguish
        between "not multipath" and "generic error" (Ben)
      - adapt to #19
* 31 (29): adapt to #19
* 32 (30): adapt to #19
* 33 (31): adapt to #18. is_mpath_uuid() will be unexported in #48
* 36 (34):
      - don't check the UUID in do_foreach_partmaps(). This would break
        the partmap_in_use detection (but see #47 below).
      - adapt to #19
* 37 (35): fetch mpp->size (Ben). Print a warning if the size has changed.
* 41 (39):
      - fetch mpp->size (Ben).
      - adapt to #19
* 42 (40): - remove redundant sync_map_state() call (Ben)
      - fetch mpp->size (Ben)
      - check return code of dm_get_wwid()
      - fix segfault caused by passing NULL to update_map()
* n/a (42): dropped (Ben)

(From here on, n maps to (n - 1) in the v1 set).

* 44 (43): adapt to #19

Patch 46-49 are new.

Martin Wilck (49):
  multipath-tools CI: more fixes for arm/v7
  multipath-tools CI: fix dmevents test for Debian Sid, arm/v7
  create-config.mk: use printf instead of /bin/echo
  multipathd.service.in: use @BINDIR@ instead of /sbin
  Makefile.inc: replace @BINDIR@ with $(TGTDIR)/$(bindir)
  kpartx.rules: use @BINDIR@ to locate kpartx
  multipath-tools: Remove hard-coded paths to executables
  multipath-tools: compile_commands.json fixes
  multipath-tools: .gitignore: ignore o.wrap files for CI helpers
  libmultipath: remove unused includes in devmapper.h
  libmultipath: use DM_DEVICE_INFO in dm_mapname()
  multipath-tools: don't call dm_task_no_open_count()
  libmpathutil: export cleanup_udev_device()
  libmpathutil: add cleanup_vector()
  libmultipath: add cleanup helpers for struct multipath
  libmultipath: add cleanup_dm_task(), and use it in devmapper.c
  libmultipath: rename dm_type()->dm_type_match() and use symbolic
    values
  libmultipath: Use symbolic return values for dm_is_mpath()
  libmultipath: add libmp_mapinfo()
  libmultipath tests: add tests for libmp_mapinfo()
  libmultipath: implement dm_get_info() and dm_map_present() with new
    API
  libmultipath: remove dm_get_prefixed_uuid()
  libmultipath: is_mpath_part(): improve parsing
  libmultipath: rename dm_get_uuid() -> dm_get_wwid()
  libmultipath: improve dm_get_wwid() return value logic
  libmultipath: reimplement dm_map_name() with new API
  libmultipath: reimplement dm_map_present_by_uuid()
  libmultipath: reimplement dm_get_opencount() with new API
  libmpathpersist: skip redundant dm_map_present() call
  libmultipath: implement dm_is_mpath() with new API
  libmultipath: implement dm_get_multipath() with new API
  libmultipath: use libmp_mapinfo() in _dm_flush_map()
  libmultipath: add is_mpath_uuid() helper
  libmultipath: add is_mpath_part_uuid() helper
  libmultipath: add dmp_errstr() helper
  libmultipath: use libmp_mapinfo() in do_foreach_partmaps()
  libmultipath: use libmp_pathinfo() in update_multipath_table()
  libmultipath: update mpp->dmi in update_multipath_table()
  libmultipath: drop extra call to dm_map_present() in domap()
  libmultipath: split off update_multipath_table__()
  multipath: implement check_usable_paths() with libmp_pathinfo()
  multipathd: implement add_map_without_path() with libmp_mapinfo()
  libmultipath: simplify dm_get_maps()
  libmpathpersist: use libmp_mapinfo() in mpath_get_map()
  libmpathpersist: use mpp->alias in do_mpath_persistent_reserve_out()
  libmultipath: fix deferred_remove logic in remove_partmap()
  libmultipath: Move UUID check into libmp_pathinfo__()
  libmultipath: don't call do_foreach_partmaps() recursively
  multipath-tools tests: fix directio test with real device

 .gitignore                               |    4 +
 Makefile                                 |    4 +-
 Makefile.inc                             |   29 +-
 create-config.mk                         |    4 +-
 kpartx/Makefile                          |    6 +-
 kpartx/devmapper.c                       |   15 -
 kpartx/{kpartx.rules => kpartx.rules.in} |    2 +-
 kpartx/kpartx_id                         |    8 +-
 libmpathpersist/mpath_persist_int.c      |   81 +-
 libmpathutil/libmpathutil.version        |    5 +
 libmpathutil/util.c                      |    6 +
 libmpathutil/util.h                      |    3 +
 libmpathutil/vector.c                    |    6 +
 libmpathutil/vector.h                    |    1 +
 libmultipath/alias.c                     |   11 +-
 libmultipath/configure.c                 |   31 +-
 libmultipath/devmapper.c                 | 1055 +++++++---------
 libmultipath/devmapper.h                 |  109 +-
 libmultipath/libmultipath.version        |   11 +-
 libmultipath/print.c                     |    6 -
 libmultipath/structs.c                   |   12 +
 libmultipath/structs.h                   |    2 +
 libmultipath/structs_vec.c               |   52 +-
 libmultipath/structs_vec.h               |    2 +
 libmultipath/valid.c                     |    2 +-
 libmultipath/wwids.c                     |    2 +-
 multipath/11-dm-mpath.rules.in           |    4 +-
 multipath/main.c                         |   57 +-
 multipath/multipath.rules.in             |    6 +-
 multipathd/dmevents.c                    |   21 +-
 multipathd/main.c                        |   77 +-
 multipathd/multipathd.service.in         |    4 +-
 multipathd/waiter.c                      |    2 -
 tests/Makefile                           |   13 +-
 tests/README.md                          |   29 +-
 tests/alias.c                            |   32 +-
 tests/directio.c                         |  182 +--
 tests/dmevents.c                         |   34 +-
 tests/mapinfo.c                          | 1401 ++++++++++++++++++++++
 tests/valid.c                            |   10 +-
 tests/wrap64.h                           |   11 +-
 41 files changed, 2372 insertions(+), 980 deletions(-)
 rename kpartx/{kpartx.rules => kpartx.rules.in} (96%)
 create mode 100644 tests/mapinfo.c

-- 
2.45.2

