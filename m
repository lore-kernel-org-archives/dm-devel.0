Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32F53C6BA
	for <dm-devel@lists.linux.dev>; Wed, 21 Feb 2024 09:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708507078; cv=none; b=VcvJU9ec8LARk5/jYAxxf60rhlxHoomlEGbYWCAVSQonfQDnNyAPZG6Ag+PRCCsjCZQ/ga/4oSpEYvUAup4BrJ5uAyZUxiSkCVfauU1gmTSMqgJjRWT5Mhp1ceYE8qKZaDrayBSatNt1FjwED9xvDTNGh56EU40sKOYxXliTSCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708507078; c=relaxed/simple;
	bh=G2NE9a3jMDn12v81Nz9NQjkLjoIDixLqd4nghLAIyiE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pHCTr1CJT/HcRdqJSNvgn5Lq8qVxnXiepXWLotPNJS/FVGd2Vm/bLp3oUZZi97Jab1L61vFx/F4K+Fhyw8VOj/wdSktpdh1GwImQTqYvHpgzf9D7SXX0IVDQr2iCiu0Au7B5P8LWUlUkrmoTLkjh4ZTVhyS8ibTJZPyPlkosAYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=rXkE1wVI; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="rXkE1wVI"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1708507067; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=TQpuyVvZ75dhIqkp8INYA616KkgNbSy6gSD3mv59K00=;
	b=rXkE1wVIFIkHfKvDlgkBbxKqG/Ngp9XGI0UJmlBTEPRbjBKcgVQ5C6D1kKw3PyGuEYms1v20KHKh3lsg8H/nkNX5tHE21FE4iAteuH6Ap8Wl77QbAXQ9lpfO948CKnUuT30PPAQdtrIK2ZjL4A8ovaswm/PyRudaGSSiKf0kU9c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0W0zPhvC_1708507063;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0W0zPhvC_1708507063)
          by smtp.aliyun-inc.com;
          Wed, 21 Feb 2024 17:17:45 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: msakai@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH 8/8] dm vdo: Modify mismatched function name
Date: Wed, 21 Feb 2024 17:17:24 +0800
Message-Id: <20240221091731.7007-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No functional modification involved.

drivers/md/dm-vdo/admin-state.c:310: warning: expecting prototype for vdo_drain_operation(). Prototype was for assert_vdo_drain_operation() instead.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=8280
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/md/dm-vdo/admin-state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/admin-state.c b/drivers/md/dm-vdo/admin-state.c
index 8663c1e91616..3f9dba525154 100644
--- a/drivers/md/dm-vdo/admin-state.c
+++ b/drivers/md/dm-vdo/admin-state.c
@@ -300,7 +300,7 @@ static bool check_code(bool valid, const struct admin_state_code *code, const ch
 }
 
 /**
- * vdo_drain_operation() - Check that an operation is a drain.
+ * assert_vdo_drain_operation() - Check that an operation is a drain.
  * @waiter The completion to finish with an error if the operation is not a drain.
  *
  * Return: true if the specified operation is a drain.
-- 
2.20.1.7.g153144c

