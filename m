Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53553DB86
	for <dm-devel@lists.linux.dev>; Wed, 21 Feb 2024 09:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708507101; cv=none; b=UX9p3wOVAn2H0LG01pQOycEDOR5pQ2DlnE65iN7HS0hwflPD2sLXUyrh+jQbLEdbCbA9biIeqbbeDjE/rE+gESze7f11Wrk/LYxP+NktfjqGZlXLMKIRpYj9nDzpc45G8gaWV6XHfLaN0OfEQ3ERBKsHhz937L92+8K+Njb2JwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708507101; c=relaxed/simple;
	bh=3KXb9nXpObxqm6iBD7n6ssU5Vsa79GNEX+w8fQbJzKY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cA2F3BR3Yteh5o3Iy8Fx7HomUq/nKiBHtSnzXdFqawvyls/zegnS0y+hz2fIU47+fgf63seMZ7bonFW9etR4TVTXmROezsN6+gk4Z+2pTsJnxGk43nqCeMmGSvucdxljRkWqBuXftxcqzADmq5sP4Ec06a5tCZh+wOrYbBqVr6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Hja2l3Tc; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Hja2l3Tc"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1708507092; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=hCL7kDhpLqny3OO9KnxYcH7qd7yJnytkUmwgoFbh7d0=;
	b=Hja2l3Tc24Dh7ZXHxNuhOx8dRPj2Lu7Dq77PoYXK8P5UCovcQzEWW3xEoP7GOcQOWph5Sz8JZ4Wczrxx6JSAZQEvH1DpJ8spj1jjzy6w57iDJaIO0xrviiVru7/wPPa1hhrIazOkNUNO/9EVcL/uA771ntuFWYHADJzUeo90j1w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0W0zPi4s_1708507089;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0W0zPi4s_1708507089)
          by smtp.aliyun-inc.com;
          Wed, 21 Feb 2024 17:18:11 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: msakai@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH 4/8] dm vdo: Modify mismatched function name
Date: Wed, 21 Feb 2024 17:17:28 +0800
Message-Id: <20240221091731.7007-5-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
In-Reply-To: <20240221091731.7007-1-jiapeng.chong@linux.alibaba.com>
References: <20240221091731.7007-1-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No functional modification involved.

drivers/md/dm-vdo/logical-zone.c:303: warning: expecting prototype for void attempt_generation_complete_notification()(). Prototype was for attempt_generation_complete_notification() instead.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=8276
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/md/dm-vdo/logical-zone.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/logical-zone.c b/drivers/md/dm-vdo/logical-zone.c
index a040fe9c0779..131161e0c152 100644
--- a/drivers/md/dm-vdo/logical-zone.c
+++ b/drivers/md/dm-vdo/logical-zone.c
@@ -295,7 +295,7 @@ static void notify_flusher(struct vdo_completion *completion)
 }
 
 /**
- * void attempt_generation_complete_notification() - Notify the flusher if some generation no
+ * attempt_generation_complete_notification() - Notify the flusher if some generation no
  *                                                   longer has active VIOs.
  * @completion: The zone completion.
  */
-- 
2.20.1.7.g153144c

