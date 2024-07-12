Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6311D176AC2
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804535; cv=none; b=efKS02SKbrtP6ZExjDf7p038oTOFGTSiebvliWF1Vuwmsg7hqn+5OMueYRNS4Gf/9InEFColgQeh9fxc6VmKQBsOKOpia9iFuYGV7piInBQ5F60URSlRZTTI6scFjuG99K/Id3obQZxSyJZKeevIJcCVXGbgv7YiuompDZzNO6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804535; c=relaxed/simple;
	bh=E4eRTa/eXNoYGRpyXQYJEYKPRfTGLEQcGj+ECxpQtJc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nPfaQYHh/9CIeE5lFNfqJtxoJvb8UiWSWeys3wLBtM2YY3sWPiJ6+HQLpI9TdicWhZR//lq//yK6GBGqabiPw6oxdNyTqKayOPM66/n4uR3f2YaPUZ9rRhEsWLTqS1EhJQIM34lwe3nZNegBXnHGmzD8PYs95h7X26niGtnI2Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ad60C9jx; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ad60C9jx"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a77baa87743so281876266b.3
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804529; x=1721409329; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ncdugygkbdj+pGfWDPg9CkvuzaPbuxX8pifco8fg3e8=;
        b=Ad60C9jxyqEmQjz1UQ4NllXxaI9OwKjEGxElN164gfLBjCaEyXyZV3dxNSKOFKG/VB
         3zDg6wulkDRiy9+JFcYMTzqTvly4ZatuqQm0FcXz3roZyZsgqmG27oliud55gjgV+YCR
         mqtmE1lYPLp/OcSIdJ7abyLzo59RVF1arhzjoIS7RU9KiAWBtLDyn38IQltEWMuMVlpl
         2mrzlmpds23oifXWkHFppbTJ+T1QIWW7p+4zai0xD3i8MlNbQ8DUPuArkNeGQ5IVllL0
         fuvHxIAA+8OPeN5BRPvsSkRoY1TxB/wLHfpYluRXm7lx0F1LTs2VY3lPlUPEog+vYYC1
         98FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804529; x=1721409329;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ncdugygkbdj+pGfWDPg9CkvuzaPbuxX8pifco8fg3e8=;
        b=dstqzLKzea8JAa3AeATiJys25nCUlfZgpl9UCuHBB74zKVdocrF3vi82YTNBeH9HQV
         Ac9YROeeLbR2Tqp5iOOr2eBKNCRwk2PYJ/U0dKackGx+hT/5zG+ZdQu5dUpVfz8V2MWT
         fv/TlIphxkTmd9TN1EPBI+gSBaEXvSiVqhwzglm8qjdWda08j05tIb9xePw6VEp29mt+
         ZDRRnMyDQ7+Js2g/UREWfeovI+wNKiN//zYbHVFEuW0RWO2xx4ir2+vgU0zhq7PB6PwJ
         Sejn4/AxnfhllksDTzcK7c6WNuSHlH/W/xpSKyxKmi13DwOMLPumDhVXnekXjhnqY8p8
         2C1g==
X-Gm-Message-State: AOJu0YxkYWIp42vmY4goa0B2GWdFaEBiq88KggEk+dtzfpPvOZQkBdVE
	r6AMe/hLivPWwwrJ3LvG5JtdVND9LRLLucYx1RXAs8sWRvnb+g4o2eB477YUDC4=
X-Google-Smtp-Source: AGHT+IGM8J9C4JdI3CvmzjHymgqB/JrFhlSWg590o3KQCzY/KYCoGC1srEjrlrkk26GM1+K/qWlGtg==
X-Received: by 2002:a17:906:c7ca:b0:a77:e55a:9e76 with SMTP id a640c23a62f3a-a780b689173mr859419466b.5.1720804528432;
        Fri, 12 Jul 2024 10:15:28 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a7ff073sm359606166b.137.2024.07.12.10.15.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:15:28 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 00/49] multipath-tools: devmapper API refactored
Date: Fri, 12 Jul 2024 19:14:08 +0200
Message-ID: <20240712171458.77611-1-mwilck@suse.com>
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
* 47: simplify and fix the logic for determining whether a map is in use
* 48: implement Ben's idea from the comment of #31 in the old series.
* 49: unrelated, fixes for the directio test

The code is pushed to https://github.com/openSUSE/multipath-tools/tree/tip.

Comments and reviews welcome.

I'm posting the entire series, because some of those patches that Ben had
already reviewed are changed.

# Changes v1->v2:

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
  libmultipath: don't call do_foreach_partmaps() recursively
  libmultipath: Move UUID check into libmp_pathinfo__()
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
 libmultipath/devmapper.c                 | 1052 +++++++---------
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
 41 files changed, 2370 insertions(+), 979 deletions(-)
 rename kpartx/{kpartx.rules => kpartx.rules.in} (96%)
 create mode 100644 tests/mapinfo.c

-- 
2.45.2

