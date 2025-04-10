Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671531AA786
	for <dm-devel@lists.linux.dev>; Thu, 10 Apr 2025 19:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744314591; cv=none; b=ZXzDSaqpbW0Cq4sttIuvl8nSxIWA9zw4JMGAzlJT6vfGPM8gvtiLPiHncJUWdrJ2cIX6wNZzRF733Nu7ISUpfVQuB0pTP7TvMdBLuLoPKiV7vlPbUDHX1Sj0PdBqnXI13QgElYvJd4iiygzKHXGwZoSLpXQqvbDN05YkQqglI+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744314591; c=relaxed/simple;
	bh=dOkEQ84PJqpR2kln2MBS2bs19PmOnx/++BzqrDK3sIw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=TV3/HCEOejhBiX04SS5un4zRI584qp4L0cT7Pct5NacMCGdlTj8rMGI3wu6PiCwZ3QtgL4SDdDk/VbLQhdR4RnGiBo3Zq6lAgulsrqvqMcgXH5vXNz7X+BePtDfu6MA+z0VUzz+2C75J12SUSinKs29RZbQCGNgdfmP3LUxFJkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rs+qUXun; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rs+qUXun"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744314588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=26G6NZ+Hirli4ZC6HAxzkMc3P0Mn/FAjAi6TdPQwxcA=;
	b=Rs+qUXunjopWBiVlxfel2UBLdaceKI9CPj1Sw0qSaxbrXUwwI/ghXc1vjlJRY+TxZ3W3KD
	+EdxWoNBfq4ZTi76SkLLkkLltM3AIWo4M/y3sJsMo6DAAQvJ+TOX2YzW5G2xg91X5fvc9j
	8QLSmu8a3V0jgxyE6SsQoZQaAfkJ63Q=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-73-XNcSiHoXM3OA4ovV2A6YNw-1; Thu,
 10 Apr 2025 15:49:46 -0400
X-MC-Unique: XNcSiHoXM3OA4ovV2A6YNw-1
X-Mimecast-MFC-AGG-ID: XNcSiHoXM3OA4ovV2A6YNw_1744314586
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D30311955BC1;
	Thu, 10 Apr 2025 19:49:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5050D180B486;
	Thu, 10 Apr 2025 19:49:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53AJniBp009341
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Apr 2025 15:49:44 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53AJnhEs009340;
	Thu, 10 Apr 2025 15:49:43 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Damien Le Moal <dlemoal@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 0/6] dm: fix issues with swapping dm tables
Date: Thu, 10 Apr 2025 15:49:37 -0400
Message-ID: <20250410194943.9326-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yELzSDORkq3ZztX4WVnqUvttIetuTvz2LBIbNOtAkbI_1744314586
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

Changes in V4:
- Fixed typos in 2 commit messages (patches 4 and 5)
- rephrased comment in dm_revalidate_zones() (patch 5)

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

