Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E163CF74
	for <dm-devel@lists.linux.dev>; Mon, 22 Jul 2024 23:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721690596; cv=none; b=UcYD9lVd9dmHXFn/UHkL9HnFpXiZeEBolGClzCOKc1a0b1dDeVFJ3vaeoZot/opca9zLyV4I4w+Qam0WlMzdsw5NRj6/7aeNGtlYO9StUtXD93NaIWWXfWF2Nai8A4QcvmyJhN2rPSTBErq3sefoSEXp9KDYsHPjDSIc0rAut78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721690596; c=relaxed/simple;
	bh=DMzNWrnLx6uwcUSuEYN4IbX+W5RVvmRSnRABc4GGTck=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=O7+31sBCY87l5PC3LyyGFxYwRl19a4H/jfojKmHS4M917JOY2hfg1dfjlZ5mgFddrzlgygwmoCHvhM+yb91UNf+dwX+bqU7Goodv0+wuePrWkZyy13V6wTZwi6n8IMPOP6xCpiE7Gf30o9scd99Ou4qW4QpYCdJ61jlOY24XAQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZmThcXQV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZmThcXQV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721690593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Y9rX9CzTJRRFDODWVrbXt73hpaALRjB2mtsXUatGiDw=;
	b=ZmThcXQVlGOATe2RO2vw6c55et8B56fVahqlAmlfAS6l/ExPgtvrDg3+XpqovK3Ot1fvit
	h8t2luL4C+uRxsphg6pJWQpTRP33VREvdIregFsxigWhM0qjq5GOl8B5LbBA1KC66rJhMa
	fLyMf/6PkbwQOnm6KIedtErrEDbLbDI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-628-0zz-mqbSOKOld08dVIuZKg-1; Mon,
 22 Jul 2024 19:23:12 -0400
X-MC-Unique: 0zz-mqbSOKOld08dVIuZKg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EADF319560AB;
	Mon, 22 Jul 2024 23:23:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6D62E195605A;
	Mon, 22 Jul 2024 23:23:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46MNN8tv2495968
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Jul 2024 19:23:09 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46MNN8QD2495967;
	Mon, 22 Jul 2024 19:23:08 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v3 00/20] path checker refactor and misc fixes
Date: Mon, 22 Jul 2024 19:23:05 -0400
Message-ID: <20240722232308.2495956-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

his patchset is based on discussions I had with Martin Wilck about my
last, partially applied patchset. It's based on top of his
mwilck/coverity branch, 27053732 fixup '"libmultipath: use
libmp_pathinfo() in update_multipath_table()"'.

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

Changes in v3 (only posting the patches that have changed):
10: adapt to 27053732 'fixup "libmultipath: use libmp_pathinfo() in
    update_multipath_table()"'. This is identical to 1d564df4
    ("multipathd: adjust when mpp is synced with the kernel") on
    mwilck/tip.
11: fix commit message (Martin)
17: use symbolic return code (Martin)


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

