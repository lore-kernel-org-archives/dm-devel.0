Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBE57470
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 18:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721239877; cv=none; b=N/V3pI72ahhtd2leGX48tT6t54SJ8TFRR8bjxZTxxxvskwzG/Gw8TP9qesflesNMk6Uus4/68jk/OC1Ie015NI6SC0DyrDLUj3ktNuV8XJ8fQIqX6sIEKaJOMTbVanLZKYmACYBh6cmcA0w/o2KQ0OQ9uohKJR7a+k0WyfvsReU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721239877; c=relaxed/simple;
	bh=yEwD/DYdFZRs+64PAHpbEU4ocTpWGQ/27GuU22x37ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eLjvVo7r1qtuiD02ZdmGY50Os9R1f1uCDoX9aoLpjJy2CnZEbP5NgRFF4/ZnruxCfYISctn3+sUiFk2nhqskWb0qi9cPH7VbaGFlS0p8CDPKY0dK/80kpdTrtqiNPCVESqMu0SnNWY7aCNcTzRPcdMtrl52TiykCsV4hrE1r4v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BnT0XeRz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BnT0XeRz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721239874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4NGN03l+rlfzmWLUyBPlFp00/WC7z0F+ySMpiOkWOlw=;
	b=BnT0XeRzNkgB0CfwaI6rkRxyeRfrKOlklQvloKaM3XCvVRKw3/zfyypZYE6ckWx00ofj8R
	VhF1cU3wBV9wafZtOpugygqInPk9/ObTjeKUzB7T+eWbLqXIdtKlP5Fn3lb1FYXu9j6WOc
	ImT3gOWKdDNZWaHWOCIVaXFocKP+4OE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-127-Ko8txbNTMACEAu_y9nFewg-1; Wed,
 17 Jul 2024 14:11:10 -0400
X-MC-Unique: Ko8txbNTMACEAu_y9nFewg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 230171955D4C;
	Wed, 17 Jul 2024 18:11:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A015C3000185;
	Wed, 17 Jul 2024 18:11:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46HIB7Pb2173556
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 17 Jul 2024 14:11:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46HIB6cO2173555;
	Wed, 17 Jul 2024 14:11:06 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 00/20] path checker refactor and misc fixes
Date: Wed, 17 Jul 2024 14:10:46 -0400
Message-ID: <20240717181106.2173527-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

This patchset is based on discussions I had with Martin Wilck about my
last, partially applied patchset. It's based on top of his mwilck-tip
branch, 4ef98926 "fixup! Makefile: add targets for test-progs.cpio and
test-progs.tar". These patches are mostly orthogonal to the
libmp_mapinfo() work. I'll rebase them if further changes to that
patchset stop them form applying cleanly.

The first two patches are reposts of patches from my earlier patchset,
redone to work with the new libmp_mapinfo() API. They make it possible
to add maps by WWID with "multipathd add map".

The rest of the patches are work and bugfixes related to refactoring
checkerloop so that

1. multipath devices get resynced with the kernel occasionally, even if
they have not paths

2. If multiple paths from a multipath device are checked in the same
loop, the multipath device will only get resynced once.

3. All the paths of a multipath device will converge to being checked at
the same time (at least as much as their differing checkint values will
allow).

4. The times for checking the paths of each multipath device will spread
out as much as possible so multipathd doesn't do all of it's checking in
a burst.

5. path checking is done my multipath device (for initialized paths,
the uninitialized paths are handled after all the adopted paths are
handled).

Items 1 & 2 are handled by patch 10 and preceding patches.

Items 3 & 4 and handled by patch 17 and preceding patches.

Item 5 is handled by patch 18 and 19.

Changes in v2 (old patch number in quotes):
01: change from returning minor number to dm info (Martin)
02: adapt to change in patch 01
05 (05-07): squash into one commit (Martin)
08 (10): fix commit message (Matin)
10 (12): rename do_check_mpp amd check_mpp
11 (13): move the code that saved the path name to right before it was
         removed (Martin)
14 (16): use symbolic return codes (Martin)
15 (17): set path state to PATH_UNCHECKED when orphaned, and skip paths
         in INIT_REMOVED in sync_map_state() (Martin)
17 (19): clear pp->pending_ticks in check_path() if the path is delayed
         instead of pending. Use a different equation to check if we
         need to modify the ticks, that can adjust the ticks on every
         check. adapt to change in patch 14
18 (20): adapt to change in patch 14
19 (21): adapt to change in patch 10 and 14
20 (22): Add fixes trailer

Benjamin Marzinski (20):
  libmultipath: rename dm_map_present_by_wwid() and add outputs
  multipathd: make cli_add_map() handle adding maps by WWID correctly
  multipathd: remove checker restart optimization
  multipathd: refactor path state getting code into a helper
  multipathd: handle uninitialized paths in new function
  multipathd: check paths immediately after failing udev initialization
  multipathd: set pp->tick = max_checkint in handle_uninitialized_path
  multipathd: return 0 from check_path() if that path wasn't checked
  multipathd: reorder path state checks
  multipathd: adjust when mpp is synced with the kernel
  multipathd: resync map after setup_map in ev_remove_path
  multipathd: resync map after setup_map in resize_map
  multipathd: always resync map in reload_and_sync_map
  multipathd: correctly handle paths removed for a wwid change
  multipathd: handle changed wwid when adding partial path
  multipathd: don't read conf->checkint twice in check_path
  multipathd: make multipath devices manage their path check times
  multipathd: factor out actual path checking loop from checkerloop
  multipathd: check paths in order by mpp
  multipathd: clean up the correct wwid in check_path_wwid_change

 libmultipath/config.c             |  12 +
 libmultipath/config.h             |   1 +
 libmultipath/configure.c          |   1 +
 libmultipath/devmapper.c          |   5 +-
 libmultipath/devmapper.h          |   2 +-
 libmultipath/libmultipath.version |   5 +
 libmultipath/structs.c            |   2 +
 libmultipath/structs.h            |   3 +
 libmultipath/structs_vec.c        |   9 +-
 libmultipath/valid.c              |   2 +-
 multipathd/cli_handlers.c         |  66 ++--
 multipathd/main.c                 | 582 +++++++++++++++++++-----------
 multipathd/main.h                 |   2 +-
 tests/valid.c                     |  13 +-
 14 files changed, 432 insertions(+), 273 deletions(-)

-- 
2.45.0

