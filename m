Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86231DDA18
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 21:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006485; cv=none; b=W5cjTylMk9T822hSllw46B8FXyYAv2C3XYhY2sEg/qjW1GamqYWTJp3TfxH8sZ9qKgofwhVuB6zCBtak9up0lbqxRjbYrTpzw8lzD1UNzK4rwHs/GVyS8vvpJmiVR6BxXoq/rdLUiY5+rzMdKMjSffgvJJidp7tl6oY4tADb24Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006485; c=relaxed/simple;
	bh=KvMV1BVMfU1Xl1d5Aezi91VNcQ3WSJFkkomMUxyA2p0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Oi77V5EwZJnlc/oPrVyJG9zEoUWsZIvXNztgZhaJrfBDdqjsMils3sokyYDTsjTHpyojXoXZJViSL1Xbj0QDdjEorNh7ByMZLK5xWDevpgISqcV8myUFtleSyhYJnChRSonOVHF6lah7P2p1z0ytE2ka80Cgrlh7OElb4/2ieUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ANKlCmkZ; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ANKlCmkZ"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-64b4f730a02so972548a12.0
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 13:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766006481; x=1766611281; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jSFdouv2l8AbD43Sak2nwSvvnDkvP4ycHoC63SluMwo=;
        b=ANKlCmkZiU+YDUXIEWtyzPw2kzu5JsXHSAZLtO5U30zQvOpP5ip9WS7vpZ6M9SzRSH
         g2Ygc66j5B7O96c1aAY133m3dN/cxUPvffKBJ62P2BbqezBsJFn5ha/LFgE1R31n8bMJ
         Y6maaCRS6q1Yk/BR9SxqUyc6I3dvQN/lXjCJ31n/B+aAilgcdPd9BpGExjGHd2b6PTgH
         amWVmxxTkRDo9s4Z7rec6qifwkIh2S802sc+L8IyhnkjTF71nAC5QyCjhXw1tBA27M15
         3Qn5g6uWfP6r2ZdIhpcr2d7ddVUl/v6jqB1n3F/m6Vwb91ZdP4Tt9c/zENkwu6Zei4i2
         6Ijw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006481; x=1766611281;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jSFdouv2l8AbD43Sak2nwSvvnDkvP4ycHoC63SluMwo=;
        b=Ix72xOp8mpPrgQci75TklsI2ksRXaAmFzsAyjpVmQS27HTrKWI8rtdttNylVwxfqLm
         O0uhhHlLnr200yJg9Ul0Akdd1W1QpALA4hhDIVhCNoCTILjIwejr0SvFCNOVA4Aqt8u/
         JU6QiFEiWJTozLaddQrGOHej15zonDr1F16x66kCtcoOPNCsvwgRLCr8a8vnU6RuQVsE
         q5o0Ah41lEHeKJ73TPuwxMi7UDJl9AH2XM9Sm2RviTStZUGxs8idthP+EC+4AL9AUcUw
         a5PDjVPX9LJGllbJjnX6iqK5H6GQLZjdFJK3spKkXXdqv62oWyKskkmAn3aMEvxjlFpK
         MqnQ==
X-Gm-Message-State: AOJu0Yy5Z8e7LBlop5JXM8CBjiBo30FqQtnGALiJlt8y2k4p1ZrVC/al
	RYA128jLMiCJRyWJpxF38nYT8b4d/XFuI+b9/OsSgO4lUcP5TVGpADfu4GF9Aia60ww=
X-Gm-Gg: AY/fxX5Im93Xxz06hmvTCXwUdjXSTTaz1hXPyzbiopLQ0DSyHdICsF+263Hg6bW9pFb
	GeMXR8QVL/6amXG8Pkv+cMTbR3VreDlvhjeEpK7Eomh+43oCohwPNNjfOfnSj2WWh8rUDZcUMoJ
	QSK1sNJKv32pCciOaEEA+I7SucEcYrZ6qXmZ+yBi5muRR1wO5uhrRO0YprNgDyoxZuoXkTythV9
	fySJ0MT/sYwti+GPWJ7PpQCnm5ZmHHt6350kHTtfM3h13Q6FCVDwsfZgNceu9hho1bSdN+oTF6e
	4cBxWo9/0XtOZgU/rJlwiCgu+nFs6AUkg+cY0mGTKNgwayAUGf+SeAaDsXaCOgJu9RKRxpmm+i0
	4PtwpemIXvtVTgMRPa9Lq1dwdIh6POdJnxAbQNMxdtZHmEGz2bjioMXKX0uWOIMNQjdR/Z2C07O
	1wlz2gMLWIXE+aEh2uPOSqMuCIizruMbQm3BAC9knZNU6xkJni5md9E7TTW22llEY+herQrmWyQ
	w==
X-Google-Smtp-Source: AGHT+IH3Q+gqgZQNKgsAq2+31lQTzpa9e9xe3VdJqgL/2HdMamr93ANJ/SlMhEtlIL4sV9zm73WBbA==
X-Received: by 2002:a17:907:96a4:b0:b7a:1bdb:30d9 with SMTP id a640c23a62f3a-b7d23ac8995mr1790616666b.65.1766006480911;
        Wed, 17 Dec 2025 13:21:20 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b8023466e85sm26808766b.36.2025.12.17.13.21.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 13:21:20 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 00/21] Multipath-tools: various bug fixes
Date: Wed, 17 Dec 2025 22:20:52 +0100
Message-ID: <20251217212113.234959-1-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series contains a number of fixes for various recent issues with
multipath-tools. The starting point was a use-after-free issue reported on
GitHub [1]. The actual fixes for that are 02/21 and 06/21. Because this
Patches 3-12 generally rework the freeing of maps, trying to avoid unexpected
freeing of paths while freeing multipath structures.

Because this changes memory handling in multipathd, I ran a set of tests to
make sure the series doesn't open up new memory leaks. The good news is that I
haven't found any, except some trivial ones (15/21, 16/21). But I did see one
minor issue related to libudev [2]. After I found a warning in the libudev man
page about the library not being thread-safe, I suspected that this might be
causing the leak, and came up with code wrapping all libudev calls with a
mutex (18/21, 19/21).  Unfortunately it didn't fix the observed leak, but I
suppose it's still useful because multipathd is using libudev in a way that
the authors of the library explicitly dismiss as unsupported.

The release of cmocka 2.0 [3] necessitated rather large-ish adaptations in our
unit test code (20/21, 21/21).

Finally 13/21 and 17/21 are bug fixes; in particular the latter is rather nasty.

[1] https://github.com/opensvc/multipath-tools/issues/128
[2] https://github.com/opensvc/multipath-tools/issues/130
[3] https://github.com/opensvc/multipath-tools/issues/129

Martin Wilck (21):
  libmultipath: drop drop_multipath
  libmultipath: don't access path members in free_pgvec()
  multipathd: free paths in checker_finished()
  libmultipath: don't touch mpvec in remove_map()
  libmpathutil: constify find_slot()
  libmultipath: don't free paths in orphan_paths()
  libmultipath: free orphaned paths in check_removed_paths()
  libmultipath: remove free_paths argument from free_pathgroup()
  libmultipath: fix numeric value of free_paths in free_multipaths()
  libmultipath: remove free_paths argument from free_pgvec()
  libmultipath: remove free_paths argument from free_multipathvec()
  libmultipath: free_multipath: fix FREE_PATHS case
  multipath-tools: Fix ISO C23 errors with strchr()
  libmultipath: simplify sysfs_get_target_nodename()
  multipathd: join the init_unwinder dummy thread
  kpartx: fix some memory leaks
  libmpathutil: use union for bitfield
  libmpathutil: add wrapper code for libudev
  multipath-tools: use the libudev wrapper functions
  Makefile: add functionality to determine cmocka version
  multipath-tools tests: adaptations for cmocka 2.0

 Makefile.inc                          |   2 +-
 create-config.mk                      |   5 +
 kpartx/kpartx.c                       |  18 +-
 libdmmp/Makefile                      |   2 +-
 libdmmp/libdmmp.c                     |   2 +-
 libmpathpersist/mpath_persist.c       |   2 +-
 libmpathpersist/mpath_persist_int.c   |   2 +-
 libmpathpersist/mpath_pr_ioctl.c      |   2 +-
 libmpathpersist/mpath_updatepr.c      |   2 +-
 libmpathutil/Makefile                 |   2 +-
 libmpathutil/globals.c                |   2 +-
 libmpathutil/libmpathutil.version     |  62 ++
 libmpathutil/mt-libudev.c             | 776 ++++++++++++++++++++++++++
 libmpathutil/mt-libudev.h             | 120 ++++
 libmpathutil/mt-udev-wrap.h           |  90 +++
 libmpathutil/parser.c                 |   2 +-
 libmpathutil/util.c                   |  12 +-
 libmpathutil/util.h                   |  43 +-
 libmpathutil/vector.c                 |   3 +-
 libmpathutil/vector.h                 |   2 +-
 libmpathvalid/mpath_valid.c           |   2 +-
 libmultipath/blacklist.c              |   2 +-
 libmultipath/blacklist.h              |   2 +-
 libmultipath/config.c                 |   2 +-
 libmultipath/configure.c              |  22 +-
 libmultipath/dict.c                   |   2 +-
 libmultipath/discovery.c              |  36 +-
 libmultipath/dmparser.c               |   6 +-
 libmultipath/foreign.c                |   2 +-
 libmultipath/foreign.h                |   2 +-
 libmultipath/foreign/nvme.c           |   2 +-
 libmultipath/libmultipath.version     |   2 +
 libmultipath/pgpolicies.c             |  14 +-
 libmultipath/print.c                  |   2 +-
 libmultipath/prio.c                   |   2 +-
 libmultipath/prioritizers/alua_rtpg.c |   2 +-
 libmultipath/prioritizers/ana.c       |   2 +-
 libmultipath/prkey.c                  |   4 +-
 libmultipath/prkey.h                  |   2 +-
 libmultipath/propsel.c                |   2 +-
 libmultipath/structs.c                |  94 ++--
 libmultipath/structs.h                |   7 +-
 libmultipath/structs_vec.c            |  58 +-
 libmultipath/structs_vec.h            |   4 +-
 libmultipath/sysfs.c                  |   2 +-
 libmultipath/uevent.c                 |   2 +-
 libmultipath/valid.c                  |   2 +-
 mpathpersist/main.c                   |   2 +-
 multipath/main.c                      |  16 +-
 multipathd/cli_handlers.c             |   2 +-
 multipathd/fpin_handlers.c            |   2 +-
 multipathd/init_unwinder.c            |   4 +-
 multipathd/main.c                     |  20 +-
 tests/Makefile                        |  22 +-
 tests/alias.c                         |  44 +-
 tests/blacklist.c                     |   2 +-
 tests/cli.c                           |   8 +-
 tests/cmocka-compat.h                 |  16 +
 tests/devt.c                          |   6 +-
 tests/directio.c                      |  23 +-
 tests/dmevents.c                      |  74 +--
 tests/features.c                      |   2 +-
 tests/hwtable.c                       |   6 +-
 tests/mapinfo.c                       |  82 +--
 tests/mpathvalid.c                    |  18 +-
 tests/parser.c                        |   2 +-
 tests/pgpolicy.c                      |   4 +-
 tests/strbuf.c                        | 130 ++---
 tests/sysfs.c                         |  76 +--
 tests/test-lib.c                      |  90 +--
 tests/test-log.c                      |  10 +-
 tests/uevent.c                        |   2 +-
 tests/unaligned.c                     |   8 +-
 tests/util.c                          | 116 ++--
 tests/valid.c                         |  30 +-
 tests/vpd.c                           |  12 +-
 76 files changed, 1680 insertions(+), 581 deletions(-)
 create mode 100644 libmpathutil/mt-libudev.c
 create mode 100644 libmpathutil/mt-libudev.h
 create mode 100644 libmpathutil/mt-udev-wrap.h
 create mode 100644 tests/cmocka-compat.h

-- 
2.52.0

