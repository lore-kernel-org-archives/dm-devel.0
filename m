Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DE5481CE
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267194; cv=none; b=rxzNjVwodOS+RjzoeU5uEl53qzg7usKy7n4YKuYDwVtxpupTI5k3oaI8ZeJLCmgjVyDzjy3kPTSydRqlydX8We/1OW8vUp17qBysuDYgQip7PLqk4lJ+C7ve41ZtquUomy4I0UUSjJ0NAmX3bp1fEGlaQ8ONEwVc38oweOms6bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267194; c=relaxed/simple;
	bh=B95ymkq+G2grjPNy94Z6A7DWGxYwkuQelkLZC8Pt3NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uz54qVgyKVgi7n0fTltCJrH1ix2MIVofFPuQQZ2altCVT8VqgFhyWOwy7U3vUBTpANdOkSN1DTip7Bpu2tgtTxvXK2Holm+yMe93qDrMSE46Wg/eSISJ02kHYEZE7CC+kfk2a6NbshIeoQOmXbJ+b0GZNfrE+S8tbiAoS422k5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OY9klrQY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OY9klrQY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F8BG+UkK+t/qd9HLuJAHAbhlvO1VsbWTBRQSai7V58Y=;
	b=OY9klrQYXzsaAVI0z5WsBOiVSks9kVgSYqa7dWZ53+Y9U5SNC9d0+m7Db27uqy5a8mAqMf
	4waAOuziL3oBkjT44Mjc37NVX4c3+codjtlo10oxWcPFdsaMCJlal72FdUzvh3iX4zJzMf
	9kYQgRWAvuWEtwtf8kd9b2YM6QgZWZ4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-282-HZDmyjoiNIq3CVEu9qKLZA-1; Thu,
 29 Feb 2024 23:26:30 -0500
X-MC-Unique: HZDmyjoiNIq3CVEu9qKLZA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1408D3806289;
	Fri,  1 Mar 2024 04:26:30 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0D4DA8CED;
	Fri,  1 Mar 2024 04:26:29 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id DBAB6A15D3; Thu, 29 Feb 2024 23:26:29 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 05/11] dm vdo: Modify mismatched function name
Date: Thu, 29 Feb 2024 23:26:23 -0500
Message-ID: <bcf5f0634073b35c8227c89462d8be6ffdb04fba.1709266694.git.msakai@redhat.com>
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

src/c++/vdo/base/encodings.c:1178: warning: expecting prototype for vdo_decode_component(). Prototype was for decode_vdo_component() instead.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/encodings.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/encodings.c b/drivers/md/dm-vdo/encodings.c
index 9e45411fe816..5012042b26af 100644
--- a/drivers/md/dm-vdo/encodings.c
+++ b/drivers/md/dm-vdo/encodings.c
@@ -1172,7 +1172,7 @@ static struct vdo_component unpack_vdo_component_41_0(struct packed_vdo_componen
 }
 
 /**
- * vdo_decode_component() - Decode the component data for the vdo itself out of the super block.
+ * decode_vdo_component() - Decode the component data for the vdo itself out of the super block.
  *
  * Return: VDO_SUCCESS or an error.
  */
-- 
2.42.0

