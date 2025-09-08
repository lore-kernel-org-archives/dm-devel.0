Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC4525D1E6
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376011; cv=none; b=VJOGD1yQHGAU1jkdXa8M4Hk/jPlccoVJhK9rWHKl3qwM+YgNdr6O1cDHnfKh6NUot99LVuuTgvJutvxU6XgwhB/n+Vjq0ZjranbIosmRrspg2fDutuJ47+9XtiKG39ETCsImch94nZaY0loMCQyGuWUSAtKO4UPsCanNJPsliu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376011; c=relaxed/simple;
	bh=k2gpcxWpC4EjWlTcIMbRpU4NOHBdMzDpHXU5AZHPNIM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=CFxm4IbVPcMVGbPQH/qO++lzE0kmEAVj6VDS0oqKR+TSx0Yq4OIB+xZSAD6e5rLz/RkZC5xoczLNqETZnOL37U0kl7g8a2sMUgdQV0oDxx+IOnH1gPwAQfcM2Du57VMK9DPZ82m7188OXOtB7netP/Ql/+cEAfJ/r9N7w3vkHVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B0AVbYw2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B0AVbYw2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=L8WhBuW4Pt71n57JZxzlRCIcphijPe9Fcn92RkwtW08=;
	b=B0AVbYw2Zwtc+gFU1lxPBAkFb9cmDU9rh/tYsL8i4aEHlptDubAiLCtwZHItU7JQOKTTWe
	EOsrK+cpFpdOApdmzSl6ptfk66vfzkTs0G9ivElMz93BJaoPcgSk27RRQPO75dZJA/nrma
	7v90W72ZKNzP9Vxy9vQ2zc1tMKAnBB4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-524-jYhUNLUPPv6pqJ0d7IoshQ-1; Mon,
 08 Sep 2025 20:00:06 -0400
X-MC-Unique: jYhUNLUPPv6pqJ0d7IoshQ-1
X-Mimecast-MFC-AGG-ID: jYhUNLUPPv6pqJ0d7IoshQ_1757376005
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5DFC01800359;
	Tue,  9 Sep 2025 00:00:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0CFB41956095;
	Tue,  9 Sep 2025 00:00:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589003Pt751080
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:03 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5890024I751079;
	Mon, 8 Sep 2025 20:00:02 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 00/32] Multiple mpathpersist improvements
Date: Mon,  8 Sep 2025 19:59:30 -0400
Message-ID: <20250909000002.751039-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eTZEV8HvldjFvkukxXEwnzDVdYnoxZRHrD7QXWaoSxg_1757376005
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

The mpathpersist code has many areas where it does a poor job of
mimicking the behavior of setting up persistent reservations on an
individual device, especially if paths to the multipath device are
missing or unusable. This patchset is aimed at fixing a number of
them. It is a combination of my two previous patchsets:
[PATCH 00/15] Improve mpathpersist's unavailable path handling
and
[PATCH 00/14] Additional fixes and cleanups
along with additional patches.

Issues handled by the patchset are:
- Changing or unregistering a key held by an unavailable path that also
  holds the reservation. This is done by preempting the old key
  (after verifying that the multipath device is holding the reservation)
- Releasing a reservation held by an unavailable path. This has always
  had code to handle it, but it relied on optional Persistent
  Reservation features. The new code preempts the key and then restores
  the removed registered keys (while the device is suspended).
- Handling removal of keys from paths that were down when the multipath
  device was unregistered.
- Changing how conflicts on key registration are handled. Instead of
  the current rollback method (which was broken anyways),
  libmpathpersist now retries with REGISTER AND IGNORE as long as the
  REGISTER command completed successfully down some of the paths.
- Changing when the reservation key is set to fix corner cases on
  failure and registration while paths are coming up.
- Retrying on conflicts in mpath_prout_common to fix corner cases when
  a path is coming up while a doing a reserve, preempt or clear.
- Allowing registrations to succeed when there are retryable errors, 
  if the paths are actually down.
- Fixing the reservation key validation code

Changes in V2:

First set (as suggested by Martin Wilck)
0009: Added a comment explaining the select_skip_kpartx()
0010: use all_threads_fail variable instead of rc.

Second set
0003 (now 0018): Remove noisy variable from update_map_pr
0007 (new 0022): Added comment explaining why we won't fail syntax error
     checks after updating the reservation key, as suggested by Martin
     Wilck (for patch 0012, but it made more sense to change it here)

0030 new patch to not attempt workaround when a release fails due to a
     mismatched type.
0031 new patch to fix an issue with issuing a RESERVE command to the
     path that doesn't hold the reservation.
0032 new patch to fix an issue with a multipath device preempting its
     own reservation key.

Benjamin Marzinski (32):
  multipathd: remove thread from mpath_pr_event_handle
  libmpathpersist: remove uneeded wrapper function.
  libmpathpersist: reduce log level for persistent reservation checking
  libmpathpersist: remove pointless update_map_pr ret value code
  multipathd: use update_map_pr in mpath_pr_event_handle
  libmpathpersist: limit changing prflag in update_map_pr
  multipathd: Don't call update_map_pr unnecessarily
  libmpathpersist: remove useless function send_prout_activepath
  libmpathpersist: redesign failed release workaround
  libmpathpersist: fail the release if all threads fail
  libmpathpersist: Handle changing key corner case
  libmpathpersist: Handle REGISTER AND IGNORE changing key corner case
  libmultipath: rename prflag_value enums
  libmpathpersist: use a switch statement for prout command finalizing
  libmpathpersist: Add safety check for preempting on key change
  libmpathpersist: remove update_map_pr code for NULL pp
  libmpathpersist: move update_map_pr to multipathd
  multipathd: clean up update_map_pr and mpath_pr_event_handle
  libmpathpersist: clean up duplicate function declarations
  multipathd: wrap setting and unsetting prflag
  multipathd: unregister PR key when path is restored if necessary
  libmpathpersist: Fix-up reservation_key checking
  libmpathpersist: change how reservation conflicts are handled
  libmpathpersist: Clear prkey in multipathd before unregistering
  libmpathpersist: only clear the key if we are using the prkeys file
  libmpathpersist: Restore old reservation key on failure
  libmpathpersist: update reservation key before checking paths
  libmpathpersist: retry on conflicts in mpath_prout_common
  libmpathpersist: Don't always fail registrations for retryable errors
  libmpathpersist: Don't try release workaround for invalid type
  libmpathpersist: Don't fail RESERVE commands unnecessarily
  libmpathpersist: reregister keys when self preempting

 libmpathpersist/libmpathpersist.version |   3 +-
 libmpathpersist/mpath_persist_int.c     | 817 ++++++++++++++----------
 libmpathpersist/mpath_persist_int.h     |   4 +-
 libmpathpersist/mpath_pr_ioctl.c        |  12 +-
 libmpathpersist/mpath_updatepr.c        |  74 ++-
 libmpathpersist/mpathpr.h               |   3 +
 libmultipath/libmultipath.version       |   1 +
 libmultipath/structs.h                  |  12 +-
 mpathpersist/main.c                     |   2 -
 multipathd/callbacks.c                  |   3 +
 multipathd/cli.c                        |   4 +-
 multipathd/cli.h                        |   3 +
 multipathd/cli_handlers.c               |  66 +-
 multipathd/main.c                       | 237 ++++---
 multipathd/main.h                       |   2 +
 15 files changed, 755 insertions(+), 488 deletions(-)

-- 
2.50.1

