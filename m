Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2512C4C92
	for <dm-devel@lists.linux.dev>; Wed,  4 Mar 2026 19:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772651078; cv=none; b=SheFb4Dl15WFLlqgL6s0i+Z/sOqOCAR7S9lsXFIAleHMzuSI1aMZtXW9AqXixgE2PDnyZn1kKEojVHo2MUS+RMyvxgVBZViJ/4dQEdQBnP6Jjh+5PUwgsGndvd5srC7V3eke2nGmaTkDUics/ymh50pWhtOrySOKBLieKRnP7ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772651078; c=relaxed/simple;
	bh=z5DcHO21FkkM2jLsixG55fluSxfkaZB9FrzRy7NEkSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=lWRKm/zO17Xl14f0uF1sATt5COXoOoXZ62jPCThxOf5q9N1iiowZJy2BoIpU1LE0kpCAs4J7Q6gQfLZSvy6Z6eBJk0BvYOBRvQiJdZ0Wm/k2u2nHce3G7wteEK0fL8Liw5KUq+Mu5bClpWnN/D4cJ9px9n5xb51i52RgPC9b06s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AYxMxvBt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AYxMxvBt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772651076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BaLtYgei9IWIO1DSr3vx23YgMlhkxC2wxvdO5uumCI4=;
	b=AYxMxvBt4zh3hS0vM5bjE0HvOtIYEmvp+qq6jF/5yaZMuR5/6U5y1NkK1ALFYeIIiLAFuJ
	mQP6T+ryuBaZiiRBPQAS2+YODjFYe7xgFSiA7j2O0A9rN8AIglQir/0h96XdcsWEGaRm1C
	rY9Ix4VNPKi9hSARW0bcZVNuKjWb4Uk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-605-RvUA3WaMPNqHxqOGAKktYw-1; Wed,
 04 Mar 2026 14:04:32 -0500
X-MC-Unique: RvUA3WaMPNqHxqOGAKktYw-1
X-Mimecast-MFC-AGG-ID: RvUA3WaMPNqHxqOGAKktYw_1772651071
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7551C1800464;
	Wed,  4 Mar 2026 19:04:31 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.44.32.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0E76418002A6;
	Wed,  4 Mar 2026 19:04:28 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-block@vger.kernel.org,
	drbd-dev@lists.linbit.com,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] block: consecutive blk_status_t error codes
Date: Wed,  4 Mar 2026 20:04:06 +0100
Message-ID: <20260304190424.291743-2-agruenba@redhat.com>
In-Reply-To: <20260304190424.291743-1-agruenba@redhat.com>
References: <20260304190424.291743-1-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 8ZRbgbXUR2aULIaBb7ZMJYJrKnFoEkAhqfQRsbo-fGg_1772651071
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Since commit 9da3d1e912f3 ("block: Add core atomic write support"),
there is a gap in the blk_status_t codes and block status code 18 is
unused.  This causes blk_status_to_errno() and blk_status_to_str() to
return incorrect values for that code.  Make the blk_status_t codes
consecutive again to avoid that.

Fixes: 9da3d1e912f3 ("block: Add core atomic write support")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 include/linux/blk_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 8808ee76e73c..89a722d76c28 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -168,7 +168,7 @@ typedef u16 blk_short_t;
 /*
  * Invalid size or alignment.
  */
-#define BLK_STS_INVAL	((__force blk_status_t)19)
+#define BLK_STS_INVAL	((__force blk_status_t)18)
 
 /**
  * blk_path_error - returns true if error may be path related
-- 
2.52.0

