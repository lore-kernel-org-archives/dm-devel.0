Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE771B86D4
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561190; cv=none; b=suMlh7gPUpmc/C5MPH57yl081Gqw03vvvXZqvp1oy1pWuxM1xUZ0ad8H4vv4R08O2WPgUl/phweu3Kmtifuzjl4WmPrGDWvsHaw5XoM5D2KcqvdreSsFcISAJ/aoW2t0WEU3sVR9bzKSbI6JXFiuEJA4fEhwHp5usJTV5O7qwZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561190; c=relaxed/simple;
	bh=5ZrLh2Ok7hKJTaNrkFeiJ09ViHA0KJN4eI+e+3fRiSI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iuHnPJiyFqMgSp8HzEjnt+Tx62rQvyUZlAvT8UaaDV2yBnXWdLGs8zM8SolcSq7FYw6hN+IW8k3KHDamAq+Y0OK/3anU2WVZWE04n/1ER0q//tqhnQJlKpM5WOE2qDPJgdlMvVhurEWOcVwwREegSihuoF1CJPJ/UPpWo3GRuBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=R6+6jztU; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="R6+6jztU"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-58b0dddab63so8508566a12.3
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561186; x=1721165986; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5hvafV7GMVW6RBiXeyaEJ7PuG0W2+DSUcc4+Yws7e/s=;
        b=R6+6jztUf78w7Mj4BFCsQeQGGQxra/IboyZrLJY0xSmuKp6fYkNT5z90RunSd1V+Gi
         pZFKNkR2COmDPNldL9JVkYZzqIH4Y4NQOla8ysK7Fc2OCtSxKPZ1m8qkGrKcCf+PUoGV
         tSzcd7jrziEE91NEL6yZo2ODZPMVIkQISnT8BYUFUzb1rsPxpWC9HbnYs/IX/aJDsgcO
         gtzuteOMWGbPWRwlg/t1AhGSf3nLoG/Ax0GLZg79VuQgzoHlN1B881N4NojgWG77UcLe
         EjtZ0snwnzeIrwXAkpX0ZoITyYZzMu4fYfYuCb93geQlItL0nD+kCTUKH134fDYqZjB8
         vFLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561186; x=1721165986;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5hvafV7GMVW6RBiXeyaEJ7PuG0W2+DSUcc4+Yws7e/s=;
        b=P6GTHKK2kvlve/z34dqmVLq+RZvCwBFG5KlLqi1LJcOfCjrUEgrv8zDrw06uj+D+Mi
         dSCAMvzY+TjB7fUSPuPSUkLx1nHF+Nta76U44fpPZ8nZ+tkTILVU9s5n4B/ZyLRoAAF4
         7yaKEluMkOsqDem2WbieLQ/efxJe/59e7mMpR3nuzdCQj/VjRw8vq+m2AWKSnjZ6aD0m
         3b5MfS1fY0slwUi0OuiF2H9dPdqgx8PGeAjTASwZTxbp1QdlGGpOzPXAOBhF8ulvXFOl
         tc9Pg3ycoP3mwcF8d/+E+Ps2NHPpGPSITQTFFcLZHFgiIW2748ONHJbxatxMV+o3B8Jz
         RyCw==
X-Gm-Message-State: AOJu0Yw4uG+GVAliuA0trntJZxzsigu7asg0C6wzvwWl12GgtP2eJoZ7
	ByUl/RgGo9h3AMlWOzOD678SPVYCwcKlm72JhS9TZHMqiLjfRNsM2CNUI1IM1Uc=
X-Google-Smtp-Source: AGHT+IH8oMrwx9xlgBpH1QP1OqVXM/Zuf/Ba/n0Lk6P2xgdaBsExqnj2cbMD+VHklI7Bb7YPxDzJuA==
X-Received: by 2002:a17:907:944f:b0:a77:db36:1ccf with SMTP id a640c23a62f3a-a780b70528emr345857266b.42.1720561185901;
        Tue, 09 Jul 2024 14:39:45 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a6bcc47sm108525666b.11.2024.07.09.14.39.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:39:45 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 00/44] multipath-tools: devmapper API refactored
Date: Tue,  9 Jul 2024 23:38:51 +0200
Message-ID: <20240709213935.177028-1-mwilck@suse.com>
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

Patch 10-16 are basic cleanups for the devmapper code.

Patch 17 is the heart of this patch set, introducing the function
libmp_mapinfo(), which is supposed to serve as general API for fetching
information about maps from libdevmapper. It can work with arbitrary
input for identifying a map, and produce any combination of desired
outputs, with the most lightweight (combination of) ioctls possible.
This part of the set removes some code that had been changed
in patch 10-16. This is sort of suboptimal, but IMO it improves
the readability of the set as  a whole.

Patch 18 adds unit tests for this function.

Patch 19-44 change the libmultipath code to use the new API everywhere,
and add some additional minor improvements and fixes.

The code is pushed to https://github.com/openSUSE/multipath-tools/tree/tip.

Comments and reviews welcome.

Martin Wilck (44):
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
  llibmultipath: fix return code check for dm_is_suspended()
  libmpathpersist: use libmp_mapinfo() in get_mpvec()
  libmpathpersist: use mpp->alias in do_mpath_persistent_reserve_out()

 .gitignore                               |    4 +
 Makefile                                 |    4 +-
 Makefile.inc                             |   29 +-
 create-config.mk                         |    4 +-
 kpartx/Makefile                          |    4 +-
 kpartx/devmapper.c                       |   15 -
 kpartx/{kpartx.rules => kpartx.rules.in} |    2 +-
 kpartx/kpartx_id                         |    8 +-
 libmpathpersist/mpath_persist_int.c      |   85 +-
 libmpathutil/libmpathutil.version        |    5 +
 libmpathutil/util.c                      |    6 +
 libmpathutil/util.h                      |    3 +
 libmpathutil/vector.c                    |    6 +
 libmpathutil/vector.h                    |    1 +
 libmultipath/alias.c                     |    5 +-
 libmultipath/configure.c                 |   27 +-
 libmultipath/devmapper.c                 | 1020 ++++++++------------
 libmultipath/devmapper.h                 |  101 +-
 libmultipath/libmultipath.version        |   10 +-
 libmultipath/print.c                     |    6 -
 libmultipath/structs.c                   |   12 +
 libmultipath/structs.h                   |    2 +
 libmultipath/structs_vec.c               |   50 +-
 libmultipath/structs_vec.h               |    2 +
 libmultipath/valid.c                     |    2 +-
 libmultipath/wwids.c                     |    2 +-
 multipath/11-dm-mpath.rules.in           |    4 +-
 multipath/main.c                         |   60 +-
 multipath/multipath.rules.in             |    6 +-
 multipathd/dmevents.c                    |    6 +-
 multipathd/main.c                        |   71 +-
 multipathd/multipathd.service.in         |    4 +-
 multipathd/waiter.c                      |    2 -
 tests/Makefile                           |    5 +-
 tests/alias.c                            |   32 +-
 tests/dmevents.c                         |   34 +-
 tests/mapinfo.c                          | 1121 ++++++++++++++++++++++
 tests/valid.c                            |   10 +-
 tests/wrap64.h                           |    9 +-
 39 files changed, 1916 insertions(+), 863 deletions(-)
 rename kpartx/{kpartx.rules => kpartx.rules.in} (96%)
 create mode 100644 tests/mapinfo.c

-- 
2.45.2

