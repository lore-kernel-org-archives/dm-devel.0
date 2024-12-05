Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5627920A5EA
	for <dm-devel@lists.linux.dev>; Thu,  5 Dec 2024 11:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733398961; cv=none; b=YZ+kG63trix8rbqI+2T2Hp+lYFn+W/lqNyfXepMo8ydDUvnr8nrZWoXigloFnWaIUrjKSTjKqvQ0kS2HFkit19iGGUxuR3hD2JbVYUymmNPpNWcy3mre37sblDBBjpc1movA/Up9fn0TkPoLAWyOEVps+LkQXgvgcJhwGwlSZi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733398961; c=relaxed/simple;
	bh=9LiNEUJailRTjLW4xWLM7k3Bo6mjK6os2YrTdl+0uko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=bXTsU5WyLvK8odRw2LZIcXhaXmyYOTP2vi8V6qpeV84mJl2k3gcozaQ4KP32xl9DOGiB8c4HAfXVSuXJjWWMKWcfSW1Lz0Ao6h3LhRZu/OPThK5hqE+64dn0WjRkpwikAhEDkv+xiF/d4T5TUFeVJysm6R310vbUbKNfFkdkJhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f/TLCuQC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f/TLCuQC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733398958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vIF9v8823C2wO9MvpPOUNzig0GUr4X2yiLwC/zjIs10=;
	b=f/TLCuQCGYMrj4UbfY8kqXoaII7AyOeh/i6vJz7sUXTle7W4t2j3TjLbTyBkuPmIwhqUn9
	aRiU7KvocZlewgoYTe2icmmedtbjr/xcnumYa+u1Omi2Ed7gAruhmv9veExzK5HIzB/TIn
	y7AmiYHsbE8Lmi6yWu9gxh2q7a+eN70=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-625-b-Wx27dPMqmbRwMr8vX2CA-1; Thu,
 05 Dec 2024 06:42:37 -0500
X-MC-Unique: b-Wx27dPMqmbRwMr8vX2CA-1
X-Mimecast-MFC-AGG-ID: b-Wx27dPMqmbRwMr8vX2CA
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 499A6195609F;
	Thu,  5 Dec 2024 11:42:36 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.67.24.108])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D1A4F1956094;
	Thu,  5 Dec 2024 11:42:32 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH v2 3/3] dm array: fix cursor index when skipping across block boundaries
Date: Thu,  5 Dec 2024 19:41:53 +0800
Message-ID: <20241205114153.1496986-4-mtsai@redhat.com>
In-Reply-To: <20241205114153.1496986-1-mtsai@redhat.com>
References: <20241205114153.1496986-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ii9xFr1UdOInK4w7_W1Zl5pxcYq-WP6VaLY_WMG3Kf8_1733398956
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

dm_array_cursor_skip() seeks to the target position by loading array
blocks iteratively until the specified number of entries to skip is
reached. When seeking across block boundaries, it uses
dm_array_cursor_next() to step into the next block.
dm_array_cursor_skip() must first move the cursor index to the end
of the current block; otherwise, the cursor position could incorrectly
remain in the same block, causing the actual number of skipped entries
to be much smaller than expected.

This bug affects cache resizing in v2 metadata and could lead to data
loss if the fast device is shrunk during the first-time resume. For
example:

1. create a cache metadata consists of 32768 blocks, with a dirty block
   assigned to the second bitmap block. cache_restore v1.0 is required.

cat <<EOF >> cmeta.xml
<superblock uuid="" block_size="64" nr_cache_blocks="32768" \
policy="smq" hint_width="4">
  <mappings>
    <mapping cache_block="32767" origin_block="0" dirty="true"/>
  </mappings>
</superblock>
EOF
dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
cache_restore -i cmeta.xml -o /dev/mapper/cmeta --metadata-version=2

2. bring up the cache while attempt to discard all the blocks belonging
   to the second bitmap block (block# 32576 to 32767). The last command
   is expected to fail, but it actually succeeds.

dmsetup create cdata --table "0 2084864 linear /dev/sdc 8192"
dmsetup create corig --table "0 65536 linear /dev/sdc 2105344"
dmsetup create cache --table "0 65536 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 64 2 metadata2 writeback smq \
2 migration_threshold 0"

Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Fixes: 9b696229aa7d ("dm persistent data: add cursor skip functions to the cursor APIs")
---
 drivers/md/persistent-data/dm-array.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persistent-data/dm-array.c
index 0850dfdffc8c..8f8792e55806 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -1003,6 +1003,7 @@ int dm_array_cursor_skip(struct dm_array_cursor *c, uint32_t count)
 		}
 
 		count -= remaining;
+		c->index += (remaining - 1);
 		r = dm_array_cursor_next(c);
 
 	} while (!r);
-- 
2.47.0

