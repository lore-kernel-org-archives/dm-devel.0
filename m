Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E201714A9
	for <dm-devel@lists.linux.dev>; Tue, 15 Oct 2024 03:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728962927; cv=none; b=t1x8MUS1j/7rq1nBEwH+Lcqrbt3TVQhnZh8gJN8ElOiRDOgo/UuyAoYkqpG1+128V7vuE1iYprAwwhqK5SY/OPzdFdnuX4sYEI6qkFwY6I3CzuXw90+Mg+JgVr4cf1ABYrzOYK39JHiE1JLzCBjt5YsXsKVwQ0jesJ0LCwAceUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728962927; c=relaxed/simple;
	bh=Pi1qPJ5e9Iroj3F3734ejzbW2NR2gd4YJJp72kyki1o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ODIyVn7ud18/rcqyWwfEAbe+QaATrv6M8JxN3W7Q4exB4M/P90vtJL7ZrABO7gPvmlgqPRvRlqZu/qkWbxqwN+s5Of6TyMoIy7+UAC9uCC91RlQGX9Kn/khM83NII14e+JpGC9vpPQgcLOTyM2wxIREctePKpL72g3gi2Y+wEN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ePYBkneP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ePYBkneP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728962921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CqyrWfK3zFp5uf2YrjRa55wyiHZqU/TEQODZ+TuKX4Q=;
	b=ePYBknePBxdhmIc0E3seNHoTy+7TLXIYDYAqcj0XV1XArMnKISALK0WwoEo4yTnOcdu33w
	OPpTqOksO2CHTJNiUT0iMNMVsrvD/3FLuLw2+Cnx8OdXDq/DCy7rwYG/rPbWez90QiumB5
	2NRuLELXMVpzwWp+f8Uc6e7nYG0/DRM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-204-yS4iTRjtMJCSD8tqFsZsSQ-1; Mon,
 14 Oct 2024 23:28:38 -0400
X-MC-Unique: yS4iTRjtMJCSD8tqFsZsSQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8CDD31956096;
	Tue, 15 Oct 2024 03:28:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 570363000198;
	Tue, 15 Oct 2024 03:28:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49F3SZJS2693279
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 23:28:35 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49F3SZTm2693278;
	Mon, 14 Oct 2024 23:28:35 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v5 00/23] path checker refactor and misc fixes
Date: Mon, 14 Oct 2024 23:28:12 -0400
Message-ID: <20241015032835.2693247-1-bmarzins@redhat.com>
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
last, partially applied patchset.

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

Changes in v5 (all from Martin's suggestions):
19: Changed checker variable name from ct->waited_for to
    ct->checked_state
23: New patch to change the directio checker to use timestamps to
    check for timeout.

Changes in v4 (all from Martin's suggestions):
09: Changed commit message and fixed incorrect comment
10: Moved getting checkint from config to the if clause where its used
11 & 12: Moved setting pp->checkint from 12 to 11
14: Added comment about when refresh_all is set.

Changes in v3:
0: adapt to 27053732 'fixup "libmultipath: use libmp_pathinfo() in
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

Benjamin Marzinski (23):
  libmultipath: store checker_check() result in checker struct
  libmultipath: add missing checker function prototypes
  libmultipath: split out the code to wait for pending checkers
  libmultipath: remove pending wait code from libcheck_check calls
  multipath-tools tests: fix up directio tests
  libmultipath: split get_state into two functions
  libmultipath: change path_offline to path_sysfs_state
  multipathd: split check_path_state into two functions
  multipathd: rename do_check_path to update_path_state
  multipathd: split check_path into two functions
  multipathd: split handle_uninitialized_path into two functions
  multipathd: split check_paths into two functions
  multipathd: fix "fail path" and "reinstate path" commands
  multipathd: update priority once after updating all paths
  multipathd: simplify checking for followover_should_failback
  multipathd: only refresh prios on PATH_UP and PATH_GHOST
  multipathd: remove pointless check
  multipathd: fix deferred_failback_tick for reload removes
  libmultipath: add libcheck_need_wait checker function
  libmultipath: don't wait in libcheck_pending
  multipathd: wait for checkers to complete
  multipath-tools tests: fix up directio tests
  multipathd: use timestamps to tell when the directio checker timed out

 libmultipath/checkers.c           |  47 +++-
 libmultipath/checkers.h           |  10 +-
 libmultipath/checkers/directio.c  | 177 +++++++++----
 libmultipath/checkers/tur.c       |  79 +++---
 libmultipath/discovery.c          |  97 ++++---
 libmultipath/discovery.h          |   6 +-
 libmultipath/libmultipath.version |   4 +-
 libmultipath/print.c              |   2 +-
 libmultipath/propsel.c            |   1 +
 libmultipath/structs.h            |  21 +-
 multipathd/cli_handlers.c         |   1 +
 multipathd/main.c                 | 409 ++++++++++++++++++------------
 tests/directio.c                  | 182 +++++++++----
 13 files changed, 676 insertions(+), 360 deletions(-)

-- 
2.45.0

