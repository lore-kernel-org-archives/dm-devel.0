Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143DA13AD0
	for <dm-devel@lists.linux.dev>; Tue, 22 Oct 2024 07:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729581180; cv=none; b=mCRtnG8wwIFuUAWA9ZwByhfZhLNDY4HC7aO/mcKX+64Lr6BtSaNqaWg59sCgP8dEvs+IuXn+2ybOB2+yDs7O1wsuZAvuMiZNjG0nbt3zOtw0T6DGnFcKwLUsAKuJTxRVYWMmr2yEKsF2S/pyv6twrIHN6IKJr/hF1BxVVaQ5tjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729581180; c=relaxed/simple;
	bh=/CiqqNEJ10PN1QWvkqC8BJSrhjzsHEuV9cVXQY+Xujo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HlSOowbW8GhDkvhxQhDqq5Va3UeT4xrVZUc2REatAkuCao3AxkbpeAWn+oJEvtlRtLlwtfOVSMYJuOYlsioDeiZPxSJD687p4B5Mmuf/4AJdbP+A4Ei8zXHIEfCIP7grpeZ11X9XTAoEp2C+L8ApaNk80a0Cy7f9mdKYpfR1ARg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e321+mg+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e321+mg+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729581178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AGi2mNoYkyktpfBeiA2epz+j1luH8CIv62zEtu27bBg=;
	b=e321+mg+03w1V6dGvEBUD75Xtgrm7NxRWkZkZ73/zsIhSnEufHVrKM/QmXmSTm6f7e8FLV
	UQsBOA1kN0UcVJ9bxI7JdPTxSkz9uU9ol9mTrwnp30+H1EfQLQzKI8NroOfwat239c4K90
	31gmk7mzOZQYp4e5Gv4z51CwqnlBOOg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-53-fcXokd_FPS2KzMfqi2I_TA-1; Tue,
 22 Oct 2024 03:12:54 -0400
X-MC-Unique: fcXokd_FPS2KzMfqi2I_TA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D125B1955D71;
	Tue, 22 Oct 2024 07:12:53 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.67.24.92])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0363319560A2;
	Tue, 22 Oct 2024 07:12:44 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	thornber@redhat.com,
	heinzm@redhat.com,
	snitzer@kernel.org,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH 1/5] dm cache: correct the number of origin blocks to match the target length
Date: Tue, 22 Oct 2024 15:12:22 +0800
Message-ID: <20241022071222.778553-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

When creating a cache device, the actual size of the cache origin might
be greater than the specified cache target length. In such case, the
number of origin blocks should match the cache target length, not the
full size of the origin device, since access beyond the cache target is
not possible. This issue occurs when reducing the origin device size
using lvm, as lvreduce preloads the new cache table before resuming the
cache origin, which can result in incorrect sizes for the discard bitset
and smq hotspot blocks.

Reproduce steps:

1. create a cache device consists of 4096 origin blocks

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 65536 linear /dev/sdc 8192"
dmsetup create corig --table "0 524288 linear /dev/sdc 262144"
dd if=/dev/zero of=/dev/mapper/cmeta bs=4k count=1 oflag=direct
dmsetup create cache --table "0 524288 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"

2. reduce the cache origin to 2048 oblocks, in lvreduce's approach

dmsetup reload corig --table "0 262144 linear /dev/sdc 262144"
dmsetup reload cache --table "0 262144 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"
dmsetup suspend cache
dmsetup suspend corig
dmsetup suspend cdata
dmsetup suspend cmeta
dmsetup resume corig
dmsetup resume cdata
dmsetup resume cmeta
dmsetup resume cache

3. shutdown the cache, and check the number of discard blocks in
   superblock. The value is expected to be 2048, but actually is 4096.

dmsetup remove cache corig cdata cmeta
dd if=/dev/sdc bs=1c count=8 skip=224 2>/dev/null | hexdump -e '1/8 "%u\n"'

Fix by correcting the origin_blocks initialization in cache_create and
removing the unused origin_sectors from struct cache_args accordingly.

Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Fixes: c6b4fcbad044 ("dm: add cache target")
---
 drivers/md/dm-cache-target.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index aaeeabfab09b..90772b42c234 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2003,7 +2003,6 @@ struct cache_args {
 	sector_t cache_sectors;
 
 	struct dm_dev *origin_dev;
-	sector_t origin_sectors;
 
 	uint32_t block_size;
 
@@ -2084,6 +2083,7 @@ static int parse_cache_dev(struct cache_args *ca, struct dm_arg_set *as,
 static int parse_origin_dev(struct cache_args *ca, struct dm_arg_set *as,
 			    char **error)
 {
+	sector_t origin_sectors;
 	int r;
 
 	if (!at_least_one_arg(as, error))
@@ -2096,8 +2096,8 @@ static int parse_origin_dev(struct cache_args *ca, struct dm_arg_set *as,
 		return r;
 	}
 
-	ca->origin_sectors = get_dev_size(ca->origin_dev);
-	if (ca->ti->len > ca->origin_sectors) {
+	origin_sectors = get_dev_size(ca->origin_dev);
+	if (ca->ti->len > origin_sectors) {
 		*error = "Device size larger than cached device";
 		return -EINVAL;
 	}
@@ -2407,7 +2407,7 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 
 	ca->metadata_dev = ca->origin_dev = ca->cache_dev = NULL;
 
-	origin_blocks = cache->origin_sectors = ca->origin_sectors;
+	origin_blocks = cache->origin_sectors = ti->len;
 	origin_blocks = block_div(origin_blocks, ca->block_size);
 	cache->origin_blocks = to_oblock(origin_blocks);
 
-- 
2.47.0

