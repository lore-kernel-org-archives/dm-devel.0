Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE252FCE1A
	for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 18:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752171070; cv=none; b=tX8oBx1QhwvMUZPfna9CdsR7eOZXFQmU38+zY/E5eMUu4WyQBeo0ktjp6zIOC58t7NdUvNW35zjgjkoMN5U5985+lorogzwF/sQ0QIVe8M16LfgGB+bqoYQUm72Kma9wC+35kTjJRVpyqd6pHaZrFlWyODf1sU6z18YhS+8qbJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752171070; c=relaxed/simple;
	bh=yXfRD0qAm3cvBxJjUlQQrbwD5KGz6R9uCHGN1fWsQxk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=rzMJ8o3sCsAo1awjYk30BJGG+/uCEVXNQ5X7tiYSBCSKoyppWg1qj//R0s6I393uIbtb68E8at6J+Yu+8ypFsxS9x/K514AvdC/RnQ4XK+aQjcxNEkyPxjqhJ7SjtuTfl17XQUZG2R4AKHculY08LWdYljW8fweVu6d75Lu/sWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RzwWEDC5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RzwWEDC5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752171067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cuDDhQfFeMEeU7R2qaQAQg1M5zoiuOLFdCUKr1Uyfa8=;
	b=RzwWEDC5lKEK/47kH3dkvdvqn+IbwRASGzoEq6AnbaTbkW6OmcIUj9/MBma9Prb0c2jzHD
	OG4++p9goznw90BJpkJB4aH8bQeaKR8kWyAVwm1IhrqHhIAluDaca0eqPl3wDu/dqf532E
	t3k0EUfUlDurGjSfkgWD9e1N0yflHTc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-55-Mn60JWkANKyEaVrTUjA_eg-1; Thu,
 10 Jul 2025 14:11:04 -0400
X-MC-Unique: Mn60JWkANKyEaVrTUjA_eg-1
X-Mimecast-MFC-AGG-ID: Mn60JWkANKyEaVrTUjA_eg_1752171063
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 46DA818011F9;
	Thu, 10 Jul 2025 18:11:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D81DD180035C;
	Thu, 10 Jul 2025 18:11:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56AIB1Y43997783
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Jul 2025 14:11:01 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56AIB0O83997782;
	Thu, 10 Jul 2025 14:11:00 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 00/15] Improve mpathpersist's unavailable path handling
Date: Thu, 10 Jul 2025 14:10:45 -0400
Message-ID: <20250710181100.3997759-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Wq7K64NGRVjf4r3QxFDHy2l2yoC_or4jDAhQWN1hWNQ_1752171063
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

A problem that mpathpersist has with making SCSI Persistent Resevations
to a multipath device work like they do to individual SCSI devices is
that some of the paths to a multipath device might be down or missing
when the mpathpersist commands are run. Multipath handles registering a
new key pretty well. If paths are unavailable at the time of the
command, the key is registered when they later become available.  But if
the multipath device is also holding a reservation on one of its paths,
things get trickier.

If a persistent reservation is being held by an unsuable path of a
multipath device (the path can either be down or completely removed),
libmpathpersist can't change it just by forwarding the regular
persistent reservation commands. This can cause problems both for the
RELEASE command and the REGISTER and REGISTER AND IGNORE commands if
they are used to change from one key to another. If the path holding the
reservation is unavailable, the reservation won't be released or have
its key changed, as expected. I wish the problem of having a reservation
key changed while it is holding the reservation was simply a theoretical
one, but there are enterprise users of multipath that need this
capability.

This patchset deals with both of these problems. libmpathpersist always
had code to handle releasing a reservation held by an unavailable path,
but the existing method is broken. It relies on poorly supported
optional features of SCSI Persistent Reservations: the READ FULL STATUS
command and specifying Initiator Ports with the REGISTER command
(SIP_C). Also, fixing its current issues would additionally require
supporting the All Target Ports option (ATP_C). This existing workaround
has been redesigned to use the PREEMPT command instead. Key changes
where the path holding the reservation is unavailable were not
previously handled by libmpathpersist. This patchset also handles them
using the PREEMPT command.

patches 0001-0008 are simply cleanups an prep work.
patches 0009-0010 redesign the RELEASE command workaround
patch 0011 creates a workaround for the REGISTER command
patch 0012 makes this work for the REGISTER AND IGNORE command as well
patches 0013-0014 are more prep work
patch 0015 Adds a safety check before preempting a key, so that only
           devices that are holding a reservation will do the
           preemption

These workarounds depend on the fact that managing scsi persistent
reservations for multipath devices has never worked correctly if
multiple nodes use the same persistent reservation key for the same
device. multipathd needs to be able to register the key on new paths,
but the key could have been preempted since it was registered for the
multipath device. To make sure that multipath isn't automatically
registering paths for a device that has been preempted, multipathd
checks that the configured key has already been registered by other
paths of the device.  Unfortunately, there is no way to verify that the
other paths to the multipath device on this node are the ones holding
the keys in question. If another node is using the same key for the
device, those registered keys could belong to paths on the other node,
and there could be no registered keys from this node (likely due to
being preempted). If multipathd registered the key for this new path
because it saw another node's keys, then a preempted node would suddenly
gain access to the storage.

As far as the workarounds from this patchset go, if there was another
node using the same key, then preempting the key in these workarounds
would preempt the other node as well. The safety check in patch 0015
tries to make sure that this only happens when the current is holding
the reservation, but this isn't foolproof.

I should also note that while working on this patchset, I noticed a
number of other issues with the persistent reservation code, mostly
involving changing a registered key. I'll be fixing them in a future
patchset.

Benjamin Marzinski (15):
  multipathd: remove thread from mpath_pr_event_handle
  libmpathpersist: remove uneeded wrapper function.
  libmpathpersist: reduce log level for persistent reservation checking
  libmpathpersist: remove pointless update_map_pr ret value code
  multipathd: use update_map_pr in mpath_pr_event_handle
  libmpathpersist: limit changing prflag in update_map_pr
  multipathd: Don't call update_map_pr unnecessarily
  libmpathpersist: remove useless function send_prout_activepath
  limpathpersist: redesign failed release workaround
  libmpathpersist: fail the release if all threads fail
  limpathpersist: Handle changing key corner case
  libmapthpersist: Handle REGISTER AND IGNORE changing key corner case
  libmultipath: rename prflag_value enums
  libmpathpersist: use a switch statement for prout command finalizing
  libmpathpersist: Add safety check for preempting on key change

 libmpathpersist/libmpathpersist.version |   2 +-
 libmpathpersist/mpath_persist_int.c     | 505 ++++++++++++++----------
 libmpathpersist/mpath_persist_int.h     |   2 +-
 libmpathpersist/mpath_updatepr.c        |  74 +++-
 libmpathpersist/mpathpr.h               |   3 +
 libmultipath/libmultipath.version       |   1 +
 libmultipath/structs.h                  |  10 +-
 multipathd/callbacks.c                  |   3 +
 multipathd/cli.c                        |   4 +-
 multipathd/cli.h                        |   3 +
 multipathd/cli_handlers.c               |  70 +++-
 multipathd/main.c                       | 149 +++----
 12 files changed, 483 insertions(+), 343 deletions(-)

-- 
2.48.1

