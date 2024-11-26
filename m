Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F8E1DE3B8
	for <dm-devel@lists.linux.dev>; Tue, 26 Nov 2024 18:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732646554; cv=none; b=ChcfF7Pf4PYCvVS2VwMp+qQflHYU2GW5Nu9A+ndDgwbb8G1WyNgzuQS+i1nkBAtK+1qey1bQUPY6ZaNInTkoUz4ZQV0iRn4L10euAPf2hDRQ4G3vwuzPvZZpongB3w+J3YfjUksvjNdzI8OG0r+PmKEyP4AUPqhoqfIGnFXbq6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732646554; c=relaxed/simple;
	bh=Cw1NZG8YjjT25qlvGhhUSSvgM+qzkVuUlLwhfSBdjxc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=EZBQz/ODHBV337fjslOld6jqYV6AAlhSguX19Ub0DiV3Sm2ERTGEFZRk55waXzKfauYjdSphkYoxBKx0i2dVXRe/wdA7S6J1KQJ3xKVuhkmhpWEcb+8i8x8P63ukM9QRdnRwKi5iQFBKdj7TbdDFM2KiqRjUgaeWAayf1uAoHBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JrWY4XWg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JrWY4XWg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732646551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=twH5HrkzURur1zxi4aLv4BMZtPJQQNfhruBpXx2ZLmE=;
	b=JrWY4XWg7mP+n7bSGQkBHD5a3rrRpeK0sOUWs6z25L+56EBWQYtbeAwFbza3UeHpZRk3Hj
	/HW/ty86qgkEwAv29M/98aIl6FrhsKXylmKFS8VZGrJldHmCOayJoXTY8GDNU2Rvlt2WnO
	bn0gpdi3xyEGry2PbXcUQi5hYU9KbN4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-550-Yt68goFtOdeVZiFHT0_ihg-1; Tue,
 26 Nov 2024 13:42:28 -0500
X-MC-Unique: Yt68goFtOdeVZiFHT0_ihg-1
X-Mimecast-MFC-AGG-ID: Yt68goFtOdeVZiFHT0_ihg
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0224C1955F3D;
	Tue, 26 Nov 2024 18:42:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 55A01300019E;
	Tue, 26 Nov 2024 18:42:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4AQIgOV1855480
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 13:42:24 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4AQIgOEA855479;
	Tue, 26 Nov 2024 13:42:24 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v3 00/12] multipath-tools: Handle tableless DM devices
Date: Tue, 26 Nov 2024 13:42:12 -0500
Message-ID: <20241126184224.855459-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wT4UGxYrUzaiIIDjoIBZcRzA-Ahd0M3M40R3DqH6DWs_1732646547
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This is another stab at handling tableless multipath devices. The first
two patches are reworkings of two patches from my last patchset based on
feedback from Martin. The rest are new.

libmp_mapinfo now has a new return value, DMP_EMPTY, for devices that
don't have any table. The creation failure path is fixed to check for
this value before removing a device after a failed create, instead of
just removing any existing DM device with the same name. 

libmp_mapinfo now also always fills in info.name, info.uuid and info.dmi
if requested, whenever a device is found, even if it returns
DMP_NO_MATCH, DMP_EMPTY, or DMP_ERR. dm_find_map_by_wwid() uses this, as
well as MAPINFO_MPATH_ONLY, to only return DM_OK for valid multipath
devices, but to return the alias of any device that matches the uuid,
even if it's not a valid multipath device.

domap() has been updated to use dm_find_map_by_wwid() to check for any
DM device that matches the WWID of the device to be created. This lets
it handle tableless devices that share the WWID of the device to be
created but not its alias. Previously, multipath would fail attempting
to create these devices. Now it correctly renames and reloads them when
running multipath, starting or reloading multipathd, or running
"multipathd add map".

Finally, dm_flush_map__() and do_foreach_partmaps() also handle tabless
devices. So multipath -F will remove tabless multipath devices, as well
as tableless partition devices on top of multipath devices (tabless or
not). I cleanup up a number of minor issues while working on this.

Changes from v2 (based on suggestions from Martin Wilck):
0008: Fixed commit message
0009 & 0010: merged. All future patch number are one less then their
             previous number.
0011 & 0012: Fixed commit messages

Changes from v1 (based on discussions with Martin Wilck):
0004: Dropped the flag. libmp_mapinfo now always fills in uuid, name, and
      dmi if a device was found and they are non-NULL.
0005: Adapt to the changes in 0004
0007-0013: New patches to handle tabless devices in dm_flush_map__() and
           do_foreach_partmaps(), as well as some minor fixes/cleanups I
           encountered along the way.


Benjamin Marzinski (11):
  libmultipath: signal device with no table in libmp_mapinfo
  libmultipath: fix removing device after failed creation
  libmultipath: set uuid, name, and dmi if a device is found
  libmultipath: check table type in dm_find_map_by_wwid
  libmultipath: handle a create corner case for empty devices
  libmultipath: handle empty maps in dm_flush_map__
  libmultipath: factor out code to check if a device is a partition
  libmultipath: remove recursive calls in partmap_funcs
  libmultipath: assume device is in use if dm_get_opencount fails
  libmultipath: accept empty partitions as valid in do_foreach_partmaps
  libmultipath: reduce log level for DMP_NOT_FOUND

Martin Wilck (1):
  multipath-tools tests: fix mapinfo tests

 libmultipath/configure.c   |  21 +++-
 libmultipath/devmapper.c   | 212 +++++++++++++++++++++----------------
 libmultipath/devmapper.h   |  13 ++-
 libmultipath/structs_vec.c |   5 +-
 multipathd/cli_handlers.c  |   8 +-
 tests/mapinfo.c            |  92 ++++++++++++----
 6 files changed, 235 insertions(+), 116 deletions(-)

-- 
2.46.2

