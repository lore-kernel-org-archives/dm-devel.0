Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FAA192B76
	for <dm-devel@lists.linux.dev>; Fri, 15 Nov 2024 23:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731712986; cv=none; b=cbY2ipqpjD6jN8hKy4KY3NZUIEhkd9I5T+m8QDdHr8Pde0IqniIjlsgXa64gB1qHRMlH/+Sag8glrsHaSqLaQGzsfXX6+GR64rzDxt1x7cWSDqCotbztvNig957HPGD8liUHd65CwYMpM3QeRxLGt5IIMMaPzhN0FPXGN6+ws+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731712986; c=relaxed/simple;
	bh=G7vn+IDHq8Z6fYIcQWTtgSGUYdI73bo3oDDCZiG4Dzc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=L94D5HIiORrZ5GUz6MmnVE6wCWqCHEwSqW3g/zQZMj6Aa+X5EqWUxhxlW1SNzym8BUREY/vzJw/ufMPRyUgq5sp3iCAIDm9ZcdQZORltzQHVOto7IkIzSKTLxKUXhd7S452aPEUCtlfXEU0XTYITBXX/eeNk3nEgvDVzXABEK7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gOwN9v1m; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gOwN9v1m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731712984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XmGZeDyo8DnIAo8/6n3NX6FW6hCZ4jBI6stvQrhhdZY=;
	b=gOwN9v1mIGqUXs20W9c/1VkXAutecVtuPwwUR6WYcsdJlTfRG2kiSW6XBv0+67zfTY5RyR
	CBo5vuw1DpkcgWAI4IVNhMlaMs9YLLZjSOrfL/Y22fCkk1Fy3xYYJvu2tnceWoT8TAfYzD
	YKRhfdo5DHPs4q3zOQzWZLTtGrFm6SM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-433-wAut-VQFMkO_6UWArHW1zg-1; Fri,
 15 Nov 2024 18:23:00 -0500
X-MC-Unique: wAut-VQFMkO_6UWArHW1zg-1
X-Mimecast-MFC-AGG-ID: wAut-VQFMkO_6UWArHW1zg
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EB1BE195608A;
	Fri, 15 Nov 2024 23:22:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9DD9D19560A3;
	Fri, 15 Nov 2024 23:22:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AFNMvXg627948
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 18:22:57 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AFNMugK627947;
	Fri, 15 Nov 2024 18:22:56 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 0/6] multipath-tools: Handle tableless DM devices
Date: Fri, 15 Nov 2024 18:22:50 -0500
Message-ID: <20241115232256.627933-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: asGAbjmEtsl3UtkSYbGUJ9hdRUQXRHY564Nmrv57Av0_1731712979
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

This is another stab at handling tableless multipath devices. The first
two patches are reworkings of two patches from my last patchset based
on feedback from Martin. The rest are new.

libmp_mapinfo now has a new return value, DMP_EMPTY, for devices that
don't have any table. The creation failure path is fixed to check for
this value before removing a device after a failed create, instead of
just removing any existing DM device with the same name. 

libmp_mapinfo now also accepts a new flag, MAPINFO_ID_IF_FOUND, which
causes it to populate info.name and info.uuid if requested, whenever a
device is found, even if it returns DMP_NO_MATCH or DMP_EMPTY.
dm_find_map_by_wwid() uses this new flag, as well as MAPINFO_MPATH_ONLY,
to only return DM_OK for valid multipath devices, but to return the
alias of any device that matches the uuid, even if it's not a valid
multipath device.

domap() has been updated to use dm_find_map_by_wwid() to check for any
DM device that matches the WWID of the device to be created. This lets
it handle tableless devices that share the WWID of the device to be
created but not its alias. Previously, multipath would fail attempting
to create these devices. Now it correctly renames and reloads them when
running multipath, starting or reloading multipathd, or running
"multipathd add map".

I'm not completely happy with the MAPINFO_ID_IF_FOUND flag. An
alternative would be to run a second libmp_mapinfo() call without
MAPINFO_MPATH_ONLY to grab the name, if the first failed with DMP_EMPTY.
If people think that's a better way to solve this, I can rework those
patches.

Benjamin Marzinski (5):
  libmultipath: signal device with no table in libmp_mapinfo
  libmultipath: fix removing device after failed creation
  libmultipath: Add flag to always return device ID when found
  libmultipath: check table type in dm_find_map_by_wwid
  libmultipath: handle a create corner case for empty devices

Martin Wilck (1):
  multipath-tools tests: fix mapinfo tests

 libmultipath/configure.c  |  21 +++++-
 libmultipath/devmapper.c  |  48 ++++++++----
 libmultipath/devmapper.h  |  13 +++-
 multipathd/cli_handlers.c |   8 +-
 tests/mapinfo.c           | 149 ++++++++++++++++++++++++++++++++++++--
 5 files changed, 216 insertions(+), 23 deletions(-)

-- 
2.46.2

