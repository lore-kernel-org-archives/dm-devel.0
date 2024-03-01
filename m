Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE213FE54
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267194; cv=none; b=BtGV6JOCyW7OZJxERT3qtGmP9OgNtJi5dBcPyL1oni0kZ9zBKQadIBnW+GBtXJZLNBvwZr922qTriKnwq+I8lQK9DUUeWueeEWPmvde82bpe1xdBBUocRyCjWnkeALZfsN+N4n/KK87t7jXuIpkQ8nr1kZlF3DtH2PLbbT6AVb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267194; c=relaxed/simple;
	bh=1bqxSgEpBJCIl5GKT66u9dmjPUGrfqnmFaEw/wkyTqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dQWBLwjX7cTGfpTREYcVboJX0+R58wlsaDkYYQc32S32TjiaDDcQGsrjgO4DI+HdWGlVMD3eSHPzSKHs1DEnmOl1eQfQCcCn0k10ahdrf6SD7zIr4O55n1fiwqR/uXWwbxabPiBs2AUoTleoyaVAxw9yY5ijRqz2fUYFYaiPolA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UF0x2ejh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UF0x2ejh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jkdnC//96V0kYtA+850a/JsUcKumW63KLUAnXfLbZO0=;
	b=UF0x2ejhqnhIOJkGM91b9MXf9nrMDTw7I6t261SpLVgXUtUfMoJWvs4Eb1Sz40ulXdK7OU
	yIHN+gojEXlHKEo1bhIMwhUXHb74wH6nDlaYZe1nINTEO9S7UAV3oBnzV6s54YJOP/hTCW
	7kfAZdJaRwiG2U2Sxkze2DLP8QTFtNg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-557-zR1ysKfZNhOBj6TdlJ4eEw-1; Thu, 29 Feb 2024 23:26:30 -0500
X-MC-Unique: zR1ysKfZNhOBj6TdlJ4eEw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1261A185A783;
	Fri,  1 Mar 2024 04:26:30 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0D2631121312;
	Fri,  1 Mar 2024 04:26:29 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id C762AA15CB; Thu, 29 Feb 2024 23:26:29 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 01/11] dm vdo: Modify mismatched function name
Date: Thu, 29 Feb 2024 23:26:19 -0500
Message-ID: <4dc27b1fe3b8520914b08ffe98f9ff7dcefa7f6d.1709266694.git.msakai@redhat.com>
In-Reply-To: <cover.1709266694.git.msakai@redhat.com>
References: <cover.1709266694.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

No functional modification involved.

src/c++/vdo/base/vdo.c:276: warning: expecting prototype for vdo_read_geometry_block(). Prototype was for read_geometry_block() instead.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/vdo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index a40f059d39b3..c161dffeb91a 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -267,8 +267,8 @@ static int __must_check initialize_thread_config(struct thread_count_config coun
 }
 
 /**
- * vdo_read_geometry_block() - Synchronously read the geometry block from a vdo's underlying block
- *                             device.
+ * read_geometry_block() - Synchronously read the geometry block from a vdo's underlying block
+ *                         device.
  * @vdo: The vdo whose geometry is to be read.
  *
  * Return: VDO_SUCCESS or an error code.
-- 
2.42.0

