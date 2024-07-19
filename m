Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E2C10A0E
	for <dm-devel@lists.linux.dev>; Fri, 19 Jul 2024 04:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721363070; cv=none; b=ZP028aoZsWnAqYROp0hh5PwpiY76Ftqn3i8T/pPy8BlZo434byo2cXGC3t93KJ8TZY71Xw9bInQVvBnD/C153OUqKIB6VsncTbR7PUwt10wYcej0NMcSfXTw+C1u+6jIXpJi1k5B9nFvh5UWKh7nI/jTry63SmN3RSMtgxIBNno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721363070; c=relaxed/simple;
	bh=jthn04xqR+Z7w1/8UDZpuHSwMjHCJG+16Xj9m+y0AQg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N+nY7a/lsFLZq0Oh/n+nZr79aH+7m+byn/rKxwq9fnM0Rays7RP2mo5REVH+CDymwk8BihXQ9NudY20E/KLfvBnn6ska9HvbaM0+7coxHlPCRZ05CUKot3NjjrRAbVbCKOgLHVxlP0datS+MLO8bpXQ9Ck/TbdBA1axlySDO0Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=cE157BJk; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="cE157BJk"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1721363068; x=1752899068;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jthn04xqR+Z7w1/8UDZpuHSwMjHCJG+16Xj9m+y0AQg=;
  b=cE157BJk0jPYUqjFjtcDDrC9hG7zVH59uqVH5VSqYDO1KE9L3ssQXqUK
   ONBkdHNHie1MHPIhS7qj0IUrHqSe+3e0w8OlJXTxc8jUV71262tIAlxjq
   Wf2mF0JScKBc7nPtYM9VIYBLVZHrtRvGSZvbxNYNs9EmAX8/Mle4TzCb7
   7q5M14P85zSAyL6tBqll1+iEfYD9rUOfYaLVL1aPtzwhH2+DnmO9x4upg
   VZnrXOKFojvmMyat5elDWqhfUV6EMrqV9Mhr5DywXkL1rkDqjo8+7d1us
   BI6Hom9tBDQsgYRqKI5Ck+7yA+FEm5GLhEULNxuMpC5K5GqNxSGEAN+xT
   w==;
X-CSE-ConnectionGUID: +RNbt3IzRha5afzXUfoiWw==
X-CSE-MsgGUID: 6xZdUS6lRxCbuccwioLmyQ==
X-IronPort-AV: E=Sophos;i="6.09,219,1716220800"; 
   d="scan'208";a="22152084"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2024 12:23:20 +0800
IronPort-SDR: 6699dc55_jiHzdSBMZbkDaCP/cxA8iDvnKKV2cZ6YKiHJEKpslS2LqSp
 PgqSUNGYEYGjio1QbFm8sKC5c2zf3CjVbZBp4LA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Jul 2024 20:24:05 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 18 Jul 2024 21:23:19 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev
Cc: Bart Van Assche <bvanassche@acm.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Bryan Gurney <bgurney@redhat.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH blktests v2] dm/002: avoid device access by udev at dmsetup remove
Date: Fri, 19 Jul 2024 13:23:18 +0900
Message-ID: <20240719042318.265227-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The test case dm/002 rarely fails with the message below:

dm/002 => nvme0n1 (dm-dust general functionality test)       [failed]
    runtime  0.204s  ...  0.174s
    --- tests/dm/002.out        2024-06-14 14:37:40.480794693 +0900
    +++ /home/shin/Blktests/blktests/results/nvme0n1/dm/002.out.bad     2024-06-14 21:38:18.588976499 +0900
    @@ -7,4 +7,6 @@
     countbadblocks: 0 badblock(s) found
     countbadblocks: 3 badblock(s) found
     countbadblocks: 0 badblock(s) found
    +device-mapper: remove ioctl on dust1  failed: Device or resource busy
    +Command failed.
     Test complete
modprobe: FATAL: Module dm_dust is in use.

This failure happens when udev opens the dm device at "dmsetup remove"
command. To avoid the failure, call "udevadm settle" before the "dmsetup
remove" command.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
This patch addresses a failure found during the debug work for another
dm/002 failure [1]. Per discussion on v1 patch [2], do "udevadm settle"
instead of retrying "dmsetup remove".

[1] https://lore.kernel.org/linux-block/42ecobcsduvlqh77iavjj2p3ewdh7u4opdz4xruauz4u5ddljz@yr7ye4fq72tr/
[2] https://lore.kernel.org/linux-block/o5wik4yvo2teffpjlwycbaek6znrtde5kml3hkof5r2w5rxttj@bhokt2ksdcbj/

 tests/dm/002 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/dm/002 b/tests/dm/002
index fae3986..afa174a 100755
--- a/tests/dm/002
+++ b/tests/dm/002
@@ -37,6 +37,7 @@ test_device() {
 	sync
 	dmsetup message dust1 0 countbadblocks
 	sync
+	udevadm settle
 	dmsetup remove dust1
 
 	echo "Test complete"
-- 
2.45.2

