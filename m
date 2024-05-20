Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC1F136986
	for <dm-devel@lists.linux.dev>; Mon, 20 May 2024 15:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716220723; cv=none; b=pLyce0kF3lakdpOIvZjQMq83h9rMSsXEGudOcKovX9CTqkxyZDdvBWBdQy2Vu2nt/JbG2YoIhgrq5+3O9a+5ypkUjNxue8xr01ZygmuCEJgEdu0FVF6+afZxJczf8Jfd4D6Ze5xnQq3vTmT/FeH4wNqGhs64eCDLkhfag9V6YO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716220723; c=relaxed/simple;
	bh=t3mfBSzF4gIvBSfX7jkRegAysI84IrZ1lqd3Qtea+DM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Zbif8u5/YupIihIYXVP1d2x9kMH4ZZ69BoZAAyhCCum4NUPacacs2DCtzdyS3WpOyYEmlpZUxQ9qrOV0/+KbWvXnG6jpMw8YWGwo/KOkV3h8B+u9DJXQBDjBBOxI3nuMVuZhh3s1JkNxfGezUBGLIzdLCACe3ORR/ThHtiOrjxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dXN0YZCC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dXN0YZCC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716220720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kSK2a4NXM+01L73sT13tW+y4QN80BSHVPrc8TenqHmM=;
	b=dXN0YZCCh1Yo7Cef9BMkd1kFOqTc2o6glS31HwQn1n+xzsItVMWTy/sxlnvBnQCoKAQ07C
	L0BoqVWFePpqGzz/VP+i3m0/P2S/WuId/uF2uGFyWY8c+Xmvlf4g80pdo4Bs/PAK/89inw
	F9GoLlJgcpV7N70IKRYmThQESSLj4Po=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-eaFpYAHbN-C-r68a1wfmlQ-1; Mon, 20 May 2024 11:58:38 -0400
X-MC-Unique: eaFpYAHbN-C-r68a1wfmlQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3BC7A81101E;
	Mon, 20 May 2024 15:58:38 +0000 (UTC)
Received: from bgurney-thinkpadp1gen5.remote.csb (unknown [10.22.9.110])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E867491032;
	Mon, 20 May 2024 15:58:37 +0000 (UTC)
From: Bryan Gurney <bgurney@redhat.com>
To: shinichiro.kawasaki@wdc.com,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	snitzer@kernel.org,
	bgurney@redhat.com
Subject: [PATCH] tests/dm: add dm-dust general functionality test
Date: Mon, 20 May 2024 11:58:26 -0400
Message-ID: <20240520155826.23446-1-bgurney@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

Add a general functionality test for the dm-dust device-mapper test
target.  Test the addition of bad blocks, and the clearing of bad
blocks after a write is performed to the test device.

Signed-off-by: Bryan Gurney <bgurney@redhat.com>
---
 tests/dm/002     | 40 ++++++++++++++++++++++++++++++++++++++++
 tests/dm/002.out | 10 ++++++++++
 2 files changed, 50 insertions(+)
 create mode 100755 tests/dm/002
 create mode 100644 tests/dm/002.out

diff --git a/tests/dm/002 b/tests/dm/002
new file mode 100755
index 0000000..6635c43
--- /dev/null
+++ b/tests/dm/002
@@ -0,0 +1,40 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-3.0+
+# Copyright (C) 2024 Red Hat, Inc.
+#
+
+. tests/dm/rc
+
+DESCRIPTION="dm-dust general functionality test"
+QUICK=1
+
+requires() {
+        _have_driver dm_dust
+}
+
+
+test_device() {
+	echo "Running ${TEST_NAME}"
+
+	TEST_DEV_SZ=$(blockdev --getsz "$TEST_DEV")
+	dmsetup create dust1 --table "0 $TEST_DEV_SZ dust $TEST_DEV 0 512"
+	dmsetup message dust1 0 addbadblock 60
+	dmsetup message dust1 0 addbadblock 67
+	dmsetup message dust1 0 addbadblock 72
+	dmsetup message dust1 0 countbadblocks
+	dmsetup message dust1 0 listbadblocks
+	dmsetup message dust1 0 clearbadblocks
+	dmsetup message dust1 0 countbadblocks
+	dmsetup message dust1 0 addbadblock 60
+	dmsetup message dust1 0 addbadblock 67
+	dmsetup message dust1 0 addbadblock 72
+	dmsetup message dust1 0 countbadblocks
+	dmsetup message dust1 0 enable
+	dd if=/dev/zero of=/dev/mapper/dust1 bs=512 count=128 oflag=direct >/dev/null 2>&1 || return $?
+	sync
+	dmsetup message dust1 0 countbadblocks
+	sync
+	dmsetup remove dust1
+
+	echo "Test complete"
+}
diff --git a/tests/dm/002.out b/tests/dm/002.out
new file mode 100644
index 0000000..f348fe4
--- /dev/null
+++ b/tests/dm/002.out
@@ -0,0 +1,10 @@
+Running dm/002
+countbadblocks: 3 badblock(s) found
+60
+67
+72
+dust_clear_badblocks: badblocks cleared
+countbadblocks: 0 badblock(s) found
+countbadblocks: 3 badblock(s) found
+countbadblocks: 0 badblock(s) found
+Test complete
-- 
2.45.0

