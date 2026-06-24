Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EC03D8101
	for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 14:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782312782; cv=none; b=bRWJPqD2y1g+/bsCp5Wjow9Ev+a8Yza4/uexATZmCU5vGO1/9VKpCaH5zOfdxd93YypL4TedrwdDdDbhmOFeK2P5R6HjKXcVN1E30cUS/gbzRvEi7a7v74PIfVAnaKkQfzSBzO7NlNrP0hAx3cH4ogu8iSXsHzmLYcrr4Hr4YJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782312782; c=relaxed/simple;
	bh=fhVAs1PwPsfdnQ9Jjcy50CGNbeAplv8b8R0CwAfUEYE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZZnbDUIDElZIcc4QXm2zTi4Zjo1b8deBKikqRULIzYVFWOiktLdCz1OVERwe4VZY7X8D9NNY1ChaYuZq1ABdEhcD4TYMY0AMEln7G5G/BWRmhm0cimUMgSn55pOydYEAJfODMy5y01XhwoP80tkrUdXAzCoZfZPXFF8C+yS3m7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R4Rd5t0I; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R4Rd5t0I"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490ac357c55so10198265e9.1
        for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 07:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782312776; x=1782917576; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yBjOt8jVsqUKTnLTmqCowSfB7pi5Ax3g2yW+bcIaGZQ=;
        b=R4Rd5t0IYyV3ntsnE5qJpwwA17W/Sy6QaGSKy96AV8bk3Y1S0XdGwWhKy1RmIzmgwv
         //ak/+67gZJ4A3uR116eiLzfF0x+/+IRvPssN0FhSk9jxUTii51jVFkCfAhnS0jRjh7L
         7WNdTWEKbA3+uSo8tnV96HkAkfDU2EfAidSuy8I6jajK9b5VkVcPL0ycuhLVpAovXw1+
         tbjEXzzZbIgjNhePKwS/TkiurwSfTufXlPC09wk1DA+yE40S1TRmvYK4l6gmqEI8rocv
         wWbHUi88ltECvPJWCJmgj7J/Kn7RZR8EAS280pxXTwNyT0/HT1ngYD+e20XhyVsqvZdG
         i+5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782312776; x=1782917576;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yBjOt8jVsqUKTnLTmqCowSfB7pi5Ax3g2yW+bcIaGZQ=;
        b=js5w4YdTF+kF85hQ1IU1gSDTl28VfwdnWhXRyGbFt5TQ3gWS18qwSYp4RqxAKWFEON
         RcKs4ObSTi6/DMZkGTwCL4EjJ3iOPpVMkRnVWnrykI4qqUQoDdYnlXLn32WvRJqYgtCB
         38BYj0Fbf1n3qbVtvfcOoNAi/eNXrKJ1j6dn+zb1J7JCcgHqPVmsKljjITWRKWTHvF7H
         t4Ipwg85Xd4m3kDlVWTST/6mY/fGQr1wy5WEQrnJmyIQQpR5KT+VD/6uwvfgamBM4jwD
         FIPaa1nfke10071tlze8V01J7C9iaFML33Xwa74dOaJuNriCSPklI6Mxlvx/l//bqrOt
         FjwQ==
X-Forwarded-Encrypted: i=1; AFNElJ8BtiTW5PAnf7u6cfxpJT9U3/DGYPuYdJm01Z095enI9E5J4bdRjpteH8DDU0qiFaVtIrZD1/tEQQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YynEavjvBnm13Ry24bKSrnq59hMxlC+lBU+Zv6ZlEMeOQQQKrq9
	Diq1mmSK8qot5vOnTWti2WYaRjFP4nau7Qwa0ufsLaaLS0/bvJ0bCb7V
X-Gm-Gg: AfdE7ck4hM4sQwD0/Xx2Pic2BsPlyCpEB1PzYec+LEn0FYbxCdu46le/d5AQIk8+Sxw
	Xlsy+QHPM3SRM+rAwUhJXfZdhiL0yM5GoeCi7H9N3We+ow3gSOgV0uo5TFlL3myVpgmbLRDIASA
	AVJF9CughpIS3UHyQ8jeGpcFV8GDlfZYALdNa80kQpqlxM/zwXdNHJ4uGMdLQQOhD0klq+ysm5C
	MN0eeGGfe6Qjdii9TDDzRnZwWodjZgVHtrusjreetIXnneGs/ACc6n4OYC1D9D/Ng28+9wWe8kw
	PK28G6RNX9Pj2RA/lWxYnQQldktjNi+bTXorv3WiIaPJZ1n+N/gkbIoQerJ9u3thyQ1PE7SWVoV
	X183jCCGvAV0O4L3JQg1RXrpT5xf3zmfoI0jVOrf8rlvpoKz792AyIyDz2iFb3QWDXQUh8fwcKx
	zJn8ydaTUSxROyT9Gvv/FfBYGKCEOpdIyMHjnS0kh0ipMvcR702ACTlPvh72+BPE2PPp+yGyHl3
	AavTOnY
X-Received: by 2002:a05:600d:4448:20b0:492:2f59:4969 with SMTP id 5b1f17b1804b1-4926086c381mr45682085e9.22.1782312776193;
        Wed, 24 Jun 2026 07:52:56 -0700 (PDT)
Received: from snowdrop.snailnet.com (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4924923392dsm735988005e9.2.2026.06.24.07.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 07:52:55 -0700 (PDT)
From: David Laight <david.laight.linux@gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>,
	Tony Asleson <tasleson@redhat.com>,
	"Bryn M . Reeves" <bmr@redhat.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: David Laight <david.laight.linux@gmail.com>
Subject: [PATCH 3/3] dm: lookup_ioctl(): Use designated array initialers
Date: Wed, 24 Jun 2026 15:52:43 +0100
Message-Id: <20260624145243.2736-4-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260624145243.2736-1-david.laight.linux@gmail.com>
References: <20260624145243.2736-1-david.laight.linux@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use designated initialisers for the _ioctls[] array and delete the
unused field that contained the array index.

Makes the code more robust against the order of the initialers.
Any uninitialised entries would be processed corretly.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
 drivers/md/dm-ioctl.c | 47 +++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 57cfbc12c0ce..2ba1eda1c9dd 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1851,33 +1851,32 @@ static int target_message(struct file *filp, struct dm_ioctl *param, size_t para
 static ioctl_fn lookup_ioctl(unsigned int cmd, int *ioctl_flags)
 {
 	static const struct {
-		int cmd;
 		int flags;
 		ioctl_fn fn;
 	} _ioctls[] = {
-		{DM_VERSION_CMD, 0, NULL}, /* version is dealt with elsewhere */
-		{DM_REMOVE_ALL_CMD, IOCTL_FLAGS_NO_PARAMS | IOCTL_FLAGS_ISSUE_GLOBAL_EVENT, remove_all},
-		{DM_LIST_DEVICES_CMD, 0, list_devices},
-
-		{DM_DEV_CREATE_CMD, IOCTL_FLAGS_NO_PARAMS | IOCTL_FLAGS_ISSUE_GLOBAL_EVENT, dev_create},
-		{DM_DEV_REMOVE_CMD, IOCTL_FLAGS_NO_PARAMS | IOCTL_FLAGS_ISSUE_GLOBAL_EVENT, dev_remove},
-		{DM_DEV_RENAME_CMD, IOCTL_FLAGS_ISSUE_GLOBAL_EVENT, dev_rename},
-		{DM_DEV_SUSPEND_CMD, IOCTL_FLAGS_NO_PARAMS, dev_suspend},
-		{DM_DEV_STATUS_CMD, IOCTL_FLAGS_NO_PARAMS, dev_status},
-		{DM_DEV_WAIT_CMD, 0, dev_wait},
-
-		{DM_TABLE_LOAD_CMD, 0, table_load},
-		{DM_TABLE_CLEAR_CMD, IOCTL_FLAGS_NO_PARAMS, table_clear},
-		{DM_TABLE_DEPS_CMD, 0, table_deps},
-		{DM_TABLE_STATUS_CMD, 0, table_status},
-
-		{DM_LIST_VERSIONS_CMD, 0, list_versions},
-
-		{DM_TARGET_MSG_CMD, 0, target_message},
-		{DM_DEV_SET_GEOMETRY_CMD, 0, dev_set_geometry},
-		{DM_DEV_ARM_POLL_CMD, IOCTL_FLAGS_NO_PARAMS, dev_arm_poll},
-		{DM_GET_TARGET_VERSION_CMD, 0, get_target_version},
-		{DM_MPATH_PROBE_PATHS_CMD, 0, NULL}, /* block device ioctl */
+		[DM_VERSION_CMD] = {0, NULL}, /* version is dealt with elsewhere */
+		[DM_REMOVE_ALL_CMD] = {IOCTL_FLAGS_NO_PARAMS | IOCTL_FLAGS_ISSUE_GLOBAL_EVENT, remove_all},
+		[DM_LIST_DEVICES_CMD] = {0, list_devices},
+
+		[DM_DEV_CREATE_CMD] = {IOCTL_FLAGS_NO_PARAMS | IOCTL_FLAGS_ISSUE_GLOBAL_EVENT, dev_create},
+		[DM_DEV_REMOVE_CMD] = {IOCTL_FLAGS_NO_PARAMS | IOCTL_FLAGS_ISSUE_GLOBAL_EVENT, dev_remove},
+		[DM_DEV_RENAME_CMD] = {IOCTL_FLAGS_ISSUE_GLOBAL_EVENT, dev_rename},
+		[DM_DEV_SUSPEND_CMD] = {IOCTL_FLAGS_NO_PARAMS, dev_suspend},
+		[DM_DEV_STATUS_CMD] = {IOCTL_FLAGS_NO_PARAMS, dev_status},
+		[DM_DEV_WAIT_CMD] = {0, dev_wait},
+
+		[DM_TABLE_LOAD_CMD] = {0, table_load},
+		[DM_TABLE_CLEAR_CMD] = {IOCTL_FLAGS_NO_PARAMS, table_clear},
+		[DM_TABLE_DEPS_CMD] = {0, table_deps},
+		[DM_TABLE_STATUS_CMD] = {0, table_status},
+
+		[DM_LIST_VERSIONS_CMD] = {0, list_versions},
+
+		[DM_TARGET_MSG_CMD] = {0, target_message},
+		[DM_DEV_SET_GEOMETRY_CMD] = {0, dev_set_geometry},
+		[DM_DEV_ARM_POLL_CMD] = {IOCTL_FLAGS_NO_PARAMS, dev_arm_poll},
+		[DM_GET_TARGET_VERSION_CMD] = {0, get_target_version},
+		[DM_MPATH_PROBE_PATHS_CMD] = {0, NULL}, /* block device ioctl */
 	};
 
 	if (unlikely(cmd >= ARRAY_SIZE(_ioctls)))
-- 
2.39.5

