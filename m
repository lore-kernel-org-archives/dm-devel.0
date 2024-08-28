Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848631AD9D7
	for <dm-devel@lists.linux.dev>; Wed, 28 Aug 2024 22:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724883488; cv=none; b=P1Hjkwbzt8R9i5uqbQZSVrDGa+Xu7nd+QgbnlQrXnOG9kBBxsud4HJY6eBiiZ8R1IwKi1Uhj7MGzRrtiHgPlwEYwET6fUlgWDIMrSQUEWiujBqwHhXGVCdr7EuPlDq2iNOJWRcUt6QicIDVsMKh1N+p/K0DXvBiFSxiYIpjhGFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724883488; c=relaxed/simple;
	bh=shEio/zfvXN8pC+Qk0cFvLnbEhzHWJ9ad5AAtGTTO1k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qsAwBzrJiL7zwV8cEi4VPD/aPH5EuWG2Fmtb7rBYRn9nAVhY8xbNBXMVyKYiuJoQ7Z30N3d4ZYnxQMet1UYETVSPGL1LkPaQNmAGbeQt7h7408wJT3aEQiEiHUYGwyeNmuGCmKgoOp/yJ3bkFTqfMztWnOQ2PGuzcbP0n7/k91Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WQ7o/H6L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WQ7o/H6L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724883485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fPcjkRZhg6psl313m0yEzdfMUvCO6Sl0Zr6PoE4n2DQ=;
	b=WQ7o/H6LavPWownTfANB13w9luODQoIFaGl8IK20r7m/Q7Bx0Y/sVFxwwzHm0BD3cwHkXb
	eqvZsl4tV/XjpoXdMj+uy1EqDgd9gvBmbt4kcVT5oVKH3FQzMqwyggcMtMCBA+hFZIE6qK
	Qy3QzLyU2s0YpWyacEs04AI1FxcuXP4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-460-WznEbtrjPjySBtaiVZmv-g-1; Wed,
 28 Aug 2024 18:18:00 -0400
X-MC-Unique: WznEbtrjPjySBtaiVZmv-g-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AFA291955D4D;
	Wed, 28 Aug 2024 22:17:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F06BE300019C;
	Wed, 28 Aug 2024 22:17:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 47SMHvgj4060572
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 28 Aug 2024 18:17:57 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 47SMHvbX4060571;
	Wed, 28 Aug 2024 18:17:57 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 00/15] Yet Another path checker refactor
Date: Wed, 28 Aug 2024 18:17:42 -0400
Message-ID: <20240828221757.4060548-1-bmarzins@redhat.com>
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

This patchset cleans up some of the ugly code from my last refactor, and
speeds up multipathd path checking, by refactoring how paths are
checked.

multipathd previously ran the checker on a path, waited briefly for it
to complete, and if it did, updated the path and the priorities for the
multipath device and possibly reloaded it.

This had multiple issues.
1. All the paths waited for their checkers to complete serially. This
wasted time with no benefit. It also meant that it wasn't that uncommon
for a checker to not finish in time, and get marked pending.

2. The prioritiers could get run on paths multiple times during a
checker loop if multiple paths were restored at the same time, which is
a common occurance.

3. In an effort to keep a multipath device's state consistent despite
the delays introduced by waiting for the path checkers, paths were
checked by multipath device. However checking the paths could involve
reloading a multipath device table, or even removing a multipath device.
This added some ugly backout and retry logic to the path check code.

With this patchset, the code now first starts the path checkers on all
devices due for a path check. Then it goes back and updates the state of
all the path devices, waiting at most a total of 1ms if there are
checkers that need waiting for. Once all of the paths have been updated,
it goes through each multipath device, updating path priorities and
reloading the device as necessary.

This allows multipathd to spend less time and do less redundant work
while checking paths, while making paths slightly more likely to not
spend a checker cycle marked as pending.

Since there isn't a delay waiting for the previous checker before
starting the next one, the path checker code has reverted to checking
all paths in pathvec order, instead of by multipath device. Updating the
paths in pathvec order simplifies the code, since the multipath devices
can change during path updates. Starting the checkers in pathvec order
keeps a path from having its checker started towards the end of the list
of paths but checking for the result towards the start of the list of
paths. However, it's possible to start the checkers by multipath device
without adding much complexity, if people think that the benfit of
starting the checkers as close together as possible outweighs the
benefit of giving each checker as close to the same amount of time as
possible to complete.

Benjamin Marzinski (15):
  libmultipath: store checker_check() result in checker struct
  libmultipath: add missing checker function prototypes
  libmultipath: split out the code to wait for pending checkers
  libmultipath: remove pending wait code from libcheck_check calls
  multipath-tools tests: fix up directio tests
  libmultipath: split get_state into two functions
  libmultipath: change path_offline to path_sysfs_state
  multipathd: split check_path_state into two functions
  multipathd: split do_checker_path
  multipathd: split check_path into two functions
  multipathd: split handle_uninitialized_path into two functions
  multipathd: split check_paths into two functions
  multipathd: update priority once after updating all paths
  multipathd: remove pointless check
  multipathd: fix deferred_failback_tick for reload removes

 libmultipath/checkers.c           |  35 +--
 libmultipath/checkers.h           |   8 +-
 libmultipath/checkers/directio.c  | 129 ++++++----
 libmultipath/checkers/tur.c       |  66 +++--
 libmultipath/discovery.c          |  90 ++++---
 libmultipath/discovery.h          |   6 +-
 libmultipath/libmultipath.version |   3 +-
 libmultipath/print.c              |   2 +-
 libmultipath/propsel.c            |   1 +
 libmultipath/structs.h            |  21 +-
 multipathd/main.c                 | 385 ++++++++++++++++++------------
 tests/directio.c                  | 133 +++++++----
 12 files changed, 546 insertions(+), 333 deletions(-)

-- 
2.45.0

