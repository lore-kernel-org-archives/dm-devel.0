Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CCF3D555
	for <dm-devel@lists.linux.dev>; Wed, 21 Feb 2024 09:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708507092; cv=none; b=uI8BWYARxOT4tOxiBNKy15ELNjWF9ykcSMo8WhNKvM9Lrgi1IO4MVDpE5fSLU36ZwJZwvZrV7yCTpL8vT+X/ris5MbP+jVKSs70xnyze1NdHs/mC057oZTiQ9TzQLAgVC3YQwtwYt67Mb+AeTUo0WXslW2a11HwZ/nFfmpUPX/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708507092; c=relaxed/simple;
	bh=5Lxs48T8AxpFP98KzY19UdH25ICYzMJoceSfQD6LMiI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=crWa50ASQBeuF3ayhuNj19qeA1SpVKHvRkmlKBt6Sd6t7DfvciDrqbNq1SBDd55NjLHYwErofi0T9kYdG5f/3tQOUDW3roCvxkbfYn6BnpWkBUK1cbywnYvcXqKKoDS1W2o971TU9GdXlaZwIGlZIfYZvoPTmr+YpFN4I7ZyI+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=AlLDZCrU; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="AlLDZCrU"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1708507086; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=hXTbZ/tv0rwC9GbkQStp8PP86sctTo9nhY1TiyFUbq4=;
	b=AlLDZCrUz7ZWNqnrRKr7QhYKZAilz7LWir1dUESAEE95MbLNW9NnDWUK6sYOCvwLIgMEuY/n4ACW/MKvwxfXTlAi248XVmR+If8+AxSvElK1KvfnxH8SoWk3IUKY0B/Hdybbn2vywsFe+f11DZbThouM2GrZQYreRPLarRm+fuQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0W0zPi2h_1708507083;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0W0zPi2h_1708507083)
          by smtp.aliyun-inc.com;
          Wed, 21 Feb 2024 17:18:05 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: msakai@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH 5/8] dm vdo: Modify mismatched function name
Date: Wed, 21 Feb 2024 17:17:27 +0800
Message-Id: <20240221091731.7007-4-jiapeng.chong@linux.alibaba.com>
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

drivers/md/dm-vdo/encodings.c:1178: warning: expecting prototype for vdo_decode_component(). Prototype was for decode_vdo_component() instead.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=8277
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/md/dm-vdo/encodings.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/encodings.c b/drivers/md/dm-vdo/encodings.c
index 42ffd793deeb..f4fee2c1d656 100644
--- a/drivers/md/dm-vdo/encodings.c
+++ b/drivers/md/dm-vdo/encodings.c
@@ -1170,7 +1170,7 @@ static struct vdo_component unpack_vdo_component_41_0(struct packed_vdo_componen
 }
 
 /**
- * vdo_decode_component() - Decode the component data for the vdo itself out of the super block.
+ * decode_vdo_component() - Decode the component data for the vdo itself out of the super block.
  *
  * Return: VDO_SUCCESS or an error.
  */
-- 
2.20.1.7.g153144c

