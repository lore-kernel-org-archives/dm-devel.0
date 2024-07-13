Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D04919478
	for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 06:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720850715; cv=none; b=gYV/LLNgLovT+f1eEe81Z7q5xo5MBgm/rmw70SJgs/WHdZJ1Hfd/YobaFzzBEhyWV0II9O+eSEWOryjeSwAUDjCNcOjjcb1f9aR8MjH/kINUv90ZAQpbtz66K6H9f+9WlK9e+WzMUqcsW7DlSigc9EnW0GlDzqaremgQqLct/WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720850715; c=relaxed/simple;
	bh=mEUXdbG7tz8gcjMFEURgyWqfTE/RUQMwyANfERFrzYs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sxVMK9B7gX2L62SYxHtSnMrfcxl0Yn2xpF0dyApCf4+Bn/Ub1T2FArstvLMoEtjAFYDqECXRawkESYIKy06NAJripUYaT3C5gYF/bsD7UnOEc3KN9bn3ub24kaNgRwinbNB3EyXly/vRZt4BTpY5EgQ33pE+SeogfPV5GNTZHjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J/KHVtE8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J/KHVtE8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720850712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=g+btle4nr49q1EScqwGwZ9JaBQqZi+bzLCyYTV1VpBg=;
	b=J/KHVtE8CeKzc87SLZx8LzV8l3cniD/PqcVv8lowp5/MyvmZDBbfnGRCZqzlm139quWqhh
	J3WqvyhuEwEpi/AegaIwJGmhDTiS96BemVYGIXuxXpPnvwMMaDJYhKlzZYvHhKmQJjhX0M
	/yk6qS5B7f0QMm+4l8rq4JXLlbhV+RY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-214-VX-L-dk3NO6X5j968KPLew-1; Sat,
 13 Jul 2024 02:05:10 -0400
X-MC-Unique: VX-L-dk3NO6X5j968KPLew-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 94E611944D30;
	Sat, 13 Jul 2024 06:05:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CEB2F19560AE;
	Sat, 13 Jul 2024 06:05:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46D657Wi2015494
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 13 Jul 2024 02:05:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46D656DO2015493;
	Sat, 13 Jul 2024 02:05:06 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 00/22] path checker refactor and misc fixes
Date: Sat, 13 Jul 2024 02:04:44 -0400
Message-ID: <20240713060506.2015463-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

This patchset is based on discussions I had with Martin Wilck about my
last, partially applied patchset. It's based on top of his mwilck-tip
branch, 6a312b6c "GitHub workflows: native.yml: run root tests". These
patches are mostly orthogonal to the libmp_mapinfo() work. I'll rebase
them if further changes to that patchset stop them form applying
cleanly.

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

Items 1 & 2 are handled by patch 12 and preceding patches.

Items 3 & 4 and handled by patch 19 and preceding patches.

Item 5 is handled by patch 20 and 21.

Benjamin Marzinski (22):
  libmultipath: rename dm_map_present_by_wwid() and add outputs
  multipathd: make cli_add_map() handle adding maps by WWID correctly
  multipathd: remove checker restart optimization
  multipathd: refactor path state getting code into a helper
  multipathd: handle uninitialized paths in new function
  multipathd: make check_path() static
  multipathd: remove redundant checks in handle_uninitialized_path()
  multipathd: check paths immediately after failing udev initialization
  multipathd: set pp->tick = max_checkint in handle_uninitialized_path
  multipathd: return 0 from path_check() if that path wasn't checked
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

 libmultipath/config.c             |  13 +
 libmultipath/config.h             |   1 +
 libmultipath/configure.c          |   1 +
 libmultipath/devmapper.c          |  16 +-
 libmultipath/devmapper.h          |   2 +-
 libmultipath/libmultipath.version |   5 +
 libmultipath/structs.c            |   1 +
 libmultipath/structs.h            |   3 +
 libmultipath/structs_vec.c        |   6 +
 libmultipath/valid.c              |   2 +-
 multipathd/cli_handlers.c         |  65 ++--
 multipathd/main.c                 | 571 +++++++++++++++++++-----------
 multipathd/main.h                 |   2 +-
 tests/valid.c                     |  12 +-
 14 files changed, 431 insertions(+), 269 deletions(-)

-- 
2.45.0

