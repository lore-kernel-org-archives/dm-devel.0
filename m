Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C3E17D6
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817124; cv=none; b=oITMinVOgsj9MrZNnjO+iAP8gIRyiCmLRkAicZ8Dm1HA2Ap0gbO2aMpWMe/mCW2t69IRrTj1E66tZu9NbC9nO/EEUpQL8WhCe2MCQo/P+lqNb8a8j/1lsHXcuU5wKqWu87H6ZmNvlL+cG1SNLOImIDC0MZEFwwEyTUIK5ikuwgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817124; c=relaxed/simple;
	bh=wBDWC8o0nPw+EimipWBj0CP5xjO6wA/8bb1oni5akYY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WOXlcPyVZmKwVAePN46J/QJyBQvIBnC3by5hlYa1MIbrN+IUVLO4/+3V55OWFKih/89kvlO+PvNjl3Ey6kdzNeY/8EwBL0IKjj6HctoibU3uJgFYz9klc84XU1oOOtL04wcdOkGv17tw0VEPFtTtc8bxELVLupR+Xxcf+tgPbic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ct9S3Zay; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ct9S3Zay"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b7a02592efaso416917466b.1
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817120; x=1768421920; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZB3WtjZXLke1ydysGTOa2Jvcc+nXQiINMyqP3vCeArY=;
        b=Ct9S3Zay/ifTW38af5p7fZwikoQWcDl26sd/TDo6ZtyAX/cglLFk68IuH54cX7PZmL
         Lq1hTKMUMVebCEOeR8jfLDYsqfeYlYgIuvbusuvOMRD15CMd8NJStDzNAVQbHLKkfTo3
         j73zRheL6fFaNr890oA2zFZTH2ZZO/VfV6lE4YnTVnNx0+eddwML7V/RJBkEdb2zIud3
         UlZiBHo0pZTkRmwgD2sqRudvlc5dR1chfT1oKGSfirxNHv1HWZE1GlpUOj4mdowYDqOV
         otNy0EYXE5KT2/LA8HHZo1jPw0M7cAUyugo1FFjFyj0159BWQnBdJZE6NWcdVyd0rVp+
         /VEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817120; x=1768421920;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZB3WtjZXLke1ydysGTOa2Jvcc+nXQiINMyqP3vCeArY=;
        b=qGANEnDxMAhPTgzZzhgaE0ntXyvHTxaeK0Fz+bQ6lSswUo5uUDUYnpZ3Gg4BNF6Ok/
         c0B5NIWh81vvPTH4Uth6wPB0TRR56QAYbiTntGfVEC4XLCjH57wIa/+8UzRel+xLUsxu
         YG+tzYu11Q4uNVfZFaTf+Obc5+yxrBBL7S1+cK7jUle1SAtyXgAg0xnSpRjjXl3ujU4p
         sH7A4LF10ERo824V1c17mLWuH4WQD7XHR7lV9umLk4BKJPmDMc1GieNQJXZcKTWbr5UL
         jF0BBHZeIUh9nta3SyjWWUfc01vZdaJe2XhdacLJw57DdLsrDZ5MVNdGvmkZQ1QNfhma
         6Ncg==
X-Gm-Message-State: AOJu0Yz3ei/w5OLrzcSciPzYhvoRMgeTaktS3bAW7w33FiXWs1sbZbcp
	enQdcfvxKUDNvDu//bSIKGxNIH+MZkw0kVL/akv37bG78LAmBooezp35cGM50O6E/Fg=
X-Gm-Gg: AY/fxX56Zb/8VDcgQg+gbKZBaxrwDYlUZ7bssSfq6RYdC1Em2n+SHbq3LBvZdOBx6Bo
	t97YAl/FLyXE7QLjIMAk0UhElkEWBH2Ck/dHhb0kSlgpftbHPThHmGFQ5LkY9zpCbrK/fhSdbtF
	apPTLJ/mKJTcexa+EOe6oIOb9VDMmhlIYet2ImD2vkEEuEzOp7KAzGJAo5xYjxOCcbzxEGTT6IS
	83t+9wGk3Dz7BKgc5xG+B0vYd8mrDZy7AcInFKpnvVoHY/3NKI4aqitkm/qk/z0ncfExkeV75hV
	nC9bpFhJ1xnUqnLvjvYHpcJg8mxPimeHti2+NJRcWcxVTA3kDN/6iXZLk+A27er/9fDZ/sLlKbz
	0P0aQNf7wjkcbQjeNy3da2FHUrqQ8CmldpOXf5bwvIx309fizNnFu43JTvGvE4+p+xxnv9TLk3B
	VnH/svOKZ7pOIj+5zwjDwB3ZvFVUiKNtTDRTL3cCWNh16kw4gekf71ZsOtswLCmf/zlEeQSSv0P
	w==
X-Google-Smtp-Source: AGHT+IHsNDfga1GPJxyPvrd0GGbJh/nT7FXvU44P+dht4/cc8NcC28nMfiYJrIrF1V5aru14jVpVMw==
X-Received: by 2002:a17:907:96a1:b0:b6d:9576:3890 with SMTP id a640c23a62f3a-b8444f9664fmr337176666b.45.1767817120094;
        Wed, 07 Jan 2026 12:18:40 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b842a4cfd97sm576189766b.36.2026.01.07.12.18.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:18:39 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 00/26] Multipath-tools: various bug fixes
Date: Wed,  7 Jan 2026 21:18:00 +0100
Message-ID: <20260107201826.323977-1-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes v2 -> v3

- 05/26: dropped, orphan_paths doesn't need to be exported in v3
  subsequent numbering changes accordingly.
- 12/26: do make sure in free_multipath() that this mpp isn't referenced any more
- 13/26: new, another cleanup for the multipath freeing code
- 14/26: to avoid the UAF pointed out by Ben in [4], change the order of definitions
- 15/26: orphaning is now done in free_multipath() (see 12/26)

[4] https://lore.kernel.org/dm-devel/aUYpC_LaTHXIUkVU@redhat.com/T/#mbb46f26895f6626f6d965269691133f85875cc77

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
  libmultipath: export cleanup_multipath()
  libmultipath: add cleanup_pathvec_and_free_paths()
  libmultipath: don't free paths in orphan_paths()
  multipathd: free orphaned paths in checker_finished()
  libmultipath: remove free_paths argument from free_pathgroup()
  libmultipath: remove free_paths argument from free_pgvec()
  libmultipath: remove free_paths argument from free_multipathvec()
  libmultipath: remove free_paths argument from free_multipath()
  libmultipath: don't free mpp->pg and mpp->paths in remove_map()
  multipath: free paths through pathvec in check_usable_paths()
  multipathd: add_map_without_path(): don't free paths
  libmultipath: remove cleanup_multipath_and_paths()
  libmultipath: annotate functions that may free paths
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
 libmultipath/libmultipath.version     |   4 +-
 libmultipath/pgpolicies.c             |  14 +-
 libmultipath/print.c                  |   2 +-
 libmultipath/prio.c                   |   2 +-
 libmultipath/prioritizers/alua_rtpg.c |   2 +-
 libmultipath/prioritizers/ana.c       |   2 +-
 libmultipath/prkey.c                  |   4 +-
 libmultipath/prkey.h                  |   2 +-
 libmultipath/propsel.c                |   2 +-
 libmultipath/structs.c                |  94 +---
 libmultipath/structs.h                |  13 +-
 libmultipath/structs_vec.c            |  92 +--
 libmultipath/structs_vec.h            |   3 +-
 libmultipath/sysfs.c                  |   2 +-
 libmultipath/uevent.c                 |   2 +-
 libmultipath/valid.c                  |   2 +-
 mpathpersist/main.c                   |   2 +-
 multipath/main.c                      |  27 +-
 multipathd/cli_handlers.c             |   2 +-
 multipathd/fpin_handlers.c            |   2 +-
 multipathd/init_unwinder.c            |   4 +-
 multipathd/main.c                     |  57 +-
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
 77 files changed, 1762 insertions(+), 628 deletions(-)
 create mode 100644 libmpathutil/mt-libudev.c
 create mode 100644 libmpathutil/mt-libudev.h
 create mode 100644 libmpathutil/mt-udev-wrap.h
 create mode 100644 tests/cmocka-compat.h

-- 
2.52.0

