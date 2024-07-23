Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D44A28E8
	for <dm-devel@lists.linux.dev>; Tue, 23 Jul 2024 04:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721710746; cv=none; b=AuCSg4SFCW/PDU34uR7jfwd+Urr81sw5iVQsmsnRtfB8EOOEgF63Fc1Kw5B9CwSyRDEDijhQFkwLHTBbq0ru2D2FchgARU9AigQE+6GMOTUBJoyZ7CT9AXMSb51ZuJ93iDOagBvFkJ8my/iGSxRS7W7Wn21V3OdzBypiuveeacw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721710746; c=relaxed/simple;
	bh=IG9tv2lJqgWWyEhDdDFHWTQNUzWsWiPoAZ7xPoRUk9E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UQfvlBlIlVdmR0T9fPtiFaFxZIUOyJWjKLUHyEbN50X+XSmk7c6CWPhjCMBObmp1ZHExmPFNboAdX6cjFxEUfsgoienMN8WifruUKVpgRnM+tLtxXPSzAJF6k0J5siXmPo9DvmW9RehXNPLd9hvArFipCRBoSM4eG+IRW7r7r3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=b5yQZyEF; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="b5yQZyEF"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1721710744; x=1753246744;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IG9tv2lJqgWWyEhDdDFHWTQNUzWsWiPoAZ7xPoRUk9E=;
  b=b5yQZyEFGFXx6Sxl2ufz/Ufa3YnKYJszw7BOkQBdTVG36Y6Joawrp5n9
   SrS6uVO8u/IenrYIIvz+aIYIMpdb4nq7DMGh3dmLLdPwmS5+G9+VnkVWn
   eKZxmWMLKI70eEDDxkrgvOwSde1hTdT3K8GLUWhKXO+yFpVfsNt4vasFR
   jZLCgw55IlCGimsgdVOzCpi08NgRrcpXsAfikkTcEE/z1ZaRu2MUthiyS
   U8nkL8TbpL52Es46dg1voaw/HvuHmKxge1BPppNN6tk/4sMcoBPCUs5/N
   kV5SzJXZtNX7QFymCnSp867KAa1b3EAolrHpGV6iZIewJGrdhyfuFuNE7
   w==;
X-CSE-ConnectionGUID: 3uWZcLsxRmadJRu/xhU+Lg==
X-CSE-MsgGUID: mGgKZmwkSzK1xH9Rbgh3EA==
X-IronPort-AV: E=Sophos;i="6.09,229,1716220800"; 
   d="scan'208";a="23104326"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jul 2024 12:58:56 +0800
IronPort-SDR: 669f2aa9_L53zfixvRaouEpmJcbQQ/D43KWA8hc39YlvvVc9Sc0lGGyb
 F2+7FvKKgLyjbGcs42yoJg8SEL+UWHMu97UKI7Q==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jul 2024 20:59:37 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 22 Jul 2024 21:58:55 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev
Cc: Bart Van Assche <bvanassche@acm.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Milan Broz <gmazyland@gmail.com>,
	Bryan Gurney <bgurney@redhat.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH blktests v3] dm/002: add --retry option to dmsetup remove command
Date: Tue, 23 Jul 2024 13:58:55 +0900
Message-ID: <20240723045855.304279-1-shinichiro.kawasaki@wdc.com>
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

When udev opens the dm device, "dmsetup remove" command also tries to
open the device and fails with EBUSY. To avoid the failure, add the
--retry option to the dmsetup command.

Suggested-by: Milan Broz <gmazyland@gmail.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
This patch addresses a failure found during the debug work for another
dm/002 failure [1].

[1] https://lore.kernel.org/linux-block/42ecobcsduvlqh77iavjj2p3ewdh7u4opdz4xruauz4u5ddljz@yr7ye4fq72tr/

Changes from v2:
* "dmsetup remove --retry " instead of "udevadm settle"
Changes from v1:
* "udevadm settle" instead of retrying "dmsetup remove"

 tests/dm/002 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/dm/002 b/tests/dm/002
index fae3986..ea3f684 100755
--- a/tests/dm/002
+++ b/tests/dm/002
@@ -37,7 +37,7 @@ test_device() {
 	sync
 	dmsetup message dust1 0 countbadblocks
 	sync
-	dmsetup remove dust1
+	dmsetup remove --retry dust1 |& grep -v "Device or resource busy"
 
 	echo "Test complete"
 }
-- 
2.45.2

