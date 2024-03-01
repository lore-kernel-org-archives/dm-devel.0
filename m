Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5194F60D
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 04:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267196; cv=none; b=gNxe9ioHmM6hjB5saZfx6EpGshf+1TXnQTDsSkufnjdAXNKnt0CHrofp76+0n6y2V+IMeMcpPfbvuyNKsQcID8KZfeAnY3+pUIA2M6h0kkD8nV4Kk7qZvCENmSCYZr/B/cuOSpFv4LcyOE19kX8KQNoa//Kl1bk5oeOyetOJW0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267196; c=relaxed/simple;
	bh=LAt8lN/RTEIA0z6ubzi3HI3GsC+yPgC7svXd0fUAxFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZrAlSJKSU7iykgxsdMink/LTbQa8Wruct1gYfZIW1HPxxGX/rPKI33BnyRWTffYBU5u/ToXMapGMFbfUWOQjhI6pVYeBXgbeitA3Q8tHZ31I14L+oGoJTxOwEnCF0SJ8rFyv0knK38yCJa/iZDtufE5Py+rY0M0eLvtfQWrKf8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f+J+JTki; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f+J+JTki"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709267194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iLnkFJVKOOVD+xdiuI3jAoqfcZOjRFFObJH/QxUgYLw=;
	b=f+J+JTkil4gnJzbiwPLDOY/pJV1R0CI0FDDs8ybveNyH4+n75QlaUFHOuu1GVTS7BHU6jt
	MUJaV+JFkUMJDBoA1wpajtFQliWO9JWRHjhrH80EspyB2FzCKQ4g7OArTlx+Fmnuma9jBw
	z0jCeCXwQtL6YD4ORkCoHFnsXDtTR7g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-ANBFClkwPAG1qgjeNDKVZQ-1; Thu, 29 Feb 2024 23:26:30 -0500
X-MC-Unique: ANBFClkwPAG1qgjeNDKVZQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1238985A589;
	Fri,  1 Mar 2024 04:26:30 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0D3A41C060AF;
	Fri,  1 Mar 2024 04:26:29 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id CC922A15CD; Thu, 29 Feb 2024 23:26:29 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 02/11] dm vdo slab-depot: Modify mismatched function name
Date: Thu, 29 Feb 2024 23:26:20 -0500
Message-ID: <f4ec2d9b45b804f79acbc08b48dff3a24627ac3c.1709266694.git.msakai@redhat.com>
In-Reply-To: <cover.1709266694.git.msakai@redhat.com>
References: <cover.1709266694.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

No functional modification involved.

src/c++/vdo/base/slab-depot.c:2042: warning: expecting prototype for vdo_find_free_block(). Prototype was for find_free_block() instead.
src/c++/vdo/base/slab-depot.c:5036: warning: expecting prototype for get_depot_slab_journal_statistics(). Prototype was for get_slab_journal_statistics() instead.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/slab-depot.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index e10c3db8e665..8c6376e79a23 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -2035,8 +2035,8 @@ static inline slab_block_number find_zero_byte_in_word(const u8 *word_ptr,
 }
 
 /**
- * vdo_find_free_block() - Find the first block with a reference count of zero in the specified
- *                         range of reference counter indexes.
+ * find_free_block() - Find the first block with a reference count of zero in the specified
+ *                     range of reference counter indexes.
  * @slab: The slab counters to scan.
  * @index_ptr: A pointer to hold the array index of the free block.
  *
@@ -5032,7 +5032,7 @@ get_ref_counts_statistics(const struct slab_depot *depot)
 }
 
 /**
- * get_depot_slab_journal_statistics() - Get the aggregated slab journal statistics for the depot.
+ * get_slab_journal_statistics() - Get the aggregated slab journal statistics for the depot.
  * @depot: The slab depot.
  *
  * Return: The aggregated statistics for all slab journals in the depot.
-- 
2.42.0

