Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE514176D
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267195; cv=none; b=P9zoFVNIjiDBbPpjxuapa/OhTuj1x89j7cLC9EKpCojNls2jfdtrDI3o1NkacqoYGzabpWEeXhlIQPFs96AYcwxNyYlLDu0/o4PjwBRHniy9Zs1fjJUBo8APts+fG4JrQqed1pH5fJDXCoOitqlQAXiJNpYIydkX/1cactCd2TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267195; c=relaxed/simple;
	bh=fM/l6EwmWRq9z3W6f4a/H3Mly9Ol6Fm9oav5n1xPj+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aTbQc20QjGCfrNpvSsHboQgPVvsM0pRyGA9f3IuKuZRgQAE7Mm/Z4LIB68HPPdh3LBfzoMdvUUv3iofzLf6Ycl8T/kD/VG6Oy9B2+tsmTNq9RiRmpZRFjBul1XGUVH9vhHGEjn3Bac0Dcc5vN9i4tTeNSlUdEkOg3ZUchSWmC+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J6XWAJ+f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J6XWAJ+f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XNlppo7VlH+01AuyUjW0dRg/x3HxHl+cA5k+RHDw750=;
	b=J6XWAJ+fLUs1tlCvq8tmM4O8hRp2jE0V1JF0agUsDWlCBql3QAi3gGjYSDmJqUVXUuXjwt
	1K72mj0H3d8DTivJZ/1PHIdCTtkm4vEFf/0VPObCv540MX506IhM34AwDKfTNqvgzt+Pbb
	7OagcHPCWfNbucWtJo8gj78nZQl98DM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-557-ASSHcK2_PF-DJEgODaNzyQ-1; Thu, 29 Feb 2024 23:26:30 -0500
X-MC-Unique: ASSHcK2_PF-DJEgODaNzyQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A2E1859B81
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:26:30 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1259DC185C0;
	Fri,  1 Mar 2024 04:26:30 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id F0399A15DB; Thu, 29 Feb 2024 23:26:29 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 09/11] dm vdo indexer delta-index: fix typos in comments
Date: Thu, 29 Feb 2024 23:26:27 -0500
Message-ID: <a5849a7ad1f55cbebf279ced9bf860914f3a7a61.1709266694.git.msakai@redhat.com>
In-Reply-To: <cover.1709266694.git.msakai@redhat.com>
References: <cover.1709266694.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/indexer/delta-index.c | 2 +-
 drivers/md/dm-vdo/indexer/delta-index.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-vdo/indexer/delta-index.c b/drivers/md/dm-vdo/indexer/delta-index.c
index 4aace707545a..6a85f93bbcb1 100644
--- a/drivers/md/dm-vdo/indexer/delta-index.c
+++ b/drivers/md/dm-vdo/indexer/delta-index.c
@@ -35,7 +35,7 @@
  *
  * Each delta list is stored as a bit stream. Within the delta list encoding, bits and bytes are
  * numbered in little endian order. Within a byte, bit 0 is the least significant bit (0x1), and
- * bit 7 is the most significant bit (0x80). Within a bit stream, bit 7 is the most signficant bit
+ * bit 7 is the most significant bit (0x80). Within a bit stream, bit 7 is the most significant bit
  * of byte 0, and bit 8 is the least significant bit of byte 1. Within a byte array, a byte's
  * number corresponds to its index in the array.
  *
diff --git a/drivers/md/dm-vdo/indexer/delta-index.h b/drivers/md/dm-vdo/indexer/delta-index.h
index 3d2ea19aef61..53f6c6ac0bc7 100644
--- a/drivers/md/dm-vdo/indexer/delta-index.h
+++ b/drivers/md/dm-vdo/indexer/delta-index.h
@@ -141,7 +141,7 @@ struct delta_index_page {
  *     record at the end of the list.
  *
  * (5) If at_end is false and is_collision is true, the delta_list entry fields refer to a
- *     collision entry in the list, and the delta_list entry can be used a a reference to this
+ *     collision entry in the list, and the delta_list entry can be used as a reference to this
  *     entry.
  *
  * (6) If at_end is false and is_collision is false, the delta_list entry fields refer to a
-- 
2.42.0

