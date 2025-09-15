Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD4F1A267
	for <dm-devel@lists.linux.dev>; Mon, 15 Sep 2025 23:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757979329; cv=none; b=WwI6lVMjVCd1kl1S0vbQGinYJC4tsuXhSbjaFmWX1tJcviGf7N/AOBIl8Ik8s8nL0bwM4zBSmYj+AEAcK80JHLW+3gGx7+9aommsZZIJiBbZz/+erKUy0Z67LUdhlBR8x0HP7oChBtiW++Xm9fHqRD9HXXfIfJSF6zQMMuZf8Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757979329; c=relaxed/simple;
	bh=xJeeurrdNWQ8IPVUSWPR0RX8ysRMqVvlNSRA/adYJ4I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=cdDzZrvtjj9KlTAQbQ0woy4Jy/AjwIo27HITcso9CF23nXAShUpDQT1H0N69j2fSaTE/7s7AwlsOqTShOhTpRLfCV6KM6V2QVonXS7SlJMx9NpjKYCDjNZg2+YMqwn7tDfXoreD1dB+t4aBPvqzm7yefoLcUAZXBs6+Qm00OJNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gPx9wsp1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gPx9wsp1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757979322;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QXrd6hpfP0mWqZobmssqZnJhv9sSjzxF7LZshVFz+jY=;
	b=gPx9wsp1imiaZlc0bKaep7FuGPvmZiK9TBwcSzWA0ii9lPzfSuODL1AMdSegS7/1lX3CTa
	6pyUVaqQIJwEIk4zkP6R2eu/lKH3hHbl99FFI0ep3rCmWq3hFSnpyskTcierr//8CKRf/A
	Wye3xJdFJTmIQ6eCfMSHAJlgLfC3xCg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-327-KTHstf69N5ukejPrmS_7Xw-1; Mon,
 15 Sep 2025 19:35:20 -0400
X-MC-Unique: KTHstf69N5ukejPrmS_7Xw-1
X-Mimecast-MFC-AGG-ID: KTHstf69N5ukejPrmS_7Xw_1757979319
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 95D17180034D
	for <dm-devel@lists.linux.dev>; Mon, 15 Sep 2025 23:35:18 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 35AA31800447;
	Mon, 15 Sep 2025 23:35:18 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 52D2910DC65; Mon, 15 Sep 2025 19:35:17 -0400 (EDT)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Bruce Johnston <bjohnsto@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: Update code to use mem_is_zero
Date: Mon, 15 Sep 2025 19:35:17 -0400
Message-ID: <5775997d7b0970c3a1b9471eaa09b3a548705c3a.1757979122.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pZCUGC_sftJM2CQkPkYeyzLAe056kh1XthAiHT5sO0s_1757979319
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Bruce Johnston <bjohnsto@redhat.com>

Remove function that would check if data was all zeroes. Use the
built-in kernel function mem_is_zero() instead.

Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/data-vio.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
index 810002747091..89e4398a2836 100644
--- a/drivers/md/dm-vdo/data-vio.c
+++ b/drivers/md/dm-vdo/data-vio.c
@@ -17,6 +17,7 @@
 #include <linux/minmax.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
+#include <linux/string.h>
 #include <linux/wait.h>
 
 #include "logger.h"
@@ -509,18 +510,6 @@ static void launch_data_vio(struct data_vio *data_vio, logical_block_number_t lb
 	vdo_enqueue_completion(completion, VDO_DEFAULT_Q_MAP_BIO_PRIORITY);
 }
 
-static bool is_zero_block(char *block)
-{
-	int i;
-
-	for (i = 0; i < VDO_BLOCK_SIZE; i += sizeof(u64)) {
-		if (*((u64 *) &block[i]))
-			return false;
-	}
-
-	return true;
-}
-
 static void copy_from_bio(struct bio *bio, char *data_ptr)
 {
 	struct bio_vec biovec;
@@ -572,7 +561,7 @@ static void launch_bio(struct vdo *vdo, struct data_vio *data_vio, struct bio *b
 		 * we acknowledge the bio.
 		 */
 		copy_from_bio(bio, data_vio->vio.data);
-		data_vio->is_zero = is_zero_block(data_vio->vio.data);
+		data_vio->is_zero = mem_is_zero(data_vio->vio.data, VDO_BLOCK_SIZE);
 		data_vio->write = true;
 	}
 
@@ -1459,7 +1448,7 @@ static void modify_for_partial_write(struct vdo_completion *completion)
 		copy_from_bio(bio, data + data_vio->offset);
 	}
 
-	data_vio->is_zero = is_zero_block(data);
+	data_vio->is_zero = mem_is_zero(data_vio->vio.data, VDO_BLOCK_SIZE);
 	data_vio->read = false;
 	launch_data_vio_logical_callback(data_vio,
 					 continue_data_vio_with_block_map_slot);
-- 
2.48.1

