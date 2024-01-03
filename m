Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A679C1C6BF
	for <dm-devel@lists.linux.dev>; Wed,  3 Jan 2024 17:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JLaTdIeS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704304605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BPzSQa8cTgZQ8zWTZJ7rJzIFmJHKk5BdmGO/EHRXoAU=;
	b=JLaTdIeSCGCmp2NjAS38wdUiKiuQ0eXXGNyoG4Mm8S6i4rOV6m/njtmEYx3rY3fDtBDhN0
	7BTOTQ9dwhNLAyWfiiAFH4lA8a9hXqii/gtf1iiUG+VNvq4WI734zlX3XJxMCYhwlAh037
	AVSwyjDkLM7hvK8xeseLNmo0RRki5Jg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-495-66nZPCXsN8axSk7RZ-dPpw-1; Wed, 03 Jan 2024 12:56:44 -0500
X-MC-Unique: 66nZPCXsN8axSk7RZ-dPpw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08312859B81;
	Wed,  3 Jan 2024 17:56:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EA5591C060AF;
	Wed,  3 Jan 2024 17:56:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 403Huhug018465
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Jan 2024 12:56:43 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 403HuhCJ018464;
	Wed, 3 Jan 2024 12:56:43 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 00/18] change how multipathd deletes maps plus cleanups
Date: Wed,  3 Jan 2024 12:56:25 -0500
Message-ID: <20240103175643.18438-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

The main purpose of this patchset is to make multipathd call
dm_suspend_and_flush_map() for the "del map" and "del maps" interactive
commands. I ran into an issue where if there was outstanding IO to a
queueing multipath device, dm_flush_map() would hang removing the last
kpartx device, since that would close the last opener of the multipath
device, forcing it to wait for the IO to flush. This is avoided by
dm_suspend_and_flush_map(), since it disables queueing first. The first
three patches do this. The next three are cleanups around removing a
device. The rest of the patches are make multipath return better errors
when it delegates removes since it doesn't need to failback to doing its
own removes anymore, make libdmmp handle failures from running
multipathd commands better, and make multipath and multipathc return
proper error codes when multipathd commands fail.

Differences from v1 (based on suggestions by Martin Wilck)
0003: simplify dm_flush_maps(), since all callers set need_suspend
0005: Minor change in dm_flush_maps() to accomodate change in 0003. I
      retained the reviewed-by.
0007: Stripped the initial "fail\n" off messages with additional failure
      information.
0009: Minor changes in dm_flush_maps() and its callers to accomodate
      change in 0003. I retained the reviewed-by.
0010: changed the log level of the error message to 2.
0012: search for path by dev_t first, and change the log level of the
      error message to 2.
0015: Minor change to calling dm_flush_maps() to accomodate change in
      0003. I retained the reviewed-by
0016: multipath repeatedly calls delegate_to_multipathd for all
      remove_retries, instead of failing back to locally calling remove.
0017: New patch based on patch 0016 discussion.
0018: New patch to deal with a issue caused by the change to track the
      queue_if_no_path state in mpp->features, from my previous
      patchset.

Benjamin Marzinski (18):
  multipathd: remove nopath flushing code from flush_map()
  multipathd: make flush_map() delete maps like the multipath command
  multipathd: disable queueing when removing unknown maps
  multipathd: simplify cli_del_map()
  libmultipath: make _dm_flush_map() return an enum
  libmultipath: make dm_remove_partmaps() a static function
  multipathd: always start failure replies with "fail\n"
  multipathd: print extra default reply msg for busy devices
  multipathd: handle busy devices in cli_del_maps()
  libmultipath: print error when find_mp_by_str() fails.
  multipathd: don't open code find_mp_by_str() in client handers
  multipathd: make cli_handlers check for paths by dev and devt
  multipathd: add cli_handler reply message for missing devs
  libdmmp: handle failures in _process_cmd
  multipath: get rid of unnecessary retries variable
  multipath: Don't locally retry deletgated remove failures
  multipath: if delegation times out mark as not delegated
  multipathd: sync features on flush_map failure corner case

 libdmmp/libdmmp.c                 |  71 +++++-------
 libmultipath/devmapper.c          |  47 ++++----
 libmultipath/devmapper.h          |  13 ++-
 libmultipath/libmultipath.version |   3 +-
 libmultipath/structs.c            |   9 +-
 multipath/main.c                  |  72 +++++++-----
 multipathd/cli_handlers.c         | 182 ++++++++++++++----------------
 multipathd/main.c                 |  70 ++++--------
 multipathd/main.h                 |   3 +-
 multipathd/uxclnt.c               |   9 +-
 multipathd/uxlsnr.c               |  15 ++-
 11 files changed, 241 insertions(+), 253 deletions(-)

-- 
2.43.0

