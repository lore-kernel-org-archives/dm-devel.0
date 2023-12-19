Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55FB3D0AE
	for <dm-devel@lists.linux.dev>; Tue, 19 Dec 2023 22:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YyV88Z7S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703026315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=N1ch2KSd+ZVrTB7hF7fUsdHCWq7MR/5C1iI+6yO6Y+o=;
	b=YyV88Z7SqwrWjioWL3KZpytknWCZ1It/oUxSRu0LUGEepGBwh6SZMJoeu4GKTWsx6gXy2b
	zWqlpz49A6jRvVw0K2AHogr4k8nAH0XTO3U8YdX8ALhZBHmcJEsn2IxIryuhDRfIqP63Fm
	EAvhoL9We66n+92YFrpjhcr9tXr7TY4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-497-GPC3C-ePP6uWef65hnCGAA-1; Tue,
 19 Dec 2023 17:51:52 -0500
X-MC-Unique: GPC3C-ePP6uWef65hnCGAA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0D8B1C0514B;
	Tue, 19 Dec 2023 22:51:51 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E7E2A2166B31;
	Tue, 19 Dec 2023 22:51:51 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 3BJMpp7t787535
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 17:51:51 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 3BJMppT3787534;
	Tue, 19 Dec 2023 17:51:51 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v3 0/5] fix set_no_path_retry and cleanup commands
Date: Tue, 19 Dec 2023 17:51:46 -0500
Message-ID: <20231219225151.787521-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

This patchset combines my patch to disable queueing in set_no_path_retry
when recovery mode has timed out with my pathset to cleanup the
interactive commands. This has been significantly changed in v3

Differences from v2 (based on suggestions by Martin Wilck):
0001: This completely new patch that Martin suggested. Martin, I've
      made you the Author. Feel free to change my commit message if
      you'd like.
0002: This is similar to patch 0001 from v2, except the rational has
      changed. It is still possible to get in a situation where a
      multipath device is queueing after timeout out in recovery, so we
      still need to handle this. Since we won't have to worry about
      multipathd flip-flopping the queueing state on reloads, I pulled
      this check outside the PATH_PENDING check, as Martin suggested.
0003: This is the same as patches 0002-0004 from v2. It made no sense
      to merge 0002 and 0004 but not 0003. In would just result in
      making changes only to undo them in the next patch.
0004: This is instead of my 0005 patch from v2. In order for
      disabling and restoring queuing to always work correctly,
      multipathd needs to track the current queueing state.
0005: This is a new patch based on some of Martin's comments on
      v2 patch 0005.

Differences from v1 (based on suggestions by Martin Wilck):
0001: added comments explaining why cleaning up the queueing state is
      unnecessary in update_queue_mode_{add|del}_path().
patches 0002-0005 were previously 0001-0004

Benjamin Marzinski (4):
  multipathd: Make sure to disable queueing if recovery has failed.
  multipathd: don't modify the multipath device on show commands
  libmultipath: keep track of queueing state in features
  multipathd: only restore queueing if it has been disabled first

Martin Wilck (1):
  libmultipath: avoid temporarily enabling queueing on reload

 libmultipath/configure.c   |  4 +--
 libmultipath/devmapper.c   | 23 +++++++++++++++---
 libmultipath/devmapper.h   |  2 +-
 libmultipath/dmparser.c    | 14 +++++++++--
 libmultipath/structs_vec.c | 34 +++++++++++++++++++++-----
 multipathd/cli_handlers.c  | 50 +++++++++++++++++---------------------
 multipathd/dmevents.c      |  2 +-
 multipathd/main.c          | 33 +++++++++++++------------
 multipathd/main.h          |  7 +++---
 multipathd/multipathd.8.in | 12 +++++++--
 multipathd/waiter.c        |  2 +-
 11 files changed, 116 insertions(+), 67 deletions(-)

-- 
2.41.0

