Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CAF154BEE
	for <dm-devel@lists.linux.dev>; Wed, 10 Apr 2024 08:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712738736; cv=none; b=Xe3Xj7bIOwTyCZDKhHJCwNJgsSJqxWSOwaDrDq988+48Fd+BLztIq27LV4k9bfHkU72gt3ydmaCEmU1WrWXfyqN5HsUUDHaBCOXBvWUOL1DV2lN1eU4fbnkPub8lJIb7uK6bFdUhkXM0d38fXUtgaXXgAmQIbkPzmO4c7P6Hceo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712738736; c=relaxed/simple;
	bh=CA1KcUVOd7+E0bkWzdnxOXoScLlHn0pNOjqV9e0jzAk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UkXJUbJJjLZ4+yKBGPBpgBcauQyksNPfWFZKUGxpwzMn2/mIv9Hbnot06S0M0y3DUoEbjLuyrxB27vmcZfihfjIpeqqtraEFjV56jQuVR2SErg1CcbFuyQx8ShUQWDAVBcuixXoI51LfhxW3dHKviU2j/ack7u1mTmZbKyGYntQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=RDOvCN+M; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="RDOvCN+M"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1712738734; x=1744274734;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CA1KcUVOd7+E0bkWzdnxOXoScLlHn0pNOjqV9e0jzAk=;
  b=RDOvCN+M/u1mrgFSrrb826Fc3H0/JNFPMyN3n2PZyL92ITQKWaFoOYZn
   DhzjPKFs88AEHYxuziQvqAcFbfFe3C8SSn7LFcZuy3pEExdsct+UxRVBz
   xqtfMfDyLJYp3/cwkl1sV3L/VHfs2/MgiDLoEzSftbXDXAYN4QGoV+3Ok
   Dm0noFh8wiXat3FYlNhgpTAUdoFs53VbQ4jbcE8rWURqvh9vP9ZRKzYYK
   7xQJ8mwKTuCYsAT7MSeFrmGQYPnjdx2V4fWBsSaDTvPFGscz6QtPgIDWk
   kwJgaXOqNnWSqPCt6tkG2/T9NGIWkdXOipZtZH6IHVX5P1Gp3am39dJD5
   Q==;
X-CSE-ConnectionGUID: guvlYc1tQr6+g9eC+TNUFw==
X-CSE-MsgGUID: LLd2+MpQTUOPJembfWtVpg==
X-IronPort-AV: E=Sophos;i="6.07,190,1708358400"; 
   d="scan'208";a="13666451"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Apr 2024 16:45:33 +0800
IronPort-SDR: x7q49Ls9PifGCcBXrCszJNnRP27cmi0NNRHET6w6quC0arX6MpWdOXIpxrSnzLj93E4jtQ8qSh
 tg1G6nVh3B0w==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Apr 2024 00:54:00 -0700
IronPort-SDR: dXAtZt1tTHpLK32MA1SZNfZUBT6RaabCDn3Ri44d0fYqCu+vANYMk+Xg7LAbMjEoE2qy3GZl0z
 fgzYU0mW+3gQ==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Apr 2024 01:45:32 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>
Cc: Tejun Heo <tj@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] dm zoned: Drop the WQ_UNBOUND flag for the chunk workqueue
Date: Wed, 10 Apr 2024 17:45:31 +0900
Message-ID: <20240410084531.2134621-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 5797b1c18919 ("workqueue: Implement system-wide nr_active
enforcement for unbound workqueues") modified the maximum number of
active works that an unbound workqueue can handle to at most
WQ_DFL_MIN_ACTIVE (8 by default). This commit thus limits the number of
active dm-zoned chunk works that execute concurrently on a single NUMA
node machine. This reduction results in garbage collection performance
degradation which manifests itself with longer unmount time with the xfs
file system on dm-zoned devices.

To restore unmount duration with dm-zoned devices, drop the WQ_UNBOUND
flag for the chunk workqueue, thus allowing more than WQ_DFL_MIN_ACTIVE
chunk works. Though this change bounds all chunk works to the same CPU,
it provides more parallelism and improved performance. The table below
shows the average xfs unmount time of 10 times measurements, using a
single NUMA node machine with 32 CPUs. The xfs volume was prepared on
dm-zoned devices on top of an SMR HDD with 26GB dm-linear clip, then
filled with data files before executing unmount.

 Kernel              | Unmount time
---------------------+--------------
 v6.8                |   29m  3s
 v6.9-rc2            |   34m 17s
 v6.9-rc2 + this fix |   27m 12s

Suggested-by: Damien Le Moal <dlemoal@kernel.org>
Fixes: 5797b1c18919 ("workqueue: Implement system-wide nr_active enforcement for unbound workqueues")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/md/dm-zoned-target.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 621794a9edd6..3d6383c7b9b2 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -900,8 +900,7 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	/* Chunk BIO work */
 	mutex_init(&dmz->chunk_lock);
 	INIT_RADIX_TREE(&dmz->chunk_rxtree, GFP_NOIO);
-	dmz->chunk_wq = alloc_workqueue("dmz_cwq_%s",
-					WQ_MEM_RECLAIM | WQ_UNBOUND, 0,
+	dmz->chunk_wq = alloc_workqueue("dmz_cwq_%s", WQ_MEM_RECLAIM, 0,
 					dmz_metadata_label(dmz->metadata));
 	if (!dmz->chunk_wq) {
 		ti->error = "Create chunk workqueue failed";
-- 
2.44.0

