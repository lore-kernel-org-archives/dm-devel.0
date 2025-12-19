Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5719E32E6A8
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155282; cv=none; b=HaiBu8iIpD5RmEOlL9+7zP4w/p/JliEvjXB8Z66AWzhLCLaRsPXxVHxn3RuS/8qibqQkYSA909dll2GzTxG8EQ6t8hWyuoKK0+jIITMZR4HJOfmcPGgPvkRjzGPRdFPjvO156ZEgKqPIaYe7J7Q4BQZ0fXwjTZdqpX6iO8PBexM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155282; c=relaxed/simple;
	bh=ZLoqQ4YAMyMQmI3EbhV8ew6sF/VtX5/hh1hhpW5UaXk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lvCNfDnsu20QtXMFTayLpDk1j5u9p+fVouXPlr+IPl1KqlQ0oIyT5CGLnwnd5QhzQ6hqeqSIgpVhiJllu1BBWO/s3cp7Ivl10/Sp9j0sx6RHuzMviGvdGaGPqSvsNT9XIGPVPEkdOwakDo0VM+Wt2PSLgzpH4AxBfuWa6jLIlLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=M6eocJqn; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="M6eocJqn"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64b8e5d1611so1311709a12.3
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155277; x=1766760077; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zY8S8Kf89OhFZiJlbdoYs1vUYlbHIP3lRLel2k19+Lk=;
        b=M6eocJqnwd/RpN1hFLTQ81L6J9uoU1w2xcRJqcaYkWBpYlUMcHmIL7pb9Q/H6IGIhr
         wiWglVrEcN2On0DoEAfsEp2Rr35QQPOi3yR/1tvDD0FGfkyINr2am25EqJ9NUnQJpVsW
         9ZPNNwlIbE5/PWHsnxS3woXtrKqRVmRS3Fbaime1LjZjbTqbLyvB6urE+Od7w0O6JYNQ
         qa/v0pzCVeNIxqoiinYr7IZfBdVBSsfmSnYFYEtsS3ioUJfqIGpPxN2/+7eEV7yvXA/4
         +LshAj8ID7C1mWpFFWiB5N0780EnZFhdhxqcNUh/ctbFJIcN+akB2Dt2Yx0nA7qtKzOv
         2mkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155277; x=1766760077;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zY8S8Kf89OhFZiJlbdoYs1vUYlbHIP3lRLel2k19+Lk=;
        b=mhK+8EU5uh4U5KT7BOMvo8BYtXKDfBbzTVUaqBjsb6M4yWwyhiB7H0visSZBiNa3A9
         kXR5wCSjtmpPf1SAh9MifElomwPQJ3gyj5QtftDBib5PXepp31rKHLHcWyLb/5wZoChN
         FlCy8bsmnfDLwme60/FraUaW0w67CK76fxGKqksf5BU6/VAWnjbx7fyy8r/KZNrv3bS/
         KI38s7rNtQGJdGg6EF6a0kiH/blnQ+HggB4w1aqP6hdGiYX7SNpVv5hUsAz8ubSMBv4R
         j/ExxOluX1sWaQm49nMT0mlQ3i6b7SxUl8dEwtvYuwc8SN4LYX0bB/QQgFqYM87dc7Tj
         2mMQ==
X-Gm-Message-State: AOJu0Yzcq9XsBNRyLTAf/CnXr7lB3dFmizDO1+KAn51t/qpN85F+1HIG
	KhGM1oxVS11c+mHG44clA600aq53om5HD9UQZqGa+TeBdXn4vm0DbQGEjUzWfo+IObU=
X-Gm-Gg: AY/fxX7AD7SacS4i/lss/xgMNDy+JzixpkzCOrt8L/amEcZ/86/j41rXsa7rcdOYN+H
	RhGvoPPe7IV5iJlierqj7XBfXfwTJo4Xd+lsAe6Kx8n6Qj4jHrRmHs/MaNGdbjAESYxF2PbH1nK
	SKqqrdhktpcUsxA5to4H0xN42NFDLeE+GZjhTHIfpWWXLSli/j7G/vpgYRc2galjSK/4oRpkeq7
	xs88sUX7PK6EOVFH4wgxrXYa8NstBZp/cN/AXREp4XLt4Hs2AbP9pNJh22kzaQ1zNXG9EDvOFv8
	aVQ/WhbmkHH8eygEVfh4SxKx7iPAfArIeTrtOyrb3+ukApZu8npRxjAQItJif3+w/9gvuFLHBe+
	28WbatKtDqwUZd5rlMWCHlRsqsnqwDEnCORtSDspx1ZBLVT5gjV0JFohRZ3LUQUdCxjj7GKROrx
	Cs/ER+/bHUkZX/JrxixIS/aMUP4RDS/BQZM4mP4K2ArEks70YpxZ/WTWQeD6JOG2sbnH+rriLWc
	Q==
X-Google-Smtp-Source: AGHT+IGhD7D9ZOki0XL39FNahbc3sdWpDhKI9RDa+n3wYXKpHyJnBrt+o9Fl3VaZCKYp49abFgWgpw==
X-Received: by 2002:a17:906:7315:b0:b73:398c:c5a7 with SMTP id a640c23a62f3a-b80371a7253mr298020066b.41.1766155277002;
        Fri, 19 Dec 2025 06:41:17 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b8037a61595sm251805366b.8.2025.12.19.06.41.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:16 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 00/26] Multipath-tools: various bug fixes
Date: Fri, 19 Dec 2025 15:40:42 +0100
Message-ID: <20251219144108.237928-1-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes v1 -> v2

Fixed the issues pointed out by Benjamin Marzinski in v1.

- paths are still removed in sync_paths(), as before. I added some comments
  lest we forget about this.
- in the checker loop, only orphan paths in REMOVED/PARTIAL state are freed
- removed the free_paths argument from free_multipath, and changed
  add_map_without_path and check_usable_paths() as suggested by Ben.
  free_multipath() doesn't free paths any more.
- the BITFIELD macro now creates a field of fixed length.
- fixed whitespace issues.

These changes required shuffling the patches around. Therefore I'm resending
the entire series. I kept Ben's Reviewed-by: trailers.

I also fixed some formatting issues reported by clang-format.
clang-format also changes context line of diffs, which I accepted.

v1 cover letter
---------------

(note: I did not fix the patch numbers)

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

Martin Wilck (26):
  libmultipath: drop drop_multipath
  libmultipath: don't access path members in free_pgvec()
  libmpathutil: constify find_slot()
  libmultipath: don't touch mpvec in remove_map()
  libmultipath: export orphan_paths()
  libmultipath: export cleanup_multipath()
  libmultipath: add cleanup_pathvec_and_free_paths()
  libmultipath: don't free paths in orphan_paths()
  multipathd: free orphaned paths in checker_finished()
  libmultipath: remove free_paths argument from free_pathgroup()
  libmultipath: remove free_paths argument from free_pgvec()
  libmultipath: remove free_paths argument from free_multipathvec()
  multipath: free paths through pathvec in check_usable_paths()
  multipathd: add_map_without_path(): orphan paths instead of freeing
    them
  libmultipath: remove free_paths argument from free_multipath()
  libmultipath: remove cleanup_multipath_and_paths()
  libmultipaths: annotate functions that may free paths
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
 libmpathutil/util.h                   |  49 +-
 libmpathutil/vector.c                 |   3 +-
 libmpathutil/vector.h                 |   2 +-
 libmpathvalid/mpath_valid.c           |   2 +-
 libmultipath/blacklist.c              |   2 +-
 libmultipath/blacklist.h              |   2 +-
 libmultipath/config.c                 |   2 +-
 libmultipath/configure.c              |  24 +-
 libmultipath/devmapper.c              |   2 +-
 libmultipath/dict.c                   |   2 +-
 libmultipath/discovery.c              |  44 +-
 libmultipath/dmparser.c               |   6 +-
 libmultipath/foreign.c                |   2 +-
 libmultipath/foreign.h                |   2 +-
 libmultipath/foreign/nvme.c           |   2 +-
 libmultipath/libmultipath.version     |   5 +-
 libmultipath/pgpolicies.c             |  14 +-
 libmultipath/print.c                  |   2 +-
 libmultipath/prio.c                   |   2 +-
 libmultipath/prioritizers/alua_rtpg.c |   2 +-
 libmultipath/prioritizers/ana.c       |   2 +-
 libmultipath/prkey.c                  |   4 +-
 libmultipath/prkey.h                  |   2 +-
 libmultipath/propsel.c                |   2 +-
 libmultipath/structs.c                |  82 +--
 libmultipath/structs.h                |  13 +-
 libmultipath/structs_vec.c            |  88 +--
 libmultipath/structs_vec.h            |   4 +-
 libmultipath/sysfs.c                  |   2 +-
 libmultipath/uevent.c                 |   2 +-
 libmultipath/valid.c                  |   2 +-
 mpathpersist/main.c                   |   2 +-
 multipath/main.c                      |  22 +-
 multipathd/cli_handlers.c             |   2 +-
 multipathd/fpin_handlers.c            |   2 +-
 multipathd/init_unwinder.c            |   4 +-
 multipathd/main.c                     |  59 +-
 tests/Makefile                        |  22 +-
 tests/alias.c                         |  50 +-
 tests/blacklist.c                     |   2 +-
 tests/cli.c                           |   8 +-
 tests/cmocka-compat.h                 |  16 +
 tests/devt.c                          |   6 +-
 tests/directio.c                      |  23 +-
 tests/dmevents.c                      |  74 +--
 tests/features.c                      |   2 +-
 tests/hwtable.c                       |   6 +-
 tests/mapinfo.c                       |  85 +--
 tests/mpathvalid.c                    |  18 +-
 tests/parser.c                        |   2 +-
 tests/pgpolicy.c                      |   4 +-
 tests/strbuf.c                        | 131 ++---
 tests/sysfs.c                         |  76 +--
 tests/test-lib.c                      |  95 ++--
 tests/test-log.c                      |  10 +-
 tests/uevent.c                        |   2 +-
 tests/unaligned.c                     |   8 +-
 tests/util.c                          | 123 ++--
 tests/valid.c                         |  30 +-
 tests/vpd.c                           |  12 +-
 77 files changed, 1748 insertions(+), 625 deletions(-)
 create mode 100644 libmpathutil/mt-libudev.c
 create mode 100644 libmpathutil/mt-libudev.h
 create mode 100644 libmpathutil/mt-udev-wrap.h
 create mode 100644 tests/cmocka-compat.h

-- 
2.52.0

