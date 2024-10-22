Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DE313BC12
	for <dm-devel@lists.linux.dev>; Tue, 22 Oct 2024 07:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729581238; cv=none; b=MWBEpDPCL3eXgTTFpDw0J2Iqk00zMUefToBwjRRLj+mf9BU+ISXWHcZ31G4Zu4kUq54pAYwyKWcpKlegWN1ohyKNQN0KdyIL7udTnWIhw4oibk7tCGY05M0MAIbeCkW8Q0Po8gz+H1iVSByJ0iogOPfV07/FPHYw2cTUReohONQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729581238; c=relaxed/simple;
	bh=gwK4nLcEWbOb6Qnn4KUs5J7cY0+KlvIaOWXxcpUib6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GMn/pKT5U22EJVV2lxd/HJrKfDb8CYwQqwY4O990uL5rysFanYOwkXv8glK29z0gzoUQIlxUpt6UsrM7oS+oQLAqCDQW5EZTU6x5AAHNRi2MLydRTawSCG6KoxuZFQZ2Gu1H8m9RxnAwJJYbOpFt/zkFRdPyqskL36ju5NXXu34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I1ClTMvI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I1ClTMvI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729581235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=45S4woCfEzn6e5MeMHLnioE0CFco3SKDnBWQLtC3JXE=;
	b=I1ClTMvImjBEwrySBjNaiCc2yo/3+u8F5QWl3EEnxdGC7fIncIsZh+WaKdljQzdEhviqnV
	F8Z2dY0nA5KHJsblbwdd5bDtbbwxQKkQipPEJAoQC3FQvF6r4ivZCYxqzqyLmtxI7osXIr
	i6RGgbl3E0nsr1AFeOK31R/n2ElD9js=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-601-QrPuuSaKP4CQ5bg5jWaX0w-1; Tue,
 22 Oct 2024 03:13:54 -0400
X-MC-Unique: QrPuuSaKP4CQ5bg5jWaX0w-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 70CEC1955EE8;
	Tue, 22 Oct 2024 07:13:53 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.67.24.92])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B79E830001A3;
	Tue, 22 Oct 2024 07:13:49 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	thornber@redhat.com,
	heinzm@redhat.com,
	snitzer@kernel.org,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH 4/5] dm cache: optimize dirty bit checking with find_next_bit when resizing
Date: Tue, 22 Oct 2024 15:13:39 +0800
Message-ID: <20241022071339.778721-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

When shrinking the fast device, dm-cache iteratively searches for a
dirty bit among the cache blocks to be dropped, which is less efficient.
Use find_next_bit instead, as it is twice as fast as the iterative
approach with test_bit.

Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
---
 drivers/md/dm-cache-target.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 1fcd8c5c220e..fa8ef2c32af8 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2911,14 +2911,14 @@ static bool can_resize(struct cache *cache, dm_cblock_t new_size)
 	/*
 	 * We can't drop a dirty block when shrinking the cache.
 	 */
-	while (from_cblock(new_size) < from_cblock(cache->cache_size)) {
-		if (is_dirty(cache, new_size)) {
-			DMERR("%s: unable to shrink cache; cache block %llu is dirty",
-			      cache_device_name(cache),
-			      (unsigned long long) from_cblock(new_size));
-			return false;
-		}
-		new_size = to_cblock(from_cblock(new_size) + 1);
+	new_size = to_cblock(find_next_bit(cache->dirty_bitset,
+					   from_cblock(cache->cache_size),
+					   from_cblock(new_size)));
+	if (new_size != cache->cache_size) {
+		DMERR("%s: unable to shrink cache; cache block %llu is dirty",
+		      cache_device_name(cache),
+		      (unsigned long long) from_cblock(new_size));
+		return false;
 	}
 
 	return true;
-- 
2.47.0

