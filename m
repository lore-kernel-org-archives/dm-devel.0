Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A436450EE
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 03:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737602212; cv=none; b=AJ9qU+ZNTCJU6dj7MuLaWHG/0+Q0Rp7jPmpV4CVhhsIsNeDkG55A5BQkqPvUz+cHrbLpOPg9xlmZnVqAq1yyECwk4p5gaK4hzIS9AWpy1kM0qCJ5WO9YUdHXc2D4P93PvRGoCyQuObaHbdrVDpjEdyn9IbGbweHeU2lJzcn4qMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737602212; c=relaxed/simple;
	bh=g+nvn2z15gv6/+F8I08dIhhwvGMu2PWdJAAHEO3+wGU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=trccFvDb9V1ZHByI/GmxEZxjtGA+2aAkkiK+JYjGeHHlgf1MWpnNjdJ/fugo4rDQIVM5xP/f+o/by5zBJIHdBKRVjs7HILbqcFMK20Vaj0edEOSc9eeXa7uAwaXBGU7Lqaq6ouQu517hn8pAN9pemjzUHLaBHydr1a+68d6vZoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZREHZiMm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZREHZiMm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737602210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TX7/GZgQk8eyQ4VyGWhae9lHUNR9jAPjRsFYPzg95b4=;
	b=ZREHZiMmmQYTDfzy8AhfPOz08856XgeHovFGPb/dwoBrcpvjdF8FhKhXdW0c+YgT6SXh3F
	7M3lsrB2Uo9kNau+vPiBerH6SFfPe+53nmRviO+b0bdtk+5pbg5JfDu+1JdLxiWGfxjtOb
	/fUH4YC1kFCAI6NlZYb2fbw9DYHXarE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-361-KPDcKFX5PXuUU9oogW8B0Q-1; Wed,
 22 Jan 2025 22:16:46 -0500
X-MC-Unique: KPDcKFX5PXuUU9oogW8B0Q-1
X-Mimecast-MFC-AGG-ID: KPDcKFX5PXuUU9oogW8B0Q
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8477F19560BB;
	Thu, 23 Jan 2025 03:16:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 375FC195608A;
	Thu, 23 Jan 2025 03:16:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50N3Ghpv3017913
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 22:16:44 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50N3Gh8L3017912;
	Wed, 22 Jan 2025 22:16:43 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 00/13] fix for GitHub issue #108 and misc cleanups
Date: Wed, 22 Jan 2025 22:16:30 -0500
Message-ID: <20250123031643.3017891-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Nv28B4xXGjWyXmeDPbcAc9HA0SlTm-zJiqkfgNHoYZA_1737602205
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This patchset has a couple of different pieces, but that main part
is fixing the issue where, if a path is added while offline (for
instance by doing a "multipath reconfigure" while the path is offline)
It won't be able to get the SCSI device serial number (or its ALUA
target port group). This meant that the GROUP_BY_SERIAL and
GROUP_BY_TPG path grouping policies would not group the path correctly,
even once it came back online.

Patches 1 & 2 are just a fix on top of Martin's recent device reloading
work.

Patches 3, 4, & 5 are changes to need_reload. They avoid setting and
checking it in cases where it won't change how multipathd behaves.
The side benefit of doing this work is that it's easier to reason about
what setting need_reload can and can't effect. Specifically, it will now
only cause multipathd to fix incorrect device tables while in
checker_finished().

Patches 6 - 11 deal with the serial and tpg_id problem from issue #108

Patch 12 is shutting up a static analyzer warning that popped up on a
recent rhel build.

Patch 13 is a fix for an issue I ran into while testing this set.

Benjamin Marzinski (13):
  multipathd: use symbolic values for wait_for_udev
  multipathd: don't reload the map when waiting for udev
  libmultipath: don't set need_reload in adopt_paths
  libmultipath: remove need_reload check from select_action
  libmultipath: drop return value from update_pathvec_from_dm
  libmultipath: Dont scan pointless sysfs parents
  libmultipath: move sysfs checks out of scsi_ioctl_pathinfo
  libmultipath: rename DI_SERIAL to DI_IOCTL
  libmultipath: retry DI_IOCTL functions if they were skipped
  libmultipath: set need_reload when pp->serial gets set
  libmultipath: set need_reload when the tpg_id gets set
  libmultipath: stop static analyzer complaint in init_foreign
  libmultipath: be lenient in allowing the alua-based pgpolicies

 libmultipath/configure.c   |   4 +-
 libmultipath/devmapper.c   |  22 +++++---
 libmultipath/discovery.c   | 104 ++++++++++++++++---------------------
 libmultipath/discovery.h   |   7 ++-
 libmultipath/foreign.c     |   2 +-
 libmultipath/propsel.c     |   6 ++-
 libmultipath/structs.h     |  15 +++++-
 libmultipath/structs_vec.c |  10 ++--
 multipath/main.c           |   2 +-
 multipathd/cli_handlers.c  |  16 +++---
 multipathd/main.c          |  40 +++++++-------
 tests/test-lib.c           |   9 +---
 12 files changed, 119 insertions(+), 118 deletions(-)

-- 
2.46.2

