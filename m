Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E26D33A02D
	for <dm-devel@lists.linux.dev>; Mon,  9 Feb 2026 07:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770623709; cv=none; b=h+AoBrbLJSJuVcfDSb/ltlD/BZsvNnwfzxFTSZbPN5Cau/59DMYB3mwfTDgt2hXPbIV84MpfHAPNuL99bZNIkB1GjgcbY8SOnp46Bd/FIQQentdH+N1i2ugtlpni4Notv2P2WllpLSe0f+KxjwhEBqU4afamGFy5u61J6UM8Bfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770623709; c=relaxed/simple;
	bh=qalOYwcXATuYi3AvTgH/xSPsRBFa57T/CEiNvL8fDMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=iQwxrp7CtyjiO+dKg1e27mj5Yp8FDHFbZn1bibMqyMno86Cz5nM3SB6HfwZkZZaOgtZ4BqfXm48utMNQ7eLtG+vjXRt3h0bq0Ia1O5N1HsWefeV2uEo5uC2tNK+mesShRi3dJKMaLRc3qN8GEQAKsb3oL8moID2sZaRg/Wo2RUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bEl4h0hr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bEl4h0hr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770623708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eqLZrw/3BJ5nXxtnu1Jlr3o+V2+NyTzCL5JNjgeJsg0=;
	b=bEl4h0hr41vpPy8sPx7kie3L4wGSNexNF3suYpk52eM+DQ3FaNxSRwkfmLvnY0FY9aY6hB
	7SYqWQSRrhur6SBVcnkG13xDvjVo3DPJogYDYFP0AfRlvD4yqVdTkF/nb8EOR73gKgamJT
	7TFi4ag8aUBXgWqcrElk2KcOdCIaR60=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-417-cSlb5Fl3M6W6BVpJTTGvVQ-1; Mon,
 09 Feb 2026 02:55:07 -0500
X-MC-Unique: cSlb5Fl3M6W6BVpJTTGvVQ-1
X-Mimecast-MFC-AGG-ID: cSlb5Fl3M6W6BVpJTTGvVQ_1770623706
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5B0AD1956088;
	Mon,  9 Feb 2026 07:55:06 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.64.240.53])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 500CD30001A8;
	Mon,  9 Feb 2026 07:55:02 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH 2/7] dm cache: fix write path cache coherency in passthrough mode
Date: Mon,  9 Feb 2026 15:54:06 +0800
Message-ID: <20260209075411.860418-3-mtsai@redhat.com>
In-Reply-To: <20260209075411.860418-1-mtsai@redhat.com>
References: <20260209075411.860418-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NAAdXjXapn-cxC0f7IwoIT11KlOGTsaSTVMUs5kjkRM_1770623706
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

In passthrough mode, dm-cache defers write bio submission until cache
invalidation completes to maintain existing coherency, requiring the
target map function to return DM_MAPIO_SUBMITTED. The current map_bio()
returns DM_MAPIO_REMAPPED, violating the required ordering constraint.

Reproduce steps:

1. Create a cache device

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 131072 linear /dev/sdc 8192"
dmsetup create corig --table "0 262144 linear /dev/sdc 262144"
dd if=/dev/zero of=/dev/mapper/cmeta bs=4k count=1 oflag=direct
dmsetup create cache --table "0 262144 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"

2. Promote the first data block into the cache

fio --filename=/dev/mapper/cache --name=populate --rw=write --bs=4k \
--direct=1 --size=64k

3. Reload the cache into passthrough mode

dmsetup suspend cache
dmsetup reload cache --table "0 262144 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 passthrough smq 0"
dmsetup resume cache

4. Write to the first data block, and check io ordering using ftrace

echo 1 > /sys/kernel/debug/tracing/events/block/block_bio_queue/enable
echo 1 > /sys/kernel/debug/tracing/events/block/block_bio_complete/enable
echo 1 > /sys/kernel/debug/tracing/events/block/block_rq_complete/enable
fio --filename=/dev/mapper/cache --name=test --rw=write --bs=64k \
--direct=1 --size 64k

5. ftrace logs show that write operations to the cache origin (252:2)
   and metadata operations (252:0) are unsynchronized: the origin write
   occurs before metadata commit.

 <snip>
       fio-146  [000] .....  420.139562: block_bio_queue: 252,3 WS 0 + 128 [fio]
       fio-146  [000] .....  420.149395: block_bio_queue: 252,2 WS 0 + 128 [fio]
       fio-146  [000] .....  420.149763: block_bio_queue: 8,32 WS 262144 + 128 [fio]
       fio-146  [000] dNh1.  420.151446: block_rq_complete: 8,32 WS () 262144 + 128 be,0,4 [0]
       fio-146  [000] dNh1.  420.152731: block_bio_complete: 252,2 WS 0 + 128 [0]
       fio-146  [000] dNh1.  420.154229: block_bio_complete: 252,3 WS 0 + 128 [0]
 kworker/0:0-9  [000] .....  420.160530: block_bio_queue: 252,0 W 408 + 8 [kworker/0:0]
 kworker/0:0-9  [000] .....  420.161641: block_bio_queue: 8,32 W 408 + 8 [kworker/0:0]
 kworker/0:0-9  [000] .....  420.162533: block_bio_queue: 252,0 W 416 + 8 [kworker/0:0]
 kworker/0:0-9  [000] .....  420.162821: block_bio_queue: 8,32 W 416 + 8 [kworker/0:0]
 <snip>

Fixes: b29d4986d0da ("dm cache: significant rework to leverage dm-bio-prison-v2")
Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
---
 drivers/md/dm-cache-target.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index a2e07b124901..ac9901033073 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1703,6 +1703,7 @@ static int map_bio(struct cache *cache, struct bio *bio, dm_oblock_t block,
 				bio_drop_shared_lock(cache, bio);
 				atomic_inc(&cache->stats.demotion);
 				invalidate_start(cache, cblock, block, bio);
+				return DM_MAPIO_SUBMITTED;
 			} else
 				remap_to_origin_clear_discard(cache, bio, block);
 		} else {
-- 
2.49.0

