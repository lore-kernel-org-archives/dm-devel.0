Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB2843C057
	for <dm-devel@lists.linux.dev>; Mon, 29 Jun 2026 15:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782747464; cv=none; b=oU+5KO9SJh/BTdngRMQYnhabtuXQYbkIRskOZ92iRxnBx2l0f3jx1eO+0FUfMHEtttNx2GFvUswZNshwYM6Uc9uhQTzejmxJZUe8fPmZmPvDNX5gsL6aFGcuFVy1n4pLpqcy858wfK83gxs14/qX6kqINqdjXJfGJgVqAhfE2F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782747464; c=relaxed/simple;
	bh=EwsK5YC4nvvN4juEL4G8z/eyn97NdgF6/tOCvLHgRD8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CGqwvIekKaDzS27WhSqvobcSGqTH6vnbpvD4K72aW2ZvMnGGXWuv0lt7rgc1qOMfvUMfWJZ313XPwH6sUMlCVfrF6XpwaLa2mW7wFV1P9F1D/I2d8al7KUBElgnG60uS7vcREXAVbHhUmOV6bCoyzbmjBCk3+nIF2Qkv0bM7DCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=Tfr4cuMS; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=vUHJD4gD; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="Tfr4cuMS";
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="vUHJD4gD"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4gpr502sYGz9tsk;
	Mon, 29 Jun 2026 17:37:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1782747460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XMMBFhz0UKrFRcJeL1Bsan4vTZxrHHTrF4ThDim2Es8=;
	b=Tfr4cuMSOjnJZ9HC+l1fXJLyNJBxMa+/uyx31rMMBhXHONCT4NQu6jmXUuFriXGU3OamSY
	318+IyZU5SHUNp5KBhxxRmu1x5S6XiDS3Gg7hMqpUllW8bAk1aT+JkUFedcQPhHEmtWrKM
	HDjQ1DTichQY6AkjpcJMBOOVQiRFW29IQ66NqYOmm6pbmCVYJXNGk/cwa+g7JYLhjYzcmT
	C57sw4U+GxnvC10izY3X+2ciiwDHoA3gTt48P2nVYSOGDrTRzTN9PtLSqtnSKFnGJjViHb
	uTTTOYDIcqRDbSBPGC1bg6QqHmZmOWguvLqsot5ABnIhL58DaAXq1q6QVecohQ==
Authentication-Results: outgoing_mbo_mout;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=vUHJD4gD;
	spf=pass (outgoing_mbo_mout: domain of manuelebner@mailbox.org designates 2001:67c:2050:b231:465::202 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org
From: Manuel Ebner <manuelebner@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1782747458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XMMBFhz0UKrFRcJeL1Bsan4vTZxrHHTrF4ThDim2Es8=;
	b=vUHJD4gDXB7rBgrMQAP2kqRWzalShfiEkSUQXpMRibEh58lg7fLe+03jA8R3ESg57ZCQYD
	YUWoocibkT6L3bufs+AVkJRuB7ELpxxacV9oRuMyk3saKPm/a47ayvrOmTdyZJrr8RdMhn
	4LKMpFcjpfs7/DQhmdpscu2LxVPFNEMDM+dxg/LVAqdoeN1wFxba50Q0x6z0MxNF5oWvp1
	EjTFWx6x8JRwBar9zXJDtal6Yqn7q/miTpOvk0RZfS0RYA8oaZUc/Vm6sOhudommY4bybR
	Ti/daxr4WsgnNXYMlXLbP4BHjXOirjZk4lCZBYhS6W/U1Ew219LlkmBrqQ/BCg==
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-doc@vger.kernel.org (open list:DOCUMENTATION),
	linux-kernel@vger.kernel.org (open list)
Cc: Manuel Ebner <manuelebner@mailbox.org>
Subject: [PATCH v2] Documentation: device-mapper: adopt new coding style of type-aware kmalloc-family
Date: Mon, 29 Jun 2026 17:35:00 +0200
Message-ID: <20260629153458.87029-3-manuelebner@mailbox.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-ID: e6329a7e99dffda4c91
X-MBO-RS-META: a95m11qyxo4jsautasoxsnci9bz1qqty
X-Rspamd-Queue-Id: 4gpr502sYGz9tsk

Change the Documentation to reflect this commit 69050f8d6d07 ("treewide: Replace
kmalloc with kmalloc_obj for non-scalar types")
kmalloc -> kmalloc_objs()

Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
---
[v2]
 added '()' for automarkup

 Documentation/admin-guide/device-mapper/statistics.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/device-mapper/statistics.rst b/Documentation/admin-guide/device-mapper/statistics.rst
index 41ded0bc5933..517b6d576826 100644
--- a/Documentation/admin-guide/device-mapper/statistics.rst
+++ b/Documentation/admin-guide/device-mapper/statistics.rst
@@ -30,7 +30,7 @@ region, etc.  Unique region_ids enable multiple userspace programs to
 request and process statistics for the same DM device without stepping
 on each other's data.
 
-The creation of DM statistics will allocate memory via kmalloc or
+The creation of DM statistics will allocate memory via kmalloc_objs() or
 fallback to using vmalloc space.  At most, 1/4 of the overall system
 memory may be allocated by DM statistics.  The admin can see how much
 memory is used by reading:
-- 
2.54.0

