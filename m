Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BD71A4E77
	for <dm-devel@lists.linux.dev>; Sun,  9 Mar 2025 22:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741559353; cv=none; b=OEMZuI96M2rJS8zU6P/iI9uGly6DHN7eY/+GKizWC8cF9fgVa1T3NDRVbNkybzCy5rjg63shnH/Wd03jfUj7FS5lX3AqCBb0hK/e4VlAlEgBS5q3czSrTci5QLJ68wP7vsg95NPE7EMNUrkZgu2KW47HwU4uqgNaeaCIC8L2r5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741559353; c=relaxed/simple;
	bh=roHPvne5C+bL8Z16kAz6LyRhIhuJ7jZMsgS38IUT37o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rLNdIQS1Q30r3PBjQKLJ4WcyazjfqgqECbVtjQfVtIKXGa1wjC3+au/86sQzXhBdkTfRO1n7c8W3RZq54CfHmBVne75jL0S53T/P0UyukfiRaq6GgQDHrHvZJ81GCwCOUHxfrZwbf2YhW3u/OZoXXbRYbDsDHS9x+YF5e/aUfjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T1GcdZrw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T1GcdZrw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741559350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9gIFXf6F1idgp8/GOcxy8iXqeXyu/FGifjsjTyt/zS0=;
	b=T1GcdZrwVZTvgUo0o+b84kgW/9yicnmt+CnosVe0gg7LDK/1yTcM3tMQ2PFLo0p642Kzib
	sQiY2Uq6eNHjTRUiYAq2Wj9Ry3zKEur+kRRj36IohegxIIcEb9EMBBjwKx/NCh26QP4dtk
	l2hFz7aqmhI1o/IrC9RAFGqCzWbKdV8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-20-WkyETDHuP6WkSwxVet_3Nw-1; Sun,
 09 Mar 2025 18:29:08 -0400
X-MC-Unique: WkyETDHuP6WkSwxVet_3Nw-1
X-Mimecast-MFC-AGG-ID: WkyETDHuP6WkSwxVet_3Nw_1741559347
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7CADE1800349;
	Sun,  9 Mar 2025 22:29:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E895D1800946;
	Sun,  9 Mar 2025 22:29:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 529MT4f9449819
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 9 Mar 2025 18:29:04 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 529MT4xv449818;
	Sun, 9 Mar 2025 18:29:04 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
        Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: [RFC PATCH 0/7] dm: fix issues with swapping dm tables
Date: Sun,  9 Mar 2025 18:28:56 -0400
Message-ID: <20250309222904.449803-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

There were multiple places in dm's __bind() function where it could fail
and not completely roll back, leaving the device using the the old
table, but with device limits and resources from the new table.
Additionally, unused mempools for request-based devices were not always
freed immediately.

Finally, there were a number of issues with switching zoned tables that
emulate zone append (in other words, dm-crypt on top of zoned devices).
dm_blk_report_zones() could be called while the device was suspended and
modifying zoned resources or could possibly fail to end a srcu read
section.  More importantly, blk_revalidate_disk_zones() would never get
called when updating a zoned table. This could cause the dm device to
see the wrong zone write offsets, not have a large enough zwplugs
reserved in its mempool, or read invalid memory when checking the
conventional zones bitmap.

This patchset fixes these issues. It does not make it so that
device-mapper is able to load any zoned table from any other zoned
table. Zoned dm-crypt devices can be safely grown and shrunk, but
reloading a zoned dm-crypt device to, for instance, point at a
completely different underlying device won't work correctly. IO might
fail since the zone write offsets of the dm-crypt device will not be
updated for all the existing zones with plugs. If the new device's zone
offsets don't match the old device's offsets, IO to the zone will fail.
If the ability to switch tables from a zoned dm-crypt device to an
abritry other zoned dm-crypt device is important to people, it could be
done as long as there are no plugged zones when dm suspends.

This patchset also doesn't touch the code for switching from a zoned to
a non-zoned device. Switching from a zoned dm-crypt device to a
non-zoned device is problematic if there are plugged zones, since the
underlying device will not be prepared to handle these plugged writes.
Switching to a target that does not pass down IOs, like the dm-error
target, is fine. So is switching when there are no plugged zones, except
that we do not free the zoned resources in this case, even though we
safely could.

If people are interested in removing some of these limitations, I can
send patches for them, but I'm not sure how much extra code we want,
just to support niche zoned dm-crypt reloads.

Benjamin Marzinski (7):
  dm: don't change md if dm_table_set_restrictions() fails
  dm: free table mempools if not used in __bind
  dm: handle failures in dm_table_set_restrictions
  dm: fix dm_blk_report_zones
  blk-zoned: clean up zone settings for devices without zwplugs
  blk-zoned: modify blk_revalidate_disk_zones for bio-based drivers
  dm: allow devices to revalidate existing zones

 block/blk-zoned.c      | 78 ++++++++++++++++++++++--------------------
 block/blk.h            |  4 ---
 drivers/md/dm-core.h   |  1 +
 drivers/md/dm-table.c  | 24 ++++++++-----
 drivers/md/dm-zone.c   | 75 ++++++++++++++++++++++++++--------------
 drivers/md/dm.c        | 30 ++++++++--------
 drivers/md/dm.h        |  1 +
 include/linux/blkdev.h |  4 +++
 8 files changed, 128 insertions(+), 89 deletions(-)

-- 
2.48.1

