Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7631317146
	for <dm-devel@lists.linux.dev>; Fri, 10 Apr 2026 13:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775826502; cv=none; b=I57WEEcWXEoW0oEaQSXrJS+MqmLxaOYnp01cjqopUswe3BrdJMsX+WWFBhuh09GMgIFyHkSfUX7/BXFFt5BQ9CmAy2Tgo3uHQkvti5UP4HTXEuDt/kNMeDiiit7lUhL9xTDmLl+ji8JxbU8kTE/xD5eGjeAyAwiAUGYsyKbuKfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775826502; c=relaxed/simple;
	bh=FX7TG4WlafHFnkSpx7XWgr9SxnQa7DqcwSBBh8OEgCM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=EYJV4mw64iwV3IfTgs6Oydiwd7yPydV03wBgy8Jy1a4V+l7OLTJzvro8nJzfNekavk/NVtWRIO/4Ljxs4OkutZM68vBHxXRFXBQebt6Iyhz8Yp8A36BpqZYoull3i4bo2gfEmkRJE4t8lHv3L9sR/4q1oLEfXHrvfNoU76YGu+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H3wHaaCZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H3wHaaCZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775826499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cFynK2YaS2U8XdZgxxUqFYL3RlDCjKgRYS0o2n8tV6E=;
	b=H3wHaaCZ59AfiuocZi0p64bmXguy1FI3ZKgKykLZKo5zATxBIoRl7QDbNygx9+pPXbJrCq
	kF/ECCYV4WKeIoC2LrsB2EnEgNXFekcvJ+0dDKMpv6DcTinhtq+IlZHEJbRncFLh7iqq/f
	6reN8hWiQDkvTBqAVdw3QEpKz4XO5Qo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-587-GAR56FhwNBGk80f9cCPoJw-1; Fri,
 10 Apr 2026 09:08:16 -0400
X-MC-Unique: GAR56FhwNBGk80f9cCPoJw-1
X-Mimecast-MFC-AGG-ID: GAR56FhwNBGk80f9cCPoJw_1775826495
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 719D61956066;
	Fri, 10 Apr 2026 13:08:15 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.64.240.16])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 842AE180049F;
	Fri, 10 Apr 2026 13:08:12 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Dan Carpenter <error27@gmail.com>
Subject: [PATCH] dm cache: fix missing return in invalidate_committed's error path
Date: Fri, 10 Apr 2026 21:08:01 +0800
Message-ID: <20260410130801.232180-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6mtIDoymPknG02TE639XYw_JLJWF47CWCfpdwwwjVhY_1775826495
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

In passthrough mode, dm-cache defers write submission until after
metadata commit completes via the invalidate_committed() continuation.
On commit error, invalidate_committed() calls invalidate_complete() to
end the bio and free the migration struct, after which it should return
immediately.

The patch 4ca8b8bd952d ("dm cache: fix write hang in passthrough mode")
omitted this early return, causing execution to fall through into the
success path on error. This results in use-after-free on the migration
struct in the subsequent calls.

Fix by adding the missing return after the invalidate_complete() call.

Fixes: 4ca8b8bd952d ("dm cache: fix write hang in passthrough mode")
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/dm-devel/adjMq6T5RRjv_uxM@stanley.mountain/
Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
---
 drivers/md/dm-cache-target.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 51453f01a7ea..aca8b37ad5ce 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1521,8 +1521,10 @@ static void invalidate_committed(struct work_struct *ws)
 	struct bio *bio = mg->overwrite_bio;
 	struct per_bio_data *pb = get_per_bio_data(bio);
 
-	if (mg->k.input)
+	if (mg->k.input) {
 		invalidate_complete(mg, false);
+		return;
+	}
 
 	init_continuation(&mg->k, invalidate_completed);
 	remap_to_origin_clear_discard(cache, bio, mg->invalidate_oblock);
-- 
2.49.0

