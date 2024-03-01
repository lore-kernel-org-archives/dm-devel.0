Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C370F4645B
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267194; cv=none; b=WX4GjONHtm6TsAbwzRnEbkPlDz2xKuiORRBkYWtGqw/cDtFcumt9Fn6y+wpf8O3Bz/ZbIylA2bWLJn/lqihOdtRBml6n21+ksVHo9NwzgEnu98w6L+WXbFwGVKHEmVL90MuO1eTJrXDbRvw1AeIrgSPXyhpxZhybanqRWl/+zJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267194; c=relaxed/simple;
	bh=t0EsVEoVBXL8N0cOMCZvvwmBVNeOFgO0PJdtxr9TOEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gnj8VJWResWZNsBNiiPEbnqz7kUkcfGhZSMRnyuheGQ4HCJ/+vk7IcHecV0oL0NbTDF/dBFw2hs4WbcUWBHHTphbO+LZBzD85Xx4Qf5MU6Ne6+20UZEBetHgvIv/DBWDkb2L9iTrAZow9Dfrmi3tHYokv7sj0BCqbq2o2nbXN/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D5GcnR9V; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D5GcnR9V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N81vUnE3X1Mdbge0DdnWb/3IxUXkbPiUMgCtx/2Nsvk=;
	b=D5GcnR9V9PAp2ap9nkvVx0YUkUW5S1CVxEhLR/XKlZB52DhS2+Ni5V3PT3obunDj81WMcJ
	ZMIoV/3BFbGV1aLFyfq8gtIVbXNBsFhgfGc22YtHrAGwb2FgaNsnTOAl9DFVKLisApX1LL
	4j0Deqa8/EB6J1TVsL796+q5Uh32VYI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-o-Hh3LcDMRus1S_JKfSDbQ-1; Thu, 29 Feb 2024 23:26:30 -0500
X-MC-Unique: o-Hh3LcDMRus1S_JKfSDbQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14435800074;
	Fri,  1 Mar 2024 04:26:30 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0D4AE1BDB1;
	Fri,  1 Mar 2024 04:26:29 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id E0D34A15D5; Thu, 29 Feb 2024 23:26:29 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 06/11] dm vdo: Modify mismatched function name
Date: Thu, 29 Feb 2024 23:26:24 -0500
Message-ID: <d676b3605dce3252e8164b1803a6bcd61f964879.1709266694.git.msakai@redhat.com>
In-Reply-To: <cover.1709266694.git.msakai@redhat.com>
References: <cover.1709266694.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

No functional modification involved.

src/c++/vdo/base/flush.c:97: warning: expecting prototype for waiter_as_flush(). Prototype was for vdo_waiter_as_flush() instead.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/flush.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/flush.c b/drivers/md/dm-vdo/flush.c
index 391b6203efc6..1bc13470a608 100644
--- a/drivers/md/dm-vdo/flush.c
+++ b/drivers/md/dm-vdo/flush.c
@@ -88,7 +88,7 @@ static inline struct vdo_flush *completion_as_vdo_flush(struct vdo_completion *c
 }
 
 /**
- * waiter_as_flush() - Convert a vdo_flush's generic wait queue entry back to the vdo_flush.
+ * vdo_waiter_as_flush() - Convert a vdo_flush's generic wait queue entry back to the vdo_flush.
  * @waiter: The wait queue entry to convert.
  *
  * Return: The wait queue entry as a vdo_flush.
-- 
2.42.0

