Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1119226D03
	for <dm-devel@lists.linux.dev>; Tue,  8 Apr 2025 23:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744156328; cv=none; b=NQZD7VdLgd5wHl5a6j9w4G7P1MYXYxJ4cBnEvwvda/eztLqsRuX0hsVGR8dpkFtrW3+cIuOGqZYY+o2my8eykLZ1o8Qt1BqB5hwmDNEduyWOTAHRjL99+J0J+nPpVV8L3OtCxx5IhlMKswTCUGW9s7ME/plIVVb8wZRRMZ/1hdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744156328; c=relaxed/simple;
	bh=t+S9glX/Y8M9vvZTplV1WRqi9KrbXRqPz7mYowNx1qY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=r8geYgx1Q3ePyy8JvM1qQeLpGIvICIpfEdh+I5T54aV6iRWZOl3gzyTOGSYcO2sonKzlS6BOZ//AfAS2fp/My6Fr4ZkcdiWe+kw0K8DKSp1GZhgvNSUV6voBtfevGP47WN59cN8jESqP2rVPpk/JYEzdRZQS7xqqK7iOhARJTaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h7Yd15Qa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h7Yd15Qa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744156325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ehYML8AU0iT2QWtnusssMHXmZae7O7qonEU4nE9GzdU=;
	b=h7Yd15QakeffjMiAmnH/fecQMUIh/kMFXc0yxSIdlrZsz3PyrG9PC7qFB8CXzwFSVz6PpW
	S0RdR32ZkWqKc1Ysu3i+Fv9P8JpKS1e2ip8xq+QKsaGjjtnTSuTgtqnLK050SqGh8vPuOI
	/uxFdChjWUtHg5fu4d5jvXhRW5VprS0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-372-5KsXnIcJN6i_-5fDEJOj5w-1; Tue,
 08 Apr 2025 19:52:02 -0400
X-MC-Unique: 5KsXnIcJN6i_-5fDEJOj5w-1
X-Mimecast-MFC-AGG-ID: 5KsXnIcJN6i_-5fDEJOj5w_1744156321
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9B2C2180025A;
	Tue,  8 Apr 2025 23:52:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B8E5B1955DCE;
	Tue,  8 Apr 2025 23:52:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 538Npx2g4128853
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 8 Apr 2025 19:51:59 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 538NpxxQ4128852;
	Tue, 8 Apr 2025 19:51:59 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Damien Le Moal <dlemoal@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 0/6] [PATCH v3 0/6] dm: fix issues with swapping dm tables
Date: Tue,  8 Apr 2025 19:51:53 -0400
Message-ID: <20250408235159.4128838-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OcBDIszxlD_L8i41yrvS2Qjm_hD9PnKB-dRTuhaGJuo_1744156321
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

There were multiple places in dm's __bind() function where it could fail
and not completely roll back, leaving the device using the the old
table, but with device limits and resources from the new table.
Additionally, unused mempools for request-based devices were not always
freed immediately.

Also, there were a number of issues with switching zoned tables that
emulate zone append (in other words, dm-crypt on top of zoned devices).
dm_blk_report_zones() could be called while the device was initially
setting up a zoned table and creating zoned resources or could possibly
fail to end a srcu read section.  More importantly,
blk_revalidate_disk_zones() would never get called when updating a zoned
table. This could cause the dm device to see the wrong zone write
offsets, not have a large enough zwplugs reserved in its mempool, or
read invalid memory when checking the conventional zones bitmap.

Finally, any DM device created on top of a device emulating zone appeads
will automatically have zone write plug resources created for it, since
max_hw_zone_append_sectors will always be 0 for a device stacked on top
of a device max_hw_zone_append_sectors = 0

This patchset fixes these issues. It deals with the problems around
blk_revalidate_disk_zones() by only calling it for devices that have no
zone write plug resources. This will always correctly update the zoned
settings. If a device has zone write plug resources, calling
blk_revalidate_disk_zones() will not correctly update them in many
cases, so DM simply doesn't call it for devices with zone write plug
resources. Instead of allowing people to load tables that can break the
device, like currently happens, DM disallosw any table reloads that
change the zoned setting for devices that already have zone write plug
resources. Finally, it deals with the max_hw_zone_append_sectors issue
by making sure that it is non-zero for zoned DM devices that do not need
zone write append emulation.

Changes in V3:
- Use queue_limits_start_update() instead of modifying
  queue_limits_set()
- Rewrote the commit message for patch 0004 ("dm: fix
  dm_blk_report_zones") to explain that this only happens when initially
  setting up a table with zone append resources, so disallowing table
  swaps after you set up a zoned dm-crypt device will not effect the
  issue at all. I did not implement Christoph's suggestion because I
  don't understand how it would work here. Perhaps I'm just being dense.
  I'm not wedded to this solution. Any one that keeps this
  use-after-free error from being possible is fine by me.
- Added a final patch to deal with the issue of stacked devices always
  getting zone append resources if any underlying device needs them.

Changes in V2:
- Made queue_limits_set() optionally return the old limits (grabbed
  while holding the limits_lock), and used this in
  dm_table_set_restrictions()
- dropped changes to disk_free_zone_resources() and the
  blk_revalidate_disk_zones() code path (removed patches 0005 & 0006)
- Instead of always calling blk_revalidate_disk_zones(), disallow
  changes that would change zone settings if the device has
  zone write plug resources (final patch).

Benjamin Marzinski (6):
  dm: don't change md if dm_table_set_restrictions() fails
  dm: free table mempools if not used in __bind
  dm: handle failures in dm_table_set_restrictions
  dm: fix dm_blk_report_zones
  dm: limit swapping tables for devices with zone write plugs
  dm: fix native zone append devices on top of emulated ones

 drivers/md/dm-core.h  |  1 +
 drivers/md/dm-table.c | 67 +++++++++++++++++++++++++-------
 drivers/md/dm-zone.c  | 90 ++++++++++++++++++++++++++++++-------------
 drivers/md/dm.c       | 36 ++++++++++-------
 drivers/md/dm.h       |  6 +++
 5 files changed, 146 insertions(+), 54 deletions(-)

-- 
2.48.1

